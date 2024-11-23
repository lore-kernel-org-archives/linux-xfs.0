Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA571BA42
	for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2024 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732374263; cv=none; b=ANVYipfd8bPC/9S1VJDT1Q4ag+VGw5aDNw9Xvavu3G8FBa82DRSrSFiG+ji9q8yS4Wwd/VWohjSnxp2mar1pZ4haxhJcBKzI0kZoe+ASQqyMpCt8aPlRdY8Ypnk8KmkxWRP+Rd/hWh/MXpR/L46zRqA0z54yx5v3nsZMZ9OUkHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732374263; c=relaxed/simple;
	bh=07igk9HLAUcioR9FrXoWK+NULrK6z9HvKQZyKrsuQWc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r7R+aowdpgTvbMdaPfQNaj6TCPJv0l5eASHAVhZI5Rt/Mz588aXAuCX27HQo1B2AwTN9I7UaSEJRKXdLOrk2rlTnM8rCiT+8hhlBgCZ4VVE1Z7dADBJmvQ/lnFM40B8+tkQGB/V3Yj/4cSOvJiuwjGpWUTlRGgZZE0KT8Qjpy/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83abb901672so357075439f.3
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2024 07:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732374261; x=1732979061;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTGiuF0orPc4cVkC95Pz41llff12Woo35NZTlolv2HI=;
        b=PCTPmBkdaJEHGAh5HjYGbVI89ntPM4rVCG+gBgI+kkDcEEhh26ZllqaNbDZvB7DQcO
         W1F9+WMRjadP3gf3gN1hUy5ELYYlaSNlxSVIQiLf9FZZ5b+xPKevVS2Z8iEJawudI7nt
         BiD5b2le2+P2xsnnh+4NCFrP/BGE+fPlY5ejQRc2jlT6UqODKI9Z0lyGMERWtCb44AyL
         YbOcsIOtEOVcbu3kdNYYMZF7MYc50WNYpIe3LXvqkwYVzPiETft00AvuGU9Xa3Fs1m5V
         AERaMsaXGCgoQQjKHpzrW8qE2XxaMKK2Xz8Fctts9NM48j0/Ougt4KRqriTq5ysMzTcF
         GY4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZyUJPcU83L0d2J3+1xD3zxc1c+fAr70f7O2ACAfxBPBv5lInPSIE8lAcc5DIWpBgtwvDMAhCw6Do=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR3clLuRMNiGqkzwm7Og+CXHIu+dA7W1IkwM4k1GTA8J56JK9o
	kKnMyNCnlHMZeu6CRfXPenGYBigUkx7QGGUiSZW6psVeV/6+2umiDdA8Due0kMpelv2qg5lBp1b
	rperjBxFESss28DriucS79PHiPsChRCaPR6AZ6dw7A/lzCvWq7wUmwv8=
X-Google-Smtp-Source: AGHT+IFb2hLTa1c0hJRM8Fm0jTHppZqJL4RCZecASYpGtoimOTIWNK1h/KGEJgaaxNl4NO3P3B4Y7rnpdSPd+xSgMk8SD5ad9xBp
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c8:b0:3a7:5cda:2769 with SMTP id
 e9e14a558f8ab-3a79aeaec6emr80833655ab.12.1732374260908; Sat, 23 Nov 2024
 07:04:20 -0800 (PST)
Date: Sat, 23 Nov 2024 07:04:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6741eef4.050a0220.1cc393.0016.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_qm_dqfree_one (3)
From: syzbot <syzbot+aceb3ddca9f98c7c934f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    414c97c966b6 Add linux-next specific files for 20241119
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=167e5ac0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
dashboard link: https://syzkaller.appspot.com/bug?extid=aceb3ddca9f98c7c934f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/394331d94392/disk-414c97c9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ad0dc40a5d80/vmlinux-414c97c9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fccab23947ef/bzImage-414c97c9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aceb3ddca9f98c7c934f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-next-20241119-syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/88 is trying to acquire lock:
ffff8881fb5e5958 (&qinf->qi_tree_lock){+.+.}-{4:4}, at: xfs_qm_dqfree_one+0x66/0x170 fs/xfs/xfs_qm.c:1874

