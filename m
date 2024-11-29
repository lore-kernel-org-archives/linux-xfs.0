Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6858022EE4
	for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2024 04:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732855287; cv=none; b=uQi85P2VxrN6tLifsKZsFJblCFI7gmJ1D93HSdeNtYuC+9hnegHCOup48cjXm1FPuJyiVByRzLGi5n16yMX5Mx1UaTGkcBrgRyxlLCFA66EwLIp4NZC/NfZqBxHC21whLf5tSH4TxoxWDsAieqOy2iZveJQz/rxGb5MWC44rtzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732855287; c=relaxed/simple;
	bh=qj2KFFuGq7lQSVXkTR4kdy8s82aWgbgFRnXf+Gb62eY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mVOeCT5NeUNLcX+QwpGk5AchnhpF0YF4/FDSV2XCiU15Bu0hEyZpMk39NP/1ccMvKrKazbJQru0HObMlfR1gqHFQAqaPox8d/1FdNL7Zhjbzci1XA23uQM3UXD7NvZfVDENRFyvTtOW1C8AABqvdrLFpqFR9MDO4bqc8AfHzkOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-841ca214adaso128354839f.1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 20:41:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732855284; x=1733460084;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bm6mg1C4Ifq86FYdHetan/X5KCf84NQHUUVteA+UGlk=;
        b=HbzvDwT+zzO9IM1hoREHqrdEJXsJQcUBy6NPs1Pwliu4eE30HADhH7mHa2QzC39zki
         x+KAztov47+etSmaIlPFnGhVgdGQx7be6qirKOznWfcEtBhJtcjX+7DLATNcOjM70GF+
         YBNOIsYeTnDyQsiwTEnlCdn90a8AgkGnDCYv6X8TYN+Gp0W43ismwsw2ljkf7aVaHLj6
         LH51FAgLewSvRlyDRtZdShfA/lwTcK1voewrISZlcoBmNNA6bqUZeVnPRVfTwRbnsjXW
         qBgK0LHf9jDw5wG1QJPsJ/mYtXIwQESvrpZUOBxsNsljaM200/vqi5Mo6fRYS7F9xQAB
         s/+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWiKNVnPB8PkVs11HayHpxCk/OkyOE7SJm1pzIf7sBjd/ccUfzV4QL3UVljUiztutBoGDXlcnpZ4lc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZbTLk2HHZt9dTJ2cHCt1ek38GwJKWOZRwb7IlwP1N7VnnBdLi
	IZLPUoIxz3kEgB+EqCvw/4YgyVMe2p/JFljTp3vYYKGhULWi8icmZ7mcTCa0dj5j0fm2sRRfVnV
	WPnRKDH7zX6UMx9IukprsyNxy80O54sD4+x8PrvjbV1MXs3CblJ2c/QY=
X-Google-Smtp-Source: AGHT+IEwAJaQdNQNnz5ms2cYidZb4LDrpozRBfQ56yNpGbTtYABgXz3xw5s6f3VtXckYi8a6uRUVdx7UdXdl+lbDDjh4sAMdwKSg
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca8:b0:3a6:ac4e:264a with SMTP id
 e9e14a558f8ab-3a7c555f0ccmr88080475ab.10.1732855284676; Thu, 28 Nov 2024
 20:41:24 -0800 (PST)
Date: Thu, 28 Nov 2024 20:41:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674945f4.050a0220.253251.00a1.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_qm_dqrele
From: syzbot <syzbot+da63448ae44acf902d11@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b86545e02e8c Merge tag 'acpi-6.13-rc1-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=157723c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f0b9d4913852126
dashboard link: https://syzkaller.appspot.com/bug?extid=da63448ae44acf902d11
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b86545e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/00ec87aaa7ee/vmlinux-b86545e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fcc70e20d51b/bzImage-b86545e0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+da63448ae44acf902d11@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-10553-gb86545e02e8c #0 Not tainted
------------------------------------------------------
kswapd1/80 is trying to acquire lock:
ffff8880548028e0 (&dqp->q_qlock){+.+.}-{4:4}, at: xfs_dqlock fs/xfs/xfs_dquot.h:131 [inline]
ffff8880548028e0 (&dqp->q_qlock){+.+.}-{4:4}, at: xfs_qm_dqrele+0xce/0x240 fs/xfs/xfs_dquot.c:1124

but task is already holding lock:
ffffffff8ea3f620 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6864 [inline]
ffffffff8ea3f620 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7246

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __fs_reclaim_acquire mm/page_alloc.c:3851 [inline]
       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3865
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4055 [inline]
       slab_alloc_node mm/slub.c:4133 [inline]
       __kmalloc_cache_noprof+0x41/0x390 mm/slub.c:4309
       kmalloc_noprof include/linux/slab.h:901 [inline]
       kzalloc_noprof include/linux/slab.h:1037 [inline]
       kobject_uevent_env+0x28b/0x8e0 lib/kobject_uevent.c:540
       set_capacity_and_notify+0x206/0x240 block/genhd.c:95
       loop_set_size drivers/block/loop.c:232 [inline]
       loop_set_status+0x584/0x8f0 drivers/block/loop.c:1285
       lo_ioctl+0xcbc/0x1f50
       blkdev_ioctl+0x57d/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
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
       xfs_qm_quotacheck+0x357/0x6f0 fs/xfs/xfs_qm.c:1569
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

-> #0 (&dqp->q_qlock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       xfs_dqlock fs/xfs/xfs_dquot.h:131 [inline]
       xfs_qm_dqrele+0xce/0x240 fs/xfs/xfs_dquot.c:1124
       xfs_qm_dqdetach+0x157/0x380 fs/xfs/xfs_qm.c:422
       xfs_inode_mark_reclaimable+0x276/0xf60 fs/xfs/xfs_icache.c:2253
       destroy_inode fs/inode.c:386 [inline]
       evict+0x7af/0x9a0 fs/inode.c:827
       dispose_list fs/inode.c:845 [inline]
       prune_icache_sb+0x239/0x2f0 fs/inode.c:1033
       super_cache_scan+0x38c/0x4b0 fs/super.c:223
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
  &dqp->q_qlock --> &q->q_usage_counter(io)#17 --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&q->q_usage_counter(io)#17);
                               lock(fs_reclaim);
  lock(&dqp->q_qlock);

 *** DEADLOCK ***

2 locks held by kswapd1/80:
 #0: ffffffff8ea3f620 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6864 [inline]
 #0: ffffffff8ea3f620 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7246
 #1: ffff88801fbb20e0 (&type->s_umount_key#45){++++}-{4:4}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff88801fbb20e0 (&type->s_umount_key#45){++++}-{4:4}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 80 Comm: kswapd1 Not tainted 6.12.0-syzkaller-10553-gb86545e02e8c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
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
 xfs_dqlock fs/xfs/xfs_dquot.h:131 [inline]
 xfs_qm_dqrele+0xce/0x240 fs/xfs/xfs_dquot.c:1124
 xfs_qm_dqdetach+0x157/0x380 fs/xfs/xfs_qm.c:422
 xfs_inode_mark_reclaimable+0x276/0xf60 fs/xfs/xfs_icache.c:2253
 destroy_inode fs/inode.c:386 [inline]
 evict+0x7af/0x9a0 fs/inode.c:827
 dispose_list fs/inode.c:845 [inline]
 prune_icache_sb+0x239/0x2f0 fs/inode.c:1033
 super_cache_scan+0x38c/0x4b0 fs/super.c:223
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
