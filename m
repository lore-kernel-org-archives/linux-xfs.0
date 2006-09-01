Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 03:41:41 -0700 (PDT)
Received: from jabber.dneg.com (mail.dneg.com [193.203.82.196])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k81AfVDW030184
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 03:41:32 -0700
Message-ID: <44F7F219.40904@dneg.com>
Date: Fri, 01 Sep 2006 09:40:57 +0100
From: Evan Fraser <evan@dneg.com>
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

I had that problem when I was using an adaptec aic79xx adapter, using a 
new LSI-Logic one fixed the problem for me.  Could it be a limit with 
your controller/controller driver?

Chris Hane wrote:
>
> I am trying to create a 3.2TB partition on my Raid 5.  Is there a 
> document that could help?
>
> I have a 3ware 9500 controller and 8 *500GB sata drives configured 
> into a single RAID 5 array.
>
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
>
>
> Any advice/pointers on how to partition and format a 3.2TB raid 5 
> array would be much appreciated.
>
> Thanks,
> Chris....
>
>
>

-- 
evan@dneg.com
Linux Systems Administrator
Double Negative
tel: +44 (0)20 7534 4400 fax: +44 (0)20 7534 4452
77 shaftesbury avenue, w1d 5du, London
