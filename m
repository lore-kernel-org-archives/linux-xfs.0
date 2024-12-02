Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F2713AA35
	for <linux-xfs@vger.kernel.org>; Mon,  2 Dec 2024 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733147011; cv=none; b=SD7Qyn/QNzVMuiIBGZhJIMTBqgzD+FepSn/z6afO66omyUnODSUXMhfFOBBf9q77cIfmLNjpYQILF6n8XNEDPVcGi8q3yl252lu6HAq0f0T+6Po3Z1NpCBC3/ciV6wPN99SBUQRFQawPbZaUybJJUHMScr4dc45CMITlL1ygBVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733147011; c=relaxed/simple;
	bh=5pmKYlpLxzvlS9JAnQH5MCmhwKMJcSmxx/KP5fCt9A0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rjFkkrlWKpczm5QPcX9oKINXfryyJTddTVt5oTUW7/ElUxmxrUd695/8FZeBIIK2gPJ13LVhRJdS+jfy/yx0sfAPaj+OKDJd/4i8dFs4ZCuRyeX72uQcWQa0Q72iDCfNSs2Vm2D6vTUd2OsWzDDpCqBbJQUrVfFgKXxYczqeM0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-841896ec108so438365339f.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2024 05:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733147008; x=1733751808;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vboPoXwRv5cDI32OSmx/NfQx+rdINON0MH0jUkQibms=;
        b=B/q05RDTckaVTVLzz+5iJXHz4MElEh16C6apNqSFdFYthJqNegeYQEfNmkAnuJaU7a
         9UHI1YJeUoL8Bfj3MZqZOcZpoQ/EPpa7ktd4e3XaMnjCPZJpgXS85MgGU5i5jqfZpeig
         E81oHxqu8iIkL+A9dAWnw2ywsQazyOWQuQN3I8sPWrmzaIKjhoGAzztRFxz9mL5o2sa3
         7TMTwnYCSc4ylAeD09RczK1QK8w2uR/DphTZxER2qPsXwbYRBSWAuok3AZX/zSPRG/Jz
         QS9fkCgmon3yr7FrX3xpKwARtb7IVvdXJ44nBLzbES6umnR/CwAvHZIVXCX13LGK7yWB
         CxyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLPu7d+glQAq5cKQnlpTh1/dJPcoZLYNJS4tvsvkAoaa9Ds1jl5g/SLDJQ2O40Y47ANP0VgfCl750=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdCwleH4wAEYf1HtoyHm806akAp6XjzgcwLsqVOcm2IyFQPoHc
	eaurdmxYNp+Ss2u5f4X/+376Y8Byu9dzqoH8XHJgsrfks3SQ8clRgtmYGpccsCn3Sqa5QgtxcMg
	AOm5ZQMwG047O0+NxcN/TeB0K6pVyPpB7jZxd7LamM0zdpxPm3HQcmKs=
X-Google-Smtp-Source: AGHT+IGKzHQpciWn6xyEXZAsSfL5OcyDYM+FQ4UCKFX4N86xBiXvgkxLUHEN7OaG1ljKAVKJc2ExyJcZsfxwTB1hJecUAWnkL4Qs
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1caf:b0:3a7:6f5a:e5c7 with SMTP id
 e9e14a558f8ab-3a7c5528576mr233302965ab.4.1733147008652; Mon, 02 Dec 2024
 05:43:28 -0800 (PST)
Date: Mon, 02 Dec 2024 05:43:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674db980.050a0220.ad585.0052.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_ail_push_all_sync (3)
From: syzbot <syzbot+92fbc8b664c9bbc40bf6@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cem@kernel.org, chandan.babu@oracle.com, 
	djwong@kernel.org, hch@lst.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f486c8aa16b8 Add linux-next specific files for 20241128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1786f1e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e348a4873516af92
dashboard link: https://syzkaller.appspot.com/bug?extid=92fbc8b664c9bbc40bf6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122c1f5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13978f78580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/beb58ebb63cf/disk-f486c8aa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b241b5609e64/vmlinux-f486c8aa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c9d817f665f2/bzImage-f486c8aa.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/fe4e6f4f2b2f/mount_0.gz

