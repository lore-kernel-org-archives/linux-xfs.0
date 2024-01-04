Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69404382
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 01:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9uc4VXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E47C433C7;
	Thu,  4 Jan 2024 01:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704330619;
	bh=otWx+mrPYpJqBuS/3OgGRiDJDqo1vt3bfPXjZkuBgkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I9uc4VXrYuhx/M6IN69oMmnCy2Q3nEEpykRFIT9Nvk7sVdGiB9GMpaQ7bE+LLGIkd
	 w9FCDaqxLKpy8bjyZLeansP84pY2jmXSpH43Wi8T43Y4y0Ew08aS8HYs63aq9cPGDq
	 RwLA0cL7VAQPfEqvMz1dMmmCnT7fnxB/YyOozyyFcheHuWxBByK4lEdakrHe8zHLBA
	 FQ/JNsbDmYVP27O6RD1gZIosHtT6B0SDdt4GyHjbMzcMe4jGVrPTQFXYOC2msXjLRJ
	 8RToiLI3Xd4ryxbJkQUK24YqDEyMQTRxEzLJOSA0mOHBi7TVDyOUwaNRZKOa/qDUq0
	 qQKzZRS/qMwSw==
Date: Wed, 3 Jan 2024 17:10:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove bc_ino.flags
Message-ID: <20240104011019.GK361584@frogsfrogsfrogs>
References: <20240103203836.608391-1-hch@lst.de>
 <20240103203836.608391-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103203836.608391-4-hch@lst.de>

On Wed, Jan 03, 2024 at 09:38:34PM +0100, Christoph Hellwig wrote:
> Just move the two flags into bc_flags where there is plenty of space.

