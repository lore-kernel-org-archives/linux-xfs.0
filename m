Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ADE19DF8B
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725335; cv=none; b=egqj587DRd4Cnn4cBLWcScSyXOw89ixvzZS9JW/KINmK8MNRMxiZHgXmujD3hqGJ/xFI4oUQZ3Kudkoq8t+/NVYROqnHpTDnKsrMoXmuwh+dEnELItd+/eQHNKXEA+AxCTDQ2Hswst6SXUJbZAfiUPX6IbSrS2NHzYhiRYo7yfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725335; c=relaxed/simple;
	bh=oCc8kiVUHH0a9spPU3xnBLKFF7P2+smtvv+27o1ThP8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HQeoLnnl0aSqP2kc3HAvmnCi/DR2k/ukLjeaVWi/cMoDWiy+8vLozvFEqhGocLUBN7UwECBDHg2z4lHMdboEMe01790VP1pnPgFZXJaCZ0507cxiooJfmKAR5xFQB4K4L7N2VJJKGOZH6/XjVV3lNq1OjtIz7yIPtk0o/s5Y2qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39d17abca55so9845515ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 05:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723725333; x=1724330133;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FO04zWfmoPl6JXkiMG9YubIKQuGqI1ZQgX1qGisSs5g=;
        b=qJGjVqJNgkJdPx6juPB5+3NtApL96xJ0iDLFNTDIW2y035YVescFc0AwtmdxSTC6Mb
         UcEn0LcYmhL/P1IC2BW9hhImTtfE9ZwgAhCAUnulCxzSWVXgxfPl8Mc6c0Q4s+JhGoeE
         TSW4pHLP4KOXpAIBhhSdxbbKzLW1IV0u7NTgYKB2W3gV8e/WW6iQtOHW8U2zQNXRvaE2
         ezPtiSdCu7iKahiTH1Oy7VDVN6ClfaA8GWTpBl1UUeBLlKECPXOMOfUC42HuVJc/dsN3
         U2kobTRlI/a8X+uVa+ZvAAFAd1A/aiQyuwn9PwTf6crV8es9B4ma6sByMh6AJLzNQ68p
         rbPA==
X-Forwarded-Encrypted: i=1; AJvYcCWza4gOeLS7VhqtGa4Y87YykTIYCARvXV3wXMLHyKXznmwOIlwLU5EUdBs3Zu4d0OjCYDb23ESY8HKftGPLh4PqZWPULTNDkgkD
X-Gm-Message-State: AOJu0Ywsrbwg+m/KarOIVE1976SADVldDpm9W1REhk3oBBs135dUCUEB
	rUHjtjc8GPP5fR73VqvbhR4qAA7SVz8igmpgONWd43Q8ibqNUSZ7gZRmm9SKUteX6prm6Bd8PT8
	Fmao9RSsRKo3cO7aiLfUalnjYt1b7/4+TjYaUb0aFPhbDKWaJpR3QI7w=
X-Google-Smtp-Source: AGHT+IE3qfcv0Gz50A9TsKAswvDjNQ74Mo+p6fxg9LQ8hiROgEVQ81tDh9Ibc4rQvRAwFMDV8lTLnQ94SWAJYBQW59D7ja3Y6QeQ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214e:b0:398:36c0:796e with SMTP id
 e9e14a558f8ab-39d124564a7mr4824845ab.1.1723725333099; Thu, 15 Aug 2024
 05:35:33 -0700 (PDT)
