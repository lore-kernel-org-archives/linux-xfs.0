Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 589397F62
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 19:12:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30F75304039
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 17:12:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FNnv35NlLHFMMjdj for <xfs@oss.sgi.com>;
	Wed, 01 Apr 2015 17:12:37 -0700 (PDT)
Date: Thu, 2 Apr 2015 11:12:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slightly Urgent:  XFS No Space Left On Device
Message-ID: <20150402001235.GI28621@dastard>
References: <551993CF.4060908@binghamton.edu> <20150330194510.GD28621@dastard>
	<551C4CB8.7@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <551C4CB8.7@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: xfs@oss.sgi.com

On Wed, Apr 01, 2015 at 03:53:28PM -0400, Dave Hall wrote:
> Please pardon the 'top-post', but here is the additional information
> requested:
> 
> This is a Dell R720xd dual 8-core Xeon system with 128GB RAM.  The
> RAID controller is Dell PERC H710 Mini with 12 2TB disks in RAID6.
> 
> The OS is Debian 6 with kernel 3.2.0-0.bpo.4-amd64 #1 SMP Debian
> 3.2.65-1+deb7u2~bpo60+1 x86_64.

So defaults to inode32 allocation....

> From /proc/mounts:
> 
>    /dev/sdb1 /data xfs
>    rw,noexec,noatime,attr2,delaylog,allocsize=64k,logbsize=64k,sunit=128,swidth=1280,usrquota,prjquota
>    0 0

... and inode64 is not in the mount options.....

> The output from xfs_info was previously included, but is repeated here:
> 
> # xfs_info /data
> meta-data=/dev/sdb1              isize=256    agcount=19,agsize=268435440 blks

Inode allocation requires contiguous free space of 16k aligned to 8k
boundaries to allocate new inode chunks. Also, 1TB AGs, so with
inode32, inodes can only be allocated in AG 0.

> Here are the more extensive freesp outputs for each of the 19 AGs:
> 
>    # xfs_db -r /dev/sdb1 -c 'freesp -s -a0'
>        from      to extents  blocks    pct
>           1       1     747     747  19.68
>           2       3    1045    2496  65.77
>           4       7     138     552  14.55
>    total free extents 1930
>    total free blocks 3795
>    average free extent size 1.96632

And that says you have no correctly aligned free 16k extents that
can be allocated in AG 0. i.e. no more inodes can be allocated, and
that's where the ENOSPC is coming from.

Unmount, add the inode64 mount option, and you'll be able to
allocate inodes again as they will be allowed to be allocated in
any AG, not just AG 0.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
