Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34036 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946676AbeCBRh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 12:37:26 -0500
Date: Fri, 2 Mar 2018 09:37:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
Message-ID: <20180302173722.GU19312@magnolia>
References: <20180301223632.28742-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301223632.28742-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 09:36:32AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When looking at an event trace recently, I noticed that non-blocking
> buffer lookup attempts would fail on cached locked buffers and then
> run the slow cache-miss path. This means we are doing an xfs_buf
> allocation, lookup and free unnecessarily every time we avoid
> blocking on a locked buffer.
> 
> Fix this by changing _xfs_buf_find() to return an error status
> encoded via ERR_PTR() to the caller to indicate that we failed the
> lock attempt rather than just returning a NULL. This allows the
> higher level code to discriminate between a cache miss and an cache
> hit that we failed to lock.
> 
> This also allows us to return a -EFSCORRUPTED state if we are asked
> to look up a block number outside the range of the filesystem in
> _xfs_buf_find(), which moves us one step closer to being able to
> handle such errors in a more graceful manner at the higher levels.
> 
> Finally, to ensure code outside the buffer cache does not see any
> change, convert external callers to use xfs_incore() and change that
> to an inline function that maintains the old "buffer or NULL" return
> values so the external code doesn't need to care about this internal
> change to _xfs_buf_find() semantics.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 56 +++++++++++++++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_buf.h |  8 +++++++-
>  fs/xfs/xfs_qm.c  |  5 ++---
>  3 files changed, 50 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 88587b33dd15..fa1e62ac5e8c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -549,20 +549,32 @@ xfs_buf_hash_destroy(
>  }
>  
>  /*
> - *	Look up, and creates if absent, a lockable buffer for
> - *	a given range of an inode.  The buffer is returned
> - *	locked.	No I/O is implied by this call.
> + * Look up a buffer in the buffer cache and return it referenced and locked.
> + *
> + * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
> + * cache.
> + *
> + * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
> + * -EAGAIN if we fail to lock it.
> + *
> + * Return values are:
> + *	-EFSCORRUPTED if have been supplied with an invalid address
> + *	-EAGAIN on trylock failure
> + *	NULL if we fail to find a match and @new_bp was NULL
> + *	@new_bp if we inserted it into the cache
> + *	the buffer we found and locked.
>   */
> -xfs_buf_t *
> +
> +struct xfs_buf *
>  _xfs_buf_find(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
>  	xfs_buf_flags_t		flags,
> -	xfs_buf_t		*new_bp)
> +	struct xfs_buf		*new_bp)
>  {
>  	struct xfs_perag	*pag;
> -	xfs_buf_t		*bp;
> +	struct xfs_buf		*bp;
>  	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
>  	xfs_daddr_t		eofs;
>  	int			i;
> @@ -580,16 +592,11 @@ _xfs_buf_find(
>  	 */
>  	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
>  	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
> -		/*
> -		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
> -		 * but none of the higher level infrastructure supports
> -		 * returning a specific error on buffer lookup failures.
> -		 */
>  		xfs_alert(btp->bt_mount,
>  			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
>  			  __func__, cmap.bm_bn, eofs);
>  		WARN_ON(1);
> -		return NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
>  	}
>  
>  	pag = xfs_perag_get(btp->bt_mount,
> @@ -626,7 +633,7 @@ _xfs_buf_find(
>  		if (flags & XBF_TRYLOCK) {
>  			xfs_buf_rele(bp);
>  			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
> -			return NULL;
> +			return ERR_PTR(-EAGAIN);
>  		}
>  		xfs_buf_lock(bp);
>  		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
> @@ -666,9 +673,28 @@ xfs_buf_get_map(
>  	int			error = 0;
>  
>  	bp = _xfs_buf_find(target, map, nmaps, flags, NULL);
> -	if (likely(bp))
> +	if (!IS_ERR_OR_NULL(bp))
>  		goto found;
>  
> +	switch (PTR_ERR(bp)) {
> +		case 0:
> +			/* cache miss, need to insert new buffer */
> +			break;
> +
> +		case -EAGAIN:
> +			/* cache hit, trylock failure, caller handles failure */
> +			ASSERT(flags & XBF_TRYLOCK);
> +			return NULL;
> +
> +		case -EFSCORRUPTED:
> +		default:
> +			/*
> +			 * None of the higher layers understand failure types
> +			 * yet, so return NULL to signal a fatal lookup error.
> +			 */
> +			return NULL;

Should I expect a follow-on patch to fix the higher layers?

> +	}
> +
>  	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
>  	if (unlikely(!new_bp))
>  		return NULL;
> @@ -680,7 +706,7 @@ xfs_buf_get_map(
>  	}
>  
>  	bp = _xfs_buf_find(target, map, nmaps, flags, new_bp);
> -	if (!bp) {
> +	if (IS_ERR_OR_NULL(bp)) {
>  		xfs_buf_free(new_bp);
>  		return NULL;
>  	}
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 2f4c91452861..db87ad0b9b79 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -229,8 +229,14 @@ xfs_incore(
>  	size_t			numblks,
>  	xfs_buf_flags_t		flags)
>  {
> +	struct xfs_buf		*bp;
> +
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -	return _xfs_buf_find(target, &map, 1, flags, NULL);
> +
> +	bp = _xfs_buf_find(target, &map, 1, flags, NULL);
> +	if (IS_ERR_OR_NULL(bp))
> +		return NULL;
> +	return bp;
>  }
>  
>  struct xfs_buf *_xfs_buf_alloc(struct xfs_buftarg *target,
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 5b848f4b637f..8d90d19684a7 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1249,9 +1249,8 @@ xfs_qm_flush_one(
>  	 */
>  	if (!xfs_dqflock_nowait(dqp)) {
>  		/* buf is pinned in-core by delwri list */
> -		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
> -				      mp->m_quotainfo->qi_dqchunklen);
> -		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
> +		bp = xfs_incore(mp->m_ddev_targp, dqp->q_blkno,
> +				mp->m_quotainfo->qi_dqchunklen, 0);

Looks ok otherwise.

--D

>  		if (!bp) {
>  			error = -EINVAL;
>  			goto out_unlock;
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
