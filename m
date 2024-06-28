Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDDBD15747A;
	Fri, 28 Jun 2024 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719592967; cv=none; b=P7XAO+wxoUsxunFuVPgpAJsMVDIFlpjoGzxgubyD1cJg4BCZarNhIOsw/jXi44l6KMaEEoV3eJBE1K/wzb3MbWa1/weNS4MVCm7kJtLmO/zZf0REPyFBeZgDAhPirnz/8M59DPeL8FM/tglmyh+mNMK0L7GN0zNMo2cmI1Grnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719592967; c=relaxed/simple;
	bh=Nj8+f1W9R0bWGVyNrv2Z/8coThS7hJJJ1R+iHMUmQ1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=areeY//TqGsVRLMLVj9Nr8nXt3IzQ5l9SVZpnAGgfAPWtE327/DpTXG3zmMq5n4louKWiGid+Sb2s8AFOTi8pUPkyqSJbOmBhy1JzLxfI8C/XlNjFDre62CKPwfIh2C3p4Z1+alwwuEbmDeQsThBmyCW+US5O9j2DWAlsP0Iu6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=c5Npm9HS; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="c5Npm9HS"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DB8FD479AE7;
	Fri, 28 Jun 2024 11:42:44 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net DB8FD479AE7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1719592965;
	bh=S1HJOZiof72M2aJeogSsY6seWoOEXLyd4gpOgbXzhls=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=c5Npm9HSfcRBHwAp1Pqy19IWi+o9GRJIIJ7skBfvyK0+wEzWyi2DIBQsHOxYNn33J
	 FoTJOvb+4zXBQu8tz5Vpp4czbc88mbV2xLQPQUkSapC4eZqDTaS4vcpcI1blC5wmih
	 +Uc8Cd8DwQuE7eVVGxpKf9ecQ1OFl1lQ7ZFaj8GmodeS6lkURmv5TJjKHR//5l0KYO
	 AsbsrnsJ5VqdciBMaMuJ5Lk3JEJPTtI3p98rAg2m4ropX7LQMvqD0OvkmQeD0u1jIs
	 is3TE3XrFDzixxmaPpz5xc6imCioGhcwvT9nfsVLqj7gG9tOiE638yXlN3vMALW+/Z
	 HRm4e1pwQ+r5w==
Message-ID: <8154df14-8f07-4fa6-b12e-c4ce8e3c4411@sandeen.net>
Date: Fri, 28 Jun 2024 11:42:43 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_can_free_eofblocks
To: syzbot <syzbot+1ac5b398842451b74cec@syzkaller.appspotmail.com>,
 chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000cd1e8b06181d6198@google.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <000000000000cd1e8b06181d6198@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/24 1:05 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    dd5a440a31fa Linux 6.9-rc7
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11059824980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d14c12b661fb43
> dashboard link: https://syzkaller.appspot.com/bug?extid=1ac5b398842451b74cec
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/58e2a4900479/disk-dd5a440a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/246a109c32d6/vmlinux-dd5a440a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d2719f7eb672/bzImage-dd5a440a.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1ac5b398842451b74cec@syzkaller.appspotmail.com

This looks like it was resolved by 6fe60465e1d5 - stack_depot_save_flags was
losing __GFP_NOLOCKDEP

#syz fix stackdepot: respect __GFP_NOLOCKDEP allocation flag

(does this make syzbot re-test?)

