Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16DE33D6D2
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784910727; cv=none; b=oUoZcrkPfjdoTcYYDb1UpCzF1I4WWhTPZO8FotL6wKkCOymQ1cEpuqz9ueuduth8DcttWrzgnldfRiCWf0CnTCfWQItSrt4WTel8B7b6ovPFXnp8OIrad2IzN1IuvTVLMvmEcMywwMwrORv10yrpQobqEZJ6QIZtYE8aYlpAQTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784910727; c=relaxed/simple;
	bh=pY0v5TX/MBabgySs069BS2M2bjuqZGRg4O6nWHVz+CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KneUk+wEix08AtWG9geIuL97DgBs5XrsZ32plSVhrJgqLNpkKiF8LaRxyy1JAs/9SiJGXpjlPy365krjlXrWO0y60/0DFRgVD/4YLvYxnbBJLys13HsHxRERVU5a09DHYcLU+bRXIJTpUanpfAsOfQJxXRnqrUQr6qgS1ReCKJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WK6fb1WT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WK6fb1WT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 778951F000E9;
	Fri, 24 Jul 2026 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784910725;
	bh=Ziiv7FGvj0CuYSh2lrs4v2RK5erR2BDrtFH+3iR3xCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WK6fb1WTE6c4qi6ohuOIZkQOMBmTyJK9Fr5CW4gieXrlWvuWnkr4B9sl2ggQWj0xc
	 wWm3gJeq2yNclQ7avFULIDsJ2IQOVRbblLmsee1ww7iJvlzn5b5znkwuxSCTcmD6Ef
	 uoMolBXxcK0gsgp+QoCQEm8MLVUJ1bOIl2K8l1eJDa8xBIjYjvrxJ1mjGWJYp3p23j
	 dWQk1vOLJcU8JtZrdSCsOJXNFdvqVaXBEG/j3kLpklhLVvhOoRNU/Ly8p2ROzGAq7E
	 TmSFrHgCsjPoyW5mc5h54Tx1+Yb6XdePncLagLwniLVW93/xCmFva7kEK0P8PZ0G1L
	 LQuEFvO/oGBDA==
Date: Fri, 24 Jul 2026 09:32:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: don't get a pag reference in xfs_buf_get_map
Message-ID: <20260724163204.GO2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-2-hch@lst.de>

On Wed, Jul 15, 2026 at 04:50:54PM +0200, Christoph Hellwig wrote:
> As of commit 497560b9ef42 ("xfs: switch (back) to a per-buftarg buffer
> hash"), buffer lookups don't require the perag structure.  Stop looking
> it up in xfs_buf_get_map, and instead only find it when allocating a new
> buffer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

b_pag is only set for cached buffers for the data device, right?  And
this patch doesn't change that property, it just moves the place where
we get the perag to xfs_buf_find_insert, right?

If yes to both, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 44 ++++++++++----------------------------------
>  1 file changed, 10 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e1465e950acc..54e091315d56 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -469,7 +469,6 @@ xfs_buf_lookup(
>  static int
>  xfs_buf_find_insert(
>  	struct xfs_buftarg	*btp,
> -	struct xfs_perag	*pag,
>  	struct xfs_buf_map	*cmap,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> @@ -482,10 +481,13 @@ xfs_buf_find_insert(
>  
>  	error = xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
>  	if (error)
> -		goto out_drop_pag;
> +		return error;
>  
>  	/* The new buffer keeps the perag reference until it is freed. */
> -	new_bp->b_pag = pag;
> +	if (!xfs_buftarg_is_mem(btp)) {
> +		new_bp->b_pag = xfs_perag_get(btp->bt_mount,
> +			xfs_daddr_to_agno(btp->bt_mount, cmap->bm_bn));
> +	}
>  
>  retry:
>  	rcu_read_lock();
> @@ -520,25 +522,12 @@ xfs_buf_find_insert(
>  	return 0;
>  
>  out_free_buf:
> +	if (new_bp->b_pag)
> +		xfs_perag_put(new_bp->b_pag);
>  	xfs_buf_free(new_bp);
> -out_drop_pag:
> -	if (pag)
> -		xfs_perag_put(pag);
>  	return error;
>  }
>  
> -static inline struct xfs_perag *
> -xfs_buftarg_get_pag(
> -	struct xfs_buftarg		*btp,
> -	const struct xfs_buf_map	*map)
> -{
> -	struct xfs_mount		*mp = btp->bt_mount;
> -
> -	if (xfs_buftarg_is_mem(btp))
> -		return NULL;
> -	return xfs_perag_get(mp, xfs_daddr_to_agno(mp, map->bm_bn));
> -}
> -
>  /*
>   * Assembles a buffer covering the specified range. The code is optimised for
>   * cache hits, as metadata intensive workloads will see 3 orders of magnitude
> @@ -552,7 +541,6 @@ xfs_buf_get_map(
>  	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp)
>  {
> -	struct xfs_perag	*pag;
>  	struct xfs_buf		*bp = NULL;
>  	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
>  	int			error;
> @@ -567,28 +555,21 @@ xfs_buf_get_map(
>  	if (error)
>  		return error;
>  
> -	pag = xfs_buftarg_get_pag(btp, &cmap);
> -
>  	error = xfs_buf_lookup(btp, &cmap, flags, &bp);
>  	if (error && error != -ENOENT)
> -		goto out_put_perag;
> +		return error;
>  
>  	/* cache hits always outnumber misses by at least 10:1 */
>  	if (unlikely(!bp)) {
>  		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
>  
>  		if (flags & XBF_INCORE)
> -			goto out_put_perag;
> -
> -		/* xfs_buf_find_insert() consumes the perag reference. */
> -		error = xfs_buf_find_insert(btp, pag, &cmap, map, nmaps,
> -				flags, &bp);
> +			return 0;
> +		error = xfs_buf_find_insert(btp, &cmap, map, nmaps, flags, &bp);
>  		if (error)
>  			return error;
>  	} else {
>  		XFS_STATS_INC(btp->bt_mount, xb_get_locked);
> -		if (pag)
> -			xfs_perag_put(pag);
>  	}
>  
>  	/*
> @@ -602,11 +583,6 @@ xfs_buf_get_map(
>  	trace_xfs_buf_get(bp, flags, _RET_IP_);
>  	*bpp = bp;
>  	return 0;
> -
> -out_put_perag:
> -	if (pag)
> -		xfs_perag_put(pag);
> -	return error;
>  }
>  
>  int
> -- 
> 2.53.0
> 
> 
