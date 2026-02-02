Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6095336C5AA
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770042535; cv=none; b=V6deVJdbmK38xum1JQr2MWlWrf/Z8zjbBaXiafl6jVS+OS42YOUNajg6Sodqsru3PTR1gQVZ0sS4yushLxhS99Sc7Rf0nrirctTEOett3+d+bjp2d3PTWYQj2Lns5R5k2AW+aIspGHVFEAr4qpR64zYGs5B/tKjdjgTxAiUqYnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770042535; c=relaxed/simple;
	bh=18lqlyZcGB71RMZtohV3JfWWBjL4hmtSBswtFVdoy24=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kxg4p+CSt6cBD6ZQmowm8Qa5PHfvbsCuBDgVIquIO3to8j0m+wKCR9TUuRgVeCXGVaS1pOB3jyVH/eRu/S5Y0PxxOcOvxYuU4kWhdCpQvQv3bxR7x049tN6L3aAtr6e45TFhOplFpzH8rn58GpQ/nRuFFcAsqzzW4AxlYuFtKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UIyDyfZ8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UIyDyfZ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=j/AKYZHyGoyCX1yD3ugPIFin5/OlyrKARVKuyD7D1AA=; b=UIyDyfZ8w7eHFNw7MoowRI9boA
	G7Pb91ZUuRpdn1ispDDoP7C7vLfGk8rsgFiemwh7ufwGjOtnwckVtoMB3ILzUs3WE2+rXOEEsPi8U
	9An0hsroTdb3r3n4rme48eQinQZmGvedzfuTB3TQIaoa/lIqnM1jsYlle6Y84epqZz+7Cxvhw7CmR
	b5tOV851XqTzuATEatIY/SDwPuhlGAIuacKTJthu+BYrce9RaMPg0IWeMTki6cJJUFtkA+vzCJcym
	5Cna49Vm/LQb/oi8Ih8ccz2ZFrYd3e3pqylNdzNmUlPplHfexjb5zl3OewAE+sRJl1yBOTOUAOMAL
	rfB9Smaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmuv7-000000056IS-2yqj;
	Mon, 02 Feb 2026 14:28:53 +0000
Date: Mon, 2 Feb 2026 06:28:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: generic/753 crash with LARP
Message-ID: <aYC0pe-S-RWSMXHn@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I've seen a few crashed during xfstests where generic/753 crashed during
attr log recovery.  They never reproduced when running the test
standalone in the loop, which made me realize that normally the
test does not even hit attr log recovery.  Forcing using the attr log
items using:

echo 1 > /sys/fs/xfs/debug/larp

Now makes it crash immediately for me.  I plan to separately look why
LARP is enabled during my -g auto run, probably some issue with the
actual LARP tests, but for now here is the trace.  Sending this to
Darrick as I think he touched that area last and might have ideas.

