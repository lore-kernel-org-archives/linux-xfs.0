Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2BE74E26
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 05:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785454; cv=none; b=PoduNU2GkYHYisE1oHDtZysxfKstP0J5QzMVzmv1ksM1rTTRBZcslS9IHMBD3jZH5T6BOWrZSz33GZRzYJvr2plL2SyII1z9rS7lRS+Tv5PMYV6S6WPyJlqX5YyO4C3kLiT6KGb2cMtpOiq+Vi4LuLZ9t5apZB5VzusJPsOsonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785454; c=relaxed/simple;
	bh=pBuWn8AfFXb38y0SWiZV88WU7toeviMwIHB1vs82FQA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Cdm5qZYUImCFLzWIL2ztJA7VnQa18tz7R50UCX0GOpeNihegOTYP/b2IHoIashH7eI2jku4kQSvm6AWLitI5oSwAfP1aGTf4osHYyR+pRa0++fxPPVCB4J9v0nFNHVrmTN76ifwLkBGq2MrUkZvJguvXpH+6fI4lTo846PPXAko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f901cd3b5so170481339f.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 22:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723785452; x=1724390252;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iFfyAQZmBgEj24rZ1Wg2lASv0otkr7m1yeyP9Qr3OoU=;
        b=PyDneqye2qHcdqIQxP4cWTwaAXSULm0rCnKqrLX+mbdsmIKtsia2lZYVe4wJkWCvc1
         fDF4gkV7iTaDBkT5SwBia/67xJ209Jm+elCKld4JNj5tBNWEDSwfk4skl9yV8Eqkc6qw
         2FqiZyE55bKUNq+mUMODALjx+HF+wAWJLOcXczQ2zJNpYwdqhEuLBp/JA4ChubDqPZyF
         WUkwBF4XPFToJb78wRBYGcczhSE/5jeqvaADQaFRNI5XXCA80hUX4hVH7/YSh8TvyUrs
         iSqaV1uznXPsuCDQsmgTTC4YnUmU131sLCawByKQ335+3ML1F+NkYxVsesylACo7flur
         lmIg==
X-Forwarded-Encrypted: i=1; AJvYcCUsvbyxp+nw/HbTWqx0oND5uuK45iRWrU+fL1KWXiLDdfJnV9d1Bm0XOUkz/YdjsQ5p7fYjBHC20nLoVI0620QOHaDsAV/3aSaz
X-Gm-Message-State: AOJu0YxlI4tUAVyUdvmtqvm6gKEezFQX8XFysmwmo+oCUhdhOG6/QsUr
	dRTHdYNNW3YwSabSafp2XGGreNcXpfj/b9EDNM+jGj/soDyRRYsivBAnXP7KcFJVtuFAtZFeL/3
	v4hhv8gFxPZPxuoyAx231uoXm4048+n1kRUBCsWv6OYXtRfqE3Gwe3eg=
X-Google-Smtp-Source: AGHT+IHaz5OLuVxVbqnWgcOLBaOryh2OWXzsSosW6OSq8kqulB7VSLlhs85kZZb5Fi/FocNefNWoD9VReHJMyNyjSQhBipqr5h2D
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190f:b0:39d:18da:7d86 with SMTP id
 e9e14a558f8ab-39d26d94d6fmr1586035ab.5.1723785451991; Thu, 15 Aug 2024
 22:17:31 -0700 (PDT)
Date: Thu, 15 Aug 2024 22:17:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008905bf061fc61371@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin (2)
From: syzbot <syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1fb918967b56 Merge tag 'for-6.11-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115e1429980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=92c0312151c4e32e
dashboard link: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7b0e9f1a37aa/disk-1fb91896.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d554edb47a8e/vmlinux-1fb91896.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d1ec77d87b65/bzImage-1fb91896.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com

INFO: task kworker/1:1H:43 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1H    state:D stack:25320 pid:43    tgid:43    ppid:2      flags:0x00004000
Workqueue: xfs-log/loop4 xlog_ioend_work
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
INFO: task syz.4.26:5406 blocked for more than 144 seconds.
      Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.26        state:D stack:21208 pid:5406  tgid:5405  ppid:5216   flags:0x00004004
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
RIP: 0033:0x7f5e315799b9
RSP: 002b:00007f5e32318038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5e31715f80 RCX: 00007f5e315799b9
RDX: 0000000020000040 RSI: 0000000041009432 RDI: 0000000000000008
RBP: 00007f5e315e78d8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f5e31715f80 R15: 00007ffda968eb98
 </TASK>

Showing all locks held in the system:
4 locks held by kworker/u8:0/11:
 #0: ffff8880b923e9d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:560
 #1: ffff8880b9228948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x441/0x770 kernel/sched/psi.c:989
 #2: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:326 [inline]
 #2: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #2: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
 #2: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: batadv_nc_worker+0xcb/0x610 net/batman-adv/network-coding.c:719
 #3: ffffffff94ebb578 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0x16d/0x510 lib/debugobjects.c:709
3 locks held by kworker/u8:1/12:
 #0: ffff888015489148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015489148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90000117d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90000117d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
1 lock held by khungtaskd/30:
 #0: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:326 [inline]
 #0: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7382e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6626
2 locks held by kworker/1:1H/43:
 #0: ffff88807dc5a148 ((wq_completion)xfs-log/loop4){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff88807dc5a148 ((wq_completion)xfs-log/loop4){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90000b37d00 ((work_completion)(&iclog->ic_end_io_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90000b37d00 ((work_completion)(&iclog->ic_end_io_work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
