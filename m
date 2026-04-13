Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47E637D104
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776068944; cv=none; b=sSWcdlLwvSs/YDRhW4tXzs3lM9Ha9Pm4XKss8va1wN2iEbhbOWhkleXjGtB2pcnlD9FLp1jj+BW/kbUu9dh1UOJQJ18vAebFgcVYEEbYHDecRXJE0/J/ogC1+GOvLgkK4nKq6lUS9Z5fAj/uCrYrw/Q2QRQ+2HSFY1hlpQUZ+e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776068944; c=relaxed/simple;
	bh=YUyNJEbAC3I2oJo6BAwYoRgX2TLtMGH6wpNQErv9yCY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=XYtAycFFSXgK8h8dYIFhO5aPTdYqT5YslNOkADAfNHugCagZX6+ErUks/HmlXC7Qh1Ya7KlHoTvaUcidtj4vbSa1T+JoXbcjfYtFaBNdGm3/0qu841Xs7rZAAHYr5bzURmk1EGC4KeFlJYJSEhyD8HwlftKazoRQbxHzLUfG+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-688b73cc616so2620246eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 01:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776068942; x=1776673742;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gAcXeJakgR1bXkBTZ7KgVy9ckHaJnJtTqdQkhj8gdZQ=;
        b=hRjc19xOyifROjgBrSTdTWw+L2EYJ/4PeeFs4cHbArYAReG04DT/ZIz2sB/m30O3XM
         TVGE8f0T/i/xdhXJ+ap3HM+kzhDnur1EUU+paMxNm+i2Jeq9I3xX28R/mJb2MDcKYbxG
         rPNJlyfwNuW0xMwNTQfUOy3fvCLxcxrYk7vdFIxNyE6nZ16FeXwo/NfJXmc8n2x1Y/RN
         s+PmONEvdcQ9ogm90dgMHg3vI324CC06faIp3WVRRWQEVRr0jcf6omFfbJt9uvzWCWJh
         /0DyyOam8qF/5pPWVT79iocwLYLV3bIPkvNnCOl9m2QjJZxwkhfoWC4m/dWxeOWJhv5k
         mOiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ7dGLNYhTQLrcieO8GFTzIycKcVgwoVPMKf9ZmTVR7mv7Oi7jqIzaMNUdQqYiYMiXgl+9dLO9aAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW68giHFcjO1GlFyDO1Mq5HVN9ZbT8OxBETL+omt+YdkaKAfqE
	eNKrTvJSMrS4BIa7BjKqPw4dWEe9DOivLlNigbqSOmsITYmgbJ1kHW+L+BDvh2Cw+IgF83YVaec
	2aqX9qCpfWBDIyPHpoZx0IZBstE4Bl2gfNJRejG7W961KuKc3axWQyhbCWqw=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:810c:b0:67e:313e:22bf with SMTP id
 006d021491bc7-68be7de906emr5507038eaf.31.1776068941947; Mon, 13 Apr 2026
 01:29:01 -0700 (PDT)
Date: Mon, 13 Apr 2026 01:29:01 -0700
In-Reply-To: <20260413080617.12857-2-ytohnuki@amazon.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69dca94d.050a0220.3030df.0049.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xlog_force_lsn (2)
From: syzbot <syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, ytohnuki@amazon.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in xfs_buf_item_unpin

