Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EC626E6F9
	for <linux-xfs@vger.kernel.org>; Sun,  7 Dec 2025 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765130856; cv=none; b=izjF4HaysYzGBugKhat2jYWzcU48PhD4pVGuUJXomb4pyHhCfFQagba2OUDqK1IKmtmab0J87Plj+m5bA3t/5s5gXuGICbxP35mX5uigYK2wvwCxQ3FkDnoKEeCK1eh9TdyePSEA1BP6olZjKiZ7gevMNjBJ8nAoqw/97SdtBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765130856; c=relaxed/simple;
	bh=DAQoY6VagmztWtjqF/5suoCNOBhOf2d9s81feQkjerw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jZKUYVjhewJ7V74I+vBiqk+YQH/nvocv+zMVaIwdRRAb4HjM6/wLe7LT+mxFVgtlf5/LtmswmELM526y1rhX/StRp9J0HbwoSShfXmnvf4Zq6z5/iR6OAl3fF0e6ZoxNixa9ldXr+zYgG87tf1ys0Sl92yoU3DnvAEUROHj1JPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65747f4376bso5942753eaf.2
        for <linux-xfs@vger.kernel.org>; Sun, 07 Dec 2025 10:07:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765130853; x=1765735653;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jt1Hk6CApeuvqwZ3x/qRlaRaH8ugE6DVOJeYmh9TPUE=;
        b=XuV26pGOu6T4r+LamvKOxUiqPrZWacFhXQJLg403Kqxep6WWY11/oxcVsXDdsmu/Ge
         r9YdKP7YvOoCDHxOnHYQg0G1MvaJ8CRC0IbK9jsep/WorMh0mqGDETyhLqZpUJFxOzOo
         gito+cqQqbBq0QwLpwqXohfQ8+7w4/TaEVLlWn6Gdrzrowau2IehYIEtCCIS7Qv8BVqI
         rvV4vvfhrgmktqhajiz6NGsWkAWeEyaRJQDaTSc8cE8lNPO8QVGDnPi6QVNE8jpm08gY
         nroMdH2lg1vFa//hV9d0nL4Aypw4vzzzhaGent6TxJk+NAwkgElyiJEFMSnq7yEpMW3E
         mVIg==
X-Forwarded-Encrypted: i=1; AJvYcCVZ1Rz/QxSBezf4etBaiirgF75mlRM0I4yJD3mBg0Inn99L2+CjORZK5jWGnLzY9S9ywHrA5HOv7C0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVC1x40RTqNkdUegCi8jJajbdSpUV1AbP5h2woTwdNXce4QolX
	K6P5oOx9J5dcc8eVpcj7d5uVaxvy8KkemyIJRBGeOA6G55aleklyDB3csCtWhFjCCrCiaZBpROx
	OcH4eJEpeASUy0UN/8w0G6G28GPmZZO6N5NNUsIhBwa5H5Z7WYlPKZce2Mvw=
X-Google-Smtp-Source: AGHT+IHwiCIJ3jBEZKNB6Scm2OQZ6Z57eeFrT/TtHei7nilCXsYa34aerP38InsdWiiavIz1ntC7AtoZDhhoEPe89QG9jw3OY2j1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2226:b0:657:6bba:676c with SMTP id
 006d021491bc7-6599a8a0723mr2493686eaf.4.1765130853373; Sun, 07 Dec 2025
 10:07:33 -0800 (PST)
Date: Sun, 07 Dec 2025 10:07:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6935c265.a70a0220.38f243.0067.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_can_free_eofblocks (3)
From: syzbot <syzbot+a8a73f25200041b89d40@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c06c303832ec ocfs2: fix xattr array entry __counted_by error
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1688a992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d3ce1cfe3996fc8b
dashboard link: https://syzkaller.appspot.com/bug?extid=a8a73f25200041b89d40
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c06c3038.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aa14148a2ef4/vmlinux-c06c3038.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2d5f3a106bf/bzImage-c06c3038.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8a73f25200041b89d40@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/79 is trying to acquire lock:
ffff88800083d798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_can_free_eofblocks+0x693/0x8e0 fs/xfs/xfs_bmap_util.c:562

