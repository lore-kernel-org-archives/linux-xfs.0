Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F3318054
	for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2024 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723886368; cv=none; b=ZFIXXjsCmrB4GkRjSkSCmGcqlEi+IEYmocQLUf7c6B4e+q/dSZBj0EX4KGb+/SdtNW6IBMkPQbDta3zNpd1kwYkbLcoAwd2ZIE0f63nQpfyfSnNI3pn9N+emANzK1CTsOXQHO7UYBHkESw6RKWjo08UKcmm/lJPtXHo6h9abVkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723886368; c=relaxed/simple;
	bh=vpcmRl/W4p8+UODTFw6j8VCM5Us1mI9yW8bBsDPddck=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mkgEYORktSVPhlci3OnMlmMsC/H3pwbPMH3LKgoKdg11B2v/qi63SAUUcMxMMiFZrGJs94Uvkc1iBGvWG/1k5uyPOUFq1CMcNPGAeWjLMsw9U7Dypbq6TFI3ChzElZCsxFwb+uB5fjKX4XCPU2BKGO6QwutHil+gSNtTPEcbpVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f9612b44fso275814139f.2
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2024 02:19:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723886366; x=1724491166;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNl35BQjE8M/Tgi/3EJbgjcmDElQtXYQ4UAyZjNv/pw=;
        b=p4umRe4fu2PTMmku8XEUv7qOVVvt/sG3+Ncq/bsKGN96u5L9+vtV42nyKnbEatAhiS
         k5E7lEIF87chgb387HoEj125xzWtJHwp5Q41eH/Wwxsbwu9tLFpeDIt1C2PTQ9pQkrrl
         Dz9yxCAKZR8lrHi/4gRYTaXzkH6+HrYTGfRk4AVhD3SXC6WqcwYphZJCAkPX1hvrQKkH
         DFrFmjit0HD+T9p6RpF6GrUueqzCu09tdbXDhUrT6Nbb8O0xZt5AA2ofpHSw8tUI3o2A
         vEZKMO70pBCUnoRYKB1vS2oFvxnmhEAb2VLAgvHexdsos2akpnRcX6nE7JTFI1YVni/7
         eEFg==
X-Forwarded-Encrypted: i=1; AJvYcCU3TrDD1GyyIUJZ+rXO6OJrRIT7S1XegQrvffz7R/bbskeX0lOIIeMztaqY2z1q/z4j98mQNVVc3qfRWHT5Gg3B0lYeFDFXP4rw
X-Gm-Message-State: AOJu0YzHoLR1PDZEXxpc0W8MJ4Xiok/WxA1DBFGQ6J+858ygdQTISPtk
	T0hhbRQB8DiIV6/B3weYvPeAV/QG9OQFLbgjXgGdxY5iyeoOI2Ej7rqgKiutnDWbMauvgRqjYqP
	CyseeEPG3a+QcXWJ5ox0EE8x2chAVmZ0EQ5B8Ejc0OmHY2XqbPUlpAsk=
X-Google-Smtp-Source: AGHT+IF9vRnf3SVvEf3IvazTKSvrzIrZ4ABOW7XVww69GYzFsWr0oq1yKTJuTQPOAOuBvyBLJmT9lASkBhGsm+Y6xLmibGgw39Gf
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fcb:b0:7f6:85d1:f82d with SMTP id
 ca18e2360f4ac-824f260adffmr8258439f.1.1723886366033; Sat, 17 Aug 2024
 02:19:26 -0700 (PDT)
Date: Sat, 17 Aug 2024 02:19:26 -0700
In-Reply-To: <0000000000008905bf061fc61371@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b1868061fdd9253@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin (2)
From: syzbot <syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    85652baa895b Merge tag 'block-6.11-20240824' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1245bf13980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=92c0312151c4e32e
dashboard link: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12350ad5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147927c5980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f48bb8a1e215/disk-85652baa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a4eced38e143/vmlinux-85652baa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3d21ddc8de52/bzImage-85652baa.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5578e92bb7fe/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com

