Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A052637F8D1
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 06:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776062284; cv=none; b=RVSpAMC2HhsiUR3hJYlYZpnaymxwvMg+77fbz1g5ZN1NCVEu46I2NadyLOnb7V8AIwC2u7PhfJha4GjTMtD5XuxXRAQj4FZemxjc+2q4tFVAlpiAIwWxsCEGLKAVyIHHuwvHpXPyV0Bqp5K5g/B7B2FdYQTKaDcK5o3v+3A1xxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776062284; c=relaxed/simple;
	bh=UwJ48Z5dSr8c3dVmLHzxwXB4J++HSR4v2jWSthikYKA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=X197C5vmV2YPK2WjQC2GdHrLBkfO41CupueKbqRGfZQUUDvOmzbDrB8XR8wvajiIo8ccNGGRkXtjVExGy1VWwdPkhq7KwxzxW0cQi9ztfvBQ5ZTAbIIWJHgeXx1uzDDItB28Lmoi9fXwdd9bc8IdsuoavhvaGFU3ITElnRABIo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dbb97a2b6eso8181092a34.3
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 23:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776062281; x=1776667081;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LkerVcEwD/1ghtolbBLoFJMbcKYdsnCXStD1RKzS1s=;
        b=S5XFWXeFPFW1AyqutNyDaYWFBj0Ks89FCNPCzNBrv4rEkVc48m4UcQkvAb6AYBavsv
         dhyM7fbIBAinbMeer7zxZ8mWkyeOZgBFzg0JJape9Lj7BQtkL7nv1hjrSS7xkhilIeTm
         cOBNaZzl5t6I/37Ypdgsc5jtl25xs+vwxI8PxNI784IlKqHpeo4pD9HtUK7i6KMYTBZk
         LVGSIRtDU1Neq41t6ZN+6/vcijaVw5eieq40o8uqpBEIB21BmxJgJyFh7RDF9Lk70Bdr
         lKaOmM6yNSQDmAaAmqVIf/0LkgC5EcAiYJZcLB3ZV86r4U7LaM7DdMj5U56FZD8jXQCX
         q0sw==
X-Forwarded-Encrypted: i=1; AJvYcCX9F1yYgKJcRID9sMD5LMj03h3WEekjdCDhQkmz+MaRqs+K7Cn7z6tuhxM9WKJemnzEFcK/y2rleGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxccYsDdTa0brHMfzrvDb/t93EMvYVG7PRgOyeuQSGB8RkDIwku
	tmyuHwtkhPCRBK61reWNYC5n4FryUBkxrE2BQ7lJDXox9arW74Tyc6KFXHCdb7d6Pawn9MEnvTW
	Bz5vo8cWxJE/fHR7n2uC6q0ecM88Y5OAEugUjrUf/OTlXwITxUPcIXZumTkw=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1606:b0:67e:4140:769a with SMTP id
 006d021491bc7-68be5c5e82amr6121097eaf.7.1776062281591; Sun, 12 Apr 2026
 23:38:01 -0700 (PDT)
Date: Sun, 12 Apr 2026 23:38:01 -0700
In-Reply-To: <20260413061917.18327-2-ytohnuki@amazon.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69dc8f49.050a0220.3030df.0046.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xlog_force_lsn (2)
From: syzbot <syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, ytohnuki@amazon.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in xfs_buf_item_unpin

INFO: task kworker/u8:0:12 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:0    state:D stack:20896 pid:12    tgid:12    ppid:2      task_flags:0x4248060 flags:0x00080000
Workqueue: xfs-cil/loop1 xlog_cil_push_work
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
INFO: task syz.1.22:6678 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.22        state:D stack:25536 pid:6678  tgid:6675  ppid:6316   task_flags:0x400140 flags:0x00080002
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
 xlog_cil_force_seq+0x228/0x8c0 fs/xfs/xfs_log_cil.c:1927
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
RIP: 0033:0x7f73218ba539
RSP: 002b:00007f7320f1e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f7321b25fa0 RCX: 00007f73218ba539
RDX: 00002000000001c0 RSI: 0000000041009432 RDI: 0000000000000004
RBP: 00007f732194dee0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7321b26038 R14: 00007f7321b25fa0 R15: 00007ffded160d28
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u8:0/12:
 #0: ffff88803de1e138 ((wq_completion)xfs-cil/loop1){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803de1e138 ((wq_completion)xfs-cil/loop1){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90000117c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90000117c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by khungtaskd/38:
 #0: ffffffff8dbb20c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #0: ffffffff8dbb20c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #0: ffffffff8dbb20c0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
