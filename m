Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE8D8C0B
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 03:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739937582; cv=none; b=S5VPxvpw1bE5qhi1YSPkKL4jskt0szT4xcxkeLRkGkgSBP3aJYcTMj+b0MLUN6MZCN5IB42RHws+xDRoLo82guPYppSg3DDQ2RY5scoNv68o4ud5L7JzrJWqxn/bAgH1vuxR7sQBCro91EuYbMvViNY5vDmA2zwSnDOTPThIDFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739937582; c=relaxed/simple;
	bh=Y2OqIkjlkYtjrJrvu3vpw+CceqY2c/2wbD79/YEgxn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNpwRoMCDdFpumeiEcikoviWKvMfWDW5V+0ejd/nNFDvcikr7QL+ztysT2jx0yN/I6rD+czj44XKYnmE2gO0YHLd2uHd0auxVHaCrMXq3MH05U6P/Unak3LAw1JvpEsogxxDAwX9KMkWHJ7AQo2U4S3w47UGTYg/n68wNw7lDb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agdlwkPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agdlwkPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D09C4CED1;
	Wed, 19 Feb 2025 03:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739937581;
	bh=Y2OqIkjlkYtjrJrvu3vpw+CceqY2c/2wbD79/YEgxn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=agdlwkPSuWt0S+30+1KzvuiN1ABwo70+yRtLz/kpGYQqQD+0VwaGbLp7E5YS9ai/c
	 R81+CUfz6sWfFK+o+zmxao9bLSS5K6pH5ZWijSSr9nReC2DqXf2ktQwdfpEUiPmhGm
	 ynLFN5mrwpUZFtTr5Aae59oVZes8wqf2/MZ292zN8wbLw2KLUE2xLrem/7fsmtkn7t
	 kF/fYDf6gVTnZ65HF3dDns6BWxWKgj+rk8o9w8MTgvEAV4ewV3PmUyjxcAmSB6nFU4
	 bOarDNXCErHZFJbXb3GxqO8QMAf1U6s49xA7j6ULT6k6WliLe2QenFUqDWnWXAfNbK
	 TFvjIvU9jt26Q==
Date: Tue, 18 Feb 2025 19:59:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org
Subject: Re: [regression 6.14-rc2 + xfs-for-next] Bad page state at unmount
Message-ID: <20250219035940.GK21808@frogsfrogsfrogs>
References: <Z7VU9QX8MrmZVSrU@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7VU9QX8MrmZVSrU@dread.disaster.area>