but task is already holding lock:
ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6973 [inline]
ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x92a/0x2820 mm/vmscan.c:7352

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4315
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4899 [inline]
       slab_alloc_node mm/slub.c:5234 [inline]
       __kmalloc_cache_noprof+0x40/0x700 mm/slub.c:5766
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x5ef/0xeb0 fs/iomap/iter.c:110
       iomap_zero_range+0x1cc/0xa30 fs/iomap/buffered-io.c:1590
       xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
       xfs_setattr_size+0x48b/0xed0 fs/xfs/xfs_iops.c:993
       __xfs_file_fallocate+0x10ca/0x15f0 include/linux/fs.h:-1
       xfs_file_fallocate+0x27b/0x340 fs/xfs/xfs_file.c:1462
       vfs_fallocate+0x669/0x7e0 fs/open.c:339
       ksys_fallocate fs/open.c:363 [inline]
       __do_sys_fallocate fs/open.c:368 [inline]
       __se_sys_fallocate fs/open.c:366 [inline]
       __x64_sys_fallocate+0xc0/0x110 fs/open.c:366
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
       down_read_nested+0x49/0x2e0 kernel/locking/rwsem.c:1662
       xfs_can_free_eofblocks+0x693/0x8e0 fs/xfs/xfs_bmap_util.c:562
       xfs_inode_mark_reclaimable+0x21d/0x1030 fs/xfs/xfs_icache.c:2244
       destroy_inode fs/inode.c:396 [inline]
       evict+0x8aa/0xae0 fs/inode.c:861
       dispose_list fs/inode.c:879 [inline]
       prune_icache_sb+0x21b/0x2c0 fs/inode.c:1027
       super_cache_scan+0x39b/0x4b0 fs/super.c:224
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x2d9/0x720 mm/vmscan.c:4919
       shrink_many mm/vmscan.c:4980 [inline]
       lru_gen_shrink_node mm/vmscan.c:5058 [inline]
       shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6045
       kswapd_shrink_node mm/vmscan.c:6899 [inline]
       balance_pgdat mm/vmscan.c:7082 [inline]
       kswapd+0x145a/0x2820 mm/vmscan.c:7352
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
  rlock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

2 locks held by kswapd0/79:
 #0: ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6973 [inline]
 #0: ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x92a/0x2820 mm/vmscan.c:7352
 #1: ffff88803639a0e0 (&type->s_umount_key#51){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:563 [inline]
 #1: ffff88803639a0e0 (&type->s_umount_key#51){.+.+}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197

stack backtrace:
CPU: 0 UID: 0 PID: 79 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
 down_read_nested+0x49/0x2e0 kernel/locking/rwsem.c:1662
 xfs_can_free_eofblocks+0x693/0x8e0 fs/xfs/xfs_bmap_util.c:562
 xfs_inode_mark_reclaimable+0x21d/0x1030 fs/xfs/xfs_icache.c:2244
 destroy_inode fs/inode.c:396 [inline]
 evict+0x8aa/0xae0 fs/inode.c:861
 dispose_list fs/inode.c:879 [inline]
 prune_icache_sb+0x21b/0x2c0 fs/inode.c:1027
 super_cache_scan+0x39b/0x4b0 fs/super.c:224
 do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x2d9/0x720 mm/vmscan.c:4919
 shrink_many mm/vmscan.c:4980 [inline]
 lru_gen_shrink_node mm/vmscan.c:5058 [inline]
 shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6045
 kswapd_shrink_node mm/vmscan.c:6899 [inline]
 balance_pgdat mm/vmscan.c:7082 [inline]
 kswapd+0x145a/0x2820 mm/vmscan.c:7352
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
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
