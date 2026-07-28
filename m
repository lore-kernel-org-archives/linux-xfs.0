Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E900542BEB9
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253325; cv=none; b=GLxbfcCjP8RvzXpT4H/xjQoHihgneZ6F+ddMc+5GEkluhjB/qFe6g/s0PLHWDFLo2aBcs87ZojD1Li6KxRNAbrinrXuZBnb75HCOK94WrEYj5am5Lgjk9bRpcyh+RM2nO8BBUKi/iKQuCUnCWd3NBGvk1P5doidL8oETB/s4l/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253325; c=relaxed/simple;
	bh=irLSJw8xwbLw7pmMj9czeIA/IcBg3QODY+CmHI1PcyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uS6JwsQziNObMmFiYTUgyFeIx/CjiT4u+Po1rp6IyHeHlyIRDi/7IclFM0TUYKxsN40xr5mo4sZuL/E/N69LIMySAx1qGYO/g4zjTpNvuO1D7qZooZgDkfjsxm+fyWR44mP9GdVrSZmZAqO7+esfHmPyKoyf2T075xjo6FjmBio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TG6+Z5u6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TG6+Z5u6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DFFE11F000E9;
	Tue, 28 Jul 2026 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785253323;
	bh=bSTeHuaObl+ztfbym8sGP9CXmlIT6vqKkwKLXM7ytVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TG6+Z5u6QbswBlv/MYAJn+a/j9LXLhbhgEpIsDSlWnvjQBgAgQvQi0z0KTpeqaXW9
	 gX1mEBv739wXFdCOtLL/1+FVEVx+M3EN6fIXzsjui+Ve9rrj60smje6uCNjGOMKptJ
	 y8RlG2yfKHqIfcCtA0oiVqPA1LSD/uphLfExRWNmcUofeI8JVAZEOAlGMnbTOC59KA
	 56ImnfSbL1E7ncsthHk7J4eZsg25IdT3gZPDfmQDzgNI5rqskTDA7wIb6VR4H8dvzy
	 pweIVx+WYjANNNPEW3FrVosjLQDxsspJLkSZslZdZknjDSrAiX4Fa5XRXTPpiL7L+B
	 NGf6rNnr0dAZA==
Date: Tue, 28 Jul 2026 08:42:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in xfs_buf_get_map
Message-ID: <20260728154202.GQ2901224@frogsfrogsfrogs>
References: <20260728081152.1778841-1-hch@lst.de>
 <20260728081152.1778841-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728081152.1778841-3-hch@lst.de>

