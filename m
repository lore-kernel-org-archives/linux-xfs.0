Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97092749D3
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762271637; cv=none; b=UPouXzBZbmsX2xVdNK+zPzmy6+LopOzsYq/O7GDtNgoQJLcCMxl7OPYlbAjhr0t5DbKK6YJAKmRXrKAQy2wpV+8vgjWGbDL711YJo4ZO6nJsWbRcy0GgLilRb8RYOKYF1jSJAPsQbkYAWcSc/5V2nyBOgDLWa8YjezgtJWvWxmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762271637; c=relaxed/simple;
	bh=kB+brCLVM6h9G+ii+POcR9jm6m1wqxO+IXJ7YJY83yI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WcFBRhlNEPWyEqUE2r2+wS8TzzPcjv8+zNj/5PcKiOCE+qXIeIjvf2ji2602CUASbpDkXDPFanfmEu+4MjxkhhyrFSUGHByBwibwc4QfTRPRSO2MqTSVEV2jTxW7m/Z5kihUx+9wwLmY5+LWUvQNt3vhses/ejpK38a7vPLpvqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YQfj8QYk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YQfj8QYk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=MRLEYFmmL7i9weeMs2zpOD/lI0eA3NQrgWyc5MJuxds=; b=YQfj8QYkFGkyUJifvGKz06pzNB
	s8y/BN9ZC/n3r96atdDo8FvQdI/2A8iBz3MScbx03bPtZLfYvOjHDoZrN53R7oEjJif3l79WJlXBs
	ZY0UmIzLopLKh5+83s60g6PlWeIlCJhfV8KBXDinKlzA1/s0DrSuzBnmz8K0Un7N7r1xt7VHhJBhk
	ydXznMaHdjuybkcYKZe7I+D9zpNWmuh0PMEhm3c5XRkJEAJ1glh5KoG+YtQd1Qh/9ztf2oiQ1qUsS
	+ikY9Gki7ePYwJSgzkPWDq+eQSDgpSQV+lfuDcctjoSqG79evtQTFOs3SfWvpRQnVS0KlQlwSCNv2
	P4osi7Sg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGJLx-0000000CCNH-48ox
	for linux-xfs@vger.kernel.org;
	Tue, 04 Nov 2025 15:53:50 +0000
Date: Tue, 4 Nov 2025 15:53:49 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-xfs@vger.kernel.org
Subject: transaction assertion failure in next-20251103
Message-ID: <aQohjfEFmU8lef6M@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Two runs of xfstests, two assertion failures.  One while running
generic/083, one while running generic/561.

Here's the g/561 failure:

