Received: from smtp153-171.sina.com.cn (smtp153-171.sina.com.cn [61.135.153.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB882367CD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097919; cv=none; b=pwujS4w0UCWn9wSF5BSPtn1n3eZxORRRzQ+fgZELLThp93BIhZ0A8oqKwhHMnD2BgtpK4TYaAQ0u3zTXa656vf5uw60F6PIRloljKCnkI7aA3rpcoDzP5TXBJBBbQ/U04TX27gXfNM3oVVtvk4VIqKC/ZoYcoys1/0PS/puevkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097919; c=relaxed/simple;
	bh=4jjBQ2f1rJCiMlxnKK17dZEOqITlbP+5OfovJB11B64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqCR8mFlhpQu4ZtK4Ng4fJAn9ir7YfnmSd4fakAhZEUj8PhV0Mxvpv21gO2xAvjLOiy5jT7U+gH6gBxmDLdLIbckjvoGHEB8Gc33hyPICWyK8K3hNI0dTIL90iWiX6/DGxIO/kvhyuD5SJs4idmrjNC+ychiarFVHIlM5oZMnzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=bWPlJqeL; arc=none smtp.client-ip=61.135.153.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="bWPlJqeL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1752097911;
	bh=nZRzGZhZC0cyTDj8L8pn8LOfcAhp11W/YG7IwV6stdk=;
	h=From:Subject:Date:Message-ID;
	b=bWPlJqeLL97NwmMWM7FSfnpzJJTArwjv8LL6SFmjASrfA8ii437UTB5TL6+AOY78s
	 aTeeGsj5EQ+9YcvgDb5Cac/IW5GpkZrPfFPDzjaXmC9X/T/Eo9W2nAv1rg2YdHFfSy
	 LSfnDhF6F1pt5fezCle/adSLL/jEhzwT8BsokwpU=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 686EE4710000274E; Wed, 10 Jul 2025 05:51:47 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 2642036291945
X-SMAIL-UIID: AEAC9F7111174656B18BBA9757B7FD9A-20250710-055147-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Alexander Potapenko <glider@google.com>,
	cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock_attr_map_shared (2)
Date: Thu, 10 Jul 2025 05:51:34 +0800
Message-ID: <20250709215135.3122-1-hdanton@sina.com>
In-Reply-To: <686ea951.050a0220.385921.0016.GAE@google.com>
References: 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Date: Wed, 09 Jul 2025 10:39:29 -0700
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    733923397fd9 Merge tag 'pwm/for-6.16-rc6-fixes' of git://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13f53582580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
> dashboard link: https://syzkaller.appspot.com/bug?extid=3470c9ffee63e4abafeb
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-73392339.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/be7feaa77b8c/vmlinux-73392339.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a663b3e31463/bzImage-73392339.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.16.0-rc5-syzkaller-00038-g733923397fd9 #0 Not tainted
> ------------------------------------------------------
> syz.0.0/5339 is trying to acquire lock:
> ffffffff8e247500 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
> ffffffff8e247500 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x153/0x610 mm/page_alloc.c:4727
> 
> but task is already holding lock:
> ffff888053415098 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_attr_map_shared+0x92/0xd0 fs/xfs/xfs_inode.c:85
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
>        down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1693
>        xfs_reclaim_inode fs/xfs/xfs_icache.c:1045 [inline]
>        xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1737 [inline]
>        xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1819
>        xfs_icwalk fs/xfs/xfs_icache.c:1867 [inline]
>        xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1111
>        super_cache_scan+0x41b/0x4b0 fs/super.c:228
>        do_shrink_slab+0x6ec/0x1110 mm/shrinker.c:437
>        shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
>        shrink_one+0x28a/0x7c0 mm/vmscan.c:4939
>        shrink_many mm/vmscan.c:5000 [inline]
>        lru_gen_shrink_node mm/vmscan.c:5078 [inline]
>        shrink_node+0x314e/0x3760 mm/vmscan.c:6060
>        kswapd_shrink_node mm/vmscan.c:6911 [inline]
>        balance_pgdat mm/vmscan.c:7094 [inline]
>        kswapd+0x147c/0x2830 mm/vmscan.c:7359
>        kthread+0x70e/0x8a0 kernel/kthread.c:464
>        ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3168 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3287 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
>        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
>        __fs_reclaim_acquire mm/page_alloc.c:4045 [inline]
>        fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4059
>        might_alloc include/linux/sched/mm.h:318 [inline]
>        prepare_alloc_pages+0x153/0x610 mm/page_alloc.c:4727
>        __alloc_frozen_pages_noprof+0x123/0x370 mm/page_alloc.c:4948
>        alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
>        alloc_frozen_pages_noprof mm/mempolicy.c:2490 [inline]
>        alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2510
>        get_free_pages_noprof+0xf/0x80 mm/page_alloc.c:5018
>        __kasan_populate_vmalloc mm/kasan/shadow.c:362 [inline]
>        kasan_populate_vmalloc+0x33/0x1a0 mm/kasan/shadow.c:417

No deadlock report could be triggered without kasan enabled.

>        alloc_vmap_area+0xd51/0x1490 mm/vmalloc.c:2084
>        __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3179
>        __vmalloc_node_range_noprof+0x301/0x12f0 mm/vmalloc.c:3845
>        __vmalloc_node_noprof mm/vmalloc.c:3948 [inline]
>        __vmalloc_noprof+0xb1/0xf0 mm/vmalloc.c:3962
>        xfs_buf_alloc_backing_mem fs/xfs/xfs_buf.c:239 [inline]
>        xfs_buf_alloc+0xed3/0x1d40 fs/xfs/xfs_buf.c:312
>        xfs_buf_find_insert+0xab/0x1470 fs/xfs/xfs_buf.c:505
>        xfs_buf_get_map+0x1264/0x1860 fs/xfs/xfs_buf.c:609
>        xfs_buf_read_map+0x82/0xa50 fs/xfs/xfs_buf.c:702
>        xfs_buf_read fs/xfs/xfs_buf.h:260 [inline]
>        xfs_attr_rmtval_get+0x5c0/0xb80 fs/xfs/libxfs/xfs_attr_remote.c:434
>        xfs_attr_node_get+0x150/0x4f0 fs/xfs/libxfs/xfs_attr.c:1532
>        xfs_attr_get_ilocked+0x330/0x410 fs/xfs/libxfs/xfs_attr.c:248
>        xfs_attr_get+0x492/0x5e0 fs/xfs/libxfs/xfs_attr.c:289
>        xfs_xattr_get+0x125/0x1c0 fs/xfs/xfs_xattr.c:150
>        vfs_getxattr_alloc+0x52c/0x580 fs/xattr.c:404
>        ima_read_xattr+0x38/0x60 security/integrity/ima/ima_appraise.c:230
>        process_measurement+0xfd7/0x1a40 security/integrity/ima/ima_main.c:366
>        ima_file_check+0xd7/0x120 security/integrity/ima/ima_main.c:613
>        security_file_post_open+0xbb/0x290 security/security.c:3130
>        do_open fs/namei.c:3898 [inline]
>        path_openat+0x2f26/0x3830 fs/namei.c:4055
>        do_filp_open+0x1fa/0x410 fs/namei.c:4082
>        do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>        do_sys_open fs/open.c:1452 [inline]
>        __do_sys_openat fs/open.c:1468 [inline]
>        __se_sys_openat fs/open.c:1463 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1463
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   rlock(&xfs_nondir_ilock_class);
>                                lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class);
>   lock(fs_reclaim);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by syz.0.0/5339:
>  #0: ffff888042ae35b8 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}, at: process_measurement+0x74b/0x1a40 security/integrity/ima/ima_main.c:279
>  #1: ffff888053415098 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_attr_map_shared+0x92/0xd0 fs/xfs/xfs_inode.c:85
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 5339 Comm: syz.0.0 Not tainted 6.16.0-rc5-syzkaller-00038-g733923397fd9 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2046
>  check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2178
>  check_prev_add kernel/locking/lockdep.c:3168 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3287 [inline]
>  validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
>  __fs_reclaim_acquire mm/page_alloc.c:4045 [inline]
>  fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4059
>  might_alloc include/linux/sched/mm.h:318 [inline]
>  prepare_alloc_pages+0x153/0x610 mm/page_alloc.c:4727
>  __alloc_frozen_pages_noprof+0x123/0x370 mm/page_alloc.c:4948
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
>  alloc_frozen_pages_noprof mm/mempolicy.c:2490 [inline]
>  alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2510
>  get_free_pages_noprof+0xf/0x80 mm/page_alloc.c:5018
>  __kasan_populate_vmalloc mm/kasan/shadow.c:362 [inline]
>  kasan_populate_vmalloc+0x33/0x1a0 mm/kasan/shadow.c:417
>  alloc_vmap_area+0xd51/0x1490 mm/vmalloc.c:2084
>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3179
>  __vmalloc_node_range_noprof+0x301/0x12f0 mm/vmalloc.c:3845
>  __vmalloc_node_noprof mm/vmalloc.c:3948 [inline]
>  __vmalloc_noprof+0xb1/0xf0 mm/vmalloc.c:3962
>  xfs_buf_alloc_backing_mem fs/xfs/xfs_buf.c:239 [inline]
>  xfs_buf_alloc+0xed3/0x1d40 fs/xfs/xfs_buf.c:312
>  xfs_buf_find_insert+0xab/0x1470 fs/xfs/xfs_buf.c:505
>  xfs_buf_get_map+0x1264/0x1860 fs/xfs/xfs_buf.c:609
>  xfs_buf_read_map+0x82/0xa50 fs/xfs/xfs_buf.c:702
>  xfs_buf_read fs/xfs/xfs_buf.h:260 [inline]
>  xfs_attr_rmtval_get+0x5c0/0xb80 fs/xfs/libxfs/xfs_attr_remote.c:434
>  xfs_attr_node_get+0x150/0x4f0 fs/xfs/libxfs/xfs_attr.c:1532
>  xfs_attr_get_ilocked+0x330/0x410 fs/xfs/libxfs/xfs_attr.c:248
>  xfs_attr_get+0x492/0x5e0 fs/xfs/libxfs/xfs_attr.c:289
>  xfs_xattr_get+0x125/0x1c0 fs/xfs/xfs_xattr.c:150
>  vfs_getxattr_alloc+0x52c/0x580 fs/xattr.c:404
>  ima_read_xattr+0x38/0x60 security/integrity/ima/ima_appraise.c:230
>  process_measurement+0xfd7/0x1a40 security/integrity/ima/ima_main.c:366
>  ima_file_check+0xd7/0x120 security/integrity/ima/ima_main.c:613
>  security_file_post_open+0xbb/0x290 security/security.c:3130
>  do_open fs/namei.c:3898 [inline]
>  path_openat+0x2f26/0x3830 fs/namei.c:4055
>  do_filp_open+0x1fa/0x410 fs/namei.c:4082
>  do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1463
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe72bf8e929
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe72ce24038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007fe72c1b6080 RCX: 00007fe72bf8e929
> RDX: 0000000000000042 RSI: 0000200000000000 RDI: ffffffffffffff9c
> RBP: 00007fe72c010b39 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000001 R14: 00007fe72c1b6080 R15: 00007ffd78e8cfc8
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
