Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbcI3TWH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 15:22:07 -0400
Date: Fri, 30 Sep 2016 15:22:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 18/63] xfs: introduce reflink utility functions
Message-ID: <20160930192204.GA64498@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520485243.29434.4219083999368879404.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520485243.29434.4219083999368879404.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 08:07:32PM -0700, Darrick J. Wong wrote:
> These functions will be used by the other reflink functions to find
> the maximum length of a range of shared blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.coM>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |  100 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_refcount.h |    4 ++
>  2 files changed, 104 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 49d8c6f..0748c9c 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1142,3 +1142,103 @@ xfs_refcount_decrease_extent(
>  	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_DECREASE,
>  			PREV->br_startblock, PREV->br_blockcount);
>  }
> +
> +/*
> + * Given an AG extent, find the lowest-numbered run of shared blocks within
> + * that range and return the range in fbno/flen.  If find_maximal is set,
> + * return the longest extent of shared blocks; if not, just return the first
> + * extent we find.  If no shared blocks are found, flen will be set to zero.
> + */
> +int
> +xfs_refcount_find_shared(
> +	struct xfs_btree_cur		*cur,
> +	xfs_agblock_t			agbno,
> +	xfs_extlen_t			aglen,
> +	xfs_agblock_t			*fbno,
> +	xfs_extlen_t			*flen,
> +	bool				find_maximal)
> +{
> +	struct xfs_refcount_irec	tmp;
> +	int				i;
> +	int				have;
> +	int				error;
> +
> +	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_private.a.agno,
> +			agbno, aglen);
> +
> +	/* By default, skip the whole range */
> +	*fbno = agbno + aglen;
> +	*flen = 0;
> +
> +	/* Try to find a refcount extent that crosses the start */
> +	error = xfs_refcount_lookup_le(cur, agbno, &have);
> +	if (error)
> +		goto out_error;
> +	if (!have) {
> +		/* No left extent, look at the next one */
> +		error = xfs_btree_increment(cur, 0, &have);
> +		if (error)
> +			goto out_error;
> +		if (!have)
> +			goto done;
> +	}
> +	error = xfs_refcount_get_rec(cur, &tmp, &i);
> +	if (error)
> +		goto out_error;
> +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
> +
> +	/* If the extent ends before the start, look at the next one */
> +	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
> +		error = xfs_btree_increment(cur, 0, &have);
> +		if (error)
> +			goto out_error;
> +		if (!have)
> +			goto done;
> +		error = xfs_refcount_get_rec(cur, &tmp, &i);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
> +	}
> +
> +	/* If the extent ends after the range we want, bail out */

Nit:			 starts

> +	if (tmp.rc_startblock >= agbno + aglen)
> +		goto done;
> +
> +	/* We found the start of a shared extent! */
> +	if (tmp.rc_startblock < agbno) {
> +		tmp.rc_blockcount -= (agbno - tmp.rc_startblock);
> +		tmp.rc_startblock = agbno;
> +	}
> +
> +	*fbno = tmp.rc_startblock;
> +	*flen = min(tmp.rc_blockcount, agbno + aglen - *fbno);
> +	if (!find_maximal)
> +		goto done;
> +
> +	/* Otherwise, find the end of this shared extent */
> +	while (*fbno + *flen < agbno + aglen) {
> +		error = xfs_btree_increment(cur, 0, &have);
> +		if (error)
> +			goto out_error;
> +		if (!have)
> +			break;
> +		error = xfs_refcount_get_rec(cur, &tmp, &i);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
> +		if (tmp.rc_startblock >= agbno + aglen ||
> +		    tmp.rc_startblock != *fbno + *flen)
> +			break;

FWIW, my impression from the comment above the function is that
find_maximal means to find the longest shared extent in the range of
blocks. Rather, this appears to extend the first found shared range to
include separate, but physically contiguous records (which I assume
means that only the refcounts differ). Perhaps changing "find_maximal"
to "ignore_refcount" or something better might be more clear?

Brian

> +		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
> +	}
> +
> +done:
> +	trace_xfs_refcount_find_shared_result(cur->bc_mp,
> +			cur->bc_private.a.agno, *fbno, *flen);
> +
> +out_error:
> +	if (error)
> +		trace_xfs_refcount_find_shared_error(cur->bc_mp,
> +				cur->bc_private.a.agno, error, _RET_IP_);
> +	return error;
> +}
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index 7e750a5..48c576c 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -54,4 +54,8 @@ extern int xfs_refcount_finish_one(struct xfs_trans *tp,
>  		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
>  		xfs_extlen_t *adjusted, struct xfs_btree_cur **pcur);
>  
> +extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
> +		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
> +		xfs_extlen_t *flen, bool find_maximal);
> +
>  #endif	/* __XFS_REFCOUNT_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