generic/561       run fstests generic/561 at 2025-11-03 22:20:18
XFS (vdb): Mounting V5 Filesystem e0d0d737-4733-4583-8d2e-deaedb725697
XFS (vdb): Ending clean mount
XFS (vdc): Mounting V5 Filesystem 522795a0-828a-4476-9928-c71a0ff20619
XFS (vdc): Ending clean mount
XFS (vdc): Unmounting Filesystem 522795a0-828a-4476-9928-c71a0ff20619
XFS (vdc): Mounting V5 Filesystem 2a587011-9c3c-41df-b507-5d3b27f8616c
XFS (vdc): Ending clean mount
iomap_finish_ioend_buffered: 80 callbacks suppressed
vdc: writeback error on inode 166, offset 1589248, sector 5544
vdc: writeback error on inode 25165978, offset 3338240, sector 22021584
vdc: writeback error on inode 174, offset 1327104, sector 14832056
vdc: writeback error on inode 8388743, offset 1122304, sector 7342704
vdc: writeback error on inode 8388743, offset 4091904, sector 7344688
vdc: writeback error on inode 8388743, offset 7483392, sector 7362280
vdc: writeback error on inode 16908430, offset 5103616, sector 22031648
vdc: writeback error on inode 16908430, offset 5865472, sector 22033136
vdc: writeback error on inode 16908438, offset 778240, sector 22031064
vdc: writeback error on inode 16908438, offset 3309568, sector 22031216
XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4/0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
XFS (vdc): Please unmount the filesystem and rectify the problem(s)
XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 120
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
CPU: 3 UID: 0 PID: 1631375 Comm: kworker/3:4 Tainted: G        W           6.18.0-rc4-next-20251103-ktest-00016-g8c6f8121e488 #113 NONE
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: xfs-conv/vdc xfs_end_io
RIP: 0010:assfail+0x3c/0x46
Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
RSP: 0018:ffff8881582d3ba8 EFLAGS: 00010202
RAX: 00000000ffffff01 RBX: ffff8880174a9790 RCX: 000000007fffffff
RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
RBP: ffff8881582d3ba8 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: 0fffffffffffffff R12: ffff8880174a9878
R13: ffff888110460000 R14: 0000000000000000 R15: ffff8880174a9948
FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7098803000 CR3: 0000000155342000 CR4: 0000000000750eb0
PKRU: 55555554
Call Trace:
 <TASK>
 xfs_trans_dup+0x258/0x270
 xfs_trans_roll+0x48/0x120
 xfs_defer_trans_roll+0x5f/0x1a0
 xfs_defer_finish_noroll+0x3d5/0x5d0
 xfs_trans_commit+0x4e/0x70
 xfs_iomap_write_unwritten+0xe5/0x350
 xfs_end_ioend+0x219/0x2c0
 xfs_end_io+0xae/0xd0
 process_one_work+0x1ed/0x530
 ? move_linked_works+0x77/0xb0
 worker_thread+0x1cf/0x3d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x100/0x220
 ? _raw_spin_unlock_irq+0x2b/0x40
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x1f6/0x250
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in: [last unloaded: crc_t10dif]
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x3c/0x46
Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
RSP: 0018:ffff8881582d3ba8 EFLAGS: 00010202
RAX: 00000000ffffff01 RBX: ffff8880174a9790 RCX: 000000007fffffff
RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
RBP: ffff8881582d3ba8 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: 0fffffffffffffff R12: ffff8880174a9878
R13: ffff888110460000 R14: 0000000000000000 R15: ffff8880174a9948
FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7098803000 CR3: 0000000155342000 CR4: 0000000000750eb0
PKRU: 55555554
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception ]---

The 081 failure looks similar:

vdc: writeback error on inode 131223, offset 1552384, sector 194360
XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4
/0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
XFS (vdc): Please unmount the filesystem and rectify the problem(s)
XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_tra
ns.c, line: 120
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
CPU: 3 UID: 0 PID: 338999 Comm: kworker/3:12 Not tainted 6.18.0-rc4-next-2025110
3-ktest-00016-g8c6f8121e488 #113 NONE 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 
04/01/2014
Workqueue: xfs-conv/vdc xfs_end_io
RIP: 0010:assfail+0x3c/0x46
Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
RSP: 0018:ffff888115b3fba8 EFLAGS: 00010202
RAX: 00000000ffffff01 RBX: ffff88815d857878 RCX: 000000007fffffff
RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
RBP: ffff888115b3fba8 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88815d857d00
R13: ffff888114c28000 R14: 0000000000000000 R15: ffff88815d857dd0
FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f585a04a000 CR3: 000000010ebd3000 CR4: 0000000000750eb0
PKRU: 55555554
Call Trace:
 <TASK>
 xfs_trans_dup+0x258/0x270
 xfs_trans_roll+0x48/0x120
 xfs_defer_trans_roll+0x5f/0x1a0
 xfs_defer_finish_noroll+0x3d5/0x5d0
 xfs_trans_commit+0x4e/0x70
 xfs_iomap_write_unwritten+0xe5/0x350
 xfs_end_ioend+0x219/0x2c0
 xfs_end_io+0xae/0xd0
 process_one_work+0x1ed/0x530
 ? move_linked_works+0x77/0xb0
 worker_thread+0x1cf/0x3d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x100/0x220
 ? _raw_spin_unlock_irq+0x2b/0x40
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x1f6/0x250
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x3c/0x46
Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
RSP: 0018:ffff888115b3fba8 EFLAGS: 00010202
RAX: 00000000ffffff01 RBX: ffff88815d857878 RCX: 000000007fffffff
RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
RBP: ffff888115b3fba8 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88815d857d00
R13: ffff888114c28000 R14: 0000000000000000 R15: ffff88815d857dd0
FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f585a04a000 CR3: 000000010ebd3000 CR4: 0000000000750eb0
PKRU: 55555554
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception ]---