The issue was bisected to:

commit 3eb96946f0be6bf447cbdf219aba22bc42672f92
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed May 24 06:05:38 2023 +0000

    block: make bio_check_eod work for zero sized devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a5c7c0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a5c7c0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15a5c7c0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92fbc8b664c9bbc40bf6@syzkaller.appspotmail.com
Fixes: 3eb96946f0be ("block: make bio_check_eod work for zero sized devices")

INFO: task syz-executor901:5953 blocked for more than 143 seconds.
      Not tainted 6.12.0-next-20241128-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor901 state:D stack:25656 pid:5953  tgid:5899  ppid:5854   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x1850/0x4c30 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 xfs_ail_push_all_sync+0x236/0x310 fs/xfs/xfs_trans_ail.c:726
 xfs_log_quiesce+0xdf/0x5b0 fs/xfs/xfs_log.c:1018
 xfs_fs_freeze+0x8d/0x1a0 fs/xfs/xfs_super.c:940
 freeze_super+0x81b/0xee0 fs/super.c:2121
 fs_bdev_freeze+0x1ac/0x320 fs/super.c:1484
 bdev_freeze+0xd6/0x220 block/bdev.c:257
 xfs_fs_goingdown+0xa9/0x160 fs/xfs/xfs_fsops.c:442
 xfs_file_ioctl+0x1312/0x1b20 fs/xfs/xfs_ioctl.c:1360
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f417e96c189
RSP: 002b:00007f417e8f3168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f417e9fc4b8 RCX: 00007f417e96c189
RDX: 0000000020000080 RSI: 000000008004587d RDI: 0000000000000004
RBP: 00007f417e9fc4b0 R08: 00007ffc4da61c37 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f417e9fc4bc
R13: 000000000000006e R14: 00007ffc4da61b50 R15: 00007ffc4da61c38
 </TASK>
INFO: task syz-executor901:5954 blocked for more than 143 seconds.
      Not tainted 6.12.0-next-20241128-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor901 state:D stack:24688 pid:5954  tgid:5901  ppid:5852   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x1850/0x4c30 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 xfs_ail_push_all_sync+0x236/0x310 fs/xfs/xfs_trans_ail.c:726
 xfs_log_quiesce+0xdf/0x5b0 fs/xfs/xfs_log.c:1018
 xfs_fs_freeze+0x8d/0x1a0 fs/xfs/xfs_super.c:940
 freeze_super+0x81b/0xee0 fs/super.c:2121
 fs_bdev_freeze+0x1ac/0x320 fs/super.c:1484
 bdev_freeze+0xd6/0x220 block/bdev.c:257
 xfs_fs_goingdown+0xa9/0x160 fs/xfs/xfs_fsops.c:442
 xfs_file_ioctl+0x1312/0x1b20 fs/xfs/xfs_ioctl.c:1360
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f417e96c189
RSP: 002b:00007f417e8f3168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f417e9fc4b8 RCX: 00007f417e96c189
RDX: 0000000020000080 RSI: 000000008004587d RDI: 0000000000000004
RBP: 00007f417e9fc4b0 R08: 00007ffc4da61c37 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f417e9fc4bc
R13: 000000000000006e R14: 00007ffc4da61b50 R15: 00007ffc4da61c38
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937b20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937b20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937b20 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
1 lock held by klogd/5196:
 #0: ffff8880b873e8d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
