Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4E15CE;
	Wed, 19 Jun 2024 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718756551; cv=none; b=U8JVGrsqX1tTG7NpVg+9yHosJyW3ojoA5GNyVv74hnrb4RFMkrQkxSMsEQbplrfxaW6QW8WjIUoqVs2uZ0QY9CbJt9h7IeWdntDpxZDJjuh7pFA0YLkdFMCXrWfPKbwBrIIEnS9AI/gtslYKYgGfQDxG12JoTO4VsLYkDaySrr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718756551; c=relaxed/simple;
	bh=/d5csBPIDvpXVBQPgaAsVkdJ00vVtZ2uN6EJ3vJqa9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiWeegUf+Rk90SRdLVIVs109CpZDrlNOrre6oOF5QpOiggJnPxqoCcdmjplnRKwkOp3nhZVXF3KNb6M6sNsOhgGvLIW6h17hmYsvksFw4M/MdbNPQQS/11CyJt74wacpvGaPKA/UzWBRTY6/Cz6iWSFTNFhuXmoarY+I4Gb8DZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQkr7HAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQkr7HAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB859C3277B;
	Wed, 19 Jun 2024 00:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718756550;
	bh=/d5csBPIDvpXVBQPgaAsVkdJ00vVtZ2uN6EJ3vJqa9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZQkr7HAyl8VSRqt5v4pBuk8Pw9Piuw54cbpFP6cuukzZ/TBhGs+HznXlof4I+HIos
	 OVfbFvccdzmczdwcXe0532XkXSOdGCH+0gf9JkXqeMpxayvomS8/ixBxjBiInzED9k
	 L9CR0joROpJAln5hmTHiQn6LbK5Dz97649r6NCMHw1ii+SbZQksxzLn3pEMBKg5g6g
	 7/nGB8qntrBcMvxCi7mNel0mcRw6My6iTNqWHYlr4R5vxv1YjCWqugUlIIirb1zVn8
	 UuWROYDT5mCi39l17rCDRU7SttNSQEvZd6xgf8zOz0cwzqkUwf40BbySWlaWfGcj0R
	 uxDUdjOaxbZ4g==
Date: Tue, 18 Jun 2024 17:22:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: Avoid races with cnt_btree lastrec updates
Message-ID: <20240619002230.GH103057@frogsfrogsfrogs>
References: <20240618133208.1161794-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618133208.1161794-1-wozizhi@huawei.com>

On Tue, Jun 18, 2024 at 09:32:08PM +0800, Zizhi Wo wrote:
> A concurrent file creation and little writing could unexpectedly return
> -ENOSPC error since there is a race window that the allocator could get
> the wrong agf->agf_longest.
> 
> Write file process steps:
> 1) Find the entry that best meets the conditions, then calculate the start
>    address and length of the remaining part of the entry after allocation.
> 2) Delete this entry and update the agf->agf_longest.
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
> process goes to 2) at this time, it will be mistaken for no space,
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
>    to the end of the cntbt modifications. And only these two scenarios
>    need to be considered:
>    2.1) In the deletion scenario, directly update the longest to the
>         rightmost record of the cntbt.
>    2.2) In the insertion scenario, determine whether the cntbt has the
>         record that larger than the previous longest.
> 
> [1] https://lore.kernel.org/all/20240419061848.1032366-2-yebin10@huawei.com
> [2] https://lore.kernel.org/all/20240604071121.3981686-1-wozizhi@huawei.com
> 
> Reported by: Ye Bin <yebin10@huawei.com>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 116 ++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  64 ------------------
>  fs/xfs/libxfs/xfs_btree.c       |  51 --------------
>  fs/xfs/libxfs/xfs_btree.h       |  16 ++---
>  4 files changed, 120 insertions(+), 127 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6c55a6e88eba..74e40f75a278 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -465,6 +465,99 @@ xfs_alloc_fix_len(
>  	args->len = rlen;
>  }
>  
> +/*
> + * Determine if the cursor points to the block that contains the right-most
> + * block of records in the by-count btree. This block contains the largest
> + * contiguous free extent in the AG, so if we modify ia record in this block we

                                                        a record

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
> +	if (!xfs_btree_ptr_is_null(cnt_cur, &ptr))
> +		return false;
> +	return true;
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
> +	struct xfs_btree_cur	*cnt_cur,
> +	int			reason)
> +{
> +	struct xfs_perag	*pag = cnt_cur->bc_ag.pag;
> +	struct xfs_agf		*agf;
> +	struct xfs_buf		*bp;
> +	struct xfs_btree_block	*block;
> +	int			error;
> +	int			i;
> +	int			numrecs;
> +
> +	/*
> +	 * Lookup last rec and update AGF.
> +	 *
> +	 * In case of LASTREC_DELREC, after called xfs_alloc_lookup_ge(), the
> +	 * ptr is in the rightmost edge, and we need to update the last record
> +	 * of this block as the longest free extent.
> +	 *
> +	 * In case of LASTREC_INSREC, because only one new record is inserted
> +	 * each time, only need to check whether the cntbt has a record that
> +	 * larger than the previous longest. Note that we can't update the
> +	 * longest with xfs_alloc_get_rec() as the xfs_verify_agbno() may not
> +	 * pass because pag->block_count is updated on the outside.
> +	 */
> +	error = xfs_alloc_lookup_ge(cnt_cur, 0, pag->pagf_longest + 1, &i);
> +	if (error)
> +		return error;
> +
> +	if (i == 1 || reason == LASTREC_DELREC) {
> +		if (XFS_IS_CORRUPT(pag->pag_mount,
> +				   i == 1 && reason == LASTREC_DELREC)) {
> +			xfs_btree_mark_sick(cnt_cur);
> +			return -EFSCORRUPTED;
> +		}
> +
> +		block = xfs_btree_get_block(cnt_cur, 0, &bp);
> +		numrecs = xfs_btree_get_numrecs(block);
> +
> +		if (numrecs) {
> +			xfs_alloc_rec_t *rrp;
> +
> +			rrp = XFS_ALLOC_REC_ADDR(cnt_cur->bc_mp, block,
> +						 numrecs);
> +			pag->pagf_longest = be32_to_cpu(rrp->ar_blockcount);
> +		} else {
> +			/* empty tree */
> +			pag->pagf_longest = 0;
> +		}
> +	}

