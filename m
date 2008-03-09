Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 14:39:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m29LdZVd031167
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 14:39:36 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B1D1B0C534
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2008 14:40:04 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157]) by cuda.sgi.com with ESMTP id SsMuRrTYdBUgFifi for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 14:40:04 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so1368465fga.8
        for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 14:40:03 -0700 (PDT)
Message-ID: <47D45926.5070806@gmail.com>
Date: Sun, 09 Mar 2008 22:39:50 +0100
From: Rekrutacja <rekrutacja119@gmail.com>
MIME-Version: 1.0
Subject: xfs for free hosting on linux ? performance questions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

hello, i'm going to create xfs on RAID 5 array consiting of 5 drives, 
each 500GB, it will be software raid made with mdadm on linux. i run 
free hosting, and the array is only for users files (system and such are 
on ext3).

what options do you recommend while creating and while mounting? i had 
performance problems while testing this setup with bonnie++ and postmark 
(postmark especially).

data will be in many directories, users files are in 
/var/www/users/username and i have more than 100 000 accounts. also a 
policy to make max 3 MB files, so most of my files are around 50 KB i think.

so knowing this all, what would you advice me if i may ask? my current 
idea was like this:

mkfs.xfs -l size=128m,lazy-count=1
mount -o nobarrier,noatime,logbufs=8,logbsize=256k

this will have full backup, so i'm more after performance, not 
stability, so if you can give me some performance tips... (postmark run 
on array made from 4 disks, not 5, durning test, with parameters - 
number of files 10k, transactions 10k, subdirs 20k, was giving very very 
slow reads, around 200KB/s, while reiser4/btrfs were like 2MB/s reads, 
but even ext3 was faster - any idea why? i tested on 2.6.24.3 and 
2.6.25-rc4 )

i keep seeing tests like this: http://www.t2-project.org/zine/1/
also, i have real life example, that 3 disks RAID-0 array with tweaked 
xfs is as fast as just one disk with reiser4 (my free hosting with 
millions of files)

i know reiser4 is not stable (i also experienced this), so i'm asking if 
  you know any additional tips to tweak xfs, or maybe you know why it 
has performance problems in some situations.

thanks in advance
