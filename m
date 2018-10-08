Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:61889 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725760AbeJHJel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Oct 2018 05:34:41 -0400
Date: Mon, 8 Oct 2018 13:24:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: remove magic handling of unwritten extents in
 xfs_bmapi_allocate
Message-ID: <20181008022455.GD18095@dastard>
References: <20181002174207.25275-1-hch@lst.de>
 <20181002174207.25275-4-hch@lst.de>
 <20181006093433.GA18095@dastard>
 <20181006094331.GA5845@lst.de>
 <20181007101319.GA25721@lst.de>
 <20181007220258.GC18095@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181007220258.GC18095@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 08, 2018 at 09:02:58AM +1100, Dave Chinner wrote:
> On Sun, Oct 07, 2018 at 12:13:19PM +0200, Christoph Hellwig wrote:
> > On Sat, Oct 06, 2018 at 11:43:31AM +0200, Christoph Hellwig wrote:
> > > I suspect the asserts actually are what is incorrect.  But given
> > > how late we are in the cycle I've just dropped the patch and kicked
> > > off xfstests runs (now including rmap, sigh..).
> > 
> > Without this patch test runs including rmap succeed.  Do you want
> > me to resend with the patch dropped (thing should just apply without
> > it as-is).
> 
> I'll drop it and see what happens...

Different problems after dropping that patch and re-instating the
rest of the series. The shutdown/io error stress tests now hang
randomly in unmount reclaiming inodes. e.g. generic/388:

.....
[ 4028.393874] XFS (pmem1): Mounting V5 Filesystem
[ 4028.397627] XFS (pmem1): Starting recovery (logdev: internal)
[ 4028.400436] XFS (pmem1): Ending recovery (logdev: internal)
[ 4028.406885] XFS (pmem1): xfs_do_force_shutdown(0x8) called from line 435 of file fs/xfs/libxfs/xfs_defer.c.  Return address = ffffffff814fc998
[ 4028.406966] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
[ 4028.500258] XFS (pmem1): Unmounting Filesystem
[ 4230.446548] INFO: task umount:16507 blocked for more than 120 seconds.
[ 4230.449820]       Not tainted 4.19.0-rc7-dgc+ #682
[ 4230.452695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4230.456142] umount          D14552 16507  14540 0x00000000
[ 4230.458206] Call Trace:
[ 4230.458980]  ? __schedule+0x2bf/0x8a0
[ 4230.459852]  ? rwsem_down_write_failed+0x235/0x440
[ 4230.460815]  ? rwsem_down_write_failed+0x230/0x440
[ 4230.461777]  schedule+0x45/0x110
[ 4230.462597]  rwsem_down_write_failed+0x235/0x440
[ 4230.463685]  ? xfs_reclaim_inode+0x107/0x430
[ 4230.464549]  ? call_rwsem_down_write_failed+0x13/0x20
[ 4230.465564]  call_rwsem_down_write_failed+0x13/0x20
[ 4230.466599]  down_write+0x37/0x50
[ 4230.467438]  xfs_ilock+0x119/0x200
[ 4230.468133]  xfs_reclaim_inode+0x107/0x430
[ 4230.468965]  xfs_reclaim_inodes_ag+0x1bd/0x330
[ 4230.469870]  xfs_reclaim_inodes+0x2b/0x50
[ 4230.470736]  xfs_unmountfs+0x92/0x180
[ 4230.471682]  xfs_fs_put_super+0x39/0xb0
[ 4230.472466]  generic_shutdown_super+0x64/0x110
[ 4230.473368]  kill_block_super+0x21/0x50
[ 4230.474149]  deactivate_locked_super+0x39/0x70
[ 4230.475100]  cleanup_mnt+0x3b/0x80
[ 4230.476004]  task_work_run+0x82/0xb0
[ 4230.476740]  exit_to_usermode_loop+0xd3/0xe0
[ 4230.477608]  do_syscall_64+0x170/0x180
[ 4230.478421]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

