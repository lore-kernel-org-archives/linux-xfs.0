Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753985AbdLUSjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 13:39:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLIagh6114359
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2017 18:39:41 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2f0j0a83ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2017 18:39:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBLIdeWm007894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2017 18:39:40 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBLIdeHR008980
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2017 18:39:40 GMT
Date: Thu, 21 Dec 2017 10:39:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: generic/388 crash?
Message-ID: <20171221183939.GW12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hmm, does this generic/388 crash look familiar to anyone?

--D

[ 5222.133531] run fstests generic/388 at 2017-12-20 18:57:01
[ 5222.705969] XFS (pmem4): Unmounting Filesystem
[ 5222.795250] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 5222.796164] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 5222.797066] XFS (pmem4): Mounting V5 Filesystem
[ 5222.799553] XFS (pmem4): Ending clean mount
[ 5222.869834] XFS (pmem4): Unmounting Filesystem
[ 5222.966982] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 5222.968327] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 5222.970077] XFS (pmem4): Mounting V5 Filesystem
[ 5222.972784] XFS (pmem4): Ending clean mount
[ 5225.046749] potentially unexpected fatal signal 6.
[ 5225.047715] CPU: 2 PID: 16591 Comm: fsstress Tainted: G        W        4.15.0-rc1-djw #7
[ 5225.049134] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.050764] task: ffff88007882c000 task.stack: ffffc90007fa8000
[ 5225.051788] RIP: 0033:0x7fe3256d0428
[ 5225.052437] RSP: 002b:00007fff452d5358 EFLAGS: 00000206 ORIG_RAX: 00000000000000ea
[ 5225.053833] RAX: 0000000000000000 RBX: 0000000000001275 RCX: 00007fe3256d0428
[ 5225.055085] RDX: 0000000000000006 RSI: 00000000000040cf RDI: 00000000000040cf
[ 5225.056325] RBP: 0000000000000005 R08: 000000000000001c R09: 00007fe325a60540
[ 5225.057549] R10: 0000000000000008 R11: 0000000000000206 R12: 0000000051eb851f
[ 5225.057850] XFS (pmem4): xfs_do_force_shutdown(0x1) called from line 236 of file /raid/home/djwong/cdev/work/linux-djw/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa010800f
[ 5225.059899] XFS (pmem4): xfs_do_force_shutdown(0x1) called from line 236 of file /raid/home/djwong/cdev/work/linux-djw/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa010800f
[ 5225.066726] XFS: Assertion failed: (lip->li_flags & XFS_LI_IN_AIL) != 0, file: /raid/home/djwong/cdev/work/linux-djw/fs/xfs/xfs_trans_ail.c, line: 49
[ 5225.066863] WARNING: CPU: 3 PID: 16583 at /raid/home/djwong/cdev/work/linux-djw/fs/xfs/xfs_message.c:105 asswarn+0x1c/0x20 [xfs]
[ 5225.066865] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c dax_pmem nd_pmem device_dax sch_fq_codel af_packet [last unloaded: scsi_debug]
[ 5225.066890] CPU: 3 PID: 16583 Comm: xfsaild/pmem4 Tainted: G        W        4.15.0-rc1-djw #7
[ 5225.066892] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.066894] task: ffff88006a1e8000 task.stack: ffffc90007f78000
[ 5225.066935] RIP: 0010:asswarn+0x1c/0x20 [xfs]
[ 5225.066938] RSP: 0018:ffffc90007f7bc60 EFLAGS: 00010286
[ 5225.066941] RAX: 00000000ffffffea RBX: ffff880078ffbf18 RCX: 0000000000000006
[ 5225.066942] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa02311dd
[ 5225.066944] RBP: ffff880077cba200 R08: 0000000000000000 R09: 0000000000000000
[ 5225.066946] R10: ffff88006a1e8000 R11: f000000000000000 R12: ffff880077cba210
[ 5225.066947] R13: ffff880077cba200 R14: 0000000000000000 R15: 000000000000000c
[ 5225.066950] FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[ 5225.066951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5225.066953] CR2: 00007f976b7043cc CR3: 0000000049101000 CR4: 00000000000006e0
[ 5225.066959] Call Trace:
[ 5225.067006]  xfs_ail_check+0xfb/0x150 [xfs]
[ 5225.067056]  xfs_ail_delete_one+0x79/0x400 [xfs]
[ 5225.067109]  xfs_iflush_done+0x28c/0x3b0 [xfs]
[ 5225.067157]  ? xfs_buf_delwri_submit_buffers+0x1af/0x730 [xfs]
[ 5225.067205]  xfs_buf_do_callbacks+0x1c/0x80 [xfs]
[ 5225.067252]  xfs_buf_iodone_callbacks+0xaa/0x740 [xfs]
[ 5225.067293]  ? xfs_buf_ioend+0x23f/0x360 [xfs]
[ 5225.067340]  xfs_buf_delwri_submit_buffers+0x1af/0x730 [xfs]
[ 5225.067388]  ? xfsaild+0x341/0x1ce0 [xfs]
[ 5225.067453]  ? xfsaild+0x341/0x1ce0 [xfs]
[ 5225.067501]  xfsaild+0x341/0x1ce0 [xfs]
[ 5225.067511]  ? finish_task_switch+0xaa/0x210
[ 5225.067604]  ? kthread+0x141/0x180
[ 5225.067607]  kthread+0x141/0x180
[ 5225.067652]  ? xfs_trans_ail_cursor_first+0x110/0x110 [xfs]
[ 5225.067656]  ? kthread_delayed_work_timer_fn+0x90/0x90
[ 5225.067665]  ret_from_fork+0x24/0x30
[ 5225.067685] Code: 38 a0 e8 98 fa 1d e1 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 e8 41 24 a0 48 89 fa 31 ff e8 d4 fc ff ff <0f> ff c3 90 66 66 66 66 90 53 48 89 f1 41 89 d0 48 c7 c6 e8 41 
[ 5225.067768] ---[ end trace a44d85618eac1af3 ]---
[ 5225.067776] stack segment: 0000 [#1] PREEMPT SMP
[ 5225.067778] Dumping ftrace buffer:
[ 5225.067782]    (ftrace buffer empty)
[ 5225.067783] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c dax_pmem nd_pmem device_dax sch_fq_codel af_packet [last unloaded: scsi_debug]
[ 5225.067795] CPU: 3 PID: 16583 Comm: xfsaild/pmem4 Tainted: G        W        4.15.0-rc1-djw #7
[ 5225.067796] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.067797] task: ffff88006a1e8000 task.stack: ffffc90007f78000
[ 5225.067839] RIP: 0010:xfs_ail_check+0x54/0x150 [xfs]
[ 5225.067841] RSP: 0018:ffffc90007f7bc68 EFLAGS: 00010286
[ 5225.067842] RAX: 00000000ffffffea RBX: ffff880078ffbf18 RCX: 0000000000000006
[ 5225.067844] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa02311dd
[ 5225.067845] RBP: dead000000000200 R08: 0000000000000000 R09: 0000000000000000
[ 5225.067846] R10: ffff88006a1e8000 R11: f000000000000000 R12: ffff880077cba210
[ 5225.067847] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000c
[ 5225.067848] FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[ 5225.067849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5225.067850] CR2: 00007f976b7043cc CR3: 0000000049101000 CR4: 00000000000006e0
[ 5225.067855] Call Trace:
[ 5225.067898]  xfs_ail_delete_one+0x79/0x400 [xfs]
[ 5225.067943]  xfs_iflush_done+0x28c/0x3b0 [xfs]
[ 5225.067985]  ? xfs_buf_delwri_submit_buffers+0x1af/0x730 [xfs]
[ 5225.068032]  xfs_buf_do_callbacks+0x1c/0x80 [xfs]
[ 5225.068076]  xfs_buf_iodone_callbacks+0xaa/0x740 [xfs]
[ 5225.068114]  ? xfs_buf_ioend+0x23f/0x360 [xfs]
[ 5225.068152]  xfs_buf_delwri_submit_buffers+0x1af/0x730 [xfs]
[ 5225.068196]  ? xfsaild+0x341/0x1ce0 [xfs]
[ 5225.068245]  ? xfsaild+0x341/0x1ce0 [xfs]
[ 5225.068291]  xfsaild+0x341/0x1ce0 [xfs]
[ 5225.068296]  ? finish_task_switch+0xaa/0x210
[ 5225.068305]  ? kthread+0x141/0x180
[ 5225.068307]  kthread+0x141/0x180
[ 5225.068351]  ? xfs_trans_ail_cursor_first+0x110/0x110 [xfs]
[ 5225.068354]  ? kthread_delayed_work_timer_fn+0x90/0x90
[ 5225.068357]  ret_from_fork+0x24/0x30
[ 5225.068364] Code: 00 00 48 85 db 0f 84 05 01 00 00 f6 43 34 01 0f 84 a5 00 00 00 48 8b 6b 08 49 39 ec 74 25 48 85 ed 4c 8b 6b 10 0f 84 d2 00 00 00 <48> 8b 45 10 4c 89 ea 48 c1 fa 20 48 89 c1 48 c1 f9 20 39 d1 74 
[ 5225.068442] RIP: xfs_ail_check+0x54/0x150 [xfs] RSP: ffffc90007f7bc68
[ 5225.068445] ---[ end trace a44d85618eac1af4 ]---
[ 5225.068447] BUG: sleeping function called from invalid context at /raid/home/djwong/cdev/work/linux-djw/include/linux/percpu-rwsem.h:34
[ 5225.068448] in_atomic(): 1, irqs_disabled(): 0, pid: 16583, name: xfsaild/pmem4
[ 5225.068449] INFO: lockdep is turned off.
[ 5225.068450] Preemption disabled at:
[ 5225.068452] [<          (null)>]           (null)
[ 5225.068454] CPU: 3 PID: 16583 Comm: xfsaild/pmem4 Tainted: G      D W        4.15.0-rc1-djw #7
[ 5225.068455] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.068456] Call Trace:
[ 5225.068461]  dump_stack+0x7c/0xbe
[ 5225.068465]  ___might_sleep+0x1f7/0x260
[ 5225.068470]  exit_signals+0x20/0x2a0
[ 5225.068473]  do_exit+0x9c/0xc90
[ 5225.068476]  ? kthread+0x141/0x180
[ 5225.068477]  ? kthread+0x141/0x180
[ 5225.068572]  ? xfs_trans_ail_cursor_first+0x110/0x110 [xfs]
[ 5225.068578]  rewind_stack_do_exit+0x17/0x20
[ 5225.068587] note: xfsaild/pmem4[16583] exited with preempt_count 1
[ 5225.141037] potentially unexpected fatal signal 6.
[ 5225.141040] CPU: 1 PID: 16592 Comm: fsstress Tainted: G      D W        4.15.0-rc1-djw #7
[ 5225.141042] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.141043] task: ffff880078990000 task.stack: ffffc90007fb0000
[ 5225.141047] RIP: 0033:0x7fe3256d0428
[ 5225.141048] RSP: 002b:00007fff452d57e8 EFLAGS: 00000202 ORIG_RAX: 00000000000000ea
[ 5225.141050] RAX: 0000000000000000 RBX: 0000000000001143 RCX: 00007fe3256d0428
[ 5225.141051] RDX: 0000000000000006 RSI: 00000000000040d0 RDI: 00000000000040d0
[ 5225.141053] RBP: 000000000007a120 R08: 000000000000001c R09: 00007fe325a60540
[ 5225.141054] R10: 0000000000000008 R11: 0000000000000202 R12: 00000000ffffffff
[ 5225.141055] R13: 0000000000001143 R14: 0000000000000000 R15: 0000000000000000
[ 5225.141057] FS:  00007fe3262a1700(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
[ 5225.141058] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5225.141060] CR2: 00007fe3262a2038 CR3: 0000000049005000 CR4: 00000000000006e0
[ 5225.141221] potentially unexpected fatal signal 6.
[ 5225.141224] CPU: 0 PID: 16588 Comm: fsstress Tainted: G      D W        4.15.0-rc1-djw #7
[ 5225.141225] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.141226] task: ffff880077640000 task.stack: ffffc90007f98000
[ 5225.141227] RIP: 0033:0x7fe3256d0428
[ 5225.141228] RSP: 002b:00007fff452d5818 EFLAGS: 00000206 ORIG_RAX: 00000000000000ea
[ 5225.141231] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 00007fe3256d0428
[ 5225.141232] RDX: 0000000000000006 RSI: 00000000000040cc RDI: 00000000000040cc
[ 5225.141233] RBP: 0000000000000005 R08: 000000000000001c R09: 00007fe325a60540
[ 5225.141234] R10: 0000000000000008 R11: 0000000000000206 R12: 000000000000117e
[ 5225.141235] R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
[ 5225.141237] FS:  00007fe3262a1700(0000) GS:ffff88003ea00000(0000) knlGS:0000000000000000
[ 5225.141238] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5225.141239] CR2: 00007fe3262af9b8 CR3: 000000006f06d000 CR4: 00000000000006f0
[ 5225.141291] potentially unexpected fatal signal 6.
[ 5225.141293] CPU: 0 PID: 16587 Comm: fsstress Tainted: G      D W        4.15.0-rc1-djw #7
[ 5225.141294] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5225.141296] task: ffff8800663a0000 task.stack: ffffc90007f90000
[ 5225.141298] RIP: 0033:0x7fe3256d0428
[ 5225.141299] RSP: 002b:00007fff452d5388 EFLAGS: 00000202 ORIG_RAX: 00000000000000ea
[ 5225.141301] RAX: 0000000000000000 RBX: 0000000000001100 RCX: 00007fe3256d0428
[ 5225.141302] RDX: 0000000000000006 RSI: 00000000000040cb RDI: 00000000000040cb
[ 5225.141303] RBP: 000000000005c2d6 R08: 000000000000001c R09: 00007fe325a60540
[ 5225.141305] R10: 0000000000000008 R11: 0000000000000202 R12: 0000000000000005
[ 5225.141306] R13: 0000000000409320 R14: 0000000000000000 R15: 0000000000000000
[ 5225.141307] FS:  00007fe3262a1700(0000) GS:ffff88003ea00000(0000) knlGS:0000000000000000
[ 5225.141309] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5225.141310] CR2: 00007fe3262af9b8 CR3: 000000006a131000 CR4: 00000000000006f0
[ 5225.318571] R13: 0000000000406fe0 R14: 0000000000000000 R15: 0000000000000000
[ 5225.319559] FS:  00007fe3262a1700(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
[ 5225.320664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5225.321701] CR2: 00007fe32629e000 CR3: 0000000078a87000 CR4: 00000000000006e0
[ 5225.459112] XFS (pmem4): Unmounting Filesystem
[ 5252.069165] watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [umount:16618]
[ 5252.070319] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c dax_pmem nd_pmem device_dax sch_fq_codel af_packet [last unloaded: scsi_debug]
[ 5252.073743] irq event stamp: 0
[ 5252.074299] hardirqs last  enabled at (0): [<          (null)>]           (null)
[ 5252.075533] hardirqs last disabled at (0): [<ffffffff810854c5>] copy_process.part.42+0x545/0x1e20
[ 5252.076944] softirqs last  enabled at (0): [<ffffffff810854c5>] copy_process.part.42+0x545/0x1e20
[ 5252.078343] softirqs last disabled at (0): [<          (null)>]           (null)
[ 5252.079544] CPU: 3 PID: 16618 Comm: umount Tainted: G      D W        4.15.0-rc1-djw #7
[ 5252.080944] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5252.083282] task: ffff88006a1e8000 task.stack: ffffc90007fa8000
[ 5252.085080] RIP: 0010:queued_spin_lock_slowpath+0x20/0x1d0
[ 5252.086030] RSP: 0018:ffffc90007fabdc0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff11
[ 5252.088242] RAX: 0000000000000001 RBX: ffff880077cba240 RCX: 0000000000000000
[ 5252.090133] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880077cba240
[ 5252.092282] RBP: ffff880077cba240 R08: 0000000000000001 R09: 0000000000000000
[ 5252.094447] R10: ffff88006a1e8000 R11: 0000000000000000 R12: ffff880077cba240
[ 5252.096567] R13: ffff880077cba210 R14: ffff880077cba2b0 R15: ffff880077e34c38
[ 5252.098728] FS:  00007f6b189e2840(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[ 5252.101467] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5252.102889] CR2: 00000000016237a8 CR3: 0000000077792000 CR4: 00000000000006e0
[ 5252.104861] Call Trace:
[ 5252.105946]  do_raw_spin_lock+0xad/0xb0
[ 5252.106921]  _raw_spin_lock+0x55/0x70
[ 5252.107916]  xfs_ail_push_all_sync+0x59/0xf0 [xfs]
[ 5252.109129]  ? remove_wait_queue+0x60/0x60
[ 5252.110295]  xfs_unmountfs+0xb2/0x3a0 [xfs]
[ 5252.112329]  xfs_fs_put_super+0x38/0xc0 [xfs]
[ 5252.114088]  generic_shutdown_super+0x64/0x110
[ 5252.115850]  kill_block_super+0x21/0x50
[ 5252.116873]  deactivate_locked_super+0x34/0x60
[ 5252.118631]  cleanup_mnt+0x3b/0x70
[ 5252.119976]  task_work_run+0x79/0xb0
[ 5252.121235]  exit_to_usermode_loop+0x93/0xa0
[ 5252.122822]  syscall_return_slowpath+0x116/0x130
[ 5252.123673]  entry_SYSCALL_64_fastpath+0x94/0x96
[ 5252.124420] RIP: 0033:0x7f6b182c3447
[ 5252.125031] RSP: 002b:00007ffc28f4f9a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 5252.126368] RAX: 0000000000000000 RBX: 0000000001612060 RCX: 00007f6b182c3447
[ 5252.127980] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000016212d0
[ 5252.129118] RBP: 00000000016212d0 R08: 00626174752f746e R09: 0000000000000013
[ 5252.130149] R10: 00000000000006b2 R11: 0000000000000246 R12: 00007f6b187cc83c
[ 5252.131136] R13: 0000000000000000 R14: 0000000001612240 R15: 00007ffc28f4fc30
[ 5252.131967] Code: d0 f0 0f b1 33 39 c2 75 db eb 9e 66 66 66 66 90 66 66 66 66 90 ba 01 00 00 00 8b 07 85 c0 75 09 f0 0f b1 17 85 c0 75 f2 c3 f3 90 <eb> ed 81 fe 00 01 00 00 0f 84 c3 00 00 00 41 b8 01 01 00 00 b9 
[ 5255.997093] watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [kworker/1:2:16598]
[ 5256.002430] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c dax_pmem nd_pmem device_dax sch_fq_codel af_packet [last unloaded: scsi_debug]
[ 5256.005592] irq event stamp: 33538
[ 5256.006221] hardirqs last  enabled at (33537): [<ffffffff816b9759>] _raw_spin_unlock_irq+0x29/0x50
[ 5256.008123] hardirqs last disabled at (33538): [<ffffffff816b10ae>] __schedule+0x9e/0xb10
[ 5256.009762] softirqs last  enabled at (29032): [<ffffffff816bde80>] __do_softirq+0x230/0x4ee
[ 5256.011363] softirqs last disabled at (28985): [<ffffffff810905da>] irq_exit+0xca/0xd0
[ 5256.012871] CPU: 1 PID: 16598 Comm: kworker/1:2 Tainted: G      D W    L   4.15.0-rc1-djw #7
[ 5256.014347] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5256.016175] Workqueue: xfs-reclaim/pmem4 xfs_reclaim_worker [xfs]
[ 5256.017506] task: ffff88003dc0c000 task.stack: ffffc90007fe0000
[ 5256.018735] RIP: 0010:queued_spin_lock_slowpath+0xf/0x1d0
[ 5256.019843] RSP: 0018:ffffc90007fe3bf0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff11
[ 5256.021334] RAX: 0000000000000001 RBX: ffff880077cba240 RCX: 0000000000000000
[ 5256.026306] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880077cba240
[ 5256.027486] RBP: ffff880077cba240 R08: 0000000000000001 R09: 0000000000000000
[ 5256.029052] R10: ffff88003dc0c000 R11: 0000000000000000 R12: 0000000000000008
[ 5256.030757] R13: ffff880077cba240 R14: ffff880077cba200 R15: ffff88003bde4000
[ 5256.032333] FS:  0000000000000000(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
[ 5256.034110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5256.035362] CR2: 00007f274c41f710 CR3: 0000000077ee8000 CR4: 00000000000006e0
[ 5256.036935] Call Trace:
[ 5256.037586]  do_raw_spin_lock+0xad/0xb0
[ 5256.038320]  _raw_spin_lock+0x55/0x70
[ 5256.039349]  xfs_iflush_abort+0xdc/0x140 [xfs]
[ 5256.040155]  xfs_reclaim_inode+0x405/0x5c0 [xfs]
[ 5256.041291]  xfs_reclaim_inodes_ag+0x327/0x7e0 [xfs]
[ 5256.042495]  xfs_reclaim_worker+0x2b/0x40 [xfs]
[ 5256.043531]  process_one_work+0x213/0x690
[ 5256.044478]  worker_thread+0x4d/0x3e0
[ 5256.045371]  kthread+0x141/0x180
[ 5256.046122]  ? process_one_work+0x690/0x690
[ 5256.047079]  ? kthread_delayed_work_timer_fn+0x90/0x90
[ 5256.048008]  ret_from_fork+0x24/0x30
[ 5256.048981] Code: 87 45 00 48 85 c0 75 d6 f3 90 8b 03 39 c2 75 e5 89 d0 f0 0f b1 33 39 c2 75 db eb 9e 66 66 66 66 90 66 66 66 66 90 ba 01 00 00 00 <8b> 07 85 c0 75 09 f0 0f b1 17 85 c0 75 f2 c3 f3 90 eb ed 81 fe 
