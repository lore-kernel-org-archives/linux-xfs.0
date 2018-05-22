Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbeEVMbJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 08:31:09 -0400
Date: Tue, 22 May 2018 08:31:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: INFO: task hung in xlog_grant_head_check
Message-ID: <20180522123107.GC3751@bfoster.bfoster>
References: <000000000000457b2d056cbb0044@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000457b2d056cbb0044@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>
Cc: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Mon, May 21, 2018 at 10:55:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    203ec2fed17a Merge tag 'armsoc-fixes' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c1ad77800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f3b4e30da84ec1ed
> dashboard link: https://syzkaller.appspot.com/bug?extid=568245b88fbaedcb1959
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=122c7427800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10387057800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com
> 
>         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................
>         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................
> XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len
> 1 error 117
> XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117,
> agno 0
> XFS (loop0): failed to read root inode

FWIW, the initial console output is actually:

[  448.028253] XFS (loop0): Mounting V4 Filesystem
[  448.033540] XFS (loop0): Log size 9371840 blocks too large, maximum size is 1048576 blocks
[  448.042287] XFS (loop0): Log size out of supported range.
[  448.047841] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
[  448.060712] XFS (loop0): totally zeroed log

... which warns about an oversized log and resulting log hangs. Not
having dug into the details of why this occurs so quickly in this mount
failure path, it does look like we'd never have got past this point on a
v5 fs (i.e., the above warning would become an error and we'd not enter
the xfs_log_mount_cancel() path).

Brian

> INFO: task syz-executor060:4501 blocked for more than 120 seconds.
>       Not tainted 4.17.0-rc5+ #60
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor060 D17168  4501   4499 0x00000000
> Call Trace:
>  context_switch kernel/sched/core.c:2859 [inline]
>  __schedule+0x801/0x1e30 kernel/sched/core.c:3501
>  schedule+0xef/0x430 kernel/sched/core.c:3545
>  xlog_grant_head_wait+0x260/0xf80 fs/xfs/xfs_log.c:275
>  xlog_grant_head_check+0x4d6/0x550 fs/xfs/xfs_log.c:337
>  xfs_log_reserve+0x398/0xd20 fs/xfs/xfs_log.c:466
>  xfs_log_unmount_write+0x2c4/0xfb0 fs/xfs/xfs_log.c:885
>  xfs_log_quiesce+0xf9/0x130 fs/xfs/xfs_log.c:1011
>  xfs_log_unmount+0x22/0xb0 fs/xfs/xfs_log.c:1025
>  xfs_log_mount_cancel+0x44/0x60 fs/xfs/xfs_log.c:828
>  xfs_mountfs+0x17d9/0x2b80 fs/xfs/xfs_mount.c:1041
>  xfs_fs_fill_super+0xdef/0x1560 fs/xfs/xfs_super.c:1734
>  mount_bdev+0x30c/0x3e0 fs/super.c:1164
>  xfs_fs_mount+0x34/0x40 fs/xfs/xfs_super.c:1801
>  mount_fs+0xae/0x328 fs/super.c:1267
>  vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
>  vfs_kern_mount fs/namespace.c:1027 [inline]
>  do_new_mount fs/namespace.c:2518 [inline]
>  do_mount+0x564/0x3070 fs/namespace.c:2848
>  ksys_mount+0x12d/0x140 fs/namespace.c:3064
>  __do_sys_mount fs/namespace.c:3078 [inline]
>  __se_sys_mount fs/namespace.c:3075 [inline]
>  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3075
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x442d9a
> RSP: 002b:00007ffc7a9dde88 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442d9a
> RDX: 0000000020000040 RSI: 0000000020000100 RDI: 00007ffc7a9dde90
> RBP: 0000000000000004 R08: 00000000200001c0 R09: 000000000000000a
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000401c00
> R13: 0000000000401c90 R14: 0000000000000000 R15: 0000000000000000
> 
> Showing all locks held in the system:
> 2 locks held by khungtaskd/893:
>  #0:         (ptrval) (rcu_read_lock){....}, at:
> check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
>  #0:         (ptrval) (rcu_read_lock){....}, at: watchdog+0x1ff/0xf60
> kernel/hung_task.c:249
>  #1:         (ptrval) (tasklist_lock){.+.+}, at:
> debug_show_all_locks+0xde/0x34a kernel/locking/lockdep.c:4470
> 1 lock held by rsyslogd/4384:
>  #0:         (ptrval) (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1a9/0x1e0
> fs/file.c:766
> 2 locks held by getty/4474:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4475:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4476:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4477:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4478:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4479:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4480:
>  #0:         (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1:         (ptrval) (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 1 lock held by syz-executor060/4501:
>  #0:         (ptrval) (&type->s_umount_key#36/1){+.+.}, at: alloc_super
> fs/super.c:213 [inline]
>  #0:         (ptrval) (&type->s_umount_key#36/1){+.+.}, at:
> sget_userns+0x2dd/0xf00 fs/super.c:506
> 
> =============================================
> 
> NMI backtrace for cpu 0
> CPU: 0 PID: 893 Comm: khungtaskd Not tainted 4.17.0-rc5+ #60
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
>  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_all_cpu_backtrace include/linux/nmi.h:138 [inline]
>  check_hung_task kernel/hung_task.c:132 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:190 [inline]
>  watchdog+0xc10/0xf60 kernel/hung_task.c:249
>  kthread+0x345/0x410 kernel/kthread.c:240
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0x6/0x10
> arch/x86/include/asm/irqflags.h:54
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
