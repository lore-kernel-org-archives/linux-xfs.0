Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8228B15748F
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 06:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750748190; cv=none; b=gg3O+Uuri3NqHBYRb8CAcj87Ahbh/BvbM8bjSP73wIXzRo0iekFG5q8wi647CHXXyIsmVd6sgc39bLZX4qfFM7gPKM1LfyerSIlshUIU8sV517TIRZVgpmlDRJAvZByTImsyApmehPixrF/oq0RpwQs5+TUK/W4wmei2IZpIJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750748190; c=relaxed/simple;
	bh=9h+PE3DRdwadgFr7j4C6c1BNz11udXoXSIHFTfUtpic=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=p4wf6ijtXnukjBf19HBwj1VCbspXE+ovaVJ5iiidZ7YisbbsAQB5tPf6hAMeAxMiIZ01y4/pjE03ry7+SrNe3uI7BaEQOlgNUQyfY3jMP/QmoZNFxn32nBJbvr4GgXjCA5O3KGuG6zXIBv9u8K7Q3zgxGMujYMgPcMhPYgtu5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3df149301fdso46666895ab.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jun 2025 23:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750748187; x=1751352987;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MomSVgdlv0x7nXb9V7DSBsOWF81rrrcQGpLpKNlGx/o=;
        b=aiVh5SvzyFx+LF4EROjVkInxVm3upQ0TEVOuyPJKhRSOJi/YuE394s5yphzdp9pkVt
         FvlcS4ScPVIXfFmDK81In/Bc6RuVzeU5QT4qtRSz3i1wTLlv5wob0WcOFv8DtWMcXwwh
         UpFgEObyYezckWYYwn7nPKkDFCD/Nuf37IIgWTmMMUymkYzEDiuct+nLB5dFYaaD3oNo
         7/PFQGBCD+qda6/EAbQ5+KZ6Kl+5rFtt5YSXU7bM0llC5i2PfZHk3LS2mtnV1vp6AtjM
         UoK1GDBdL1fZEHIFCakhEw8/sRjvC/NuXYrNb+fexXP05kMMw6wCqaLmnLLQ3zbTIOwb
         rDng==
X-Forwarded-Encrypted: i=1; AJvYcCW2AOiQTXGGZiLwRAIUQv7uFB9VLb3lShxu+bHDchky+j0bCXWrVlYhsVgLjyr92alS9RHHHM1ESfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw3R6Opd+keQsBfl+iCP2NZ1OeGTuwQwbcKEfOELafFlY2Dxe8
	1p3zTB7sVSyOYIeFgO+2MzqD4jd7wGH8LMa0nJMWL99k19NsaU6koLh7+BiA2PLzTW47eEQRZgy
	/mzIhMyE/8Wx3FtTBDvHCWuJgo0vKnRbus0z1zKND9R8/aeUoW0gFmdPBrQE=
X-Google-Smtp-Source: AGHT+IGvoXMNldhgcCtWrwW0ybRg7YxVVmgvLNMV22mPFDC9KBSX+2GzZtLWAiel5SlFWe+QEyIJOGZQxE4aDEeW6T4pQBgNivp+
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178e:b0:3dc:87c7:a5b9 with SMTP id
 e9e14a558f8ab-3de38ca2cadmr160440945ab.10.1750748187622; Mon, 23 Jun 2025
 23:56:27 -0700 (PDT)
Date: Mon, 23 Jun 2025 23:56:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <685a4c1b.a00a0220.2e5631.005a.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_map_blocks
From: syzbot <syzbot+6acd9f2fce056265f549@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2c923c845768 Add linux-next specific files for 20250619
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13b39d0c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58afc4b78b52b7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=6acd9f2fce056265f549
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1571f5d4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b4ef8488b2c5/disk-2c923c84.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/97fc575793ea/vmlinux-2c923c84.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b8095fa1838d/bzImage-2c923c84.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f420501f3e18/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12fa030c580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6acd9f2fce056265f549@syzkaller.appspotmail.com

