Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EE935A398
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626341; cv=none; b=iGy6yJru53xT8hTPCkDMct2XC6L+6eDfb/ouRcaC5Dpg1HzwnOCDR4huvgsidYI7LOodwabCq+yuAnQoy0B04A9jTuuRmqBClXpXpmTSkvYja/vFDyBdZRcMRsiX2cYQbaP2intYBe0bU5sqI86iFO/tY/y+Tw/n44/SzadbqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626341; c=relaxed/simple;
	bh=RMETp2z45XrtoDaoe9d57xdP3NGeXJXoTRTd9kFMxOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CArfxO2UxqY0IEP9rJpxRlVt/7w9q8seZOwaMbCDR5FwBv7sStwXSXxB5jSpOGazmZr3+krTfqrxkNJNZqsJyKUFtVojNcNF9vASQ7WnZo+yXaW1wxz4AO2vFcSp/D/536nt0X6Ad56KaG9efNQLHmYJi8GjTTHtcg6zTRnGgss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5yw+Feo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5yw+Feo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92B3C2BCB0;
	Tue, 12 May 2026 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778626340;
	bh=RMETp2z45XrtoDaoe9d57xdP3NGeXJXoTRTd9kFMxOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P5yw+FeonNkKC3qSUlRZjHXMqrEo8OU0SYDpz12vHX6J7BbI4/frZ0YgXhEjnCgUL
	 j/ZBfPuZeDyTBb5SUPIOKsg1n6xTc+9n0qFPwWbYN4+mruup10ONXQnCJLIN+zwP1z
	 j4c3CduBt1far7Tca6X+OA4WJMezwsO3Mrlo4lCoVKA6FN4Jj/wGLoCiTGzXGYMOHk
	 9H4gI3G5L727knuStKzNV2h/4/eGOUrPLpPvpE9EA2ivODbehamQTegKdpbB3NsKQa
	 fPTdPNVk2JGRyOwxGGT6cp/5Y5Ub0X33Eh2hCFWa/MK9pCPCbPULf5s3Brn2JylafH
	 o/C2SyJjZ0vig==
Date: Wed, 13 May 2026 08:52:12 +1000
From: Dave Chinner <dgc@kernel.org>
To: yebin <yebin@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de
Subject: Re: [bug report] kernel BUG at fs/xfs/xfs_message.c:102!
Message-ID: <agOvHBfTbfQI-PTj@dread>
References: <6A031038.9030708@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A031038.9030708@huaweicloud.com>

