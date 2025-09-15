Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E133BBA3D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757962538; cv=none; b=GTsqd+hE85tcvyrCTbQJKWSAc0wlR4DFnIhzZtge8K0U4MwHBsvHytIAe9f8kPgYzM4D2W/LWgkITnAVbbbYoMuZ8q8ic3OsYO9Pczy9pIetsRs9Fu/hcKiiOPxOCVipyuKOMCdT1TEQkIBB0guPqXITNIPcyDOfGf0ULtrJ0L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757962538; c=relaxed/simple;
	bh=n48qOh89Qlo+ByLxGpJQMXENJfIA2kSOr9M41FoUlLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHBd2m4qyAxmZRAAHJSzMXkMEiHFhyufrQPzDNuaJJ8KWbg7DWkj85aeO7NdJ0fN6Dx52kZ+Z2ENvcYYdFv+JNnYfdNFC1jQuv3yiHEdJHVvB4sjZFnVMWIzs0cVMkUtQHf0Wi9qTgwTZh6zmWHbxLl+EOnX5kpE2t7UPni5MfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgatR7IW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgatR7IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB87C4CEF1;
	Mon, 15 Sep 2025 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757962537;
	bh=n48qOh89Qlo+ByLxGpJQMXENJfIA2kSOr9M41FoUlLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgatR7IWqkiZ7SYBbMIIo1skSugmGbkTr06rGTnzofhdYAbjD+QKulpjz+wP/ysui
	 g0CVvlHy9tgLKELuZPx8/2dFfGmLso0qS8LF0rJxvQAXhXeL+HDWQRsaBSnc+bfzs3
	 qZQXP7zSyYSeEhHLbopbAyC72H0raeEFJIunPzNX7/en/YSLENTkcy33yWq9BjTeBQ
	 0lOURTmwxbIoJDBoATdtuIPbYFLc7kCqIYad2r92dEEjWSjydOOD/oCf7r6Ab6wPVP
	 z7m0zTvVerBWUHfXVSuaYJ+8b7/nZmQ0bj33bAM5EOg7ZU5wBnzTE/4eGj6G9VuIiA
	 fx38TXYrKmULg==
Date: Mon, 15 Sep 2025 11:55:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: remove the expr argument to XFS_TEST_ERROR
Message-ID: <20250915185536.GV8096@frogsfrogsfrogs>
References: <20250915133104.161037-1-hch@lst.de>
 <20250915133104.161037-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133104.161037-4-hch@lst.de>

On Mon, Sep 15, 2025 at 06:30:39AM -0700, Christoph Hellwig wrote:
> Don't pass expr to XFS_TEST_ERROR.  Most calls pass a constant false,
> and the places that do pass an expression become cleaner by moving it
> out.

