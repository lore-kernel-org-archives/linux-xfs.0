Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 06:14:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3JDEpfB023951
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 06:14:52 -0700
Date: Thu, 19 Apr 2007 23:14:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Inode usage
Message-ID: <20070419131442.GC32602149@melbourne.sgi.com>
References: <4627283E.7060000@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627283E.7060000@start.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Stein M. Hugubakken" <dulci@start.no>
Cc: xfs@oss.sgi.com

On Thu, Apr 19, 2007 at 10:28:46AM +0200, Stein M. Hugubakken wrote:
> Hi!
> 
> I have a lot of free inodes on my xfs-partitions and was wondering about 
> what impact this has on performance or memory?

None.  The number of free inodes is a made up number. ;)

XFS dynamically allocates and frees inodes, so the number of free
inodes is determined by working out how many inodes
could be allocated in the remaining free space you have.
It's a theoretical maximum....

> Here is output from 'df':
> df -ih
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/hda2               5,1M    129K    5,0M    3% /
> /dev/hda3                31M     54K     31M    1% /home
> 
> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/hda2             5,1G  2,8G  2,4G  55% /
> /dev/hda3              31G   18G   13G  59% /home
> 
> With xfs_growfs -m I can adjust the amount of free inodes, but it seems 
> I can't change it for the root-partition, why is that a problem?

Works for me....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