INFO: task kworker/u8:7:1104 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc2-next-20250619-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:7    state:D stack:24392 pid:1104  tgid:1104  ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: writeback wb_workfn (flush-7:4)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5313 [inline]
 __schedule+0x16f5/0x4d00 kernel/sched/core.c:6696
 __schedule_loop kernel/sched/core.c:6774 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6789
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6846
 rwsem_down_read_slowpath+0x552/0x880 kernel/locking/rwsem.c:1084
 __down_read_common kernel/locking/rwsem.c:1248 [inline]
 __down_read kernel/locking/rwsem.c:1261 [inline]
 down_read_nested+0x9a/0x2f0 kernel/locking/rwsem.c:1650
 xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
 iomap_writepage_map_blocks fs/iomap/buffered-io.c:1773 [inline]
 iomap_writepage_map fs/iomap/buffered-io.c:1923 [inline]
 iomap_writepages+0x10df/0x3240 fs/iomap/buffered-io.c:1977
 xfs_vm_writepages+0x235/0x2b0 fs/xfs/xfs_aops.c:650
 do_writepages+0x32e/0x550 mm/page-writeback.c:2636
 __writeback_single_inode+0x145/0xff0 fs/fs-writeback.c:1680
 writeback_sb_inodes+0x6c7/0x1010 fs/fs-writeback.c:1976
 __writeback_inodes_wb+0x111/0x240 fs/fs-writeback.c:2047
 wb_writeback+0x44f/0xaf0 fs/fs-writeback.c:2158
 wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
 wb_do_writeback fs/fs-writeback.c:2315 [inline]
 wb_workfn+0xaef/0xef0 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3239 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3322
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3403
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/0:0/9:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13ef20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13ef20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e13ef20 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
4 locks held by kworker/u8:2/36:
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc90000ac7bc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc90000ac7bc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff8880633ca0e0 (&type->s_umount_key#53){++++}-{4:4}, at: super_trylock_shared+0x20/0xf0 fs/super.c:563
 #3: ffff888050fbce98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
4 locks held by kworker/u8:4/61:
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc9000212fbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc9000212fbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff8880278120e0 (&type->s_umount_key#53){++++}-{4:4}, at: super_trylock_shared+0x20/0xf0 fs/super.c:563
 #3: ffff888050f80118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
4 locks held by kworker/u8:5/1008:
6 locks held by kworker/u8:6/1094:
4 locks held by kworker/u8:7/1104:
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc90003ecfbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc90003ecfbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff88807e5340e0 (&type->s_umount_key#53){++++}-{4:4}, at: super_trylock_shared+0x20/0xf0 fs/super.c:563
 #3: ffff88807670ed98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
2 locks held by kworker/u8:8/1157:
 #0: ffff88801a489148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff88801a489148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc900040bfbc0 (connector_reaper_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc900040bfbc0 (connector_reaper_work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
4 locks held by kworker/u8:9/3554:
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc9000c7a7bc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc9000c7a7bc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff8880705c80e0 (&type->s_umount_key#53){++++}-{4:4}, at: super_trylock_shared+0x20/0xf0 fs/super.c:563
 #3: ffff88807656bf18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
2 locks held by getty/5590:
 #0: ffff88814d42c0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000331b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by udevd/5913:
3 locks held by kworker/0:6/6092:
 #0: ffff88801a480d48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff88801a480d48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc90003647bc0 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc90003647bc0 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff888024298240 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x26b/0x3180 drivers/net/netdevsim/fib.c:1490
4 locks held by syz.4.110/7000:
 #0: ffff88807e534428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807670efb0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807670efb0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88807e534618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff88807670ed98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
4 locks held by syz.1.142/7354:
 #0: ffff8880633ca428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888050fbd0b0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff888050fbd0b0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff8880633ca618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff888050fbce98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
4 locks held by syz.0.181/7783:
 #0: ffff888027812428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888050f80330 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff888050f80330 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888027812618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff888050f80118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
6 locks held by syz.6.252/8512:
 #0: ffff8880705c8428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807656c130 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807656c130 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff8880705c8618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff88807656bf18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
 #4: ffff8880b8639f58 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:606
 #5: ffff8880b8623f08 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x39a/0x6d0 kernel/sched/psi.c:991
4 locks held by syz.3.287/8865:
 #0: ffff888069ff6428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888050c8c8f0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff888050c8c8f0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888069ff6618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff888050c8c6d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
4 locks held by kworker/u8:10/9073:
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc9000e65fbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc9000e65fbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff888069ff60e0 (&type->s_umount_key#53){++++}-{4:4}, at: super_trylock_shared+0x20/0xf0 fs/super.c:563
 #3: ffff888050c8c6d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
1 lock held by syz-executor/9121:
 #0: ffffffff8e144a38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #0: ffffffff8e144a38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:967
4 locks held by syz.2.349/9538:
 #0: ffff88802f6d6428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807e150af0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807e150af0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88802f6d6618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: ffff88807e1508d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
4 locks held by syz.7.350/9559:
 #0: ffff888058944428 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807e1531b0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807e1531b0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888058944618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1096
 #3: 
ffff88807e152f98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1102
2 locks held by syz-executor/9800:
 #0: ffffffff8f519508 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8f519508 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #0: ffffffff8f519508 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8db/0x1c70 net/core/rtnetlink.c:4054
 #1: ffff88805d32d4e8 (&wg->device_update_lock){+.+.}-{4:4}, at: wg_open+0x227/0x420 drivers/net/wireguard/device.c:50
4 locks held by kworker/u8:13/9958:
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff8881404e5148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc900021afbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc900021afbc0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff8880589440e0 (&type->s_umount_key#53){++++}-{4:4}, at: super_trylock_shared+0x20/0xf0 fs/super.c:563
 #3: ffff88807e152f98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_map_blocks+0x315/0xe80 fs/xfs/xfs_aops.c:330
2 locks held by syz.8.394/10038:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc2-next-20250619-syzkaller #0 PREEMPT(full) 
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
CPU: 1 UID: 0 PID: 9121 Comm: syz-executor Not tainted 6.16.0-rc2-next-20250619-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:check_preemption_disabled+0x17/0x120 lib/smp_processor_id.c:14
Code: 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 41 57 41 56 53 48 83 ec 10 65 48 8b 05 de fd 31 07 48 89 44 24 08 <65> 8b 05 e6 fd 31 07 65 8b 0d db fd 31 07 f7 c1 ff ff ff 7f 74 23
RSP: 0018:ffffc90000a08700 EFLAGS: 00000086
RAX: 4ef41329efdb5400 RBX: 00000000ffffffff RCX: 4ef41329efdb5400
RDX: 0000000000000000 RSI: ffffffff8d9a4e0e RDI: ffffffff8be320e0
RBP: 00000000ffffffff R08: 0000000000000000 R09: ffffffff821a1446
R10: dffffc0000000000 R11: fffffbfff1f4317f R12: 0000000000000046
R13: ffff888027481e00 R14: ffff8880b8742120 R15: ffff888140eaba00
FS:  000055558bfad500(0000) GS:ffff888125d28000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f03dd865740 CR3: 000000007d080000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 lockdep_recursion_inc kernel/locking/lockdep.c:468 [inline]
 lock_is_held_type+0x79/0x190 kernel/locking/lockdep.c:5942
 lock_is_held include/linux/lockdep.h:249 [inline]
 get_freelist+0x45/0x120 mm/slub.c:3655
 ___slab_alloc+0x298/0x1410 mm/slub.c:3776
 __slab_alloc mm/slub.c:3980 [inline]
 __slab_alloc_node mm/slub.c:4055 [inline]
 slab_alloc_node mm/slub.c:4216 [inline]
 kmem_cache_alloc_node_noprof+0x280/0x3c0 mm/slub.c:4280
 __alloc_skb+0x112/0x2d0 net/core/skbuff.c:660
 __netdev_alloc_skb+0x108/0x970 net/core/skbuff.c:734
 netdev_alloc_skb include/linux/skbuff.h:3414 [inline]
 dev_alloc_skb include/linux/skbuff.h:3427 [inline]
 hsr_init_skb+0xef/0x6e0 net/hsr/hsr_device.c:264
 send_hsr_supervision_frame+0x133/0xb30 net/hsr/hsr_device.c:313
 hsr_announce+0x1d5/0x360 net/hsr/hsr_device.c:415
 call_timer_fn+0x17e/0x5f0 kernel/time/timer.c:1747
 expire_timers kernel/time/timer.c:1798 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x61a/0x860 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2061 [inline]
RIP: 0010:vprintk_emit+0x58f/0x7a0 kernel/printk/printk.c:2449
Code: 85 32 01 00 00 e8 c1 5b 1f 00 41 89 df 4d 85 f6 48 8b 1c 24 75 07 e8 b0 5b 1f 00 eb 06 e8 a9 5b 1f 00 fb 48 c7 c7 a0 31 13 8e <31> f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 a9 36
RSP: 0018:ffffc9000ea5f980 EFLAGS: 00000293
RAX: ffffffff81a10ce7 RBX: ffffffff81a10ba4 RCX: ffff888027481e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e1331a0
RBP: ffffc9000ea5fa90 R08: ffffffff8fa18bf7 R09: 1ffffffff1f4317e
R10: dffffc0000000000 R11: fffffbfff1f4317f R12: dffffc0000000000
R13: 1ffff92001d4bf34 R14: 0000000000000200 R15: 0000000000000047
 _printk+0xcf/0x120 kernel/printk/printk.c:2475
 __xfs_printk fs/xfs/xfs_message.c:24 [inline]
 xfs_printk_level+0x18b/0x280 fs/xfs/xfs_message.c:44
 xfs_fs_put_super+0x55/0x160 fs/xfs/xfs_super.c:1245
 generic_shutdown_super+0x135/0x2c0 fs/super.c:643
 kill_block_super+0x44/0x90 fs/super.c:1755
 xfs_kill_sb+0x15/0x50 fs/xfs/xfs_super.c:2317
 deactivate_locked_super+0xb9/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1417
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:114
 exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:414 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:449 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcb38f8fc57
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffdbc2dfef8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007fcb39010925 RCX: 00007fcb38f8fc57
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffdbc2dffb0
RBP: 00007ffdbc2dffb0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffdbc2e1040
R13: 00007fcb39010925 R14: 0000000000053a61 R15: 00007ffdbc2e1080
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
