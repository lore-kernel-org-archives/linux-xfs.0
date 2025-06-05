Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D3A27A112
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749146131; cv=none; b=hcjL2hVMRXjm8uz5patyPc3p78et/1RXuJPzhLNYcT85HYaDGHQItgzDqv8DI4J7EHEraWBTOahd6X8X4R06sruWEFdITEFNY9fQyh8ANECFFHxqpbgUdAnvvPvfD74aXuHHuGy+mpMlmUgtNnOZoL8yO9vtAk2DKX3tJ+9gptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749146131; c=relaxed/simple;
	bh=wdDha2tCb/d4mPaMwyCoEIobXZ4/2AN4XR3pnZ+g6is=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f2H4TeNJ4CKxd2ie9PqWSadU8WIInDr71QLDQdN1glitlCeQFfDr5TcQLml8quKb3Bvbd2fwAe0ozMYvworRvCWk1Vg1w4ECz8yq3qPIudB9UmoPXHplRY5B9kwCwKVizOD7IywJeR2KrG/3Nq2rLadnKosy8FjB4SIj/NrP+fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddb4a92e80so17634705ab.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jun 2025 10:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749146128; x=1749750928;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LqH8M9rtmVG9L5l4qcJ/6jdyJmDhCB1Emg0U2+eybck=;
        b=VYlvnnyrUN/KcwnQZHQBeKOlT/e8e3nYeHjzk8UQpDaA9YJW3jJN7w0CuxeSA47Bee
         LPP9WSTyR1ccM8R5MgwobVyjud57UOz/dfK9H/4EnIXc8PzJy/F6XHS2KlOOaPRJoyTF
         G9Uu8KvxSSkUWSeUSfeGXAtECAHMjhR6SRzFivfIT4vX2a9ha/+7+CCWAlI6rVQJBsFl
         v6rXjbz2dbewlG9AHpxoeuBWlXal3ONuj9i22JEhufkVIv+/iNCR45fpVtuUsV5D2hJ3
         EQeus5atYrwSgbAy3iz4DhEoFLLahqN2JwaUzUPYEevy7rMy3yFE49k92DPWEIfhtd9t
         OJCg==
X-Forwarded-Encrypted: i=1; AJvYcCX8e8UmLGvUwpS/5LupVSBQNL9SYGPyvXD/eKZnFqHTZz1yY2MoZBqKJwnu9rJAKsxwOWJI0kMlUBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR4yh2kEzTktw4wL6MIcERNbmWLseGwrt8uDz8cgFpmDuEgL4m
	0wBN/57iDargQhTnW9cC8+4cZ3eC8jZT/d2BfMzBjEhRiH6IvC4VoCEmVRwIa0TEy0rVz9Sm0rc
	uP8WS49K3RZbRBAaYxrF5Jp5Oyj7PtrO8bH85A7opmZIjr7crt9IAnDSgzFM=
X-Google-Smtp-Source: AGHT+IGUIFaN0Ed7oEimCPfzUTydN/3lDXwGywsbsE3iYRCX0x2c3hLg6yedQiLsHAolVfsPoaHLZBxs9Ueh7Jhx8jHsSkEaVEx+
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc4:b0:3dd:babf:9b00 with SMTP id
 e9e14a558f8ab-3ddce3ea2efmr5725905ab.1.1749146128339; Thu, 05 Jun 2025
 10:55:28 -0700 (PDT)
Date: Thu, 05 Jun 2025 10:55:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6841da10.a00a0220.68b4a.0018.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in vfs_setxattr (7)
From: syzbot <syzbot+3d0a18cd22695979a7c6@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3a83b350b5be Add linux-next specific files for 20250530
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1798600c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28859360c84ac63d
dashboard link: https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138db00c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e18e458d13c9/disk-3a83b350.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a1c40854811c/vmlinux-3a83b350.xz
kernel image: https://storage.googleapis.com/syzbot-assets/571f670b130a/bzImage-3a83b350.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b3f387ffeadc/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=131e4c82580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d0a18cd22695979a7c6@syzkaller.appspotmail.com

