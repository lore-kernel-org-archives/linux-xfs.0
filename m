Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAB8377ECE
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779102887; cv=none; b=SIZEF99hsztvMI8gvpNVOyBQO3OnnG1Wo4GoIryofcip+Cy/LIl7USpZcfhI78athJiAV5wzHjD/xt2sxLJB0dsBoLT92DbBwRmG6UG34aGaXxVqNj74WWojm7mY0ObFtmIqXlXZ/rTEWnsrC2n7W+2ZZjDP7HH8I0I0SVUsxS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779102887; c=relaxed/simple;
	bh=0s9rdQxS+6jv08A0sdYAG6efiWlEZ6x5Y0LmV3rlJMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHKe+Nk/3oA/0ASaf3neoXIotz6PswbQhpK7AgxWvXlieWL+tvMzDgPiKFurJyKT0xNd0O8eKDc5LBUtfc0CJzdhLS65wZ3GFHr4Uf0JSfV9dG5iJqdHIT84oesiRBFBJoIuojgL9YUp5hhjV+AawkxZQcy5XVXXtq4GBX/mQvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ri+lSrRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ri+lSrRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4ADC2BCC6;
	Mon, 18 May 2026 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779102886;
	bh=0s9rdQxS+6jv08A0sdYAG6efiWlEZ6x5Y0LmV3rlJMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ri+lSrRW6d2aGAE81wziNGHfSCkqttUjXn5hxJfQQaWMS+gMycVDlYjZgsB439WeT
	 snHy6EEonHrLD8e8f1pDHyj4ZBxRqcTwj5hXZLuTVRlnmrJmbDKgikYU6BtOkn7fzw
	 iJtmWudyIKZPdwDpiY7q5q4BWGjF5Iv/KwQktOzEFnwGj2yDCqHFYIdF54nNpXCIFx
	 NpomhlnWxO1+PHbanrGffPEQ6RRejCoU4pnVi47IO31VPiJPrMYKLAePnjIDiCOOQD
	 IJjHM5isJDNLiXoR7V+8fdjr/QgzHPBaxsegRZz9GeZrTDPSTh76FqGWedT9DPDryz
	 jUcMSSdN5ovYA==
Date: Mon, 18 May 2026 13:14:43 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: add a xfs_rmap_inode_bmbt_owner
Message-ID: <agr0ncVOQWCT5gnx@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-5-hch@lst.de>

