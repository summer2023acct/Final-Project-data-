
#******************************************************************
#Downloading data
#******************************************************************

if(!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet 
unzip(zipfile="./data/Dataset.zip",exdir="./data")


#Reading  tables:

xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

feature <- read.table('./data/UCI HAR Dataset/features.txt')


activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assigning column names:

colnames(xtrain) <- features[,2]
colnames(ytrain) <-"activityId"
colnames(subjecttrain) <- "subjectId"

colnames(xtest) <- features[,2] 
colnames(ytest) <- "activityId"
colnames(subjecttest) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#1Merging data

merge_train <- cbind(ytrain, subjecttrain, xtrain)
merge_test <- cbind(ytest, subjecttest, xtest)
setAllInOne <- rbind(merge_train, merge_test)

#dim(setAllInOne)
#[1] 10299   563


# Reading column names:

colNames <- colnames(setAllInOne)

#Create vector:

mean <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#2.3 Making nessesary subset from setAllInOne:

setForMeanAndStd <- setAllInOne[ , mean == TRUE]


setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)


#Making a second data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#5.2 Writing second tidy data set in txt file

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
