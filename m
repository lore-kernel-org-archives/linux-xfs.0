Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31699 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdITVKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 17:10:44 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8KLAhUc001915
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2017 21:10:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8KLAhjB011920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2017 21:10:43 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8KLAh7u007384
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2017 21:10:43 GMT
Date: Wed, 20 Sep 2017 14:10:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: shared/298 lockdep splat?
Message-ID: <20170920211042.GH7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hello list,

Yesterday I tried setting up qemu 2.10 with some (fake) nvdimms backed
by an on-disk file.  Midway through a -g auto xfstests run, shared/298
produced the attached dmesg spew.  I'll try to have a look later, but
in the meantime I'm doing the 'complain to list, see if anyone bites'
thing. :)

The kernel is 4.14-rc1 without any patches applied.

--D

======================================================
WARNING: possible circular locking dependency detected
4.14.0-rc1-fixes #1 Tainted: G        W      
------------------------------------------------------
loop0/31693 is trying to acquire lock:
 (&(&ip->i_mmaplock)->mr_lock){++++}, at: [<ffffffffa00f1b0c>] xfs_ilock+0x23c/0x330 [xfs]

but now in release context of a crosslock acquired at the following:
 ((complete)&ret.event){+.+.}, at: [<ffffffff81326c1f>] submit_bio_wait+0x7f/0xb0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 ((complete)&ret.event){+.+.}:
       lock_acquire+0xab/0x200
       wait_for_completion_io+0x4e/0x1a0
       submit_bio_wait+0x7f/0xb0
       blkdev_issue_zeroout+0x71/0xa0
       xfs_bmapi_convert_unwritten+0x11f/0x1d0 [xfs]
       xfs_bmapi_write+0x374/0x11f0 [xfs]
       xfs_iomap_write_direct+0x2ac/0x430 [xfs]
       xfs_file_iomap_begin+0x20d/0xd50 [xfs]
       iomap_apply+0x43/0xe0
       dax_iomap_rw+0x89/0xf0
       xfs_file_dax_write+0xcc/0x220 [xfs]
       xfs_file_write_iter+0xf0/0x130 [xfs]
       __vfs_write+0xd9/0x150
       vfs_write+0xc8/0x1c0
       SyS_write+0x45/0xa0
       entry_SYSCALL_64_fastpath+0x1f/0xbe

-> #1 (&xfs_nondir_ilock_class){++++}:
       lock_acquire+0xab/0x200
       down_write_nested+0x4a/0xb0
       xfs_ilock+0x263/0x330 [xfs]
       xfs_setattr_size+0x152/0x370 [xfs]
       xfs_vn_setattr+0x6b/0x90 [xfs]
       notify_change+0x27d/0x3f0
       do_truncate+0x5b/0x90
       path_openat+0x237/0xa90
       do_filp_open+0x8a/0xf0
       do_sys_open+0x11c/0x1f0
       entry_SYSCALL_64_fastpath+0x1f/0xbe

-> #0 (&(&ip->i_mmaplock)->mr_lock){++++}:
       up_write+0x1c/0x40
       xfs_iunlock+0x1d0/0x310 [xfs]
       xfs_file_fallocate+0x8a/0x310 [xfs]
       loop_queue_work+0xb7/0x8d0
       kthread_worker_fn+0xb9/0x1f0

other info that might help us debug this:

Chain exists of:
  &(&ip->i_mmaplock)->mr_lock --> &xfs_nondir_ilock_class --> (complete)&ret.event

 Possible unsafe locking scenario by crosslock:

       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class);
  lock((complete)&ret.event);
                               lock(&(&ip->i_mmaplock)->mr_lock);
                               unlock((complete)&ret.event);

 *** DEADLOCK ***

1 lock held by loop0/31693:
 #0:  (&x->wait#16){-...}, at: [<ffffffff810d1858>] complete+0x18/0x60

stack backtrace:
CPU: 2 PID: 31693 Comm: loop0 Tainted: G        W       4.14.0-rc1-fixes #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0x7c/0xbe
 print_circular_bug+0x204/0x310
 ? graph_unlock+0x70/0x70
 check_prev_add+0x401/0x800
 ? __lock_acquire+0x72a/0x1100
 ? __lock_acquire+0x534/0x1100
 ? lock_commit_crosslock+0x3e9/0x5c0
 lock_commit_crosslock+0x3e9/0x5c0
 complete+0x24/0x60
 blk_update_request+0xc2/0x3e0
 blk_mq_end_request+0x18/0x80
 __blk_mq_complete_request+0x9f/0x170
 loop_queue_work+0x51/0x8d0
 ? kthread_worker_fn+0x96/0x1f0
 kthread_worker_fn+0xb9/0x1f0
 kthread+0x148/0x180
 ? loop_get_status64+0x80/0x80
 ? kthread_create_on_node+0x40/0x40
 ret_from_fork+0x2a/0x40
XFS (loop0): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
XFS (loop0): EXPERIMENTAL reflink feature enabled. Use at your own risk!
XFS (loop0): Mounting V5 Filesystem
XFS (loop0): Ending clean mount
XFS (loop0): Unmounting Filesystem
XFS (pmem3): Unmounting Filesystem
XFS (pmem3): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
XFS (pmem3): EXPERIMENTAL reflink feature enabled. Use at your own risk!
XFS (pmem3): Mounting V5 Filesystem
XFS (pmem3): Ending clean mount
