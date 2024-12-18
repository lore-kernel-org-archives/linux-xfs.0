Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173899460
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 00:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734481648; cv=none; b=lOvAUVtIVBEEZ9qBCDslA7iHBaary7AXtwqVoO/2hOKTs//CkyxKtFMcWHl+YGLpKcFfvfPWFB/axs9CZOuGrs0uMnUHZ8dZ5uwvDtLPbetjBZXXoKyVOdtK7pR4B1NEfGBcB3fisAFXzB/sYUJN9Hwj2fo0ppgteGMtlSeRRpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734481648; c=relaxed/simple;
	bh=NKSQJcLfIX4TXBrPQM3Z7qRCP6WUPo25U3pDL7fLOwo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RXQMMSj5Fqo+3SLE1bdfH8C4XpF5TRtcJsIr8qa3JKCJD1A24Uas7gk1hlPvcv+yY63JLLwlJB4ZLxlow6mCjK1WImtgysMj1F24Ol7DRSPRvrY23rwM8BhXnT5xyjc12/Zq8C7+Ac2vrJIBzUPL1e4/lH6eAfk59dTvWlz1JQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a9d195e6e5so60657555ab.2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 16:27:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734481645; x=1735086445;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nzzzAYviRF3iBCYz59WzBgpdQGau7YtZrcQ/qAeL5lo=;
        b=fy5zDCWhTaiEkXYQO71LhAfGjOTfZTFN1zWCr/Wof/drj58Wb8faNJ3mYIieT8lBez
         BHNGhSSbv35KTyjQeZP1xsNvuucZ6vszgT07rAiuUAll4/+ZATZAzhqhuIbu8bszFcjv
         M84iyecxA2NHkDb9gxonGYtwplSShP7bgi17QXoHL2oT0GndDhcXr6g1Zcuhlo/gbrWs
         N5e8QcrOt5H4RCD5lEtSzRNjXmi9t2pCOqn+3uJ10PkrlSgoj8Dv2Z211daoZ0E8dmF2
         LbkfJs8iu5UnAD7F3CMuZeIeujam3hi7sW7bPfGd9dEDB143mpfV11IRCuj2eWVjZ/CJ
         XN0A==
X-Forwarded-Encrypted: i=1; AJvYcCVy19FgdtWSl2FDD8za3MnwbpVh3XffMac0PtOef5GsfyjLcnzhKLECdXDFQv6f43KenPdWUIyhELE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLNpRmRJ9Ic1DEcbVIS04JpOT/SexMR0g8Ze3oSfeHc9uMcKRm
	lyT/faUJNGCYuQGHYRihnDZYiN7tdXhzujIktWw2r4TS6wHJ9tOsbMWtjEOHkKMkjKUjRuLfM6z
	heUdGQKx9QfT/9sPXCywEE5qjevTlP18TR9faxAgPxgjb9kGbkfJM19g=
X-Google-Smtp-Source: AGHT+IHCDuoYffjFxcTaRfIi7fAV7Qrv0xMGMRWw35AFpFfkGSYeVcsFqlnj3n9dzx2R/CxRrBcJ2VBXbrt4Qsn7fwtlhv3ccmuo
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:154e:b0:3a7:e732:471f with SMTP id
 e9e14a558f8ab-3bdc003e838mr9459835ab.1.1734481645246; Tue, 17 Dec 2024
 16:27:25 -0800 (PST)
Date: Tue, 17 Dec 2024 16:27:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676216ed.050a0220.29fcd0.007e.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_dquot_detach_buf
From: syzbot <syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    78d4f34e2115 Linux 6.13-rc3
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=154b47e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fe704d2356374ad
dashboard link: https://syzkaller.appspot.com/bug?extid=3126ab3db03db42e7a31
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108434f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fef344580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/01951386840d/disk-78d4f34e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/25dd6cdc37e1/vmlinux-78d4f34e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/76c0990dd6b1/bzImage-78d4f34e.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/22e572a24a7b/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/0171ea56f8f3/mount_1.gz

The issue was bisected to:

commit ca378189fdfa890a4f0622f85ee41b710bbac271
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Mon Dec 2 18:57:39 2024 +0000

    xfs: convert quotacheck to attach dquot buffers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122f34f8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=112f34f8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=162f34f8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Fixes: ca378189fdfa ("xfs: convert quotacheck to attach dquot buffers")

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc3-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor179/5816 is trying to acquire lock:
ffff8880292b4170 (&lp->qli_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff8880292b4170 (&lp->qli_lock){+.+.}-{3:3}, at: xfs_dquot_detach_buf+0x2f/0x1a0 fs/xfs/xfs_dquot.c:83

but task is already holding lock:
ffff888032810830 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888032810830 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x24b/0x4e0 mm/list_lru.c:77

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&l->lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       lock_list_lru_of_memcg+0x24b/0x4e0 mm/list_lru.c:77
       list_lru_add+0x59/0x270 mm/list_lru.c:164
       xfs_buf_rele_cached fs/xfs/xfs_buf.c:1106 [inline]
       xfs_buf_rele+0x4ca/0x15b0 fs/xfs/xfs_buf.c:1151
       xfs_imap_lookup+0x26a/0x750 fs/xfs/libxfs/xfs_ialloc.c:2431
       xfs_imap+0x54d/0x1090 fs/xfs/libxfs/xfs_ialloc.c:2514
       xfs_iget_cache_miss fs/xfs/xfs_icache.c:644 [inline]
       xfs_iget+0xaf6/0x2ec0 fs/xfs/xfs_icache.c:806
       xfs_mountfs+0x13df/0x2410 fs/xfs/xfs_mount.c:919
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

-> #2 (&bch->bc_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       _atomic_dec_and_lock+0xb8/0x130 lib/dec_and_lock.c:28
       xfs_buf_rele_cached fs/xfs/xfs_buf.c:1085 [inline]
       xfs_buf_rele+0x178/0x15b0 fs/xfs/xfs_buf.c:1151
       xfs_imap_lookup+0x26a/0x750 fs/xfs/libxfs/xfs_ialloc.c:2431
       xfs_imap+0x54d/0x1090 fs/xfs/libxfs/xfs_ialloc.c:2514
       xfs_iget_cache_miss fs/xfs/xfs_icache.c:644 [inline]
       xfs_iget+0xaf6/0x2ec0 fs/xfs/xfs_icache.c:806
       xfs_mountfs+0x13df/0x2410 fs/xfs/xfs_mount.c:919
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

-> #1 (&bp->b_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       xfs_buf_rele_cached fs/xfs/xfs_buf.c:1084 [inline]
       xfs_buf_rele+0x164/0x15b0 fs/xfs/xfs_buf.c:1151
       xfs_dquot_attach_buf+0x33e/0x560 fs/xfs/xfs_dquot.c:1345
       xfs_qm_quotacheck_dqadjust+0x13f/0x5e0 fs/xfs/xfs_qm.c:1341
       xfs_qm_dqusage_adjust+0x6a8/0x850 fs/xfs/xfs_qm.c:1464
       xfs_iwalk_ag_recs+0x4e3/0x820 fs/xfs/xfs_iwalk.c:209
       xfs_iwalk_run_callbacks+0x218/0x470 fs/xfs/xfs_iwalk.c:370
       xfs_iwalk_ag+0xa9a/0xbb0 fs/xfs/xfs_iwalk.c:476
       xfs_iwalk_ag_work+0xfb/0x1b0 fs/xfs/xfs_iwalk.c:625
       xfs_pwork_work+0x7f/0x190 fs/xfs/xfs_pwork.c:47
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (&lp->qli_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       xfs_dquot_detach_buf+0x2f/0x1a0 fs/xfs/xfs_dquot.c:83
       xfs_qm_dquot_isolate+0x49d/0x1420 fs/xfs/xfs_qm.c:528
       __list_lru_walk_one+0x170/0x470 mm/list_lru.c:301
       list_lru_walk_one+0x3c/0x50 mm/list_lru.c:338
       list_lru_shrink_walk include/linux/list_lru.h:240 [inline]
       xfs_qm_shrink_scan+0x1e1/0x400 fs/xfs/xfs_qm.c:574
       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
       drop_slab_node mm/vmscan.c:414 [inline]
       drop_slab+0x142/0x280 mm/vmscan.c:432
       drop_caches_sysctl_handler+0xbc/0x160 fs/drop_caches.c:68
       proc_sys_call_handler+0x5ec/0x920 fs/proc/proc_sysctl.c:601
       do_iter_readv_writev+0x600/0x880
       vfs_writev+0x376/0xba0 fs/read_write.c:1050
       do_writev+0x1b6/0x360 fs/read_write.c:1096
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &lp->qli_lock --> &bch->bc_lock --> &l->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&l->lock);
                               lock(&bch->bc_lock);
                               lock(&l->lock);
  lock(&lp->qli_lock);

 *** DEADLOCK ***

3 locks held by syz-executor179/5816:
 #0: ffff888023dba420 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #0: ffff888023dba420 (sb_writers#3){.+.+}-{0:0}, at: vfs_writev+0x2d1/0xba0 fs/read_write.c:1048
 #1: ffff888032810830 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #1: ffff888032810830 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x24b/0x4e0 mm/list_lru.c:77
 #2: ffff8880292b4258 (&xfs_dquot_group_class){+.+.}-{4:4}, at: xfs_dqlock_nowait fs/xfs/xfs_dquot.h:126 [inline]
 #2: ffff8880292b4258 (&xfs_dquot_group_class){+.+.}-{4:4}, at: xfs_qm_dquot_isolate+0x8d/0x1420 fs/xfs/xfs_qm.c:467

stack backtrace:
CPU: 0 UID: 0 PID: 5816 Comm: syz-executor179 Not tainted 6.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
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
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 xfs_dquot_detach_buf+0x2f/0x1a0 fs/xfs/xfs_dquot.c:83
 xfs_qm_dquot_isolate+0x49d/0x1420 fs/xfs/xfs_qm.c:528
 __list_lru_walk_one+0x170/0x470 mm/list_lru.c:301
 list_lru_walk_one+0x3c/0x50 mm/list_lru.c:338
 list_lru_shrink_walk include/linux/list_lru.h:240 [inline]
 xfs_qm_shrink_scan+0x1e1/0x400 fs/xfs/xfs_qm.c:574
 do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:414 [inline]
 drop_slab+0x142/0x280 mm/vmscan.c:432
 drop_caches_sysctl_handler+0xbc/0x160 fs/drop_caches.c:68
 proc_sys_call_handler+0x5ec/0x920 fs/proc/proc_sysctl.c:601
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1050
 do_writev+0x1b6/0x360 fs/read_write.c:1096
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5dd34a0ab9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd98ced508 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00007f5dd34a0ab9
RDX: 0000000000000001 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00007f5dd351f610 R08: 0000000000000000 R09: 00007ffd98ced6d8
R10: 00000000000001e3 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffd98ced6c8 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