[   40.121475] XFS (dm-0): Mounting V5 Filesystem 82ccfb3f-c733-4297-a560-0b583af89968
[   40.325118] XFS (dm-0): Starting recovery (logdev: internal)
[   40.947262] XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 2996
[   40.947950] ------------[ cut here ]------------
[   40.948205] kernel BUG at fs/xfs/xfs_message.c:102!
[   40.948500] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[   40.948932] CPU: 0 UID: 0 PID: 4585 Comm: mount Not tainted 6.19.0-rc6+ #3467 PREEMPT(full) 
[   40.949483] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   40.950048] RIP: 0010:assfail+0x2c/0x35
[   40.950252] Code: 40 d6 49 89 d0 41 89 c9 48 c7 c2 58 ed f8 82 48 89 f1 48 89 fe 48 c7 c7 d6 33 02 83 e8 fd fd ff ff 80 3d 7e ce 84 02 00 74 02 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c
[   40.950871] RSP: 0018:ffffc90006dc3a68 EFLAGS: 00010202
[   40.950871] RAX: 0000000000000000 RBX: ffff8881130bd158 RCX: 000000007fffffff
[   40.950871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff830233d6
[   40.950871] RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
[   40.950871] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88811ac9c000
[   40.950871] R13: ffff88811ac9c0d0 R14: ffff888117b8e300 R15: ffff8881130bd100
[   40.950871] FS:  00007f35a3087840(0000) GS:ffff8884eb58a000(0000) knlGS:0000000000000000
[   40.950871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.950871] CR2: 00007fff920deed8 CR3: 000000012821e004 CR4: 0000000000770ef0
[   40.950871] PKRU: 55555554
[   40.950871] Call Trace:
[   40.950871]  <TASK>
[   40.950871]  xfs_attr3_leaf_setflag+0x188/0x1e0
[   40.950871]  xfs_attr_set_iter+0x46d/0xbb0
[   40.950871]  xfs_attr_finish_item+0x48/0x110
[   40.950871]  xfs_defer_finish_one+0xfd/0x2a0
[   40.950871]  xlog_recover_finish_intent+0x68/0x80
[   40.950871]  xfs_attr_recover_work+0x360/0x5a0
[   40.950871]  xfs_defer_finish_recovery+0x1f/0x90
[   40.950871]  xlog_recover_process_intents+0x9f/0x2b0
[   40.950871]  ? _raw_spin_unlock_irqrestore+0x1d/0x40
[   40.950871]  ? debug_object_activate+0x1ec/0x250
[   40.950871]  xlog_recover_finish+0x46/0x320
[   40.950871]  xfs_log_mount_finish+0x16a/0x1c0
[   40.950871]  xfs_mountfs+0x52e/0xa60
[   40.950871]  ? xfs_mru_cache_create+0x179/0x1c0
[   40.950871]  xfs_fs_fill_super+0x669/0xa30
[   40.950871]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[   40.950871]  get_tree_bdev_flags+0x12f/0x1d0
[   40.950871]  vfs_get_tree+0x24/0xd0
[   40.950871]  vfs_cmd_create+0x54/0xd0
[   40.950871]  __do_sys_fsconfig+0x4f6/0x6b0
[   40.950871]  do_syscall_64+0x50/0x2a0
[   40.950871]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   40.950871] RIP: 0033:0x7f35a32ac4aa
[   40.950871] Code: 73 01 c3 48 8b 0d 4e 59 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 af 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e 59 0d 00 f7 d8 64 89 01 48
[   40.950871] RSP: 002b:00007ffce01ac698 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
[   40.950871] RAX: ffffffffffffffda RBX: 00005625531e3ad0 RCX: 00007f35a32ac4aa
[   40.950871] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
[   40.950871] RBP: 00005625531e4bf0 R08: 0000000000000000 R09: 0000000000000000
[   40.950871] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   40.950871] R13: 00007f35a343e580 R14: 00007f35a344026c R15: 00007f35a3425a23
[   40.950871]  </TASK>
[   40.950871] Modules linked in:
[   40.964577] ---[ end trace 0000000000000000 ]---
[   40.965044] RIP: 0010:assfail+0x2c/0x35
[   40.965274] Code: 40 d6 49 89 d0 41 89 c9 48 c7 c2 58 ed f8 82 48 89 f1 48 89 fe 48 c7 c7 d6 33 02 83 e8 fd fd ff ff 80 3d 7e ce 84 02 00 74 02 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c
[   40.966296] RSP: 0018:ffffc90006dc3a68 EFLAGS: 00010202
[   40.966588] RAX: 0000000000000000 RBX: ffff8881130bd158 RCX: 000000007fffffff
[   40.967151] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff830233d6
[   40.967546] RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
[   40.967947] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88811ac9c000
[   40.968322] R13: ffff88811ac9c0d0 R14: ffff888117b8e300 R15: ffff8881130bd100
[   40.968687] FS:  00007f35a3087840(0000) GS:ffff8884eb58a000(0000) knlGS:0000000000000000
[   40.969101] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.969437] CR2: 00007f9fd47ad3f0 CR3: 000000012821e004 CR4: 0000000000770ef0
[   40.969806] PKRU: 55555554
