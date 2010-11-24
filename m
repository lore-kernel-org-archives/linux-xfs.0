Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOHJITa135771 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 11:19:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8B4B1A511E
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 09:20:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id A7i4rJyPxs3sDYDB for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 09:20:56 -0800 (PST)
Date: Wed, 24 Nov 2010 12:20:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: push stale, pinned buffers on trylock failures
Message-ID: <20101124172051.GA32129@infradead.org>
References: <1290597873-5807-1-git-send-email-david@fromorbit.com>
	<1290597873-5807-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290597873-5807-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> -	/* Attempt to get the semaphore without sleeping,
> -	 * if this does not work then we need to drop the
> -	 * spinlock and do a hard attempt on the semaphore.
> +	/*
> +	 * Attempt to get the semaphore without sleeping first. if we fail then
> +	 * do a blocking lock if requested.
>  	 */

You might as well remove the comment entirely, as it's utterly
pointless.

> -	if (down_trylock(&bp->b_sema)) {
> +	if (xfs_buf_cond_lock(bp)) {
>  		if (!(flags & XBF_TRYLOCK)) {
>  			/* wait for buffer ownership */
>  			xfs_buf_lock(bp);
>  			XFS_STATS_INC(xb_get_locked_waited);
>  		} else {
> -			/* We asked for a trylock and failed, no need
> -			 * to look at file offset and length here, we
> -			 * know that this buffer at least overlaps our
> -			 * buffer and is locked, therefore our buffer
> -			 * either does not exist, or is this buffer.
> -			 */
> +			/* We asked for a trylock and failed.  */
>  			xfs_buf_rele(bp);
>  			XFS_STATS_INC(xb_busy_locked);
>  			return NULL;
>  		}

In case we wait for the lock we now do the log force twice, but that
should be fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
