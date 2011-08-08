Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78NxKaG062053 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 18:59:21 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 476C2151E277
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 17:00:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BxQm1gfupVmyCLki for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2011 17:00:38 -0700 (PDT)
Date: Tue, 9 Aug 2011 09:58:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "Corrupt dinode 6242615, (btree extents).  This is a bug."
Message-ID: <20110808235859.GN3162@dastard>
References: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hanne Munkholm <hanne@binf.ku.dk>
Cc: xfs@oss.sgi.com

On Mon, Aug 08, 2011 at 12:05:09PM +0200, Hanne Munkholm wrote:
> Hi list.
> 
> I have an xfs file system which got damaged due to not being
> properly unmounted before the iSCSI connection terminated (I
> think. Corrupted it is).
> 
> I cannot mount it. mount: wrong fs type, bad option, bad superblock
> on /dev/sdd,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so

That is the default error message from mount when the kernel throws
and error. The error message in dmesg will tell you exactly what the
error was - can you post that?

> xfs_check suggests running xfs_repair -L. ERROR: The filesystem has
> valuable metadata changes in a log
> which needs to be replayed.  Mount the filesystem to replay the log, and
> unmount it before re-running xfs_check.  If you are unable to mount the
> filesystem, then use the xfs_repair -L option to destroy the log and attempt a
> repair.  Note that destroying the log may cause corruption -- please
> attempt a mount of the filesystem before doing this.
> 
> I haven't done that yet.

You won't be able to because mounting is failing. Hence you only
option for recovery is to use xfs_repair -L to zero the log.

> Instead I ran
> xfs_repair -n.
> I got a lot of output that looks promising for a repair IMO, at
> least it acknowleges an xfs system beoing there:
> 
> xfs_repair -n /dev/sdd
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>          - scan filesystem freespace and inode maps...
>          - found root inode chunk
> Phase 3 - for each AG...
>          - scan (but don't clear) agi unlinked lists...
>          - process known inodes and perform inode discovery...
>          - agno = 0
> bad nblocks 952 for inode 6242615, would reset to 972
> bad nextents 182 for inode 6242615, would reset to 185
> imap claims a free inode 13352640 is in use, would correct imap and clear inode
> imap claims a free inode 13352641 is in use, would correct imap and clear inode
> <snip>
>         - agno = 1
>          - agno = 2
>          - agno = 3
>          - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>          - setting up duplicate extent list...
>          - check for inodes claiming duplicate blocks...
>          - agno = 0
>          - agno = 3
>          - agno = 2
>          - agno = 1
> bad nblocks 952 for inode 6242615, would reset to 972
> bad nextents 182 for inode 6242615, would reset to 185
> entry "sample_000001299840_0_0.000000.pdb" at block 764 offset
> 2512 in directory inode 6242615 references free inode 13352640
>  	would clear inode number in entry at offset 2512...
> entry "sample_000001299860_0_0.000000.pdb" at block 764 offset
> 2560 in directory inode 6242615 references free inode 13352641
> <snip>
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>          - traversing filesystem ...
> corrupt dinode 6242615, (btree extents).  This is a bug.

That's one of the inodes that has already been found to be bad, and
woul dhave had parts of it fixed before getting to phase 6. Hence
this problem may have already been fixed by this stage.

> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> corrupt dinode 6242615, (btree extents).  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> corrupt dinode 6242615, (btree extents).  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> Segmentation fault

And the chance is that this won't happen.

> I have placed a xfs_metadump here:
> http://people.binf.ku.dk/hanne/tmp/metadata.gz

Downloading it now. it's about 550MB, so will take a little while...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
