Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0116622D7B0
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760129374; cv=none; b=QQjQX/UDMWtpCFkVPnoUzdYWipYxhMneMDI3IcNPGE+/sKFmWv4K/dRPHmXPxXAOZ7OQQ7btGqKX2nuT0GR+b3f4ERTcTevUXlwNd2Gsl0/T+AiStvi9hAMoxWIyBCl9G9dxt06NTQjSNaXuGxeLeKY6tTnwvkgHaB6bbji3AAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760129374; c=relaxed/simple;
	bh=LuOcPfSJ9LTHTMBgVa909MlLljEs2vtFneSM8MZcR0E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=I379JtXhYzPE9l5rtebHVFznQelNmk3EqVlZHMT2M5gXvfntqKc4p8sFwoCwE04DrPImxZbiBl2AdWNpqx6Ki2HRca60LVWQ/26UqI1j4xx6vZDMcKHmTmipb4i4jcHox6CtPSz1hJgBHyDtvkI2P+yLDOZcNN7qCNc2qLFEbc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-8877131dec5so835648139f.2
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 13:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760129371; x=1760734171;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SrzwkP1t9ialgASTXKix0iA/Jg8yOBt1ydTSj+KQn2U=;
        b=jfNQTYuw6qrKdHeNd5g7SAcKgKlyNgRRLXM0WV8GjrT5QbEiYxE+CYIxPEc+i7RckH
         j2olpP26geFQLMqsikREk5TtXLsplnsksLYgzqF4HTwX5qYUuFvsr/oMPUGZcjMhb5JH
         cLKgIj6neKC6hBC0E36BMnXn6jUtuuI5wOF4tsz7xjwjZ4vWeNIvpeMNvelaBetOWRyk
         /ch1t9ZE2qa9a7thgUq1JTUQG2DRSp2cEtOaKjsOxOPbk3zDHbmCHaCawg5vVlZHWcjp
         LxtO8wK/GriERKmZ6R5Bid+jG7ROQGMxgry29KGty2n/VjpfLzQDB8hA3gZ87G+mWOrQ
         Kj+Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6JLhxXJWw7Q6UQ0ASNaOu0qlh6PgeQuU5sPbB0mGlOkI3pbvKCsJDHMuqZIpfo2vNzxUC4J8XJIc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKXHu3rR7Dgy4/8u7nBSai7L426JNG3OmPX2CGWlpXa6Ht/15d
	r+8zZgO1GLtHbsExDz5GSAbqFl0630OtAZCazU4yD3vWzWGVLQ9lyLD6YHLjm/qxdJW/RtqDAHm
	8gFXAHSnWxf7G0BJAIpODtRdkzEw15AsLEaoiDLuXg/u84llaXkBcyT/Fcww=
X-Google-Smtp-Source: AGHT+IHsdYD+NRDWq7iO1rgoHgx966RxIBaaEHYQ7+fp4VG6Uqzra+7MLF3XSjqNh2G4ck/8NxqRB4dLjGSKIUVjboh+Gfpdv43v
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1514:b0:8fc:2095:302b with SMTP id
 ca18e2360f4ac-93bd191f136mr1739845039f.16.1760129371100; Fri, 10 Oct 2025
 13:49:31 -0700 (PDT)
Date: Fri, 10 Oct 2025 13:49:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e9715b.050a0220.1186a4.000e.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xlog_force_lsn (2)
From: syzbot <syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    971199ad2a0f Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a5e1e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5dad7c03514bf787
dashboard link: https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17be6304580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c431e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6f70cc00930c/disk-971199ad.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5c5740d1a0de/vmlinux-971199ad.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9f306c159d19/bzImage-971199ad.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4027534f1a29/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1495f92f980000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com

INFO: task syz.0.17:6151 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:23560 pid:6151  tgid:6150  ppid:5941   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5325 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6929
 __schedule_loop kernel/sched/core.c:7011 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7026
 xlog_wait fs/xfs/xfs_log_priv.h:588 [inline]
 xlog_wait_on_iclog+0x4ac/0x6f0 fs/xfs/xfs_log.c:841
 xlog_force_lsn+0x4d7/0x970 fs/xfs/xfs_log.c:3045
 xfs_log_force_seq+0x1c9/0x440 fs/xfs/xfs_log.c:3082
 __xfs_trans_commit+0x7d2/0xbd0 fs/xfs/xfs_trans.c:879
 xfs_trans_commit+0x13e/0x1c0 fs/xfs/xfs_trans.c:928
 xfs_sync_sb_buf+0x134/0x230 fs/xfs/libxfs/xfs_sb.c:1472
 xfs_ioc_setlabel fs/xfs/xfs_ioctl.c:1039 [inline]
 xfs_file_ioctl+0x14b2/0x1830 fs/xfs/xfs_ioctl.c:1196
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f601931eec9
RSP: 002b:00007f6018986038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6019575fa0 RCX: 00007f601931eec9
RDX: 00002000000001c0 RSI: 0000000041009432 RDI: 0000000000000004
RBP: 00007f60193a1f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6019576038 R14: 00007f6019575fa0 R15: 00007fffb9cf9fe8
 </TASK>
