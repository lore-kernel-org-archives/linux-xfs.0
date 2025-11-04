Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929F52561AA
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273188; cv=none; b=oCjm+mbsFGxjLSC86a9CEoxHHQswQM1J2PTmSLlwYCvp0TCNFArC+IkE8bMJzxEARBxgyEO80IgaktVoWtANCBLoVmFjJu0zfIrZ27VGCP8BedHQdYV4mgjD+Lq94OXlzLPqKkZP+T9rR93LX3TeN2lpTwo10Kd41ydWpKNgmyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273188; c=relaxed/simple;
	bh=G0dB4FHVCsRL94zXGivFRPOSkmVYuwVOCZlcfxAMz5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNSaMD85PYUZe6/uP8Pip8QWxj2M4zXPzsoODE4zMEWkOZqpPS7mqrSJ7fQ2efPhKR5nQ/+Zgl2z2OWOi2Lls0Zc7sqH3roQQ6tqFDsKAsaHI7AublEPvms5G80+EjUTGw/UIsLOgXozjHGmW2p1E4ROv0MTlI5kgT0//aOxBdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XgkxZPZy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XgkxZPZy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iqIvnhRDOIiNLJOH8u4NbMgl5OKaLxvvM9geUMvrJaE=; b=XgkxZPZyQKHRErA3YhtjmMLeId
	bQJAq/IsRvcWLv4R2vXU7b8qe/FhHWqssB/nOt7vofc5wFNPOKbMtvyap//YMOHz5nfupKB08Y0FZ
	rqK6b/fAM0m+AilAZD3DOozMFir93Hf9zaVaPQx1sbQqY5tEZ5Km6RkvmkKZeXspZyIpWyLl7UeiU
	W66QCrfWW2RbbZGe+eaCdgVd+uPeou9Gy7lHmZ6+R6ZZI9+pcFFGWPMvo2YEe9dIYTaBtgWniPs4S
	+KkTv+KqIE/JiX1Yi/gK4C86eumMdWgaEmTj4AHA5Zyo+JUgfiI/uUHGm+FSmKGiUZUxgqEV+enuk
	DAsJ0lGQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGJl1-0000000CpKZ-0ofC;
	Tue, 04 Nov 2025 16:19:43 +0000
Date: Tue, 4 Nov 2025 16:19:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: transaction assertion failure in next-20251103
Message-ID: <aQonnm_0G-iU4fAj@casper.infradead.org>
References: <aQohjfEFmU8lef6M@casper.infradead.org>
 <20251104160102.GF196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104160102.GF196370@frogsfrogsfrogs>

On Tue, Nov 04, 2025 at 08:01:02AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 04, 2025 at 03:53:49PM +0000, Matthew Wilcox wrote:
> > Two runs of xfstests, two assertion failures.  One while running
> > generic/083, one while running generic/561.
> 
> Can you also post the output of xfs_info /dev/vd[bc] (whichever one is
> TEST_DEV)?  561 is the duperemove + write stress test, and 083 is
> another stresser.

Maybe?  It's all wrapped up inside a CI system I don't fully understand,
and since it's paniced, I can't log into it.  Restarting the VM will
presuambly blow away the storage.  So here's what I can do:

$ /usr/sbin/xfs_info ktest-out/vm/dev-1
meta-data=ktest-out/vm/dev-1     isize=512    agcount=4, agsize=917504 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=3670016, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents

$ /usr/sbin/xfs_info ktest-out/vm/dev-2
meta-data=ktest-out/vm/dev-2     isize=512    agcount=4, agsize=917504 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=3670016, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents

$ /usr/sbin/xfs_info ktest-out/vm/dev-3
xfs_info: ktest-out/vm/dev-3 is not a valid XFS filesystem (unexpected SB magic number 0x72687377)
Use -F to force a read attempt.

So my guess is that dev-1 is vdb, dev-2 is vdc and dev-3 is vdd.  

