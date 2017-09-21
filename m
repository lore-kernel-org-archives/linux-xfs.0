Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:44782 "EHLO
        lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdIUIrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 04:47:24 -0400
Date: Thu, 21 Sep 2017 17:47:14 +0900
From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: shared/298 lockdep splat?
Message-ID: <20170921084714.GI5994@X58A-UD3R>
References: <20170920211042.GH7112@magnolia>
 <20170920222256.GR18948@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920222256.GR18948@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, kernel-team@lge.com

On Thu, Sep 21, 2017 at 08:22:56AM +1000, Dave Chinner wrote:
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 4.14.0-rc1-fixes #1 Tainted: G        W      
> > ------------------------------------------------------
> > loop0/31693 is trying to acquire lock:
> >  (&(&ip->i_mmaplock)->mr_lock){++++}, at: [<ffffffffa00f1b0c>] xfs_ilock+0x23c/0x330 [xfs]
> > 
> > but now in release context of a crosslock acquired at the following:
> >  ((complete)&ret.event){+.+.}, at: [<ffffffff81326c1f>] submit_bio_wait+0x7f/0xb0
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #2 ((complete)&ret.event){+.+.}:
> >        lock_acquire+0xab/0x200
> >        wait_for_completion_io+0x4e/0x1a0
> >        submit_bio_wait+0x7f/0xb0
> >        blkdev_issue_zeroout+0x71/0xa0
> >        xfs_bmapi_convert_unwritten+0x11f/0x1d0 [xfs]
> >        xfs_bmapi_write+0x374/0x11f0 [xfs]
> >        xfs_iomap_write_direct+0x2ac/0x430 [xfs]
> >        xfs_file_iomap_begin+0x20d/0xd50 [xfs]
> >        iomap_apply+0x43/0xe0
> >        dax_iomap_rw+0x89/0xf0
> >        xfs_file_dax_write+0xcc/0x220 [xfs]
> >        xfs_file_write_iter+0xf0/0x130 [xfs]
> >        __vfs_write+0xd9/0x150
> >        vfs_write+0xc8/0x1c0
> >        SyS_write+0x45/0xa0
> >        entry_SYSCALL_64_fastpath+0x1f/0xbe
> 
> This is on the lower filesystem - it's a write() syscall on a DAX
> enable filesystem. Locking in this case is:
> 
> Context			function		lock
> Lower filesystem	xfs_file_dax_write	XFS_IOLOCK_EXCL
> Lower filesystem	xfs_file_iomap_begin	XFS_ILOCK_EXCL
> Lower filesystem/
>    lower blkdev		submit_bio_wait		wait for dax block
> 						device IO completion
> 
> Which gives: IOLOCK -> &xfs_nondir_ilock_class -> IO completion
> 
> In the lower filesystem.
> 
> > -> #1 (&xfs_nondir_ilock_class){++++}:
> >        lock_acquire+0xab/0x200
> >        down_write_nested+0x4a/0xb0
> >        xfs_ilock+0x263/0x330 [xfs]
> >        xfs_setattr_size+0x152/0x370 [xfs]
> >        xfs_vn_setattr+0x6b/0x90 [xfs]
> >        notify_change+0x27d/0x3f0
> >        do_truncate+0x5b/0x90
> >        path_openat+0x237/0xa90
> >        do_filp_open+0x8a/0xf0
> >        do_sys_open+0x11c/0x1f0
> >        entry_SYSCALL_64_fastpath+0x1f/0xbe
> 
> Context			function		lock
> Lower filesystem	xfs_vn_setattr		XFS_IOLOCK_EXCL
> Lower filesystem	xfs_vn_setattr		XFS_MMAPLOCK_EXCL
> Lower filesystem	xfs_setattr_size	XFS_ILOCK_EXCL
> 
> Which gives: IOLOCK -> MMAPLOCK -> &xfs_nondir_ilock_class
> 
> i.e.: IOLOCK -> MMAPLOCK -> &xfs_nondir_ilock_class -> IO completion
> 
> In the lower filesystem.
> 
> > 
> > -> #0 (&(&ip->i_mmaplock)->mr_lock){++++}:
> >        up_write+0x1c/0x40
> >        xfs_iunlock+0x1d0/0x310 [xfs]
> >        xfs_file_fallocate+0x8a/0x310 [xfs]
> >        loop_queue_work+0xb7/0x8d0
> >        kthread_worker_fn+0xb9/0x1f0
> 
> Context			function		lock
> Lower filesystem	xfs_file_fallocate	XFS_IOLOCK_EXCL
> Lower filesystem	xfs_file_fallocate	XFS_MMAPLOCK_EXCL
> [Lower filesystem	whatever falloc calls	XFS_ILOCK_EXCL]
> Upper filesystem/
>    Upper blkd		loop_queue_work		blk_mq_complete_request
> 
> This is clearer when the reported stack is looked at:
> 
> > lock_commit_crosslock+0x3e9/0x5c0
> > complete+0x24/0x60
> > blk_update_request+0xc2/0x3e0
> > blk_mq_end_request+0x18/0x80
> > __blk_mq_complete_request+0x9f/0x170
> > loop_queue_work+0x51/0x8d0
> > kthread_worker_fn+0xb9/0x1f0
> > kthread+0x148/0x180
> > ret_from_fork+0x2a/0x40
> 
> So this is reporting as:
> 
> > Chain exists of:
> >   &(&ip->i_mmaplock)->mr_lock --> &xfs_nondir_ilock_class --> (complete)&ret.event
> >
> >  Possible unsafe locking scenario by crosslock:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&xfs_nondir_ilock_class);
> >   lock((complete)&ret.event);
> >                                lock(&(&ip->i_mmaplock)->mr_lock);
> >                                unlock((complete)&ret.event);
> >
> >                *** DEADLOCK ***
> 
> Which effectively means:
> 
> 	IO completion -> XFS_MMAPLOCK_EXCL .....
> 
> The thing is, this IO completion has nothing to do with the lower
> filesystem - it's the IO completion for the filesystem on the loop
> device (the upper filesystem) and is not in any way related to the
> IO completion from the dax device the lower filesystem is waiting
> on.
> 
> IOWs, this is a false positive.
> 
> Peter, this is the sort of false positive I mentioned were likely to
> occur without some serious work to annotate the IO stack to prevent
> them.  We can nest multiple layers of IO completions and locking in
> the IO stack via things like loop and RAID devices.  They can be
> nested to arbitrary depths, too (e.g. loop on fs on loop on fs on
> dm-raid on n * (loop on fs) on bdev) so this new completion lockdep
> checking is going to be a source of false positives until there is
> an effective (and simple!) way of providing context based completion
> annotations to avoid them...

Hello,

It looks caused by that &ret.event in submit_bio_wait() is initialized
with the same class for all layers. I mean that completion variables in
different layers should be initialized with different classes, as you do
for typical locks in xfs.

I am not sure if I understand how xfs works correctly. Right? If yes,
how can we distinguish between independent 'bio's in submit_bio_wait()?
You or I can make it work with the answer. No?

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
