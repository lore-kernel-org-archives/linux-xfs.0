Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AD92641F9
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752680293; cv=none; b=SpABDkvTK/1C9EbGKdKCDxW50v+cGVtfW24RMYRz95kiOf1V0F5VEF6foCxdhH6ALtIkknbPjq/X0XDwJSCv/CHdG+GTuDnhqaym7k+NwQYQ+o/xEGvBLCI6VFjqoMkgRE1fmhycWNo5n1l8iODzw5uX+wQ39XTCpMH9GQQtzL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752680293; c=relaxed/simple;
	bh=rdr4NKTxH/9RggyqCNUejVW3Cx5yMQzovURT/fRplao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9ln2vOafew2ShI2U8D5k3/rEuSXeSZDEPE6+QwPsCxSMRHuICE87XJNQMQh2VjxH7Bjh0D1EtZ3IYBxgRk7atqRz6OngFtW+eX4VCWV6Ky430lzh2NINH22N/CNbv5qhUOFLt5JjdjeMxjmZHH3CXIDGl7QP5SNwOIb6KUIEsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgIlunTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgIlunTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D65C4CEE7;
	Wed, 16 Jul 2025 15:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752680293;
	bh=rdr4NKTxH/9RggyqCNUejVW3Cx5yMQzovURT/fRplao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BgIlunTd6f0+6TxcVv67IiJl1552uLsa1qBqy5R9pkafIwxObQe4LTezUA6JaE6WT
	 CgDljfH3JVar5QJBeAYKr8bbvBo9dRPZa9fPesYxs54oDFx2ZgywuPsj4K3Yr8EvFQ
	 rMxjEww+vbwLtf8bAVVdT5e3MEaC/MNgMTk22Vo1MRqDJa2n/qN3ZI6GfHMRQjZWoG
	 uglJs085fb2tO9xu4j5CYW/kQFC7NsesUo4bohnVY6Dgvz4p2yHKiajCVDpoBnDyFT
	 WQLSTKdYpFu8PjZEjTbbzk3AcRaEnGs1MHCiq0ynLX+sEEOvQvBX3NdIzM4h5rtueu
	 VZcOCQ8vfApjQ==
Date: Wed, 16 Jul 2025 08:38:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: Re: flakey assert failures in xfs/538 in for-next
Message-ID: <20250716153812.GG2672049@frogsfrogsfrogs>
References: <20250716121339.GA2043@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716121339.GA2043@lst.de>

On Wed, Jul 16, 2025 at 02:13:39PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I'm seeing assert failures in xfs/538 in for-next when using 1k file
> systems.  Unfortunately the errors are a bit flakely, two days ago I had
> a streak where I could reproduce them pretty easily and the bisection
> landed at:
> 
> "xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()"

O^o

> but trying to reproduce it again yesterday mostly failed, with just
> a single occurance of the failure in many runs.  Below is the
> assert output, which suggests that xfs_bmapi_write gets something
> wrong in the accounting in case it rings a bell for someone:
> 
> [ 6062.095597] XFS (vdc): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3665, on filesystem "vdc"
> [ 6062.355716] XFS: Assertion failed: pathlen == 0, file: fs/xfs/libxfs/xfs_symlink_remote.c, line: 383

I've seen this happen maybe once or twice, I think the problem is that
the symlink xfs_bmapi_write fails to allocate enough blocks to store the
symlink target, doesn't notice, and then the actual target write runs
out of blocks before it runs out of pathlen and kaboom.

Probably the right answer is to ENOSPC if we can't allocate blocks, but
I guess we did reserve free space so perhaps we just keep bmapi'ing
until we get all the space we need?

The weird part is that XFS_SYMLINK_MAPS should be large enough to fit
all the target we need, so ... I don't know if bmapi_write is returning
fewer than 3 nmaps because it hit ENOSPC or what?

(and because I can't reproduce it reliably, I have not investigated
further :()

--D

> [ 6062.356258] ------------[ cut here ]------------
> [ 6062.356502] kernel BUG at fs/xfs/xfs_message.c:102!
> [ 6062.356761] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> [ 6062.357027] CPU: 1 UID: 0 PID: 1002774 Comm: fsstress Not tainted 6.16.0-rc2+ #1286 PREEMPT(full) 
> [ 6062.357481] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [ 6062.358024] RIP: 0010:assfail+0x2c/0x35
> [ 6062.358229] Code: 1f 00 49 89 d0 41 89 c9 48 c7 c2 f0 2a 1a 83 48 89 f1 48 89 fe 48 c7 c7 8f 47 24 83 e8 fd fd ff ff 80 3d 1e 57 a4c
> [ 6062.361574] RSP: 0018:ffff8881d6a53c80 EFLAGS: 00010202
> [ 6062.361951] RAX: 0000000000000000 RBX: ffff88813bb6ee80 RCX: 000000007fffffff
> [ 6062.362701] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8324478f
> [ 6062.363427] RBP: ffff8881026ee000 R08: 0000000000000000 R09: 000000000000000a
> [ 6062.363756] R10: 000000000000000a R11: 0fffffffffffffff R12: 000000000000001f
> [ 6062.364254] R13: 0000000000000001 R14: 00000000000003c8 R15: 00000000000003c8
> [ 6062.364718] FS:  00007f6c9b5e1040(0000) GS:ffff8882b3418000(0000) knlGS:0000000000000000
> [ 6062.365347] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6062.365906] CR2: 00007f6c9b7df000 CR3: 00000001f456d005 CR4: 0000000000770ef0
> [ 6062.366424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6062.366909] DR3: 0000000000000000 DR6: 00000000ffff07f0 DR7: 0000000000000400
> [ 6062.367395] PKRU: 55555554
> [ 6062.367593] Call Trace:
> [ 6062.367777]  <TASK>
> [ 6062.367938]  xfs_symlink_write_target+0x2c5/0x2d0
> [ 6062.368282]  ? xfs_diflags_to_iflags+0x14/0x100
> [ 6062.368626]  ? preempt_count_add+0x73/0xb0
> [ 6062.368898]  xfs_symlink+0x41d/0x520
> [ 6062.369181]  xfs_vn_symlink+0x8a/0x1b0
> [ 6062.369446]  vfs_symlink+0x10a/0x180
> [ 6062.369765]  do_symlinkat+0x104/0x130
> [ 6062.370061]  __x64_sys_symlink+0x32/0x40
> [ 6062.370399]  do_syscall_64+0x50/0x1d0
> [ 6062.370659]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