3 locks held by kworker/u9:0/60:
 #0: ffff888028c92138 ((wq_completion)hci7){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff888028c92138 ((wq_completion)hci7){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000126fc40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000126fc40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
 #2: ffff8880310bcf80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1d3/0x400 net/bluetooth/hci_sync.c:331
2 locks held by kworker/u8:4/67:
 #0: ffff88813fe6c138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88813fe6c138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc9000153fc40 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc9000153fc40 ((reaper_work).work){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:6/140:
 #0: ffff88803a6cc138 ((wq_completion)xfs-cil/loop4#36){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803a6cc138 ((wq_completion)xfs-cil/loop4#36){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90003aa7c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90003aa7c40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/1:2/805:
 #0: ffff88802558a538 ((wq_completion)xfs-sync/loop1){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88802558a538 ((wq_completion)xfs-sync/loop1){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90005107c40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90005107c40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:8/1054:
 #0: ffff88803583d138 ((wq_completion)xfs-cil/loop3#2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803583d138 ((wq_completion)xfs-cil/loop3#2){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90005edfc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90005edfc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
3 locks held by kworker/u8:10/1400:
 #0: ffff88803478a138 ((wq_completion)loop8){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803478a138 ((wq_completion)loop8){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90006c0fc40 ((work_completion)(&lo->rootcg_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90006c0fc40 ((work_completion)(&lo->rootcg_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
 #2: ffff888025b90160 (&lo->lo_work_lock){+.+.}-{3:3}, at: spin_lock_irq include/linux/spinlock_rt.h:96 [inline]
 #2: ffff888025b90160 (&lo->lo_work_lock){+.+.}-{3:3}, at: loop_process_work+0x125/0x11b0 drivers/block/loop.c:1953
2 locks held by kworker/u8:12/1431:
 #0: ffff88813fe6c138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88813fe6c138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90006b0fc40 (connector_reaper_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90006b0fc40 (connector_reaper_work){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/u8:14/4094:
 #0: ffff88803ac6a138 ((wq_completion)xfs-cil/loop2#4){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803ac6a138 ((wq_completion)xfs-cil/loop2#4){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc900107bfc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc900107bfc40 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by udevd/5162:
2 locks held by getty/5551:
 #0: ffff8880370870a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e8b2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x462/0x13c0 drivers/tty/n_tty.c:2211
1 lock held by udevd/6362:
 #0: ffff88801b2c5a58 (&n->list_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #0: ffff88801b2c5a58 (&n->list_lock){+.+.}-{3:3}, at: get_partial_node_bulk mm/slub.c:3750 [inline]
 #0: ffff88801b2c5a58 (&n->list_lock){+.+.}-{3:3}, at: __refill_objects_node+0x87/0x560 mm/slub.c:7027
2 locks held by kworker/1:6/6523:
 #0: ffff8880376a0938 ((wq_completion)xfs-sync/loop4#37){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff8880376a0938 ((wq_completion)xfs-sync/loop4#37){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90004f07c40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90004f07c40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
2 locks held by kworker/1:7/6527:
 #0: ffff8880296d4d38 ((wq_completion)xfs-sync/loop3){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff8880296d4d38 ((wq_completion)xfs-sync/loop3){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc90004f27c40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc90004f27c40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by udevd/6623:
 #0: ffff88802205be30 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1043 [inline]
 #0: ffff88802205be30 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: blkdev_read_iter+0x2ff/0x440 block/fops.c:854