INFO: task kworker/0:1H:43 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc3-syzkaller-00271-g85652baa895b #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:1H    state:D stack:26736 pid:43    tgid:43    ppid:2      flags:0x00004000
Workqueue: xfs-log/loop0 xlog_ioend_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2557
 ___down_common kernel/locking/semaphore.c:225 [inline]
 __down_common+0x343/0x7f0 kernel/locking/semaphore.c:246
 down+0x84/0xc0 kernel/locking/semaphore.c:63
 xfs_buf_lock+0x164/0x510 fs/xfs/xfs_buf.c:1196
 xfs_buf_item_unpin+0x1dd/0x710 fs/xfs/xfs_buf_item.c:582
 xlog_cil_committed+0x82f/0xf00 fs/xfs/xfs_log_cil.c:910
 xlog_cil_process_committed+0x15c/0x1b0 fs/xfs/xfs_log_cil.c:941
 xlog_state_shutdown_callbacks+0x2ba/0x3b0 fs/xfs/xfs_log.c:487
 xlog_force_shutdown+0x32c/0x390 fs/xfs/xfs_log.c:3530
 xlog_ioend_work+0xad/0x100 fs/xfs/xfs_log.c:1244
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task syz-executor224:5234 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc3-syzkaller-00271-g85652baa895b #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor224 state:D stack:22224 pid:5234  tgid:5234  ppid:5232   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 xlog_wait fs/xfs/xfs_log_priv.h:587 [inline]
 xlog_wait_on_iclog+0x501/0x770 fs/xfs/xfs_log.c:840
 xlog_force_lsn+0x523/0x9e0 fs/xfs/xfs_log.c:3066
 xfs_log_force_seq+0x1da/0x450 fs/xfs/xfs_log.c:3103
 __xfs_trans_commit+0xb98/0x1290 fs/xfs/xfs_trans.c:900
 xfs_sync_sb_buf+0x2dc/0x370 fs/xfs/libxfs/xfs_sb.c:1178
 xfs_ioc_setlabel fs/xfs/xfs_ioctl.c:1143 [inline]
 xfs_file_ioctl+0x165b/0x19e0 fs/xfs/xfs_ioctl.c:1298
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f816deedc99
RSP: 002b:00007fff94625058 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000020000100 RCX: 00007f816deedc99
RDX: 0000000020000340 RSI: 0000000041009432 RDI: 0000000000000006
RBP: 00007f816df6a5f0 R08: 00005555629df4c0 R09: 00005555629df4c0
R10: 00005555629df4c0 R11: 0000000000000246 R12: 00007fff94625080
R13: 00007fff946252a8 R14: 431bde82d7b634db R15: 00007f816df3603b
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:326 [inline]
 #0: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6626
2 locks held by kworker/0:1H/43:
 #0: ffff888022723148 ((wq_completion)xfs-log/loop0){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888022723148 ((wq_completion)xfs-log/loop0){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90000b37d00 ((work_completion)(&iclog->ic_end_io_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90000b37d00 ((work_completion)(&iclog->ic_end_io_work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
2 locks held by getty/4972:
 #0: ffff8880303d20a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031332f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ac/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by syz-executor224/5234:
 #0: ffff8880118c2420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write_file+0x61/0x200 fs/namespace.c:559

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-rc3-syzkaller-00271-g85652baa895b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 1057 Comm: kworker/u8:5 Not tainted 6.11.0-rc3-syzkaller-00271-g85652baa895b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:preempt_count_add+0x6/0x190 kernel/sched/core.c:5643
Code: 48 8b 3c 24 e8 cb aa 94 00 eb 8c e9 ee fe ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 57 <41> 56 53 89 fb 48 c7 c0 c0 a9 ce 94 48 c1 e8 03 49 bf 00 00 00 00
RSP: 0018:ffffc90003b77498 EFLAGS: 00000002
RAX: 0000000000000002 RBX: ffff8880b933e9c0 RCX: ffffffff94cea903
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: ffffffff813578d1 R09: 1ffff11017267d38
R10: dffffc0000000000 R11: ffffed1017267d39 R12: dffffc0000000000
R13: 00000000fffffabc R14: ffffc90003b77600 R15: ffffffff8e080a48
FS:  0000000000000000(0000) GS:ffff8880b9300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005628b5ca0680 CR3: 000000000e534000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 _raw_spin_lock_nested+0x15/0x40 kernel/locking/spinlock.c:377
 raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:560
 raw_spin_rq_lock kernel/sched/sched.h:1415 [inline]
 _raw_spin_rq_lock_irqsave kernel/sched/sched.h:1435 [inline]
 rq_lock_irqsave kernel/sched/sched.h:1700 [inline]
 sched_balance_update_blocked_averages+0x140/0x16a0 kernel/sched/fair.c:9490
 sched_balance_newidle+0x49a/0xfd0 kernel/sched/fair.c:12412
 pick_next_task_fair+0x27a/0xde0 kernel/sched/fair.c:8582
 __pick_next_task+0xb0/0x2c0 kernel/sched/core.c:5812
 __schedule+0x728/0x4a10 kernel/sched/core.c:6484
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 toggle_allocation_gate+0x16a/0x250 mm/kfence/core.c:835
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.477 msecs


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
