Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17017545
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717109953; cv=none; b=BV41fhvLY4MvvAPjDgr5Akhb5ZEwj0LcDUDgbw8ulQt24dKdnA7EBmkYMdXUtvGPNRcIM0TAI3GWK9bzNqbTOWAf0EK//X+GQzoVoVv38gr/T9xSNDl6tdMedb5gnt8+3Ec88vpx2lnaFkMHsjNoJStj429W8h0nucZjHzuBMo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717109953; c=relaxed/simple;
	bh=85mXCTCD9LWSB8AODQI5z8bLV2WDNhH0YIKv+4gc030=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fQYoeVoWvy173qWFWhuTqpcPL/W8fvC8a5WPk/kpisQV+B7ctDyKSZYNmQbxDBtROqJrD7OsqfRlCXjGgiTmZQPDUtf+7aRj0Yl+Eo1NdfuWWuJpAhoGZJjP8kHrYQtz/cASxAIKQ5HuuEoms1kKNQzwaE085cMpbxzoor0S5G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQ+hTvca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQ+hTvca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34780C2BBFC;
	Thu, 30 May 2024 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717109953;
	bh=85mXCTCD9LWSB8AODQI5z8bLV2WDNhH0YIKv+4gc030=;
	h=Date:From:To:Cc:Subject:From;
	b=WQ+hTvcaH372lOhcf7UVJBGY9P/6sRV5L7PHS7mraOTfre+K0ZejcLxq0qHwjLQSV
	 BBd6RwFB4A97JEBlS8WqXHifys2hk6yo7u0d04W1gmxL/xJhkMDRZ12seB7J1NVxu0
	 GKlOL9SGybmDRZ0zMRkxx6ocDPU4hAJirIV1P02KHSfrrXf4sGp3pLxxvcAKtUsPl5
	 3ZO4OuH/dtRtC3MvS5zy3wkIqmnIdoNL9TXNailA4oZQV1QJCzHlFJe9Y10S6JKLki
	 61AC4Nn5+v01n3kIwABVYTovnqbIWpROlAm1JkoF1kfYmV+LCuNxBVDN9pNXLIuizM
	 vbE/k2pWllmwA==
Date: Thu, 30 May 2024 15:59:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: weird splats in xfs/561 on 6.10-rc1?
Message-ID: <20240530225912.GC52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

I noticed the following assert triggering on xfs/561 after about 8
minutes of operation on a 64k-page arm64 vm with a rtgroups filesystem:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/aarch64 oci-mtra46 6.10.0-rc1-xfsa #rc1 SMP PREEMPT Wed May 29 11:26:10 PDT 2024
MKFS_OPTIONS  -- -f -rrtdev=/dev/sdb4 -i verity=1,exchange=1, -d rtinherit=1, -n parent=1, -r rtgroups=1, /dev/sda3
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, -ortdev=/dev/sdb4 /dev/sda3 /opt

XFS (sda3): ino 414aa33 data fork has delalloc extent at [0x16a:0x6]
XFS: Assertion failed: 0, file: fs/xfs/xfs_icache.c, line: 1853
------------[ cut here ]------------
WARNING: CPU: 0 PID: 44 at fs/xfs/xfs_message.c:104 assfail+0x48/0x68 [xfs]
Modules linked in: xfs rpcsec_gss_krb5 auth_rpcgss nft_chain_nat xt_REDIRECT nf_nat nf_
CPU: 0 PID: 44 Comm: kswapd0 Tainted: G        W          6.10.0-rc1-xfsa #rc1 1ccdfe2f
Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : assfail+0x48/0x68 [xfs]
lr : assfail+0x3c/0x68 [xfs]
sp : fffffe0081fef7b0
x29: fffffe0081fef7b0 x28: fffffe0081fefab8 x27: 000000000000f35c
x26: 0000000000000005 x25: 00000000000003fb x24: 0000000000000000
x23: fffffc013f518000 x22: fffffe007a40ebe4 x21: fffffe0080f30008
x20: fffffe0081289458 x19: fffffc00e5f25f00 x18: 0000000000000006
x17: 3a61363178305b20 x16: 746120746e657478 x15: fffffe0081fef1a0
x14: 0000000000000000 x13: 33353831203a656e x12: fffffe0081fef6e0
x11: fffffe007a644790 x10: fffffe00fa64478f x9 : 0fffffffffffffff
x8 : 000000000000000a x7 : 00000000ffffffc0 x6 : 0000000000000021
x5 : fffffe007a644791 x4 : 00000000ffffffca x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 assfail+0x48/0x68 [xfs 33c3f304945dadccc25d02a0520df74527538fda]
 xfs_inodegc_set_reclaimable+0x164/0x180 [xfs 33c3f304945dadccc25d02a0520df74527538fda]
 xfs_inode_mark_reclaimable+0xd0/0x460 [xfs 33c3f304945dadccc25d02a0520df74527538fda]
 xfs_fs_destroy_inode+0xf4/0x1b8 [xfs 33c3f304945dadccc25d02a0520df74527538fda]
 destroy_inode+0x48/0x88
 evict+0x158/0x1a8
 dispose_list+0x6c/0xa8
 prune_icache_sb+0x64/0xa0
 super_cache_scan+0x148/0x1a8
 do_shrink_slab+0x14c/0x470
 shrink_slab+0x304/0x528
 shrink_one+0xa8/0x240
 shrink_node+0xb18/0xe50
 balance_pgdat+0x398/0x8b0
 kswapd+0x244/0x518
 kthread+0x110/0x128
 ret_from_fork+0x10/0x20
---[ end trace 0000000000000000 ]---
Direct I/O collision with buffered writes! File: d32/d36/d5a/f54 Comm: fsstress
Direct I/O collision with buffered writes! File: /rt/p3/f25 Comm: fsstress

From what I can tell, this wasn't happening with my 6.9 djwong-dev
branch, so I suspect it's something that came in from when I rebased
against 6.10-rc1.  It seems to happen all over the place (and not just
with realtime files) if I leave Zhang Yi's iomap patches applied.  If I
revert them, the screaming seems to go down to just this one test.

The file itself is ~1482KB, or enough for the file to have 0x169 actual
blocks of written data to it, so the delalloc reservation is beyond the
eof block.  Any thoughts?

--D