but task is already holding lock:
ffffffff8ea35ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6864 [inline]
ffffffff8ea35ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7246

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __fs_reclaim_acquire mm/page_alloc.c:3887 [inline]
       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3901
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4055 [inline]
       slab_alloc_node mm/slub.c:4133 [inline]
       __kmalloc_cache_noprof+0x41/0x390 mm/slub.c:4309
       kmalloc_noprof include/linux/slab.h:901 [inline]
       kzalloc_noprof include/linux/slab.h:1037 [inline]
       kobject_uevent_env+0x28b/0x8e0 lib/kobject_uevent.c:540
       loop_set_size drivers/block/loop.c:233 [inline]
       loop_set_status+0x5f0/0x8f0 drivers/block/loop.c:1285
       lo_ioctl+0xcbc/0x1f50
       blkdev_ioctl+0x57d/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#20){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1536/0x23a0 block/blk-mq.c:3092
       __submit_bio+0x2c6/0x560 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:739
       xlog_state_release_iclog+0x41d/0x7b0 fs/xfs/xfs_log.c:567
       xlog_force_iclog fs/xfs/xfs_log.c:802 [inline]
       xlog_force_and_check_iclog fs/xfs/xfs_log.c:2866 [inline]
       xfs_log_force+0x616/0x960 fs/xfs/xfs_log.c:2943
       xfs_qm_dqflush+0xd5e/0x15e0 fs/xfs/xfs_dquot.c:1333
       xfs_qm_flush_one+0x129/0x430 fs/xfs/xfs_qm.c:1489
       xfs_qm_dquot_walk+0x232/0x4a0 fs/xfs/xfs_qm.c:90
       xfs_qm_quotacheck+0x3aa/0x6f0 fs/xfs/xfs_qm.c:1573
       xfs_qm_mount_quotas+0x38f/0x680 fs/xfs/xfs_qm.c:1693
       xfs_mountfs+0x1e60/0x2410 fs/xfs/xfs_mount.c:1030
       xfs_fs_fill_super+0x12db/0x1590 fs/xfs/xfs_super.c:1791
       get_tree_bdev_flags+0x48c/0x5c0 fs/super.c:1636
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&xfs_dquot_group_class){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       xfs_dqlock fs/xfs/xfs_dquot.h:131 [inline]
       xfs_qm_dqget_cache_insert fs/xfs/xfs_dquot.c:843 [inline]
       xfs_qm_dqget+0x370/0x6f0 fs/xfs/xfs_dquot.c:910
       xfs_qm_quotacheck_dqadjust+0xea/0x5a0 fs/xfs/xfs_qm.c:1297
       xfs_qm_dqusage_adjust+0x6a8/0x850 fs/xfs/xfs_qm.c:1426
       xfs_iwalk_ag_recs+0x4e1/0x820 fs/xfs/xfs_iwalk.c:209
       xfs_iwalk_run_callbacks+0x218/0x470 fs/xfs/xfs_iwalk.c:370
       xfs_iwalk_ag+0xa9a/0xbb0 fs/xfs/xfs_iwalk.c:476
       xfs_iwalk_ag_work+0xfb/0x1b0 fs/xfs/xfs_iwalk.c:625
       xfs_pwork_work+0x7f/0x190 fs/xfs/xfs_pwork.c:47
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (&qinf->qi_tree_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       xfs_qm_dqfree_one+0x66/0x170 fs/xfs/xfs_qm.c:1874
       xfs_qm_shrink_scan+0x33f/0x400 fs/xfs/xfs_qm.c:558
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:437
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
       shrink_one+0x43b/0x850 mm/vmscan.c:4836
       shrink_many mm/vmscan.c:4897 [inline]
       lru_gen_shrink_node mm/vmscan.c:4975 [inline]
       shrink_node+0x37c5/0x3e50 mm/vmscan.c:5956
       kswapd_shrink_node mm/vmscan.c:6785 [inline]
       balance_pgdat mm/vmscan.c:6977 [inline]
       kswapd+0x1ca9/0x3700 mm/vmscan.c:7246
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &qinf->qi_tree_lock --> &q->q_usage_counter(io)#20 --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&q->q_usage_counter(io)#20);
                               lock(fs_reclaim);
  lock(&qinf->qi_tree_lock);

 *** DEADLOCK ***

1 lock held by kswapd0/88:
 #0: ffffffff8ea35ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6864 [inline]
 #0: ffffffff8ea35ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7246

stack backtrace:
CPU: 1 UID: 0 PID: 88 Comm: kswapd0 Not tainted 6.12.0-next-20241119-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
 xfs_qm_dqfree_one+0x66/0x170 fs/xfs/xfs_qm.c:1874
 xfs_qm_shrink_scan+0x33f/0x400 fs/xfs/xfs_qm.c:558
 do_shrink_slab+0x701/0x1160 mm/shrinker.c:437
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
 shrink_one+0x43b/0x850 mm/vmscan.c:4836
 shrink_many mm/vmscan.c:4897 [inline]
 lru_gen_shrink_node mm/vmscan.c:4975 [inline]
 shrink_node+0x37c5/0x3e50 mm/vmscan.c:5956
 kswapd_shrink_node mm/vmscan.c:6785 [inline]
 balance_pgdat mm/vmscan.c:6977 [inline]
 kswapd+0x1ca9/0x3700 mm/vmscan.c:7246
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