2 locks held by getty/5600:
 #0: ffff8880353b20a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz-executor901/5953:
 #0: ffff888148c8ddb0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x2a/0x220 block/bdev.c:248
 #1: ffff8880660c8420 (sb_writers#11){++++}-{0:0}, at: sb_wait_write fs/super.c:1910 [inline]
 #1: ffff8880660c8420 (sb_writers#11){++++}-{0:0}, at: freeze_super+0x4e9/0xee0 fs/super.c:2099
 #2: ffff8880660c80e0 (&type->s_umount_key#45){+.+.}-{4:4}, at: __super_lock fs/super.c:56 [inline]
 #2: ffff8880660c80e0 (&type->s_umount_key#45){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:71 [inline]
 #2: ffff8880660c80e0 (&type->s_umount_key#45){+.+.}-{4:4}, at: freeze_super+0x4f1/0xee0 fs/super.c:2100
 #3: ffff8880660c8518 (sb_pagefaults){+.+.}-{0:0}, at: sb_wait_write fs/super.c:1910 [inline]
 #3: ffff8880660c8518 (sb_pagefaults){+.+.}-{0:0}, at: freeze_super+0x519/0xee0 fs/super.c:2104
 #4: ffff8880660c8610 (sb_internal#2){++++}-{0:0}, at: sb_wait_write fs/super.c:1910 [inline]
 #4: ffff8880660c8610 (sb_internal#2){++++}-{0:0}, at: freeze_super+0x7cc/0xee0 fs/super.c:2118
5 locks held by syz-executor901/5954:
 #0: ffff888148c8c6b0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x2a/0x220 block/bdev.c:248
 #1: ffff8880661e0420 (sb_writers#11){++++}-{0:0}, at: sb_wait_write fs/super.c:1910 [inline]
 #1: ffff8880661e0420 (sb_writers#11){++++}-{0:0}, at: freeze_super+0x4e9/0xee0 fs/super.c:2099
 #2: ffff8880661e00e0 (&type->s_umount_key#45){+.+.}-{4:4}, at: __super_lock fs/super.c:56 [inline]
 #2: ffff8880661e00e0 (&type->s_umount_key#45){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:71 [inline]
 #2: ffff8880661e00e0 (&type->s_umount_key#45){+.+.}-{4:4}, at: freeze_super+0x4f1/0xee0 fs/super.c:2100
 #3: ffff8880661e0518 (sb_pagefaults){+.+.}-{0:0}, at: sb_wait_write fs/super.c:1910 [inline]
 #3: ffff8880661e0518 (sb_pagefaults){+.+.}-{0:0}, at: freeze_super+0x519/0xee0 fs/super.c:2104
 #4: ffff8880661e0610 (sb_internal#2){++++}-{0:0}, at: sb_wait_write fs/super.c:1910 [inline]
 #4: ffff8880661e0610 (sb_internal#2){++++}-{0:0}, at: freeze_super+0x7cc/0xee0 fs/super.c:2118

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-next-20241128-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 3556 Comm: kworker/u8:10 Not tainted 6.12.0-next-20241128-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:kasan_check_range+0x5/0x290 mm/kasan/generic.c:188
Code: 8e e8 ff 89 e1 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 55 <41> 57 41 56 41 54 53 b0 01 48 85 f6 0f 84 a0 01 00 00 4c 8d 04 37
RSP: 0018:ffffc9000cac7760 EFLAGS: 00000046
RAX: 000000000000001d RBX: 0000000000000759 RCX: ffffffff817abd42
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff942c4968
RBP: 0000000000000000 R08: ffffffff942c4967 R09: 1ffffffff285892c
R10: dffffc0000000000 R11: fffffbfff285892d R12: 0000000000000001
R13: ffff8880323cc728 R14: 0000000000000001 R15: ffff8880323cc728
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cd011df600 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 hlock_class kernel/locking/lockdep.c:228 [inline]
 check_wait_context kernel/locking/lockdep.c:4875 [inline]
 __lock_acquire+0x8a2/0x2100 kernel/locking/lockdep.c:5176
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 batadv_iv_ogm_slide_own_bcast_window net/batman-adv/bat_iv_ogm.c:754 [inline]
 batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:825 [inline]
 batadv_iv_ogm_schedule+0x43f/0x10a0 net/batman-adv/bat_iv_ogm.c:868
 batadv_iv_send_outstanding_bat_ogm_packet+0x6fe/0x810 net/batman-adv/bat_iv_ogm.c:1712
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
