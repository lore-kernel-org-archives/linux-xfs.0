Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CEC2750FB;
	Tue,  2 Dec 2025 07:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661208; cv=none; b=Cbgd0IKWQ2+RXlwUplacfFC51M4/xLzyAFoARH2MUD4W5tjLBc28Zt8fpPGu/xwhjqXAGr7FbrOWb3G864W4eUcq0oo0HSgZLfqqoB1ZT/tfU1EN5p0Es4XZM7c9MXeHczzHw2Mrq19wAhhn3NCg1EV96aTieMAAEa3Nb0wxMTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661208; c=relaxed/simple;
	bh=vNRWNeFN++o6MWfQsivgBx6V+hNRj8rCQjvYsNNquqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXRpt0p4xFCK1J7+W/S25bYZNJL3/QTK627XYmWPd0MVRwrNtaN9gWQvtjAXkjXodfjsv3213YPG5evUDUECN5iWhY79+2w7lF8RAkXYcAKz0agc1/bv5VFPpzdCX3y4nA9rNwjqokYYus/+9Dtr3m7p1iMvaLFTGcSkWtSsV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LYbWXEhn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LYbWXEhn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V/qCHtHtrcVzrUL3MV29ZsNwC53A73HLWorl5hvGFHk=; b=LYbWXEhnXor92gNgj6EIm8mMmV
	VRg3zIAoWNtiCQ9qTv69GczeSgNwD9TaeJTelcjHFvfBCu8vtWwlFY2ZIyH/CRLhYUV0kxUBtHL4y
	F7j8rGp4T4+8nzpUx//7K/D2Pe3oK+mXfHrwx+DgP1GuJbqVsrPXUxPukQY29gVOd/w26S3DiA+SW
	BUx5A0x/wATPzeEAC/aqaNntfZJ+82cKX2yhX06LN7w+0CRIa+PG9HhyskPyBRxoBXB8ZR649RbNW
	sXEsofNlOdUO3oWVk+uq0jC+p+0gNyGYOixdSsCVRlHoL6Jxob16ng5EapS4ii8EsHmC1Z5Pm9+J6
	PPhkPHmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQKzT-00000004xtA-3XYA;
	Tue, 02 Dec 2025 07:40:03 +0000
Date: Mon, 1 Dec 2025 23:40:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_icwalk_ag (3)
Message-ID: <aS6X08yD5yK8d8EG@infradead.org>
References: <689a0c9f.050a0220.51d73.009e.GAE@google.com>
 <692e499e.a70a0220.d98e3.0191.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <692e499e.a70a0220.d98e3.0191.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This look like the batch zeroing code.  I think we have a patch pending
to remove the allocation, but I lost track a bit where we are with that.

On Mon, Dec 01, 2025 at 06:06:22PM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    1d18101a644e Merge tag 'kernel-6.19-rc1.cred' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=119238c2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
> dashboard link: https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1407a512580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1d18101a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/98f78b52cccd/vmlinux-1d18101a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7a8898061bfb/bzImage-1d18101a.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/9f625d767816/mount_0.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1406a192580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> kswapd0/73 is trying to acquire lock:
> ffff88804146c118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
> ffff88804146c118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
> ffff88804146c118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
> 
> but task is already holding lock:
> ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
> ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
>        fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4278
>        might_alloc include/linux/sched/mm.h:318 [inline]
>        slab_pre_alloc_hook mm/slub.c:4929 [inline]
>        slab_alloc_node mm/slub.c:5264 [inline]
>        __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5766
>        kmalloc_noprof include/linux/slab.h:957 [inline]
>        iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
>        xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
>        iomap_iter+0x5f2/0xf10 fs/iomap/iter.c:110
>        iomap_zero_range+0x1cc/0xa50 fs/iomap/buffered-io.c:1590
>        xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
>        xfs_reflink_remap_prep+0x398/0x720 fs/xfs/xfs_reflink.c:1699
>        xfs_file_remap_range+0x235/0x780 fs/xfs/xfs_file.c:1518
>        vfs_copy_file_range+0xd81/0x1370 fs/read_write.c:1598
>        __do_sys_copy_file_range fs/read_write.c:1681 [inline]
>        __se_sys_copy_file_range+0x2fb/0x470 fs/read_write.c:1648
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
>        xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
>        xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
>        xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
>        xfs_icwalk fs/xfs/xfs_icache.c:1862 [inline]
>        xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1106
>        super_cache_scan+0x41b/0x4b0 fs/super.c:228
>        do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
>        shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
>        shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
>        shrink_many mm/vmscan.c:5016 [inline]
>        lru_gen_shrink_node mm/vmscan.c:5094 [inline]
>        shrink_node+0x315d/0x3780 mm/vmscan.c:6081
>        kswapd_shrink_node mm/vmscan.c:6941 [inline]
>        balance_pgdat mm/vmscan.c:7124 [inline]
>        kswapd+0x147c/0x2800 mm/vmscan.c:7389
>        kthread+0x711/0x8a0 kernel/kthread.c:463
>        ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class);
>                                lock(fs_reclaim);
>   lock(&xfs_nondir_ilock_class);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kswapd0/73:
>  #0: ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
>  #0: ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389
>  #1: ffff8880119bc0e0 (&type->s_umount_key#54){++++}-{4:4}, at: super_trylock_shared fs/super.c:563 [inline]
>  #1: ffff8880119bc0e0 (&type->s_umount_key#54){++++}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 73 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
>  check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
>  xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
>  xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
>  xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
>  xfs_icwalk fs/xfs/xfs_icache.c:1862 [inline]
>  xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1106
>  super_cache_scan+0x41b/0x4b0 fs/super.c:228
>  do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
>  shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
>  shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
>  shrink_many mm/vmscan.c:5016 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5094 [inline]
>  shrink_node+0x315d/0x3780 mm/vmscan.c:6081
>  kswapd_shrink_node mm/vmscan.c:6941 [inline]
>  balance_pgdat mm/vmscan.c:7124 [inline]
>  kswapd+0x147c/0x2800 mm/vmscan.c:7389
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
---end quoted text---
