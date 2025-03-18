Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A076520C473
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742300644; cv=none; b=GFOLBMiVVIinQhH8s0CJAiRuJ9X3xywnHAbi+AUFbuN4V3wf46e8bWSKh8vK+vnrJLQqAe6FzbL/dbQiszkQn+ppPjzpU7WPTjyynMZYzViVxm+W9qC7M/cjMN06e7s7xPDvDt/iKxEoGk3R63EFiQvwwes/+HgKHfKqg36O8EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742300644; c=relaxed/simple;
	bh=9Gi4lYaPYtc9Z08N9u8yGZbztnTHAadOB8XvthSlxaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pf3GmWS5r2iuxTDZKMwyeW7GSGMsliWJ8R5yp+XKk/SalKilOoIPOZD0Kxej+L2WKTMTufOQwvmXtViqGC4Zu8jKog6TLBSQmQx05ijgRsXwva4Sol73CXV+6zOEd2vVuwlsvC8/rxjYLRNsPeCh41MPBwD0KZwH6LcU/JTiuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eq437Zst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eq437Zst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C18C4CEEA;
	Tue, 18 Mar 2025 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742300644;
	bh=9Gi4lYaPYtc9Z08N9u8yGZbztnTHAadOB8XvthSlxaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eq437ZstF6fQt9OOy6V2fsb578j2c1LI3/7UEhzXxe+eI15ftGNZy/GSNJxFBSXKt
	 X0kS0tkbD6KDPW2+0QnrI2x9lEQNThpEp0SoWne0AQqTZyVu+1yiribwkhhYJy9cqG
	 BZijpa1NF3Wz8vvpNf91LYLnGisIToAFHNFcuCUgWd2PlYGeprfPx9dh9NbH972mSv
	 gsWQjaxzVwK0wqGfYV9z1zM9oEeRsOmml9Eik8vyw/a8EfjWLPAyAWuSR984X1nyfs
	 fHOhL/y1IxRHJtEeoR9MUuC8khQlVcr6zG3zunseNEgntAGLcGGl4d50f0t1GaJwPi
	 yIIeQQbA8We5g==
Date: Tue, 18 Mar 2025 13:23:27 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: call xfs_buf_alloc_backing_mem from
 _xfs_buf_alloc
Message-ID: <czklpy7cdmtwolmojgjha4mdd4l5tj2k4i5ic6p5ucnu4fe3yn@7rofdxljrhe6>
References: <20250317054850.1132557-1-hch@lst.de>
 <HaKUgBXws5jAIpQYPouglbgHF-CY9sAhikGf-eePYNs2ujWEhstM2FaZEcsPihmcu1coMEi2ztE6SWIvZP8oGQ==@protonmail.internalid>
 <20250317054850.1132557-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054850.1132557-2-hch@lst.de>

