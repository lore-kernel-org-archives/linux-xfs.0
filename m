Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFDD3C1F
	for <linux-xfs@vger.kernel.org>; Sun,  7 Dec 2025 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765066231; cv=none; b=sJB4oBO4tKcuHPRgna/DWu4bDzm9/1ygtWaQ0FqxtQQ2Az+DhdMMBdatRnEM0Z7n2xOA7Lv2i3tV5XSS6v/Fd/i/OwA/VP6AEPfrjZfbkp9NxoXMKDoZQD/l5lGXMbljB8QcbxfmJf8/Kl08sR4Wz6VQGr/3zOVjD6YvUeoxY2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765066231; c=relaxed/simple;
	bh=G25YPTd8T/bkGKTGfGIQBVwyQWGyn2PLPeuEqOJouR4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aKdlQzRCS9txIlhJCh36g2uXYBSi2JF5C2t6laqcj4fKFYxDc1kFni7mO1cXYdyiCXBvBkICkH+OZLoIgm5BrgjiiqlWnw6VayGMcitsci8VDEY/mIFlgaLqQ8IL+D5w84h/Z0mqbN8++cIfUtm0rPyeVeeWJu9j8dOfN7KXamo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7c702347c6eso3441365a34.1
        for <linux-xfs@vger.kernel.org>; Sat, 06 Dec 2025 16:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765066229; x=1765671029;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zB6J4yOEUaqWry5Np9xzhlqr/nImQJ7mTrqIpnkXkGE=;
        b=bLZG0sVO2QnX89E1YsFo3aT03ITDNEJh9CEuq/vbDBl/bT28CsFjbNVue4egfSqLm6
         /BRF2e08FebvtQuDcQW+4Ja99t0dHcr2lKzCmIkfwX8NQbJIjzn7JtBsaXBabcUYB2by
         0WEZ9T+g/H5dlM+V7e6vYFPI8As5R+GXhJDaPx0iSvUFFOoX1Ho9EPOfdf8bh7TfxCYa
         M2+p/mce3PTBR48vPnY0Co33VpkON/1lMZQTsUZyJDZW1yBbP2DfI0BlvOyrxb1hJdll
         9f/rwIZiKVYl0AtWbwfzYZa11rQynqVqSkeawY6xQua7BswQS0LQqAODfdH65FpZAGeM
         XRIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO0atcjXLUb6kd+QNxtfzueq0GFqxKGcSYTB/rjHAQdMOsOiFJYrjxbp9/asP7r1sVnivWfIjCCBE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6RlMr5wOpeWg16ve3nNZMuhb8Oxx9nPJlOmOSnLdxcYAncsS6
	GU6Fwm8XSQwAA7Ugu0QDLsGQICuUAsF2VsYDOLTEFUE2wRgLcG4lV0PVG8EermEbpVBS+F7VCDp
	EZwpHD5RG2GgAzpj/hTsBLC7Q0KssW6yX0fIbTgTA7AA7Wa2Q/aoWP1nQVXQ=
X-Google-Smtp-Source: AGHT+IHCZbpXw03/bU/hbQHa55FyjrklQiwBGWkKaCCl8uPdj/63lfDKedtCURYKaz5nf87kFuKPly5Rj6vLjhjcrUO4ucMB8/f3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:61c:b0:659:9a49:8e45 with SMTP id
 006d021491bc7-6599a8c4386mr1628715eaf.21.1765066228880; Sat, 06 Dec 2025
 16:10:28 -0800 (PST)
Date: Sat, 06 Dec 2025 16:10:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6934c5f4.a70a0220.243dc6.003c.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_trans_alloc
From: syzbot <syzbot+f4c587833618ec4a76f9@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4a26e7032d7d Merge tag 'core-bugs-2025-12-01' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12529512580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=553f3db6410d5a82
dashboard link: https://syzkaller.appspot.com/bug?extid=f4c587833618ec4a76f9
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4a26e703.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bf3025099b65/vmlinux-4a26e703.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e022e7e7365/bzImage-4a26e703.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4c587833618ec4a76f9@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/79 is trying to acquire lock:
ffff88803fad6610 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc+0xd7/0x960 fs/xfs/xfs_trans.c:256

