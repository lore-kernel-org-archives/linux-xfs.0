Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782B314D22
	for <linux-xfs@vger.kernel.org>; Mon,  5 Jan 2026 02:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767580826; cv=none; b=eh3DlWb9sS7ZrQwwNuk7NpjrNvR2SjBY4Vn6HGmFCoyKw2BHahSpFdzd3FaSon8QnqV0UzcVCyzBQ1bBmBCExJaGUAmxl+H+QKZHgeOA1jmBVg6LyvUmjnrwnTJ28AaUn7KbkXcdR43H98aeT9O4cSSQM2kQrbfIlgPQl77iRW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767580826; c=relaxed/simple;
	bh=U6wpLQ5Z5cIMEIYzqwLob6eG48a4avIrKV82ACwivZk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rXst1JjlFLV0rPvl9hFxj1BHgKxpuDTpW2xFfzVzxPgse2s5vfZuWJu5cj1fj0Kx4CC/1ncTTL9hZ4iPZ6eXABZY/9zw1f7DCnXFx2XrjSRroNL7GLz6f2sef3D4b6I2aRYOkNj8vUAwxWkw/9f1hnyOiykwu/EnGJI3WuerSVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-65b31ec93e7so28064434eaf.3
        for <linux-xfs@vger.kernel.org>; Sun, 04 Jan 2026 18:40:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767580821; x=1768185621;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hXSps325Kn9v9njQEqlL312GyfBWNt0qMpATKIhnVCI=;
        b=lL90yAU0UWjcFfgRLoIf6JyqtnRa91YI132+xJ+17Nw1XPJKMrqMNOnVJIkL1L8H/S
         /Pdpu27KxlLTH7TIMY4y8gd7Fhx9iQQ0ViLv0gEKbgzqp/hGkM0MiSgecYTSVMXtTWUE
         f5Qt6OIQXwEYUrlROL2KkjxweMPmzCCARCpQXfwXW9/xU9yIxFU+Cc1c2/uwzSzN431f
         Tf8w66aSbiCxghc442NK65Jmi7nmqOgKfXZtsCJuNkGz+7QpAyfKod4M82XzvM27rNn5
         CFGUqfi9rJ80yUrFIrWvCEbXU4SEXNq9Lv8rIxJE6uMYnJRczm9J/74hW7WLjTPrgM+t
         cbRw==
X-Forwarded-Encrypted: i=1; AJvYcCX/LRj6fMBam4Lr3dZF8tE7py+zqrx29ljh3gzGPTJY40R2aONZcCzhFioHa8kBYU480/orLYb4iEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsBLTaJTk2qEQEqLKtKsKrF2c7MPx+lmKbLNqR7svaik2eHzHw
	b8nTHgy/8Wyhhyk5jVSHbAMKbZAap7XegZ7/ILSzwkj3mTpKm2vRNXLrk6fLmVI4/6alk4I9fkC
	UomQSNh5w6LRKlAcGQ3iYjB/EddMNVWmTSdTAYvNXCVpLCIKpLkfdRbTsrTY=
X-Google-Smtp-Source: AGHT+IHh2vqQ7FCk/k4TQlEycq8hpvKA+bmfSi5ukxkDD7ipuG+7JDa9oplXJHs7ZJBBBRD72u/nUnJEh4X2iUgYpDSlp5qqW4J4
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:b905:0:b0:65d:1e7:9526 with SMTP id
 006d021491bc7-65d0e94d6a3mr15991857eaf.10.1767580821132; Sun, 04 Jan 2026
 18:40:21 -0800 (PST)
Date: Sun, 04 Jan 2026 18:40:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695b2495.050a0220.1c9965.0020.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_ilock (4)
From: syzbot <syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1481d792580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
dashboard link: https://syzkaller.appspot.com/bug?extid=c628140f24c07eb768d8
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cd4f5f43efc8/disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aafb35ac3a3c/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d221fae4ab17/Image-8f0b4cce.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com

WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.3.4/6790 is trying to acquire lock:
ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4904 [inline]
ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5239 [inline]
ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771

