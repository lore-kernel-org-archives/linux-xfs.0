Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DCD264630
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762272063; cv=none; b=TepmhDBGf2dwBpIyKqHzxH9EEaFe8YLaCDYSZU9QD34MKLd4WVjh3Bw2LaLHrvygQA7k92iLMiOZpaHPS0P/NK/5rsHgDEwBvWVixCrNInYdWPqQ8DOKB7uuiriUKRTWWVxjUe2bxOTP7m6iY7mLRflDsaq9KJKnRqOKhSd483k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762272063; c=relaxed/simple;
	bh=urq5Jnv1+ymhmV/gUw8XnqBxK5lapln5Pt5V332Qyuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOqPRiS7UG6w+cJO7L2brZ7axzWdR/jRrb8Ldv7cv7PeRxn2fZaZAuI4jdE9DMAfZ8G97H0Kr4t47WaU0ksJIJWAxdi4L/uMe64ZwprSjD/ZgELeeu5UVK+Mc7685YuB+jvjg+kjMvePFnxiqfBh0V55j8+vaqoUPAHtJosp0XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=halPUPPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="halPUPPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28311C4CEF7;
	Tue,  4 Nov 2025 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762272063;
	bh=urq5Jnv1+ymhmV/gUw8XnqBxK5lapln5Pt5V332Qyuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=halPUPPFb69lor+LEQ5CI6zPvGi2KAqTJVukuOeTcGvcSL1WWA65A+hc/sHlcv6Gs
	 CjGyY2hrlM+pj5nVILYSkHHqQovgALANpnCWtU/5JR/hE53aVRZAtoUDotY3VeF6SX
	 G9sRe4svQKtubQAvf3qFbS4PYCXYT+/WV5hk4eKWzaHHPTOymwda95b/Yq0V4oW1MF
	 QB1acwZVBySu9iPqa+rCsS8Z38urrZo6bINs8KjLepXE17Jc0X2j84cg7XPil0+0IG
	 cLfOOImdJKQJV8BWVpwjuCqd+TPPvdR5tIJNeMmZ6jIMiQRojQwJOJFjVdcitjc0G0
	 aRc+8jSueVctw==
Date: Tue, 4 Nov 2025 08:01:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: transaction assertion failure in next-20251103
Message-ID: <20251104160102.GF196370@frogsfrogsfrogs>
References: <aQohjfEFmU8lef6M@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQohjfEFmU8lef6M@casper.infradead.org>

On Tue, Nov 04, 2025 at 03:53:49PM +0000, Matthew Wilcox wrote:
> Two runs of xfstests, two assertion failures.  One while running
> generic/083, one while running generic/561.

Can you also post the output of xfs_info /dev/vd[bc] (whichever one is
TEST_DEV)?  561 is the duperemove + write stress test, and 083 is
another stresser.

--D

