Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061920C48D
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750939055; cv=none; b=e9G44PIfFQYsSaV19if0Y6hOYTZz37RLMW/n6p0SBJs90GBhn/MAulf4d9neA592X6cXJeqWG3QP7Ju3qUbeVMSuFTliyhs3ZHRH+Yl+gH6ozB7+dteNAYWty9VNWgJWSMpniERUbOgXThogKsmDzJKj3TFz+5yHIgC5ZpsIWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750939055; c=relaxed/simple;
	bh=yYsRTdu6FUe6VdOY/+VhboYv6M7qX4SL+9FqNJCll9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwM7HRK8iYpgzrbcl1ihCNE+uIAS/rWL9eCT5+M8QBjjHWNr0NMzf73ryt07v3fcy5VITkIHw58FIg7bulPMlCmiHUFFSvry9BqZk7YnbFT/sE2XfhAprfUn/3rot/oOpVD5WUstP6I83IrxwHnoIq4d+cRB7mBVUg7zb9jJSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NK+R7CZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NK+R7CZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01547C4CEEB;
	Thu, 26 Jun 2025 11:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750939054;
	bh=yYsRTdu6FUe6VdOY/+VhboYv6M7qX4SL+9FqNJCll9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NK+R7CZHktfWfbtqNoa7CmF6Z4zTL0dz9dNIT4kSYRJNqy+oTXFlnYsYu07egYiku
	 kWdMpawevTpAZ+NOqidoqepl9mHNvEda79+h6Ui+unrI9cTMwZbBZb3mTfGDGKCedt
	 4tgEEwETQW4VJ/9XgNztCxKC/4EK7qKMuKSab7+S0DhDB/9BDBclIoUbEU6jYJKDid
	 TbEZgFOXqbjWnwe0QEJNtz+g2U86DiCPbJmlMxmYnQJfnUYoQjrNGTj2qXnD3mxcRm
	 M15vDHeRu3TfxaDQoMXv8isiXJ2KfAGMAHZK/ApGd3QWWLPUN4rY7xt+HYqZyzjjMG
	 WmYlBuS0vtYWg==
Date: Thu, 26 Jun 2025 13:57:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: rearrange code in xfs_buf_item.c
Message-ID: <zolxrnbf2gomijkxhp74vd3ks75xytmznuhvfmileopgehcbu2@5gxh4g4y25h3>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <t9db4y2ZpaNkNi8wkNSvCoYwbLOuuBIWoaDfqmPIIsquNTwIFj0nwmdaBVoz91V61VdpbU7Dojiq3mlG-0VMtw==@protonmail.internalid>
 <20250625224957.1436116-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-6-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:48:58AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The code to initialise, release and free items is all the way down
