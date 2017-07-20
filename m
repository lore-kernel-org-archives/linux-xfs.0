Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40619 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdGTG6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 02:58:17 -0400
Date: Wed, 19 Jul 2017 23:58:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: quotacheck deadlock?
Message-ID: <20170720065804.GR4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>

Hi,

I ran the following sequence of commands on 4.13-rc1:

# mkfs.xfs -f /dev/sdf
# xfs_db -x -c 'sb 0' -c 'addr rootino' -c 'write -d core.uid 4294967295' /dev/sdf
# mount /dev/sdf -o usrquota

The kernel reports that it's starting quotacheck, but never finishes.
echo t > /proc/sysrq produces this for the hung mount command:

mount           R  running task        0   988    895 0x00000000
Call Trace:
 ? sched_clock_cpu+0xa8/0xe0
 ? xfs_qm_flush_one+0x3c/0x120 [xfs]
 ? lock_acquire+0xac/0x200
 ? lock_acquire+0xac/0x200
 ? xfs_qm_flush_one+0x3c/0x120 [xfs]
 ? xfs_qm_dquot_walk+0xa1/0x170 [xfs]
 ? get_lock_stats+0x19/0x60
 ? get_lock_stats+0x19/0x60
 ? xfs_qm_dquot_walk+0xa1/0x170 [xfs]
 ? xfs_qm_dquot_walk+0x125/0x170 [xfs]
 ? radix_tree_gang_lookup+0xd1/0xf0
 ? xfs_qm_shrink_count+0x20/0x20 [xfs]
 ? xfs_qm_dquot_walk+0xbb/0x170 [xfs]
 ? kfree+0x23f/0x2d0
 ? kvfree+0x2a/0x40
 ? xfs_bulkstat+0x315/0x680 [xfs]
 ? xfs_qm_get_rtblks+0xa0/0xa0 [xfs]
 ? xfs_qm_quotacheck+0x2bd/0x360 [xfs]
 ? xfs_qm_mount_quotas+0x106/0x1f0 [xfs]
 ? xfs_mountfs+0x6f2/0xb00 [xfs]
 ? xfs_fs_fill_super+0x483/0x610 [xfs]
 ? mount_bdev+0x180/0x1b0
 ? xfs_finish_flags+0x150/0x150 [xfs]
 ? xfs_fs_mount+0x15/0x20 [xfs]
 ? mount_fs+0x14/0x80
 ? vfs_kern_mount+0x67/0x170
 ? do_mount+0x195/0xd00
 ? kmem_cache_alloc_trace+0x231/0x2a0
 ? SyS_mount+0x95/0xe0
 ? entry_SYSCALL_64_fastpath+0x1f/0xbe

Any thoughts?  I'm not sure what's going on for sure, other than the
call stack looks funny and it's midnight so I'm going to sleep. :)

--D
