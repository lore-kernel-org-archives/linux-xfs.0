Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473762853F7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769184118; cv=none; b=jjpsONevLk7N5xUDmRWlpxB7SodQOak2ucV4ELNyo4sMazODqkfs0te/z204MvaFGjRzH34P5h8WeeOWL7QYZZDr5v4c8KZpAM/Y9FceHejHSopl+vlG17ZsV+EP7GCLEPrHu5ftUzEBZbMXy3ta68PeU+whKaViTyNW1eF9Rhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769184118; c=relaxed/simple;
	bh=EfEvEbhGr3HxFh6caoBrB/FHdjnc+6qxi/iv4Yu+So8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AF5BUvQGYx4WZ2DZPzvPkS0YpZplOFSQNZXzZhBJLsQb/c7WF7CDENG11t8SDFrA7wqPeoeaSuLqzIxVYJt6QYjaX23QmKxMFN8ND6iZ/jwIGlAvOVECa8svgnffTB1OF3nYqENCfx97QNVva++im6p+aQNwmLpBNBYxUSdOYdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EAk4Kt/R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAk4Kt/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769184116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g664VrAiD6M357XHBTkZD0uF6T2dXBxWUzNyMC/QMRg=;
	b=EAk4Kt/RUGOLA1IgmMgmIz8+X8tsqK0E4EkPs2wkeV3Lfa4E9w9nU5UJElyHGNTrkBcEuF
	Cm8jVyvAQXDDCBJDCrQmgpUZLwOT+MNRNalegbKUv/e/7hn1/XcbbRAV3ozAC3i5GeWU0A
	omY/lyiWQM0iQPWEg8X63949kcS2QQ0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-TiCWp4jHNeqAVPv2DAzANg-1; Fri,
 23 Jan 2026 11:01:52 -0500
X-MC-Unique: TiCWp4jHNeqAVPv2DAzANg-1
X-Mimecast-MFC-AGG-ID: TiCWp4jHNeqAVPv2DAzANg_1769184111
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B130119775B0;
	Fri, 23 Jan 2026 16:01:51 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4711195419B;
	Fri, 23 Jan 2026 16:01:50 +0000 (UTC)
Date: Fri, 23 Jan 2026 11:01:48 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <aXObbCA2bu6p_8by@bfoster>
References: <20260122052709.412336-1-hch@lst.de>
 <20260122052709.412336-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122052709.412336-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Jan 22, 2026 at 06:26:55AM +0100, Christoph Hellwig wrote:
> Currently the buffer cache adds a reference to b_hold for buffers that
> are on the LRU.  This seems to go all the way back and allows releasing
> buffers from the LRU using xfs_buf_rele.  But it makes xfs_buf_rele
> really complicated in differs from how other LRUs are implemented in
> Linux.
> 
> Switch to not having a reference for buffers in the LRU, and use a
> separate negative hold value to mark buffers as dead.  This simplifies
> xfs_buf_rele, which now just deal with the last "real" reference,
> and prepares for using the lockref primitive.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf.c | 140 ++++++++++++++++++-----------------------------
>  fs/xfs/xfs_buf.h |   8 +--
>  2 files changed, 54 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index db46883991de..aacdf080e400 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -80,11 +80,8 @@ xfs_buf_stale(
>  
>  	spin_lock(&bp->b_lock);
>  	atomic_set(&bp->b_lru_ref, 0);
> -	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
> -	    (list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru)))
> -		bp->b_hold--;
> -
> -	ASSERT(bp->b_hold >= 1);
> +	if (bp->b_hold >= 0)
> +		list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);

I see that b_hold goes away in subsequent patches, but nonetheless it's
unsigned as of this patch, which kind of makes this look like a
potential bisect bomb. I wouldn't want to turn this into a big effort
just to fix it up mid-series, but maybe this should just change b_hold
to a signed type and call out the transient wart in the commit log?