INFO: task kworker/u8:3:57 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:3    state:D stack:24616 pid:57    tgid:57    ppid:2      task_flags:0x4248160 flags:0x00080000
Workqueue: xfs-cil/loop3 xlog_cil_push_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0x1553/0x5190 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7008
 schedule_timeout+0xc3/0x2c0 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x321/0x730 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 xfs_buf_lock+0x14d/0x520 fs/xfs/xfs_buf.c:993
 xfs_buf_item_unpin+0x1c4/0x770 fs/xfs/xfs_buf_item.c:551
 xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:-1 [inline]
 xlog_cil_committed+0x9f4/0x1170 fs/xfs/xfs_log_cil.c:995
 xlog_cil_push_work+0x1e0c/0x23d0 fs/xfs/xfs_log_cil.c:1607
 process_one_work kernel/workqueue.c:3288 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3371
 worker_thread+0x8a2/0xda0 kernel/workqueue.c:3452
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz.3.50:7129 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.50        state:D stack:25616 pid:7129  tgid:7127  ppid:6387   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0x1553/0x5190 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7008
 schedule_timeout+0xc3/0x2c0 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common kernel/sched/completion.c:121 [inline]
 wait_for_common kernel/sched/completion.c:132 [inline]
 wait_for_completion+0x2cc/0x5e0 kernel/sched/completion.c:153
 __flush_workqueue+0x6f6/0x14f0 kernel/workqueue.c:4096
 xlog_cil_push_now fs/xfs/xfs_log_cil.c:1725 [inline]
 xlog_cil_force_seq+0x262/0x930 fs/xfs/xfs_log_cil.c:1927
 xfs_log_force_seq+0x196/0x440 fs/xfs/xfs_log.c:3000
 __xfs_trans_commit+0x7d3/0xc20 fs/xfs/xfs_trans.c:877
 xfs_trans_commit+0x13e/0x1c0 fs/xfs/xfs_trans.c:926
 xfs_sync_sb_buf+0x13f/0x230 fs/xfs/libxfs/xfs_sb.c:1490
 xfs_ioc_setlabel+0x1de/0x340 fs/xfs/xfs_ioctl.c:1041
 xfs_file_ioctl+0x9c5/0x1710 fs/xfs/xfs_ioctl.c:1198
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6551f5a539
RSP: 002b:00007f65515be028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f65521c5fa0 RCX: 00007f6551f5a539
RDX: 00002000000001c0 RSI: 0000000041009432 RDI: 0000000000000004
RBP: 00007f6551fedee0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f65521c6038 R14: 00007f65521c5fa0 R15: 00007ffeece18258
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u8:1/13:
 #0: ffff88805ab4c138 ((wq_completion)xfs-cil/loop0#15){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88805ab4c138 ((wq_completion)xfs-cil/loop0#15){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90000127c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90000127c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by khungtaskd/37:
 #0: ffffffff8dbb20c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #0: ffffffff8dbb20c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #0: ffffffff8dbb20c0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u8:2/39:
 #0: ffff88805a498138 ((wq_completion)xfs-cil/loop2#20){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88805a498138 ((wq_completion)xfs-cil/loop2#20){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90000b07c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90000b07c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:3/57:
 #0: ffff8880346e0138 ((wq_completion)xfs-cil/loop3#6){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff8880346e0138 ((wq_completion)xfs-cil/loop3#6){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000123fc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000123fc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:8/1051:
 #0: ffff88805ff21938 ((wq_completion)xfs-cil/loop7#34){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88805ff21938 ((wq_completion)xfs-cil/loop7#34){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc900057afc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc900057afc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:9/1485:
 #0: ffff88805c9f5138 ((wq_completion)xfs-cil/loop5#13){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88805c9f5138 ((wq_completion)xfs-cil/loop5#13){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000667fc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000667fc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:10/1960:
 #0: ffff8880412e0938 ((wq_completion)xfs-cil/loop8#29){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff8880412e0938 ((wq_completion)xfs-cil/loop8#29){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000756fc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000756fc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:12/3013:
 #0: ffff88805b7bb938 ((wq_completion)xfs-cil/loop1#43){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88805b7bb938 ((wq_completion)xfs-cil/loop1#43){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000eaefc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000eaefc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by getty/5548:
 #0: ffff8880382bf0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e8b2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x462/0x13c0 drivers/tty/n_tty.c:2211
1 lock held by udevd/6541:
 #0: ffff888022331670 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1043 [inline]
 #0: ffff888022331670 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: blkdev_read_iter+0x2ff/0x440 block/fops.c:854
2 locks held by kworker/u8:13/6857:
 #0: ffff88803a0cd938 ((wq_completion)xfs-cil/loop6#10){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803a0cd938 ((wq_completion)xfs-cil/loop6#10){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90004a27c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90004a27c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by syz.3.50/7129:
 #0: ffff888038ffc480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.0.87/7519:
 #0: ffff88803bc02480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.2.100/7656:
 #0: ffff888034b6e480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.5.144/8136:
 #0: ffff88805764c480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.1.178/8506:
 #0: ffff88804313c480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.6.180/8535:
 #0: ffff88802a7ea480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
2 locks held by kworker/u8:14/8818:
 #0: ffff888062f6b938 ((wq_completion)xfs-cil/loop9#8){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff888062f6b938 ((wq_completion)xfs-cil/loop9#8){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000fbdfc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000fbdfc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by syz.7.266/9442:
 #0: ffff8880656c2480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.9.270/9483:
 #0: ffff888057cee480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.8.292/9652:
 #0: ffff88805f5ba480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.5.361/10079:
4 locks held by syz.0.362/10081:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 37 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:161 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xfd9/0x1030 kernel/hung_task.c:515
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 17 Comm: pr/legacy Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:io_serial_in+0x77/0xc0 drivers/tty/serial/8250/8250_port.c:401
Code: e8 5e d3 95 fc 44 89 f9 d3 e3 49 83 ee 80 4c 89 f0 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 ef da fa fc 41 03 1e 89 da ec <0f> b6 c0 5b 41 5c 41 5e 41 5f c3 cc cc cc cc cc 44 89 f9 80 e1 07
RSP: 0018:ffffc900001679d0 EFLAGS: 00000202
RAX: 1ffffffff32cff00 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff9967fe30 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff852d02a0 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff9967fba0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88812660f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f098b3e1000 CR3: 000000002a706000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:128 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:150 [inline]
 wait_for_lsr+0x1aa/0x2f0 drivers/tty/serial/8250/8250_port.c:1970
 serial8250_fifo_wait_for_lsr_thre drivers/tty/serial/8250/8250_port.c:3207 [inline]
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3272 [inline]
 serial8250_console_write+0x120d/0x1b90 drivers/tty/serial/8250/8250_port.c:3357
 console_emit_next_record kernel/printk/printk.c:3163 [inline]
 console_flush_one_record+0x68b/0xb90 kernel/printk/printk.c:3269
 legacy_kthread_func+0x1b6/0x250 kernel/printk/printk.c:3712
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


Tested on:

commit:         028ef9c9 Linux 7.0
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104e60ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9800c931612cba58
dashboard link: https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11de9036580000