On Tue, Jul 28, 2026 at 10:11:10AM +0200, Christoph Hellwig wrote:
> Consolidate the code to lock the buffer based on the passed in flags
> into xfs_buf_get_map instead of having two different sites for buffer
> lookup vs insertation.  This requires initializing b_lock to unlocked on
> allocation and doing an atomic for locking it for newly allocated buffers,
> but greatly simplifies the logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c   | 73 +++++++++++++++++++++-------------------------
>  fs/xfs/xfs_trace.h |  2 +-
>  2 files changed, 35 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 16b9f3e50551..d4ab69112d11 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -261,6 +261,19 @@ xfs_buf_alloc_backing_mem(
>  	return xfs_buf_alloc_folio(bp, size, gfp_mask);
>  }
>  
> +/*
> + * Allocate a new buffer.
> + *
> + * The creator of a new buffer holds a lockref to that buffer.  This ensures
> + * that the buffer is owned by the caller and racing RCU lookups right after
> + * inserting into the hash table are safe against freeing.
> + *
> + * Racing threads trying to look up the buffer will have to wait for b_sema to
> + * do anything non-trivial.
> + *
> + * Note that b_sema is not locked at creation time, but only when a caller
> + * wants to access the buffer.

Yay comments :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> + */
>  static int
>  xfs_buf_alloc(
>  	struct xfs_buftarg	*target,
> @@ -282,15 +295,8 @@ xfs_buf_alloc(
>  	 * specifically set by later operations on the buffer.
>  	 */
>  	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
> -
> -	/*
> -	 * A new buffer is held and locked by the owner.  This ensures that the
> -	 * buffer is owned by the caller and racing RCU lookups right after
> -	 * inserting into the hash table are safe (and will have to wait for
> -	 * the unlock to do anything non-trivial).
> -	 */
>  	lockref_init(&bp->b_lockref);
> -	sema_init(&bp->b_sema, 0); /* held, no waiters */
> +	sema_init(&bp->b_sema, 1); /* unlocked */
>  	atomic_set(&bp->b_lru_ref, 1);
>  	init_completion(&bp->b_iowait);
>  	INIT_LIST_HEAD(&bp->b_lru);
> @@ -433,33 +439,25 @@ xfs_buf_find_lock(
>  	return 0;
>  }
>  
> -static inline int
> +static inline struct xfs_buf *
>  xfs_buf_lookup(
>  	struct xfs_buftarg	*btp,
> -	struct xfs_buf_map	*map,
> -	xfs_buf_flags_t		flags,
> -	struct xfs_buf		**bpp)
> +	struct xfs_buf_map	*map)
>  {
>  	struct xfs_buf          *bp;
> -	int			error;
>  
>  	rcu_read_lock();
>  	bp = rhashtable_lookup(&btp->bt_hash, map, xfs_buf_hash_params);
>  	if (!bp || !lockref_get_not_dead(&bp->b_lockref)) {
>  		rcu_read_unlock();
> -		return -ENOENT;
> +		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
> +		return NULL;
>  	}
>  	rcu_read_unlock();
>  
> -	error = xfs_buf_find_lock(bp, flags);
> -	if (error) {
> -		xfs_buf_rele(bp);
> -		return error;
> -	}
> -
> -	trace_xfs_buf_find(bp, flags, _RET_IP_);
> -	*bpp = bp;
> -	return 0;
> +	trace_xfs_buf_find(bp, _RET_IP_);
> +	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
> +	return bp;
>  }
>  
>  /*
> @@ -512,11 +510,7 @@ xfs_buf_find_insert(
>  			goto retry;
>  		}
>  		rcu_read_unlock();
> -		error = xfs_buf_find_lock(bp, flags);
> -		if (error)
> -			xfs_buf_rele(bp);
> -		else
> -			*bpp = bp;
> +		*bpp = bp;
>  		goto out_free_buf;
>  	}
>  	rcu_read_unlock();
> @@ -558,21 +552,20 @@ xfs_buf_get_map(
>  	if (error)
>  		return error;
>  
> -	error = xfs_buf_lookup(btp, &cmap, flags, &bp);
> -	if (error && error != -ENOENT)
> -		return error;
> -
>  	/* cache hits always outnumber misses by at least 10:1 */
> +	bp = xfs_buf_lookup(btp, &cmap);
>  	if (unlikely(!bp)) {
> -		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
> -
>  		if (flags & XBF_INCORE)
>  			return -ENOENT;
>  		error = xfs_buf_find_insert(btp, &cmap, map, nmaps, flags, &bp);
>  		if (error)
>  			return error;
> -	} else {
> -		XFS_STATS_INC(btp->bt_mount, xb_get_locked);
> +	}
> +
> +	error = xfs_buf_find_lock(bp, flags);
> +	if (error) {
> +		xfs_buf_rele(bp);
> +		return error;
>  	}
>  
>  	/*
> @@ -797,9 +790,11 @@ xfs_buf_get_uncached(
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
>  
>  	error = xfs_buf_alloc(target, &map, 1, 0, bpp);
> -	if (!error)
> -		trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
> -	return error;
> +	if (error)
> +		return error;
> +	xfs_buf_lock(*bpp);
> +	trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index aeb89ac53bf1..f333c938fbd9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -792,6 +792,7 @@ DEFINE_BUF_EVENT(xfs_buf_backing_folio);
>  DEFINE_BUF_EVENT(xfs_buf_backing_kmem);
>  DEFINE_BUF_EVENT(xfs_buf_backing_vmalloc);
>  DEFINE_BUF_EVENT(xfs_buf_backing_fallback);
> +DEFINE_BUF_EVENT(xfs_buf_find);
>  
>  /* not really buffer traces, but the buf provides useful information */
>  DEFINE_BUF_EVENT(xfs_btree_corrupt);
> @@ -837,7 +838,6 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  DEFINE_EVENT(xfs_buf_flags_class, name, \
>  	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
>  	TP_ARGS(bp, flags, caller_ip))
> -DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_readahead);
> -- 
> 2.53.0
> 
> 
