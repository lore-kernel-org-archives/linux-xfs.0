Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 11:56:26 -0700 (PDT)
Received: from mail.itsolut.com (mail.itsolut.com [64.182.153.89])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7VIuCDW013517
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 11:56:17 -0700
Received: from [192.168.0.197] (host-69-95-111-118.cwon.choiceone.net [69.95.111.118])
	by mail.itsolut.com (Postfix) with ESMTP id 3635C59240
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 11:57:22 -0500 (EST)
Message-ID: <44F714F2.7050502@gmail.com>
Date: Thu, 31 Aug 2006 12:57:22 -0400
From: Chris Hane <chrishane@gmail.com>
MIME-Version: 1.0
Subject: XFS and 3.2TB Partition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I am trying to create a 3.2TB partition on my Raid 5.  Is there a 
document that could help?

I have a 3ware 9500 controller and 8 *500GB sata drives configured into 
a single RAID 5 array.

I am running linux 2.6.16 with the 3ware drivers compiled into the kernel.

I've tried a couple of different means to create the partition and 
format the file system with xfs without success (or confidence that I 
haven't done something wrong).

1. FDISK

I've tried fdisk on the array to create the partition; but it forces me 
enter the number of cylinders before letting me create the partition.  I 
enter the largest number of cylinders since I'm not sure how to 
calculate the correct cylinder number across an 8 disk RAID 5 array.

I then create the partition starting at 0 (or whatever the default was) 
and ending at 3500GB.

Once the partition is created this way, I can mkfs.xfs; but I'm a little 
hesitant to use this since I input and arbitrary cylinder number.

Thoughts on what to use for the correct cylinder count with fdisk?

2. PARTED

I've tried to use parted without any success.  Here is what I've tried 
and the errors I get.

 > parted
parted> mklabel gpt
parted> mkpart primary 0 3500GB
parted> quit

ok  - the partition now exists.  If I use ext2 everything works ok.

however, when I run

 > mkfs.xfs /dev/sda1

the file system is formated but is truncated to to 2TB.


Any advice/pointers on how to partition and format a 3.2TB raid 5 array 
would be much appreciated.

Thanks,
Chris....
