Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76CA4594A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660913; cv=none; b=DElFJ7R1px1OfknHHh9OC1xMubElDVDWxk3F63lhvG4iVGqJRk8L5quHp8XE+sMV1NS7oVqZKEG2JgydaxlUw+CqpWZ4CDwQ6pgVCWKPDUy0kGbBhj0sbfHgmKDyFUQCf0KqrhWosSVO+twnMF35C8lyLGvsaWUMK0rdt/DkCM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660913; c=relaxed/simple;
	bh=Hj6k1tAr1/Np8EUwu4G2jVdDaiO7G/eoQrWEko5yX44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMx5rUDCX1sWmF+4LUE28UpxTAZeYs8oI8jonPJgLbxnJ0H+T8ifGmbmjn6RqNFbqoJl1Rfxrnl3e297Bc2Knx+SSia6kpA6LJJB7Auqhm0w8dUPhB5MudfkO2G1Ng7eDUtkrpjauwrJovIzEpHhuFC2UsTmCIi0RaRQDjQ4HSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4hiErfy2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4hiErfy2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EoB1L4mzBfJQM3/lelhXcokRo2otTtg5YPQB+7uLvSE=; b=4hiErfy2U58WBfrZpeYe8zz/Ww
	JLVOr/9GPQs4kQThL7d4JyB1ssqStZ4hkdpSHQGdMLZVMdk2APnalviG4uxhKmxZG4aNbZrbtLi4/
	xpmdmj0iIK1MmmOwQH1J0wjhuPFFlfuzT4gamWiOBJSZEs63jhEb3BN6iWCz+QxQl+20SciUF83ZG
	oHnswr7qpRuTcNi19PzeqPE/x/NrUZxUY+m3bnfPCJNPmct6ltpuVDORKKj6cS2kDz1RilNxr5daK
	sTcNCEVhHuRnp284ycscQ5WUtRfDKvFV24Tse9et0xEpLbDsGScpe2aXK4pEcNshLdf/77ubYDqD4
	rx1uuXdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQKuk-00000004xVo-0L4U;
	Tue, 02 Dec 2025 07:35:10 +0000
Date: Mon, 1 Dec 2025 23:35:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: KASAN triggering on generic/475 on aarch64?
Message-ID: <aS6Wrmz74IMh_NtW@infradead.org>
References: <20251202005911.GF89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202005911.GF89472@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 01, 2025 at 04:59:11PM -0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> Does anyone else see weird warnings and crashes in the kernel timer code
> when running generic/475 for a couple of hours on arm64?

I'm pretty the population of folks running generic/475 for a few hours
on arm is rather low :)  But given that this is low-level arm stuff
adding the arm list might make sense.