Date: Thu, 15 Aug 2024 05:35:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b8b05061fb8147f@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_can_free_eofblocks (2)
From: syzbot <syzbot+53d541c7b07d55a392ca@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6b0f8db921ab Merge tag 'execve-v6.11-rc4' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104cabd3980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=801d05d1ea4be1b8
dashboard link: https://syzkaller.appspot.com/bug?extid=53d541c7b07d55a392ca
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148fe6ed980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17840ad5980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-6b0f8db9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b407dbb66544/vmlinux-6b0f8db9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5c1cf0f1b692/bzImage-6b0f8db9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ce1130cd3c8d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53d541c7b07d55a392ca@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc3-syzkaller-00013-g6b0f8db921ab #0 Not tainted
------------------------------------------------------
kswapd0/79 is trying to acquire lock:
ffff88801da74118 (&xfs_nondir_ilock_class#3){++++}-{3:3}, at: xfs_can_free_eofblocks+0x5f1/0x8d0 fs/xfs/xfs_bmap_util.c:550

but task is already holding lock:
ffffffff8ea2fce0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
ffffffff8ea2fce0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __fs_reclaim_acquire mm/page_alloc.c:3823 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3837
       might_alloc include/linux/sched/mm.h:334 [inline]
       slab_pre_alloc_hook mm/slub.c:3939 [inline]
       slab_alloc_node mm/slub.c:4017 [inline]
       __do_kmalloc_node mm/slub.c:4157 [inline]
       __kmalloc_noprof+0xa9/0x400 mm/slub.c:4170
       kmalloc_noprof include/linux/slab.h:685 [inline]
       xfs_attr_shortform_list+0x753/0x1900 fs/xfs/xfs_attr_list.c:117
       xfs_attr_list+0x1d0/0x270 fs/xfs/xfs_attr_list.c:595
       xfs_vn_listxattr+0x1d2/0x2c0 fs/xfs/xfs_xattr.c:341
       vfs_listxattr fs/xattr.c:493 [inline]
       listxattr+0x107/0x290 fs/xattr.c:841
       path_listxattr fs/xattr.c:865 [inline]
       __do_sys_llistxattr fs/xattr.c:883 [inline]
       __se_sys_llistxattr fs/xattr.c:880 [inline]
       __x64_sys_llistxattr+0x170/0x230 fs/xattr.c:880
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&xfs_nondir_ilock_class#3){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read_nested+0xb5/0xa50 kernel/locking/rwsem.c:1651
       xfs_can_free_eofblocks+0x5f1/0x8d0 fs/xfs/xfs_bmap_util.c:550
       xfs_inode_mark_reclaimable+0x1bb/0xf60 fs/xfs/xfs_icache.c:2148
       destroy_inode fs/inode.c:313 [inline]
       evict+0x549/0x630 fs/inode.c:694
       dispose_list fs/inode.c:712 [inline]
       prune_icache_sb+0x239/0x2f0 fs/inode.c:897
       super_cache_scan+0x38c/0x4b0 fs/super.c:223
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1090/0x14c0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4815
       shrink_many mm/vmscan.c:4876 [inline]
       lru_gen_shrink_node mm/vmscan.c:4954 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
       kswapd_shrink_node mm/vmscan.c:6762 [inline]
       balance_pgdat mm/vmscan.c:6954 [inline]
       kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class#3);
                               lock(fs_reclaim);
  rlock(&xfs_nondir_ilock_class#3);

 *** DEADLOCK ***

2 locks held by kswapd0/79:
 #0: ffffffff8ea2fce0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
 #0: ffffffff8ea2fce0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223
 #1: ffff88803a2860e0 (&type->s_umount_key#44){.+.+}-{3:3}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff88803a2860e0 (&type->s_umount_key#44){.+.+}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 79 Comm: kswapd0 Not tainted 6.11.0-rc3-syzkaller-00013-g6b0f8db921ab #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 down_read_nested+0xb5/0xa50 kernel/locking/rwsem.c:1651
 xfs_can_free_eofblocks+0x5f1/0x8d0 fs/xfs/xfs_bmap_util.c:550
 xfs_inode_mark_reclaimable+0x1bb/0xf60 fs/xfs/xfs_icache.c:2148
 destroy_inode fs/inode.c:313 [inline]
 evict+0x549/0x630 fs/inode.c:694
 dispose_list fs/inode.c:712 [inline]
 prune_icache_sb+0x239/0x2f0 fs/inode.c:897
 super_cache_scan+0x38c/0x4b0 fs/super.c:223
 do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
 shrink_slab+0x1090/0x14c0 mm/shrinker.c:662
 shrink_one+0x43b/0x850 mm/vmscan.c:4815
 shrink_many mm/vmscan.c:4876 [inline]
 lru_gen_shrink_node mm/vmscan.c:4954 [inline]
 shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
 kswapd_shrink_node mm/vmscan.c:6762 [inline]
 balance_pgdat mm/vmscan.c:6954 [inline]
 kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
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
