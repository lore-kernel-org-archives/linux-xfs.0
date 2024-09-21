Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708C9605BA
	for <linux-xfs@vger.kernel.org>; Sat, 21 Sep 2024 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726921826; cv=none; b=Ic5HFou3+XX1WHvuoZorO5GezYUcrc+EB/28UYqujKqZar3kXTXfW4mDi1AzP3g+dnUhnpTH6F7XUS3yK6d7NTFBtHjiPu9ISluWHanqXyc4ipeN0X2Y5ViHqCeqNGNxxsgWMnTFQNtvYLvJYRrUTidC0kkFnKHoNkevsp6bGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726921826; c=relaxed/simple;
	bh=hs5m+THVTu0oYo5eRourhPtOSy5GTYZDCEI4DYW57Gw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rV9HUGiWezxnlf2dSArA557p2u3JU8gJ32rH4aWAVLRV7VefQjI4QnEpZ20Ds+kdryOJlsvPPDHXDEmZnyfxOJ3r8+Tv0dUMjd2DVHciMUkkH5hvrBgFOt/TA/jVk1gIyW/c5+CCb7aMAZCAodP+3yb0Qi4By3PtTC4dUb67uzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0ce4692a4so8651075ab.0
        for <linux-xfs@vger.kernel.org>; Sat, 21 Sep 2024 05:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726921823; x=1727526623;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oXh049IlUMXetBW9qT3DncLxl3GlaSQJHmaMqTgr4UU=;
        b=qopz7dNrnpuoeIbYZeDdq1gQNYGq9fAXjeyFa/FWbN9h/BAFeyMWuoXhRwJgar13zn
         ibOVzJlysjnyt69UwYzphwUag5cqDDACNW2LjbT0pY3t8pQ/difhqCfABt+ZbbTermv1
         RM1VFrNTW/307xBzhR6fHir9ZEH5/kEP74QrD5KhIlnALCdfuD0tmomXtQ3c12+QG54p
         162BY5tHYw3jScarnUFnPO/mGuevB2AS66SnGizDriyLGSo+m6Ar3YCPOP1WdywF+WrF
         EoV5scJXF4MiLUWNCU78XjZ+6ekji6y03vNn0LwKQI5yAMHyE1+W4RC/ECrYp2EGNhyB
         G5mA==
X-Forwarded-Encrypted: i=1; AJvYcCUiigDr7EYb72QnHgiafKZnPMxTB1NvuGlUl1t0LiinqvorUXyyranXdqoYo3pe/XEgF77hcj/d8CQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUJ47MjUvrUOpEOYIRPnaLpEcxd0DoipTPX6DOrr6Z8HCWp7Pa
	SwzOCtPYcDzUva5OZ/2CTuhRTBEHV8edahh++KyL/wYZ7Pcu68YKZKBh3EGrBPlHs6KmnnoZXDB
	QfJshn5gs3tRZI1b//hP1QNkV1kgUKOM31kZwsILkJOLCdTPLdpl0iNc=
X-Google-Smtp-Source: AGHT+IGnuBhg8j/2xIKI/VxtNA5Xv5ExRO2minvL86NMdvyqUFP78LO5M3sqzyCt5k9zVP908SU+EsN0/C6uiqDU0RixCrknvTWJ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c2f:b0:3a0:9ee3:d85b with SMTP id
 e9e14a558f8ab-3a0c8997974mr48203585ab.4.1726921823543; Sat, 21 Sep 2024
 05:30:23 -0700 (PDT)
Date: Sat, 21 Sep 2024 05:30:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66eebc5f.050a0220.3195df.0053.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_ail_push_all_sync
From: syzbot <syzbot+bf0143df12877cb1a21b@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a430d95c5efa Merge tag 'lsm-pr-20240911' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15569d00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9ab5893ec5191eb
dashboard link: https://syzkaller.appspot.com/bug?extid=bf0143df12877cb1a21b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e6a77980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f8549392ace4/disk-a430d95c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9b866ef0c06c/vmlinux-a430d95c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9d6691641029/bzImage-a430d95c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/dd50a033ca89/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf0143df12877cb1a21b@syzkaller.appspotmail.com

INFO: task syz.0.75:6468 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.75        state:D stack:24864 pid:6468  tgid:6446  ppid:6378   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 xfs_ail_push_all_sync+0x236/0x310 fs/xfs/xfs_trans_ail.c:726
 xfs_log_quiesce+0xdf/0x5b0 fs/xfs/xfs_log.c:1018
 xfs_fs_freeze+0x8d/0x1a0 fs/xfs/xfs_super.c:936
 freeze_super+0x81b/0xee0 fs/super.c:2107
 fs_bdev_freeze+0x1ac/0x320 fs/super.c:1484
 bdev_freeze+0xd6/0x220 block/bdev.c:257
 xfs_fs_goingdown+0xa9/0x160 fs/xfs/xfs_fsops.c:446
 xfs_file_ioctl+0x12d4/0x19e0 fs/xfs/xfs_ioctl.c:1473
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc862d7def9
RSP: 002b:00007fc863b4a038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc862f36058 RCX: 00007fc862d7def9
RDX: 0000000020000080 RSI: 000000008004587d RDI: 0000000000000006
RBP: 00007fc862df0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fc862f36058 R15: 00007ffd1aceae18
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e738660 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:326 [inline]
 #0: ffffffff8e738660 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e738660 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6626
