Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E24714EC47
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 23:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120949; cv=none; b=ar6S/73KAYsh8h143B73xHOXtnnlGAd+Cc6qQ9OK4bR+aYbsThdG6n2p8L65G8wd0nd77+vTvYQjFG2BTMmQ/vwQHN+52MDhUiF+DgN4w8qEmBFzscRAoUuQVhGNXLK6BLXIg0JLn8vaGBQFg7iG4AHoTpkUlIS0CGLIAmKy/s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120949; c=relaxed/simple;
	bh=mVE0l1hRwBDS/FZtpe0sXBUiTBSJha3jv4Akusym25g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PLifm7XTxQZEQSbQOUNuQ+p0OhvttB/p0eZZ9+krMdrh0n5T8gyCvdyiICR4PVDIdC1x2C2f1wHR9g+me/8/roO3FBSy+GKyfZRkhq7CSp2icJBbZBc2XpwQgn5cF4qbh4uMY+6L+AwHPnokLPczXbmzU67ogWAaefufvVheJY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3c5a6c5e1so4507665ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 16:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729120947; x=1729725747;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nbtPBNOsMBhRrfsUYqjp/D614SNfpBqJ7uG2QiYsvQA=;
        b=aT2UQpwCMmq+JbK8ED9rzHPjt+rEH8gTxYz2C7FWTrX89BJPJzf+fof4bqIEmEOXht
         At3c3q93dqUsdOnSspjbHyfUoP8nld4wT9wjOWYnYogdCEQYdqQMysU5oHZaxlX5lIWB
         gAFx+BrZQ4UivaFqmFP71y0tJ5BIKTlxB/IXPKEs7cxx/q9SvInVS/4ZSYx7RMtqLogO
         FcI33QeJffSE9HT8bMgf5lKZ1WpW6AieSX4RNSX04NGgeNg1QZBSUNd6VaUBYMEIqork
         yD4Xn4LIGDmob2t0kRS3c8defqCFoofSS0mCSFCwS93FLF7aSTifwdIcURMofy6M6Ze0
         ZfWg==
X-Forwarded-Encrypted: i=1; AJvYcCUuRZNyyiFOASNfH0ljuU8S7Hoek89/NADyYqmMJ743fkIxjH6/CnnE5CvMg4ztXQ1cyjdhMUL7Bak=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGfxq9/ezmIbNPNtgKCBj8Fmi7ChCiMds+d5yw5Feh9/PDWMdI
	yToIjB3fzJuHoHmuxbHHG0sTNw5K4r6/aidz6W59oXmjJoNIKbxww2qdLJETH4GFRhcWj8B1Fdl
	M+eh7xAwXzIYpURCHgv4yZRrlJCfsB2HLho0IlpKP8xuWtO3Jnn2zUF0=
X-Google-Smtp-Source: AGHT+IF0Z9/TtTiy8unpNEcLnO8CgOACIjGn47ZfVzHjXJbB0BCJtpz3T25UeW8XeFU70EuzF3AJdIxNGt99Na5fG7Kvo3mYSnLG
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c241:0:b0:3a0:8f20:36e7 with SMTP id
 e9e14a558f8ab-3a3b5fb649bmr200318245ab.19.1729120947034; Wed, 16 Oct 2024
 16:22:27 -0700 (PDT)
Date: Wed, 16 Oct 2024 16:22:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67104ab3.050a0220.d9b66.0175.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_ail_push_all_sync (2)
From: syzbot <syzbot+611be8174be36ca5dbc9@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    09f6b0c8904b Merge tag 'linux_kselftest-fixes-6.12-rc3' of..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14af3fd0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7cd9e7e4a8a0a15b
dashboard link: https://syzkaller.appspot.com/bug?extid=611be8174be36ca5dbc9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c7705f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d2fb27980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-09f6b0c8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3844cfd6d6b9/vmlinux-09f6b0c8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8752e101c1ff/bzImage-09f6b0c8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5410decf46fa/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+611be8174be36ca5dbc9@syzkaller.appspotmail.com

INFO: task syz-executor279:5128 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc2-syzkaller-00291-g09f6b0c8904b #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor279 state:D stack:25488 pid:5128  tgid:5105  ppid:5102   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5322 [inline]
 __schedule+0x1895/0x4b30 kernel/sched/core.c:6682
 __schedule_loop kernel/sched/core.c:6759 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6774
 xfs_ail_push_all_sync+0x236/0x310 fs/xfs/xfs_trans_ail.c:726
 xfs_log_quiesce+0xdf/0x5b0 fs/xfs/xfs_log.c:1018
 xfs_fs_freeze+0x8d/0x1a0 fs/xfs/xfs_super.c:936
 freeze_super+0x81b/0xee0 fs/super.c:2107
 fs_bdev_freeze+0x1ac/0x320 fs/super.c:1484
 bdev_freeze+0xd6/0x220 block/bdev.c:257
 xfs_fs_goingdown+0xa9/0x160 fs/xfs/xfs_fsops.c:446
 xfs_file_ioctl+0x12e5/0x1a30 fs/xfs/xfs_ioctl.c:1343
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f70924b2539
RSP: 002b:00007f709243f168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f709253c6d8 RCX: 00007f70924b2539
RDX: 0000000020000080 RSI: 000000008004587d RDI: 0000000000000005
RBP: 00007f709253c6d0 R08: 00007f709243f6c0 R09: 0000000000000000
R10: 00007f709243f6c0 R11: 0000000000000246 R12: 00007f709253c6dc
R13: 000000000000006e R14: 00007ffd410540a0 R15: 00007ffd41054188
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/25:
 #0: ffffffff8e937de0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937de0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937de0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
2 locks held by getty/4897:
 #0: ffff88801e2510a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000039b2f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz-executor279/5128:
 #0: ffff888031ccc6b0 (&bdev->bd_fsfreeze_mutex){+.+.}-{3:3}, at: bdev_freeze+0x2a/0x220 block/bdev.c:248
 #1: ffff888011c84420 (sb_writers#10){++++}-{0:0}, at: sb_wait_write fs/super.c:1896 [inline]
 #1: ffff888011c84420 (sb_writers#10){++++}-{0:0}, at: freeze_super+0x4e9/0xee0 fs/super.c:2085
 #2: ffff888011c840e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #2: ffff888011c840e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #2: ffff888011c840e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: freeze_super+0x4f1/0xee0 fs/super.c:2086
 #3: ffff888011c84518 (sb_pagefaults#2){+.+.}-{0:0}, at: sb_wait_write fs/super.c:1896 [inline]
 #3: ffff888011c84518 (sb_pagefaults#2){+.+.}-{0:0}, at: freeze_super+0x519/0xee0 fs/super.c:2090
 #4: ffff888011c84610 (sb_internal#2){++++}-{0:0}, at: sb_wait_write fs/super.c:1896 [inline]
 #4: ffff888011c84610 (sb_internal#2){++++}-{0:0}, at: freeze_super+0x7cc/0xee0 fs/super.c:2104

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 25 Comm: khungtaskd Not tainted 6.12.0-rc2-syzkaller-00291-g09f6b0c8904b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
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