> --D
> 
> > Here's the g/561 failure:
> > 
> > generic/561       run fstests generic/561 at 2025-11-03 22:20:18
> > XFS (vdb): Mounting V5 Filesystem e0d0d737-4733-4583-8d2e-deaedb725697
> > XFS (vdb): Ending clean mount
> > XFS (vdc): Mounting V5 Filesystem 522795a0-828a-4476-9928-c71a0ff20619
> > XFS (vdc): Ending clean mount
> > XFS (vdc): Unmounting Filesystem 522795a0-828a-4476-9928-c71a0ff20619
> > XFS (vdc): Mounting V5 Filesystem 2a587011-9c3c-41df-b507-5d3b27f8616c
> > XFS (vdc): Ending clean mount
> > iomap_finish_ioend_buffered: 80 callbacks suppressed
> > vdc: writeback error on inode 166, offset 1589248, sector 5544
> > vdc: writeback error on inode 25165978, offset 3338240, sector 22021584
> > vdc: writeback error on inode 174, offset 1327104, sector 14832056
> > vdc: writeback error on inode 8388743, offset 1122304, sector 7342704
> > vdc: writeback error on inode 8388743, offset 4091904, sector 7344688
> > vdc: writeback error on inode 8388743, offset 7483392, sector 7362280
> > vdc: writeback error on inode 16908430, offset 5103616, sector 22031648
> > vdc: writeback error on inode 16908430, offset 5865472, sector 22033136
> > vdc: writeback error on inode 16908438, offset 778240, sector 22031064
> > vdc: writeback error on inode 16908438, offset 3309568, sector 22031216
> > XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4/0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
> > XFS (vdc): Please unmount the filesystem and rectify the problem(s)
> > XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 120
> > ------------[ cut here ]------------
> > kernel BUG at fs/xfs/xfs_message.c:102!
> > Oops: invalid opcode: 0000 [#1] SMP NOPTI
> > CPU: 3 UID: 0 PID: 1631375 Comm: kworker/3:4 Tainted: G        W           6.18.0-rc4-next-20251103-ktest-00016-g8c6f8121e488 #113 NONE
> > Tainted: [W]=WARN
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > Workqueue: xfs-conv/vdc xfs_end_io
> > RIP: 0010:assfail+0x3c/0x46
> > Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > RSP: 0018:ffff8881582d3ba8 EFLAGS: 00010202
> > RAX: 00000000ffffff01 RBX: ffff8880174a9790 RCX: 000000007fffffff
> > RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> > RBP: ffff8881582d3ba8 R08: 0000000000000000 R09: 000000000000000a
> > R10: 000000000000000a R11: 0fffffffffffffff R12: ffff8880174a9878
> > R13: ffff888110460000 R14: 0000000000000000 R15: ffff8880174a9948
> > FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f7098803000 CR3: 0000000155342000 CR4: 0000000000750eb0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  xfs_trans_dup+0x258/0x270
> >  xfs_trans_roll+0x48/0x120
> >  xfs_defer_trans_roll+0x5f/0x1a0
> >  xfs_defer_finish_noroll+0x3d5/0x5d0
> >  xfs_trans_commit+0x4e/0x70
> >  xfs_iomap_write_unwritten+0xe5/0x350
> >  xfs_end_ioend+0x219/0x2c0
> >  xfs_end_io+0xae/0xd0
> >  process_one_work+0x1ed/0x530
> >  ? move_linked_works+0x77/0xb0
> >  worker_thread+0x1cf/0x3d0
> >  ? __pfx_worker_thread+0x10/0x10
> >  kthread+0x100/0x220
> >  ? _raw_spin_unlock_irq+0x2b/0x40
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork+0x1f6/0x250
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> > Modules linked in: [last unloaded: crc_t10dif]
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:assfail+0x3c/0x46
> > Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > RSP: 0018:ffff8881582d3ba8 EFLAGS: 00010202
> > RAX: 00000000ffffff01 RBX: ffff8880174a9790 RCX: 000000007fffffff
> > RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> > RBP: ffff8881582d3ba8 R08: 0000000000000000 R09: 000000000000000a
> > R10: 000000000000000a R11: 0fffffffffffffff R12: ffff8880174a9878
> > R13: ffff888110460000 R14: 0000000000000000 R15: ffff8880174a9948
> > FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f7098803000 CR3: 0000000155342000 CR4: 0000000000750eb0
> > PKRU: 55555554
> > Kernel panic - not syncing: Fatal exception
> > Kernel Offset: disabled
> > ---[ end Kernel panic - not syncing: Fatal exception ]---
> > 
> > The 081 failure looks similar:
> > 
> > vdc: writeback error on inode 131223, offset 1552384, sector 194360
> > XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4
> > /0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
> > XFS (vdc): Please unmount the filesystem and rectify the problem(s)
> > XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_tra
> > ns.c, line: 120
> > ------------[ cut here ]------------
> > kernel BUG at fs/xfs/xfs_message.c:102!
> > Oops: invalid opcode: 0000 [#1] SMP NOPTI
> > CPU: 3 UID: 0 PID: 338999 Comm: kworker/3:12 Not tainted 6.18.0-rc4-next-2025110
> > 3-ktest-00016-g8c6f8121e488 #113 NONE 
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 
> > 04/01/2014
> > Workqueue: xfs-conv/vdc xfs_end_io
> > RIP: 0010:assfail+0x3c/0x46
> > Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > RSP: 0018:ffff888115b3fba8 EFLAGS: 00010202
> > RAX: 00000000ffffff01 RBX: ffff88815d857878 RCX: 000000007fffffff
> > RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> > RBP: ffff888115b3fba8 R08: 0000000000000000 R09: 000000000000000a
> > R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88815d857d00
> > R13: ffff888114c28000 R14: 0000000000000000 R15: ffff88815d857dd0
> > FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f585a04a000 CR3: 000000010ebd3000 CR4: 0000000000750eb0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  xfs_trans_dup+0x258/0x270
> >  xfs_trans_roll+0x48/0x120
> >  xfs_defer_trans_roll+0x5f/0x1a0
> >  xfs_defer_finish_noroll+0x3d5/0x5d0
> >  xfs_trans_commit+0x4e/0x70
> >  xfs_iomap_write_unwritten+0xe5/0x350
> >  xfs_end_ioend+0x219/0x2c0
> >  xfs_end_io+0xae/0xd0
> >  process_one_work+0x1ed/0x530
> >  ? move_linked_works+0x77/0xb0
> >  worker_thread+0x1cf/0x3d0
> >  ? __pfx_worker_thread+0x10/0x10
> >  kthread+0x100/0x220
> >  ? _raw_spin_unlock_irq+0x2b/0x40
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork+0x1f6/0x250
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:assfail+0x3c/0x46
> > Code: c2 f8 d1 41 82 48 89 f1 48 89 fe 48 c7 c7 55 69 46 82 48 89 e5 e8 e4 fd ff ff 8a 05 e6 79 55 01 3c 01 76 02 0f 0b a8 01 74 02 <0f> 0b 0f 0b 5d c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > RSP: 0018:ffff888115b3fba8 EFLAGS: 00010202
> > RAX: 00000000ffffff01 RBX: ffff88815d857878 RCX: 000000007fffffff
> > RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff82466955
> > RBP: ffff888115b3fba8 R08: 0000000000000000 R09: 000000000000000a
> > R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88815d857d00
> > R13: ffff888114c28000 R14: 0000000000000000 R15: ffff88815d857dd0
> > FS:  0000000000000000(0000) GS:ffff8881f6b8d000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f585a04a000 CR3: 000000010ebd3000 CR4: 0000000000750eb0
> > PKRU: 55555554
> > Kernel panic - not syncing: Fatal exception
> > Kernel Offset: disabled
> > ---[ end Kernel panic - not syncing: Fatal exception ]---
> > 
> > 
