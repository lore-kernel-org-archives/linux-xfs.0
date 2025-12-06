Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91C1862A
	for <linux-xfs@vger.kernel.org>; Sat,  6 Dec 2025 00:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980672; cv=none; b=REYIRfp39ZOKS+FaRjyXru9U5YFOZ12sSzP//QhXEc3SfZ8SihxkFv1SUhwdINosVzdZRVFGLuEWFqYe83ylWxA9OmYiE2k6zh+9JB2gdcUXUyEoQ0jTd5u+b/eGqaproT2uwKpzgWsRGStzTO2g40NZ/vfa3CRBeZO+e5Bz8Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980672; c=relaxed/simple;
	bh=xnEqAPQlnkOcuy/9CGduHwd4WGq6hhbUNixt5yBjTEo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Iu8p58jwHYxu9Q45/1ekLaggMXQLJlOsNJ0IIMXHtK76vfqlkek2xR9E044ibyUdj4TM/7o6Pmo12HL+Mkr6cDPydCFoYINGoRgA60xtG8QzRh7Ov8Te1W3Zq+TGPGNzj7ZCUEOF/z6DZIq3SNNMrykwtQkzq2uQgtms2ulArTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7c75290862cso5609607a34.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 16:24:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980670; x=1765585470;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RHplcnl7X1J7hKWfE7GMG6in81WZO2nb6IFz+zr1MJs=;
        b=h2v+Ii02buGmxmU+XudjWpxXuKBAIuTO90b0XJeVXk9yuOCy9ugE86J0grPtu//6Q4
         jT0GLzg5ndxfKFi6N3oqDgN/8yyVKbgTGamOZpyZFKFmXz1FzaTOkZ7neQjQnlYJ7m3A
         euq3FqYE4mx6du51lKNYUW5yhFOQnIQsFH9fzx6tmh0TyimRF6pMCfzFEhgGKlJFTaWS
         pf9ZtbdpdSlMoO2u08a3TpAmfoChi2AWIPokdgve7mfHgjGMzFVLcIn4m+huIi7kELlf
         yI9YFVTJUYRZs2wevZKHgu+i+iK2OkWOGaYSmfBS5P5/cbca6L621NBkgSXCIuCaJkhr
         7SAg==
X-Forwarded-Encrypted: i=1; AJvYcCUbTzYzpkWOmH7UdyjaQt2aCrKczNz292mKacSs3vCdaAsk9RtVpnDPibBNQRlyNrJyJwPmmJCn/dc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJw6nwNrizf4zRoIuVygDinixpE8sKh9s15jyEqbVsFYcs7n4p
	oAtbriO0tNFLAVk5akZhoAKlZXmhsPla7v44KBYkNMbzwh6ZZOaiP7NC5R1QrhdmzwNqJHBrap+
	sa9oWojC7L3V8s2x9GLQpOWzyNOi5LkQvKY/UJCRBeltssVXjObBKiVVFt2c=
X-Google-Smtp-Source: AGHT+IGYe93VCvR3p/trlazBOTlN8YbbIr0v8ZfgT7iJ3JONFM0gkRdYUm5IzY36bZ6Szb34RX4fcfvayPEhmR5GktZf+3Esz1Rw
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f030:b0:659:9a49:8e8a with SMTP id
 006d021491bc7-6599a8a0428mr452727eaf.14.1764980669771; Fri, 05 Dec 2025
 16:24:29 -0800 (PST)
Date: Fri, 05 Dec 2025 16:24:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693377bd.a70a0220.243dc6.0023.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_buffered_write_iomap_begin
From: syzbot <syzbot+5f5f36a9ed0aadd614f3@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d1d36025a617 Merge tag 'probes-v6.19' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163b021a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eaa3e2adda258a7
dashboard link: https://syzkaller.appspot.com/bug?extid=5f5f36a9ed0aadd614f3
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d1d36025.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8198d2c1f670/vmlinux-d1d36025.xz
kernel image: https://storage.googleapis.com/syzbot-assets/51df1359897b/bzImage-d1d36025.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f5f36a9ed0aadd614f3@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5333 is trying to acquire lock:
ffffffff8e0507e0 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
ffffffff8e0507e0 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4899 [inline]
ffffffff8e0507e0 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5234 [inline]
ffffffff8e0507e0 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5766

