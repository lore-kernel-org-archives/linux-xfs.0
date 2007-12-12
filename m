Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 14:04:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBCM0WwF030701
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 14:00:36 -0800
Date: Thu, 13 Dec 2007 09:00:32 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_btree_check_sblock
Message-ID: <20071212220032.GJ4612@sgi.com>
References: <475ED66F.40800@dgreaves.com> <20071211222546.GD4612@sgi.com> <475F2008.5030702@dgreaves.com> <20071212111202.GI4612@sgi.com> <475FC878.4000709@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475FC878.4000709@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Dec 12, 2007 at 11:39:36AM +0000, David Greaves wrote:
> David Chinner wrote:
> > On Tue, Dec 11, 2007 at 11:40:56PM +0000, David Greaves wrote:
> >> So is there anything else I should do?
> > 
> > Check the filesystem before repairing it.
> yeah, OK :)
> 
> Well, it happened next boot. So:
> 
> haze:~# umount /scratch
> haze:~# xfs_check /dev/video_vg/video_lv
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> haze:~# mount /scratch
> haze:~# umount /scratch
> haze:~# xfs_check /dev/video_vg/video_lv
> bad format 2 for inode 1435146910 type 0
> ir_freecount/free mismatch, inode chunk 42/25860704, freecount 64 nfree 63
> bad format 2 for inode 1435150526 type 0
> ir_freecount/free mismatch, inode chunk 42/25864320, freecount 64 nfree 63
> bad format 2 for inode 1435173822 type 0
> ir_freecount/free mismatch, inode chunk 42/25887616, freecount 64 nfree 63
> bad format 2 for inode 1984739518 type 0
> ir_freecount/free mismatch, inode chunk 59/5027968, freecount 27 nfree 26
> allocated inode 1435146910 has 0 link count
> allocated inode 1435173822 has 0 link count
> allocated inode 1435150526 has 0 link count
> allocated inode 1984739518 has 0 link count

This is after the shutdown, right?

Hmmmm - that looks like inodes that have not been unlinked correctly. This is
after the shutdown, right? Also, "bad format 2" indicates that the di_mode
field is invalid or the data fork format of the inode is invalid. Can
you print out these inodes with:

# xfs_db -r -c "inode <ino #>" -c p /dev/video_vg/video_lv

And post that so we can see what state they are apparently in?

Also, no freespace btree corruption has been reported, so if a btree block
is being corrupted in memory as indicated by the shutdown there's either
a logic error in the btree code or something is trashing your memory.

Have you run memtest86 on this box to see if the memory is ok?

> I've not yet run a repair...

Can you hol doff for a while longer?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
