Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6SDEhlJ251712 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 08:14:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE85C1AD342B
	for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 06:17:47 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	gSEUOhXtnG0arqex for <xfs@oss.sgi.com>;
	Wed, 28 Jul 2010 06:17:47 -0700 (PDT)
Date: Wed, 28 Jul 2010 23:17:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang in xlog_grant_log_space
Message-ID: <20100728131744.GS7362@dastard>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd> <20100727080632.GA4958@amd>
	<20100727113626.GA2884@amd> <20100727133038.GP7362@dastard>
	<20100727145808.GQ7362@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727145808.GQ7362@dastard>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Wed, Jul 28, 2010 at 12:58:09AM +1000, Dave Chinner wrote:
> On Tue, Jul 27, 2010 at 11:30:38PM +1000, Dave Chinner wrote:
> > On Tue, Jul 27, 2010 at 09:36:26PM +1000, Nick Piggin wrote:
> > > On Tue, Jul 27, 2010 at 06:06:32PM +1000, Nick Piggin wrote:
> > > On this same system, same setup (vanilla kernel with sha given below),
> > > I have now twice reproduced a complete hang in XFS. I can give more
> > > information, test patches or options etc if required.
> > > 
> > > setup.sh looks like this:
> > > #!/bin/bash
> > > modprobe rd rd_size=$[2*1024*1024]
> > > dd if=/dev/zero of=/dev/ram0 bs=4K
> > > mkfs.xfs -f -l size=64m -d agcount=16 /dev/ram0
> > > mount -o delaylog,logbsize=262144,nobarrier /dev/ram0 mnt
> > > 
> > > The 'dd' is required to ensure rd driver does not allocate pages
> > > during IO (which can lead to out of memory deadlocks). Running just
> > > involves changing into mnt directory and
> > > 
> > > while true
> > > do
> > >   sync
> > >   echo 3 > /proc/sys/vm/drop_caches
> > >   ../dbench -c ../loadfiles/client.txt -t20 8
> > >   rm -rf clients
> > > done
> > > 
> > > And wait for it to hang (happend in < 5 minutes here)
> > ....
> > > Call Trace:
> > >  [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
> > 
> > It's waiting on log space to be freed up. Either there's an
> > accounting problem (possible), or you've got an xfslogd/xfsaild
> > spinning and not making progress competing log IOs or pushing the
> > tail of the log. I'll see if I can reproduce it.
> 
> Ok, I've just reproduced it. From some tracing:
> 
> touch-3340  [004] 1844935.582716: xfs_log_reserve: dev 1:0 type CREATE t_ocnt 2 t_cnt 2 t_curr_res 167148 t_unit_res 167148 t_flags XLOG_TIC_INITED|XLOG_TIC_PERM_RESERV reserve_headq 0xffff88010f489c78 write_headq 0x(null) grant_reserve_cycle 314 grant_reserve_bytes 24250680 grant_write_cycle 314 grant_write_bytes 24250680 curr_cycle 314 curr_block 44137 tail_cycle 313 tail_block 48532
> 
> The key part here is this:
> 
> curr_cycle 314 curr_block 44137 tail_cycle 313 tail_block 48532
> 
> This says the tail of the log is roughly 62MB behind the head. i.e
> the log is full and we are waiting for tail pushing to write the
> item holding the tail in place to disk so it can them be moved
> forward. That's better than an accounting problem, at least.
> 
> So what is holding the tail in place? The first item on the AIL
> appears to be:
> 
> xfsaild/ram0-2997  [000] 1844800.800764: xfs_buf_cond_lock: dev 1:0 bno 0x280120 len 0x2000 hold 3 pincount 0 lock 0 flags ASYNC|DONE|STALE|PAGE_CACHE caller xfs_buf_item_trylock
> 
> A stale buffer. Given that the next objects show this trace:
> 
> xfsaild/ram0-2997  [000] 1844800.800767: xfs_ilock_nowait: dev 1:0 ino 0x500241 flags ILOCK_SHARED caller xfs_inode_item_trylock
> xfsaild/ram0-2997  [000] 1844800.800768: xfs_buf_rele: dev 1:0 bno 0x280120 len 0x2000 hold 4 pincount 0 lock 0 flags ASYNC|DONE|STALE|PAGE_CACHE caller _xfs_buf_find
> xfsaild/ram0-2997  [000] 1844800.800769: xfs_iunlock: dev 1:0 ino 0x500241 flags ILOCK_SHARED caller xfs_inode_item_pushbuf
> 
> we see the next item on the AIL is an inode but the trace is
> followed by a release on the original buffer, than tells me the
> inode is flush locked and it returned XFS_ITEM_PUSHBUF to push the
> inode buffer out. That results in xfs_inode_item_pushbuf() being
> called, and that tries to lock the inode buffer to flush it.
> xfs_buf_rele is called if the trylock on the buffer fails.
> 
> IOWs, this looks to be another problem with inode cluster freeing.
> 
> Ok, so we can't flush the buffer because it is locked. Why is it
> locked? Well, that is unclear as yet. None of the blocked processes
> should be holding an inode buffer locked, and a stale buffer should
> be unlocked during transaction commit and not live longer than
> the log IO that writes the transaction to disk. That is, it should
> not get locked again before everything is freed up.
> 
> That's as much as I can get from post-mortem analysis - I need to
> capture a trace that spans the lockup to catch what happens
> to the buffer that we are hung on. That will have to wait until the
> morning....

Ok, so I got a trace of all the inode and buffer locking and log
item operations, and the reason the hang has occurred can bee seen
here:

dbench-3084  [007] 1877156.395784: xfs_buf_item_unlock_stale: dev 1:0 bno 0x80040 len 0x2000 hold 2 pincount 0 lock 0 flags |ASYNC|DONE|STALE|PAGE_CACHE recur 1 refcount 1 bliflags |STALE|INODE_ALLOC|STALE_INODE lidesc 0x(null) liflags IN_AIL

The key points in this trace is that when we are unlocking a stale
buffer during transaction commit - we don't actually unlock it. WHat
we do it:

        /*
         * If the buf item is marked stale, then don't do anything.  We'll
         * unlock the buffer and free the buf item when the buffer is unpinned
         * for the last time.
         */
        if (bip->bli_flags & XFS_BLI_STALE) {
                trace_xfs_buf_item_unlock_stale(bip);
                ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
                if (!aborted) {
                        atomic_dec(&bip->bli_refcount);
                        return;
                }
        }

But from the above trace it can be seen that the buffer pincount is zero.
Hence it will never get and unpin callback, and hence never get unlocked.
As a result, this process here is the one that is stuck on the buffer:

dbench        D 0000000000000007     0  3084      1 0x00000004
 ffff880104e07608 0000000000000086 ffff880104e075b8 0000000000014000
 ffff880104e07fd8 0000000000014000 ffff880104e07fd8 ffff880104c1d770
 0000000000014000 0000000000014000 ffff880104e07fd8 0000000000014000
Call Trace:
 [<ffffffff817e59cd>] schedule_timeout+0x1ed/0x2c0
 [<ffffffff810de9de>] ? ring_buffer_lock_reserve+0x9e/0x160
 [<ffffffff817e690e>] __down+0x7e/0xc0
 [<ffffffff812f41d5>] ? _xfs_buf_find+0x145/0x290
 [<ffffffff810a05d0>] down+0x40/0x50
 [<ffffffff812f41d5>] ? _xfs_buf_find+0x145/0x290
 [<ffffffff812f314d>] xfs_buf_lock+0x4d/0x110
 [<ffffffff812f41d5>] _xfs_buf_find+0x145/0x290
 [<ffffffff812f4380>] xfs_buf_get+0x60/0x1c0
 [<ffffffff812ea8f0>] xfs_trans_get_buf+0xe0/0x180
 [<ffffffff812ccdab>] xfs_ialloc_inode_init+0xcb/0x1c0
 [<ffffffff812cdaf9>] xfs_ialloc_ag_alloc+0x179/0x4a0
 [<ffffffff812cdeff>] xfs_dialloc+0xdf/0x870
 [<ffffffff8105ec88>] ? pvclock_clocksource_read+0x58/0xd0
 [<ffffffff812d2105>] xfs_ialloc+0x65/0x6b0
 [<ffffffff812eb032>] xfs_dir_ialloc+0x82/0x2d0
 [<ffffffff8128ce83>] ? ftrace_raw_event_xfs_lock_class+0xd3/0xe0
 [<ffffffff812ecad7>] ? xfs_create+0x1a7/0x690
 [<ffffffff812ecd37>] xfs_create+0x407/0x690
 [<ffffffff812f9f97>] xfs_vn_mknod+0xa7/0x1c0
 [<ffffffff812fa0e0>] xfs_vn_create+0x10/0x20
 [<ffffffff8114ca6c>] vfs_create+0xac/0xd0
 [<ffffffff8114d6ec>] do_last+0x51c/0x620
 [<ffffffff8114f6d8>] do_filp_open+0x228/0x640
 [<ffffffff812c1f18>] ? xfs_dir2_block_getdents+0x218/0x220
 [<ffffffff8115a62a>] ? alloc_fd+0x10a/0x150
 [<ffffffff8113f919>] do_sys_open+0x69/0x140
 [<ffffffff8113fa30>] sys_open+0x20/0x30
 [<ffffffff81035032>] system_call_fastpath+0x16/0x1b

It is trying to allocate a new inode chunk on disk, which happens to
be the one we just removed and staled. Now to find out why the pin
count on the buffer is wrong.

.....

Now it makes no sense - the buf item pin trace is there directly
directly before the above unlock stale trace. The buf item pinning
increments both the buffer pin count and the buf item refcount,
neith of which are reflected in the unlock stale trace. From the
trace analysis I did:


process
83		84		85		86		87
.....
								get
								trans_read
								stale
								format
								pin
								unlock

								committed
								unpin stale
								free

		trans_get
		init
		format
		pin
		item unlock

		get
		trans_read
		unlock

		get
		trans_read
		item unlock

**** pincount goes from 1 to 0 here without any unpin traces ****

		get
		trans_read
		unlock

		get
		trans_read
		item unlock

		(repeat 1x)

		get
		trans_read
		unlock

		get
		trans_read
		stale
		format
		pin

**** no committed/unlock/free trace for this transaction ****
**** hold count goes from 2 to 1 without any rele traces ****
**** is a new buffer allocated here without the staled buffer being committed? ****

		trans_get
		init
		format
		pin
		item unlock

		get
		trans_read
		unlock

		get
		trans_read
		item unlock

		(repeat 9x)

		get
		trans_read
		unlock

		get
		trans_read
		stale
		format
		pin

**** pin count does not increment! ****

		buf lock from xfs_buf_find => hangs

**** buffer that was found is locked, not pinned ****

Something very strange is happening, and to make matters worse I
cannot reproduce it with a debug kernel (ran for 3 hours without
failing). Hence it smells like a race condition somewhere.

I've reproduced it without delayed logging, so it is not directly
related to that functionality.

I've seen this warning:

Filesystem "ram0": inode 0x704680 background reclaim flush failed with 117

Which indicates we failed to mark an inode stale when freeing an
inode cluster, but I think I've fixed that and the problem still
shows up. It's posible the last version didn't fix it, but....

Now I've got the ag iterator rotor patch in place as well and
possibly a different version of the cluster free fix to what I
previously tested and it's now been running for almost half an hour.
I can't say yet whether I've fixed the bug of just changed the
timing enough to avoid it. I'll leave this test running over night
and redo individual patch testing tomorrow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
