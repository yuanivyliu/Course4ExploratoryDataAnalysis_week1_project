#1. download the dataset.
library(dplyr)
library(tidyr)
library(lubridate)

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/data.zip", mode = "wb")

setwd("~/Desktop/data") #make sure the zip file and working directory in the same folder
unzip("data.zip")

#2. read the datafile
dataset <- read.table("~/Desktop/data/household_power_consumption.txt", sep = ";", header = TRUE)
str(dataset)
summary(dataset) #overview the whole dataset

#2.1 set the Date column to the date class & combine the Date and Time column to date_time
dataset$date_time <- paste(dataset$Date, dataset$Time, sep = " ")
dataset$date_time <- as.POSIXct(dataset$date_time, format = "%d/%m/%Y %H:%M:%S")
dataset$Date <- dmy(dataset$Date)

#2.2 select the data from the dates 2007-02-01 and 2007-02-02
date_select <- with(dataset, dataset[(Date == "2007-02-01") | (Date == "2007-02-02") , ])
table(date_select$Date) #check the selected date

#2.3 change the columns class to numeric

date_select[, 3:9] <- sapply(date_select[, 3:9], as.numeric)
summary(date_select)

#3. Construct the plots
quartz(title = "plot1.png", width = 5, height = 5, bg = "white") #set the PNG file with a width of 
#480 pixels and a height of 480 pixels

attach(date_select)
plot(date_time, Sub_metering_1, type = "l", 
     xlab = "",
     ylab = "Energy sub metering")
lines(date_time, Sub_metering_2, type = "l", col = "red")
lines(date_time, Sub_metering_3, type = "l", col = "blue")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1, 1), col = c("black", "red", "blue"), y.intersp = 0.8, x.intersp = 0.6)

quartz.save(file = "plot3.png", type = "png")
