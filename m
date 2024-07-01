Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAB72F29;
	Mon,  1 Jul 2024 23:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719877352; cv=none; b=dWzM6zPivsbONSAdv0+/ySs1FIof2v9JULXRpNgTPVmSAQSHTQdIUQWkdJhEajaaArQIzp9p67buqjIv7tFIv2Y3B17WVmMpGXI7Yc/hBTIqXCs1kLDfPltVbr4DuTv67vEYTuo4Y92DbhtQz40dkStPoY8LivEeyfOHkbIjsf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719877352; c=relaxed/simple;
	bh=rxTAODphPpBD4Fjom5sHwur5wVQ6Qe5/92gENnZr5kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oy7OLc79DIbp2HhUr1BlwhO+B5F9bwRXVGYn1fth9PG7PNFbqOWyRS2hJnOndW+TdMt2RBbuPAcMbI7KWO5G1Jsm9RBKldoIcx1JpkWSCfHcI4arqf8vSRNdziid3WcmsuYSiShuWNZ0eUfYN4IIabxSnaD6lCDCpRQrCVU/pIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0EeKCNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0EeKCNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86F3C116B1;
	Mon,  1 Jul 2024 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719877351;
	bh=rxTAODphPpBD4Fjom5sHwur5wVQ6Qe5/92gENnZr5kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F0EeKCNeQm/IyrcLP2tluQsnMLGqqdlf/1EUv4Gl2ndx4i/hCla1hIk1RojCXCLxY
	 Y4YyBn+hIVMeHow8PNW8RxWQS5Ps+WHMeuA+w3Dvh1Xc7ZlPL1Ys4ps0B7qLEmp8cg
	 dhGgTR5ahhq5tCkRDgFUidJhh2285/1bYPk3NDlFqJUrjNJUCe7DOOAAjaGUDA9A58
	 Gcip5RBGZwDqLoYMt6MjiQ5h1S56QZiAU7Mlp5CNVE6sDaEflLd9oskqc1Po0qXL7l
	 e5OZUiv86zsSl0ks+9q7pRfDSi2Qv80A4ygcGPN+bxqowJ4YQ5iC/5RZhVExifNc1I
	 UA6LpItkouKKQ==
Date: Mon, 1 Jul 2024 16:42:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V5] xfs: Avoid races with cnt_btree lastrec updates
Message-ID: <20240701234231.GI612460@frogsfrogsfrogs>
References: <20240701060236.2221400-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701060236.2221400-1-wozizhi@huawei.com>

