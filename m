Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E8E3019D0
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 09:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508545; cv=none; b=LaoLKs7T1qkAL/NPWNmlCxhv+icRcrMhxYwTkKs/Vpr4V/uYlva2N/kIutIr29iCjtR3yOwjiZVvnNIYEudnoi/NBp5bSchPIM+gzmRSQy5aCJN5GIxWhQOIde4N5fKs4Ii8+wRkTXIcuLfL+jNazYz+YZIVgPmJIzkUOdFcSgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508545; c=relaxed/simple;
	bh=Ak/rAiYCOgEwqXgQA+/n7Y376rVfCuJdQvMln97qd+Q=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AcplhSpNBeaiuNMuBZdbyjDybwPaz2odnULlv8F+HhiCNmOAPoK1rA6/IUEMKEl1tYPED4SIG4LCSd9aSHHcuMJ9TY7jQS3SvlcOj5K/QWjCCeRmD81RDqxxToFW6II1PRsDCMnst7hFUfLLlOhhkz7hGKGLBXmR53HmXeaAxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKcXRiLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKcXRiLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065FC2BCB6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762508544;
	bh=Ak/rAiYCOgEwqXgQA+/n7Y376rVfCuJdQvMln97qd+Q=;
	h=Date:From:To:Subject:From;
	b=hKcXRiLiVXCxr5BYClHPNihNJvBuygNkL1sr/eiJ357Gzj4LUQN46qIiYLd224hwS
	 ggvyYXXV1ZW926R0HQGhV8kj2RfatH8YrhoFwSQe0wLo7eoLIc4RcAm2OpHxNlkFiN
	 nHezlLOIJQCMSSJiIudsjvjACIC1lBYKvMVsnWpUa+Ab4C61VawfJYF5e7OfaqQ/j0
	 fp/EREuD6yvu2NjPf8M4+wtj/CE0u+msDORoHHIABs5wjlXCMbVD3HA2lAY7euWPzd
	 xWVw6Zt/37gtY8kLJprNft4R4+F2gSVFUgkopmLIRSzGAge6cq3c4BDPwVNvwPALe9
	 pQFfjfXeOzSHw==
Date: Fri, 7 Nov 2025 10:42:21 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: generic/648 metadata corruption
Message-ID: <gjureda6lp7phaaum3ffwmcumu5q2zisatei73o6u2mgvohkkk@n2i2bwltxjqu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello, has anybody has found any issues with generic/648 recently?

I've hit it on my test batch this evening, running a 2k block size a
metadata corruption error o generic/648.

I'll rerun the tests now and it later today, sharing it for a broader
audience.

This is running xfs's branch xfs-6.18-fixes.

I don't remember have seen this on my previous runs, but
I'll check the logs just in case.

The fsstress process ended up getting stuck at:

$ sudo cat /proc/2969171/stack 
[<0>] folio_wait_bit_common+0x138/0x340
[<0>] folio_wait_bit+0x1c/0x30
[<0>] folio_wait_writeback+0x2f/0x90
[<0>] __filemap_fdatawait_range+0x8d/0xf0
[<0>] filemap_fdatawait_keep_errors+0x22/0x50
[<0>] sync_inodes_sb+0x22c/0x2d0
[<0>] sync_filesystem+0x70/0xb0
[<0>] __x64_sys_syncfs+0x4e/0xd0
[<0>] x64_sys_call+0x778/0x1da0
[<0>] do_syscall_64+0x7f/0x7b0
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

The kernel log from the last mount.

