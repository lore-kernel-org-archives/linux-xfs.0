Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C33FC1D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752082713; cv=none; b=neTQkWrlQqXQwzyzTC8ratRbHigiH7N2JGrQKnMIZ23/UpspiE7wnnzGMqqVonxLtlgVRjJKddeMEJOer1BMKLp/a2kZRdj9KG1OD2KebBOzGJSOQ1/98Eohi/uTAxTtAQB04znuTtzSshmBI4z2YfliwEYYh/YrWnseZMdLt1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752082713; c=relaxed/simple;
	bh=lovV8gO41fV5SCPaGfmV6A/0Zri7rQ8ynOCmavFGodU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MqdgSGtCSmaLkTlqYsyLee4ewI6F3qpGYMSZSiXNFjgAFVl/nFjDCrgJS3J46h505qq6L653yptSndMFABq/V5JxXg6ZJNpQK4iiZ41TaCbDWk9ursnRzLvk9kg7R5wZFouaOa4H9+bj14fPVivaN8pNKRWwzLW+y6q6m/MAjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-876afa8b530so26879939f.0
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jul 2025 10:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752082710; x=1752687510;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7RihC63W/jvwroZO72oRGjq1LGCnhJ/xjfdfT4wYx24=;
        b=VBwGO9XPq567UxIGEwuF5pgvbx6dw1A4Du8O3qTjT/9porLXKNV4tYyMz71fIO9oZJ
         lJnWH73NJbzmSNGvb2OMPAVRc6xz13i7iJXuMDiWxP3HVQWAP2tJy/kJm011ufcvhMdG
         2TjiLVlTK40s+w5ze+ziNAU+87IFy0Tet4y7cxyQJuV1IFBn1I1HeYst//yH1WSFm61E
         5L9qqUqw9zs4PbPHrtYS9O2Lp9qLuSDxU2nbu9DxCIW75ZQqSPJvcpIhhGWy8BUijVOu
         JHbk31Sw7+BN/ybmBsSp9vWgIVSriHIFUOzAEDhZoiXqC7sWGSlJHNEHPXiVjJm2yvL1
         35cg==
X-Forwarded-Encrypted: i=1; AJvYcCW0IhRHVz6qduzJ/+iAe++jeZ/Gp2Q5Z7sRPCKdo4b+74jgvvJaOX8esmtcnTFUpPFmtpGH1hJARMk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe3BC2ig7AB8FwappqTpi8aA3CMf92iWw4MV7mBsN0ySYicRYQ
	jSpHAs61wbOiWQ0bWsITpqQpOsjmo6eNNrcQVhKCNtJYjgkPFvzWI3I5EMfIfjWLPt/cVUWGmh1
	EcAPZsTbfkeZeCXbQdZDGG/lb7AXu3FZwHDDHl2Ir8WV+O49m1V/XuSXEwEU=
X-Google-Smtp-Source: AGHT+IF1//XpukPGK3uG0wEHS7eCmjEAyal42KN5hrRGGplRFGw8SxOZBKa3AYtA5I9dimYQ8szkEYCTPVIT+saKNUbaPaXJJQvE
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:9c0c:0:b0:86a:84f:7a45 with SMTP id
 ca18e2360f4ac-879662f8901mr85090639f.8.1752082710672; Wed, 09 Jul 2025
 10:38:30 -0700 (PDT)
Date: Wed, 09 Jul 2025 10:38:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686ea916.050a0220.385921.0012.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_setfilesize
From: syzbot <syzbot+d42ea321837890ff464b@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15e63582580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=d42ea321837890ff464b
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a87f70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16602a8c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/589c382b9e63/disk-d006330b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/756fa29cc5a7/vmlinux-d006330b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/41f40b8b4afc/bzImage-d006330b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/399f89a3843b/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=17287f70580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d42ea321837890ff464b@syzkaller.appspotmail.com

INFO: task kworker/1:2:2145 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:2     state:D stack:25736 pid:2145  tgid:2145  ppid:2      task_flags:0x4248060 flags:0x00004000
Workqueue: xfs-conv/loop5 xfs_end_io

Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5401 [inline]
 __schedule+0x16f5/0x4d00 kernel/sched/core.c:6790
 __schedule_loop kernel/sched/core.c:6868 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6883
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6940
 rwsem_down_write_slowpath+0xbec/0x1030 kernel/locking/rwsem.c:1176
 __down_write_common kernel/locking/rwsem.c:1304 [inline]
 __down_write kernel/locking/rwsem.c:1313 [inline]
 down_write_nested+0x1b5/0x200 kernel/locking/rwsem.c:1694
 xfs_setfilesize+0xdb/0x440 fs/xfs/xfs_aops.c:65
 xfs_end_ioend+0x419/0x690 fs/xfs/xfs_aops.c:164
 xfs_end_io+0x253/0x2d0 fs/xfs/xfs_aops.c:205
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz-executor289:5945 blocked for more than 144 seconds.
      Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor289 state:D stack:21864 pid:5945  tgid:5882  ppid:5876   task_flags:0x400040 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5401 [inline]
 __schedule+0x16f5/0x4d00 kernel/sched/core.c:6790
 __schedule_loop kernel/sched/core.c:6868 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6883
 io_schedule+0x80/0xd0 kernel/sched/core.c:7728
 folio_wait_bit_common+0x6b0/0xb90 mm/filemap.c:1317
 folio_wait_writeback+0xb0/0x100 mm/page-writeback.c:3126
 __filemap_fdatawait_range+0x147/0x230 mm/filemap.c:539
 file_write_and_wait_range+0x275/0x330 mm/filemap.c:798
 xfs_file_fsync+0x1a3/0xa30 fs/xfs/xfs_file.c:140
 generic_write_sync include/linux/fs.h:3031 [inline]
 xfs_file_buffered_write+0x713/0x890 fs/xfs/xfs_file.c:1018
 do_iter_readv_writev+0x56e/0x7f0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_sys_pwritev2 fs/read_write.c:1211 [inline]
 __se_sys_pwritev2+0x179/0x290 fs/read_write.c:1202
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3cdbf794f9
RSP: 002b:00007f3cdbf04158 EFLAGS: 00000212 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f3cdc0036d8 RCX: 00007f3cdbf794f9
RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000004
RBP: 00007f3cdc0036d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000e7b R11: 0000000000000212 R12: 00007f3cdc0036dc
R13: 000000000000006e R14: 00007ffc4c1d04e0 R15: 00007ffc4c1d05c8
 </TASK>

