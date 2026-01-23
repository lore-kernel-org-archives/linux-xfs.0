Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B517525BEF8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769169861; cv=none; b=oh7cPuFAuQSVVym7lTav2Luo67NkeP6s1o3OHjMqyPQ0uBb+6rYkXYzvRV2MTDCcLCz8uOW6kh8KhtltVR3WeNfA8zLrgJJmMvv/c75qChZvFQkVr/kkFydrbLmanbX4k5uI6cC0G/l2wAVSsu2LkgdJBwA8DklFkn6/U2l0jMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769169861; c=relaxed/simple;
	bh=6F5lKmw7qu8OLXyk8Pp8ux5LAvz0ot388pfOcNCgeoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLvKQhpm1rFxkp3Z7UIRfrSC5Cyh/6M7LenDynDrvPYYXwEOX1VvGpW5eqOmSI1J51B1nlHlflzLZPgA5VqKuh/cnQa/jNlvutgi1zGl2Id7L/oPW7+OQNgt30vUh1QV+/YuJaG/BlLYRcJY/Nyej4VjUsngtv0kyTdp+tS+37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpotWBV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpotWBV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43236C4CEF1;
	Fri, 23 Jan 2026 12:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769169861;
	bh=6F5lKmw7qu8OLXyk8Pp8ux5LAvz0ot388pfOcNCgeoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MpotWBV5KcyMT0AbwaeFa6pCENarp6v4lUqGL21DgEGO4dnCMNAH0bxEsrssYNFt8
	 5xE41p5/q6y0hQB7FzfJK35RP9QzCMklzAb3xCCMJ59CoaUYupesw2PIm8pZE3IlZA
	 HVZYwk0LBcuZKcBvXD+JoKDNc7xnB7LOmo+RUKDaljWdcrysjb59QNi+YM0ubPcjfw
	 2+Kroevq7GcG8+tgFDI6abms6TIP5lM7ALalnxyqNdJUGwUpKM82EDncgaBkxhm0Yr
	 lUoV9j7J5aIV53D6iSqHNwyaGXZRq3fcp++EaO25apiGDnRxmu7DhqHtvRTtPUMjTW
	 TXQyDAP1vnkIg==
Date: Fri, 23 Jan 2026 13:04:17 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/3] xfs: use a lockref for the buffer reference count
Message-ID: <aXNjvJjmcIbi8rkN@nidhogg.toxiclabs.cc>
References: <20260122052709.412336-1-hch@lst.de>
 <20260122052709.412336-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122052709.412336-3-hch@lst.de>