but task is already holding lock:
ffff888049d01798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_for_iomap fs/xfs/xfs_iomap.c:789 [inline]
ffff888049d01798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_buffered_write_iomap_begin+0x4d1/0x1a70 fs/xfs/xfs_iomap.c:1793

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
       down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1035 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1727 [inline]
       xfs_icwalk_ag+0x1229/0x1a90 fs/xfs/xfs_icache.c:1809
       xfs_icwalk fs/xfs/xfs_icache.c:1857 [inline]
       xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1101
       super_cache_scan+0x41b/0x4b0 fs/super.c:228
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
       shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
       shrink_many mm/vmscan.c:5016 [inline]
       lru_gen_shrink_node mm/vmscan.c:5094 [inline]
       shrink_node+0x315d/0x3780 mm/vmscan.c:6081
       kswapd_shrink_node mm/vmscan.c:6941 [inline]
       balance_pgdat mm/vmscan.c:7124 [inline]
       kswapd+0x13f5/0x2780 mm/vmscan.c:7389
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4278
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4899 [inline]
       slab_alloc_node mm/slub.c:5234 [inline]
       __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5766
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x5ef/0xeb0 fs/iomap/iter.c:110
       iomap_zero_range+0x1cc/0xa30 fs/iomap/buffered-io.c:1590
       xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
       xfs_free_file_space+0x8ad/0xcc0 fs/xfs/xfs_bmap_util.c:900
       xfs_falloc_zero_range fs/xfs/xfs_file.c:1281 [inline]
       __xfs_file_fallocate+0x91b/0x15f0 fs/xfs/xfs_file.c:1396
       xfs_file_fallocate+0x27b/0x340 fs/xfs/xfs_file.c:1462
       vfs_fallocate+0x669/0x7e0 fs/open.c:339
       ksys_fallocate fs/open.c:363 [inline]
       __do_sys_fallocate fs/open.c:368 [inline]
       __se_sys_fallocate fs/open.c:366 [inline]
       __x64_sys_fallocate+0xc0/0x110 fs/open.c:366
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
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
 #0: ffff88803534c420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2682 [inline]
 #0: ffff88803534c420 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f0/0x7e0 fs/open.c:338
 #1: ffff888049d019b0 (&sb->s_type->i_mutex_key#22){+.+.}-{4:4}, at: xfs_ilock+0xee/0x370 fs/xfs/xfs_inode.c:149
 #2: ffff888049d01b50 (mapping.invalidate_lock#3){+.+.}-{4:4}, at: xfs_ilock+0x16c/0x370 fs/xfs/xfs_inode.c:157
 #3: ffff888049d01798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_for_iomap fs/xfs/xfs_iomap.c:789 [inline]
 #3: ffff888049d01798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_buffered_write_iomap_begin+0x4d1/0x1a70 fs/xfs/xfs_iomap.c:1793

stack backtrace:
CPU: 0 UID: 0 PID: 5333 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
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
 __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
 fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4278
 might_alloc include/linux/sched/mm.h:318 [inline]
 slab_pre_alloc_hook mm/slub.c:4899 [inline]
 slab_alloc_node mm/slub.c:5234 [inline]
 __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5766
 kmalloc_noprof include/linux/slab.h:957 [inline]
 iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
 xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
 iomap_iter+0x5ef/0xeb0 fs/iomap/iter.c:110
 iomap_zero_range+0x1cc/0xa30 fs/iomap/buffered-io.c:1590
 xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
 xfs_free_file_space+0x8ad/0xcc0 fs/xfs/xfs_bmap_util.c:900
 xfs_falloc_zero_range fs/xfs/xfs_file.c:1281 [inline]
 __xfs_file_fallocate+0x91b/0x15f0 fs/xfs/xfs_file.c:1396
 xfs_file_fallocate+0x27b/0x340 fs/xfs/xfs_file.c:1462
 vfs_fallocate+0x669/0x7e0 fs/open.c:339
 ksys_fallocate fs/open.c:363 [inline]
 __do_sys_fallocate fs/open.c:368 [inline]
 __se_sys_fallocate fs/open.c:366 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:366
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6ad8f8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6ad9dd1038 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f6ad91e6090 RCX: 00007f6ad8f8f7c9
RDX: 0000000000000002 RSI: 0000000000000010 RDI: 0000000000000009
RBP: 00007f6ad9013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001b7c R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6ad91e6128 R14: 00007f6ad91e6090 R15: 00007ffc63ee8278
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
