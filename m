Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 14:25:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBBMPhDU003941
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 14:25:45 -0800
Date: Wed, 12 Dec 2007 09:25:46 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_btree_check_sblock
Message-ID: <20071211222546.GD4612@sgi.com>
References: <475ED66F.40800@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475ED66F.40800@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 11, 2007 at 06:26:55PM +0000, David Greaves wrote:
> Hi
> 
> I've been having problems with this filesystem for a while now.
> 
> I upgraded to 2.6.23 to see if it's improved (no).
> 
> Once every 2 or 3 cold boots I get this in dmesg as the user logs in and
> accesses the /scratch filesystem. If the error doesn't occur as the user logs in
> then it won't happen at all.
> 
> Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file
> fs/xfs/xfs_btree.c.  Caller 0xc01b7bc1
>  [<c010511a>] show_trace_log_lvl+0x1a/0x30
>  [<c0105d72>] show_trace+0x12/0x20
>  [<c0105d95>] dump_stack+0x15/0x20
>  [<c01dd34f>] xfs_error_report+0x4f/0x60
>  [<c01cfcb6>] xfs_btree_check_sblock+0x56/0xd0
>  [<c01b7bc1>] xfs_alloc_lookup+0x181/0x390
>  [<c01b7e23>] xfs_alloc_lookup_eq+0x13/0x20
>  [<c01b5594>] xfs_free_ag_extent+0x2f4/0x690
>  [<c01b7164>] xfs_free_extent+0xb4/0xd0
>  [<c01c1979>] xfs_bmap_finish+0x119/0x170
>  [<c0209aa7>] xfs_remove+0x247/0x4f0
>  [<c0211cc2>] xfs_vn_unlink+0x22/0x50
>  [<c0172f28>] vfs_unlink+0x68/0xa0
>  [<c01751e9>] do_unlinkat+0xb9/0x140
>  [<c0175280>] sys_unlink+0x10/0x20
>  [<c010420a>] syscall_call+0x7/0xb
>  =======================
> xfs_force_shutdown(dm-0,0x8) called from line 4274 of file fs/xfs/xfs_bmap.c.
> Return address = 0xc0214dae
> Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down
> filesystem: dm-0
> Please umount the filesystem, and rectify the problem(s)

So there's a corrupted freespace btree block.

> I ssh in as root, umount, mount, umount and run xfs_repair.
> 
> This is what I got this time:
> 
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> ir_freecount/free mismatch, inode chunk 59/5027968, freecount 27 nfree 26
>         - found root inode chunk
> 
> All the rest was clean.

repair doesn't check the freespace btrees - it just rebuilds them from
scratch. use xfs_check to tell you what is wrong with the filesystem, then
use xfs_repair to fix it....

> It is possible this fs suffered in the 2.6.17 timeframe
> It is also possible something got broken whilst I was having lots of issues with
>  hibernate (which is still unreliable).

Suspend does not quiesce filesystems safely, so you risk filesystem
corruption every time you suspend and resume no matter what filesystem
you use.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