Hum.  Would it work if we did:

	xfs_extlen_t	len;

	xfs_alloc_lookup_le(cnt_cur, 0, mp->m_sb.sb_agsize, &i);

	if (i)
		xfs_alloc_get_rec(cnt_cur, ..., &len, &i);
	if (!i)
		len = 0;

	pag->pagf_longest = len;

This performs a LE lookup on the longest possible free extent (aka the
AG size).  If we get pointed at a record, that's the longest free extent
and we can set pag->pagf_longest to that.  If we get no record, then
there's zero space and we can zero it.

Then I think you don't need the @reason argument either.

--D

> +
> +	bp = cnt_cur->bc_ag.agbp;
> +	agf = bp->b_addr;
> +	agf->agf_longest = cpu_to_be32(pag->pagf_longest);
> +	xfs_alloc_log_agf(cnt_cur->bc_tp, bp, XFS_AGF_LONGEST);
> +
> +	return 0;
> +}
> +
>  /*
>   * Update the two btrees, logically removing from freespace the extent
>   * starting at rbno, rlen blocks.  The extent is contained within the
> @@ -489,6 +582,7 @@ xfs_alloc_fixup_trees(
>  	xfs_extlen_t	nflen1=0;	/* first new free length */
>  	xfs_extlen_t	nflen2=0;	/* second new free length */
>  	struct xfs_mount *mp;
> +	bool		fixup_longest = false;
>  
>  	mp = cnt_cur->bc_mp;
>  
> @@ -577,6 +671,10 @@ xfs_alloc_fixup_trees(
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
> @@ -654,6 +752,10 @@ xfs_alloc_fixup_trees(
>  			return -EFSCORRUPTED;
>  		}
>  	}
> +
> +	if (fixup_longest)
> +		return xfs_alloc_fixup_longest(cnt_cur, LASTREC_DELREC);
> +
>  	return 0;
>  }
>  
> @@ -1956,6 +2058,7 @@ xfs_free_ag_extent(
>  	int				i;
>  	int				error;
>  	struct xfs_perag		*pag = agbp->b_pag;
> +	bool				fixup_longest = false;
>  
>  	bno_cur = cnt_cur = NULL;
>  	mp = tp->t_mountp;
> @@ -2219,8 +2322,13 @@ xfs_free_ag_extent(
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
> @@ -2229,6 +2337,8 @@ xfs_free_ag_extent(
>  		error = -EFSCORRUPTED;
>  		goto error0;
>  	}
> +	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
> +		fixup_longest = true;
>  	if ((error = xfs_btree_insert(cnt_cur, &i)))
>  		goto error0;
>  	if (XFS_IS_CORRUPT(mp, i != 1)) {
> @@ -2236,6 +2346,12 @@ xfs_free_ag_extent(
>  		error = -EFSCORRUPTED;
>  		goto error0;
>  	}
> +	if (fixup_longest) {
> +		error = xfs_alloc_fixup_longest(cnt_cur, LASTREC_INSREC);
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
> index f93374278aa1..670470874630 100644
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
> @@ -222,15 +216,13 @@ struct xfs_btree_ops {
>  };
>  
>  /* btree geometry flags */
> -#define XFS_BTGEO_LASTREC_UPDATE	(1U << 0) /* track last rec externally */
> -#define XFS_BTGEO_OVERLAPPING		(1U << 1) /* overlapping intervals */
> +#define XFS_BTGEO_OVERLAPPING		(1U << 0) /* overlapping intervals */
>  
>  /*
> - * Reasons for the update_lastrec method to be called.
> + * Reasons for the xfs_alloc_fixup_longest() to be called.
>   */
> -#define LASTREC_UPDATE	0
> -#define LASTREC_INSREC	1
> -#define LASTREC_DELREC	2
> +#define LASTREC_INSREC	0
> +#define LASTREC_DELREC	1
>  
>  
>  union xfs_btree_irec {
> -- 
> 2.39.2
> 