INFO: task syz.4.173:7853 blocked for more than 143 seconds.
      Not tainted 6.15.0-next-20250530-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.173       state:D stack:25352 pid:7853  tgid:7809  ppid:5949   task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5396 [inline]
 __schedule+0x16f5/0x4d00 kernel/sched/core.c:6785
 __schedule_loop kernel/sched/core.c:6863 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6878
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6935
 rwsem_down_write_slowpath+0xbec/0x1030 kernel/locking/rwsem.c:1176
 __down_write_common kernel/locking/rwsem.c:1304 [inline]
 __down_write kernel/locking/rwsem.c:1313 [inline]
 down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1578
 inode_lock include/linux/fs.h:867 [inline]
 vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:750
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6a4f78e969
RSP: 002b:00007f6a50646038 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f6a4f9b6080 RCX: 00007f6a4f78e969
RDX: 0000200000000340 RSI: 0000200000000180 RDI: 0000200000000040
RBP: 00007f6a4f810ab1 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000000d4 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f6a4f9b6080 R15: 00007ffe0d3fb538
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13f140 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13f140 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e13f140 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
2 locks held by getty/5591:
 #0: ffff888030ba30a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by udevd/5913:
 #0: ffff888148cf9320 (&sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:882 [inline]
 #0: ffff888148cf9320 (&sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter+0x2f8/0x440 block/fops.c:832
1 lock held by syz-executor/5936:
 #0: ffff8880285d40e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff8880285d40e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff8880285d40e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
2 locks held by syz-executor/5944:
 #0: ffff88807e1020e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff88807e1020e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff88807e1020e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
 #1: ffff8880b863b918 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:606
4 locks held by syz.4.173/7810:
 #0: ffff88807b30e428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888059424130 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff888059424130 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88807b30e618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff888059423f18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
2 locks held by syz.4.173/7853:
 #0: ffff88807b30e428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888059424130 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff888059424130 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
2 locks held by syz.3.482/11259:
 #0: ffff888025568428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff8880596db970 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff8880596db970 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
2 locks held by syz.3.482/11289:
 #0: ffff888025568428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff8880596db970 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff8880596db970 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
2 locks held by syz.5.481/11278:
4 locks held by syz.1.483/11280:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.15.0-next-20250530-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:470
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5837 Comm: syz-executor Not tainted 6.15.0-next-20250530-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:unwind_next_frame+0x374/0x2390 arch/x86/kernel/unwind_orc.c:505
Code: ea 48 01 d2 48 01 f2 48 bd 00 00 00 00 00 fc ff df 0f 84 37 01 00 00 4c 8d 62 04 4c 8d 6a 05 4c 89 e0 48 c1 e8 03 0f b6 04 28 <84> c0 0f 85 6d 19 00 00 4c 89 e8 48 c1 e8 03 0f b6 04 28 84 c0 0f
RSP: 0018:ffffc900043770f8 EFLAGS: 00000a03
RAX: 0000000000000000 RBX: ffffffff8fb4db94 RCX: ffffffff8fb4db98
RDX: ffffffff90303ae8 RSI: ffffffff90303ab8 RDI: ffffffff8be29c20
RBP: dffffc0000000000 R08: 0000000000000009 R09: ffffffff81729de5
R10: ffffc90004377228 R11: fffff5200086ee51 R12: ffffffff90303aec
R13: ffffffff90303aed R14: ffffc90004377228 R15: ffffffff8fb4db94
FS:  000055557497c500(0000) GS:ffff888125d53000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff520a6f80 CR3: 0000000077dae000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __unwind_start+0x5b9/0x760 arch/x86/kernel/unwind_orc.c:758
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0xe4/0x150 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 save_stack+0xf5/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:308
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0xc71/0xe70 mm/page_alloc.c:2706
 discard_slab mm/slub.c:2717 [inline]
 __put_partials+0x161/0x1c0 mm/slub.c:3186
 put_cpu_partial+0x17c/0x250 mm/slub.c:3261
 __slab_free+0x2f7/0x400 mm/slub.c:4513
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4148 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 kmem_cache_alloc_node_noprof+0x1bb/0x3c0 mm/slub.c:4249
 __alloc_skb+0x112/0x2d0 net/core/skbuff.c:660
 alloc_skb_fclone include/linux/skbuff.h:1386 [inline]
 tcp_stream_alloc_skb+0x3d/0x340 net/ipv4/tcp.c:894
 tcp_sendmsg_locked+0x1fa8/0x56f0 net/ipv4/tcp.c:1200
 tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1396
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x19c/0x270 net/socket.c:727
 sock_write_iter+0x258/0x330 net/socket.c:1131
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x54b/0xa90 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f18c638d3e0
Code: 40 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d 61 71 1f 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
RSP: 002b:00007ffdfa6c3d28 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000077fbf140 RCX: 00007f18c638d3e0
RDX: 00000000000000b8 RSI: 00007f18c1a3ff48 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000007 R09: 000000000003fde8
R10: 56c24c0166ec81ab R11: 0000000000000202 R12: 00000000000000b8
R13: 0000555574993b40 R14: 00007ffdfa6c41f0 R15: 00007f18c1a3ff48
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
