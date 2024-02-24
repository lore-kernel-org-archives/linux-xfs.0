Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C897138A
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708736541; cv=none; b=SW7AOmoX/ECTCULPq7vj17TV7nmazYczwdUQSTMVnJD0fK0jbEHGvfnXC1eMk6HttVbFXO3ALB2MAkjzI0qJvFSvhChg6yMrdixncTJVicL0l2iV3xLITGcWR8gH1PEjHePZlR6W2+Q+bSwat6crc6Q2QcvOtz4Nb7KBopDefhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708736541; c=relaxed/simple;
	bh=Y+2So/cxC+2bmFuQp38/Hhrpm7Emidc4vsEtH05ilCM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dxDdZ3wIAolS6zLSd6xD84zDjILgKRAiKS3CrFQSGw+VcqiYt+hZCPNu+sPSIbO8uZSiQSOEkIrz+FZ70CaAdaqYUtcruwih8fnWcFCSMagfXdKfy4Fy0sD78h6T9aUdIPuiBdsNUF00PamHJB/ibzoWUjqL66sUzdcWSLURwbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2ELRvso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2ELRvso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1496C433F1;
	Sat, 24 Feb 2024 01:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708736540;
	bh=Y+2So/cxC+2bmFuQp38/Hhrpm7Emidc4vsEtH05ilCM=;
	h=Date:From:To:Cc:Subject:From;
	b=a2ELRvsodgXOidxOcI7Si/YkVyO4dfS2RxMrfzufHl88Y3uFUChtzYhmw96qfTT6J
	 hsKm2BM6x4ZJVuuOOX0Pcu0O1JEg6MvWhROlTWxopGKmejS25Cgw3CcHRUt5HLe/gn
	 1KuW3i3G88U46IPAP7gzN8sn9Yayq+HnJgmV23ZLLCQN9Pk++cRI8XYGo0GjpwMept
	 sQo8KUJ4SitTa16g7vbkHAVmbcBmZjR5JWNzfAJydZS0eQJfA+xycARPS/T8jca0bC
	 W/I28xqdXvLqCWuLV2skvx0DVwuBwB9udnj9fIoKAej40ZF60woZhUkvbLFpNHFRSb
	 9ZBvCzM7MFhug==
Date: Fri, 23 Feb 2024 17:02:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanrlinux@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PRBOMB] xfs: online repair patches for 6.9
Message-ID: <20240224010220.GN6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Chandan,

Please pull these multiple pull requests containing all the online
repair functionality that Christoph and I managed to get reviewed in
time for 6.9.

--D

PS: Has anyone out there observed the following crash on arm64?

run fstests xfs/570 at 2024-02-22 20:32:17
spectre-v4 mitigation disabled by command-line option
XFS (sda2): Mounting V5 Filesystem 2fd78ebc-692d-46e1-bd8a-9f1591c007f6
XFS (sda2): Ending clean mount
XFS (sda2): EXPERIMENTAL online scrub feature in use. Use at your own risk!
XFS (sda3): Mounting V5 Filesystem ac0b0a07-294f-418e-b4d0-c14cc345fcd4
XFS (sda3): Ending clean mount
XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at your own risk!
Unable to handle kernel paging request at virtual address ffffffff80206388
Mem abort info:
  ESR = 0x0000000096000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 64k pages, 42-bit VAs, pgdp=0000000040d40000
[ffffffff80206388] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: xfs rpcsec_gss_krb5 auth_rpcgss nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defra
sch_fq_codel fuse configfs efivarfs ip_tables x_tables overlay nfsv4
CPU: 0 PID: 38 Comm: 0:1H Not tainted 6.8.0-rc4-djwa #rc4 892edfc98307d2cdb226d4164dfd6775c2b3b52c
Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
Workqueue: xfs-log/sda3 xlog_ioend_work [xfs]
pstate: a0401005 (NzCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : kfree+0x54/0x2d8
lr : xlog_cil_committed+0x11c/0x1d8 [xfs]
sp : fffffe00830cfbe0
x29: fffffe00830cfbe0 x28: fffffc00240e0c80 x27: fffffc00240e0c00
x26: 00000005000037a8 x25: 0000000000000000 x24: 0000000000000000
x23: fffffc0021e68d40 x22: fffffe00818e0000 x21: fffffc0021e68d88
x20: fffffe007a6b93cc x19: ffffffff80206380 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: fffffe008840f620
x14: 0000000000000000 x13: 0000000000000020 x12: 0101010101010101
x11: 0000000000000040 x10: fffffc0025b0d5d8 x9 : fffffe007a6b93cc
x8 : fffffe00830cfbe0 x7 : 0000000000000000 x6 : 0000000000000000
x5 : d230261c49c51c03 x4 : fffffc00e1357340 x3 : dead000000000122
x2 : fffffc00ea7fa000 x1 : fffffc0021e68d88 x0 : ffffffff00000000
Call trace:
 kfree+0x54/0x2d8
 xlog_cil_committed+0x11c/0x1d8 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
 xlog_cil_process_committed+0x6c/0xa8 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
 xlog_state_do_callback+0x1e0/0x3e0 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
 xlog_state_done_syncing+0x8c/0x158 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
 xlog_ioend_work+0x70/0xd8 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
 process_one_work+0x174/0x3e8
 worker_thread+0x2c4/0x3e8
 kthread+0x110/0x128
 ret_from_fork+0x10/0x20
Code: 8b1302d3 b2607fe0 d350fe73 8b131813 (f9400660) 
---[ end trace 0000000000000000 ]---

