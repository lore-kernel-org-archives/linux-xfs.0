Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E96229B30;
	Mon, 17 Feb 2025 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739813398; cv=none; b=JieAAfIvLkdNzlOkyST126ER+xlHkC2w7AHHanT/BfUv/svbHtzpc7G6bRCoP63F5nZjNyfaeO2EctmKZhzWDoo7LYqEsenHxVrgaeqox5+qpHlCLD6zls3KMdTS6kMhN87QmxCfZ1JvMCtgzgKH2KMXQGo2NmTF+8Jo/2/UNoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739813398; c=relaxed/simple;
	bh=ENc2XqVvYlCGkGRqVkpA8jhlZmEYwp5yvr2cmI2EhcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSMFsCjt72ZteJxsGnb8kHTNfHkdwbqficM/YnB2UvjYQrZB4fSGZ4DjoHzbIsj03/dZ1MnF1wasaO9QRNBe6gwTOt+3BroHvB2hmvDt6GueOSIFx13fyEGOxtZj/t4ECcV1bF6wz8pl4Vr1uMbr1fdr+WghCDgInJx3UM6dRVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Csiw52hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Csiw52hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A49C4CEE4;
	Mon, 17 Feb 2025 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739813397;
	bh=ENc2XqVvYlCGkGRqVkpA8jhlZmEYwp5yvr2cmI2EhcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Csiw52hR0xI8lT/OKTWo8OJ2EZXA6SdTcH5cAgDRWPJ5sMfa8h2adh1bzEkosfttB
	 CF2dkwo4vupGdy8AO/p/RjibMOVdhheo3fCigoZIkAYFR5bk4ETZozo9LpLLUBldAj
	 L8bK/YccMLl9cpPdA0GsO0P6zGO6x8AxCRK2sH/1+yvtx70NyD50TP2iQIx3O2yC3a
	 ER3/z/ZJ72wQd03D8ZSVJBpBdDFk5QnG8VYtcq6NspShMy+iWigwDZSZprFZDfwer5
	 C2Acv2BHHUkIdAs6Ny+svA3LDQg4+1kO3JHNeZJZ5nwVAf679bNBfjHd4QU3MDJgWY
	 GQ7c+LAIAVmVw==
Date: Mon, 17 Feb 2025 09:29:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lorenz Brun <lorenz@monogon.tech>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [REGRESSION] xfs kernel panic
Message-ID: <20250217172957.GB21808@frogsfrogsfrogs>
References: <CAJMi0nTHX0inFxme=xnJf23c8=w0bAf7LfiT=YNpmU-zVnUR+Q@mail.gmail.com>
 <CAJMi0nTbyi6VGTmmZ43wYWwJWur0XPtuswZ_5UaXB+S6Z=Mo6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJMi0nTbyi6VGTmmZ43wYWwJWur0XPtuswZ_5UaXB+S6Z=Mo6A@mail.gmail.com>

