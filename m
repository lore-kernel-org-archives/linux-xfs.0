Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C8457CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 16:31:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D786304048
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 14:31:20 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ofWfBGcDDMKubsOt for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2016 14:31:17 -0800 (PST)
Date: Sat, 6 Feb 2016 09:30:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about continous blocks for inode due to 'no space left
	on device' problem
Message-ID: <20160205223023.GL459@dastard>
References: <CAAgKQi+AOZO_K9Garmz3G6C1X8TuTRxrfF1MP2HPEZ3JkdE41w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAgKQi+AOZO_K9Garmz3G6C1X8TuTRxrfF1MP2HPEZ3JkdE41w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michel Verbraak <info1stsetup@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 05, 2016 at 02:13:00PM +0100, Michel Verbraak wrote:
> All,
> 
> Recently we ran into a problem where our filesystem (300GB in size)
> reported 'no space left on device' (ENOSPC) but when we looked at disk
> space usage and inode usage it was around 52% for disk space and 11% for
> inode. (sorry do not have a save of the output of df command).
....
> meta-data=/dev/sdb               isize=256    agcount=6, agsize=19660800

Inode allocation requires aligned 16k extents.
......
> Some extra info about the system and files on the system:
> - Ubuntu 12.04.5 LTS
> - Kernel: Linux ealxs00170 3.2.0-97-generic #137-Ubuntu SMP Thu Dec 17
> 18:11:47 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> - 32 million files of which about 75% is smaller than 1k. Files are
> separated over different folders to keep the number of files per folder low.

You have lots of small single block files which will cause free
space to tend towards small extents as the filesystem fills up...

> - mount options: defaults,noatime,inode64,nobarrier
> 
> Regards,
> 
> Michel Verbraak.
> 
> Store 03 (root@server):~# xfs_db -c freesp /dev/sdb
>    from      to extents  blocks    pct
>       1       1 3282633 3282633   9.03
>       2       3 3416223 8372325  23.03
>       4       7 6175009 24700036  67.94

Yup, no more aligned 4 block extents in the filesystem.

This is what the experimental sparse inode feature in current
kernels addresses - it allows unaligned block allocation for inodes
and so allows you to abuse the filesystem all the way up to 100%
full with workloads like this.

But without moving to a current 4.4 kernel and reformatting all your
filesystems, there's absolutely nothing you can do about it except
grow the filesystem to be larger every time you drive the filesystem
into this condition.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
