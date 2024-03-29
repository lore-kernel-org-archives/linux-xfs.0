Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687C44B5DA;
	Fri, 29 Mar 2024 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711754288; cv=none; b=iFw3LsHS8s/CK82AP0/Z5eMLScaiNgNNTIxMMoTDwdpbDSj2t8Po1Fu3S7sJ0AlEF+piLnrkpAFKK2VSdtBx6q3+1GoICIWT+WKfserL9BIb2vcLl2/u76SAwOHcsk5xqmEEH76pr+wEwg9jxyIVn0ReyRGXJHNERYH0VIPCNHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711754288; c=relaxed/simple;
	bh=C+fFnjSigcSgH/JTgs80wimEZcmJxmcoTAdhHACyp3g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QIB/k5vAXPn/hJ/cl/TCoY5+xwbc2U1oc0HH4r/Ov08FHj2Sy38UkHw5+Z0bafgHuDDoizL+7eBKBJO5QMORpC2dxRZgpY5PL3EW2hMyJURoQCRTadQ1NWRrwALvxZlJMELnBlV0VHaJWGxqCb87nF5i/09Kw9Yg/7qJnYU2vAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+TRxJ92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+TRxJ92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD111C433F1;
	Fri, 29 Mar 2024 23:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711754287;
	bh=C+fFnjSigcSgH/JTgs80wimEZcmJxmcoTAdhHACyp3g=;
	h=Date:From:To:Cc:Subject:From;
	b=n+TRxJ92z9wl7odld3HVeUk/psw5byQTyPi03RtDV3m5HKyxmafJB7l4CbCVs8psf
	 RrYiSLmgSwaslLV6Zw9XbNHNz5Pat94Iw1jn73avqE9AomsD94WVwUJlLAf8OfkxHb
	 j3cq5nHtl0fr8XDrSLxCkrcxiQz6Oaf9ApVQXukjBLxKzH8oMCcGmmAYl4BVKNJo3r
	 z8rxK1t6FEe/ka2whs8IaEZY0ZzHFC6hhzvSjrSrUWeeR5AxLLM3bakZ5tR6hsxPnD
	 W5Y5wuOmh0D8mOnRcPKskJps42YVTHPW/I2pMnL5C/Hk+5ctXJss+BJl7DqNXXJ2dT
	 FVL2Lxas+yx+A==
Date: Fri, 29 Mar 2024 16:18:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Subject: asserts triggered on 6.9-rc1?
Message-ID: <20240329231807.GS6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hrmm.  Has anyone else seen a crash like this on 6.9-rc1?  Particularly
with arm64?  I know Chandan was reporting that something in this week's
for-next branches have been causing different problems.

<shrug> /me runs away for the weekend

run fstests xfs/559 at 2024-03-28 19:41:51
spectre-v4 mitigation disabled by command-line option
XFS (sda2): Mounting V5 Filesystem e9713a0b-c124-47b0-a1dd-b45dded16592
XFS (sda2): Ending clean mount
XFS (sda3): Mounting V5 Filesystem 3eb29dfb-da2b-4f90-82f2-1f1b12fac345
XFS (sda3): Ending clean mount
XFS (sda3): Quotacheck needed: Please wait.
XFS (sda3): Quotacheck: Done.
XFS (sda3): Unmounting Filesystem 3eb29dfb-da2b-4f90-82f2-1f1b12fac345
XFS (sda3): Mounting V5 Filesystem 3eb29dfb-da2b-4f90-82f2-1f1b12fac345
XFS (sda3): Ending clean mount
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
page: refcount:3 mapcount:0 mapping:fffffc018fc5b718 index:0x3001 pfn:0x8001
memcg:fffffc00f23c1000
aops:xfs_address_space_operations [xfs] ino:107
flags: 0xfff600000008029(locked|uptodate|lru|private|node=0|zone=0|lastcpupid=0xfff)
page_type: 0xffffffff()
raw: 0fff600000008029 ffffffff40100088 ffffffff40100008 fffffc018fc5b718
raw: 0000000000003001 fffffc0108404d40 00000003ffffffff fffffc00f23c1000
page dumped because: VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index))
------------[ cut here ]------------
kernel BUG at mm/filemap.c:2078!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: dm_delay dm_flakey xfs nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rpcs
use efivarfs ip_tables x_tables overlay nfsv4 [last unloaded: scsi_debug]
CPU: 0 PID: 3949199 Comm: umount Tainted: G        W          6.9.0-rc1-djwa #rc1 016eb5755235bfdc60adce068d3fc4d2a3c06376
Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : find_lock_entries+0x478/0x518
lr : find_lock_entries+0x478/0x518
sp : fffffe00893cf9f0
x29: fffffe00893cf9f0 x28: 0000000000000006 x27: fffffc018f6d7fc0
x26: fffffc018fc5b718 x25: fffffe00893cfb10 x24: 0000000000000003
x23: fffffe00893cfb08 x22: fffffe00893cfb88 x21: fffffffffffffffe
x20: ffffffff40100040 x19: ffffffffffffffff x18: 0000000000000000
x17: 2e736178202c6f69 x16: 6c6f6628736e6961 x15: 746e6f635f6f696c
x14: 6f6621284f494c4f x13: 29297865646e695f x12: 61782e736178202c
x11: 6f696c6f6628736e x10: 6961746e6f635f6f x9 : fffffe00800e26c4
x8 : fffffe00893cf6f0 x7 : 0000000000000000 x6 : fffffe00814639a8
x5 : 00000000000017d0 x4 : 0000000000000002 x3 : 0000000000000000
x2 : 0000000000000000 x1 : fffffc00e65421c0 x0 : 000000000000004a
Call trace:
 find_lock_entries+0x478/0x518
 truncate_inode_pages_range+0xc8/0x650
 truncate_inode_pages_final+0x58/0x90
 evict+0x188/0x1a8
 dispose_list+0x6c/0xa8
 evict_inodes+0x138/0x1b0
 generic_shutdown_super+0x4c/0x100
 kill_block_super+0x24/0x50
 xfs_kill_sb+0x20/0x40 [xfs 6fb2b419729f76f7aa4b144d75af2e13a7e35081]
 deactivate_locked_super+0x58/0x140
 deactivate_super+0x8c/0xb0
 cleanup_mnt+0xa4/0x140
 __cleanup_mnt+0x1c/0x30
 task_work_run+0x88/0xf8
 do_notify_resume+0x114/0x138
 el0_svc+0x180/0x218
 el0t_64_sync_handler+0x100/0x130
 el0t_64_sync+0x190/0x198
