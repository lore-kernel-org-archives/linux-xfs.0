Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A591929ACCD
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783882182; cv=none; b=KBit7R6g4ZBU1XAe4ISbEU6UztKJGgjIUdgPBSL2Ehf6lPDp2tmdqXsGWYmsVHDmlJh0XHDjMRXikRlpvKqaLgKO2E+Bf9KnaiGKjN4Ng+m7AWnLHWDjtbIFUWfkR6k4SMfbt0+6GRcoQ67o1MHr7L8Efiev/ZJvgvGOZvM7jPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783882182; c=relaxed/simple;
	bh=U/Nn4wHvOsW3xC6GnOx/hZfKlEwVZiFYmxvm8SKCmWQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tlbB4ZT9mekg2vDSEQ1FAdEh3OZz8rPkaN2aPv1HFz7CsttNRAazw6+g1iC9UpuxGOEyJG8cblCHLxaAt2AkEKLSb6SRewfAOTbU8QV6HWdxM4FjwyQquxBbr8wRfSLBRC9kIqUPLqRGDmJNErrEHY2yZ/FlzEs8QbslxlEKXtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-49f3a97f1caso2691130b6e.0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 11:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783882179; x=1784486979;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zv+UWdhAnDCA2XUrVR4E7pUtYoXyHbuwGTRef4D6ZWM=;
        b=rLo7hMebSehuiWI5tyB6CKYmN0F671n5c8mWAld4vbJdBbPl3w0UNCA/QTvSHlavxI
         H2OvgPPw03c71+XR01lIJWutkASzeZajSQ9TgnDqbgGlg2fF7EH8SMUd4r6hidej89uj
         fTfFi3ToJEvCqR8XXWLoFhcLl7Cf/tmXho+tlM5e4m3M3PLT6dM1Z2ZliSpPfDgOncUi
         mLVI9IfYw7m/BTX+jAuV3y0DV2uKDeVLifXQKfN+8p/7HdXfmA+6ISliaG32aD6PLipK
         3n91/hcKFKL6U1npHUZGQxh/ACqgk6iwxfY1lKUidltqaSaDj7EjJEF5wKgah/FA52RY
         JWJA==
X-Forwarded-Encrypted: i=1; AFNElJ/abv7yHS1KwPuyBCIMQs19B2xGe+UubUjFH9vEHcAnMwKdQAhUS1cOeKpYuPKB+slFs6k6Wpum+DU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2gG2Rsn8u2JnmYFnKFX/q/7Pahy2CHFszeZL6rTCaiogfQPll
	PQ6ixn5CVf+QbYyt5Q93I49RX9dtgEGSGs561EvB2cIoXDiiP43beky6M4ZKr3el9tKGA6O6jYr
	JHDx/ydk2zdw/X9sDg+YqHD9O9BcSgpgQ9+Qs5SmjfVrweyE32A/XUWF+b4Q=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3507:b0:496:b7c:23a6 with SMTP id
 5614622812f47-4a42afafb7fmr4514609b6e.38.1783882179745; Sun, 12 Jul 2026
 11:49:39 -0700 (PDT)
Date: Sun, 12 Jul 2026 11:49:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a53e1c3.278cdcd2.e885.001f.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_dquot_disk_alloc (2)
From: syzbot <syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e35b9b6ec0f Merge tag 'mm-hotfixes-stable-2026-07-06-17-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134d6739580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=59178abfeb0ea3f0ab20
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0e35b9b6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a17ca6db8f5/vmlinux-0e35b9b6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c885024dccba/bzImage-0e35b9b6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
loop0: detected capacity change from 32768 to 0

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5333 is trying to acquire lock:
ffffffff8ec86c80 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
ffffffff8ec86c80 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4565 [inline]
ffffffff8ec86c80 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4925 [inline]
ffffffff8ec86c80 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x64/0x5f0 mm/slub.c:4959