but task is already holding lock:
ffff0000f77f5b18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
       down_write_nested+0x58/0xcc kernel/locking/rwsem.c:1706
       xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1035 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1727 [inline]
       xfs_icwalk_ag+0xe4c/0x16a4 fs/xfs/xfs_icache.c:1809
       xfs_icwalk fs/xfs/xfs_icache.c:1857 [inline]
       xfs_reclaim_inodes_nr+0x1b4/0x268 fs/xfs/xfs_icache.c:1101
       xfs_fs_free_cached_objects+0x68/0x7c fs/xfs/xfs_super.c:1282
       super_cache_scan+0x2f0/0x380 fs/super.c:228
       do_shrink_slab+0x638/0x11b0 mm/shrinker.c:437
       shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
       shrink_node_memcgs mm/vmscan.c:6022 [inline]
       shrink_node+0xe18/0x20bc mm/vmscan.c:6061
       kswapd_shrink_node mm/vmscan.c:6901 [inline]
       balance_pgdat+0xb60/0x13b8 mm/vmscan.c:7084
       kswapd+0x6d0/0xe64 mm/vmscan.c:7354
       kthread+0x5fc/0x75c kernel/kthread.c:463
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
       fs_reclaim_acquire+0x8c/0x118 mm/page_alloc.c:4315
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4904 [inline]
       slab_alloc_node mm/slub.c:5239 [inline]
       __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf0/0x218 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0x8b4/0x1668 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x528/0xefc fs/iomap/iter.c:110
       iomap_zero_range+0x17c/0x8ec fs/iomap/buffered-io.c:1590
       xfs_zero_range+0x98/0xfc fs/xfs/xfs_iomap.c:2289
       xfs_reflink_zero_posteof+0x110/0x2f0 fs/xfs/xfs_reflink.c:1619
       xfs_reflink_remap_prep+0x314/0x5e4 fs/xfs/xfs_reflink.c:1699
       xfs_file_remap_range+0x1f4/0x758 fs/xfs/xfs_file.c:1518
       vfs_clone_file_range+0x62c/0xb68 fs/remap_range.c:403
       ioctl_file_clone fs/ioctl.c:239 [inline]
       ioctl_file_clone_range fs/ioctl.c:257 [inline]
       do_vfs_ioctl+0xb84/0x1834 fs/ioctl.c:544
       __do_sys_ioctl fs/ioctl.c:595 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __arm64_sys_ioctl+0xe4/0x1c4 fs/ioctl.c:583
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by syz.3.4/6790:
 #0: ffff0000dceca420 (sb_writers#13){.+.+}-{0:0}, at: ioctl_file_clone fs/ioctl.c:239 [inline]
 #0: ffff0000dceca420 (sb_writers#13){.+.+}-{0:0}, at: ioctl_file_clone_range fs/ioctl.c:257 [inline]
 #0: ffff0000dceca420 (sb_writers#13){.+.+}-{0:0}, at: do_vfs_ioctl+0xb84/0x1834 fs/ioctl.c:544
 #1: ffff0000f77f5d30 (&sb->s_type->i_mutex_key#27){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #1: ffff0000f77f5d30 (&sb->s_type->i_mutex_key#27){+.+.}-{4:4}, at: xfs_iolock_two_inodes_and_break_layout fs/xfs/xfs_inode.c:2716 [inline]
 #1: ffff0000f77f5d30 (&sb->s_type->i_mutex_key#27){+.+.}-{4:4}, at: xfs_ilock2_io_mmap+0x1a4/0x64c fs/xfs/xfs_inode.c:2792
 #2: ffff0000f77f5ed0 (mapping.invalidate_lock#3){++++}-{4:4}, at: filemap_invalidate_lock_two+0x3c/0x84 mm/filemap.c:1032
 #3: ffff0000f77f5b18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165

stack backtrace:
CPU: 0 UID: 0 PID: 6790 Comm: syz.3.4 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2043
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
 __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
 fs_reclaim_acquire+0x8c/0x118 mm/page_alloc.c:4315
 might_alloc include/linux/sched/mm.h:317 [inline]
 slab_pre_alloc_hook mm/slub.c:4904 [inline]
 slab_alloc_node mm/slub.c:5239 [inline]
 __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771
 kmalloc_noprof include/linux/slab.h:957 [inline]
 iomap_fill_dirty_folios+0xf0/0x218 fs/iomap/buffered-io.c:1557
 xfs_buffered_write_iomap_begin+0x8b4/0x1668 fs/xfs/xfs_iomap.c:1857
 iomap_iter+0x528/0xefc fs/iomap/iter.c:110
 iomap_zero_range+0x17c/0x8ec fs/iomap/buffered-io.c:1590
 xfs_zero_range+0x98/0xfc fs/xfs/xfs_iomap.c:2289
 xfs_reflink_zero_posteof+0x110/0x2f0 fs/xfs/xfs_reflink.c:1619
 xfs_reflink_remap_prep+0x314/0x5e4 fs/xfs/xfs_reflink.c:1699
 xfs_file_remap_range+0x1f4/0x758 fs/xfs/xfs_file.c:1518
 vfs_clone_file_range+0x62c/0xb68 fs/remap_range.c:403
 ioctl_file_clone fs/ioctl.c:239 [inline]
 ioctl_file_clone_range fs/ioctl.c:257 [inline]
 do_vfs_ioctl+0xb84/0x1834 fs/ioctl.c:544
 __do_sys_ioctl fs/ioctl.c:595 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0xe4/0x1c4 fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


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
