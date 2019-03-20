Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfCTFEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 01:04:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2K53fjl151121
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2019 05:04:09 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2r8rjurhef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2019 05:04:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2K548LP027825
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2019 05:04:09 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2K548Gm025138
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2019 05:04:08 GMT
Date: Tue, 19 Mar 2019 22:04:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: generic/475 deadlock?
Message-ID: <20190320050408.GA24923@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hmmm.

Every now and then I see a generic/475 deadlock that generates the
hangcheck warning pasted below.

I /think/ this is ... the ail is processing an inode log item, for which
it locked the cluster buffer and pushed the cil to unpin the buffer.
However, the cil is cleaning up after the shut down and is trying to
simulate an EIO completion, but tries grabs the buffer lock and hence
the cil and ail deadlock.  Maybe the solution is to trylock in the
(freed && remove) case of xfs_buf_item_unpin, since we're tearing the
whole system down anyway?

Anyway, tired, going to bed now, really just backing up my brain to the
internet... :)

--D

INFO: task kworker/1:4:4668 blocked for more than 61 seconds.
      Not tainted 5.1.0-rc1-xfsx #rc1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:4     D11632  4668      2 0x80000000
Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]
Call Trace:
 ? __schedule+0x309/0x9e0
 schedule+0x36/0x90
 schedule_timeout+0x1fd/0x500
 ? __next_timer_interrupt+0xc0/0xc0
 ? __down_timeout+0x9b/0x120
 __down_timeout+0xc3/0x120
 down_timeout+0x43/0x50
 xfs_buf_lock+0x7a/0x280 [xfs]
 xfs_buf_item_unpin+0x300/0x4a0 [xfs]
 xfs_trans_committed_bulk+0x105/0x3e0 [xfs]
 xlog_cil_committed+0x4b/0x410 [xfs]
 ? mark_held_locks+0x47/0x70
 ? xlog_cil_push+0x3f3/0x460 [xfs]
 ? xlog_cil_push+0x3f3/0x460 [xfs]
 ? rcu_read_lock_sched_held+0x74/0x80
 xlog_cil_push+0x400/0x460 [xfs]
 process_one_work+0x252/0x600
 worker_thread+0x1d9/0x390
 ? wq_calc_node_cpumask+0x80/0x80
 kthread+0x11f/0x140
 ? kthread_create_on_node+0x70/0x70
 ret_from_fork+0x24/0x30
INFO: task xfsaild/dm-0:7063 blocked for more than 61 seconds.
      Not tainted 5.1.0-rc1-xfsx #rc1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsaild/dm-0    D13752  7063      2 0x80000000
Call Trace:
 ? __schedule+0x309/0x9e0
 ? wait_for_completion+0x12b/0x1c0
 schedule+0x36/0x90
 schedule_timeout+0x32a/0x500
 ? wait_for_completion+0x12b/0x1c0
 wait_for_completion+0x153/0x1c0
 ? wake_up_q+0x80/0x80
 __flush_work+0x1e1/0x300
 ? flush_workqueue_prep_pwqs+0x1b0/0x1b0
 ? wait_for_completion+0x43/0x1c0
 xlog_cil_force_lsn+0x97/0x270 [xfs]
 ? xfs_iflush+0x38d/0x470 [xfs]
 xfs_log_force+0xff/0x4f0 [xfs]
 ? xfs_dinode_calc_crc+0x3b/0x60 [xfs]
 ? xfs_iflush_int+0x24d/0x570 [xfs]
 xfs_iflush+0x38d/0x470 [xfs]
 xfs_inode_item_push+0xe6/0x200 [xfs]
 xfsaild+0x50d/0x1210 [xfs]
 ? sched_clock+0x5/0x10
 ? sched_clock_cpu+0xe/0xd0
 ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
 kthread+0x11f/0x140
 ? kthread_create_on_node+0x70/0x70
 ret_from_fork+0x24/0x30
INFO: task umount:7089 blocked for more than 61 seconds.
      Not tainted 5.1.0-rc1-xfsx #rc1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount          D13312  7089   6414 0x00000000
Call Trace:
 ? __schedule+0x309/0x9e0
 ? wait_for_completion+0x12b/0x1c0
 schedule+0x36/0x90
 schedule_timeout+0x32a/0x500
 ? wait_for_completion+0x12b/0x1c0
 wait_for_completion+0x153/0x1c0
 ? wake_up_q+0x80/0x80
 __flush_work+0x1e1/0x300
 ? flush_workqueue_prep_pwqs+0x1b0/0x1b0
 ? wait_for_completion+0x43/0x1c0
 xlog_cil_force_lsn+0x97/0x270 [xfs]
 ? xfs_fs_sync_fs+0x21/0x50 [xfs]
 xfs_log_force+0xff/0x4f0 [xfs]
 xfs_fs_sync_fs+0x21/0x50 [xfs]
 sync_filesystem+0x6b/0x90
 generic_shutdown_super+0x22/0x100
 kill_block_super+0x21/0x50
 deactivate_locked_super+0x29/0x60
 cleanup_mnt+0x3b/0x70
 task_work_run+0x98/0xc0
 exit_to_usermode_loop+0x83/0x90
 do_syscall_64+0x14b/0x150
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fa9ff80e8c7
Code: Bad RIP value.
RSP: 002b:00007ffd647ea078 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00005642818ed970 RCX: 00007fa9ff80e8c7
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00005642818fa100
RBP: 0000000000000000 R08: 00005642818f91e0 R09: 00007fa9ffad8c40
R10: 000000000000000b R11: 0000000000000246 R12: 00005642818fa100
R13: 00007fa9ffd308a4 R14: 00005642818f9980 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/34:
 #0: 0000000056e8f88f (rcu_read_lock){....}, at: debug_show_all_locks+0x15/0x17f
1 lock held by in:imklog/1113:
 #0: 000000007873f311 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x4d/0x60
5 locks held by kworker/u13:4/3736:
2 locks held by kworker/1:4/4668:
 #0: 00000000cd34452f ((wq_completion)xfs-cil/dm-0){+.+.}, at: process_one_work+0x1d8/0x600
 #1: 000000003c563604 ((work_completion)(&cil->xc_push_work)){+.+.}, at: process_one_work+0x1d8/0x600
2 locks held by kworker/2:4/5394:
 #0: 0000000072544c54 ((wq_completion)xfs-sync/dm-0){+.+.}, at: process_one_work+0x1d8/0x600
 #1: 00000000c3e919b6 ((work_completion)(&(&log->l_work)->work)){+.+.}, at: process_one_work+0x1d8/0x600
1 lock held by xfsaild/dm-0/7063:
 #0: 0000000049da3bb4 (&xfs_nondir_ilock_class){++++}, at: xfs_ilock_nowait+0x1ee/0x330 [xfs]
1 lock held by umount/7089:
 #0: 0000000031dc2924 (&type->s_umount_key#50){++++}, at: deactivate_super+0x43/0x50

=============================================
