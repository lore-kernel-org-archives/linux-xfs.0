Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o891WSfu075936 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 20:32:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9870F14EE9ED
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 18:44:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zJrk7qY103DqdMqq for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 18:44:28 -0700 (PDT)
Date: Wed, 8 Sep 2010 21:33:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: kill XBF_FS_MANAGED buffers
Message-ID: <20100909013312.GB29825@infradead.org>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283958778-28610-2-git-send-email-david@fromorbit.com>
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

Looks good, but a few comments below:

> +	bp = xfs_buf_get_noaddr(sector_size, mp->m_ddev_targp);
> +
>  	if (!bp || XFS_BUF_ISERROR(bp)) {

xfs_buf_get_noaddr will never return a buffer with an error set.

> -	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
> +
> +	/* set up the buffer for a read IO */
> +	xfs_buf_lock(bp);
> +	XFS_BUF_SET_ADDR(bp, XFS_SB_DADDR);
> +        XFS_BUF_READ(bp);
> +        XFS_BUF_BUSY(bp);

Various indentation problems.

> +	/* grab a reference for caching the buffer */
> +        XFS_BUF_HOLD(bp);
>  	mp->m_sb_bp = bp;
> +
>  	xfs_buf_relse(bp);

Grabbing the reference just to drop it three lines later is rather
pointless, just remove both.

>  	ASSERT(XFS_BUF_VALUSEMA(bp) > 0);

Given that we took the lock a few lines above this one also feels rather
poinless.

> +fail:
> +	if (bp)
>  		xfs_buf_relse(bp);
> -	}
>  	return error;

I'd rather see this split into a fail_buf_relese label that puts the
buffer, and a fail label that just returns the error.

>  	 * when we call xfs_buf_relse().
>  	 */
>  	bp = xfs_getsb(mp, 0);
> -	XFS_BUF_UNMANAGE(bp);
> -	xfs_buf_relse(bp);
>  	mp->m_sb_bp = NULL;
> +
> +	/*
> +	 * need to release the buffer twice to free it because we hold an extra
> +	 * reference count on it.
> +	 */
> +	xfs_buf_relse(bp);
> +	xfs_buf_relse(bp);

I'd rather rewrite xfs_freesb to not use xfs_getsb and thus avoid taking
the superflous reference:

void
xfs_freesb(
	struct xfs_mount	*mp);

	struct xfs_buf		*bp = mp->m_sb_bp;

	mp->m_sb_bp = NULL;
	if (xfs_buf_cond_lock(bp)
		BUG();
	xfs_buf_relse(bp);
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