5 locks held by kworker/u8:4/63:
 #0: ffff8880162e3148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff8880162e3148 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc900015e7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc900015e7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8fa63750 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594
 #3: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xe9/0xa90 net/core/dev.c:11875
 #4: ffffffff8e73d6b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:328 [inline]
 #4: ffffffff8e73d6b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:958
3 locks held by kworker/u8:5/83:
 #0: ffff88802a205148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff88802a205148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc9000233fd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc9000233fd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4194
2 locks held by dhcpcd/4881:
 #0: ffff88807c593678 (nlk_cb_mutex-ROUTE){+.+.}-{3:3}, at: __netlink_dump_start+0x119/0x780 net/netlink/af_netlink.c:2404
 #1: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #1: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_dumpit+0x99/0x200 net/core/rtnetlink.c:6506
2 locks held by getty/4971:
 #0: ffff88802f8080a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031332f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ac/0x1e00 drivers/tty/n_tty.c:2211
3 locks held by kworker/1:5/5272:
 #0: ffff888015480948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015480948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc900044f7d00 ((work_completion)(&(&devlink->rwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc900044f7d00 ((work_completion)(&(&devlink->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8e73d6b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:328 [inline]
 #2: ffffffff8e73d6b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:958
1 lock held by syz.4.26/5406:
 #0: ffff88806c67c420 (sb_writers#19){.+.+}-{0:0}, at: mnt_want_write_file+0x61/0x200 fs/namespace.c:559
3 locks held by syz-executor/7304:
 #0: ffffffff8fad5a30 (cb_lock){++++}-{3:3}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1218
 #1: ffffffff8fad58e8 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:35 [inline]
 #1: ffffffff8fad58e8 (genl_mutex){+.+.}-{3:3}, at: genl_op_lock net/netlink/genetlink.c:60 [inline]
 #1: ffffffff8fad58e8 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x121/0xec0 net/netlink/genetlink.c:1209
 #2: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: ieee80211_register_hw+0x2c4e/0x3e10 net/mac80211/main.c:1518
7 locks held by syz-executor/7537:
 #0: ffff88806d07a420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2881 [inline]
 #0: ffff88806d07a420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x227/0xc90 fs/read_write.c:586
 #1: ffff88805dc05c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1eb/0x500 fs/kernfs/file.c:325
 #2: ffff8880226511e8 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20f/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f30cda8 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: new_device_store+0x1b4/0x890 drivers/net/netdevsim/bus.c:166
 #4: ffff8880605da0e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:1009 [inline]
 #4: ffff8880605da0e8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x8e/0x520 drivers/base/dd.c:1004
 #5: ffff88804e059250 (&devlink->lock_key#27){+.+.}-{3:3}, at: nsim_drv_probe+0xcb/0xb80 drivers/net/netdevsim/dev.c:1534
 #6: ffffffff8fa702c8 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3872
3 locks held by syz.1.317/7709:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 141 Comm: kworker/u8:6 Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Workqueue: events_unbound cfg80211_wiphy_work
RIP: 0010:unwind_next_frame+0x796/0x2a00 arch/x86/kernel/unwind_orc.c:512
Code: 48 c1 e8 03 42 0f b6 04 28 84 c0 4d 89 f7 0f 85 5b 1a 00 00 0f b7 5d 00 c1 eb 0b 80 e3 01 48 8b 44 24 78 42 0f b6 04 28 84 c0 <4c> 8b 74 24 48 0f 85 5e 1a 00 00 88 1a 48 89 6c 24 28 0f b7 6d 00
RSP: 0018:ffffc90002d6e928 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88801b7a3c00
RDX: ffffc90002d6ea35 RSI: ffffffff8e5a3d80 RDI: 0000000000000002
RBP: ffffffff9087a06e R08: 0000000000000003 R09: ffffffff81412e12
R10: 0000000000000002 R11: ffff88801b7a3c00 R12: ffffffff900f0c7c
R13: dffffc0000000000 R14: 1ffff920005add40 R15: 1ffff920005add40
FS:  0000000000000000(0000) GS:ffff8880b9300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555569aa15c8 CR3: 0000000012890000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 arch_stack_walk+0x151/0x1b0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2252 [inline]
 slab_free mm/slub.c:4473 [inline]
 kfree+0x149/0x360 mm/slub.c:4594
 ieee80211_inform_bss+0xbb2/0x1080 net/mac80211/scan.c:160
 rdev_inform_bss net/wireless/rdev-ops.h:418 [inline]
 cfg80211_inform_single_bss_data+0xe93/0x2030 net/wireless/scan.c:2335
 cfg80211_inform_bss_data+0x3dd/0x5a70 net/wireless/scan.c:3159
 cfg80211_inform_bss_frame_data+0x3b8/0x720 net/wireless/scan.c:3254
 ieee80211_bss_info_update+0x8a7/0xbc0 net/mac80211/scan.c:226
 ieee80211_rx_bss_info net/mac80211/ibss.c:1100 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1579 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x1962/0x2d70 net/mac80211/ibss.c:1606
 ieee80211_iface_process_skb net/mac80211/iface.c:1588 [inline]
 ieee80211_iface_work+0x8a5/0xf20 net/mac80211/iface.c:1642
 cfg80211_wiphy_work+0x2db/0x490 net/wireless/core.c:440
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
