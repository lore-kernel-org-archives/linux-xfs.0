Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741693D45E4
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778606372; cv=none; b=O9b+gFF2TxQBdAUj9br9BYSJ1dJ5CpFHxcCBgleVeftwb8V37kdcRWS7tYgow/V7MuoFu/gKQOy7reoiZXSunKf/Kg2Aqm6osJX4xYExib++W3AhHFb2X15FO8/K/7FhvJWU/3PEk4ZUEX16XSqRf+4Mbtj+n2iZlhJEqVxI+JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778606372; c=relaxed/simple;
	bh=/nBG2fKIoTuZ8p8fS3b1oIi+1M4sdTALQx4Ta+VZRBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eC/03mCavMIvJf+SMOsBOWwlQkYeB/Kuip0G2wNFTRcIxm5q/lDZZaafkJWiaHG86Ag++soENUMt5a9cMF1hGO8+mrWkNNEeWGY3jH2QPspl6yhlgx8QdsxcpfKK30oDazI3bT8mSbjvDWF3Ul4hAFDG4mUYsRr7TabDMWgTCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KV6GKZj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KV6GKZj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1702BC2BCB0;
	Tue, 12 May 2026 17:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778606372;
	bh=/nBG2fKIoTuZ8p8fS3b1oIi+1M4sdTALQx4Ta+VZRBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KV6GKZj1W7u4FZZ5nx22+Ny+UQMX1CMs2aJfTgEuEQQu5uiHEtmcgyAzP5nPG5h9z
	 pYY/VMNa2xKUto72/ZmF051T8RpqHflzOb8eWuf8eAlZIBD1nsogMU+w6de1QyXOj9
	 W70JhWk8Sw6qhgV8dfngbvnAkxzdwAhPyKQFr4jYUA9TjOXTUT2l0v6SzrMc4dS7Bv
	 x7p+8yP63281k0naPekqqGMQT4OGDT4ynnHHS6/T3B/LcNKCcL+/PUV93PtytxZ5GJ
	 v2wo8WLa03GL/4B7JOqpZqpQETGaih/rNi5HebX3cwVrRGXMy/etaLYyl9lUrBOUHx
	 GTxOq6Ub4dR5A==
Date: Tue, 12 May 2026 10:19:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: yebin <yebin@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [bug report] kernel BUG at fs/xfs/xfs_message.c:102!
Message-ID: <20260512171931.GN9555@frogsfrogsfrogs>
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
>         xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
>          case XFS_AG_RESV_NONE:
>           field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS : XFS_TRANS_SB_FDBLOCKS; //args->wasdel  == false
>           xfs_trans_mod_sb(args->tp, field, -(int64_t)args->len);
>            case XFS_TRANS_SB_FDBLOCKS:
>             if (delta < 0)
>              tp->t_blk_res_used += (uint)-delta;
>              if (tp->t_blk_res_used > tp->t_blk_res)  // ***tp->t_blk_res is 0, thus triggering xfs_force_shutdown()***
>               xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> ```
> 
> The logic that triggers the issue above was designed by me to facilitate the
> construction of the problem. Besides the scenario where XFS_DINODE_FMT_BTREE
> and XFS_DINODE_FMT_EXTENTS are converted back and forth, there is also the
> scenario of btree splitting.
> 
> The core reason for the issue is that in xfs_bmapi_convert_delalloc(), the
> call to xfs_bmap_worst_indlen() calculates the worst-case number of reserved
> blocks, which is the number of additional blocks required after a complete
> conversion of the entire delayed extent. It assumes that the entire conversion
> process is atomic. However, the current process cannot guarantee such atomicity.
> In the case of a fragmented filesystem, the most extreme scenario is that every
> block conversion triggers a full btree split, in which case the reserved blocks
> are far from sufficient. When this issue is triggered, the filesystem fragmentation
> in the environment is indeed quite severe.
> 
> Further analysis of this abnormal model shows that because the reserved blocks
> are continuously consumed, they may eventually exceed the reserved amount. When
> the space is nearly exhausted, xfs_bmap_extents_to_btree() may fail to allocate
> blocks, triggering a warning. This failure to allocate additional blocks can lead
> to issues with normal block allocation.
> 
> Additionally, in xfs_bmap_add_extent_delay_real(), if a delayed extent is split
> into two, xfs_bmap_worst_indlen() is recalculated to reserve blocks. In the case
> of nearly exhausted space, it may be impossible to reserve the newly required
> blocks, leading to a writeback failure.
> 
> During the reservation phase, reserving more blocks by considering the worst-case
> scenario would require occupying a lot of extra space, which is not very practical.
> I was thinking that we could convert all the delay extents at once to ensure
> atomicity, which would ensure that the two issues analyzed above do not exist.
> However, I am not sure what negative impacts this approach might have. The only
> thing I can think of is that the reserved space would be repeatedly allocated and
> released, but I believe the current logic already has similar situations.
> 
> I haven't thought of a better solution at the moment. I wonder if anyone has any
> good ideas?

I haven't.  With EFI-based space freeing in transactions, as a
theoretical last resort you could steal a block from an EFI instead of
scanning the bnobt/cntbt.  This would mitigate the nastiness of repeated
split/merge cycles but you'd have to be careful about block reuse.

--D

> 
> Thanks,
> Ye Bin
> 
> 
