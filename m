Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbfCTRDI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Mar 2019 13:03:08 -0400
Date: Wed, 20 Mar 2019 13:03:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190320170305.GA29010@bfoster>
References: <20190320050408.GA24923@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320050408.GA24923@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 19, 2019 at 10:04:08PM -0700, Darrick J. Wong wrote:
> Hmmm.
> 
> Every now and then I see a generic/475 deadlock that generates the
> hangcheck warning pasted below.
> 

Haven't seen it, but I'll kick off a few iterations..

> I /think/ this is ... the ail is processing an inode log item, for which
> it locked the cluster buffer and pushed the cil to unpin the buffer.
> However, the cil is cleaning up after the shut down and is trying to
> simulate an EIO completion, but tries grabs the buffer lock and hence
> the cil and ail deadlock.  Maybe the solution is to trylock in the
> (freed && remove) case of xfs_buf_item_unpin, since we're tearing the
> whole system down anyway?
> 

While the xfsaild will lock buffers via ->iop_push() callouts, I think
this is only to queue the buffer to the delwri queue (both buffer and
inode item pushes should cycle the buf lock before returning) and then
to submit the pending delwri queue. I don't think xfsaild should own any
such locks at the time it issues a log force..

> Anyway, tired, going to bed now, really just backing up my brain to the
> internet... :)
> 
> --D
> 
> INFO: task kworker/1:4:4668 blocked for more than 61 seconds.
>       Not tainted 5.1.0-rc1-xfsx #rc1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/1:4     D11632  4668      2 0x80000000
> Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]
> Call Trace:
>  ? __schedule+0x309/0x9e0
>  schedule+0x36/0x90
>  schedule_timeout+0x1fd/0x500
>  ? __next_timer_interrupt+0xc0/0xc0
>  ? __down_timeout+0x9b/0x120
>  __down_timeout+0xc3/0x120
>  down_timeout+0x43/0x50
>  xfs_buf_lock+0x7a/0x280 [xfs]
>  xfs_buf_item_unpin+0x300/0x4a0 [xfs]
>  xfs_trans_committed_bulk+0x105/0x3e0 [xfs]
>  xlog_cil_committed+0x4b/0x410 [xfs]
>  ? mark_held_locks+0x47/0x70
>  ? xlog_cil_push+0x3f3/0x460 [xfs]
>  ? xlog_cil_push+0x3f3/0x460 [xfs]
>  ? rcu_read_lock_sched_held+0x74/0x80
>  xlog_cil_push+0x400/0x460 [xfs]
>  process_one_work+0x252/0x600
>  worker_thread+0x1d9/0x390
>  ? wq_calc_node_cpumask+0x80/0x80
>  kthread+0x11f/0x140
>  ? kthread_create_on_node+0x70/0x70
>  ret_from_fork+0x24/0x30

Ok, so there's a CIL push where the log write failed and the buf item
abort is waiting on the buf lock..

> INFO: task xfsaild/dm-0:7063 blocked for more than 61 seconds.
>       Not tainted 5.1.0-rc1-xfsx #rc1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> xfsaild/dm-0    D13752  7063      2 0x80000000
> Call Trace:
>  ? __schedule+0x309/0x9e0
>  ? wait_for_completion+0x12b/0x1c0
>  schedule+0x36/0x90
>  schedule_timeout+0x32a/0x500
>  ? wait_for_completion+0x12b/0x1c0
>  wait_for_completion+0x153/0x1c0
>  ? wake_up_q+0x80/0x80
>  __flush_work+0x1e1/0x300
>  ? flush_workqueue_prep_pwqs+0x1b0/0x1b0
>  ? wait_for_completion+0x43/0x1c0
>  xlog_cil_force_lsn+0x97/0x270 [xfs]
>  ? xfs_iflush+0x38d/0x470 [xfs]
>  xfs_log_force+0xff/0x4f0 [xfs]
>  ? xfs_dinode_calc_crc+0x3b/0x60 [xfs]
>  ? xfs_iflush_int+0x24d/0x570 [xfs]
>  xfs_iflush+0x38d/0x470 [xfs]
>  xfs_inode_item_push+0xe6/0x200 [xfs]
>  xfsaild+0x50d/0x1210 [xfs]
>  ? sched_clock+0x5/0x10
>  ? sched_clock_cpu+0xe/0xd0
>  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
>  kthread+0x11f/0x140
>  ? kthread_create_on_node+0x70/0x70
>  ret_from_fork+0x24/0x30