On Mon, Jul 01, 2024 at 02:02:36PM +0800, Zizhi Wo wrote:
> A concurrent file creation and little writing could unexpectedly return
> -ENOSPC error since there is a race window that the allocator could get
> the wrong agf->agf_longest.
> 
> Write file process steps:
> 1) Find the entry that best meets the conditions, then calculate the start
>    address and length of the remaining part of the entry after allocation.
> 2) Delete this entry and update the -current- agf->agf_longest.
> 3) Insert the remaining unused parts of this entry based on the
>    calculations in 1), and update the agf->agf_longest again if necessary.
> 
> Create file process steps:
> 1) Check whether there are free inodes in the inode chunk.
> 2) If there is no free inode, check whether there has space for creating
>    inode chunks, perform the no-lock judgment first.
> 3) If the judgment succeeds, the judgment is performed again with agf lock
>    held. Otherwire, an error is returned directly.
> 
> If the write process is in step 2) but not go to 3) yet, the create file
> process goes to 2) at this time, it may be mistaken for no space,
> resulting in the file system still has space but the file creation fails.
> 
> We have sent two different commits to the community in order to fix this
> problem[1][2]. Unfortunately, both solutions have flaws. In [2], I
> discussed with Dave and Darrick, realized that a better solution to this
> problem requires the "last cnt record tracking" to be ripped out of the
> generic btree code. And surprisingly, Dave directly provided his fix code.
> This patch includes appropriate modifications based on his tmp-code to
> address this issue.
> 
> The entire fix can be roughly divided into two parts:
> 1) Delete the code related to lastrec-update in the generic btree code.
> 2) Place the process of updating longest freespace with cntbt separately
>    to the end of the cntbt modifications. Move the cursor to the rightmost
>    firstly, and update the longest free extent based on the record.
> 
> Note that we can not update the longest with xfs_alloc_get_rec() after
> find the longest record, as xfs_verify_agbno() may not pass because
> pag->block_count is updated on the outside. Therefore, use
> xfs_btree_get_rec() as a replacement.
> 
> [1] https://lore.kernel.org/all/20240419061848.1032366-2-yebin10@huawei.com
> [2] https://lore.kernel.org/all/20240604071121.3981686-1-wozizhi@huawei.com
> 
> Reported by: Ye Bin <yebin10@huawei.com>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 114 ++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  64 ------------------
>  fs/xfs/libxfs/xfs_btree.c       |  51 --------------
>  fs/xfs/libxfs/xfs_btree.h       |  16 +----
>  4 files changed, 115 insertions(+), 130 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6c55a6e88eba..88fceb7ef946 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -465,6 +465,97 @@ xfs_alloc_fix_len(
>  	args->len = rlen;
>  }
>  
> +/*
> + * Determine if the cursor points to the block that contains the right-most
> + * block of records in the by-count btree. This block contains the largest
> + * contiguous free extent in the AG, so if we modify a record in this block we
> + * need to call xfs_alloc_fixup_longest() once the modifications are done to
> + * ensure the agf->agf_longest field is kept up to date with the longest free
> + * extent tracked by the by-count btree.
> + */
> +static bool
> +xfs_alloc_cursor_at_lastrec(
> +	struct xfs_btree_cur	*cnt_cur)
> +{
> +	struct xfs_btree_block	*block;
> +	union xfs_btree_ptr	ptr;
> +	struct xfs_buf		*bp;
> +
> +	block = xfs_btree_get_block(cnt_cur, 0, &bp);
> +
> +	xfs_btree_get_sibling(cnt_cur, block, &ptr, XFS_BB_RIGHTSIB);
> +	return xfs_btree_ptr_is_null(cnt_cur, &ptr);
> +}
> +
> +/*
> + * Find the rightmost record of the cntbt, and return the longest free space
> + * recorded in it. Simply set both the block number and the length to their
> + * maximum values before searching.
> + */
> +static int
> +xfs_cntbt_longest(
> +	struct xfs_btree_cur	*cnt_cur,
> +	xfs_extlen_t		*longest)
> +{
> +	struct xfs_alloc_rec_incore irec;
> +	union xfs_btree_rec	    *rec;
> +	int			    stat = 0;
> +	int			    error;
> +
> +	memset(&cnt_cur->bc_rec, 0xFF, sizeof(cnt_cur->bc_rec));
> +	error = xfs_btree_lookup(cnt_cur, XFS_LOOKUP_LE, &stat);
> +	if (error)
> +		return error;
> +	if (!stat) {
> +		/* totally empty tree */
> +		*longest = 0;
> +		return 0;
> +	}
> +
> +	error = xfs_btree_get_rec(cnt_cur, &rec, &stat);
> +	if (error)
> +		return error;
> +	if (XFS_IS_CORRUPT(cnt_cur->bc_mp, !stat)) {

Yeah, thanks for correcting that.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		xfs_btree_mark_sick(cnt_cur);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	xfs_alloc_btrec_to_irec(rec, &irec);
> +	*longest = irec.ar_blockcount;
> +	return 0;
> +}
> +
> +/*
> + * Update the longest contiguous free extent in the AG from the by-count cursor
> + * that is passed to us. This should be done at the end of any allocation or
> + * freeing operation that touches the longest extent in the btree.
> + *
> + * Needing to update the longest extent can be determined by calling
> + * xfs_alloc_cursor_at_lastrec() after the cursor is positioned for record
> + * modification but before the modification begins.
> + */
> +static int
> +xfs_alloc_fixup_longest(
> +	struct xfs_btree_cur	*cnt_cur)
> +{
> +	struct xfs_perag	*pag = cnt_cur->bc_ag.pag;
> +	struct xfs_buf		*bp = cnt_cur->bc_ag.agbp;
> +	struct xfs_agf		*agf = bp->b_addr;
> +	xfs_extlen_t		longest = 0;
> +	int			error;
> +
> +	/* Lookup last rec in order to update AGF. */
> +	error = xfs_cntbt_longest(cnt_cur, &longest);
> +	if (error)
> +		return error;
> +
> +	pag->pagf_longest = longest;
> +	agf->agf_longest = cpu_to_be32(pag->pagf_longest);
> +	xfs_alloc_log_agf(cnt_cur->bc_tp, bp, XFS_AGF_LONGEST);
> +
> +	return 0;
> +}
> +
>  /*
>   * Update the two btrees, logically removing from freespace the extent
>   * starting at rbno, rlen blocks.  The extent is contained within the
> @@ -489,6 +580,7 @@ xfs_alloc_fixup_trees(
>  	xfs_extlen_t	nflen1=0;	/* first new free length */
>  	xfs_extlen_t	nflen2=0;	/* second new free length */
>  	struct xfs_mount *mp;
> +	bool		fixup_longest = false;
>  
>  	mp = cnt_cur->bc_mp;
>  
> @@ -577,6 +669,10 @@ xfs_alloc_fixup_trees(
>  		nfbno2 = rbno + rlen;
>  		nflen2 = (fbno + flen) - nfbno2;
>  	}
> +
> +	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
> +		fixup_longest = true;
> +
>  	/*
>  	 * Delete the entry from the by-size btree.
>  	 */
> @@ -654,6 +750,10 @@ xfs_alloc_fixup_trees(
>  			return -EFSCORRUPTED;
>  		}
>  	}
> +
> +	if (fixup_longest)
> +		return xfs_alloc_fixup_longest(cnt_cur);
> +
>  	return 0;
>  }
>  
> @@ -1956,6 +2056,7 @@ xfs_free_ag_extent(
>  	int				i;
>  	int				error;
>  	struct xfs_perag		*pag = agbp->b_pag;
> +	bool				fixup_longest = false;
>  
>  	bno_cur = cnt_cur = NULL;
>  	mp = tp->t_mountp;
> @@ -2219,8 +2320,13 @@ xfs_free_ag_extent(
>  	}
>  	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
>  	bno_cur = NULL;
> +
>  	/*
>  	 * In all cases we need to insert the new freespace in the by-size tree.
> +	 *
> +	 * If this new freespace is being inserted in the block that contains
> +	 * the largest free space in the btree, make sure we also fix up the
> +	 * agf->agf-longest tracker field.
>  	 */
>  	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
>  		goto error0;
> @@ -2229,6 +2335,8 @@ xfs_free_ag_extent(
>  		error = -EFSCORRUPTED;
>  		goto error0;
>  	}
> +	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
> +		fixup_longest = true;
>  	if ((error = xfs_btree_insert(cnt_cur, &i)))
>  		goto error0;
>  	if (XFS_IS_CORRUPT(mp, i != 1)) {
> @@ -2236,6 +2344,12 @@ xfs_free_ag_extent(
>  		error = -EFSCORRUPTED;
>  		goto error0;
>  	}
> +	if (fixup_longest) {
> +		error = xfs_alloc_fixup_longest(cnt_cur);
> +		if (error)
> +			goto error0;
> +	}
> +
>  	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  	cnt_cur = NULL;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 6ef5ddd89600..585e98e87ef9 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -115,67 +115,6 @@ xfs_allocbt_free_block(
>  	return 0;
>  }
>  
> -/*
> - * Update the longest extent in the AGF
> - */
> -STATIC void
> -xfs_allocbt_update_lastrec(
> -	struct xfs_btree_cur		*cur,
> -	const struct xfs_btree_block	*block,
> -	const union xfs_btree_rec	*rec,
> -	int				ptr,
> -	int				reason)
> -{
> -	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
> -	struct xfs_perag	*pag;
> -	__be32			len;
> -	int			numrecs;
> -
> -	ASSERT(!xfs_btree_is_bno(cur->bc_ops));
> -
> -	switch (reason) {
> -	case LASTREC_UPDATE:
> -		/*
> -		 * If this is the last leaf block and it's the last record,
> -		 * then update the size of the longest extent in the AG.
> -		 */
> -		if (ptr != xfs_btree_get_numrecs(block))
> -			return;
> -		len = rec->alloc.ar_blockcount;
> -		break;
> -	case LASTREC_INSREC:
> -		if (be32_to_cpu(rec->alloc.ar_blockcount) <=
> -		    be32_to_cpu(agf->agf_longest))
> -			return;
> -		len = rec->alloc.ar_blockcount;
> -		break;
> -	case LASTREC_DELREC:
> -		numrecs = xfs_btree_get_numrecs(block);
> -		if (ptr <= numrecs)
> -			return;
> -		ASSERT(ptr == numrecs + 1);
> -
> -		if (numrecs) {
> -			xfs_alloc_rec_t *rrp;
> -
> -			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
> -			len = rrp->ar_blockcount;
> -		} else {
> -			len = 0;
> -		}
> -
> -		break;
> -	default:
> -		ASSERT(0);
> -		return;
> -	}
> -
> -	agf->agf_longest = len;
> -	pag = cur->bc_ag.agbp->b_pag;
> -	pag->pagf_longest = be32_to_cpu(len);
> -	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
> -}
> -
>  STATIC int
>  xfs_allocbt_get_minrecs(
>  	struct xfs_btree_cur	*cur,
> @@ -493,7 +432,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
>  	.set_root		= xfs_allocbt_set_root,
>  	.alloc_block		= xfs_allocbt_alloc_block,
>  	.free_block		= xfs_allocbt_free_block,
> -	.update_lastrec		= xfs_allocbt_update_lastrec,
>  	.get_minrecs		= xfs_allocbt_get_minrecs,
>  	.get_maxrecs		= xfs_allocbt_get_maxrecs,
>  	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
> @@ -511,7 +449,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
>  const struct xfs_btree_ops xfs_cntbt_ops = {
>  	.name			= "cnt",
>  	.type			= XFS_BTREE_TYPE_AG,
> -	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
>  
>  	.rec_len		= sizeof(xfs_alloc_rec_t),
>  	.key_len		= sizeof(xfs_alloc_key_t),
> @@ -525,7 +462,6 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
>  	.set_root		= xfs_allocbt_set_root,
>  	.alloc_block		= xfs_allocbt_alloc_block,
>  	.free_block		= xfs_allocbt_free_block,
> -	.update_lastrec		= xfs_allocbt_update_lastrec,
>  	.get_minrecs		= xfs_allocbt_get_minrecs,
>  	.get_maxrecs		= xfs_allocbt_get_maxrecs,
>  	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index d29547572a68..a5c4af148853 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1331,30 +1331,6 @@ xfs_btree_init_block_cur(
>  			xfs_btree_owner(cur));
>  }
>  
> -/*
> - * Return true if ptr is the last record in the btree and
> - * we need to track updates to this record.  The decision
> - * will be further refined in the update_lastrec method.
> - */
> -STATIC int
> -xfs_btree_is_lastrec(
> -	struct xfs_btree_cur	*cur,
> -	struct xfs_btree_block	*block,
> -	int			level)
> -{
> -	union xfs_btree_ptr	ptr;
> -
> -	if (level > 0)
> -		return 0;
> -	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LASTREC_UPDATE))
> -		return 0;
> -
> -	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
> -	if (!xfs_btree_ptr_is_null(cur, &ptr))
> -		return 0;
> -	return 1;
> -}
> -
>  STATIC void
>  xfs_btree_buf_to_ptr(
>  	struct xfs_btree_cur	*cur,
> @@ -2420,15 +2396,6 @@ xfs_btree_update(
>  	xfs_btree_copy_recs(cur, rp, rec, 1);
>  	xfs_btree_log_recs(cur, bp, ptr, ptr);
>  
> -	/*
> -	 * If we are tracking the last record in the tree and
> -	 * we are at the far right edge of the tree, update it.
> -	 */
> -	if (xfs_btree_is_lastrec(cur, block, 0)) {
> -		cur->bc_ops->update_lastrec(cur, block, rec,
> -					    ptr, LASTREC_UPDATE);
> -	}
> -
>  	/* Pass new key value up to our parent. */
>  	if (xfs_btree_needs_key_update(cur, ptr)) {
>  		error = xfs_btree_update_keys(cur, 0);
> @@ -3617,15 +3584,6 @@ xfs_btree_insrec(
>  			goto error0;
>  	}
>  
> -	/*
> -	 * If we are tracking the last record in the tree and
> -	 * we are at the far right edge of the tree, update it.
> -	 */
> -	if (xfs_btree_is_lastrec(cur, block, level)) {
> -		cur->bc_ops->update_lastrec(cur, block, rec,
> -					    ptr, LASTREC_INSREC);
> -	}
> -
>  	/*
>  	 * Return the new block number, if any.
>  	 * If there is one, give back a record value and a cursor too.
> @@ -3983,15 +3941,6 @@ xfs_btree_delrec(
>  	xfs_btree_set_numrecs(block, --numrecs);
>  	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
>  
> -	/*
> -	 * If we are tracking the last record in the tree and
> -	 * we are at the far right edge of the tree, update it.
> -	 */
> -	if (xfs_btree_is_lastrec(cur, block, level)) {
> -		cur->bc_ops->update_lastrec(cur, block, NULL,
> -					    ptr, LASTREC_DELREC);
> -	}
> -
>  	/*
>  	 * We're at the root level.  First, shrink the root block in-memory.
>  	 * Try to get rid of the next level down.  If we can't then there's
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index f93374278aa1..10b7ddc3b2b3 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -154,12 +154,6 @@ struct xfs_btree_ops {
>  			       int *stat);
>  	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
>  
> -	/* update last record information */
> -	void	(*update_lastrec)(struct xfs_btree_cur *cur,
> -				  const struct xfs_btree_block *block,
> -				  const union xfs_btree_rec *rec,
> -				  int ptr, int reason);
> -
>  	/* records in block/level */
>  	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
>  	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
> @@ -222,15 +216,7 @@ struct xfs_btree_ops {
>  };
>  
>  /* btree geometry flags */
> -#define XFS_BTGEO_LASTREC_UPDATE	(1U << 0) /* track last rec externally */
> -#define XFS_BTGEO_OVERLAPPING		(1U << 1) /* overlapping intervals */
> -
> -/*
> - * Reasons for the update_lastrec method to be called.
> - */
> -#define LASTREC_UPDATE	0
> -#define LASTREC_INSREC	1
> -#define LASTREC_DELREC	2
> +#define XFS_BTGEO_OVERLAPPING		(1U << 0) /* overlapping intervals */
>  
>  
>  union xfs_btree_irec {
> -- 
> 2.39.2
> 
> 
