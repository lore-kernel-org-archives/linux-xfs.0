Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEQW4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 18:56:42 -0400
Subject: Re: [PATCH 6/3] libxfs: factor common xfs_trans_bjoin code
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <3a54f934-5651-d709-1503-b583f9e044e9@redhat.com>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <99ee81de-e180-8565-5b45-de4a98b86b19@oracle.com>
Date: Fri, 17 May 2019 15:56:11 -0700
MIME-Version: 1.0
In-Reply-To: <3a54f934-5651-d709-1503-b583f9e044e9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/16/19 1:39 PM, Eric Sandeen wrote:
> Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf_map,
> xfs_trans_getsb and xfs_trans_read_buf_map.  Add a new
> _xfs_trans_bjoin which can be called by all three functions.
> 
> Source kernel commit: d7e84f413726876c0ec66bbf90770f69841f7663
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Alex Elder <aelder@sgi.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/trans.c | 53 +++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 39 insertions(+), 14 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index f3c28fa7..f78222fd 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -537,19 +537,50 @@ xfs_trans_binval(
>   	tp->t_flags |= XFS_TRANS_DIRTY;
>   }
>   
> -void
> -xfs_trans_bjoin(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> +/*
> + * Add the locked buffer to the transaction.
> + *
> + * The buffer must be locked, and it cannot be associated with any
> + * transaction.
> + *
> + * If the buffer does not yet have a buf log item associated with it,
> + * then allocate one for it.  Then add the buf item to the transaction.
> + */
> +STATIC void
> +_xfs_trans_bjoin(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp,
> +	int			reset_recur)
>   {
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>   
>   	ASSERT(bp->b_transp == NULL);
>   
> +        /*
> +	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
> +	 * it doesn't have one yet, then allocate one and initialize it.
> +	 * The checks to see if one is there are in xfs_buf_item_init().
> +	 */
>   	xfs_buf_item_init(bp, tp->t_mountp);
>   	bip = bp->b_log_item;
> +	if (reset_recur)
> +		bip->bli_recur = 0;
> +
> +	/*
> +	 * Attach the item to the transaction so we can find it in
> +	 * xfs_trans_get_buf() and friends.
> +	 */
>   	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>   	bp->b_transp = tp;
> +
> +}
> +
> +void
> +xfs_trans_bjoin(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	_xfs_trans_bjoin(tp, bp, 0);
>   	trace_xfs_trans_bjoin(bp->b_log_item);
>   }
>   
> @@ -594,9 +625,7 @@ xfs_trans_get_buf_map(
>   	if (bp == NULL)
>   		return NULL;
>   
> -	xfs_trans_bjoin(tp, bp);
> -	bip = bp->b_log_item;
> -	bip->bli_recur = 0;
> +	_xfs_trans_bjoin(tp, bp, 1);
>   	trace_xfs_trans_get_buf(bp->b_log_item);
>   	return bp;
>   }
> @@ -626,9 +655,7 @@ xfs_trans_getsb(
>   
>   	bp = xfs_getsb(mp);
>   
> -	xfs_trans_bjoin(tp, bp);
> -	bip = bp->b_log_item;
> -	bip->bli_recur = 0;
> +	_xfs_trans_bjoin(tp, bp, 1);
>   	trace_xfs_trans_getsb(bp->b_log_item);
>   	return bp;
>   }
> @@ -677,9 +704,7 @@ xfs_trans_read_buf_map(
>   	if (bp->b_error)
>   		goto out_relse;
>   
> -	xfs_trans_bjoin(tp, bp);
> -	bip = bp->b_log_item;
> -	bip->bli_recur = 0;
> +	_xfs_trans_bjoin(tp, bp, 1);
>   done:
>   	trace_xfs_trans_read_buf(bp->b_log_item);
>   	*bpp = bp;
> 
