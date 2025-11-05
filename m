Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB87F253F13
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762374116; cv=none; b=IwZPxHNihRAYoxnE9joMm1yUBtT6DX35QMS9Rq9UEA/MD3tlssec0Kq4QOCgZS0fKVmYGees5ap25MWg2oNt7rzT2UfZorw7f5diPhnGtL7rjchjTI22MBtB95YLF6JtuNkIOeh3Gx9ePNImrFrxuwVXloGqu9ZlhsqUpsDeqIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762374116; c=relaxed/simple;
	bh=aM2ZceFgHtJc7XzIXWkzd/ySWmQFhPnOiv6NEv5fSlk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gf7PERZbmV0uVEc+ToHmPyh/0zLHsTvk2r4TA+z3V6lEJo7dzCsYAs8i0U8XArZVBZNK/dsvHkQ2WrYCv48oUtcGow0ymm802hHKQCdP5Mg1EugeWXA2R+REIfa0+VGwZd4wsI5bi8BYj5TVWLz9LqHKIBouWwF3OpO6ZVTlNHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UnjJnNB9; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UnjJnNB9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aBJYD3Trn2g4fIxxIhDkBq8/hpDgFuCCczPRsJtiG7Y=; b=UnjJnNB9xhkHkTNtV/VOiBqJ1c
	9LGiqqjcbmwN4q85vKGCerkj4D0MtAELZbEiV0bZ1qPZaSXa+9zLkZ7FkS9MJaldZObelJ4oEw+RL
	KVakVK3pEWfg6OhvGaiaBNdkleMZf9CiriHCzJOHJnDPaeU5cLhiP9Aw/4zmbS0PFJl7pbvyzPJHY
	qsS8Pae15iIGDFjIuPnq3t4nzFyphJBRX0OevMzpCRb6Q/ZEAkfuCGWUEK2fH1xFIyA5v7ZYx4B5s
	kBNg9cxz7pvvxEiv5kvrNYhoJyQ6CbKI5g0xWDM3oUWqslZ7DnrrQqs18oNM+hStHKwg93xfDDX17
	eP4f6irA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGk0t-0000000GCgo-1k4D
	for linux-xfs@vger.kernel.org;
	Wed, 05 Nov 2025 20:21:51 +0000
Date: Wed, 5 Nov 2025 20:21:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-xfs@vger.kernel.org
Subject: fs-next-20251103 reclaim lockdep splat
Message-ID: <aQux3yPwLFU42qof@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In trying to bisect the earlier reported transaction assertion failure,
I hit this:

generic/476       run fstests generic/476 at 2025-11-05 20:16:46
XFS (vdb): Mounting V5 Filesystem 7f483353-a0f6-4710-9adc-4b72f25598f8
XFS (vdb): Ending clean mount
XFS (vdc): Mounting V5 Filesystem 47fa2f49-e8e1-4622-a62c-53ea07b3d714
XFS (vdc): Ending clean mount

======================================================
WARNING: possible circular locking dependency detected
6.18.0-rc4-ktest-00382-ga1e94de7fbd5 #116 Tainted: G        W
------------------------------------------------------
kswapd0/111 is trying to acquire lock:
ffff888102462418 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x14b/0x2b0

but task is already holding lock:
ffffffff82710f00 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x3e0/0x780

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       fs_reclaim_acquire+0x67/0xa0
       __kmalloc_cache_noprof+0x4d/0x500
       iomap_fill_dirty_folios+0x6b/0xe0
       xfs_buffered_write_iomap_begin+0xaee/0x1060
       iomap_iter+0x1a1/0x4a0
       iomap_zero_range+0xb0/0x420
       xfs_zero_range+0x54/0x70
       xfs_file_write_checks+0x21d/0x320
       xfs_file_dio_write_unaligned+0x140/0x2b0
       xfs_file_write_iter+0x22a/0x270
       vfs_write+0x23f/0x540
       ksys_write+0x6d/0x100
       __x64_sys_write+0x1d/0x30
       x64_sys_call+0x7d/0x1da0
       do_syscall_64+0x6a/0x2e0
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       __lock_acquire+0x15be/0x27d0
       lock_acquire+0xb2/0x290
       down_write_nested+0x2a/0xb0
       xfs_ilock+0x14b/0x2b0
       xfs_icwalk_ag+0x517/0xaf0
       xfs_icwalk+0x46/0x80
       xfs_reclaim_inodes_nr+0x8c/0xb0
       xfs_fs_free_cached_objects+0x1d/0x30
       super_cache_scan+0x178/0x1d0
       do_shrink_slab+0x16d/0x6a0
       shrink_slab+0x4cf/0x8c0
       shrink_node+0x334/0x870
       balance_pgdat+0x35f/0x780

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

2 locks held by kswapd0/111:
 #0: ffffffff82710f00 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x3e0/0x780
 #1: ffff888132a800e0 (&type->s_umount_key#38){++++}-{4:4}, at: super_cache_scan+0x3d/0x1d0

stack backtrace:
CPU: 2 UID: 0 PID: 111 Comm: kswapd0 Tainted: G        W           6.18.0-rc4-ktest-00382-ga1e94de7fbd5 #116 NONE
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x63/0x90
 dump_stack+0x14/0x1a
 print_circular_bug.cold+0x17e/0x1bb
 check_noncircular+0x123/0x140
 __lock_acquire+0x15be/0x27d0
 lock_acquire+0xb2/0x290
 ? xfs_ilock+0x14b/0x2b0
 ? find_held_lock+0x31/0x90
 ? xfs_icwalk_ag+0x50a/0xaf0
 down_write_nested+0x2a/0xb0
 ? xfs_ilock+0x14b/0x2b0
 xfs_ilock+0x14b/0x2b0
 xfs_icwalk_ag+0x517/0xaf0
 ? xfs_icwalk_ag+0x60/0xaf0
 xfs_icwalk+0x46/0x80
 xfs_reclaim_inodes_nr+0x8c/0xb0
 xfs_fs_free_cached_objects+0x1d/0x30
 super_cache_scan+0x178/0x1d0
 do_shrink_slab+0x16d/0x6a0
 shrink_slab+0x4cf/0x8c0
 ? shrink_slab+0x2f1/0x8c0
 shrink_node+0x334/0x870
 balance_pgdat+0x35f/0x780
 kswapd+0x1cf/0x3b0
 ? __pfx_autoremove_wake_function+0x10/0x10
 ? __pfx_kswapd+0x10/0x10
 kthread+0x100/0x220
 ? _raw_spin_unlock_irq+0x2b/0x40
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x18c/0x1d0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>