[ 7467.362544] XFS (loop0): EXPERIMENTAL metadata directory tree feature enabled.  Use at your own risk!
[ 7467.363481] XFS (loop0): Mounting V5 Filesystem 2b40a1e4-f2f6-4a87-8f86-bbfc8a748329
[ 7467.880205] XFS (loop0): Starting recovery (logdev: internal)
[ 7468.006067] XFS (loop0): Ending recovery (logdev: internal)
[ 7470.131605] buffer_io_error: 8 callbacks suppressed
[ 7470.131613] Buffer I/O error on dev dm-1, logical block 243952, async page read
[ 7470.148095] I/O error, dev loop0, sector 10071568 op 0x0:(READ) flags 0x81700 phys_seg 1 prio class 2
[ 7470.148145] dm-0: writeback error on inode 71, offset 239466496, sector 668620
[ 7470.150431] dm-0: writeback error on inode 71, offset 295327744, sector 1291332
[ 7470.152500] dm-0: writeback error on inode 71, offset 239519744, sector 668724
[ 7470.153937] dm-0: writeback error on inode 71, offset 3490498560, sector 103136
[ 7470.154564] dm-0: writeback error on inode 71, offset 295213056, sector 1290512
[ 7470.155123] Buffer I/O error on dev dm-0, logical block 41942912, async page read
[ 7470.155132] Buffer I/O error on dev dm-0, logical block 41942913, async page read
[ 7470.155136] Buffer I/O error on dev dm-0, logical block 41942914, async page read
[ 7470.155139] Buffer I/O error on dev dm-0, logical block 41942915, async page read
[ 7470.155142] Buffer I/O error on dev dm-0, logical block 41942916, async page read
[ 7470.155145] Buffer I/O error on dev dm-0, logical block 41942917, async page read
[ 7470.155148] Buffer I/O error on dev dm-0, logical block 41942918, async page read
[ 7470.155151] Buffer I/O error on dev dm-0, logical block 41942919, async page read
[ 7470.156967] dm-0: writeback error on inode 71, offset 3724138496, sector 1262832
[ 7470.158445] dm-0: writeback error on inode 71, offset 295239680, sector 1301124
[ 7470.158458] dm-0: writeback error on inode 71, offset 1988405248, sector 10605108
[ 7470.167752] dm-0: writeback error on inode 71, offset 3490500608, sector 103140
[ 7470.168539] dm-0: writeback error on inode 71, offset 3768272896, sector 1301296
[ 7470.169439] I/O error, dev loop0, sector 10071568 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
[ 7470.169425] I/O error, dev loop0, sector 6817447 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
[ 7470.170375] XFS (loop0): metadata I/O error in "xfs_btree_read_buf_block+0xb7/0x170 [xfs]" at daddr 0x99ae10 len 4 error 5
[ 7470.172378] XFS (loop0): log I/O error -5
[ 7470.179737] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[ 7470.182399] XFS (dm-0): log I/O error -5
[ 7470.183490] XFS (dm-0): Filesystem has been shut down due to log error (0x2).
[ 7470.185349] XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
[ 7470.187467] I/O error, dev loop0, sector 6817489 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
[ 7470.188787] I/O error, dev loop0, sector 6817489 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
[ 7470.189868] XFS (loop0): log I/O error -5
[ 7470.190717] I/O error, dev loop0, sector 6817617 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
[ 7470.193844] XFS (loop0): log I/O error -5
[ 7470.195987] XFS (loop0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1fe/0x4c0 [xfs] (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
[ 7470.200555] XFS (loop0): Please unmount the filesystem and rectify the problem(s)
[ 7470.201821] XFS (loop0): Metadata corruption detected at xfs_dinode_verify.part.0+0x434/0xcb0 [xfs], inode 0x40d422 xfs_inode_item_precommit_check
[ 7470.206186] XFS (loop0): Unmount and run xfs_repair
[ 7470.207577] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[ 7470.209043] 00000000: 49 4e 81 b6 03 02 00 00 00 00 03 8b 00 00 02 1c  IN..............
[ 7470.210242] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 0d  ................
[ 7470.211633] 00000020: 36 42 da 8b dd 84 5e ec 36 42 da 8b ea d0 f9 2c  6B....^.6B.....,
[ 7470.212668] 00000030: 36 42 da 8b ea d0 f9 2c 00 00 00 00 00 25 b8 00  6B.....,.....%..
[ 7470.213878] 00000040: 00 00 00 00 00 00 03 32 00 00 00 00 00 00 00 00  .......2........
[ 7470.215056] 00000050: 00 00 18 01 00 00 00 00 00 00 00 02 6e b2 b8 ce  ............n...
[ 7470.216375] 00000060: 00 00 00 00 9f bb e2 1f 00 00 00 00 00 00 00 2f  .............../
[ 7470.217157] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a  ................
[ 7470.218462] XFS: Assertion failed: fa == NULL, file: fs/xfs/xfs_inode_item.c, line: 62
[ 7470.219749] ------------[ cut here ]------------
[ 7470.220602] kernel BUG at fs/xfs/xfs_message.c:102!
[ 7470.221232] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[ 7470.221907] CPU: 9 UID: 0 PID: 2967999 Comm: kworker/9:2 Not tainted 6.18.0-rc2.xfsRC5+ #23 PREEMPT(voluntary) 
[ 7470.223443] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
[ 7470.224773] Workqueue: xfs-conv/loop0 xfs_end_io [xfs]
[ 7470.225855] RIP: 0010:assfail+0x35/0x3f [xfs]
[ 7470.226665] Code: 89 d0 41 89 c9 48 c7 c2 98 04 a0 c0 48 89 f1 48 89 fe 48 c7 c7 48 d6 9e c0 48 89 e5 e8 a4 fd ff ff 80 3d b5 62 26 00 00 74 02 <0f> 0b 0f 0b 5d e9 91 1d ba f8 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
[ 7470.228907] RSP: 0018:ffffb2e087bcfc60 EFLAGS: 00010202
[ 7470.229492] RAX: 0000000000000000 RBX: ffff9e399129e400 RCX: 000000007fffffff
[ 7470.230298] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc09ed648
[ 7470.231094] RBP: ffffb2e087bcfc60 R08: 0000000000000000 R09: 000000000000000a
[ 7470.231871] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff9e3988311800
[ 7470.232670] R13: ffff9e399a358000 R14: ffff9e3c05054318 R15: ffff9e3999d0d790
[ 7470.233457] FS:  0000000000000000(0000) GS:ffff9e3d3e65f000(0000) knlGS:0000000000000000
[ 7470.234362] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7470.235002] CR2: 00007f2f373b20d8 CR3: 0000000114904005 CR4: 0000000000772ef0
[ 7470.235805] PKRU: 55555554
[ 7470.236113] Call Trace:
[ 7470.236417]  <TASK>
[ 7470.236688]  xfs_inode_item_precommit+0x1b8/0x370 [xfs]
[ 7470.237601]  __xfs_trans_commit+0xba/0x410 [xfs]
[ 7470.238453]  xfs_trans_commit+0x3b/0x70 [xfs]
[ 7470.239245]  xfs_setfilesize+0xff/0x160 [xfs]
[ 7470.240098]  xfs_end_ioend+0x235/0x2c0 [xfs]
[ 7470.240921]  xfs_end_io+0xba/0xf0 [xfs]
[ 7470.241680]  process_one_work+0x199/0x360
[ 7470.242193]  worker_thread+0x265/0x3a0
[ 7470.242637]  ? _raw_spin_unlock_irqrestore+0x12/0x40
[ 7470.243215]  ? __pfx_worker_thread+0x10/0x10
[ 7470.243737]  kthread+0x10f/0x250
[ 7470.244173]  ? _raw_spin_unlock_irq+0x12/0x30
[ 7470.244747]  ? __pfx_kthread+0x10/0x10
[ 7470.245160]  ret_from_fork+0x1cb/0x200
[ 7470.245617]  ? __pfx_kthread+0x10/0x10
[ 7470.246038]  ret_from_fork_asm+0x1a/0x30
[ 7470.246495]  </TASK>
[ 7470.246744] Modules linked in: dm_zero dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey ip_set nf_tables sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency_common kvm_intel kvm iTCO_wdt intel_pmc_bxt iTCO_vendor_support irqbypass rapl i2c_i801 i2c_smbus lpc_ich virtio_balloon joydev dm_mod loop nfnetlink zram xfs polyval_clmulni ghash_clmulni_intel serio_raw fuse qemu_fw_cfg [last unloaded: scsi_debug]
[ 7470.251529] ---[ end trace 0000000000000000 ]---
[ 7470.252054] RIP: 0010:assfail+0x35/0x3f [xfs]
[ 7470.252842] Code: 89 d0 41 89 c9 48 c7 c2 98 04 a0 c0 48 89 f1 48 89 fe 48 c7 c7 48 d6 9e c0 48 89 e5 e8 a4 fd ff ff 80 3d b5 62 26 00 00 74 02 <0f> 0b 0f 0b 5d e9 91 1d ba f8 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
[ 7470.254883] RSP: 0018:ffffb2e087bcfc60 EFLAGS: 00010202
[ 7470.255472] RAX: 0000000000000000 RBX: ffff9e399129e400 RCX: 000000007fffffff
[ 7470.256377] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc09ed648
[ 7470.257191] RBP: ffffb2e087bcfc60 R08: 0000000000000000 R09: 000000000000000a
[ 7470.258034] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff9e3988311800
[ 7470.258830] R13: ffff9e399a358000 R14: ffff9e3c05054318 R15: ffff9e3999d0d790
[ 7470.259637] FS:  0000000000000000(0000) GS:ffff9e3d3e65f000(0000) knlGS:0000000000000000
[ 7470.260537] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7470.261179] CR2: 00007f2f373b20d8 CR3: 0000000114904005 CR4: 0000000000772ef0
[ 7470.261963] PKRU: 55555554