On Mon, Mar 17, 2025 at 06:48:32AM +0100, Christoph Hellwig wrote:
> We never allocate a buffer without backing memory.  Simplify the call
> chain by calling xfs_buf_alloc_backing_mem from _xfs_buf_alloc.  To
> avoid a forward declaration, move _xfs_buf_alloc down a bit in the
> file.
> 
> Also drop the pointless _-prefix from _xfs_buf_alloc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 165 +++++++++++++++++++++--------------------------
>  1 file changed, 75 insertions(+), 90 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 106ee81fa56f..f42f6e47f783 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -118,71 +118,6 @@ xfs_buf_free_maps(
>  	}
>  }
> 
> -static int
> -_xfs_buf_alloc(
> -	struct xfs_buftarg	*target,
> -	struct xfs_buf_map	*map,
> -	int			nmaps,
> -	xfs_buf_flags_t		flags,
> -	struct xfs_buf		**bpp)
> -{
> -	struct xfs_buf		*bp;
> -	int			error;
> -	int			i;
> -
> -	*bpp = NULL;
> -	bp = kmem_cache_zalloc(xfs_buf_cache,
> -			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> -
> -	/*
> -	 * We don't want certain flags to appear in b_flags unless they are
> -	 * specifically set by later operations on the buffer.
> -	 */
> -	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
> -
> -	/*
> -	 * A new buffer is held and locked by the owner.  This ensures that the
> -	 * buffer is owned by the caller and racing RCU lookups right after
> -	 * inserting into the hash table are safe (and will have to wait for
> -	 * the unlock to do anything non-trivial).
> -	 */
> -	bp->b_hold = 1;
> -	sema_init(&bp->b_sema, 0); /* held, no waiters */
> -
> -	spin_lock_init(&bp->b_lock);
> -	atomic_set(&bp->b_lru_ref, 1);
> -	init_completion(&bp->b_iowait);
> -	INIT_LIST_HEAD(&bp->b_lru);
> -	INIT_LIST_HEAD(&bp->b_list);
> -	INIT_LIST_HEAD(&bp->b_li_list);
> -	bp->b_target = target;
> -	bp->b_mount = target->bt_mount;
> -	bp->b_flags = flags;
> -
> -	error = xfs_buf_get_maps(bp, nmaps);
> -	if (error)  {
> -		kmem_cache_free(xfs_buf_cache, bp);
> -		return error;
> -	}
> -
> -	bp->b_rhash_key = map[0].bm_bn;
> -	bp->b_length = 0;
> -	for (i = 0; i < nmaps; i++) {
> -		bp->b_maps[i].bm_bn = map[i].bm_bn;
> -		bp->b_maps[i].bm_len = map[i].bm_len;
> -		bp->b_length += map[i].bm_len;
> -	}
> -
> -	atomic_set(&bp->b_pin_count, 0);
> -	init_waitqueue_head(&bp->b_waiters);
> -
> -	XFS_STATS_INC(bp->b_mount, xb_create);
> -	trace_xfs_buf_init(bp, _RET_IP_);
> -
> -	*bpp = bp;
> -	return 0;
> -}
> -
>  static void
>  xfs_buf_free_callback(
>  	struct callback_head	*cb)
> @@ -342,6 +277,77 @@ xfs_buf_alloc_backing_mem(
>  	return 0;
>  }
> 
> +static int
> +xfs_buf_alloc(
> +	struct xfs_buftarg	*target,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +	int			i;
> +
> +	*bpp = NULL;
> +	bp = kmem_cache_zalloc(xfs_buf_cache,
> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> +
> +	/*
> +	 * We don't want certain flags to appear in b_flags unless they are
> +	 * specifically set by later operations on the buffer.
> +	 */
> +	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
> +
> +	/*
> +	 * A new buffer is held and locked by the owner.  This ensures that the
> +	 * buffer is owned by the caller and racing RCU lookups right after
> +	 * inserting into the hash table are safe (and will have to wait for
> +	 * the unlock to do anything non-trivial).
> +	 */
> +	bp->b_hold = 1;
> +	sema_init(&bp->b_sema, 0); /* held, no waiters */
> +
> +	spin_lock_init(&bp->b_lock);
> +	atomic_set(&bp->b_lru_ref, 1);
> +	init_completion(&bp->b_iowait);
> +	INIT_LIST_HEAD(&bp->b_lru);
> +	INIT_LIST_HEAD(&bp->b_list);
> +	INIT_LIST_HEAD(&bp->b_li_list);
> +	bp->b_target = target;
> +	bp->b_mount = target->bt_mount;
> +	bp->b_flags = flags;
> +
> +	error = xfs_buf_get_maps(bp, nmaps);
> +	if (error)  {
> +		kmem_cache_free(xfs_buf_cache, bp);
> +		return error;
> +	}
> +
> +	bp->b_rhash_key = map[0].bm_bn;
> +	bp->b_length = 0;
> +	for (i = 0; i < nmaps; i++) {
> +		bp->b_maps[i].bm_bn = map[i].bm_bn;
> +		bp->b_maps[i].bm_len = map[i].bm_len;
> +		bp->b_length += map[i].bm_len;
> +	}
> +
> +	atomic_set(&bp->b_pin_count, 0);
> +	init_waitqueue_head(&bp->b_waiters);
> +
> +	XFS_STATS_INC(bp->b_mount, xb_create);
> +	trace_xfs_buf_init(bp, _RET_IP_);
> +
> +	error = xfs_buf_alloc_backing_mem(bp, flags);
> +	if (error) {
> +		xfs_buf_free(bp);
> +		return error;
> +	}
> +
> +	*bpp = bp;
> +	return 0;
> +}
> +
>  /*
>   *	Finding and Reading Buffers
>   */
> @@ -525,14 +531,10 @@ xfs_buf_find_insert(
>  	struct xfs_buf		*bp;
>  	int			error;
> 
> -	error = _xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
> +	error = xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
>  	if (error)
>  		goto out_drop_pag;
> 
> -	error = xfs_buf_alloc_backing_mem(new_bp, flags);
> -	if (error)
> -		goto out_free_buf;
> -
>  	/* The new buffer keeps the perag reference until it is freed. */
>  	new_bp->b_pag = pag;
> 
> @@ -869,28 +871,11 @@ xfs_buf_get_uncached(
>  	struct xfs_buf		**bpp)
>  {
>  	int			error;
> -	struct xfs_buf		*bp;
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
> 
> -	/* there are currently no valid flags for xfs_buf_get_uncached */
> -	ASSERT(flags == 0);
> -
> -	*bpp = NULL;
> -
> -	error = _xfs_buf_alloc(target, &map, 1, flags, &bp);
> -	if (error)
> -		return error;
> -
> -	error = xfs_buf_alloc_backing_mem(bp, flags);
> -	if (error)
> -		goto fail_free_buf;
> -
> -	trace_xfs_buf_get_uncached(bp, _RET_IP_);
> -	*bpp = bp;
> -	return 0;
> -
> -fail_free_buf:
> -	xfs_buf_free(bp);
> +	error = xfs_buf_alloc(target, &map, 1, flags, bpp);
> +	if (!error)
> +		trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
>  	return error;
>  }
> 
> --
> 2.45.2
> 
> 