On Mon, Feb 17, 2025 at 05:27:33PM +0100, Lorenz Brun wrote:
> Am Mo., 17. Feb. 2025 um 16:00 Uhr schrieb Lorenz Brun <lorenz@monogon.tech>:
> >
> > Hi everyone,
> >
> > Linux 6.12.14 (released today) contains a regression for XFS, causing
> > a kernel panic after just a few seconds of working with a
> > freshly-created (xfsprogs 6.9) XFS filesystem. I have not yet bisected
> > this because I wanted to get this report out ASAP but I'm going to do
> > that now. There are multiple associated stack traces, but all of them
> > have xfs_buf_offset as the faulting function.
> >
> > Example backtrace:
> > [   31.745932] BUG: kernel NULL pointer dereference, address: 0000000000000098
> > [   31.746590] #PF: supervisor read access in kernel mode
> > [   31.747072] #PF: error_code(0x0000) - not-present page
> > [   31.747537] PGD 5bee067 P4D 5bee067 PUD 5bef067 PMD 0
> > [   31.748016] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> > [   31.748459] CPU: 0 UID: 0 PID: 116 Comm: xfsaild/vda4 Not tainted
> > 6.12.14-metropolis #1 9b2470be3d7713b818a3236e4a2804dd9cbef735
> > [   31.749490] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> > BIOS 0.0.0 02/06/2015
> > [   31.750340] RIP: 0010:xfs_buf_offset+0x9/0x50
> > [   31.750823] Code: 08 5b e9 8a 2c c4 00 66 2e 0f 1f 84 00 00 00 00
> > 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f
> > 44 00 00 <48> 8b 87 98 00 00 00 48 85 c0 75 2e 48 8b 87 00 01 00 00 48
> > 89 f2
> > [   31.752775] RSP: 0018:ffffbf50c07abdb8 EFLAGS: 00010246
> > [   31.753343] RAX: 0000000000000002 RBX: ffff9c0985817d58 RCX: 0000000000000016
> > [   31.754103] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > [   31.754734] RBP: 0000000000000000 R08: ffff9c09fb704000 R09: 00000000e0be9fc4
> > [   31.755396] R10: 0000000000000000 R11: ffff9c0985827df8 R12: ffff9c09fb57ff58
> > [   31.756078] R13: ffff9c0985817eb0 R14: ffff9c09fb704000 R15: ffff9c0985817f00
> > [   31.756764] FS:  0000000000000000(0000) GS:ffff9c09fc000000(0000)
> > knlGS:0000000000000000
> > [   31.757529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   31.758041] CR2: 0000000000000098 CR3: 0000000005b70000 CR4: 0000000000350ef0
> > [   31.758696] Call Trace:
> > [   31.758940]  <TASK>
> > [   31.759172]  ? __die+0x56/0x97
> > [   31.759473]  ? page_fault_oops+0x15c/0x2d0
> > [   31.759853]  ? exc_page_fault+0x4c5/0x790
> > [   31.760237]  ? asm_exc_page_fault+0x26/0x30
> > [   31.760637]  ? xfs_buf_offset+0x9/0x50
> > [   31.761002]  ? srso_return_thunk+0x5/0x5f
> > [   31.761409]  xfs_qm_dqflush+0xd0/0x350
> > [   31.761799]  xfs_qm_dquot_logitem_push+0xe9/0x140
> > [   31.762253]  xfsaild+0x347/0xa10
> > [   31.762567]  ? srso_return_thunk+0x5/0x5f
> > [   31.762952]  ? srso_return_thunk+0x5/0x5f
> > [   31.763325]  ? __pfx_xfsaild+0x10/0x10
> > [   31.763665]  kthread+0xd2/0x100
> > [   31.763985]  ? __pfx_kthread+0x10/0x10
> > [   31.764342]  ret_from_fork+0x34/0x50
> > [   31.764675]  ? __pfx_kthread+0x10/0x10
> > [   31.765029]  ret_from_fork_asm+0x1a/0x30
> > [   31.765408]  </TASK>
> > [   31.765618] Modules linked in: kvm_amd
> > [   31.765978] CR2: 0000000000000098
> > [   31.766297] ---[ end trace 0000000000000000 ]---
> > [   32.371004] RIP: 0010:xfs_buf_offset+0x9/0x50
> > [   32.371453] Code: 08 5b e9 8a 2c c4 00 66 2e 0f 1f 84 00 00 00 00
> > 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f
> > 44 00 00 <48> 8b 87 98 00 00 00 48 85 c0 75 2e 48 8b 87 00 01 00 00 48
> > 89 f2
> > [   32.373133] RSP: 0018:ffffbf50c07abdb8 EFLAGS: 00010246
> > [   32.373611] RAX: 0000000000000002 RBX: ffff9c0985817d58 RCX: 0000000000000016
> > [   32.374275] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > [   32.374921] RBP: 0000000000000000 R08: ffff9c09fb704000 R09: 00000000e0be9fc4
> > [   32.375720] R10: 0000000000000000 R11: ffff9c0985827df8 R12: ffff9c09fb57ff58
> > [   32.376376] R13: ffff9c0985817eb0 R14: ffff9c09fb704000 R15: ffff9c0985817f00
> > [   32.377027] FS:  0000000000000000(0000) GS:ffff9c09fc000000(0000)
> > knlGS:0000000000000000
> > [   32.377761] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   32.378292] CR2: 0000000000000098 CR3: 0000000005b70000 CR4: 0000000000350ef0
> > [   32.378940] Kernel panic - not syncing: Fatal exception
> > [   32.379492] Kernel Offset: 0x2a600000 from 0xffffffff81000000
> > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> >
> > #regzbot introduced: v6.12.13..v6.12.14
> >
> > Regards,
> > Lorenz
> 
> Hi everyone,
> 
> I root-caused this to 5808d420 ("xfs: attach dquot buffer to dquot log
> item buffer"), but needs reverting of the 3 follow-up commits
> (d331fc15, ee6984a2 and 84307caf) as well as they depend on the broken
> one. With that 6.12.14 passes our test suite again. Reproduction
> should be rather easy by just creating a fresh filesystem, mounting
> with "prjquota" and performing I/O.

Known bug, will patch soon.

--D

> Regards,
> Lorenz
> 