INFO: task syz.0.17:6177 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:27208 pid:6177  tgid:6150  ppid:5941   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5325 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6929
 __schedule_loop kernel/sched/core.c:7011 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7026
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x319/0x6a0 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 xfs_buf_lock+0x15d/0x4d0 fs/xfs/xfs_buf.c:993
 xfs_buf_item_unpin+0x1d4/0x700 fs/xfs/xfs_buf_item.c:556
 xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:-1 [inline]
 xlog_cil_committed+0x95c/0x1040 fs/xfs/xfs_log_cil.c:897
 xlog_cil_process_committed+0x15c/0x1b0 fs/xfs/xfs_log_cil.c:927
 xlog_state_shutdown_callbacks+0x269/0x360 fs/xfs/xfs_log.c:488
 xlog_force_shutdown+0x332/0x400 fs/xfs/xfs_log.c:3520
 xfs_do_force_shutdown+0x283/0x640 fs/xfs/xfs_fsops.c:517
 xfs_fs_goingdown+0x71/0x150 fs/xfs/xfs_fsops.c:-1
 xfs_file_ioctl+0x11be/0x1830 fs/xfs/xfs_ioctl.c:1371
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f601931eec9
RSP: 002b:00007f6018965038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6019576090 RCX: 00007f601931eec9
RDX: 0000200000000080 RSI: 000000008004587d RDI: 0000000000000005
RBP: 00007f60193a1f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6019576128 R14: 00007f6019576090 R15: 00007fffb9cf9fe8
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/38:
 #0: ffffffff8d7aa500 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8d7aa500 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8d7aa500 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/1:1/44:
 #0: ffff88805b739138 ((wq_completion)xfs-sync/loop6){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff88805b739138 ((wq_completion)xfs-sync/loop6){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc90000b57ba0 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc90000b57ba0 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
2 locks held by kworker/u8:4/70:
 #0: ffff888055624138 ((wq_completion)xfs-cil/loop6){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff888055624138 ((wq_completion)xfs-cil/loop6){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc9000155fba0 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc9000155fba0 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
3 locks held by kworker/0:2/1245:
2 locks held by getty/5563:
 #0: ffff88823bf320a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e832e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x444/0x1400 drivers/tty/n_tty.c:2222
1 lock held by syz.0.17/6151:
 #0: ffff888029a28480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.2.33/6264:
 #0: ffff888050c54480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.1.34/6276:
 #0: ffff8880551d2480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.3.80/6795:
 #0: ffff888056592480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.6.61/6859:
 #0: ffff888039de8480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.5.113/7166:
 #0: ffff8880365f0480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.4.127/7342:
 #0: ffff88802bb78480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.8.104/7367:
 #0: ffff888039d14480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.7.171/7768:
 #0: ffff888067dbc480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
1 lock held by syz.9.185/7887:
 #0: ffff88806ddf0480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:552
4 locks held by syz.2.319/8216:
1 lock held by syz.6.321/8222:
5 locks held by syz.0.323/8224:
1 lock held by syz-executor/8227:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 38 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
 watchdog+0xf60/0xfa0 kernel/hung_task.c:495
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4b9/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 1245 Comm: kworker/0:2 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Workqueue: events_power_efficient wg_ratelimiter_gc_entries
RIP: 0010:__lock_acquire+0x818/0xd20 kernel/locking/lockdep.c:-1
Code: 8d 48 89 de e8 d9 b7 1c 03 eb c2 44 89 e0 25 ff 1f 00 00 41 c1 ec 03 41 81 e4 00 60 00 00 41 09 c4 4c 89 f9 48 c1 e9 20 89 ca <c1> c2 04 41 29 cc 44 31 e2 44 01 f9 41 29 d7 89 d6 c1 c6 06 44 31
RSP: 0000:ffffc90005177770 EFLAGS: 00000803
RAX: 0000000000000b53 RBX: 0000000000000003 RCX: 000000008c3c8419
RDX: 000000008c3c8419 RSI: ffff888026bd47d8 RDI: ffff888026bd3c00
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8ac7bb0a
R10: dffffc0000000000 R11: fffffbfff1deecaf R12: 0000000000000b53
R13: ffff888026bd4760 R14: ffff888026bd47d8 R15: 8c3c8419ff0f723d
FS:  0000000000000000(0000) GS:ffff888126bcd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4515835613 CR3: 0000000071142000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
 rtlock_slowlock kernel/locking/rtmutex.c:1894 [inline]
 rtlock_lock kernel/locking/spinlock_rt.c:43 [inline]
 __rt_spin_lock kernel/locking/spinlock_rt.c:49 [inline]
 rt_spin_lock+0x14a/0x3e0 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:44 [inline]
 wg_ratelimiter_gc_entries+0x5d/0x480 drivers/net/wireguard/ratelimiter.c:63
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4b9/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
