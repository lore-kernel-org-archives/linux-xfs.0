Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 17:47:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8M0lUaG001624
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 17:47:31 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: xfs_read_buf error 5.
Date: Thu, 21 Sep 2006 17:45:32 -0700
Message-ID: <43FB1967D03EC7449A77FA91322E364802A9AB91@SVL1XCHCLUPIN01.enterprise.veritas.com>
In-Reply-To: <20060922001619.GW3034@melbourne.sgi.com>
From: "Nikhil Kulkarni" <nikhil_kulkarni@symantec.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hi David,

Hi David,

Thanks for your prompt response, I really appreciate it!!! I made a
major tying mistake in describing the initial size of the partitions. We
are having issues when we assign a size > 2TB and not 2GB. I'm sorry
about the typo.

Here are the 2 /proc/partition files:

This is the one where the partition size is 3.5T

[nikhil@nkulkarni tmp]$ more xfs-log-3.5T
[root@ssimppi7 log]# cat /proc/partitions
major minor  #blocks  name

   8     0 4093902848 sda
   8     1 1436513398 sda1
   8    16  143257600 sdb
   8    17   10482381 sdb1
   8    18   10482412 sdb2
   8    19    4192965 sdb3
   8    20          1 sdb4
   8    21  118093783 sdb5
   8    32  878837760 sdc
   8    33   12811806 sdc1
   8    34   64010992 sdc2
   8    35       8032 sdc3
   8    36          1 sdc4
   8    37   19197643 sdc5
   8    38  100582933 sdc6
   8    39  682224291 sdc7
 253     0  136445952 dm-0
 253     1  545775616 dm-1

This is the one where the partition size is 2TB:

[nikhil@nkulkarni tmp]$ more xfs-log-2T
root@ssimppi7 log]# cat /proc/partitions
major minor  #blocks  name

   8     0 4093902848 sda
   8     1 2047998298 sda1
   8    16  143257600 sdb
   8    17   10482381 sdb1
   8    18   10482412 sdb2
   8    19    4192965 sdb3
   8    20          1 sdb4
   8    21  118093783 sdb5
   8    32  878837760 sdc
   8    33   12811806 sdc1
   8    34   64010992 sdc2
   8    35       8032 sdc3
   8    36          1 sdc4
   8    37   19197643 sdc5
   8    38  100582933 sdc6
   8    39  682224291 sdc7
 253     0  136445952 dm-0
 253     1  545775616 dm-1
[nikhil@nkulkarni tmp]$


I think you are right. The partitions are not set up correctly.

Do you know on a 2.5 kernel on a 32 bit operating system, which tool can
be used to setup partitions for sizes up to 4TB or 8TB?
fdisk on a 32 bit os does not work correctly. I thought parted worked
but apparently it does not either.

Any suggestions how I can utilize the entire 4TB file system using xfs?

Thanks,
Nikhil

-----Original Message-----
From: David Chinner [mailto:dgc@sgi.com] 
Sent: Thursday, September 21, 2006 5:16 PM
To: Nikhil Kulkarni
Cc: xfs@oss.sgi.com
Subject: Re: xfs_read_buf error 5.

On Thu, Sep 21, 2006 at 03:52:18PM -0700, Nikhil Kulkarni wrote:
> Hi,
> 
>  
> 
> We are running the latest stable kernel 2.6.18 on RedHat Enterprise 4
> Update 4.
> 
> When I create an xfs partition and assign it a size > 2GB , I get the
> following errors during bootup:
....
> If the partition size is < 2GB then everything works smoothly. The
> filesystem mounts successfully.

Sounds like a partition problem, not an XFS problem...
What is the size of the partitions in both cases according to
/proc/partitions?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