Heh, and I just got rid of all the XFS_BTREE_ flags except for one.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c             | 27 +++++++++------------------
>  fs/xfs/libxfs/xfs_bmap_btree.c       | 14 ++++----------
>  fs/xfs/libxfs/xfs_btree.c            |  2 +-
>  fs/xfs/libxfs/xfs_btree.h            | 12 ++++++------
>  fs/xfs/libxfs/xfs_rtrefcount_btree.c | 10 +---------
>  fs/xfs/libxfs/xfs_rtrmap_btree.c     | 10 +---------
>  6 files changed, 22 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b14761ec96b87a..d6b62884401c0f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -643,7 +643,8 @@ xfs_bmap_extents_to_btree(
>  	 */
>  	xfs_bmbt_iroot_alloc(ip, whichfork);
>  	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
> +	if (wasdel)
> +		cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
>  	/*
>  	 * Convert to a btree with two levels, one record in root.
>  	 */
> @@ -1426,8 +1427,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  	ASSERT(whichfork != XFS_ATTR_FORK);
>  	ASSERT(!isnullstartblock(new->br_startblock));
> -	ASSERT(!bma->cur ||
> -	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
> +	ASSERT(!bma->cur || (bma->cur->bc_flags & XFS_BTREE_BMBT_WASDEL));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> @@ -2686,7 +2686,7 @@ xfs_bmap_add_extent_hole_real(
>  	struct xfs_bmbt_irec	old;
>  
>  	ASSERT(!isnullstartblock(new->br_startblock));
> -	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
> +	ASSERT(!cur || !(cur->bc_flags & XFS_BTREE_BMBT_WASDEL));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> @@ -4223,9 +4223,8 @@ xfs_bmapi_allocate(
>  	 */
>  	bma->nallocs++;
>  
> -	if (bma->cur)
> -		bma->cur->bc_ino.flags =
> -			bma->wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
> +	if (bma->cur && bma->wasdel)
> +		bma->cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
>  
>  	bma->got.br_startoff = bma->offset;
>  	bma->got.br_startblock = bma->blkno;
> @@ -4762,10 +4761,8 @@ xfs_bmapi_remap(
>  	ip->i_nblocks += len;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_ino.flags = 0;
> -	}
>  
>  	got.br_startoff = bno;
>  	got.br_startblock = startblock;
> @@ -5413,7 +5410,6 @@ __xfs_bunmapi(
>  	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_ino.flags = 0;
>  	} else
>  		cur = NULL;
>  
> @@ -5872,10 +5868,8 @@ xfs_bmap_collapse_extents(
>  	if (error)
>  		return error;
>  
> -	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_ino.flags = 0;
> -	}
>  
>  	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
>  		*done = true;
> @@ -5989,10 +5983,8 @@ xfs_bmap_insert_extents(
>  	if (error)
>  		return error;
>  
> -	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_ino.flags = 0;
> -	}
>  
>  	if (*next_fsb == NULLFSBLOCK) {
>  		xfs_iext_last(ifp, &icur);
> @@ -6109,7 +6101,6 @@ xfs_bmap_split_extent(
>  
>  	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_ino.flags = 0;
>  		error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  		if (error)
>  			goto del_cursor;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index a6de8b7528aa1c..99b86bbf23c957 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -169,13 +169,8 @@ xfs_bmbt_dup_cursor(
>  
>  	new = xfs_bmbt_init_cursor(cur->bc_mp, cur->bc_tp,
>  			cur->bc_ino.ip, cur->bc_ino.whichfork);
> -
> -	/*
> -	 * Copy the firstblock, dfops, and flags values,
> -	 * since init cursor doesn't get them.
> -	 */
> -	new->bc_ino.flags = cur->bc_ino.flags;
> -
> +	new->bc_flags |= (cur->bc_flags &
> +		(XFS_BTREE_BMBT_INVALID_OWNER | XFS_BTREE_BMBT_WASDEL));
>  	return new;
>  }
>  
> @@ -209,7 +204,7 @@ xfs_bmbt_alloc_block(
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
>  			cur->bc_ino.whichfork);
>  	args.minlen = args.maxlen = args.prod = 1;
> -	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
> +	args.wasdel = cur->bc_flags & XFS_BTREE_BMBT_WASDEL;
>  	if (!args.wasdel && args.tp->t_blk_res == 0)
>  		return -ENOSPC;
>  
> @@ -608,7 +603,6 @@ xfs_bmbt_init_common(
>  
>  	cur->bc_ino.ip = ip;
>  	cur->bc_ino.allocated = 0;
> -	cur->bc_ino.flags = 0;
>  
>  	return cur;
>  }
> @@ -799,7 +793,7 @@ xfs_bmbt_change_owner(
>  	ASSERT(xfs_ifork_ptr(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
>  
>  	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
> -	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
> +	cur->bc_flags |= XFS_BTREE_BMBT_INVALID_OWNER;
>  
>  	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
>  	xfs_btree_del_cursor(cur, error);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index be484f86da9859..3bc8aa6049b9a7 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1888,7 +1888,7 @@ xfs_btree_check_block_owner(
>  		return NULL;
>  	}
>  
> -	if (cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER)
> +	if (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER)
>  		return NULL;
>  
>  	if (be64_to_cpu(block->bb_u.l.bb_owner) != cur->bc_ino.ip->i_ino)
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 503f51ef22f81e..05a4572ce44dd2 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -257,12 +257,6 @@ struct xfs_btree_cur_ino {
>  	int				allocated;
>  	short				forksize;
>  	char				whichfork;
> -	char				flags;
> -/* We are converting a delalloc reservation */
> -#define	XFS_BTCUR_BMBT_WASDEL		(1 << 0)
> -
> -/* For extent swap, ignore owner check in verifier */
> -#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
>  	struct xbtree_refc		refc;
>  };
>  
> @@ -353,6 +347,12 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
>  # define XFS_BTREE_IN_XFILE		(0)
>  #endif
>  
> +/* We are converting a delalloc reservation (only for bmbt btrees) */
> +#define	XFS_BTREE_BMBT_WASDEL		(1 << 8)
> +
> +/* For extent swap, ignore owner check in verifier (only for bmbt btrees) */
> +#define	XFS_BTREE_BMBT_INVALID_OWNER	(1 << 9)
> +
>  #define	XFS_BTREE_NOERROR	0
>  #define	XFS_BTREE_ERROR		1
>  
> diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
> index 47ce0acd92a19d..89fa7dcf1225c2 100644
> --- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
> @@ -45,15 +45,8 @@ static struct xfs_btree_cur *
>  xfs_rtrefcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
> -	struct xfs_btree_cur	*new;
> -
> -	new = xfs_rtrefcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
> +	return xfs_rtrefcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
>  			cur->bc_ino.rtg, cur->bc_ino.ip);
> -
> -	/* Copy the flags values since init cursor doesn't get them. */
> -	new->bc_ino.flags = cur->bc_ino.flags;
> -
> -	return new;
>  }
>  
>  STATIC int
> @@ -398,7 +391,6 @@ xfs_rtrefcountbt_init_common(
>  
>  	cur->bc_ino.ip = ip;
>  	cur->bc_ino.allocated = 0;
> -	cur->bc_ino.flags = 0;
>  	cur->bc_ino.refc.nr_ops = 0;
>  	cur->bc_ino.refc.shape_changes = 0;
>  
> diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> index 3b105e2da8468d..95983dc081fa21 100644
> --- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> @@ -48,15 +48,8 @@ static struct xfs_btree_cur *
>  xfs_rtrmapbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
> -	struct xfs_btree_cur	*new;
> -
> -	new = xfs_rtrmapbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ino.rtg,
> +	return xfs_rtrmapbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ino.rtg,
>  			cur->bc_ino.ip);
> -
> -	/* Copy the flags values since init cursor doesn't get them. */
> -	new->bc_ino.flags = cur->bc_ino.flags;
> -
> -	return new;
>  }
>  
>  STATIC int
> @@ -518,7 +511,6 @@ xfs_rtrmapbt_init_common(
>  
>  	cur->bc_ino.ip = ip;
>  	cur->bc_ino.allocated = 0;
> -	cur->bc_ino.flags = 0;
>  
>  	cur->bc_ino.rtg = xfs_rtgroup_hold(rtg);
>  	return cur;
> -- 
> 2.39.2
> 
> 