but task is already holding lock:
ffff88801f853b00 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_dquot_disk_alloc+0x2cf/0xae0 fs/xfs/xfs_dquot.c:363

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
       down_write_nested+0x9d/0x210 kernel/locking/rwsem.c:1757
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1046 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1738 [inline]
       xfs_icwalk_ag+0x12b7/0x1980 fs/xfs/xfs_icache.c:1820
       xfs_icwalk fs/xfs/xfs_icache.c:1868 [inline]
       xfs_reclaim_inodes_nr+0x1e5/0x260 fs/xfs/xfs_icache.c:1112
       super_cache_scan+0x40e/0x4a0 fs/super.c:229
       do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
       shrink_slab+0xea4/0x1220 mm/shrinker.c:674
       shrink_one+0x2a2/0x730 mm/vmscan.c:5026
       shrink_many mm/vmscan.c:5087 [inline]
       lru_gen_shrink_node mm/vmscan.c:5165 [inline]
       shrink_node+0x3303/0x3b60 mm/vmscan.c:6154
       kswapd_shrink_node mm/vmscan.c:7008 [inline]
       balance_pgdat mm/vmscan.c:7186 [inline]
       kswapd+0x17b6/0x31c0 mm/vmscan.c:7462
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4329 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4343
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4565 [inline]
       slab_alloc_node mm/slub.c:4925 [inline]
       kmem_cache_alloc_noprof+0x64/0x5f0 mm/slub.c:4959
       xfs_buf_item_init+0x6a/0x6e0 fs/xfs/xfs_buf_item.c:872
       _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
       xfs_trans_bjoin+0x2e/0x220 fs/xfs/xfs_trans_buf.c:102
       xfs_defer_restore_resources+0x32f/0x7c0 fs/xfs/libxfs/xfs_defer.c:451
       xfs_defer_trans_roll+0x1a9/0x5e0 fs/xfs/libxfs/xfs_defer.c:481
       xfs_defer_finish_noroll+0x844/0x1320 fs/xfs/libxfs/xfs_defer.c:688
       xfs_trans_commit+0x10b/0x1c0 fs/xfs/xfs_trans.c:919
       xfs_dquot_disk_alloc+0x7a2/0xae0 fs/xfs/xfs_dquot.c:435
       xfs_qm_dqread+0xfe/0x520 fs/xfs/xfs_dquot.c:720
       xfs_qm_dqget+0x18a/0x3d0 fs/xfs/xfs_dquot.c:922
       xfs_qm_vop_dqalloc+0x472/0xaa0 fs/xfs/xfs_qm.c:1887
       xfs_setattr_nonsize+0x3a1/0xca0 fs/xfs/xfs_iops.c:831
       xfs_vn_setattr+0x29e/0x310 fs/xfs/xfs_iops.c:1161
       notify_change+0xbba/0xea0 fs/attr.c:556
       chown_common+0x41c/0x630 fs/open.c:776
       vfs_fchown fs/open.c:841 [inline]
       ksys_fchown+0xe9/0x160 fs/open.c:853
       __do_sys_fchown fs/open.c:858 [inline]
       __se_sys_fchown fs/open.c:856 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:856
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by syz.0.0/5333:
 #0: ffff888042324450 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x60/0x200 fs/namespace.c:538
 #1: ffff88801f8552d0 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff88801f8552d0 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{4:4}, at: chown_common+0x313/0x630 fs/open.c:764
 #2: ffff888042324640 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc+0xcf/0x990 fs/xfs/xfs_trans.c:254
 #3: ffff88801f853b00 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_dquot_disk_alloc+0x2cf/0xae0 fs/xfs/xfs_dquot.c:363

stack backtrace:
CPU: 0 UID: 0 PID: 5333 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __fs_reclaim_acquire mm/page_alloc.c:4329 [inline]
 fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4343
 might_alloc include/linux/sched/mm.h:317 [inline]
 slab_pre_alloc_hook mm/slub.c:4565 [inline]
 slab_alloc_node mm/slub.c:4925 [inline]
 kmem_cache_alloc_noprof+0x64/0x5f0 mm/slub.c:4959
 xfs_buf_item_init+0x6a/0x6e0 fs/xfs/xfs_buf_item.c:872
 _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_bjoin+0x2e/0x220 fs/xfs/xfs_trans_buf.c:102
 xfs_defer_restore_resources+0x32f/0x7c0 fs/xfs/libxfs/xfs_defer.c:451
 xfs_defer_trans_roll+0x1a9/0x5e0 fs/xfs/libxfs/xfs_defer.c:481
 xfs_defer_finish_noroll+0x844/0x1320 fs/xfs/libxfs/xfs_defer.c:688
 xfs_trans_commit+0x10b/0x1c0 fs/xfs/xfs_trans.c:919
 xfs_dquot_disk_alloc+0x7a2/0xae0 fs/xfs/xfs_dquot.c:435
 xfs_qm_dqread+0xfe/0x520 fs/xfs/xfs_dquot.c:720
 xfs_qm_dqget+0x18a/0x3d0 fs/xfs/xfs_dquot.c:922
 xfs_qm_vop_dqalloc+0x472/0xaa0 fs/xfs/xfs_qm.c:1887
 xfs_setattr_nonsize+0x3a1/0xca0 fs/xfs/xfs_iops.c:831
 xfs_vn_setattr+0x29e/0x310 fs/xfs/xfs_iops.c:1161
 notify_change+0xbba/0xea0 fs/attr.c:556
 chown_common+0x41c/0x630 fs/open.c:776
 vfs_fchown fs/open.c:841 [inline]
 ksys_fchown+0xe9/0x160 fs/open.c:853
 __do_sys_fchown fs/open.c:858 [inline]
 __se_sys_fchown fs/open.c:856 [inline]
 __x64_sys_fchown+0x7a/0x90 fs/open.c:856
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0044f9de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0045e1afe8 EFLAGS: 00000246 ORIG_RAX: 000000000000005d
RAX: ffffffffffffffda RBX: 00007f0045225fa0 RCX: 00007f0044f9de59
RDX: 000000000000000a RSI: 000000003a736e6f RDI: 0000000000000006
RBP: 00007f0045033e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0045226038 R14: 00007f0045225fa0 R15: 00007fff82a814a8
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
