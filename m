Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D5C28D82F
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668025; cv=none; b=irO9+kx75nfWvTYmcwPxhceiS8d6f6KHC187z6dZQruiaVOiJz2wkzUnsdksGiAcOu7o4yk7D3JZlMYPYdKchrheUBNlYdWpmEPOsn8p+H6b8jlsXm5U0AP/m41tLawYnDarGlgHOFg5xlNJXNqsD7XLYw4jW18JEV3sYe76/UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668025; c=relaxed/simple;
	bh=TFIFqRMUqFU6SOg+mkItAvzCzEopinsWs7R5XDTma0s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P8jc1eHmMKJ7c3MNGUEZrQ9kaDigiwLG48ckPp3vtkI9gEtzz8Lb9pUmyOkHe8/LZ6kg/zs1J123+0bzgUeumzmkiFgCiroeOkKL7b+JM2j2zvPOfKNnGXnhTqXtUszDeNbFTYw6j1JdkRiL70BBrsWjiSUrG2fPQNNFsIp5G4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D45BC68BEB; Wed, 16 Jul 2025 14:13:39 +0200 (CEST)
Date: Wed, 16 Jul 2025 14:13:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Fedor Pchelkin <pchelkin@ispras.ru>
Subject: flakey assert failures in xfs/538 in for-next
Message-ID: <20250716121339.GA2043@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi all,

I'm seeing assert failures in xfs/538 in for-next when using 1k file
systems.  Unfortunately the errors are a bit flakely, two days ago I had
a streak where I could reproduce them pretty easily and the bisection
landed at:

"xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()"

but trying to reproduce it again yesterday mostly failed, with just
a single occurance of the failure in many runs.  Below is the
assert output, which suggests that xfs_bmapi_write gets something
wrong in the accounting in case it rings a bell for someone:

[ 6062.095597] XFS (vdc): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3665, on filesystem "vdc"
[ 6062.355716] XFS: Assertion failed: pathlen == 0, file: fs/xfs/libxfs/xfs_symlink_remote.c, line: 383
[ 6062.356258] ------------[ cut here ]------------
[ 6062.356502] kernel BUG at fs/xfs/xfs_message.c:102!
[ 6062.356761] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[ 6062.357027] CPU: 1 UID: 0 PID: 1002774 Comm: fsstress Not tainted 6.16.0-rc2+ #1286 PREEMPT(full) 
[ 6062.357481] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 6062.358024] RIP: 0010:assfail+0x2c/0x35
[ 6062.358229] Code: 1f 00 49 89 d0 41 89 c9 48 c7 c2 f0 2a 1a 83 48 89 f1 48 89 fe 48 c7 c7 8f 47 24 83 e8 fd fd ff ff 80 3d 1e 57 a4c
[ 6062.361574] RSP: 0018:ffff8881d6a53c80 EFLAGS: 00010202
[ 6062.361951] RAX: 0000000000000000 RBX: ffff88813bb6ee80 RCX: 000000007fffffff
[ 6062.362701] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8324478f
[ 6062.363427] RBP: ffff8881026ee000 R08: 0000000000000000 R09: 000000000000000a
[ 6062.363756] R10: 000000000000000a R11: 0fffffffffffffff R12: 000000000000001f
[ 6062.364254] R13: 0000000000000001 R14: 00000000000003c8 R15: 00000000000003c8
[ 6062.364718] FS:  00007f6c9b5e1040(0000) GS:ffff8882b3418000(0000) knlGS:0000000000000000
[ 6062.365347] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6062.365906] CR2: 00007f6c9b7df000 CR3: 00000001f456d005 CR4: 0000000000770ef0
[ 6062.366424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6062.366909] DR3: 0000000000000000 DR6: 00000000ffff07f0 DR7: 0000000000000400
[ 6062.367395] PKRU: 55555554
[ 6062.367593] Call Trace:
[ 6062.367777]  <TASK>
[ 6062.367938]  xfs_symlink_write_target+0x2c5/0x2d0
[ 6062.368282]  ? xfs_diflags_to_iflags+0x14/0x100
[ 6062.368626]  ? preempt_count_add+0x73/0xb0
[ 6062.368898]  xfs_symlink+0x41d/0x520
[ 6062.369181]  xfs_vn_symlink+0x8a/0x1b0
[ 6062.369446]  vfs_symlink+0x10a/0x180
[ 6062.369765]  do_symlinkat+0x104/0x130
[ 6062.370061]  __x64_sys_symlink+0x32/0x40
[ 6062.370399]  do_syscall_64+0x50/0x1d0
[ 6062.370659]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