> ======================================================
> WARNING: possible circular locking dependency detected
> 6.9.0-rc7-syzkaller #0 Not tainted
> ------------------------------------------------------
> kswapd0/89 is trying to acquire lock:
> ffff8880540b9858
>  (&xfs_nondir_ilock_class#3){++++}-{3:3}, at: xfs_can_free_eofblocks+0x645/0x910 fs/xfs/xfs_bmap_util.c:555
> 
> but task is already holding lock:
> ffffffff8e42a780 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6782 [inline]
> ffffffff8e42a780 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbe8/0x38a0 mm/vmscan.c:7164
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
>        __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
>        fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3712
>        might_alloc include/linux/sched/mm.h:312 [inline]
>        slab_pre_alloc_hook mm/slub.c:3746 [inline]
>        slab_alloc_node mm/slub.c:3827 [inline]
>        kmalloc_trace+0x47/0x360 mm/slub.c:3992
>        kmalloc include/linux/slab.h:628 [inline]
>        add_stack_record_to_list mm/page_owner.c:177 [inline]
>        inc_stack_record_count mm/page_owner.c:219 [inline]
>        __set_page_owner+0x561/0x810 mm/page_owner.c:334
>        set_page_owner include/linux/page_owner.h:32 [inline]
>        post_alloc_hook+0x1ea/0x210 mm/page_alloc.c:1534
>        prep_new_page mm/page_alloc.c:1541 [inline]
>        get_page_from_freelist+0x3410/0x35b0 mm/page_alloc.c:3317
>        __alloc_pages+0x256/0x6c0 mm/page_alloc.c:4575
>        alloc_pages_mpol+0x3e8/0x680 mm/mempolicy.c:2264
>        stack_depot_save_flags+0x666/0x830 lib/stackdepot.c:635
>        kasan_save_stack mm/kasan/common.c:48 [inline]
>        kasan_save_track+0x51/0x80 mm/kasan/common.c:68
>        poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
>        __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
>        kasan_kmalloc include/linux/kasan.h:211 [inline]
>        kmalloc_trace+0x1db/0x360 mm/slub.c:3997
>        kmalloc include/linux/slab.h:628 [inline]
>        kzalloc include/linux/slab.h:749 [inline]
>        xfs_iext_alloc_node fs/xfs/libxfs/xfs_iext_tree.c:401 [inline]
>        xfs_iext_alloc_root fs/xfs/libxfs/xfs_iext_tree.c:593 [inline]
>        xfs_iext_insert_raw+0x206/0x23d0 fs/xfs/libxfs/xfs_iext_tree.c:645
>        xfs_iext_insert+0x38/0x250 fs/xfs/libxfs/xfs_iext_tree.c:684
>        xfs_bmap_add_extent_hole_delay+0x573/0xc20 fs/xfs/libxfs/xfs_bmap.c:2686
>        xfs_bmapi_reserve_delalloc+0x897/0x9b0 fs/xfs/libxfs/xfs_bmap.c:4128
>        xfs_buffered_write_iomap_begin+0x1243/0x1b40 fs/xfs/xfs_iomap.c:1130
>        iomap_iter+0x693/0xf60 fs/iomap/iter.c:91
>        iomap_zero_range+0x16e/0x6e0 fs/iomap/buffered-io.c:1426
>        xfs_setattr_size+0x384/0xc80 fs/xfs/xfs_iops.c:858
>        xfs_vn_setattr+0x25d/0x320 fs/xfs/xfs_iops.c:1020
>        notify_change+0xb9f/0xe70 fs/attr.c:497
>        do_truncate fs/open.c:65 [inline]
>        do_ftruncate+0x46b/0x590 fs/open.c:181
>        do_sys_ftruncate fs/open.c:199 [inline]
>        __do_sys_ftruncate fs/open.c:207 [inline]
>        __se_sys_ftruncate fs/open.c:205 [inline]
>        __x64_sys_ftruncate+0x95/0xf0 fs/open.c:205
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&xfs_nondir_ilock_class#3){++++}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3134 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3253 [inline]
>        validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
>        __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
>        down_read_nested+0xb5/0xa50 kernel/locking/rwsem.c:1651
>        xfs_can_free_eofblocks+0x645/0x910 fs/xfs/xfs_bmap_util.c:555
>        xfs_inode_mark_reclaimable+0x1bb/0xf60 fs/xfs/xfs_icache.c:2149
>        destroy_inode fs/inode.c:311 [inline]
>        evict+0x54b/0x630 fs/inode.c:682
>        dispose_list fs/inode.c:700 [inline]
>        prune_icache_sb+0x239/0x2f0 fs/inode.c:885
>        super_cache_scan+0x38c/0x4b0 fs/super.c:223
>        do_shrink_slab+0x707/0x1160 mm/shrinker.c:435
>        shrink_slab_memcg mm/shrinker.c:548 [inline]
>        shrink_slab+0x883/0x14d0 mm/shrinker.c:626
>        shrink_one+0x453/0x880 mm/vmscan.c:4774
>        shrink_many mm/vmscan.c:4835 [inline]
>        lru_gen_shrink_node mm/vmscan.c:4935 [inline]
>        shrink_node+0x3b17/0x4310 mm/vmscan.c:5894
>        kswapd_shrink_node mm/vmscan.c:6704 [inline]
>        balance_pgdat mm/vmscan.c:6895 [inline]
>        kswapd+0x1882/0x38a0 mm/vmscan.c:7164
>        kthread+0x2f2/0x390 kernel/kthread.c:388
>        ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class#3);
>                                lock(fs_reclaim);
>   rlock(&xfs_nondir_ilock_class#3);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kswapd0/89:
>  #0: ffffffff8e42a780 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6782 [inline]
>  #0: ffffffff8e42a780 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbe8/0x38a0 mm/vmscan.c:7164
>  #1: ffff8880796d20e0 (&type->s_umount_key#66){++++}-{3:3}, at: super_trylock_shared fs/super.c:561 [inline]
>  #1: ffff8880796d20e0 (&type->s_umount_key#66){++++}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196
> 
> stack backtrace:
> CPU: 0 PID: 89 Comm: kswapd0 Not tainted 6.9.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
>  check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
>  check_prev_add kernel/locking/lockdep.c:3134 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3253 [inline]
>  validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
>  __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
>  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
>  down_read_nested+0xb5/0xa50 kernel/locking/rwsem.c:1651
>  xfs_can_free_eofblocks+0x645/0x910 fs/xfs/xfs_bmap_util.c:555
>  xfs_inode_mark_reclaimable+0x1bb/0xf60 fs/xfs/xfs_icache.c:2149
>  destroy_inode fs/inode.c:311 [inline]
>  evict+0x54b/0x630 fs/inode.c:682
>  dispose_list fs/inode.c:700 [inline]
>  prune_icache_sb+0x239/0x2f0 fs/inode.c:885
>  super_cache_scan+0x38c/0x4b0 fs/super.c:223
>  do_shrink_slab+0x707/0x1160 mm/shrinker.c:435
>  shrink_slab_memcg mm/shrinker.c:548 [inline]
>  shrink_slab+0x883/0x14d0 mm/shrinker.c:626
>  shrink_one+0x453/0x880 mm/vmscan.c:4774
>  shrink_many mm/vmscan.c:4835 [inline]
>  lru_gen_shrink_node mm/vmscan.c:4935 [inline]
>  shrink_node+0x3b17/0x4310 mm/vmscan.c:5894
>  kswapd_shrink_node mm/vmscan.c:6704 [inline]
>  balance_pgdat mm/vmscan.c:6895 [inline]
>  kswapd+0x1882/0x38a0 mm/vmscan.c:7164
>  kthread+0x2f2/0x390 kernel/kthread.c:388
>  ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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

