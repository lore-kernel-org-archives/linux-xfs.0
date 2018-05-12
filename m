Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbeELAYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 20:24:51 -0400
Date: Fri, 11 May 2018 17:24:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: one-shot cached buffers
Message-ID: <20180512002448.GM11261@magnolia>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511225107.27171-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, May 12, 2018 at 08:50:58AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For the new growfs work, we want to ensure that we serialise
> secondary superblock updates with other operations (e.g. scrub)
> correctly, but we don't want to cache the buffers for long term
> reuse. We need cached buffers for serialisation, however.
> 
> To solve this, introduce a "oneshot" buffer which will be marshalled
> through the cache but then released once the last current reference
> goes away. If the buffer is already cached, then we ignore the
> "one-shot" behaviour and leave the buffer in the state it was prior
> to the one-shot command being run. This means we don't perturb
> either the working set or existing cached buffer state by a one-shot
> operation.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Hmm, should the xfs_sb_read_secondary function in "xfs: superblock scrub
should use short-lived buffers" be calling this to set a zero lru_ref
instead of doing it directly?

The code itself looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 830e2f6c064a..f5f2b71c2fde 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -347,6 +347,18 @@ extern void xfs_buf_terminate(void);
>  
>  void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref);
>  
> +/*
> + * If the buffer is already on the LRU, do nothing. Otherwise set the buffer
> + * up with a reference count of 0 so it will be tossed from the cache when
> + * released.
> + */
> +static inline void xfs_buf_oneshot(struct xfs_buf *bp)
> +{
> +	if (!list_empty(&bp->b_lru) || atomic_read(&bp->b_lru_ref) > 1)
> +		return;
> +	atomic_set(&bp->b_lru_ref, 0);
> +}
> +
>  static inline int xfs_buf_ispinned(struct xfs_buf *bp)
>  {
>  	return atomic_read(&bp->b_pin_count);
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
