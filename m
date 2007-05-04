Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 17:59:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l440xXfB009201
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 17:59:35 -0700
Date: Fri, 4 May 2007 10:59:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504005922.GC32602149@melbourne.sgi.com>
References: <20070503164521.16efe075@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503164521.16efe075@harpe.intellique.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Thu, May 03, 2007 at 04:45:21PM +0200, Emmanuel Florac wrote:
> 
> Hello, 
> Apparently quite a lot of people do encounter the same problem from
> time to time, but I couldn't find any solution. 
> 
> When writing quite a lot to the filesystem (heavy load on the
> fileserver), the filesystem crashes when filled at 2.5~3TB (varies from
> time to time). The filesystems tested where always running on a software
> raid 0, with disabled barriers. I tend to think that disabled write
> barriers are causing the crash but I'll do some more tests to get sure.
> 
> I've met this problem for the first time on 12/23 (yup... merry
> christmas :) when a 13 TB filesystem went belly up :
> 
> Dec 23 01:38:10 storiq1 -- MARK --
> Dec 23 01:58:10 storiq1 -- MARK --
> Dec 23 02:10:29 storiq1 kernel: xfs_iunlink_remove: xfs_itobp()
> returned an error 990 on md0. Returning error.
> Dec 23 02:10:29 storiq1 kernel: xfs_inactive:^Ixfs_ifree() returned an
> error = 990 on md0
> Dec 23 02:10:29 storiq1 kernel: xfs_force_shutdown(md0,0x1) called from
> line 1763 of file fs/xfs/xfs_vnodeops.c. Return address = 0xc027f78b
> Dec 23 02:38:11 storiq1 -- MARK --
> Dec 23 02:58:11 storiq1 -- MARK -- 

So, trying to remove an inode there was a corruption found on disk
and it shut the filesystem down.

Where there any I/o errors reported before the shutdown?

> When mounting, it did that :
> 
> Filesystem "md0": Disabling barriers, not supported by the underlying
> device XFS mounting filesystem md0
> Starting XFS recovery on filesystem: md0 (logdev: internal)
> Filesystem "md0": xfs_inode_recover: Bad inode magic number, dino ptr =
> 0xf7196600, dino bp = 0xf718e980, ino = 119318 Filesystem "md0": XFS

Which was found again during log recovery.

> The system was running vanilla 2.6.17.9, and md0 was made of 3 striped
> RAID-5 on 3 3Ware-9550 cards, each hardware RAID-5 made of 8 750 GB
> drives.
> 
> On a similar hardware with 2 3Ware-9550 16x750GB striped together, but
> running 2.6.17.13, I had a similar fs crash last week. Unfortunately I
> don't have the logs at hand, but we where able to reproduce several
> times the crash at home :

Hmm - 750GB drives are brand new. i wouldn't rule out media issues
at this point...

> Filesystem "md0": XFS internal error xfs_btree_check_sblock at line 336
> of file fs/xfs/xfs_btree.c.  Caller 0xc01fb282 <c0214568>

Memory corruption?

> line 1151 of file fs/xfs/xfs_trans.c.  Return address = 0xc025f7b9
> Filesystem "md0": Corruption of in-memory data detected.  Shutting down
> filesystem: md0 Please umount the filesystem, and rectify the
> problem(s) xfs_force_shutdown(md0,0x1) called from line 338 of file
> fs/xfs/xfs_rw.c.  Return address = 0xc025f7b9
> xfs_force_shutdown(md0,0x1) called from line 338 of file
> fs/xfs/xfs_rw.c.  Return address = 0xc025f7b9
> 
> After xfs_repair, the fs is fine. However, it crashes again when
> writing again a couple of GBs of data. It crashes again under 2.6.17.13,
> 2.6.17.13 SMP, 2.6.18.8, 2.6.16.36... 
> 
> Out of curiosity, I've tried to use reiserfs (just to see how it
> compares regarding this). Reiserfs crashed before even writing 100MB!

That indicates there's something wrong other than the filesystem.
I'd suggest making sure your raid arrays, memory, etc are all
functioning correctly first.

What platform are you running on? Are you running ia32 with 4k stacks?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