Showing all locks held in the system:
1 lock held by pool_workqueue_/3:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13f160 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13f160 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e13f160 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
4 locks held by kworker/0:2/971:
 #0: ffff8880272e8948 ((wq_completion)xfs-conv/loop2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff8880272e8948 ((wq_completion)xfs-conv/loop2){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3321
 #1: ffffc9000386fbc0 ((work_completion)(&ip->i_ioend_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc9000386fbc0 ((work_completion)(&ip->i_ioend_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3321
 #2: ffff888023f06618 (sb_internal#2){.+.+}-{0:0}, at: xfs_setfilesize+0xb3/0x440 fs/xfs/xfs_aops.c:61
 #3: ffff88807416a7d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_setfilesize+0xdb/0x440 fs/xfs/xfs_aops.c:65
4 locks held by kworker/1:2/2145:
 #0: ffff888024a75148 ((wq_completion)xfs-conv/loop5){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff888024a75148 ((wq_completion)xfs-conv/loop5){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3321
 #1: ffffc90004827bc0 ((work_completion)(&ip->i_ioend_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc90004827bc0 ((work_completion)(&ip->i_ioend_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3321
 #2: ffff88806b42a618 (sb_internal#2){.+.+}-{0:0}, at: xfs_setfilesize+0xb3/0x440 fs/xfs/xfs_aops.c:61
 #3: ffff8880741446d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_setfilesize+0xdb/0x440 fs/xfs/xfs_aops.c:65
2 locks held by getty/5600:
 #0: ffff888033f110a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000333b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by syz-executor289/5945:
 #0: ffff88806b42a428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff88806b42a428 (sb_writers#9){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
4 locks held by syz-executor289/5946:
 #0: ffff88806b42a428 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff8880741448f0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff8880741448f0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88806b42a618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff8880741446d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz-executor289/6007:
 #0: ffff88806a48a428 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff8880741467f0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff8880741467f0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88806a48a618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff8880741465d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz-executor289/7400:
 #0: ffff88807e078428 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff8880741592b0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff8880741592b0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88807e078618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff888074159098 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
1 lock held by syz-executor289/7674:
 #0: ffff888023f06428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff888023f06428 (sb_writers#9){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
4 locks held by syz-executor289/7676:
 #0: ffff888023f06428 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807416a9f0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807416a9f0 (&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888023f06618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88807416a7d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
2 locks held by syz-executor289/7766:
2 locks held by syz-executor289/7768:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:470
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5922 Comm: udevd Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:lock_release+0x5/0x3e0 kernel/locking/lockdep.c:5879
Code: 03 48 8b 3c 24 e9 08 fa ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 <41> 57 41 56 41 55 41 54 53 48 83 ec 30 49 89 f5 49 89 fe 65 48 8b
RSP: 0018:ffffc9000433f990 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff88801b692780 RCX: 2039e734034f1a00
RDX: 0000000000000000 RSI: ffffffff82195d0d RDI: ffff8880b8640970
RBP: 0000000000000286 R08: 0000000000000000 R09: ffffffff82195d0d
R10: dffffc0000000000 R11: fffffbfff1f43ddf R12: 0000000000000000
R13: 0000000000000000 R14: ffff88806b7f8000 R15: ffff8880b8640970
FS:  00007f7b9d843880(0000) GS:ffff888125c1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3cd49ff000 CR3: 000000007e515000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 local_lock_release include/linux/local_lock_internal.h:54 [inline]
 put_cpu_partial+0x13f/0x250 mm/slub.c:3258
 __slab_free+0x2f7/0x400 mm/slub.c:4513
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4148 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_noprof+0x224/0x4f0 mm/slub.c:4340
 kmalloc_noprof include/linux/slab.h:909 [inline]
 tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x1e8/0x5a0 security/tomoyo/file.c:723
 security_file_ioctl+0xcb/0x2d0 security/security.c:2913
 __do_sys_ioctl fs/ioctl.c:901 [inline]
 __se_sys_ioctl+0x47/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7b9d11d378
Code: 00 00 48 8d 44 24 08 48 89 54 24 e0 48 89 44 24 c0 48 8d 44 24 d0 48 89 44 24 c8 b8 10 00 00 00 c7 44 24 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 07 89 d0 c3 0f 1f 40 00 48 8b 15 49 3a 0d
RSP: 002b:00007ffd0e9529d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000055fab513fc70 RCX: 00007f7b9d11d378
RDX: 0000000000000000 RSI: 0000000000005331 RDI: 0000000000000009
RBP: 0000000000000009 R08: 0000000000000170 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000009
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