On Tue, May 12, 2026 at 07:34:16PM +0800, yebin wrote:
> Hello Darrick and all,
> 
> Recently, I encountered a problem where a BUG was triggered in the write-back process.
> The detailed problem information is as follows:
> ```
> XFS (sde): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0xaa6/0xc60 (fs/xfs/xfs_trans.c:351).  Shutting.
> XFS (sde): Please unmount the filesystem and rectify the problem(s)
> XFS: Assertion failed: tp->t_blk_res || tp->t_fdblocks_delta >= 0, file: fs/xfs/xfs_trans.c, line: 610
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:102!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> RIP: 0010:assfail+0x9f/0xb0

What kernel? You've stripped that line out of the stack dump.

> Code: fe 84 db 75 20 e8 51 2e 33 fe 0f 0b 5b 5d 41 5c 41 5d c3 cc cc cc cc 48 c7 c7 58 ae 2b 8d e8 08 73 a2 fe eb cc e8 310
> RSP: 0018:ffffc9000f6372e0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff838c91a6
> RDX: ffff8881a856bb00 RSI: ffffffff838c91cf RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: fffff52001ec6ded
> R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8a956520
> R13: 0000000000000262 R14: 0000000000000000 R15: ffffffffffffffff
> FS:  00007f7ee1f5b740(0000) GS:ffff88878bb45000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0e632788f0 CR3: 00000001b524a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xfs_trans_unreserve_and_mod_sb+0xb86/0xd00
>  __xfs_trans_commit+0x38b/0xe00
>  xfs_trans_commit+0xeb/0x1a0
>  xfs_bmapi_convert_one_delalloc+0xbca/0x1270
>  xfs_bmapi_convert_delalloc+0x101/0x350
>  xfs_writeback_range+0x76c/0x12d0
>  iomap_writeback_folio+0x9ed/0x2100
>  iomap_writepages+0x13c/0x2a0
>  xfs_vm_writepages+0x278/0x330
>  do_writepages+0x247/0x5c0
>  filemap_writeback+0x22c/0x2e0
>  xfs_file_release+0x442/0x580
>  __fput+0x407/0xb50
>  fput_close_sync+0x114/0x210
>  __x64_sys_close+0x94/0x120
>  do_syscall_64+0xc4/0xf80
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> ```
> 
> After analyzing the above issues, the possible triggering process
> is as follows:
> ```
> xfs_bmapi_convert_delalloc
>  xfs_bmapi_convert_one_delalloc
>   xfs_bmapi_allocate
>    xfs_bmap_add_extent_delay_real
>     da_old = startblockval(PREV.br_startblock); // da_old = 5
>     case BMAP_LEFT_FILLING:
>      ifp->if_nextents++;  // 21 + 1 = 22
>      if (xfs_bmap_needs_btree(bma->ip, whichfork))  // 22 > 21
>       xfs_bmap_extents_to_btree     // convert to btree
>         cur->bc_ino.allocated++;
>       da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>                                startblockval(PREV.br_startblock) -
>                                (bma->cur ? bma->cur->bc_ino.allocated : 0));  // da_new = 5 - 1 = 4
>       PREV.br_startblock = nullstartblock(da_new); //xfs_bmapi_convert_one_delalloc() return
> 
>                                                  xfs_bmap_del_extent_real
>                                                    case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
>                                                     ifp->if_nextents--;  // 22 - 1 = 21
>                                                     if (xfs_bmap_needs_btree(ip, whichfork))
>                                                       xfs_bmap_extents_to_btree
>                                                     else
>                                                       xfs_bmap_btree_to_extents  // convert to extents

So your test code is creating a number of fragmented extents to get
to the edge of btree format conversion, then doing a delalloc
write() to create a long delalloc extent range, then is alternating
along the range of the delalloc extent doing:

loop:
	sync_file_range(offset, 4096, SYNC_FILE_RANGE_WRITE)
	fallocate(PUNCH_HOLE, offset, 4096)
	offset += 4096;

And so it is converting a single block at the left edge of the
delalloc extent to a written extent which triggers a extent -> btree
conversion, and then you punch out the newly created written extent
triggering a btree -> extent conversion.

And each time you do this it removes a reserved block from the
delalloc extent for the btree root block, yes?

How realistic is this scenario in an application/production
environment? I mean, nobody walks through a file syncing data to
disk one fragmented extent at a time only to immediately remove it
before writing the next block.

We've known that this is possible for a very long time. I've
personally known it can happen in carefully constructed test code
for over 20 years, but I can count on one hand the number of times
I've actually seen this exhaustion occur in a production system.

The reservation we use here is essentially unchanged since if was
first introduced in 1994, so time in use tells us that the
reservation is largely sufficient for production systems. Can you
describe the situation where you production systems are hitting
this? What is the application actually doing to trigger this
problem?

> ... // Alternate a few times in the middle.
> da_old = 4
> da_old = 3
> da_old = 2
> da_old = 1
> ...
> xfs_bmapi_convert_delalloc
>  xfs_bmapi_convert_one_delalloc
>   error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, XFS_TRANS_RESERVE, &tp);  // Both blocks and rtextents are 0
>    tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
>    error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>    if (blocks > 0)
>     error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
>     tp->t_blk_res += blocks;    // The value of blocks is 0, so the value of tp->t_blk_res is 0
>    xfs_bmapi_allocate
>     xfs_bmap_add_extent_delay_real
>      da_old = startblockval(PREV.br_startblock); // da_old = 0
>      case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:   // The current delay extent is just exhausted.
>       ifp->if_nextents++;  // 21 + 1 + 22
> 
>     if (xfs_bmap_needs_btree(bma->ip, whichfork))  // 22 > 21
>      error = xfs_bmap_extents_to_btree(bma->tp, bma->ip, &bma->cur, da_old > 0, &tmp_logflags, whichfork);     // Converted to btree. da_old > 0 is false.
>       args.wasdel = wasdel;   //  wasdel is false
>       error = xfs_alloc_vextent(&args);
>        xfs_alloc_ag_vextent(args, 0)

Ok, that's why you stripped the kernel ID out of the stack dump -
this analysis is from a vendor kernel of some kind. i.e.
xfs_alloc_ag_vextent() went away in 2023...

Which begs the question: we fixed some issues with this code back in
2024, so does this problem still occur on TOT kernels? e.g. commit
d69bee6a35d3 ("xfs: fix xfs_bmap_add_extent_delay_real for partial
conversions") should help address indlen block consumption for
repeated partial conversions.

> Further analysis of this abnormal model shows that because the reserved blocks
> are continuously consumed, they may eventually exceed the reserved amount. When
> the space is nearly exhausted, xfs_bmap_extents_to_btree() may fail to allocate
> blocks, triggering a warning. This failure to allocate additional blocks can lead
> to issues with normal block allocation.

The TOT code should be recalculating the required indlen for the
remaining delalloc extent and accounting for indlen block usage
where it gets depleted. hence the gradual reduction of the indlen
over repeated left edge conversion and removal triggering repeated
indlen block consumption should no longer be a problem.

If it is a problem, then we need to make sure we account for it
correctly, similar to the fix in the above commit and the series it
was part of.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