1 lock held by udevd/6644:
5 locks held by udevd/6645:
2 locks held by kworker/0:6/6670:
 #0: ffff88803b9f1d38 ((wq_completion)xfs-sync/loop2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3263 [inline]
 #0: ffff88803b9f1d38 ((wq_completion)xfs-sync/loop2){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3371
 #1: ffffc900015cfc40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3264 [inline]
 #1: ffffc900015cfc40 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3371
1 lock held by syz.1.22/6678:
 #0: ffff888036b5c480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.3.32/6804:
 #0: ffff8880247ec480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.2.37/6884:
 #0: ffff8880288bc480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz.4.146/8193:
 #0: ffff888034c2a480 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537
1 lock held by syz-executor/8516:
 #0: ffff88801b2c5a58 (&n->list_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #0: ffff88801b2c5a58 (&n->list_lock){+.+.}-{3:3}, at: get_partial_node_bulk mm/slub.c:3750 [inline]
 #0: ffff88801b2c5a58 (&n->list_lock){+.+.}-{3:3}, at: __refill_objects_node+0x87/0x560 mm/slub.c:7027
1 lock held by syz.5.318/10004:
 #0: ffff88803c46c0d0 (&type->s_umount_key#55/1){+.+.}-{4:4}, at: alloc_super+0x28c/0xac0 fs/super.c:345
2 locks held by syz.6.319/10016:
2 locks held by syz.0.320/10018:
2 locks held by syz.7.321/10020:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 38 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
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
CPU: 0 UID: 0 PID: 6644 Comm: udevd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:spin_lock include/linux/spinlock_rt.h:45 [inline]
RIP: 0010:__slab_free+0xe6/0x2a0 mm/slub.c:5519
Code: f0 49 0f c7 4e 20 0f 84 cd 00 00 00 48 89 44 24 40 48 89 54 24 48 e9 ac 00 00 00 49 8b 06 48 c1 e8 3a 4c 8b ac c3 c8 00 00 00 <4c> 89 ef e8 b2 9b f0 08 4d 8b 26 41 c1 ec 09 41 83 e4 01 f6 43 0a
RSP: 0018:ffffc900051978b0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88801b2c8280 RCX: 0000000000120011
RDX: ffff88805d4e99c8 RSI: ffff88805d4e99c8 RDI: ffff88801b2c8280
RBP: ffffc90005197938 R08: 0000000000000001 R09: ffffffff8227effc
R10: dffffc0000000000 R11: fffffbfff1e7e917 R12: 0000000000000000
R13: ffff88801b2c5b00 R14: ffffea0001753a00 R15: 0000000000000000
FS:  00007fe1d410f880(0000) GS:ffff88812660f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe1d37bb000 CR3: 0000000035e24000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x399/0x7b0 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
 security_inode_getattr+0x12b/0x310 security/security.c:1870
 vfs_getattr fs/stat.c:259 [inline]
 vfs_fstat fs/stat.c:281 [inline]
 __do_sys_newfstat fs/stat.c:551 [inline]
 __se_sys_newfstat fs/stat.c:546 [inline]
 __x64_sys_newfstat+0x13b/0x270 fs/stat.c:546
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe1d4267ad7
Code: 73 01 c3 48 8b 0d 21 f3 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 05 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 f1 f2 0d 00 f7 d8 64 89 02 b8
RSP: 002b:00007ffd1c62b248 EFLAGS: 00000297 ORIG_RAX: 0000000000000005
RAX: ffffffffffffffda RBX: 000055d891db7280 RCX: 00007fe1d4267ad7
RDX: 00007fe1d4345ea0 RSI: 00007ffd1c62b250 RDI: 000000000000000b
RBP: 00007fe1d4345ff0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000297 R12: 000000000000000a
R13: 0000000000003fff R14: 0000000000000000 R15: 000055d891db7280
 </TASK>


Tested on:

commit:         028ef9c9 Linux 7.0
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125260ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9800c931612cba58
dashboard link: https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1266d106580000

