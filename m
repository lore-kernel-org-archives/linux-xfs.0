Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 05:49:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7KCnGj9028623
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 05:49:18 -0700
Date: Wed, 20 Aug 2008 08:50:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix use-after-free with buffers
Message-ID: <20080820125033.GA29680@infradead.org>
References: <48ABA9EC.5040902@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ABA9EC.5040902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 20, 2008 at 03:21:48PM +1000, Lachlan McIlroy wrote:
> 	XB_TRACE(bp, "rele", bp->b_relse);
>
> +	ASSERT(atomic_read(&bp->b_hold) > 0);
> +
> 	if (unlikely(!hash)) {
> 		ASSERT(!bp->b_relse);
> 		if (atomic_dec_and_test(&bp->b_hold))
> @@ -838,7 +840,6 @@ xfs_buf_rele(
> 		return;
> 	}
>
> -	ASSERT(atomic_read(&bp->b_hold) > 0);

Makes sense, but how is this related to the other bits of the
patch?  All but log and iozero buffers should always be hashed.

> @@ -732,6 +732,7 @@ xfs_buf_item_init(
> 	bip->bli_item.li_ops = &xfs_buf_item_ops;
> 	bip->bli_item.li_mountp = mp;
> 	bip->bli_buf = bp;
> +	xfs_buf_hold(bp);

These refcount changes look good to me.

> +void
> +xfs_buf_item_free(
> +	xfs_buf_log_item_t	*bip)
> +{
> +#ifdef XFS_TRANS_DEBUG
> +	kmem_free(bip->bli_orig);
> +	bip->bli_orig = NULL;
> +	kmem_free(bip->bli_logged);
> +	bip->bli_logged = NULL;
> +#endif /* XFS_TRANS_DEBUG */
> +
> +#ifdef XFS_BLI_TRACE
> +	ktrace_free(bip->bli_trace);
> +#endif
> +	kmem_zone_free(xfs_buf_item_zone, bip);
> +}

Faktoring this out makes sense, although you might want to remove the
zeroing of bip->bli_orig and bip->bli_logged while you're at it, so that
slab poisoning can do it's work.