xfsaild forces the log and the associated CIL push blocks on the one
already in progress..

> INFO: task umount:7089 blocked for more than 61 seconds.
>       Not tainted 5.1.0-rc1-xfsx #rc1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> umount          D13312  7089   6414 0x00000000
> Call Trace:
>  ? __schedule+0x309/0x9e0
>  ? wait_for_completion+0x12b/0x1c0
>  schedule+0x36/0x90
>  schedule_timeout+0x32a/0x500
>  ? wait_for_completion+0x12b/0x1c0
>  wait_for_completion+0x153/0x1c0
>  ? wake_up_q+0x80/0x80
>  __flush_work+0x1e1/0x300
>  ? flush_workqueue_prep_pwqs+0x1b0/0x1b0
>  ? wait_for_completion+0x43/0x1c0
>  xlog_cil_force_lsn+0x97/0x270 [xfs]
>  ? xfs_fs_sync_fs+0x21/0x50 [xfs]
>  xfs_log_force+0xff/0x4f0 [xfs]
>  xfs_fs_sync_fs+0x21/0x50 [xfs]
>  sync_filesystem+0x6b/0x90
>  generic_shutdown_super+0x22/0x100
>  kill_block_super+0x21/0x50
>  deactivate_locked_super+0x29/0x60
>  cleanup_mnt+0x3b/0x70
>  task_work_run+0x98/0xc0
>  exit_to_usermode_loop+0x83/0x90
>  do_syscall_64+0x14b/0x150
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe

And unmount is doing a log force as well..

Hmm.. yeah, I think we need to figure out how/why the buffer is locked.
I don't think it should be xfsaild because while the delwri submit locks
the buffers for I/O, that should essentially transfer lock ownership to
the async I/O (i.e., to be unlocked via xfs_buf_ioend() via bio
completion). Is the buf I/O associated completion wq stuck somewhere? Is
the buffer submission path working correctly in the shutdown case..?

Brian

> RIP: 0033:0x7fa9ff80e8c7
> Code: Bad RIP value.
> RSP: 002b:00007ffd647ea078 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00005642818ed970 RCX: 00007fa9ff80e8c7
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00005642818fa100
> RBP: 0000000000000000 R08: 00005642818f91e0 R09: 00007fa9ffad8c40
> R10: 000000000000000b R11: 0000000000000246 R12: 00005642818fa100
> R13: 00007fa9ffd308a4 R14: 00005642818f9980 R15: 0000000000000000
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/34:
>  #0: 0000000056e8f88f (rcu_read_lock){....}, at: debug_show_all_locks+0x15/0x17f
> 1 lock held by in:imklog/1113:
>  #0: 000000007873f311 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x4d/0x60
> 5 locks held by kworker/u13:4/3736:
> 2 locks held by kworker/1:4/4668:
>  #0: 00000000cd34452f ((wq_completion)xfs-cil/dm-0){+.+.}, at: process_one_work+0x1d8/0x600
>  #1: 000000003c563604 ((work_completion)(&cil->xc_push_work)){+.+.}, at: process_one_work+0x1d8/0x600
> 2 locks held by kworker/2:4/5394:
>  #0: 0000000072544c54 ((wq_completion)xfs-sync/dm-0){+.+.}, at: process_one_work+0x1d8/0x600
>  #1: 00000000c3e919b6 ((work_completion)(&(&log->l_work)->work)){+.+.}, at: process_one_work+0x1d8/0x600
> 1 lock held by xfsaild/dm-0/7063:
>  #0: 0000000049da3bb4 (&xfs_nondir_ilock_class){++++}, at: xfs_ilock_nowait+0x1ee/0x330 [xfs]
> 1 lock held by umount/7089:
>  #0: 0000000031dc2924 (&type->s_umount_key#50){++++}, at: deactivate_super+0x43/0x50
> 
> =============================================
> 