And on a different machine, generic/475:

[ 8001.777349] XFS (dm-0): Unmounting Filesystem
[ 8001.850325] XFS (dm-0): Mounting V5 Filesystem
[ 8002.234755] XFS (dm-0): Starting recovery (logdev: internal)
[ 8002.410851] XFS (dm-0): Ending recovery (logdev: internal)
[ 8002.438481] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0xd60 len 8 error 5
[ 8002.438542] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0xa00728 len 8 error 5
[ 8002.441590] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x1406f80 len 32 error 5
[ 8002.441597] XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[ 8002.442325] Buffer I/O error on dev dm-0, logical block 5242864, async page read
[ 8002.442377] XFS (dm-0): xfs_do_force_shutdown(0x1) called from line 327 of file fs/xfs/xfs_trans_buf.c.  Return address = ffffffff8156e5e4
[ 8002.442422] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x1e00080 len 32 error 5
[ 8002.442427] XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[ 8002.442443] XFS (dm-0): metadata I/O error in "xlog_iodone" at daddr 0x1402790 len 64 error 5
[ 8002.442448] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1271 of file fs/xfs/xfs_log.c.  Return address = ffffffff81558d45
[ 8002.442459] XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[ 8002.442480] XFS (dm-0): Log I/O Error Detected.  Shutting down filesystem
[ 8002.442481] XFS (dm-0): Please umount the filesystem and rectify the problem(s)
[ 8002.525313] XFS (dm-0): Unmounting Filesystem
[ 8217.616288] INFO: task umount:11278 blocked for more than 120 seconds.
[ 8217.621420]       Tainted: G        W         4.19.0-rc7-dgc+ #682
[ 8217.622924] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 8217.625024] umount          D14640 11278   9205 0x00000080
[ 8217.626512] Call Trace:
[ 8217.627192]  ? __schedule+0x2bf/0x8a0
[ 8217.628213]  ? rwsem_down_write_failed+0x235/0x440
[ 8217.629512]  ? rwsem_down_write_failed+0x230/0x440
[ 8217.630804]  schedule+0x45/0x110
[ 8217.631673]  rwsem_down_write_failed+0x235/0x440
[ 8217.632593]  ? xfs_reclaim_inode+0x107/0x430
[ 8217.633429]  ? call_rwsem_down_write_failed+0x13/0x20
[ 8217.634419]  call_rwsem_down_write_failed+0x13/0x20
[ 8217.635361]  down_write+0x37/0x50
[ 8217.636010]  xfs_ilock+0x119/0x200
[ 8217.636702]  xfs_reclaim_inode+0x107/0x430
[ 8217.637510]  xfs_reclaim_inodes_ag+0x1bd/0x330
[ 8217.638391]  ? _raw_spin_lock_irqsave+0x32/0x40
[ 8217.639276]  ? __flush_work+0x194/0x1e0
[ 8217.640027]  ? preempt_count_sub+0x43/0x50
[ 8217.640847]  ? _raw_spin_unlock_irqrestore+0x2c/0x60
[ 8217.641815]  ? del_timer+0x53/0x80
[ 8217.642490]  ? __cancel_work_timer+0x13c/0x1e0
[ 8217.643354]  ? xfs_ail_push_all_sync+0xcc/0xf0
[ 8217.644238]  xfs_reclaim_inodes+0x2b/0x50
[ 8217.645025]  xfs_unmountfs+0x92/0x180
[ 8217.645742]  xfs_fs_put_super+0x39/0xb0
[ 8217.646490]  generic_shutdown_super+0x64/0x110
[ 8217.647360]  kill_block_super+0x21/0x50
[ 8217.648131]  deactivate_locked_super+0x39/0x70
[ 8217.649006]  cleanup_mnt+0x3b/0x80
[ 8217.649675]  task_work_run+0x82/0xb0
[ 8217.650389]  exit_to_usermode_loop+0xd3/0xe0
[ 8217.651223]  do_syscall_64+0x170/0x180

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