(A quick/spot test might not hurt either if that hadn't been done.)

>  	spin_unlock(&bp->b_lock);
>  }
>  
...
> @@ -862,76 +859,24 @@ xfs_buf_hold(
>  }
>  
...
> -static void
> -xfs_buf_rele_cached(
> +xfs_buf_destroy(
>  	struct xfs_buf		*bp)
>  {
...
> +	if (!xfs_buf_is_uncached(bp)) {
> +		struct xfs_buf_cache	*bch =
> +			xfs_buftarg_buf_cache(bp->b_target, bp->b_pag);
>  
> -		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
>  				xfs_buf_hash_params);

This looks like a subtle locking change in that we're no longer under
b_lock..? AFAICT that is fine as RCU protection is more important for
the lookup side, but it also might be worth documenting that change in
the commit log as well so it's clear that it is intentional and safe.

Brian

> -		if (pag)
> -			xfs_perag_put(pag);
> -		freebuf = true;
> -	}
>  
> -out_unlock:
> -	spin_unlock(&bp->b_lock);
> +		if (bp->b_pag)
> +			xfs_perag_put(bp->b_pag);
> +	}
>  
> -	if (freebuf)
> -		xfs_buf_free(bp);
> +	xfs_buf_free(bp);
>  }
>  
>  /*
> @@ -942,10 +887,22 @@ xfs_buf_rele(
>  	struct xfs_buf		*bp)
>  {
>  	trace_xfs_buf_rele(bp, _RET_IP_);
> -	if (xfs_buf_is_uncached(bp))
> -		xfs_buf_rele_uncached(bp);
> -	else
> -		xfs_buf_rele_cached(bp);
> +
> +	spin_lock(&bp->b_lock);
> +	if (!--bp->b_hold) {
> +		if (xfs_buf_is_uncached(bp) || !atomic_read(&bp->b_lru_ref))
> +			goto kill;
> +		list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru);
> +	}
> +	spin_unlock(&bp->b_lock);
> +	return;
> +
> +kill:
> +	bp->b_hold = -1;
> +	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
> +	spin_unlock(&bp->b_lock);
> +
> +	xfs_buf_destroy(bp);
>  }
>  
>  /*
> @@ -1254,9 +1211,11 @@ xfs_buf_ioerror_alert(
>  
>  /*
>   * To simulate an I/O failure, the buffer must be locked and held with at least
> - * three references. The LRU reference is dropped by the stale call. The buf
> - * item reference is dropped via ioend processing. The third reference is owned
> - * by the caller and is dropped on I/O completion if the buffer is XBF_ASYNC.
> + * two references.
> + *
> + * The buf item reference is dropped via ioend processing. The second reference
> + * is owned by the caller and is dropped on I/O completion if the buffer is
> + * XBF_ASYNC.
>   */
>  void
>  xfs_buf_ioend_fail(
> @@ -1514,19 +1473,14 @@ xfs_buftarg_drain_rele(
>  
>  	if (!spin_trylock(&bp->b_lock))
>  		return LRU_SKIP;
> -	if (bp->b_hold > 1) {
> +	if (bp->b_hold > 0) {
>  		/* need to wait, so skip it this pass */
>  		spin_unlock(&bp->b_lock);
>  		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
>  		return LRU_SKIP;
>  	}
>  
> -	/*
> -	 * clear the LRU reference count so the buffer doesn't get
> -	 * ignored in xfs_buf_rele().
> -	 */
> -	atomic_set(&bp->b_lru_ref, 0);
> -	bp->b_state |= XFS_BSTATE_DISPOSE;
> +	bp->b_hold = -1;
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lock);
>  	return LRU_REMOVED;
> @@ -1581,7 +1535,7 @@ xfs_buftarg_drain(
>  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
>  					(long long)xfs_buf_daddr(bp));
>  			}
> -			xfs_buf_rele(bp);
> +			xfs_buf_destroy(bp);
>  		}
>  		if (loop++ != 0)
>  			delay(100);
> @@ -1610,11 +1564,23 @@ xfs_buftarg_isolate(
>  	struct list_head	*dispose = arg;
>  
>  	/*
> -	 * we are inverting the lru lock/bp->b_lock here, so use a trylock.
> -	 * If we fail to get the lock, just skip it.
> +	 * We are inverting the lru lock vs bp->b_lock order here, so use a
> +	 * trylock. If we fail to get the lock, just skip the buffer.
>  	 */
>  	if (!spin_trylock(&bp->b_lock))
>  		return LRU_SKIP;
> +
> +	/*
> +	 * If the buffer is in use, remove it from the LRU for now as we can't
> +	 * free it.  It will be added to the LRU again when the reference count
> +	 * hits zero.
> +	 */
> +	if (bp->b_hold > 0) {
> +		list_lru_isolate(lru, &bp->b_lru);
> +		spin_unlock(&bp->b_lock);
> +		return LRU_REMOVED;
> +	}
> +
>  	/*
>  	 * Decrement the b_lru_ref count unless the value is already
>  	 * zero. If the value is already zero, we need to reclaim the
> @@ -1625,7 +1591,7 @@ xfs_buftarg_isolate(
>  		return LRU_ROTATE;
>  	}
>  
> -	bp->b_state |= XFS_BSTATE_DISPOSE;
> +	bp->b_hold = -1;
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lock);
>  	return LRU_REMOVED;
> @@ -1647,7 +1613,7 @@ xfs_buftarg_shrink_scan(
>  		struct xfs_buf *bp;
>  		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>  		list_del_init(&bp->b_lru);
> -		xfs_buf_rele(bp);
> +		xfs_buf_destroy(bp);
>  	}
>  
>  	return freed;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index e25cd2a160f3..1117cd9cbfb9 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -68,11 +68,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_INCORE,		"INCORE" }, \
>  	{ XBF_TRYLOCK,		"TRYLOCK" }
>  
> -/*
> - * Internal state flags.
> - */
> -#define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
> -
>  struct xfs_buf_cache {
>  	struct rhashtable	bc_hash;
>  };
> @@ -159,6 +154,7 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> +	spinlock_t		b_lock;		/* internal state lock */
>  	unsigned int		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
> @@ -169,8 +165,6 @@ struct xfs_buf {
>  	 * bt_lru_lock and not by b_sema
>  	 */
>  	struct list_head	b_lru;		/* lru list */
> -	spinlock_t		b_lock;		/* internal state lock */
> -	unsigned int		b_state;	/* internal state flags */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
>  	struct xfs_perag	*b_pag;
> -- 
> 2.47.3
> 
> 

