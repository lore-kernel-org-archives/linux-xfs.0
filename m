Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA4E376
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 01:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711070216; cv=none; b=UQW5Lq3Xd2dBRt7OaKwGWjolOV4TrqqeqASbLshfRDMquyzh9ZN/Lh1Ge91R1m4T4/Vdkpo0oBJio1F6nAtJBdQDp8fO/CrHoNv/oWMG81Vi6NlS93IPuqRbvUvVMEWpkBat0Jtxv2gGr81fGJ8n7F8G7w0nVmeL2VL9T647UmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711070216; c=relaxed/simple;
	bh=F/tcAb3Si7Pu+BrHtGbX+RGILR/3CbgGsomo9xKG+FA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dIIEGLh9CJYPblJsawsLDxTPqusCy6MpEPJxQpdYgm2rYzLZuDXv6RGcmbq2GzMzmhBoZtvpy/H41M36W2AqrpYGk6oaR+0Os1Y+iAYsf1JuD8pZ+YipORcUsSiV3Nq/E/mLaQo4Pv10jAX9TfXt2p8V4aBSCeLUjiNJIjdRehw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EZdsaR7a; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EZdsaR7a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=18T4k9dxtdS1vHJjIGNr9zIijWTocJURJMrdkFK/lEo=; b=EZdsaR7a9WtXdWUzSJJs2Xe9PG
	6EU+Vam6n/HYeLxlOl2i+QIFg4XIV89O34eLSciBNDbQBQYBPGE9xZACEnDu/6oDwvT+99eCahNRN
	mBkpIAFC1ykmeoacVj/yPONN5x+D2cWeDH/9uemThdM3noeUz+VIPq+sW8FcChGuKgGnBtYynurNw
	KadYdMzebTMoD5YV8Jbwg2dYeoWG1k1N6XqwjKVxJyblwKgIpSkPj1/15ciNa4dq2aGF9WYkC9wHz
	dh3BAvAYXuM26iV8BYexvw8Otgmgl8VYSYKk/aTLTVVjBSCPtp7VVlgKe2vefO1n8Fu7M51ruTpG6
	g38PJwgQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rnTWW-000000085Mj-43dQ
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 01:16:44 +0000
Date: Fri, 22 Mar 2024 01:16:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-xfs@vger.kernel.org
Subject: assertion failure in v6.7
Message-ID: <Zfzb_NOXer7Aybmi@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I ran xfstests against vanilla v6.7 to establish a baseline and hit
this.  Maybe it was in xfs/359 or maybe xfs/359 was the last test to
successfully complete.

