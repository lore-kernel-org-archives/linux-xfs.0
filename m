Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o891bMXU076117 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 20:37:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BF0D14EEA0C
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 18:49:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4RgeaErfDPgpqBEj for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 18:49:23 -0700 (PDT)
Date: Wed, 8 Sep 2010 21:38:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: use unhashed buffers for size checks
Message-ID: <20100909013806.GC29825@infradead.org>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283958778-28610-3-git-send-email-david@fromorbit.com>
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

> +struct xfs_buf *
> +xfs_buf_read_uncached(
> +	struct xfs_mount	*mp,
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		daddr,
> +	size_t			length)
> +{
> +	xfs_buf_t	*bp;
> +	int		error;

struct xfs_buf and the same indentation as the parameters, please.

> +
> +	bp = xfs_buf_get_noaddr(length, target);

I think both the buf_get and buf_read interfaces for the non-hash
buffers should have the same name.  Either your uncached or maybe better
unhashed?  (And certainly no noaddr, which is not very useful)

> +	if (!bp || XFS_BUF_ISERROR(bp))
> +		goto fail;

xfs_buf_get_noaddr never returns an error in the buffer.

> +	/* set up the buffer for a read IO */
> +	xfs_buf_lock(bp);
> +	XFS_BUF_SET_ADDR(bp, daddr);
> +	XFS_BUF_READ(bp);
> +	XFS_BUF_BUSY(bp);
> +
> +	xfsbdstrat(mp, bp);
> +	error = xfs_iowait(bp);
> +	if (error || XFS_BUF_ISERROR(bp))
> +		goto fail;
> +
> +	return bp;
> +fail:
> +	if (bp)
> +		xfs_buf_relse(bp);

again, different labels please.

Also this one returns the buffer locked, while buf_get_noaddr doesn't.
I suspect we should also change buf_get_noaddr to return a locked buffer
to make it consistant with all other buf_read/get interfaces.

> +struct xfs_buf * xfs_buf_read_uncached(struct xfs_mount *mp,
> +				struct xfs_buftarg *target,
> +				xfs_daddr_t daddr, size_t length);

wrong placement of the *


This patch, or at least the introduction of the new read helper should
be moved before patch 1 so that we don't add code that gets removed a
little later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