but task is already holding lock:
ffffffff8e04ee20 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
ffffffff8e04ee20 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x8ce/0x2780 mm/vmscan.c:7389

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4278
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4929 [inline]
       slab_alloc_node mm/slub.c:5264 [inline]
       __kmalloc_cache_noprof+0x40/0x6e0 mm/slub.c:5766
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

-> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
       down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
       xfs_trans_alloc_ichange+0x1e6/0x6e0 fs/xfs/xfs_trans.c:1252
       xfs_setattr_nonsize+0x402/0xcb0 fs/xfs/xfs_iops.c:837
       xfs_setattr_size+0x294/0xed0 fs/xfs/xfs_iops.c:944
       xfs_vn_setattr+0x258/0x300 fs/xfs/xfs_iops.c:1171
       notify_change+0xc1a/0xf40 fs/attr.c:546
       do_truncate+0x1a4/0x220 fs/open.c:68
       handle_truncate fs/namei.c:4235 [inline]
       do_open fs/namei.c:4632 [inline]
       path_openat+0x359d/0x3dd0 fs/namei.c:4787
       do_filp_open+0x1fa/0x410 fs/namei.c:4814
       do_sys_openat2+0x121/0x200 fs/open.c:1430
       do_sys_open fs/open.c:1436 [inline]
       __do_sys_open fs/open.c:1444 [inline]
       __se_sys_open fs/open.c:1440 [inline]
       __x64_sys_open+0x11e/0x150 fs/open.c:1440
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       __xfs_trans_alloc+0xad/0x420 fs/xfs/xfs_trans.c:224
       xfs_trans_alloc+0xd7/0x960 fs/xfs/xfs_trans.c:256
       xfs_fs_dirty_inode+0x12f/0x1e0 fs/xfs/xfs_super.c:735
       __mark_inode_dirty+0x390/0x1330 fs/fs-writeback.c:2587
       mark_inode_dirty_sync include/linux/fs.h:2200 [inline]
       iput+0x3e8/0x1030 fs/inode.c:1984
       __dentry_kill+0x209/0x660 fs/dcache.c:670
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1115
       shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1142
       prune_dcache_sb+0x10e/0x180 fs/dcache.c:1223
       super_cache_scan+0x369/0x4b0 fs/super.c:222
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
       shrink_many mm/vmscan.c:5016 [inline]
       lru_gen_shrink_node mm/vmscan.c:5094 [inline]
       shrink_node+0x315d/0x3780 mm/vmscan.c:6081
       kswapd_shrink_node mm/vmscan.c:6941 [inline]
       balance_pgdat mm/vmscan.c:7124 [inline]
       kswapd+0x13f5/0x2780 mm/vmscan.c:7389
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x52d/0xa60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &xfs_nondir_ilock_class --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
  rlock(sb_internal#2);

 *** DEADLOCK ***

2 locks held by kswapd0/79:
 #0: ffffffff8e04ee20 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
 #0: ffffffff8e04ee20 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x8ce/0x2780 mm/vmscan.c:7389
 #1: ffff88803fad60e0 (&type->s_umount_key#50){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:563 [inline]
 #1: ffff88803fad60e0 (&type->s_umount_key#50){.+.+}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197

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
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_intwrite include/linux/fs/super.h:177 [inline]
 __xfs_trans_alloc+0xad/0x420 fs/xfs/xfs_trans.c:224
 xfs_trans_alloc+0xd7/0x960 fs/xfs/xfs_trans.c:256
 xfs_fs_dirty_inode+0x12f/0x1e0 fs/xfs/xfs_super.c:735
 __mark_inode_dirty+0x390/0x1330 fs/fs-writeback.c:2587
 mark_inode_dirty_sync include/linux/fs.h:2200 [inline]
 iput+0x3e8/0x1030 fs/inode.c:1984
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1115
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1142
 prune_dcache_sb+0x10e/0x180 fs/dcache.c:1223
 super_cache_scan+0x369/0x4b0 fs/super.c:222
 do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
 shrink_many mm/vmscan.c:5016 [inline]
 lru_gen_shrink_node mm/vmscan.c:5094 [inline]
 shrink_node+0x315d/0x3780 mm/vmscan.c:6081
 kswapd_shrink_node mm/vmscan.c:6941 [inline]
 balance_pgdat mm/vmscan.c:7124 [inline]
 kswapd+0x13f5/0x2780 mm/vmscan.c:7389
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x52d/0xa60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
