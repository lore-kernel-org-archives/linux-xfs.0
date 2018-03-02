Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48610 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933561AbeCBWuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 17:50:51 -0500
Date: Fri, 2 Mar 2018 14:50:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
Message-ID: <20180302225050.GA25395@infradead.org>
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

>  /*
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

NULL or error calling conventions are nasty.  Can we switch to always
return an ERR_PTR?

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
> +	}

Usual style is to not indent the switch labels.

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

Can we move xfs_incore to xfs_buf.c and stop exporting _xfs_buf_find
while we're at it?

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
>  		if (!bp) {
>  			error = -EINVAL;
>  			goto out_unlock;

Make this a separate prep patch, please.  Maybe together with moving
xfs_incore out of line.