> the bottom of the file. Upcoming fixes need to these functions
> earlier in the file, so move them to the top.
> 
> There is one code change in this move - the parameter to
> xfs_buf_item_relse() is changed from the xfs_buf to the
> xfs_buf_log_item - the thing that the function is releasing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf_item.c | 116 +++++++++++++++++++++---------------------
>  fs/xfs/xfs_buf_item.h |   1 -
>  2 files changed, 58 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 90139e0f3271..3e3c0f65a25c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -32,6 +32,61 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_buf_log_item, bli_item);
>  }
> 
> +static void
> +xfs_buf_item_get_format(
> +	struct xfs_buf_log_item	*bip,
> +	int			count)
> +{
> +	ASSERT(bip->bli_formats == NULL);
> +	bip->bli_format_count = count;
> +
> +	if (count == 1) {
> +		bip->bli_formats = &bip->__bli_format;
> +		return;
> +	}
> +
> +	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
> +				GFP_KERNEL | __GFP_NOFAIL);
> +}
> +
> +static void
> +xfs_buf_item_free_format(
> +	struct xfs_buf_log_item	*bip)
> +{
> +	if (bip->bli_formats != &bip->__bli_format) {
> +		kfree(bip->bli_formats);
> +		bip->bli_formats = NULL;
> +	}
> +}
> +
> +static void
> +xfs_buf_item_free(
> +	struct xfs_buf_log_item	*bip)
> +{
> +	xfs_buf_item_free_format(bip);
> +	kvfree(bip->bli_item.li_lv_shadow);
> +	kmem_cache_free(xfs_buf_item_cache, bip);
> +}
> +
> +/*
> + * xfs_buf_item_relse() is called when the buf log item is no longer needed.
> + */
> +static void
> +xfs_buf_item_relse(
> +	struct xfs_buf_log_item	*bip)
> +{
> +	struct xfs_buf		*bp = bip->bli_buf;
> +
> +	trace_xfs_buf_item_relse(bp, _RET_IP_);
> +
> +	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> +	ASSERT(atomic_read(&bip->bli_refcount) == 0);
> +
> +	bp->b_log_item = NULL;
> +	xfs_buf_rele(bp);
> +	xfs_buf_item_free(bip);
> +}
> +
>  /* Is this log iovec plausibly large enough to contain the buffer log format? */
>  bool
>  xfs_buf_log_check_iovec(
> @@ -468,7 +523,7 @@ xfs_buf_item_unpin(
>  			ASSERT(list_empty(&bp->b_li_list));
>  		} else {
>  			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> -			xfs_buf_item_relse(bp);
> +			xfs_buf_item_relse(bip);
>  			ASSERT(bp->b_log_item == NULL);
>  		}
>  		xfs_buf_relse(bp);
> @@ -578,7 +633,7 @@ xfs_buf_item_put(
>  	 */
>  	if (aborted)
>  		xfs_trans_ail_delete(lip, 0);
> -	xfs_buf_item_relse(bip->bli_buf);
> +	xfs_buf_item_relse(bip);
>  	return true;
>  }
> 
> @@ -729,33 +784,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
>  	.iop_push	= xfs_buf_item_push,
>  };
> 
> -STATIC void
> -xfs_buf_item_get_format(
> -	struct xfs_buf_log_item	*bip,
> -	int			count)
> -{
> -	ASSERT(bip->bli_formats == NULL);
> -	bip->bli_format_count = count;
> -
> -	if (count == 1) {
> -		bip->bli_formats = &bip->__bli_format;
> -		return;
> -	}
> -
> -	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
> -				GFP_KERNEL | __GFP_NOFAIL);
> -}
> -
> -STATIC void
> -xfs_buf_item_free_format(
> -	struct xfs_buf_log_item	*bip)
> -{
> -	if (bip->bli_formats != &bip->__bli_format) {
> -		kfree(bip->bli_formats);
> -		bip->bli_formats = NULL;
> -	}
> -}
> -
>  /*
>   * Allocate a new buf log item to go with the given buffer.
>   * Set the buffer's b_log_item field to point to the new
> @@ -976,34 +1004,6 @@ xfs_buf_item_dirty_format(
>  	return false;
>  }
> 
> -STATIC void
> -xfs_buf_item_free(
> -	struct xfs_buf_log_item	*bip)
> -{
> -	xfs_buf_item_free_format(bip);
> -	kvfree(bip->bli_item.li_lv_shadow);
> -	kmem_cache_free(xfs_buf_item_cache, bip);
> -}
> -
> -/*
> - * xfs_buf_item_relse() is called when the buf log item is no longer needed.
> - */
> -void
> -xfs_buf_item_relse(
> -	struct xfs_buf	*bp)
> -{
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -
> -	trace_xfs_buf_item_relse(bp, _RET_IP_);
> -	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> -
> -	if (atomic_read(&bip->bli_refcount))
> -		return;
> -	bp->b_log_item = NULL;
> -	xfs_buf_rele(bp);
> -	xfs_buf_item_free(bip);
> -}
> -
>  void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
> @@ -1023,5 +1023,5 @@ xfs_buf_item_done(
>  	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
>  			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
>  			     SHUTDOWN_CORRUPT_INCORE);
> -	xfs_buf_item_relse(bp);
> +	xfs_buf_item_relse(bp->b_log_item);
>  }
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index e10e324cd245..50dd79b59cf5 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -49,7 +49,6 @@ struct xfs_buf_log_item {
> 
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void	xfs_buf_item_done(struct xfs_buf *bp);
> -void	xfs_buf_item_relse(struct xfs_buf *);
>  bool	xfs_buf_item_put(struct xfs_buf_log_item *);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
> --
> 2.45.2
> 
> 