Yeah, that expr argument has always struck me as kind of pointless.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c    |  7 +++----
>  fs/xfs/libxfs/xfs_alloc.c      |  5 ++---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  2 +-
>  fs/xfs/libxfs/xfs_bmap.c       | 17 ++++++++---------
>  fs/xfs/libxfs/xfs_btree.c      |  2 +-
>  fs/xfs/libxfs/xfs_da_btree.c   |  2 +-
>  fs/xfs/libxfs/xfs_dir2.c       |  2 +-
>  fs/xfs/libxfs/xfs_exchmaps.c   |  4 ++--
>  fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
>  fs/xfs/libxfs/xfs_inode_fork.c |  3 +--
>  fs/xfs/libxfs/xfs_metafile.c   |  2 +-
>  fs/xfs/libxfs/xfs_refcount.c   |  7 +++----
>  fs/xfs/libxfs/xfs_rmap.c       |  2 +-
>  fs/xfs/libxfs/xfs_rtbitmap.c   |  2 +-
>  fs/xfs/scrub/cow_repair.c      |  4 ++--
>  fs/xfs/scrub/repair.c          |  2 +-
>  fs/xfs/xfs_attr_item.c         |  2 +-
>  fs/xfs/xfs_buf.c               |  4 ++--
>  fs/xfs/xfs_error.c             |  5 ++---
>  fs/xfs/xfs_error.h             | 10 +++++-----
>  fs/xfs/xfs_inode.c             | 28 +++++++++++++---------------
>  fs/xfs/xfs_iomap.c             |  4 ++--
>  fs/xfs/xfs_log.c               |  8 ++++----
>  fs/xfs/xfs_trans_ail.c         |  2 +-
>  25 files changed, 62 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index fb79215a509d..8ac8230c3d3c 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -92,9 +92,8 @@ xfs_ag_resv_critical(
>  	trace_xfs_ag_resv_critical(pag, type, avail);
>  
>  	/* Critically low if less than 10% or max btree height remains. */
> -	return XFS_TEST_ERROR(avail < orig / 10 ||
> -			      avail < mp->m_agbtree_maxlevels,
> -			mp, XFS_ERRTAG_AG_RESV_CRITICAL);
> +	return avail < orig / 10 || avail < mp->m_agbtree_maxlevels ||
> +		XFS_TEST_ERROR(mp, XFS_ERRTAG_AG_RESV_CRITICAL);
>  }
>  
>  /*
> @@ -203,7 +202,7 @@ __xfs_ag_resv_init(
>  		return -EINVAL;
>  	}
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_AG_RESV_FAIL))
>  		error = -ENOSPC;
>  	else
>  		error = xfs_dec_fdblocks(mp, hidden_space, true);
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 000cc7f4a3ce..ad381c73abc4 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3321,7 +3321,7 @@ xfs_agf_read_verify(
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
>  		fa = xfs_agf_verify(bp);
> -		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
> +		if (fa || XFS_TEST_ERROR(mp, XFS_ERRTAG_ALLOC_READ_AGF))
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
>  }
> @@ -4019,8 +4019,7 @@ __xfs_free_extent(
>  	ASSERT(len != 0);
>  	ASSERT(type != XFS_AG_RESV_AGFL);
>  
> -	if (XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_FREE_EXTENT))
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_FREE_EXTENT))
>  		return -EIO;
>  
>  	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fddb55605e0c..8508c845b27e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1225,7 +1225,7 @@ xfs_attr3_leaf_to_node(
>  
>  	trace_xfs_attr_leaf_to_node(args);
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
>  		error = -EIO;
>  		goto out;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d954f9b8071f..17edc24d4bb0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3662,8 +3662,7 @@ xfs_bmap_btalloc(
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
>  
> -	if (unlikely(XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +	if (unlikely(XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
>  		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
>  	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
>  			xfs_inode_is_filestream(ap->ip))
> @@ -3849,7 +3848,7 @@ xfs_bmapi_read(
>  	}
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		return -EFSCORRUPTED;
>  	}
> @@ -4200,7 +4199,7 @@ xfs_bmapi_write(
>  			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		return -EFSCORRUPTED;
>  	}
> @@ -4545,7 +4544,7 @@ xfs_bmapi_remap(
>  			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		return -EFSCORRUPTED;
>  	}
> @@ -5679,7 +5678,7 @@ xfs_bmap_collapse_extents(
>  	int			logflags = 0;
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		return -EFSCORRUPTED;
>  	}
> @@ -5795,7 +5794,7 @@ xfs_bmap_insert_extents(
>  	int			logflags = 0;
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		return -EFSCORRUPTED;
>  	}
> @@ -5900,7 +5899,7 @@ xfs_bmap_split_extent(
>  	int				i = 0;
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		return -EFSCORRUPTED;
>  	}
> @@ -6065,7 +6064,7 @@ xfs_bmap_finish_one(
>  
>  	trace_xfs_bmap_deferred(bi);
>  
> -	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_BMAP_FINISH_ONE))
> +	if (XFS_TEST_ERROR(tp->t_mountp, XFS_ERRTAG_BMAP_FINISH_ONE))
>  		return -EIO;
>  
>  	switch (bi->bi_type) {
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index a61211d253f1..dbe9df8c3300 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -306,7 +306,7 @@ xfs_btree_check_block(
>  
>  	fa = __xfs_btree_check_block(cur, block, level, bp);
>  	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
> -	    XFS_TEST_ERROR(false, mp, xfs_btree_block_errtag(cur))) {
> +	    XFS_TEST_ERROR(mp, xfs_btree_block_errtag(cur))) {
>  		if (bp)
>  			trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_btree_mark_sick(cur);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 723a0643b838..90f7fc219fcc 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -565,7 +565,7 @@ xfs_da3_split(
>  
>  	trace_xfs_da_split(state->args);
>  
> -	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
> +	if (XFS_TEST_ERROR(state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 1775abcfa04d..82a338458a51 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -223,7 +223,7 @@ xfs_dir_ino_validate(
>  	bool		ino_ok = xfs_verify_dir_ino(mp, ino);
>  
>  	if (XFS_IS_CORRUPT(mp, !ino_ok) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DIR_INO_VALIDATE)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_DIR_INO_VALIDATE)) {
>  		xfs_warn(mp, "Invalid inode number 0x%Lx",
>  				(unsigned long long) ino);
>  		return -EFSCORRUPTED;
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 3f1d6a98c118..932ee4619e9e 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -616,7 +616,7 @@ xfs_exchmaps_finish_one(
>  			return error;
>  	}
>  
> -	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
> +	if (XFS_TEST_ERROR(tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
>  		return -EIO;
>  
>  	/* If we still have work to do, ask for a new transaction. */
> @@ -882,7 +882,7 @@ xmi_ensure_delta_nextents(
>  				&new_nextents))
>  		return -EFBIG;
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
>  	    new_nextents > 10)
>  		return -EFBIG;
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 750111634d9f..ca57a4e5ced9 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2706,7 +2706,7 @@ xfs_agi_read_verify(
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
>  		fa = xfs_agi_verify(bp);
> -		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_IALLOC_READ_AGI))
> +		if (fa || XFS_TEST_ERROR(mp, XFS_ERRTAG_IALLOC_READ_AGI))
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index aa13fc00afd7..b1812b2c3cce 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -61,8 +61,8 @@ xfs_inode_buf_verify(
>  		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
>  			xfs_dinode_good_version(mp, dip->di_version) &&
>  			xfs_verify_agino_or_null(bp->b_pag, unlinked_ino);
> -		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> -						XFS_ERRTAG_ITOBP_INOTOBP))) {
> +		if (unlikely(!di_ok ||
> +				XFS_TEST_ERROR(mp, XFS_ERRTAG_ITOBP_INOTOBP))) {
>  			if (readahead) {
>  				bp->b_flags &= ~XBF_DONE;
>  				xfs_buf_ioerror(bp, -EIO);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 4f99b90add55..1772d82f2d68 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -756,8 +756,7 @@ xfs_iext_count_extend(
>  	if (nr_exts < ifp->if_nextents)
>  		return -EFBIG;
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
> -	    nr_exts > 10)
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) && nr_exts > 10)
>  		return -EFBIG;
>  
>  	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
> diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
> index 225923e463c4..b02e3d6c0868 100644
> --- a/fs/xfs/libxfs/xfs_metafile.c
> +++ b/fs/xfs/libxfs/xfs_metafile.c
> @@ -121,7 +121,7 @@ xfs_metafile_resv_critical(
>  			div_u64(mp->m_metafile_resv_target, 10)))
>  		return true;
>  
> -	return XFS_TEST_ERROR(false, mp, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
> +	return XFS_TEST_ERROR(mp, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
>  }
>  
>  /* Allocate a block from the metadata file's reservation. */
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 897784037483..2484dc9f6d7e 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1113,8 +1113,7 @@ xfs_refcount_still_have_space(
>  	 * refcount continue update "error" has been injected.
>  	 */
>  	if (cur->bc_refc.nr_ops > 2 &&
> -	    XFS_TEST_ERROR(false, cur->bc_mp,
> -			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
> +	    XFS_TEST_ERROR(cur->bc_mp, XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
>  		return false;
>  
>  	if (cur->bc_refc.nr_ops == 0)
> @@ -1398,7 +1397,7 @@ xfs_refcount_finish_one(
>  
>  	trace_xfs_refcount_deferred(mp, ri);
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
>  		return -EIO;
>  
>  	/*
> @@ -1511,7 +1510,7 @@ xfs_rtrefcount_finish_one(
>  
>  	trace_xfs_refcount_deferred(mp, ri);
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 3cdf50563fec..83e0488ff773 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2690,7 +2690,7 @@ xfs_rmap_finish_one(
>  
>  	trace_xfs_rmap_deferred(mp, ri);
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_RMAP_FINISH_ONE))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 5057536e586c..618061d898d4 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1067,7 +1067,7 @@ xfs_rtfree_extent(
>  	ASSERT(rbmip->i_itemp != NULL);
>  	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
>  
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_FREE_EXTENT))
>  		return -EIO;
>  
>  	error = xfs_rtcheck_alloc_range(&args, start, len);
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index 38a246b8bf11..b2a83801412e 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -300,7 +300,7 @@ xrep_cow_find_bad(
>  	 * on the debugging knob, replace everything in the CoW fork.
>  	 */
>  	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
> -	    XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
> +	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
>  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
>  				xc->irec.br_blockcount);
>  		if (error)
> @@ -385,7 +385,7 @@ xrep_cow_find_bad_rt(
>  	 * CoW fork and then scan for staging extents in the refcountbt.
>  	 */
>  	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
> -	    XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
> +	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
>  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
>  				xc->irec.br_blockcount);
>  		if (error)
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index d00c18954a26..efd5a7ccdf62 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1110,7 +1110,7 @@ xrep_will_attempt(
>  		return true;
>  
>  	/* Let debug users force us into the repair routines. */
> -	if (XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
> +	if (XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
>  		return true;
>  
>  	/* Metadata is corrupt or failed cross-referencing. */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5eef3bc30bda..c3a593319bee 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -491,7 +491,7 @@ xfs_attr_finish_item(
>  	/* Reset trans after EAGAIN cycle since the transaction is new */
>  	args->trans = tp;
>  
> -	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
> +	if (XFS_TEST_ERROR(args->dp->i_mount, XFS_ERRTAG_LARP)) {
>  		error = -EIO;
>  		goto out;
>  	}
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..8360e77b3215 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1299,7 +1299,7 @@ xfs_buf_bio_end_io(
>  	if (bio->bi_status)
>  		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
>  	else if ((bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> -		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
> +		 XFS_TEST_ERROR(bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
>  		xfs_buf_ioerror(bp, -EIO);
>  
>  	if (bp->b_flags & XBF_ASYNC) {
> @@ -2084,7 +2084,7 @@ void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
>  	 * This allows userspace to disrupt buffer caching for debug/testing
>  	 * purposes.
>  	 */
> -	if (XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_LRU_REF))
> +	if (XFS_TEST_ERROR(bp->b_mount, XFS_ERRTAG_BUF_LRU_REF))
>  		lru_ref = 0;
>  
>  	atomic_set(&bp->b_lru_ref, lru_ref);
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index fac35ff3da65..44dd8aba0097 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -291,7 +291,6 @@ xfs_errortag_enabled(
>  bool
>  xfs_errortag_test(
>  	struct xfs_mount	*mp,
> -	const char		*expression,
>  	const char		*file,
>  	int			line,
>  	unsigned int		error_tag)
> @@ -317,8 +316,8 @@ xfs_errortag_test(
>  		return false;
>  
>  	xfs_warn_ratelimited(mp,
> -"Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
> -			expression, file, line, mp->m_super->s_id);
> +"Injecting error at file %s, line %d, on filesystem \"%s\"",
> +			file, line, mp->m_super->s_id);
>  	return true;
>  }
>  
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index fd60a008f9d2..8429c1ee86e7 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -41,10 +41,10 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
>  #ifdef DEBUG
>  extern int xfs_errortag_init(struct xfs_mount *mp);
>  extern void xfs_errortag_del(struct xfs_mount *mp);
> -extern bool xfs_errortag_test(struct xfs_mount *mp, const char *expression,
> -		const char *file, int line, unsigned int error_tag);
> -#define XFS_TEST_ERROR(expr, mp, tag)		\
> -	((expr) || xfs_errortag_test((mp), #expr, __FILE__, __LINE__, (tag)))
> +bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
> +		unsigned int error_tag);
> +#define XFS_TEST_ERROR(mp, tag)		\
> +	xfs_errortag_test((mp), __FILE__, __LINE__, (tag))
>  bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
>  #define XFS_ERRORTAG_DELAY(mp, tag)		\
>  	do { \
> @@ -63,7 +63,7 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #else
>  #define xfs_errortag_init(mp)			(0)
>  #define xfs_errortag_del(mp)
> -#define XFS_TEST_ERROR(expr, mp, tag)		(expr)
> +#define XFS_TEST_ERROR(mp, tag)			(false)
>  #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
>  #define xfs_errortag_add(mp, tag)		(ENOSYS)
>  #define xfs_errortag_clearall(mp)		(ENOSYS)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9c39251961a3..5940faefe522 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2377,8 +2377,8 @@ xfs_iflush(
>  	 * error handling as the caller will shutdown and fail the buffer.
>  	 */
>  	error = -EFSCORRUPTED;
> -	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
> -			       mp, XFS_ERRTAG_IFLUSH_1)) {
> +	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC) ||
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_1)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: Bad inode %llu magic number 0x%x, ptr "PTR_FMT,
>  			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
> @@ -2394,29 +2394,27 @@ xfs_iflush(
>  			goto flush_out;
>  		}
>  	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
> -		if (XFS_TEST_ERROR(
> -		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> -		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE,
> -		    mp, XFS_ERRTAG_IFLUSH_3)) {
> +		if ((ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> +		     ip->i_df.if_format != XFS_DINODE_FMT_BTREE) ||
> +		    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_3)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad regular inode %llu, ptr "PTR_FMT,
>  				__func__, ip->i_ino, ip);
>  			goto flush_out;
>  		}
>  	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
> -		if (XFS_TEST_ERROR(
> -		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> -		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE &&
> -		    ip->i_df.if_format != XFS_DINODE_FMT_LOCAL,
> -		    mp, XFS_ERRTAG_IFLUSH_4)) {
> +		if ((ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> +		     ip->i_df.if_format != XFS_DINODE_FMT_BTREE &&
> +		     ip->i_df.if_format != XFS_DINODE_FMT_LOCAL) ||
> +		    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_4)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad directory inode %llu, ptr "PTR_FMT,
>  				__func__, ip->i_ino, ip);
>  			goto flush_out;
>  		}
>  	}
> -	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(&ip->i_af) >
> -				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
> +	if (ip->i_df.if_nextents + xfs_ifork_nextents(&ip->i_af) >
> +	    ip->i_nblocks || XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %llu, "
>  			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
> @@ -2425,8 +2423,8 @@ xfs_iflush(
>  			ip->i_nblocks, ip);
>  		goto flush_out;
>  	}
> -	if (XFS_TEST_ERROR(ip->i_forkoff > mp->m_sb.sb_inodesize,
> -				mp, XFS_ERRTAG_IFLUSH_6)) {
> +	if (ip->i_forkoff > mp->m_sb.sb_inodesize ||
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_6)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: bad inode %llu, forkoff 0x%x, ptr "PTR_FMT,
>  			__func__, ip->i_ino, ip->i_forkoff, ip);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 2a74f2957341..2570d0a66047 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1554,7 +1554,7 @@ xfs_zoned_buffered_write_iomap_begin(
>  		return error;
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  		error = -EFSCORRUPTED;
>  		goto out_unlock;
> @@ -1728,7 +1728,7 @@ xfs_buffered_write_iomap_begin(
>  		return error;
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  		error = -EFSCORRUPTED;
>  		goto out_unlock;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c8a57e21a1d3..6e6442b0543c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -969,8 +969,8 @@ xfs_log_unmount_write(
>  	 * counters will be recalculated.  Refer to xlog_check_unmount_rec for
>  	 * more details.
>  	 */
> -	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
> -			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
> +	if (xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS) ||
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
>  		xfs_alert(mp, "%s: will fix summary counters at next mount",
>  				__func__);
>  		return;
> @@ -1240,7 +1240,7 @@ xlog_ioend_work(
>  	/*
>  	 * Race to shutdown the filesystem if we see an error.
>  	 */
> -	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
> +	if (error || XFS_TEST_ERROR(log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
>  		xfs_alert(log->l_mp, "log I/O error %d", error);
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	}
> @@ -1827,7 +1827,7 @@ xlog_sync(
>  	 * detects the bad CRC and attempts to recover.
>  	 */
>  #ifdef DEBUG
> -	if (XFS_TEST_ERROR(false, log->l_mp, XFS_ERRTAG_LOG_BAD_CRC)) {
> +	if (XFS_TEST_ERROR(log->l_mp, XFS_ERRTAG_LOG_BAD_CRC)) {
>  		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
>  		iclog->ic_fail_crc = true;
>  		xfs_warn(log->l_mp,
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 67c328d23e4a..38983c6777df 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -374,7 +374,7 @@ xfsaild_push_item(
>  	 * If log item pinning is enabled, skip the push and track the item as
>  	 * pinned. This can help induce head-behind-tail conditions.
>  	 */
> -	if (XFS_TEST_ERROR(false, ailp->ail_log->l_mp, XFS_ERRTAG_LOG_ITEM_PIN))
> +	if (XFS_TEST_ERROR(ailp->ail_log->l_mp, XFS_ERRTAG_LOG_ITEM_PIN))
>  		return XFS_ITEM_PINNED;
>  
>  	/*
> -- 
> 2.47.2
> 
> 
