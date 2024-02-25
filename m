Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B947A10979
	for <linux-xfs@vger.kernel.org>; Sun, 25 Feb 2024 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708865627; cv=none; b=cwf9272eB9F49g0BM37KbD4pqq74OfcnNaHKi6FTEAEe9M+ynxKfSd98vfE3tUsMUQnIXDas3xHktNLMdCzDcVxLf04dd64ZDyL4yHc6xX56Xcf50IoJmN49Cj6ckmSQwdKUsNrE8bfWIfyQEjqpaa/afI9ZMNVH0pSeVw/f/Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708865627; c=relaxed/simple;
	bh=5Y6btHFFh5XDVVslLAjjB5lCJ+nuCvnr/UqJtG1SAr0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=M0f0Ds/DSu9z+/YBDJZOqNYxz2JgIRtTln12XhQciWQgensF8SyAvmr73AfEUhYWln9Jz27x8cUIfkJZsCkn8nT80p5SXlerQZ6IXdFRYs1gJ0QpS/AtnJ5LokP0Izo1BnaLDnHT2sFraXBtMNLlAAg0Nvvuyw2MwefRHwyUPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYPEQuIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYPEQuIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E4BC43390;
	Sun, 25 Feb 2024 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708865627;
	bh=5Y6btHFFh5XDVVslLAjjB5lCJ+nuCvnr/UqJtG1SAr0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=hYPEQuIMSLtIlgvhhDO3L0r/2UI5BB3aGYtI49G/GAd9J8gA64zc4051PU9AhCAFb
	 QqdbcV8YxHbziLEwDasZfLGM9+5gRMkzGMYdhxZX8oxzIF2+8ABFlNDqRPsTT0Z2Kx
	 7T4Xl++QSze3CohwKoVE6o7l4nh8CVGUkOKEYyMVJsM3MT50ZZw8uKwasPbAWDU38A
	 2GnSngALtl870QglbTvadKpI+dRF/DXXXwSkInKioJ3w2Lcif97XROtyncA71TB5CF
	 zUvBs4OqzCFYMd6OieqgI/hrtHqVTi5OxexYktcC9PFjOwFCdeA8xtlYpgbRcmfPiV
	 snj5vrPXOYDxg==
References: <20240224010220.GN6226@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanrlinux@gmail.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PRBOMB] xfs: online repair patches for 6.9
Date: Sun, 25 Feb 2024 18:21:19 +0530
In-reply-to: <20240224010220.GN6226@frogsfrogsfrogs>
Message-ID: <878r387lif.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Feb 23, 2024 at 05:02:20 PM -0800, Darrick J. Wong wrote:
> Hi Chandan,
>
> Please pull these multiple pull requests containing all the online
> repair functionality that Christoph and I managed to get reviewed in
> time for 6.9.
>
> --D
>
> PS: Has anyone out there observed the following crash on arm64?
>
> run fstests xfs/570 at 2024-02-22 20:32:17
> spectre-v4 mitigation disabled by command-line option
> XFS (sda2): Mounting V5 Filesystem 2fd78ebc-692d-46e1-bd8a-9f1591c007f6
> XFS (sda2): Ending clean mount
> XFS (sda2): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> XFS (sda3): Mounting V5 Filesystem ac0b0a07-294f-418e-b4d0-c14cc345fcd4
> XFS (sda3): Ending clean mount
> XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> Unable to handle kernel paging request at virtual address ffffffff80206388
> Mem abort info:
>   ESR = 0x0000000096000006
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
>   FSC = 0x06: level 2 translation fault
> Data abort info:
>   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
>   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> swapper pgtable: 64k pages, 42-bit VAs, pgdp=0000000040d40000
> [ffffffff80206388] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000, pmd=0000000000000000
> Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in: xfs rpcsec_gss_krb5 auth_rpcgss nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defra
> sch_fq_codel fuse configfs efivarfs ip_tables x_tables overlay nfsv4
> CPU: 0 PID: 38 Comm: 0:1H Not tainted 6.8.0-rc4-djwa #rc4 892edfc98307d2cdb226d4164dfd6775c2b3b52c
> Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> Workqueue: xfs-log/sda3 xlog_ioend_work [xfs]
> pstate: a0401005 (NzCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> pc : kfree+0x54/0x2d8
> lr : xlog_cil_committed+0x11c/0x1d8 [xfs]
> sp : fffffe00830cfbe0
> x29: fffffe00830cfbe0 x28: fffffc00240e0c80 x27: fffffc00240e0c00
> x26: 00000005000037a8 x25: 0000000000000000 x24: 0000000000000000
> x23: fffffc0021e68d40 x22: fffffe00818e0000 x21: fffffc0021e68d88
> x20: fffffe007a6b93cc x19: ffffffff80206380 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: fffffe008840f620
> x14: 0000000000000000 x13: 0000000000000020 x12: 0101010101010101
> x11: 0000000000000040 x10: fffffc0025b0d5d8 x9 : fffffe007a6b93cc
> x8 : fffffe00830cfbe0 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : d230261c49c51c03 x4 : fffffc00e1357340 x3 : dead000000000122
> x2 : fffffc00ea7fa000 x1 : fffffc0021e68d88 x0 : ffffffff00000000
> Call trace:
>  kfree+0x54/0x2d8
>  xlog_cil_committed+0x11c/0x1d8 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
>  xlog_cil_process_committed+0x6c/0xa8 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
>  xlog_state_do_callback+0x1e0/0x3e0 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
>  xlog_state_done_syncing+0x8c/0x158 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
>  xlog_ioend_work+0x70/0xd8 [xfs 6eb07a1ebfe13a228ea62c550c04c138eaa0de6a]
>  process_one_work+0x174/0x3e8
>  worker_thread+0x2c4/0x3e8
>  kthread+0x110/0x128
>  ret_from_fork+0x10/0x20
> Code: 8b1302d3 b2607fe0 d350fe73 8b131813 (f9400660) 
> ---[ end trace 0000000000000000 ]---

I just now noticed that generic/019 has failed with the same call trace as
above on an x86_64 machine. I will try to root cause the problem.

-- 
Chandan
