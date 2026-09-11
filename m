Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B7B42FCA1;
	Fri, 11 Sep 2026 07:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111774; cv=none; b=NaHFbrGlRoiNVd30ftNz/yWyoWWrp16ISCI7hyGioylEHw69Jhq70rr3UNDtodycAPb5Q0JCDWoVrC0GqzcHqegTL3FjPmD+5Li47Dg1KLfHNAuKdlxzoi4b2odYK7fQdIWVk9eFESSL5z2gibYFiwxYayhVWje8HpYhSOfIIeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111774; c=relaxed/simple;
	bh=0iEsaBiUnVl/KQPGsYLvA0J7EtiEt+vi8tluZiWk544=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EfdknBzPG9T+/b64JF3D8HQeO7NN2jJbD3/0byQM7iohkcTcueieO6cTleN8O4BGPCP/Ufm3f99irbR1tS6wvku+015c/OEd3zWcOGErTaVbGAJwjheqtJZr69UFyYFlrvbUyswUCoTYuNaGt3qtn2LgcaiFXOLcwbe7WBrQBYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7aULQcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7aULQcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859EB1F0089A;
	Fri, 11 Sep 2026 07:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111773;
	bh=qypTKPadeM7L2ZB02QIhTZdaEFwUztZ76MZg8zaISxQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=k7aULQcSQp4sM/33rpZ0+SGhzT/OiWdCNVDPclK9tYSECKw/eeT9OdjPQjKXWmlpP
	 RPRd7LOQq58DmKozk0RMDyr6YH6VAUZoAPcZnu4W3TwhEjKUqRhXrrH4SfwJ9StRoK
	 gCFaPdqMtprMBEscmvRhU9wTqlRscqfFRAAGgid72sEjUbWDHDi9hwt7W22plC3hwg
	 oftD3IcpI5KVhz9L9FMqSRaXQw5ZNCPdcBTfAuLmFo1H/JeuxzN+Xw0vkrGcNSrkoA
	 1s2SdrFTIcMPVibywc31b0kOcFEd22yaOGkFChxiY//OkuapUgN6eI7qL4V+Y6XMMw
	 tJewMWQ9nLb/Q==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: dgc@kernel.org, floss@jetm.me, stable@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260911044228.GA6265@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
 <20260911044228.GA6265@frogsfrogsfrogs>
Subject: Re: [PATCH v1.1 1/7] xfs: fix under-reservation of blocks when
 repairing sf directories
Message-Id: <178911177124.25559.8200298817554349732.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:29:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 10 Sep 2026 21:42:28 -0700, Darrick J. Wong wrote:
> Whilst running QA on XFS for-next as of 7.3-rc2 with MKFS_OPTIONS="-n
> size=8192", I observed the following (trimmed) dmesg splat:
> 
>  XFS: Assertion failed: args->total >= dp->i_nblocks - nblks, file: fs/xfs/libxfs/xfs_da_btree.c, line: 2387
>  WARNING: fs/xfs/xfs_message.c:104 at assfail+0x46/0x4a [xfs], CPU#0: xfs_scrub/1426511
>  CPU: 0 UID: 0 PID: 1426511 Comm: xfs_scrub Tainted: G        W           7.3.0-rc2-djwx #rc2 PREEMPT(lazy)  6e418570b606a39783b0e7e7b30dc407b965f9e8
>  Tainted: [W]=WARN
>  RIP: 0010:assfail+0x46/0x4a [xfs]
>  RSP: 0018:ffffc900010d7890 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffd1
>  RDX: 0000000000000000 RSI: 0000000000000021 RDI: ffffffffa059fd38
>  RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
>  R10: 000000000000000a R11: 000000007fffffff R12: ffffc900010d7940
>  R13: ffff888368d8f980 R14: ffffc900010d7a48 R15: ffffc900010d78d0
>  FS:  00007f445c5ce680(0000) GS:ffff8884a97ea000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f443803b9a8 CR3: 0000000107a4b000 CR4: 00000000003506f0
>  Call Trace:
>   <TASK>
>   xfs_da_grow_inode_int+0x2e0/0x300 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xfs_dir2_grow_inode+0x6e/0x150 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xfs_dir2_sf_to_block+0x149/0x870 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xrep_dir_swap_prep+0xe2/0x110 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xrep_dir_swap+0xfb/0x2f0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xrep_dir_rebuild_tree+0x99/0x100 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xrep_directory+0x83/0x1c0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xrep_attempt+0x4f/0x1e0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xfs_scrub_metadata+0x393/0x5b0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xfs_ioc_scrubv_metadata+0x306/0x570 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   xfs_file_ioctl+0xa4f/0x1150 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
>   __x64_sys_ioctl+0x76/0xc0
>   do_syscall_64+0x7a/0x3b0
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> [...]

Applied to for-next, thanks!

[1/7] xfs: fix under-reservation of blocks when repairing sf directories
      commit: 4d3c07591534517c633945c8d8e6526f10e3fabc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