On Thu, Jan 22, 2026 at 06:26:56AM +0100, Christoph Hellwig wrote:
> The lockref structure allows incrementing/decrementing counters like
> an atomic_t for the fast path, while still allowing complex slow path
> operations as if the counter was protected by a lock.  The only slow
> path operations that actually need to take the lock are the final
> put, LRU evictions and marking a buffer stale.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c   | 79 ++++++++++++++++++----------------------------
>  fs/xfs/xfs_buf.h   |  4 +--
>  fs/xfs/xfs_trace.h | 10 +++---
>  3 files changed, 38 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index aacdf080e400..348c91335163 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -31,20 +31,20 @@ struct kmem_cache *xfs_buf_cache;
>   *
>   * xfs_buf_stale:
>   *	b_sema (caller holds)
> - *	  b_lock
> + *	  b_lockref.lock
>   *	    lru_lock
>   *
>   * xfs_buf_rele:
> - *	b_lock
> + *	b_lockref.lock
>   *	  lru_lock
>   *
>   * xfs_buftarg_drain_rele
>   *	lru_lock
> - *	  b_lock (trylock due to inversion)
> + *	  b_lockref.lock (trylock due to inversion)
>   *
>   * xfs_buftarg_isolate
>   *	lru_lock
> - *	  b_lock (trylock due to inversion)
> + *	  b_lockref.lock (trylock due to inversion)
>   */
>  
>  static void xfs_buf_submit(struct xfs_buf *bp);
> @@ -78,11 +78,11 @@ xfs_buf_stale(
>  	 */
>  	bp->b_flags &= ~_XBF_DELWRI_Q;
>  
> -	spin_lock(&bp->b_lock);
> +	spin_lock(&bp->b_lockref.lock);
>  	atomic_set(&bp->b_lru_ref, 0);
> -	if (bp->b_hold >= 0)
> +	if (!__lockref_is_dead(&bp->b_lockref))
>  		list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
> -	spin_unlock(&bp->b_lock);
> +	spin_unlock(&bp->b_lockref.lock);
>  }
>  
>  static void
> @@ -274,10 +274,8 @@ xfs_buf_alloc(
>  	 * inserting into the hash table are safe (and will have to wait for
>  	 * the unlock to do anything non-trivial).
>  	 */
> -	bp->b_hold = 1;
> +	lockref_init(&bp->b_lockref);
>  	sema_init(&bp->b_sema, 0); /* held, no waiters */
> -
> -	spin_lock_init(&bp->b_lock);
>  	atomic_set(&bp->b_lru_ref, 1);
>  	init_completion(&bp->b_iowait);
>  	INIT_LIST_HEAD(&bp->b_lru);
> @@ -434,20 +432,6 @@ xfs_buf_find_lock(
>  	return 0;
>  }
>  
> -static bool
> -xfs_buf_try_hold(
> -	struct xfs_buf		*bp)
> -{
> -	spin_lock(&bp->b_lock);
> -	if (bp->b_hold == -1) {
> -		spin_unlock(&bp->b_lock);
> -		return false;
> -	}
> -	bp->b_hold++;
> -	spin_unlock(&bp->b_lock);
> -	return true;
> -}
> -
>  static inline int
>  xfs_buf_lookup(
>  	struct xfs_buf_cache	*bch,
> @@ -460,7 +444,7 @@ xfs_buf_lookup(
>  
>  	rcu_read_lock();
>  	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
> -	if (!bp || !xfs_buf_try_hold(bp)) {
> +	if (!bp || !lockref_get_not_dead(&bp->b_lockref)) {
>  		rcu_read_unlock();
>  		return -ENOENT;
>  	}
> @@ -511,7 +495,7 @@ xfs_buf_find_insert(
>  		error = PTR_ERR(bp);
>  		goto out_free_buf;
>  	}
> -	if (bp && xfs_buf_try_hold(bp)) {
> +	if (bp && lockref_get_not_dead(&bp->b_lockref)) {
>  		/* found an existing buffer */
>  		rcu_read_unlock();
>  		error = xfs_buf_find_lock(bp, flags);
> @@ -853,16 +837,14 @@ xfs_buf_hold(
>  {
>  	trace_xfs_buf_hold(bp, _RET_IP_);
>  
> -	spin_lock(&bp->b_lock);
> -	bp->b_hold++;
> -	spin_unlock(&bp->b_lock);
> +	lockref_get(&bp->b_lockref);
>  }
>  
>  static void
>  xfs_buf_destroy(
>  	struct xfs_buf		*bp)
>  {
> -	ASSERT(bp->b_hold < 0);
> +	ASSERT(__lockref_is_dead(&bp->b_lockref));
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
>  	if (!xfs_buf_is_uncached(bp)) {
> @@ -888,19 +870,20 @@ xfs_buf_rele(
>  {
>  	trace_xfs_buf_rele(bp, _RET_IP_);
>  
> -	spin_lock(&bp->b_lock);
> -	if (!--bp->b_hold) {
> +	if (lockref_put_or_lock(&bp->b_lockref))
> +		return;
> +	if (!--bp->b_lockref.count) {
>  		if (xfs_buf_is_uncached(bp) || !atomic_read(&bp->b_lru_ref))
>  			goto kill;
>  		list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru);
>  	}
> -	spin_unlock(&bp->b_lock);
> +	spin_unlock(&bp->b_lockref.lock);
>  	return;
>  
>  kill:
> -	bp->b_hold = -1;
> +	lockref_mark_dead(&bp->b_lockref);
>  	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
> -	spin_unlock(&bp->b_lock);
> +	spin_unlock(&bp->b_lockref.lock);
>  
>  	xfs_buf_destroy(bp);
>  }
> @@ -1471,18 +1454,18 @@ xfs_buftarg_drain_rele(
>  	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
>  	struct list_head	*dispose = arg;
>  
> -	if (!spin_trylock(&bp->b_lock))
> +	if (!spin_trylock(&bp->b_lockref.lock))
>  		return LRU_SKIP;
> -	if (bp->b_hold > 0) {
> +	if (bp->b_lockref.count > 0) {
>  		/* need to wait, so skip it this pass */
> -		spin_unlock(&bp->b_lock);
> +		spin_unlock(&bp->b_lockref.lock);
>  		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
>  		return LRU_SKIP;
>  	}
>  
> -	bp->b_hold = -1;
> +	lockref_mark_dead(&bp->b_lockref);
>  	list_lru_isolate_move(lru, item, dispose);
> -	spin_unlock(&bp->b_lock);
> +	spin_unlock(&bp->b_lockref.lock);
>  	return LRU_REMOVED;
>  }
>  
> @@ -1564,10 +1547,10 @@ xfs_buftarg_isolate(
>  	struct list_head	*dispose = arg;
>  
>  	/*
> -	 * We are inverting the lru lock vs bp->b_lock order here, so use a
> -	 * trylock. If we fail to get the lock, just skip the buffer.
> +	 * We are inverting the lru lock vs bp->b_lockref.lock order here, so
> +	 * use a trylock. If we fail to get the lock, just skip the buffer.
>  	 */
> -	if (!spin_trylock(&bp->b_lock))
> +	if (!spin_trylock(&bp->b_lockref.lock))
>  		return LRU_SKIP;
>  
>  	/*
> @@ -1575,9 +1558,9 @@ xfs_buftarg_isolate(
>  	 * free it.  It will be added to the LRU again when the reference count
>  	 * hits zero.
>  	 */
> -	if (bp->b_hold > 0) {
> +	if (bp->b_lockref.count > 0) {
>  		list_lru_isolate(lru, &bp->b_lru);
> -		spin_unlock(&bp->b_lock);
> +		spin_unlock(&bp->b_lockref.lock);
>  		return LRU_REMOVED;
>  	}
>  
> @@ -1587,13 +1570,13 @@ xfs_buftarg_isolate(
>  	 * buffer, otherwise it gets another trip through the LRU.
>  	 */
>  	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> -		spin_unlock(&bp->b_lock);
> +		spin_unlock(&bp->b_lockref.lock);
>  		return LRU_ROTATE;
>  	}
>  
> -	bp->b_hold = -1;
> +	lockref_mark_dead(&bp->b_lockref);
>  	list_lru_isolate_move(lru, item, dispose);
> -	spin_unlock(&bp->b_lock);
> +	spin_unlock(&bp->b_lockref.lock);
>  	return LRU_REMOVED;
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 1117cd9cbfb9..3a1d066e1c13 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -14,6 +14,7 @@
>  #include <linux/dax.h>
>  #include <linux/uio.h>
>  #include <linux/list_lru.h>
> +#include <linux/lockref.h>
>  
>  extern struct kmem_cache *xfs_buf_cache;
>  
> @@ -154,8 +155,7 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> -	spinlock_t		b_lock;		/* internal state lock */
> -	unsigned int		b_hold;		/* reference count */
> +	struct lockref		b_lockref;	/* refcount + lock */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
>  	struct semaphore	b_sema;		/* semaphore for lockables */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f70afbf3cb19..abf022d5ff42 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -736,7 +736,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->nblks = bp->b_length;
> -		__entry->hold = bp->b_hold;
> +		__entry->hold = bp->b_lockref.count;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->flags = bp->b_flags;
> @@ -810,7 +810,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->length = bp->b_length;
>  		__entry->flags = flags;
> -		__entry->hold = bp->b_hold;
> +		__entry->hold = bp->b_lockref.count;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->caller_ip = caller_ip;
> @@ -854,7 +854,7 @@ TRACE_EVENT(xfs_buf_ioerror,
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->length = bp->b_length;
> -		__entry->hold = bp->b_hold;
> +		__entry->hold = bp->b_lockref.count;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->error = error;
> @@ -898,7 +898,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->buf_bno = xfs_buf_daddr(bip->bli_buf);
>  		__entry->buf_len = bip->bli_buf->b_length;
>  		__entry->buf_flags = bip->bli_buf->b_flags;
> -		__entry->buf_hold = bip->bli_buf->b_hold;
> +		__entry->buf_hold = bip->bli_buf->b_lockref.count;
>  		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
>  		__entry->buf_lockval = bip->bli_buf->b_sema.count;
>  		__entry->li_flags = bip->bli_item.li_flags;
> @@ -5181,7 +5181,7 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
>  		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->nblks = bp->b_length;
> -		__entry->hold = bp->b_hold;
> +		__entry->hold = bp->b_lockref.count;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->flags = bp->b_flags;
> -- 
> 2.47.3
> 