> I turned on
> KASAN and got the following report:
> 
> [ 1080.098534] XFS (dm-0): EXPERIMENTAL metadata directory tree feature enabled.  Use at your own risk!
> [ 1080.101096] XFS (dm-0): Mounting V5 Filesystem 056cb806-0bb7-401d-a116-1bc85c6026b5
> [ 1080.190389] XFS (dm-0): Starting recovery (logdev: internal)
> [ 1080.292266] XFS (dm-0): Ending recovery (logdev: internal)
> [ 1081.456848] iomap_finish_ioend_buffered: 26 callbacks suppressed
> [ 1081.456867] dm-0: writeback error on inode 70234311, offset 1073152, sector 38493904
> [ 1081.456954] XFS (dm-0): log I/O error -5
> [ 1081.456960] XFS (dm-0): Filesystem has been shut down due to log error (0x2).
> [ 1081.456963] XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
> [ 1081.456967] CPU: 1 UID: 0 PID: 111 Comm: 1:1H Not tainted 6.18.0-xfsa #5 PREEMPTLAZY  aa447adfe084b5fbc6023ad319929e88e68ca52d
> [ 1081.456973] Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> [ 1081.456975] Workqueue: xfs-log/dm-0 xlog_ioend_work [xfs]
> [ 1081.466571] Call trace:
> [ 1081.466573]  show_stack+0x20/0x40 (C)
> [ 1081.466580]  dump_stack_lvl+0x60/0x80
> [ 1081.466585]  dump_stack+0x1c/0x28
> [ 1081.466588]  xlog_force_shutdown+0x36c/0x400 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1081.473209]  xlog_ioend_work+0xe8/0x1a0 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1081.473414]  process_one_work+0x564/0xfb8
> [ 1081.473421]  worker_thread+0x4e0/0xc90
> [ 1081.473425]  kthread+0x350/0x630
> [ 1081.473429]  ret_from_fork+0x10/0x20
> [ 1081.479204] dm-0: writeback error on inode 3338862, offset 23678976, sector 20967632
> [ 1081.484022] buffer_io_error: 502 callbacks suppressed
> [ 1081.484053] Buffer I/O error on dev dm-0, logical block 0, async page read
> [ 1081.484069] Buffer I/O error on dev dm-0, logical block 1, async page read
> [ 1081.484080] Buffer I/O error on dev dm-0, logical block 2, async page read
> [ 1081.484088] Buffer I/O error on dev dm-0, logical block 3, async page read
> [ 1081.484097] Buffer I/O error on dev dm-0, logical block 4, async page read
> [ 1081.484106] Buffer I/O error on dev dm-0, logical block 5, async page read
> [ 1081.484114] Buffer I/O error on dev dm-0, logical block 6, async page read
> [ 1081.498036] Buffer I/O error on dev dm-0, logical block 7, async page read
> [ 1081.498058] Buffer I/O error on dev dm-0, logical block 8, async page read
> [ 1081.498069] Buffer I/O error on dev dm-0, logical block 9, async page read
> [ 1081.594384] XFS (dm-0): Unmounting Filesystem 056cb806-0bb7-401d-a116-1bc85c6026b5
> [ 1081.738455] XFS (dm-0): EXPERIMENTAL metadata directory tree feature enabled.  Use at your own risk!
> [ 1081.741840] XFS (dm-0): Mounting V5 Filesystem 056cb806-0bb7-401d-a116-1bc85c6026b5
> [ 1082.351959] XFS (dm-0): Starting recovery (logdev: internal)
> [ 1082.699264] XFS (dm-0): Ending recovery (logdev: internal)
> [ 1084.392933] ==================================================================
> [ 1084.392951] BUG: KASAN: slab-use-after-free in __run_timers+0x7e8/0x8a0
> [ 1084.392962] Write of size 8 at addr fffffc014647a7a8 by task fsstress/29105
> [ 1084.392966] 
> [ 1084.392970] CPU: 0 UID: 0 PID: 29105 Comm: fsstress Not tainted 6.18.0-xfsa #5 PREEMPTLAZY  aa447adfe084b5fbc6023ad319929e88e68ca52d
> [ 1084.392975] Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> [ 1084.392977] Call trace:
> [ 1084.392978]  show_stack+0x20/0x40 (C)
> [ 1084.392984]  dump_stack_lvl+0x60/0x80
> [ 1084.392988]  print_report+0x160/0x4c0
> [ 1084.392992]  kasan_report+0xb0/0xf8
> [ 1084.392997]  __asan_report_store8_noabort+0x20/0x30
> [ 1084.393002]  __run_timers+0x7e8/0x8a0
> [ 1084.393006]  run_timer_base+0xf8/0x148
> [ 1084.393009]  run_timer_softirq+0x24/0x50
> [ 1084.393014]  handle_softirqs+0x2b0/0xa60
> [ 1084.393017]  __do_softirq+0x1c/0x28
> [ 1084.393020]  ____do_softirq+0x18/0x30
> [ 1084.393024]  call_on_irq_stack+0x30/0x80
> [ 1084.393027]  do_softirq_own_stack+0x24/0x50
> [ 1084.393031]  __irq_exit_rcu+0x1f8/0x310
> [ 1084.393034]  irq_exit_rcu+0x18/0x30
> [ 1084.393037]  el1_interrupt+0x40/0x60
> [ 1084.393042]  el1h_64_irq_handler+0x18/0x28
> [ 1084.393046]  el1h_64_irq+0x6c/0x70
> [ 1084.393049]  kasan_check_range+0xcc/0x190 (P)
> [ 1084.393053]  do_raw_spin_unlock+0x16c/0x260
> [ 1084.393057]  _raw_spin_unlock+0x1c/0x80
> [ 1084.393062]  xfs_iget+0xb94/0x2358 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.393722]  xfs_bulkstat_one_int+0x104/0x1300 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.394622]  xfs_bulkstat_iwalk+0x70/0xc0 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.394827]  xfs_iwalk_ag_recs+0x2d4/0x5f0 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.395027]  xfs_iwalk_run_callbacks+0x238/0x548 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.395227]  xfs_iwalk_ag+0x43c/0x808 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.395604]  xfs_iwalk_args.constprop.0+0x170/0x310 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.395803]  xfs_iwalk+0x118/0x170 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.396001]  xfs_bulkstat+0x2b4/0x418 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.396244]  xfs_ioc_fsbulkstat.isra.0+0x1a0/0x428 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.396442]  xfs_file_ioctl+0x1c0/0x1d40 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.396639]  __arm64_sys_ioctl+0x74c/0x1598
> [ 1084.396645]  do_el0_svc+0x114/0x280
> [ 1084.396650]  el0_svc+0x40/0xf8
> [ 1084.396655]  el0t_64_sync_handler+0xa0/0xe8
> [ 1084.396659]  el0t_64_sync+0x198/0x1a0
> [ 1084.396663] 
> [ 1084.396664] Allocated by task 29104:
> [ 1084.396668]  kasan_save_stack+0x3c/0x70
> [ 1084.396673]  kasan_save_track+0x20/0x40
> [ 1084.396676]  kasan_save_alloc_info+0x40/0x58
> [ 1084.396679]  __kasan_kmalloc+0xd4/0xe0
> [ 1084.396682]  __kmalloc_noprof+0x1f8/0x728
> [ 1084.396685]  xlog_cil_commit+0x5c8/0x2b40 [xfs]
> [ 1084.396882]  __xfs_trans_commit+0x298/0xb10 [xfs]
> [ 1084.397091]  xfs_trans_roll+0xd0/0x3a0 [xfs]
> [ 1084.397286]  xfs_defer_trans_roll+0xd8/0x458 [xfs]
> [ 1084.397486]  xfs_defer_finish_noroll+0x5a0/0xe80 [xfs]
> [ 1084.397684]  xfs_trans_commit+0x158/0x1a0 [xfs]
> [ 1084.397880]  xfs_bmapi_convert_one_delalloc+0x740/0x9a0 [xfs]
> [ 1084.398078]  xfs_bmapi_convert_delalloc+0x98/0xf8 [xfs]
> [ 1084.398277]  xfs_buffered_write_iomap_begin+0x1698/0x1d48 [xfs]
> [ 1084.398472]  iomap_iter+0x360/0xcc0
> [ 1084.398478]  iomap_zero_range+0x298/0x4a0
> [ 1084.398481]  xfs_zero_range+0x98/0xf8 [xfs]
> [ 1084.398676]  xfs_file_write_checks+0x380/0x790 [xfs]
> [ 1084.398871]  xfs_file_buffered_write+0x228/0x870 [xfs]
> [ 1084.399065]  xfs_file_write_iter+0x378/0x890 [xfs]
> [ 1084.399259]  vfs_write+0x48c/0x8d8
> [ 1084.399264]  ksys_write+0xf8/0x1f0
> [ 1084.399267]  __arm64_sys_write+0x74/0xb0
> [ 1084.399270]  do_el0_svc+0x114/0x280
> [ 1084.399273]  el0_svc+0x40/0xf8
> [ 1084.399276]  el0t_64_sync_handler+0xa0/0xe8
> [ 1084.399280]  el0t_64_sync+0x198/0x1a0
> [ 1084.399282] 
> [ 1084.399283] Freed by task 44:
> [ 1084.399286]  kasan_save_stack+0x3c/0x70
> [ 1084.399289]  kasan_save_track+0x20/0x40
> [ 1084.399291]  __kasan_save_free_info+0x4c/0x80
> [ 1084.399295]  __kasan_slab_free+0x88/0xb8
> [ 1084.399298]  kfree+0x114/0x500
> [ 1084.399301]  kvfree+0x44/0x60
> [ 1084.399304]  xlog_cil_committed+0x288/0x4e8 [xfs]
> [ 1084.399498]  xlog_cil_process_committed+0xe4/0x190 [xfs]
> [ 1084.399692]  xlog_state_do_callback+0x3cc/0x930 [xfs]
> [ 1084.399886]  xlog_state_done_syncing+0x134/0x318 [xfs]
> [ 1084.400079]  xlog_ioend_work+0xf0/0x1a0 [xfs]
> [ 1084.400317]  process_one_work+0x564/0xfb8
> [ 1084.400323]  worker_thread+0x4e0/0xc90
> [ 1084.400326]  kthread+0x350/0x630
> [ 1084.400329]  ret_from_fork+0x10/0x20
> [ 1084.400333] 
> [ 1084.400335] The buggy address belongs to the object at fffffc014647a000
> [ 1084.400335]  which belongs to the cache kmalloc-4k of size 4096
> [ 1084.400338] The buggy address is located 1960 bytes inside of
> [ 1084.400338]  freed 4096-byte region [fffffc014647a000, fffffc014647b000)
> [ 1084.400341] 
> [ 1084.400342] The buggy address belongs to the physical page:
> [ 1084.400345] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x18646
> [ 1084.400348] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> [ 1084.400351] anon flags: 0x1ffe000000000040(head|node=0|zone=1|lastcpupid=0x7ff)
> [ 1084.400356] page_type: f5(slab)
> [ 1084.400360] raw: 1ffe000000000040 fffffc00e0011040 0000000000000000 dead000000000001
> [ 1084.400363] raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> [ 1084.400365] head: 1ffe000000000040 fffffc00e0011040 0000000000000000 dead000000000001
> [ 1084.400368] head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> [ 1084.400370] head: 1ffe000000000001 ffffffff40519181 00000000ffffffff 00000000ffffffff
> [ 1084.400372] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> [ 1084.400374] page dumped because: kasan: bad access detected
> [ 1084.400375] 
> [ 1084.400376] Memory state around the buggy address:
> [ 1084.400378]  fffffc014647a680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1084.400380]  fffffc014647a700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1084.400382] >fffffc014647a780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1084.400383]                                   ^
> [ 1084.400385]  fffffc014647a800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1084.400387]  fffffc014647a880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1084.400388] ==================================================================
> [ 1084.400390] Disabling lock debugging due to kernel taint
> [ 1084.400397] Unable to handle kernel paging request at virtual address e0fffe000c7480c1
> [ 1084.400400] KASAN: maybe wild-memory-access in range [0x0800000063a40608-0x0800000063a4060f]
> [ 1084.400402] Mem abort info:
> [ 1084.400404]   ESR = 0x0000000096000006
> [ 1084.400405]   EC = 0x25: DABT (current EL), IL = 32 bits
> [ 1084.400407]   SET = 0, FnV = 0
> [ 1084.400409]   EA = 0, S1PTW = 0
> [ 1084.400410]   FSC = 0x06: level 2 translation fault
> [ 1084.400412] Data abort info:
> [ 1084.400413]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
> [ 1084.400414]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [ 1084.400416]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [ 1084.400418] [e0fffe000c7480c1] address between user and kernel address ranges
> [ 1084.400422] Internal error: Oops: 0000000096000006 [#1]  SMP
> [ 1084.527749] Dumping ftrace buffer:
> [ 1084.528246]    (ftrace buffer empty)
> [ 1084.528716] Modules linked in: xfs rpcsec_gss_krb5 auth_rpcgss nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat x_tables ip_set_hash_mac nf_tables bfq sch_fq_codel fuse configfs efivarfs overlay nfsv4
> [ 1084.548848] CPU: 0 UID: 0 PID: 29105 Comm: fsstress Tainted: G    B               6.18.0-xfsa #5 PREEMPTLAZY  aa447adfe084b5fbc6023ad319929e88e68ca52d
> [ 1084.569541] Tainted: [B]=BAD_PAGE
> [ 1084.574702] Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> [ 1084.578232] pstate: 404010c5 (nZcv daIF +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> [ 1084.579170] pc : __run_timers+0x414/0x8a0
> [ 1084.579706] lr : __run_timers+0x60c/0x8a0
> [ 1084.580253] sp : fffffe0082defc80
> [ 1084.580682] x29: fffffe0082defde0 x28: dffffe0000000000 x27: fffffc014647a7a0
> [ 1084.589758] x26: dffffe0000000000 x25: fffffc014d52b040 x24: 0800000063a40600
> [ 1084.595175] x23: 000000010002fe00 x22: 1fffff803797a5e3 x21: 1fffffc0105bdfaa
> [ 1084.596172] x20: fffffe0082defd50 x19: fffffc01bcbd2f00 x18: 0000000000000000
> [ 1084.597122] x17: 3d3d3d3d3d3d3d3d x16: 3d3d3d3d3d3d3d3d x15: 3d3d3d3d3d3d3d3d
> [ 1084.599965] x14: 3d3d3d3d3d3d3d3d x13: 00000000000f7588 x12: fffffdc01053a965
> [ 1084.609386] x11: 1fffffc01053a964 x10: fffffdc01053a964 x9 : fffffe00802a6d40
> [ 1084.620436] x8 : fffffe0082defc70 x7 : 0000000000000000 x6 : 0000000000000001
> [ 1084.631299] x5 : 010000000c7480c1 x4 : 0000000000000000 x3 : 0000000000000020
> [ 1084.643080] x2 : fffffe0082defd50 x1 : fffffe0082a02920 x0 : 0800000063a40608
> [ 1084.653742] Call trace:
> [ 1084.657493]  __run_timers+0x414/0x8a0 (P)
> [ 1084.663591]  run_timer_base+0xf8/0x148
> [ 1084.669316]  run_timer_softirq+0x24/0x50
> [ 1084.675362]  handle_softirqs+0x2b0/0xa60
> [ 1084.681433]  __do_softirq+0x1c/0x28
> [ 1084.686871]  ____do_softirq+0x18/0x30
> [ 1084.692642]  call_on_irq_stack+0x30/0x80
> [ 1084.698699]  do_softirq_own_stack+0x24/0x50
> [ 1084.705185]  __irq_exit_rcu+0x1f8/0x310
> [ 1084.711045]  irq_exit_rcu+0x18/0x30
> [ 1084.716410]  el1_interrupt+0x40/0x60
> [ 1084.721853]  el1h_64_irq_handler+0x18/0x28
> [ 1084.727848]  el1h_64_irq+0x6c/0x70
> [ 1084.732975]  kasan_check_range+0xcc/0x190 (P)
> [ 1084.738896]  do_raw_spin_unlock+0x16c/0x260
> [ 1084.745084]  _raw_spin_unlock+0x1c/0x80
> [ 1084.750697]  xfs_iget+0xb94/0x2358 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.762064]  xfs_bulkstat_one_int+0x104/0x1300 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.775161]  xfs_bulkstat_iwalk+0x70/0xc0 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.787709]  xfs_iwalk_ag_recs+0x2d4/0x5f0 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.800602]  xfs_iwalk_run_callbacks+0x238/0x548 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.814206]  xfs_iwalk_ag+0x43c/0x808 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.826326]  xfs_iwalk_args.constprop.0+0x170/0x310 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.841182]  xfs_iwalk+0x118/0x170 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.852948]  xfs_bulkstat+0x2b4/0x418 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.864605]  xfs_ioc_fsbulkstat.isra.0+0x1a0/0x428 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.878410]  xfs_file_ioctl+0x1c0/0x1d40 [xfs 7a664e8b2565bbf246e2d705932ac3446adc6009]
> [ 1084.891037]  __arm64_sys_ioctl+0x74c/0x1598
> [ 1084.897397]  do_el0_svc+0x114/0x280
> [ 1084.902617]  el0_svc+0x40/0xf8
> [ 1084.907180]  el0t_64_sync_handler+0xa0/0xe8
> [ 1084.913489]  el0t_64_sync+0x198/0x1a0
> [ 1084.918999] Code: f9000058 b40000d8 91002300 d343fc05 (38fc68a5) 
> [ 1084.928221] ---[ end trace 0000000000000000 ]---
> [ 1084.935096] Kernel panic - not syncing: Oops: Fatal exception in interrupt
> [ 1084.943330] SMP: stopping secondary CPUs
> [ 1084.945640] Dumping ftrace buffer:
> [ 1084.947807]    (ftrace buffer empty)
> [ 1084.949888] Kernel Offset: disabled
> [ 1084.952106] CPU features: 0x100000,0000e000,40006281,0441700b
> [ 1084.955826] Memory Limit: none
> [ 1084.957847] ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---
> 
> This is a weird report -- the timer code reports what looks like garbage
> in a timer_list object, but the KASAN report reports to the most recent
> allocation being the xlog_kvmalloc call in xlog_cil_alloc_shadow_bufs
> and the corresponding kvfree of that shadow buffer.
> 
> My guess is that someone created a timer, queued it somewhere, freed the
> timer, and later on the CIL stumbled onto the same memory and that's why
> there's a bunch of kaboom.
> 
> Coincidentally generic/656 on a different (but otherwise identical)
> arm64 VM coughed this up:
> 
> [ 8707.815539] ------------[ cut here ]------------
> [ 8707.815546] workqueue: cannot queue xfs_reclaim_worker [xfs] on wq \xd8f\xee\xed
> [ 8707.815680] WARNING: CPU: 0 PID: 0 at kernel/workqueue.c:2257 __queue_work+0x460/0x5f8
> [ 8707.827486] Modules linked in: ext2 mbcache dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio dm_flakey loop xfs rpcsec_gss_krb5 auth_rpcgss nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat x_tables ip_set_hash_mac nf_tables bfq sch_fq_codel fuse configfs efivarfs overlay nfsv4
> [ 8707.852559] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G        W           6.18.0-acha #1 PREEMPTLAZY  36e54c0b238dbd4929d429645e39497dd45df6eb
> [ 8707.861584] Tainted: [W]=WARN
> [ 8707.863400] Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> [ 8707.867278] pstate: 604010c5 (nZCv daIF +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> [ 8707.871956] pc : __queue_work+0x460/0x5f8
> [ 8707.874232] lr : __queue_work+0x460/0x5f8
> [ 8707.875944] sp : fffffe00813afd70
> [ 8707.877382] x29: fffffe00813afd70 x28: fffffe0080097b48 x27: fffffe008127e888
> [ 8707.880626] x26: fffffc00edee3400 x25: fffffe0081175d78 x24: 0000000000000001
> [ 8707.884868] x23: 0000000000000101 x22: 00000001002012c0 x21: fffffe0080097b48
> [ 8707.889942] x20: 0000000000000008 x19: fffffc00c5470780 x18: 0000000000000000
> [ 8707.894895] x17: fffffe017e420000 x16: fffffe00813a0000 x15: 0000000000000000
> [ 8707.899722] x14: 0000000000000000 x13: 2065756575712074 x12: fffffe008119c138
> [ 8707.904676] x11: fffffe00811999b0 x10: fffffe00811a49b0 x9 : fffffe00800fa598
> [ 8707.909402] x8 : 00000000001ad848 x7 : 0000000000000ac8 x6 : c000000100005a73
> [ 8707.912864] x5 : 000000000000a42a x4 : 0000000000000001 x3 : fffffe008117e080
> [ 8707.916207] x2 : 0000000000000000 x1 : 0000000000000000 x0 : fffffe008117e080
> [ 8707.919499] Call trace:
> [ 8707.920601]  __queue_work+0x460/0x5f8 (P)
> [ 8707.922478]  delayed_work_timer_fn+0x24/0x40
> [ 8707.924584]  call_timer_fn+0x3c/0x1a8
> [ 8707.927048]  __run_timers+0x204/0x318
> [ 8707.929416]  run_timer_base+0x64/0x88
> [ 8707.931964]  run_timer_softirq+0x24/0x50
> [ 8707.934504]  handle_softirqs+0x15c/0x398
> [ 8707.937631]  __do_softirq+0x1c/0x28
> [ 8707.940076]  ____do_softirq+0x18/0x30
> [ 8707.942424]  call_on_irq_stack+0x30/0x78
> [ 8707.945418]  do_softirq_own_stack+0x24/0x50
> [ 8707.948320]  __irq_exit_rcu+0xf0/0x168
> [ 8707.951297]  irq_exit_rcu+0x18/0x38
> [ 8707.953762]  el1_interrupt+0x40/0x60
> [ 8707.955889]  el1h_64_irq_handler+0x18/0x28
> [ 8707.958503]  el1h_64_irq+0x6c/0x70
> [ 8707.960990]  default_idle_call+0x38/0x178 (P)
> [ 8707.963907]  do_idle+0x214/0x280
> [ 8707.966232]  cpu_startup_entry+0x3c/0x50
> [ 8707.969031]  rest_init+0xf0/0x100
> [ 8707.971311]  start_kernel+0x764/0x770
> [ 8707.973854]  __primary_switched+0x88/0x98
> [ 8707.976703] ---[ end trace 0000000000000000 ]---
> 
> Which makes me wonder if the delayed reclaim work is not being cancelled
> properly?  <shrug> will keep looking...
> 
> --D
> 
---end quoted text---
