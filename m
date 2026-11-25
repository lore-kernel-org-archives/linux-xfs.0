Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.35.52.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625438;
	b=bsUOclMkGB4vTQFz1muk+I+maYPLLTNQod+rtRRdfqFVaOkLDg3myWw0ajCHRnLEUrPs
	 jImPmq5NNkzJtIM7dOW08IWANniIzrpj6fhMba+kAZ2cPG5ybk9PJKwDmk2XndZmm37Xs
	 d/ztSondRavjv5SCdGfsAZn+DIuDOe8tQ9MWxaVbtgATsLOqnN4xb/tlGZ5j4sLD6nDFG
	 4FhF8ytUuoqSPO6q7RI3lr+Daw5MrabgSFT0s/ifvDQaHepNDCdBw0U5EhhzxokktSCVG
	 La0aQ+PbRhZN4Lm1LDxQVfxvs/2E+vyls1hiMDFESyD0EQgF4Y3Ooc85PS7LvJC9hzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625438;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 X-Operating-System:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=/Yl/m5OF7BVoxkSxHo6vKvm1Ci5tkhmrvlTYmJm06c4=;
	b=LdQCNfX/eGNG8D8mj8M/qdnCgWxe7YiiFTtOpTrx+GmMEaU9lNTDfDx30uoB6BWAfBGd
	 5UGhMLpqAiFQwRx151cypqHcYtnpkQ60ZdyVIXbAT42vAVZk1M5Gdz6G8jvCGNaVefdAt
	 z7rvR8vdGSFfcqoxRtDtu62GYw0KsfUixTwU+oQm7mac2agYVPdctXZo9mivn5uPwQs6X
	 2wppwS8FgszimEpUbAZXDWrJ6joCA6pqiEkW2xy3nnkFsV3/9qr85ZRwOFw5mLgPFqvwq
	 XJ0WXkuelQtFgplrpW4j19UdbYNT0zJnPQFtPdnhoJTyYbtOskmbrDWtO515vx5AAMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gunderson.no;
	spf=pass smtp.mailfrom=gunderson.no;
	dkim=pass header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=jl11sQZy;
	arc=none smtp.remote-ip=193.35.52.50
Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05753606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 16:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05753606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=jl11sQZy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/Yl/m5OF7BVoxkSxHo6vKvm1Ci5tkhmrvlTYmJm06c4=; b=jl11sQZytnsVX+dOrAXRgtNOJa
	dnk2Om4MrMX3QrkOBexRe+VIlJNYB/TLbJzzX6JU3ZwCP/LFep/UjaleeTfdgrUuI9ln1w2SZ87UV
	riZTs4zLDVyuTTUnzx08lTMmnUVgiBnMwXO4X+TIF0aXcE12zRWiV74riTfpU10QbFl6map2e+ScO
	zEUHK4GwgIQG1ZQs4eZ46I5LkEw4tsyrzjLWTnDqOevmTuy1rUI7Z4RgpLo3QnWxQmSfob1y/yLeF
	yA806xFW1Tjv6rr8bGtUoC0ainksfgNOylyX2F6wp2AM4uaoZEISiTv/quSs2d5Y+bgCH/LsNQ/Yu
	p6z72bMQ==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.98.2)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1xWG54-00000003MN2-3I2d
	for linux-xfs@vger.kernel.org;
	Wed, 25 Nov 2026 17:44:32 +0100
Date: Wed, 25 Nov 2026 17:42:50 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: linux-xfs@vger.kernel.org
Subject: Hung I/O
Message-ID: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>
X-Operating-System: Linux 7.3.6 on a x86_64
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

I'm seeing a problem I haven't seen before; I first saw it with 7.4.0-rc4
but it looks exactly the same on 7.3.6, so it may be something related to
changing workload.