On Fri, May 15, 2026 at 03:50:25PM +0200, Christoph Hellwig wrote:
> Add a small wrapper for initializing the bmbt owner to i_ino.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
>  fs/xfs/libxfs/xfs_bmap_btree.c | 4 ++--
>  fs/xfs/libxfs/xfs_btree.c      | 4 ++--
>  fs/xfs/libxfs/xfs_rmap.h       | 2 ++
>  fs/xfs/scrub/bmap.c            | 2 +-
>  fs/xfs/scrub/bmap_repair.c     | 4 ++--
>  fs/xfs/scrub/newbt.c           | 2 +-
>  fs/xfs/scrub/reap.c            | 2 +-
>  fs/xfs/scrub/rtrefcount.c      | 2 +-
>  fs/xfs/scrub/rtrmap.c          | 3 +--
>  10 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a11a8aee5b79..066d13e97ec9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -602,7 +602,7 @@ xfs_bmap_btree_to_extents(
>  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
>  		return error;
>  
> -	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, ip, whichfork);
>  	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
>  			XFS_AG_RESV_NONE, 0);
>  	if (error)
> @@ -676,7 +676,7 @@ xfs_bmap_extents_to_btree(
>  	memset(&args, 0, sizeof(args));
>  	args.tp = tp;
>  	args.mp = mp;
> -	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
> +	xfs_rmap_inode_bmbt_owner(&args.oinfo, ip, whichfork);
>  
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.wasdel = wasdel;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 1c7165df483a..8683574566e2 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -217,7 +217,7 @@ xfs_bmbt_alloc_block(
>  	memset(&args, 0, sizeof(args));
>  	args.tp = cur->bc_tp;
>  	args.mp = cur->bc_mp;
> -	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
> +	xfs_rmap_inode_bmbt_owner(&args.oinfo, cur->bc_ino.ip,
>  			cur->bc_ino.whichfork);
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.wasdel = cur->bc_flags & XFS_BTREE_BMBT_WASDEL;
> @@ -280,7 +280,7 @@ xfs_bmbt_free_block(
>  	struct xfs_owner_info	oinfo;
>  	int			error;
>  
> -	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, ip, cur->bc_ino.whichfork);
>  	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
>  			XFS_AG_RESV_NONE, 0);
>  	if (error)
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 71d65f2fa005..ea85c5fbe531 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -5607,7 +5607,7 @@ xfs_btree_alloc_metafile_block(
>  
>  	ASSERT(xfs_is_metadir_inode(ip));
>  
> -	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
> +	xfs_rmap_inode_bmbt_owner(&args.oinfo, ip, cur->bc_ino.whichfork);
>  	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
>  	if (error)
>  		return error;
> @@ -5639,7 +5639,7 @@ xfs_btree_free_metafile_block(
>  
>  	ASSERT(xfs_is_metadir_inode(ip));
>  
> -	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, ip, cur->bc_ino.whichfork);
>  	error = xfs_free_extent_later(tp, fsbno, 1, &oinfo, XFS_AG_RESV_METAFILE,
>  			0);
>  	if (error)
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index 5f39f6e53cd1..7188459f61cf 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -21,6 +21,8 @@ xfs_rmap_ino_bmbt_owner(
>  	if (whichfork == XFS_ATTR_FORK)
>  		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
>  }
> +#define xfs_rmap_inode_bmbt_owner(oi, ip, whichfork) \
> +	xfs_rmap_ino_bmbt_owner(oi, (ip)->i_ino, whichfork)
>  
>  static inline void
>  xfs_rmap_ino_owner(
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index d40534bf9ef9..2ad223f0bc8a 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -600,7 +600,7 @@ xchk_bmap_btree(
>  
>  	/* Check the btree structure. */
>  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
> -	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, ip, whichfork);
>  	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
>  	xfs_btree_del_cursor(cur, error);
>  out:
> diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
> index 822a4af43833..f5791ad21e41 100644
> --- a/fs/xfs/scrub/bmap_repair.c
> +++ b/fs/xfs/scrub/bmap_repair.c
> @@ -760,7 +760,7 @@ xrep_bmap_build_new_fork(
>  	 * Prepare to construct the new fork by initializing the new btree
>  	 * structure and creating a fake ifork in the ifakeroot structure.
>  	 */
> -	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, rb->whichfork);
>  	error = xrep_newbt_init_inode(&rb->new_bmapbt, sc, rb->whichfork,
>  			&oinfo);
>  	if (error)
> @@ -833,7 +833,7 @@ xrep_bmap_remove_old_tree(
>  	struct xfs_owner_info	oinfo;
>  
>  	/* Free the old bmbt blocks if they're not in use. */
> -	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, rb->whichfork);
>  	return xrep_reap_fsblocks(sc, &rb->old_bmbt_blocks, &oinfo);
>  }
>  
> diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
> index 6ab0eff7d2ea..c82f4631fd9c 100644
> --- a/fs/xfs/scrub/newbt.c
> +++ b/fs/xfs/scrub/newbt.c
> @@ -145,7 +145,7 @@ xrep_newbt_init_metadir_inode(
>  
>  	ASSERT(xfs_is_metadir_inode(sc->ip));
>  
> -	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
>  
>  	ifp = kmem_cache_zalloc(xfs_ifork_cache, XCHK_GFP_FLAGS);
>  	if (!ifp)
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index fff23932828b..cd90ecae3ffb 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -1205,7 +1205,7 @@ xrep_reap_metadir_fsblocks(
>  	ASSERT(xfs_is_metadir_inode(sc->ip));
>  
>  	xreap_configure_agextent_limits(&rs);
> -	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
>  	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
> index 4951cc271788..0d10ce2910c2 100644
> --- a/fs/xfs/scrub/rtrefcount.c
> +++ b/fs/xfs/scrub/rtrefcount.c
> @@ -555,7 +555,7 @@ xchk_rtrefcountbt(
>  	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>  		return error;
>  
> -	xfs_rmap_ino_bmbt_owner(&btree_oinfo, rtg_refcount(sc->sr.rtg)->i_ino,
> +	xfs_rmap_inode_bmbt_owner(&btree_oinfo, rtg_refcount(sc->sr.rtg),
>  			XFS_DATA_FORK);
>  	error = xchk_btree(sc, sc->sr.refc_cur, xchk_rtrefcountbt_rec,
>  			&btree_oinfo, &rrc);
> diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
> index 8b1a8389d32f..043be93c7148 100644
> --- a/fs/xfs/scrub/rtrmap.c
> +++ b/fs/xfs/scrub/rtrmap.c
> @@ -244,7 +244,6 @@ int
>  xchk_rtrmapbt(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_inode	*ip = rtg_rmap(sc->sr.rtg);
>  	struct xfs_owner_info	oinfo;
>  	struct xchk_rtrmap	cr = { };
>  	int			error;
> @@ -253,7 +252,7 @@ xchk_rtrmapbt(
>  	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>  		return error;
>  
> -	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, XFS_DATA_FORK);
> +	xfs_rmap_inode_bmbt_owner(&oinfo, rtg_rmap(sc->sr.rtg), XFS_DATA_FORK);
>  	return xchk_btree(sc, sc->sr.rmap_cur, xchk_rtrmapbt_rec, &oinfo, &cr);
>  }
>  
> -- 
> 2.53.0
> 
> 
