Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 13:43:01 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7VKgmDW003634
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 13:42:54 -0700
Received: from agami.com ([192.168.168.133])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k7VKgBuu004832
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 13:42:11 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k7VKg6lA002944
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 13:42:06 -0700
Message-ID: <44F74996.8000209@agami.com>
Date: Fri, 01 Sep 2006 02:11:58 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: XFS and 3.2TB Partition
References: <44F714F2.7050502@gmail.com>
In-Reply-To: <44F714F2.7050502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Hane <chrishane@gmail.com>
Cc: xfs@oss.sgi.com


Hi Chris,

>
> I am trying to create a 3.2TB partition on my Raid 5.  Is there a 
> document that could help?

You can get generic information on partitions and how to create them at
http://www.faqs.org/docs/Linux-mini/Partition.html

> I have a 3ware 9500 controller and 8 *500GB sata drives configured 
> into a single RAID 5 array.
> I am running linux 2.6.16 with the 3ware drivers compiled into the 
> kernel.
>
> I've tried a couple of different means to create the partition and 
> format the file system with xfs without success (or confidence that I 
> haven't done something wrong).
>
> 1. FDISK
>
> I've tried fdisk on the array to create the partition; but it forces 
> me enter the number of cylinders before letting me create the 
> partition.  I enter the largest number of cylinders since I'm not sure 
> how to calculate the correct cylinder number across an 8 disk RAID 5 
> array.
>
> I then create the partition starting at 0 (or whatever the default 
> was) and ending at 3500GB.
>
> Once the partition is created this way, I can mkfs.xfs; but I'm a 
> little hesitant to use this since I input and arbitrary cylinder number.
>
> Thoughts on what to use for the correct cylinder count with fdisk?
>
It is not actually arbitrary. There are various options to create a 
partition - can specify the size, sectors or cylinders. fdisk -l 
/dev/<device> can hopefully give you details about the size of the disk, 
cylinders etc. Now, it is upto to you as to how many partiotions you 
want to create and use. 

> 2. PARTED
>
> I've tried to use parted without any success.  Here is what I've tried 
> and the errors I get.
>
> > parted
> parted> mklabel gpt
> parted> mkpart primary 0 3500GB
> parted> quit
>
> ok  - the partition now exists.  If I use ext2 everything works ok.
>
> however, when I run
>
> > mkfs.xfs /dev/sda1
>
> the file system is formated but is truncated to to 2TB.

XFS can limit the FS size this way when AG count is just 2. xfs_info 
<mnt_point> will list the details about the number of AG count. XFS can 
support about 1 TB in one AG. By default, it calculates the agcount 
automatically unless you force them. Your command line option does not 
suggest this.

The 2 TB limit might be coming, perhaps, because parted uses 4 byte 
addresses data structures. This way, it can support maximum of 2^32  
sectors of  512 size ~ 41 bits ~ 2TB. It is my guess, though.
-shailendra