Code: aa1403e0 f00053a1 910c8021 94015f6f (d4210000) 
---[ end trace 0000000000000000 ]---

Or on my dev tree:

run fstests xfs/559 at 2024-03-28 20:52:41
spectre-v4 mitigation disabled by command-line option
XFS (sda2): EXPERIMENTAL metadata directory feature in use. Use at your own risk!
XFS (sda2): EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!
XFS (sda2): EXPERIMENTAL parent pointer feature enabled. Use at your own risk!
XFS (sda2): EXPERIMENTAL fsverity feature in use. Use at your own risk!
XFS (sda2): Mounting V5 Filesystem c9424439-7289-4703-bf73-d66814432ac7
XFS (sda2): Ending clean mount
XFS (sda3): EXPERIMENTAL metadata directory feature in use. Use at your own risk!
XFS (sda3): EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!
XFS (sda3): EXPERIMENTAL parent pointer feature enabled. Use at your own risk!
XFS (sda3): EXPERIMENTAL fsverity feature in use. Use at your own risk!
XFS (sda3): Mounting V5 Filesystem 5882e817-a05b-417c-9e8f-3a4f7b019fb0
XFS (sda3): Ending clean mount
XFS (sda3): Quotacheck needed: Please wait.
XFS (sda3): Quotacheck: Done.
XFS (sda3): Unmounting Filesystem 5882e817-a05b-417c-9e8f-3a4f7b019fb0
XFS (sda3): EXPERIMENTAL metadata directory feature in use. Use at your own risk!
XFS (sda3): EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!
XFS (sda3): EXPERIMENTAL parent pointer feature enabled. Use at your own risk!
XFS (sda3): EXPERIMENTAL fsverity feature in use. Use at your own risk!
XFS (sda3): Mounting V5 Filesystem 5882e817-a05b-417c-9e8f-3a4f7b019fb0
XFS (sda3): Ending clean mount
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
------------[ cut here ]------------
kernel BUG at fs/inode.c:614!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: ext2 xfs thread_with_file time_stats dm_thin_pool dm_persistent_data dm_
 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_
CPU: 1 PID: 2180105 Comm: umount Tainted: G        W          6.9.0-rc1-xfsa #rc1 4137f913a
Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
pstate: a04010c5 (NzCv daIF +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : clear_inode+0x80/0xa0
lr : clear_inode+0x28/0xa0
sp : fffffe0085c6fc10
x29: fffffe0085c6fc10 x28: fffffc00eb8a0000 x27: fffffc00ce7aa2b0
x26: fffffe0085c6fcf8 x25: fffffc01861dee40 x24: fffffc01861de800
x23: fffffc00eb8a0000 x22: fffffe007b3c9358 x21: fffffc00ce7aa378
x20: fffffc00ce7aa328 x19: fffffc00ce7aa178 x18: 0000000000000014
x17: 0a01000000000000 x16: fffffc00e49edae8 x15: 0000000000000040
x14: 0000000000000000 x13: 0000000000000020 x12: 0101010101010101
x11: 7f7f7f7f7f7f7f7f x10: 0000000000000000 x9 : fffffe00809c9320
x8 : fffffe0085c6fa60 x7 : 0000000000000000 x6 : fffffe0085c6fa60
x5 : 0000000000000000 x4 : fffffe0085c6fb58 x3 : 0000000000000000
x2 : fffffe017e700000 x1 : fffffe017e700000 x0 : 0000000000003f00
Call trace:
 clear_inode+0x80/0xa0
 evict+0x190/0x1a8
 dispose_list+0x6c/0xa8
 evict_inodes+0x138/0x1b0
 generic_shutdown_super+0x4c/0x110
 kill_block_super+0x24/0x50
 xfs_kill_sb+0x20/0x40 [xfs b096c248217f70a3dcd07b920f66f8452d01eb1f]
 deactivate_locked_super+0x58/0x140
 deactivate_super+0x8c/0xb0
 cleanup_mnt+0xa4/0x140
 __cleanup_mnt+0x1c/0x30
 task_work_run+0x88/0xf8
 do_notify_resume+0x114/0x138
 el0_svc+0x180/0x1f0
 el0t_64_sync_handler+0x100/0x130
 el0t_64_sync+0x190/0x198
Code: a94153f3 a8c27bfd d50323bf d65f03c0 (d4210000) 
---[ end trace 0000000000000000 ]---
note: umount[2180105] exited with irqs disabled
note: umount[2180105] exited with preempt_count 2
------------[ cut here ]------------

--D
