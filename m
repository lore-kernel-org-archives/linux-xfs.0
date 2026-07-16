Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940CA422E34
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784207586; cv=none; b=b+15C5MMk1QQtY4u8QqBiv/qmXZewldjVsEPY/9Wqmiokmh+43zjSYkw/YcfxhHgw289UFSOFXXEmoeKJj1xHr6r6Opmdjv3z/RD+WwrjkY2VxbvI2Di2X/kAP8R0minxKrrd5irwjPcSyL4Lzcn1ozIXGn8w8H3vgXl0vvrqio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784207586; c=relaxed/simple;
	bh=gx9IR2imq3+9mShBDcMQOA2NJtEDL6oK4ZmmxpAxHu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpG3xSVwMg+vy+PKYgXpgbWETmJnwEwka5m7VzXLhK1/Rv3CI2pQPD7tSEXnPXxX7pI8HkpndpOPHF2KUJYANyJ5nZsrOPwvYz7VRrt++KX4E+rgXgRb0wQGlCUYDZqbHX6fho0AkGOlUoYPGbXiskeR3N0dCsD5qjbf5MUFFF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K/5uoV9Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/5uoV9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784207580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f/YN48UjQCe3DjWzj13wkpUne0sALfaPpAJ9HBQf6Zc=;
	b=K/5uoV9QF0z8seHsNt85PTV3o/5iuVLeHTm0oCK9Dg27ABzKMKQFVtx/mRobskgo5ECStu
	hEvHFQCh3/30xCNOmzJrYGCwv/LAlQeklsgzZBaJQ2YXvXLNR9oMS0t6o2midBwKmoxpu8
	vjK3g7VeS+U42v2cxw3vyM7OQHj0nNk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-A29fVAa9PpW_P7Y6yQzCiw-1; Thu,
 16 Jul 2026 09:12:54 -0400
X-MC-Unique: A29fVAa9PpW_P7Y6yQzCiw-1
X-Mimecast-MFC-AGG-ID: A29fVAa9PpW_P7Y6yQzCiw_1784207573
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 967DC1955F68;
	Thu, 16 Jul 2026 13:12:53 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1E67180036E;
	Thu, 16 Jul 2026 13:12:52 +0000 (UTC)
Date: Thu, 16 Jul 2026 09:12:50 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in xfs_buf_get_map
Message-ID: <aljY0uI6jY8y2b3Z@bfoster>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-3-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Jul 15, 2026 at 04:50:55PM +0200, Christoph Hellwig wrote:
> Consolidate the code to lock the buffer based on the passed in flags
> into xfs_buf_get_map instead of having two different sites for buffer
> lookup vs insertation.  This requires initializing b_lock to unlocked on
> allocation and doing an atomic for locking it for newly allocated buffers,
> but greatly simplifies the logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c   | 62 ++++++++++++++++------------------------------
>  fs/xfs/xfs_trace.h |  2 +-
>  2 files changed, 23 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 54e091315d56..e56d4b8b0771 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -282,15 +282,8 @@ xfs_buf_alloc(
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

Maybe I'm missing something, but I thought the point of the locked init
was to ensure that the allocator owns the buffer and can't end up
blocking on the lock with a racing lookup. I.e., the buffer is locked
before it becomes available for external lookup. Do we plan to do that
another way, or are we just dropping that assumption?

Brian

>  	atomic_set(&bp->b_lru_ref, 1);
>  	init_completion(&bp->b_iowait);
>  	INIT_LIST_HEAD(&bp->b_lru);
> @@ -433,33 +426,25 @@ xfs_buf_find_lock(
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
> @@ -509,11 +494,7 @@ xfs_buf_find_insert(
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
> @@ -555,21 +536,20 @@ xfs_buf_get_map(
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
> -			return 0;
> +			return -ENOENT;
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
> @@ -794,9 +774,11 @@ xfs_buf_get_uncached(
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

