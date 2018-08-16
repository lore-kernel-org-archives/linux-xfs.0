Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39200 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391896AbeHPTCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Aug 2018 15:02:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1134B28B3F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Aug 2018 16:03:19 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] New: XFS hangs in xfs_reclaim_inode()
Date: Thu, 16 Aug 2018 16:03:18 +0000
Message-ID: <bug-200835-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200835

            Bug ID: 200835
           Summary: XFS hangs in xfs_reclaim_inode()
           Product: File System
           Version: 2.5
    Kernel Version: 4.14.62
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: peter.klotz99@gmail.com
        Regression: No

Created attachment 277895
  --> https://bugzilla.kernel.org/attachment.cgi?id=277895&action=edit
Hang of kernel 4.14.62

The attached file shows backtraces that occur in quick succession and
ultimately lead to a complete server hang.

The backtraces seem related to inode reclamation.

For example the first backtrace:

Aug 16 02:33:30 hpmicroserver kernel: INFO: task khugepaged:28 blocked for more
than 120 seconds.
Aug 16 02:33:30 hpmicroserver kernel:       Not tainted 4.14.62-1-lts #1
Aug 16 02:33:30 hpmicroserver kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 16 02:33:30 hpmicroserver kernel: khugepaged      D    0    28      2
0x80000000
Aug 16 02:33:30 hpmicroserver kernel: Call Trace:
Aug 16 02:33:30 hpmicroserver kernel:  ? __schedule+0x284/0x860
Aug 16 02:33:30 hpmicroserver kernel:  schedule+0x28/0x80
Aug 16 02:33:30 hpmicroserver kernel:  schedule_timeout+0x292/0x370
Aug 16 02:33:30 hpmicroserver kernel:  ? check_preempt_curr+0x62/0x90
Aug 16 02:33:30 hpmicroserver kernel:  wait_for_completion+0xaf/0x140
Aug 16 02:33:30 hpmicroserver kernel:  ? wake_up_q+0x70/0x70
Aug 16 02:33:30 hpmicroserver kernel:  flush_work+0x116/0x1d0
Aug 16 02:33:30 hpmicroserver kernel:  ? worker_detach_from_pool+0xa0/0xa0
Aug 16 02:33:30 hpmicroserver kernel:  xlog_cil_force_lsn+0x78/0x210 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  ? enqueue_task_fair+0x5a/0x500
Aug 16 02:33:30 hpmicroserver kernel:  ? native_sched_clock+0x37/0x90
Aug 16 02:33:30 hpmicroserver kernel:  ? __switch_to_asm+0x40/0x70
Aug 16 02:33:30 hpmicroserver kernel:  _xfs_log_force_lsn+0x71/0x340 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  ? try_to_wake_up+0x54/0x4b0
Aug 16 02:33:30 hpmicroserver kernel:  ? update_group_capacity+0x27/0x1e0
Aug 16 02:33:30 hpmicroserver kernel:  ? xfs_reclaim_inode+0xe3/0x340 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  __xfs_iunpin_wait+0xa7/0x160 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  ? bit_waitqueue+0x30/0x30
Aug 16 02:33:30 hpmicroserver kernel:  xfs_reclaim_inode+0xe3/0x340 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  xfs_reclaim_inodes_ag+0x1b1/0x300 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  super_cache_scan+0x152/0x1a0
Aug 16 02:33:30 hpmicroserver kernel:  shrink_slab.part.45+0x1e8/0x3c0
Aug 16 02:33:30 hpmicroserver kernel:  shrink_node+0x123/0x310
Aug 16 02:33:30 hpmicroserver kernel:  do_try_to_free_pages+0xc3/0x330
Aug 16 02:33:30 hpmicroserver kernel:  try_to_free_pages+0xf4/0x1b0
Aug 16 02:33:30 hpmicroserver kernel:  __alloc_pages_slowpath+0x3e4/0xd80
Aug 16 02:33:30 hpmicroserver kernel:  ? __switch_to+0x170/0x4b0
Aug 16 02:33:30 hpmicroserver kernel:  ? __switch_to_asm+0x34/0x70
Aug 16 02:33:30 hpmicroserver kernel:  ? __switch_to_asm+0x34/0x70
Aug 16 02:33:30 hpmicroserver kernel:  ? __switch_to_asm+0x40/0x70
Aug 16 02:33:30 hpmicroserver kernel:  __alloc_pages_nodemask+0x226/0x240
Aug 16 02:33:30 hpmicroserver kernel:  khugepaged_alloc_page+0x17/0x50
Aug 16 02:33:30 hpmicroserver kernel:  khugepaged+0xbcb/0x2120
Aug 16 02:33:30 hpmicroserver kernel:  ? wait_woken+0x80/0x80
Aug 16 02:33:30 hpmicroserver kernel:  ? collapse_shmem+0xb90/0xb90
Aug 16 02:33:30 hpmicroserver kernel:  kthread+0x119/0x130
Aug 16 02:33:30 hpmicroserver kernel:  ? __kthread_parkme+0xa0/0xa0
Aug 16 02:33:30 hpmicroserver kernel:  ret_from_fork+0x22/0x40


The problem has occurred twice so far. Once in kernel 4.14.52 and once in
4.14.62. I am using the Arch Linux LTS kernel so it is more or less the vanilla
kernel.

The server has two XFS filesystems. One is a 30TB XFS/LUKS/RAID setup, the
other one is a plain 4TB XFS volume.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