2 locks held by getty/4972:
 #0: ffff888034b890a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000311b2f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz.0.75/6468:
 #0: ffff888022c9c6b0 (&bdev->bd_fsfreeze_mutex){+.+.}-{3:3}, at: bdev_freeze+0x2a/0x220 block/bdev.c:248
 #1: ffff888031aac420 (sb_writers#12){++++}-{0:0}, at: sb_wait_write fs/super.c:1896 [inline]
 #1: ffff888031aac420 (sb_writers#12){++++}-{0:0}, at: freeze_super+0x4e9/0xee0 fs/super.c:2085
 #2: ffff888031aac0e0 (&type->s_umount_key#53){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #2: ffff888031aac0e0 (&type->s_umount_key#53){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #2: ffff888031aac0e0 (&type->s_umount_key#53){+.+.}-{3:3}, at: freeze_super+0x4f1/0xee0 fs/super.c:2086
 #3: ffff888031aac518 (sb_pagefaults#2){+.+.}-{0:0}, at: sb_wait_write fs/super.c:1896 [inline]
 #3: ffff888031aac518 (sb_pagefaults#2){+.+.}-{0:0}, at: freeze_super+0x519/0xee0 fs/super.c:2090
 #4: ffff888031aac610 (sb_internal#2){++++}-{0:0}, at: sb_wait_write fs/super.c:1896 [inline]
 #4: ffff888031aac610 (sb_internal#2){++++}-{0:0}, at: freeze_super+0x7cc/0xee0 fs/super.c:2104
1 lock held by syz-executor/6470:
 #0: ffffffff8e73da38 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:296 [inline]
 #0: ffffffff8e73da38 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:958

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
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
CPU: 1 UID: 0 PID: 4661 Comm: klogd Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:filter_irq_stacks+0x4f/0xa0 kernel/stacktrace.c:397
Code: f0 84 bd 8b 48 89 fb eb 0c 49 ff c7 48 83 c3 08 4d 39 fc 74 4f 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 <74> 08 48 89 df e8 e7 6a 78 00 4b 8b 04 fe 48 39 e8 72 0c 48 c7 c1
RSP: 0018:ffffc90003137418 EFLAGS: 00000246
RAX: 1ffff92000626e96 RBX: ffffc900031374b0 RCX: dffffc0000000000
RDX: 0000000000400cc0 RSI: 000000000000000c RDI: ffffc900031374b0
RBP: ffffffff8bc00230 R08: ffffffff81378892 R09: 1ffffffff1ff501d
R10: dffffc0000000000 R11: fffffbfff1ff501e R12: 000000000000000c
R13: ffffffff8bbd84f0 R14: ffffc900031374b0 R15: 0000000000000000
FS:  00007f80f557f380(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f37b7714000 CR3: 0000000063a2e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 stack_depot_save_flags+0x29/0x830 lib/stackdepot.c:609
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_save_track+0x51/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3989 [inline]
 slab_alloc_node mm/slub.c:4038 [inline]
 kmem_cache_alloc_node_noprof+0x16b/0x320 mm/slub.c:4081
 __alloc_skb+0x1c3/0x440 net/core/skbuff.c:668
 alloc_skb include/linux/skbuff.h:1322 [inline]
 alloc_skb_with_frags+0xc3/0x820 net/core/skbuff.c:6612
 sock_alloc_send_pskb+0x91a/0xa60 net/core/sock.c:2883
 unix_dgram_sendmsg+0x6d3/0x1f80 net/unix/af_unix.c:2027
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:745
 __sys_sendto+0x398/0x4f0 net/socket.c:2210
 __do_sys_sendto net/socket.c:2222 [inline]
 __se_sys_sendto net/socket.c:2218 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2218
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f80f56e19b5
Code: 8b 44 24 08 48 83 c4 28 48 98 c3 48 98 c3 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 26 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 7a 48 8b 15 44 c4 0c 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffe65f0c128 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f80f56e19b5
RDX: 000000000000004f RSI: 000055b41fbcd6b0 RDI: 0000000000000003
RBP: 000055b41fbc8910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000013
R13: 00007f80f586f212 R14: 00007ffe65f0c228 R15: 0000000000000000
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
