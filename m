Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A0277CB9
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750939188; cv=none; b=ZTyG08qQYI2vWm2grdRYR5ani+TODI3dhmDabQMavpwz3ExPaMc1lKTixhXJ7dEeqCX6Ij2IceRdz489b6JghgjprJuYEPXHsB3uMRqXMM7eoiA+GGFuk80rbW0PDXt9xbvZ0AZ4A9ry7q5Icc9a/ur88bnr26z8yiEJYcugWGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750939188; c=relaxed/simple;
	bh=hwg9UuH773BehMqTKrHJ5paz6wwvjmy2XdOv72HEPgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQhNUNihw5MWih7PRMlTX4bMD2MdrPZSWT8TyLvboQpH2XHb2Wt8uYIHi5pMAuiAj1fGwa+Fbe1+ScElVMt5BO2vzrJna5xH6Ganp2rEwaEHiCmrYmHZ+F+yQvOJrapONHVqR6a7ZDnwMXmmfKpEAo+WrtNbknlODzU1wPjT9iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5aUbuXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5aUbuXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCE7C4CEEB;
	Thu, 26 Jun 2025 11:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750939188;
	bh=hwg9UuH773BehMqTKrHJ5paz6wwvjmy2XdOv72HEPgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z5aUbuXHpnfM2mC8NSSdIKNKYgEEm+VhVlRT5xNo9e9FOy1X6V0PmfeDxS8eIGu2s
	 cwu7KD1XQJEJaFueLaOsXjEO+mbELdxr5AtFJRZe7IQFHIlY6Z48X131IphBaPXskE
	 Q5sPTxITwe599H2ApgXXxF9rsQQuzLXE7Ffg9HbAJzUvA54dVuMJQZomOk0XXgHuw9
	 yGrpTplaJwZcYcAAEC8R4gca8M5hHpJ3EXRZpiroGsSzdTFfTcs4q6LIuX5zUl49PT
	 ZJVHG8X0hgbHAii4gampPyUPL/PRKE6ZNjPaWEsFcLHSuvcq5QnxXjL/OXCj41W6Sk
	 olC+3iJ95Yu+g==
Date: Thu, 26 Jun 2025 13:59:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: factor out stale buffer item completion
Message-ID: <c66t2nksribmph42r6xzqjvc7pj3ii56z5ywwksg6tzpypfmul@dp326wmzx2m6>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <nmkMPg8SehDTHtd9Th3rilYsI7bOfS2g5mGNoFG0RWSztWRWavPjz1ay8cuE6PaJzGH9lWDsQSdSjWFTPca7dQ==@protonmail.internalid>
 <20250625224957.1436116-7-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-7-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:48:59AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The stale buffer item completion handling is currently only done
> from BLI unpinning. We need to perform this function from where-ever
> the last reference to the BLI is dropped, so first we need to
> factor this code out into a helper.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3e3c0f65a25c..c95826863c82 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -444,6 +444,42 @@ xfs_buf_item_pin(
>  	atomic_inc(&bip->bli_buf->b_pin_count);
>  }
> 
> +/*
> + * For a stale BLI, process all the necessary completions that must be
> + * performed when the final BLI reference goes away. The buffer will be
> + * referenced and locked here - we return to the caller with the buffer still
> + * referenced and locked for them to finalise processing of the buffer.
> + */
> +static void
> +xfs_buf_item_finish_stale(
> +	struct xfs_buf_log_item	*bip)
> +{
> +	struct xfs_buf		*bp = bip->bli_buf;
> +	struct xfs_log_item	*lip = &bip->bli_item;
> +
> +	ASSERT(bip->bli_flags & XFS_BLI_STALE);
> +	ASSERT(xfs_buf_islocked(bp));
> +	ASSERT(bp->b_flags & XBF_STALE);
> +	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> +	ASSERT(list_empty(&lip->li_trans));
> +	ASSERT(!bp->b_transp);
> +
> +	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> +		xfs_buf_item_done(bp);
> +		xfs_buf_inode_iodone(bp);
> +		ASSERT(list_empty(&bp->b_li_list));
> +		return;
> +	}
> +
> +	/*
> +	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
> +	 * the right thing regardless of the situation in which we are called.
> +	 */
> +	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> +	xfs_buf_item_relse(bip);
> +	ASSERT(bp->b_log_item == NULL);
> +}
> +
>  /*
>   * This is called to unpin the buffer associated with the buf log item which was
>   * previously pinned with a call to xfs_buf_item_pin().  We enter this function
> @@ -493,13 +529,6 @@ xfs_buf_item_unpin(
>  	}
> 
>  	if (stale) {
> -		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> -		ASSERT(xfs_buf_islocked(bp));
> -		ASSERT(bp->b_flags & XBF_STALE);
> -		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> -		ASSERT(list_empty(&lip->li_trans));
> -		ASSERT(!bp->b_transp);
> -
>  		trace_xfs_buf_item_unpin_stale(bip);
> 
>  		/*
> @@ -510,22 +539,7 @@ xfs_buf_item_unpin(
>  		 * processing is complete.
>  		 */
>  		xfs_buf_rele(bp);
> -
> -		/*
> -		 * If we get called here because of an IO error, we may or may
> -		 * not have the item on the AIL. xfs_trans_ail_delete() will
> -		 * take care of that situation. xfs_trans_ail_delete() drops
> -		 * the AIL lock.
> -		 */
> -		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> -			xfs_buf_item_done(bp);
> -			xfs_buf_inode_iodone(bp);
> -			ASSERT(list_empty(&bp->b_li_list));
> -		} else {
> -			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> -			xfs_buf_item_relse(bip);
> -			ASSERT(bp->b_log_item == NULL);
> -		}
> +		xfs_buf_item_finish_stale(bip);
>  		xfs_buf_relse(bp);
>  		return;
>  	}
> --
> 2.45.2
> 
> 