On Wed, Feb 19, 2025 at 02:50:13PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I hit this running check-parallel a moment ago:
> 
> [80180.074658] BUG: Bad page cache in process umount  pfn:7655f4
> [80180.077259] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x0 pfn:0x7655f4
> [80180.080573] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
> [80180.083615] memcg:ffff888104f36000
> [80180.084977] aops:xfs_address_space_operations ino:84
> [80180.087175] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
> [80180.091380] raw: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
> [80180.094469] raw: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
> [80180.097740] head: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
> [80180.100988] head: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
> [80180.104129] head: 0017ffffc0000202 ffffea001d957d01 ffffffff00000003 0000000000000004
> [80180.107232] head: 0000000000000004 0000000000000000 0000000000000000 0000000000000000
> [80180.110338] page dumped because: still mapped when deleted
> [80180.112755] CPU: 32 UID: 0 PID: 832271 Comm: umount Not tainted 6.14.0-rc2-dgc+ #302
> [80180.112757] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [80180.112760] Call Trace:
> [80180.112763]  <TASK>
> [80180.112766]  dump_stack_lvl+0x3d/0xa0
> [80180.112773]  dump_stack+0x10/0x17
> [80180.112775]  filemap_unaccount_folio+0x151/0x1e0
> [80180.112779]  delete_from_page_cache_batch+0x61/0x2f0
> [80180.112787]  truncate_inode_pages_range+0x122/0x3e0
> [80180.112807]  truncate_inode_pages_final+0x40/0x50
> [80180.112809]  evict+0x1af/0x310
> [80180.112817]  evict_inodes+0x66/0xc0
> [80180.112818]  generic_shutdown_super+0x3c/0x160
> [80180.112821]  kill_block_super+0x1b/0x40
> [80180.112823]  xfs_kill_sb+0x12/0x30
> [80180.112824]  deactivate_locked_super+0x38/0x100
> [80180.112826]  deactivate_super+0x41/0x50
> [80180.112828]  cleanup_mnt+0x9f/0x160
> [80180.112830]  __cleanup_mnt+0x12/0x20
> [80180.112831]  task_work_run+0x89/0xb0
> [80180.112833]  resume_user_mode_work+0x4f/0x60
> [80180.112836]  syscall_exit_to_user_mode+0x76/0xb0
> [80180.112838]  do_syscall_64+0x74/0x130
> [80180.112840]  ? exc_page_fault+0x62/0xc0
> [80180.112841]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> ....
> [80180.131293] BUG: Bad page cache in process umount  pfn:4ac768
> [80180.131296] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x4 pfn:0x4ac768
> [80180.131299] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
> [80180.131301] memcg:ffff888104f36000
> [80180.131302] aops:xfs_address_space_operations ino:84
> [80180.218440] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
> [80180.222779] raw: 0017ffffc000016d ffffea001d957d08 ffffea000d980b08 ffff8891726dae98
> [80180.226376] raw: 0000000000000004 0000000000000000 0000000900000000 ffff888104f36000
> [80180.229546] head: 0017ffffc000016d ffffea001d957d08 ffffea000d980b08 ffff8891726dae98
> [80180.232954] head: 0000000000000004 0000000000000000 0000000900000000 ffff888104f36000
> [80180.232956] head: 0017ffffc0000202 ffffea0012b1da01 ffffffff00000003 0000000000000004
> [80180.232958] head: 0000000500000004 0000000000000000 0000000000000000 0000000000000000
> [80180.232958] page dumped because: still mapped when deleted
> [80180.232961] CPU: 32 UID: 0 PID: 832271 Comm: umount Tainted: G    B              6.14.0-rc2-dgc+ #302
> [80180.232965] Tainted: [B]=BAD_PAGE
> .....
> [80180.233052] BUG: Bad page cache in process umount  pfn:36602c
> [80180.241951] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x8 pfn:0x36602c
> [80180.241955] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
> [80180.241957] memcg:ffff888104f36000
> [80180.241958] aops:xfs_address_space_operations ino:84
> [80180.241961] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
> [80180.241965] raw: 0017ffffc000016d ffffea0012b1da08 ffffea000d585508 ffff8891726dae98
> [80180.241966] raw: 0000000000000008 0000000000000000 0000000900000000 ffff888104f36000
> [80180.241967] head: 0017ffffc000016d ffffea0012b1da08 ffffea000d585508 ffff8891726dae98
> [80180.241969] head: 0000000000000008 0000000000000000 0000000900000000 ffff888104f36000
> [80180.241970] head: 0017ffffc0000202 ffffea000d980b01 ffffffff00000003 0000000000000004
> [80180.241971] head: 0000000500000004 0000000000000000 0000000000000000 0000000000000000
> [80180.241972] page dumped because: still mapped when deleted
> [80180.241974] CPU: 32 UID: 0 PID: 832271 Comm: umount Tainted: G    B              6.14.0-rc2-dgc+ #302
> [80180.241976] Tainted: [B]=BAD_PAGE
> 
> I don't know which fstest triggered it, but this is a new failure
> that I haven't seen before. It looks like 3 consecutive order-2
> folios on the same mapping all have the same problem....
> 
> The kernel was a post 6.14-rc2 kernel with linux-xfs/for-next merged
> into it. I'm going to update the kernel to TOT to see if this
> reproduces again, but I've only seen this once in dozens of tests
> runs on this kernel, so....
> 
> Has anyone seen something similar or have any ideas where to look?

I didn't see anything like that on -rc2, and -rc3 doesn't seem to be
showing that either.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