I have a process that mmaps a fairly large file (~500GB) for read/write;
this is more than my amount of RAM (256GB) but the working set is generally
less (I work on only parts of the file at any given time, and MADV_DISCARD
things when I'm done with them). I'm not sure if this is directly related,
but it seems so.

At some point, all XFS filesystem I/O on my machine becomes really slow
and hangs for several minutes, before it recovers. (Stopping the process
does not cause immediate recovery.) The ext4 filesystems seem to be mostly
OK, but I haven't tested this thoroughly. The file is backed by XFS on an
mdadm RAID-6 against SATA 7200rpm drives (on a SAS controller), but even the
SSD-backed volumes seem to get large problems; various daemons hang and/or
time out since everything takes forever, SSH-ing into the machine times out,
etc..

dmesg outputs a few of these:

  [ 3263.529187] INFO: task sponge:111219 blocked in I/O wait for more than 120 seconds.
  [ 3263.534641]       Not tainted 7.3.6 #1
  [ 3263.540028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [ 3263.545487] task:sponge          state:D stack:0     pid:111219 tgid:111219 ppid:111216 task_flags:0x400100 flags:0x00080000
  [ 3263.551029] Call Trace:
  [ 3263.556397]  <TASK>
  [ 3263.561662]  __schedule+0x581/0x10b0
  [ 3263.566883]  schedule+0x28/0xa0
  [ 3263.572011]  io_schedule+0x46/0x70
  [ 3263.577103]  folio_wait_bit_common+0x13b/0x370
  [ 3263.582194]  ? __pfx_wake_page_function+0x10/0x10
  [ 3263.587227]  folio_wait_writeback+0x2c/0x80
  [ 3263.592201]  truncate_inode_partial_folio+0x68/0x200
  [ 3263.597161]  truncate_inode_pages_range+0x1e0/0x440
  [ 3263.602094]  xfs_fs_evict_inode+0x1f/0x70 [xfs]
  [ 3263.607057]  evict+0xff/0x270
  [ 3263.611827]  dentry_kill+0xa8/0x310
  [ 3263.616564]  dput.part.0+0xc4/0x190
  [ 3263.621254]  filename_renameat2+0x2bc/0x4a0
  [ 3263.625889]  __x64_sys_rename+0x48/0x70
  [ 3263.630447]  do_syscall_64+0xc0/0x550
  [ 3263.634971]  ? do_fchmodat+0x9c/0xe0
  [ 3263.639447]  ? __x64_sys_chmod+0x1d/0x30
  [ 3263.643855]  ? do_syscall_64+0xf9/0x550
  [ 3263.648187]  ? __mod_memcg_lruvec_state+0xcc/0x180
  [ 3263.652517]  ? lruvec_stat_mod_folio+0x80/0xc0
  [ 3263.656815]  ? __folio_mod_stat+0x26/0x80
  [ 3263.661036]  ? map_anon_folio_pte_nopf+0xcd/0x1b0
  [ 3263.665203]  ? do_anonymous_page+0x62c/0x9b0
  [ 3263.669340]  ? __handle_mm_fault+0xbb9/0x1170
  [ 3263.673440]  ? lock_vma_under_rcu+0x92/0x160
  [ 3263.677468]  ? count_memcg_events+0xb4/0x160
  [ 3263.681407]  ? handle_mm_fault+0x1aa/0x300
  [ 3263.685317]  ? do_user_addr_fault+0x202/0x690
  [ 3263.689166]  ? irqentry_exit+0x48/0x730
  [ 3263.692914]  ? do_syscall_64+0x35/0x550
  [ 3263.696530]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [ 3263.700060] RIP: 0033:0x7f60fbb333e7
  [ 3263.703469] RSP: 002b:00007ffea66e4b38 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
  [ 3263.706908] RAX: ffffffffffffffda RBX: 0000556b8f04e4c0 RCX: 00007f60fbb333e7
  [ 3263.710315] RDX: ffffffffffffffff RSI: 00007ffea66e6d74 RDI: 0000556b8f04e2a0
  [ 3263.713652] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
  [ 3263.716979] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
  [ 3263.720250] R13: 0000000000002000 R14: 0000000000000000 R15: 0000000000000e25
  [ 3263.723395]  </TASK>

A simpler one:

  [14380.178852] INFO: task prometheus:14307 blocked in I/O wait for more than 120 seconds.
  [14380.183922]       Not tainted 7.3.6 #1
  [14380.188970] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [14380.194138] task:prometheus      state:D stack:0     pid:14307 tgid:11079 ppid:1      task_flags:0x400040 flags:0x00080000
  [14380.199474] Call Trace:
  [14380.204758]  <TASK>
  [14380.210031]  __schedule+0x581/0x10b0
  [14380.215328]  schedule+0x28/0xa0
  [14380.220571]  io_schedule+0x46/0x70
  [14380.225767]  folio_wait_bit_common+0x13b/0x370
  [14380.230958]  ? __pfx_wake_page_function+0x10/0x10
  [14380.236131]  folio_wait_writeback+0x2c/0x80
  [14380.241323]  __filemap_fdatawait_range+0x87/0xe0
  [14380.246530]  file_write_and_wait_range+0x88/0xb0
  [14380.251730]  xfs_file_fsync+0x4a/0x1b0 [xfs]
  [14380.256982]  do_fsync+0x50/0xc0
  [14380.262043]  __x64_sys_fsync+0x13/0x20
  [14380.267015]  do_syscall_64+0xc0/0x550
  [14380.271864]  ? do_syscall_64+0xf9/0x550
  [14380.276589]  ? do_syscall_64+0xf9/0x550
  [14380.281157]  ? do_syscall_64+0xf9/0x550
  [14380.285603]  ? do_syscall_64+0x35/0x550
  [14380.289992]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [14380.294380] RIP: 0033:0x40f1ae
  [14380.298697] RSP: 002b:000000c002c4d4d0 EFLAGS: 00000216 ORIG_RAX: 000000000000004a
  [14380.303068] RAX: ffffffffffffffda RBX: 00000000000000b8 RCX: 000000000040f1ae
  [14380.307435] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000b8
  [14380.311721] RBP: 000000c002c4d510 R08: 0000000000000000 R09: 0000000000000000
  [14380.315865] R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000000
  [14380.319908] R13: 000000000be9e589 R14: 000000c000f03a40 R15: 000000000be9e588
  [14380.323863]  </TASK>

Lots of processes seem to hang in uninterruptable sleep (state D),
but there is _some_ I/O activity, typically around 1000–2000 kB/sek/disk.

The stuck processes are typically stuck in xfs_buf_lock. Here's one from
kworker/u513:1+flush-253:37:

  pannekake:~> sudo cat /proc/737609/stack
  [<0>] xfs_buf_lock+0x32/0xd0 [xfs]
  [<0>] xfs_buf_find_lock+0x51/0x100 [xfs]
  [<0>] xfs_buf_read_map+0x94/0x2b0 [xfs]
  [<0>] xfs_trans_read_buf_map+0x12d/0x270 [xfs]
  [<0>] xfs_btree_read_buf_block+0xa0/0x120 [xfs]
  [<0>] xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
  [<0>] xfs_btree_lookup+0xf2/0x550 [xfs]
  [<0>] xfs_alloc_cntbt_iter+0x9e/0x1b0 [xfs]
  [<0>] xfs_alloc_ag_vextent_locality+0x23f/0x460 [xfs]
  [<0>] xfs_alloc_ag_vextent_near+0x2c0/0x530 [xfs]
  [<0>] xfs_alloc_vextent_iterate_ags.constprop.0+0xd2/0x220 [xfs]
  [<0>] xfs_alloc_vextent_start_ag+0x9b/0x1a0 [xfs]
  [<0>] xfs_bmap_btalloc+0x2b3/0x690 [xfs]
  [<0>] xfs_bmapi_allocate+0xdf/0x2d0 [xfs]
  [<0>] xfs_bmapi_convert_one_delalloc+0x1f7/0x450 [xfs]
  [<0>] xfs_bmapi_convert_delalloc+0x43/0x60 [xfs]
  [<0>] xfs_writeback_range+0x2a4/0x470 [xfs]
  [<0>] iomap_writeback_folio+0x28f/0x6e0
  [<0>] iomap_writepages+0x5e/0xd0
  [<0>] xfs_vm_writepages+0x93/0x110 [xfs]
  [<0>] do_writepages+0xca/0x170
  [<0>] __writeback_single_inode+0x42/0x350
  [<0>] writeback_sb_inodes+0x23d/0x560
  [<0>] __writeback_inodes_wb+0x4c/0xf0
  [<0>] wb_writeback+0x1ac/0x310
  [<0>] wb_workfn+0x2ec/0x470
  [<0>] process_one_work+0x1ca/0x3c0
  [<0>] worker_thread+0x1ac/0x320
  [<0>] kthread+0xe5/0x120
  [<0>] ret_from_fork+0x2b7/0x340
  [<0>] ret_from_fork_asm+0x1a/0x30

and here's one from a userspace process:

  pannekake:~> sudo cat /proc/770769/stack
  [<0>] xfs_buf_lock+0x32/0xd0 [xfs]
  [<0>] xfs_buf_find_lock+0x51/0x100 [xfs]
  [<0>] xfs_buf_read_map+0x94/0x2b0 [xfs]
  [<0>] xfs_trans_read_buf_map+0x12d/0x270 [xfs]
  [<0>] xfs_read_agi+0xa2/0x170 [xfs]
  [<0>] xfs_ialloc_read_agi+0x4e/0x120 [xfs]
  [<0>] xfs_dialloc+0x1e1/0x8a0 [xfs]
  [<0>] xfs_create+0x297/0x460 [xfs]
  [<0>] xfs_generic_create+0x305/0x3a0 [xfs]
  [<0>] lookup_open+0x58a/0x870
  [<0>] path_openat+0x4cd/0xa00
  [<0>] do_file_open+0xf1/0x1a0
  [<0>] do_sys_openat2+0x80/0xe0
  [<0>] __x64_sys_openat+0x54/0xa0
  [<0>] do_syscall_64+0xc0/0x550
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Any ideas? It appears to be fairly easily reproducible, so I can do more
debugging if need be (although it's a production machine, so not too much
rebooting would be fine).

/* Steinar */
-- 
Homepage: https://www.sesse.net/
