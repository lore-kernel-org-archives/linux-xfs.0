Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54CE12F5A5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 02:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641185; cv=none; b=V8lPmTHue41R6W29QJxbmf7CBzn7BfQrsbnNcAJWCr6tmWPGo2+u7AuwhJXsbqZz56b8tCfSnLk0aZpt8SucSf8LbK+gn6EbUocICy0uvSjTmOUaf6FYaaCVsRT4MCzLPxb+NzHszOdAKrLtWd7lTh3tVMZ4VfJPj98An5J86ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641185; c=relaxed/simple;
	bh=8pfL0RtlebWriEXNvONf2CbNJkGkDOfISXAbkUjrro8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=V91KxEywP0sG9MTYr56Vq9Yf7BYrfyS6wt42g3Hl8Id7mKCa/ggh//ekWCI3WHbGMxn7WQyYEG3BgKw0NhVBrU2L4VTO5hNSWoS9+ZjfE92xdwvImsz0gxzRa4KdjNrEFsC+jEoD/gugZS2FI4c2Jwv7CmC/5pljun8iykzIXwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4501833aab1so4146261b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 18:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641183; x=1765245983;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGvzRWmCy1tzbmEMH476LZzI2ig1frX5t+c7vxzxaEI=;
        b=bjWDu93+K+8dASSG4sjaLXxwmj6V5KEVPgMnPiy4WhO+Imu5zBXXyonXwQu3l728UL
         T7hneoW359LnG+SbYDno2PAge1iwXAalDSs8NvgkwbJTHu8zsVrq2dwfWwr5OLE+tJSu
         ZptX/Vv47q82rM4vXFhK+GYnockU+WPPdycetZiERHt737pGDCPKqYkw/x7e7XIaXsit
         +Plyexv5zS+oaSU30ck8zkOfdH4ySmnsnD/CcB7jteNj/r7jTst1Q66Kzs5ZU2Go6pY/
         hDAEClMn8K6R7Oev5zYHjfCKqmZIqynkVYE0IQ6eQfXLZN0wCKtiF5PMVqK3ONUl36zD
         yrow==
X-Forwarded-Encrypted: i=1; AJvYcCWD+dTevbGiEjfvJX7UCL7RrS/9KGW4T0NzgcRw+bXE3NOLp8DENIHXRhHZ4dpJMlqPwWJrW4MgRno=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTmKjD2mIcZvIEs7TnDJlB70IRtIrPRO1VTMIt0Gt8ChBdyGEM
	L4aGif/AZ53j4bNLACLuL3qPHtZecHBho2e4T0QAj9ySBUdaXJ5nvhkW7rsCr2wsHff3mlfasNI
	sp3Gi6FFMHoSNBPIpuSZN3jsAgHQmYBr24BJ/uuN81AuCT963uCEX26cc5rw=
X-Google-Smtp-Source: AGHT+IGuEU4zgM4LaB5wHNWcJhGF7DtoNznZNFtKb24Jtpv1d78Uh0oze49ygwQdA7qJa84IjSB1SZLf13ZPSFf9pOq+NpZRoi0t
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2227:b0:43f:5c61:448d with SMTP id
 5614622812f47-4514e60108emr11272902b6e.9.1764641182846; Mon, 01 Dec 2025
 18:06:22 -0800 (PST)
Date: Mon, 01 Dec 2025 18:06:22 -0800
In-Reply-To: <689a0c9f.050a0220.51d73.009e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692e499e.a70a0220.d98e3.0191.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_icwalk_ag (3)
From: syzbot <syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    1d18101a644e Merge tag 'kernel-6.19-rc1.cred' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119238c2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1407a512580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1d18101a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98f78b52cccd/vmlinux-1d18101a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a8898061bfb/bzImage-1d18101a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9f625d767816/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1406a192580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/73 is trying to acquire lock:
ffff88804146c118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
ffff88804146c118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
ffff88804146c118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814

but task is already holding lock:
ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4278
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4929 [inline]
       slab_alloc_node mm/slub.c:5264 [inline]
       __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5766
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x5f2/0xf10 fs/iomap/iter.c:110
       iomap_zero_range+0x1cc/0xa50 fs/iomap/buffered-io.c:1590
       xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
       xfs_reflink_remap_prep+0x398/0x720 fs/xfs/xfs_reflink.c:1699
       xfs_file_remap_range+0x235/0x780 fs/xfs/xfs_file.c:1518
       vfs_copy_file_range+0xd81/0x1370 fs/read_write.c:1598
       __do_sys_copy_file_range fs/read_write.c:1681 [inline]
       __se_sys_copy_file_range+0x2fb/0x470 fs/read_write.c:1648
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
       xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
       xfs_icwalk fs/xfs/xfs_icache.c:1862 [inline]
       xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1106
       super_cache_scan+0x41b/0x4b0 fs/super.c:228
       do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
       shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
       shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
       shrink_many mm/vmscan.c:5016 [inline]
       lru_gen_shrink_node mm/vmscan.c:5094 [inline]
       shrink_node+0x315d/0x3780 mm/vmscan.c:6081
       kswapd_shrink_node mm/vmscan.c:6941 [inline]
       balance_pgdat mm/vmscan.c:7124 [inline]
       kswapd+0x147c/0x2800 mm/vmscan.c:7389
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

2 locks held by kswapd0/73:
 #0: ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
 #0: ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389
 #1: ffff8880119bc0e0 (&type->s_umount_key#54){++++}-{4:4}, at: super_trylock_shared fs/super.c:563 [inline]
 #1: ffff8880119bc0e0 (&type->s_umount_key#54){++++}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197

stack backtrace:
CPU: 0 UID: 0 PID: 73 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
 xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
 xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
 xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
 xfs_icwalk fs/xfs/xfs_icache.c:1862 [inline]
 xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1106
 super_cache_scan+0x41b/0x4b0 fs/super.c:228
 do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
 shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
 shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
 shrink_many mm/vmscan.c:5016 [inline]
 lru_gen_shrink_node mm/vmscan.c:5094 [inline]
 shrink_node+0x315d/0x3780 mm/vmscan.c:6081
 kswapd_shrink_node mm/vmscan.c:6941 [inline]
 balance_pgdat mm/vmscan.c:7124 [inline]
 kswapd+0x147c/0x2800 mm/vmscan.c:7389
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