XFS (vdc): EXPERIMENTAL online scrub feature in use. Use at your own risk!
[U] ++ Detect fuzzed field ill-health report
[U] ++ Try to repair filesystem (online)
XFS (vdc): Corruption not fixed during online repair.  Unmount and run xfs_repair.
XFS (vdc): Corruption not fixed during online repair.  Unmount and run xfs_repair.
[U] ++ Make sure error is gone (online)
XFS (vdc): Unmounting Filesystem 743f3785-a53c-472d-aa4c-9f3d419b08b7
XFS (vdc): Uncorrected metadata errors detected; please run xfs_repair.
[U] + Make sure error is gone (offline)
[U] + Mount filesystem to make changes
XFS (vdc): Mounting V5 Filesystem 743f3785-a53c-472d-aa4c-9f3d419b08b7
XFS (vdc): Ending clean mount
[U] ++ Try to write filesystem again
XFS: Assertion failed: 0, file: fs/xfs/libxfs/xfs_btree.c, line: 1756
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
invalid opcode: 0000 [#1] SMP
CPU: 0 PID: 1158473 Comm: kworker/u32:2 Not tainted 6.7.0-ktest #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: writeback wb_workfn (flush-254:32)
RIP: 0010:assfail+0x39/0x40
Code: c9 48 c7 c2 f8 f9 b9 81 48 89 e5 48 89 f1 48 89 fe 48 c7 c7 d2 9e b3 81 e8 a4 fd ff ff 80 3d ed d2 b7 00 00 75 04 0f 0b 5d c3 <0f> 0b 90 0f 1f 40 00 66 0f 1f 00 0f 1f 44 00 00 55 48 63 f6 49 89
RSP: 0018:ffff88812d5d3430 EFLAGS: 00010202
RAX: 00000000ffffffea RBX: ffff888109abb290 RCX: 000000007fffffff
RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff81b39ed2
RBP: ffff88812d5d3430 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: 0fffffffffffffff R12: 0000000000000002
R13: 0000000000000000 R14: ffff88812d5d34bc R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888179600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa788c27d0 CR3: 0000000001e2a000 CR4: 0000000000750eb0
PKRU: 55555554
Call Trace:
 <TASK>
 ? show_regs+0x65/0x70
 ? die+0x3b/0x90
 ? do_trap+0xc4/0xe0
 ? do_error_trap+0x6c/0x90
 ? assfail+0x39/0x40
 ? exc_invalid_op+0x56/0x70
 ? assfail+0x39/0x40
 ? asm_exc_invalid_op+0x1f/0x30
 ? assfail+0x39/0x40
 xfs_btree_decrement+0x2e3/0x350
 xfs_alloc_walk_iter+0xb5/0xe0
 xfs_alloc_ag_vextent_locality+0x165/0x3c0
 xfs_alloc_ag_vextent_near+0x2b8/0x530
 xfs_alloc_vextent_iterate_ags.constprop.0+0xcd/0x210
 xfs_alloc_vextent_start_ag+0xd3/0x190
 xfs_bmap_btalloc+0x375/0x5b0
 xfs_bmapi_allocate+0xd4/0x440
 xfs_bmapi_convert_delalloc+0x32e/0x530
 xfs_map_blocks+0x21a/0x590
 iomap_do_writepage+0x22f/0x7f0
 write_cache_pages+0x162/0x3d0
 ? iomap_truncate_page+0x50/0x50
 iomap_writepages+0x24/0x40
 xfs_vm_writepages+0x73/0xa0
 do_writepages+0xb1/0x1a0
 __writeback_single_inode+0x40/0x2d0
 writeback_sb_inodes+0x1a1/0x430
 __writeback_inodes_wb+0x54/0xf0
 ? queue_io+0xf1/0x100
 wb_writeback+0x233/0x280
 wb_workfn+0x2a8/0x420
 ? __switch_to+0x131/0x460
 process_one_work+0x138/0x2c0
 worker_thread+0x2ea/0x420
 ? flush_work+0x20/0x20
 kthread+0xdb/0x100
 ? kthread_complete_and_exit+0x30/0x30
 ret_from_fork+0x3a/0x60
 ? kthread_complete_and_exit+0x30/0x30
 ret_from_fork_asm+0x11/0x20
 </TASK>
Modules linked in: crct10dif_generic crct10dif_common [last unloaded: crc_t10dif]
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x39/0x40
Code: c9 48 c7 c2 f8 f9 b9 81 48 89 e5 48 89 f1 48 89 fe 48 c7 c7 d2 9e b3 81 e8 a4 fd ff ff 80 3d ed d2 b7 00 00 75 04 0f 0b 5d c3 <0f> 0b 90 0f 1f 40 00 66 0f 1f 00 0f 1f 44 00 00 55 48 63 f6 49 89
RSP: 0018:ffff88812d5d3430 EFLAGS: 00010202
RAX: 00000000ffffffea RBX: ffff888109abb290 RCX: 000000007fffffff
RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff81b39ed2
RBP: ffff88812d5d3430 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: 0fffffffffffffff R12: 0000000000000002
R13: 0000000000000000 R14: ffff88812d5d34bc R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888179600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa788c27d0 CR3: 0000000001e2a000 CR4: 0000000000750eb0
PKRU: 55555554
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception ]---

