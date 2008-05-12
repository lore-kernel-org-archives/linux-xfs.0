Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 09:47:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4CGlASo028168
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:47:13 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 892B61142FC1
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:47:57 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id I7xisHlzuajwfvCr for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:47:57 -0700 (PDT)
Date: Mon, 12 May 2008 09:47:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
In-Reply-To: <200805121726.15576.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805121726.15576.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: xfs@oss.sgi.com, Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>



On Mon, 12 May 2008, Alistair John Strachan wrote:
>
> I've been getting this since -rc1. It's still present in -rc2, so I thought 
> I'd bug some people. Everything seems to be working fine.

Hmm. The problem is that blk_remove_plug() does a non-atomic 

	queue_flag_clear(QUEUE_FLAG_PLUGGED, q);

without holding the queue lock.

Now, sometimes that's ok, because of higher-level locking on the same 
queue, so there is no possibility of any races.

And yes, this comes through the raid5 layer, and yes, the raid layer holds 
the 'device_lock' on the raid5_conf_t, so it's all safe from other 
accesses by that raid5 configuration, but I wonder if at least in theory 
somebody could access that same device directly.

So I do suspect that this whole situation with md needs to be resolved 
some way. Either the queue is already safe (because of md layer locking), 
and in that case maybe the queue lock should be changed to point to that 
md layer lock (or that sanity test simply needs to be removed). Or the 
queue is unsafe (because non-md users can find it too), and we need to fix 
the locking.

Alternatively, we may just need to totally revert the thing that made the 
bit operations non-atomic and depend on the locking. This was introduced 
by Nick in commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e ("block: make 
queue flags non-atomic"), and maybe it simply isn't viable.

Anyway, this is not an XFS bug, and no, I do not think you can ever 
actually find any problems in real life that comes from this. But we do 
need to resolve it one way or another.

(I'm leaving the rest of your report quoted, since I added Nick to the 
list of Cc's).

		Linus

---
> The taint is from loading a custom (fixed) DSDT which I've been doing for 
> ages, and which shouldn't affect this trace.
> 
> XFS: correcting sb_features alignment problem
> XFS mounting filesystem md1
> ------------[ cut here ]------------
> WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x60/0x88()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G       A  2.6.26-rc2-damocles #2
> 
> Call Trace:
>  [<ffffffff802305be>] warn_on_slowpath+0x58/0x82
>  [<ffffffff80250038>] ? find_symbol+0x21e/0x236
>  [<ffffffff8025d617>] ? __rmqueue+0x1f/0x1c1
>  [<ffffffff8032c02f>] blk_remove_plug+0x60/0x88
>  [<ffffffff803eb3ea>] raid5_unplug_device+0x31/0xe6
>  [<ffffffff803eb6ba>] get_active_stripe+0x21b/0x4c0
>  [<ffffffff802265b3>] ? __wake_up+0x43/0x50
>  [<ffffffff80226a66>] ? default_wake_function+0x0/0xf
>  [<ffffffff803f14e7>] make_request+0x4d7/0x675
>  [<ffffffff8025bc02>] ? mempool_alloc_slab+0x11/0x13
>  [<ffffffff802429b2>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff8025bc02>] ? mempool_alloc_slab+0x11/0x13
>  [<ffffffff8032b793>] generic_make_request+0x1ec/0x227
>  [<ffffffff8025eb5b>] ? __get_free_pages+0x15/0x54
>  [<ffffffff8032cd19>] submit_bio+0x112/0x11b
>  [<ffffffff8031bb6f>] _xfs_buf_ioapply+0x1eb/0x216
>  [<ffffffff8031bbd8>] xfs_buf_iorequest+0x3e/0x65
>  [<ffffffff8031f33f>] xfs_bdstrat_cb+0x19/0x3b
>  [<ffffffff803181bd>] xfs_bwrite+0x5f/0xc0
>  [<ffffffff8030818c>] xlog_bwrite+0x81/0xac
>  [<ffffffff80308f29>] xlog_write_log_records+0x1eb/0x228
>  [<ffffffff803090a0>] xlog_clear_stale_blocks+0x13a/0x147
>  [<ffffffff80309a77>] xlog_find_tail+0x33f/0x3a5
>  [<ffffffff8030b221>] xlog_recover+0x19/0x88
>  [<ffffffff8030533c>] xfs_log_mount+0xb9/0x10d
>  [<ffffffff8030d563>] xfs_mountfs+0x252/0x5a2
>  [<ffffffff8031886f>] ? kmem_zalloc+0x11/0x2c
>  [<ffffffff8030df35>] ? xfs_mru_cache_create+0x119/0x166
>  [<ffffffff80313693>] xfs_mount+0x2a1/0x352
>  [<ffffffff80321ca6>] xfs_fs_fill_super+0xc3/0x1f9
>  [<ffffffff8027fc1f>] get_sb_bdev+0xfe/0x14d
>  [<ffffffff80321be3>] ? xfs_fs_fill_super+0x0/0x1f9
>  [<ffffffff8032035a>] xfs_fs_get_sb+0x13/0x15
>  [<ffffffff8027f9e2>] vfs_kern_mount+0x52/0x99
>  [<ffffffff8027fa86>] do_kern_mount+0x47/0xe2
>  [<ffffffff80294d44>] do_new_mount+0x5f/0x92
>  [<ffffffff80294f26>] do_mount+0x1af/0x1de
>  [<ffffffff8025eb44>] ? __alloc_pages+0xb/0xd
>  [<ffffffff80294fde>] sys_mount+0x89/0xd5
>  [<ffffffff805cdcdd>] mount_block_root+0xda/0x263
>  [<ffffffff805cdebc>] mount_root+0x56/0x5a
>  [<ffffffff805cdfdd>] prepare_namespace+0x11d/0x14a
>  [<ffffffff805cd845>] kernel_init+0x251/0x267
>  [<ffffffff8020c128>] child_rip+0xa/0x12
>  [<ffffffff805cd5f4>] ? kernel_init+0x0/0x267
>  [<ffffffff8020c11e>] ? child_rip+0x0/0x12
> 
> ---[ end trace 693a3c7fd0010c41 ]---
> Ending clean XFS mount for filesystem: md1
> 
> -- 
> Cheers,
> Alistair.
> 
> 137/1 Warrender Park Road, Edinburgh, UK.
> 