> Here's the g/561 failure:
> 
> generic/561       run fstests generic/561 at 2025-11-03 22:20:18
> XFS (vdb): Mounting V5 Filesystem e0d0d737-4733-4583-8d2e-deaedb725697
> XFS (vdb): Ending clean mount
> XFS (vdc): Mounting V5 Filesystem 522795a0-828a-4476-9928-c71a0ff20619
> XFS (vdc): Ending clean mount
> XFS (vdc): Unmounting Filesystem 522795a0-828a-4476-9928-c71a0ff20619
> XFS (vdc): Mounting V5 Filesystem 2a587011-9c3c-41df-b507-5d3b27f8616c
> XFS (vdc): Ending clean mount
> iomap_finish_ioend_buffered: 80 callbacks suppressed
> vdc: writeback error on inode 166, offset 1589248, sector 5544
> vdc: writeback error on inode 25165978, offset 3338240, sector 22021584
> vdc: writeback error on inode 174, offset 1327104, sector 14832056
> vdc: writeback error on inode 8388743, offset 1122304, sector 7342704
> vdc: writeback error on inode 8388743, offset 4091904, sector 7344688
> vdc: writeback error on inode 8388743, offset 7483392, sector 7362280
> vdc: writeback error on inode 16908430, offset 5103616, sector 22031648
> vdc: writeback error on inode 16908430, offset 5865472, sector 22033136
> vdc: writeback error on inode 16908438, offset 778240, sector 22031064
> vdc: writeback error on inode 16908438, offset 3309568, sector 22031216
> XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4/0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
> XFS (vdc): Please unmount the filesystem and rectify the problem(s)
> XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 120
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:102!
> Oops: invalid opcode: 0000 [#1] SMP NOPTI
> CPU: 3 UID: 0 PID: 1631375 Comm: kworker/3:4 Tainted: G        W           6.18.0-rc4-next-20251103-ktest-00016-g8c6f8121e488 #113 NONE
> Tainted: [W]=WARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: xfs-conv/vdc xfs_end_io
> RIP: 0010:assfail+0x3c/0x46
> Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> RSP: 0018:ffff8881582d3ba8 EFLAGS: 00010202
> RAX: 00000000ffffff01 RBX: ffff8880174a9790 RCX: 000000007fffffff
> RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> RBP: ffff8881582d3ba8 R08: 0000000000000000 R09: 000000000000000a
> R10: 000000000000000a R11: 0fffffffffffffff R12: ffff8880174a9878
> R13: ffff888110460000 R14: 0000000000000000 R15: ffff8880174a9948
> FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7098803000 CR3: 0000000155342000 CR4: 0000000000750eb0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  xfs_trans_dup+0x258/0x270
>  xfs_trans_roll+0x48/0x120
>  xfs_defer_trans_roll+0x5f/0x1a0
>  xfs_defer_finish_noroll+0x3d5/0x5d0
>  xfs_trans_commit+0x4e/0x70
>  xfs_iomap_write_unwritten+0xe5/0x350
>  xfs_end_ioend+0x219/0x2c0
>  xfs_end_io+0xae/0xd0
>  process_one_work+0x1ed/0x530
>  ? move_linked_works+0x77/0xb0
>  worker_thread+0x1cf/0x3d0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x100/0x220
>  ? _raw_spin_unlock_irq+0x2b/0x40
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x1f6/0x250
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in: [last unloaded: crc_t10dif]
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:assfail+0x3c/0x46
> Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> RSP: 0018:ffff8881582d3ba8 EFLAGS: 00010202
> RAX: 00000000ffffff01 RBX: ffff8880174a9790 RCX: 000000007fffffff
> RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> RBP: ffff8881582d3ba8 R08: 0000000000000000 R09: 000000000000000a
> R10: 000000000000000a R11: 0fffffffffffffff R12: ffff8880174a9878
> R13: ffff888110460000 R14: 0000000000000000 R15: ffff8880174a9948
> FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7098803000 CR3: 0000000155342000 CR4: 0000000000750eb0
> PKRU: 55555554
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: disabled
> ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> The 081 failure looks similar:
> 
> vdc: writeback error on inode 131223, offset 1552384, sector 194360
> XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4
> /0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
> XFS (vdc): Please unmount the filesystem and rectify the problem(s)
> XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_tra
> ns.c, line: 120
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:102!
> Oops: invalid opcode: 0000 [#1] SMP NOPTI
> CPU: 3 UID: 0 PID: 338999 Comm: kworker/3:12 Not tainted 6.18.0-rc4-next-2025110
> 3-ktest-00016-g8c6f8121e488 #113 NONE 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 
> 04/01/2014
> Workqueue: xfs-conv/vdc xfs_end_io
> RIP: 0010:assfail+0x3c/0x46
> Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> RSP: 0018:ffff888115b3fba8 EFLAGS: 00010202
> RAX: 00000000ffffff01 RBX: ffff88815d857878 RCX: 000000007fffffff
> RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> RBP: ffff888115b3fba8 R08: 0000000000000000 R09: 000000000000000a
> R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88815d857d00
> R13: ffff888114c28000 R14: 0000000000000000 R15: ffff88815d857dd0
> FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f585a04a000 CR3: 000000010ebd3000 CR4: 0000000000750eb0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  xfs_trans_dup+0x258/0x270
>  xfs_trans_roll+0x48/0x120
>  xfs_defer_trans_roll+0x5f/0x1a0
>  xfs_defer_finish_noroll+0x3d5/0x5d0
>  xfs_trans_commit+0x4e/0x70
>  xfs_iomap_write_unwritten+0xe5/0x350
>  xfs_end_ioend+0x219/0x2c0
>  xfs_end_io+0xae/0xd0
>  process_one_work+0x1ed/0x530
>  ? move_linked_works+0x77/0xb0
>  worker_thread+0x1cf/0x3d0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x100/0x220
>  ? _raw_spin_unlock_irq+0x2b/0x40
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x1f6/0x250
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:assfail+0x3c/0x46
> Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> RSP: 0018:ffff888115b3fba8 EFLAGS: 00010202
> RAX: 00000000ffffff01 RBX: ffff88815d857878 RCX: 000000007fffffff
> RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> RBP: ffff888115b3fba8 R08: 0000000000000000 R09: 000000000000000a
> R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88815d857d00
> R13: ffff888114c28000 R14: 0000000000000000 R15: ffff88815d857dd0
> FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f585a04a000 CR3: 000000010ebd3000 CR4: 0000000000750eb0
> PKRU: 55555554
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: disabled
> ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> 
