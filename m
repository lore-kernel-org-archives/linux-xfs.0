Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0A2258CE5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769169355; cv=none; b=oXGH4WXRLeQFoNnGncCIblbkGokoJFv+OBZeIICOo5TOlJAE0PcTSyMsvyoHVko9ycrwBictGfJ93m0QovA8r1/rOeuCKq7JZn/54yfR+zg2xeZA0KXNEnldU/iBiVr/q/OiYPBkCl8kODNhkkRakbCwDM7/FGVZIhtrDEiRbuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769169355; c=relaxed/simple;
	bh=3NWh+Bb2Yj24A+60+SQHXCDNhklaKMtjHPTZuwHQ2i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GM+o6Szq6AQX/HgffGwzyUqNOhFrxljD4Ipi3w7Kx6o4znpwfd0PP3B7ZkV/dUbT2rnqHKxVssBp/mVh0ysPUQJXMEOXLdrrEoPIDC4KOIJUkMWs6sA/ytSwDiDmeLywS0UF8aJzb8QT2uCl69VnnAszt5LWfqiXn/7FS/FJv7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tw1od7o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tw1od7o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE85C4CEF1;
	Fri, 23 Jan 2026 11:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769169355;
	bh=3NWh+Bb2Yj24A+60+SQHXCDNhklaKMtjHPTZuwHQ2i8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tw1od7o5FHRKBz4rF3tzGR/Se9qaWlDF6AD5jSopz95X8pL30kL8ppNV6jamWXTUq
	 T65Msii88xQ4mvF9wBmJ1bh7Ch3SE1TRpbRpu8LAwL6MEHper0FwtTgD6+Tym//BCs
	 cCDI734mFYeb98YetUlqwQ2U4pRuGPmr/j9vx/M76RtPExx6EJyb4lOfvlhsDhzXjZ
	 HlXohOjIHMH2Khuq5gDikmoyUl71gAlAh9NnrituX56nGvpdpqRSB5GDQAIVP2XTKJ
	 d142qF1vC7LkOnauncQkfRDfN2LqLKtRWQBgo2KwepVu/9kKZkAIVcXo1iXViTV0pg
	 xduHtgCvQL3RA==
Date: Fri, 23 Jan 2026 12:55:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <aXNhqyVDb_RLgaPL@nidhogg.toxiclabs.cc>
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

Looks fine.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
>  	spin_unlock(&bp->b_lock);
>  }
>  
> @@ -442,7 +439,7 @@ xfs_buf_try_hold(
>  	struct xfs_buf		*bp)
>  {
>  	spin_lock(&bp->b_lock);
> -	if (bp->b_hold == 0) {
> +	if (bp->b_hold == -1) {
>  		spin_unlock(&bp->b_lock);
>  		return false;
>  	}
> @@ -862,76 +859,24 @@ xfs_buf_hold(
>  }
>  
>  static void
> -xfs_buf_rele_uncached(
> -	struct xfs_buf		*bp)
> -{
> -	ASSERT(list_empty(&bp->b_lru));
> -
> -	spin_lock(&bp->b_lock);
> -	if (--bp->b_hold) {
> -		spin_unlock(&bp->b_lock);
> -		return;
> -	}
> -	spin_unlock(&bp->b_lock);
> -	xfs_buf_free(bp);
> -}
> -
> -static void
> -xfs_buf_rele_cached(
> +xfs_buf_destroy(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buftarg	*btp = bp->b_target;
> -	struct xfs_perag	*pag = bp->b_pag;
> -	struct xfs_buf_cache	*bch = xfs_buftarg_buf_cache(btp, pag);
> -	bool			freebuf = false;
> -
> -	trace_xfs_buf_rele(bp, _RET_IP_);
> -
> -	spin_lock(&bp->b_lock);
> -	ASSERT(bp->b_hold >= 1);
> -	if (bp->b_hold > 1) {
> -		bp->b_hold--;
> -		goto out_unlock;
> -	}
> +	ASSERT(bp->b_hold < 0);
> +	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
> -	/* we are asked to drop the last reference */
> -	if (atomic_read(&bp->b_lru_ref)) {
> -		/*
> -		 * If the buffer is added to the LRU, keep the reference to the
> -		 * buffer for the LRU and clear the (now stale) dispose list
> -		 * state flag, else drop the reference.
> -		 */
> -		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru))
> -			bp->b_state &= ~XFS_BSTATE_DISPOSE;
> -		else
> -			bp->b_hold--;
> -	} else {
> -		bp->b_hold--;
> -		/*
> -		 * most of the time buffers will already be removed from the
> -		 * LRU, so optimise that case by checking for the
> -		 * XFS_BSTATE_DISPOSE flag indicating the last list the buffer
> -		 * was on was the disposal list
> -		 */
> -		if (!(bp->b_state & XFS_BSTATE_DISPOSE)) {
> -			list_lru_del_obj(&btp->bt_lru, &bp->b_lru);
> -		} else {
> -			ASSERT(list_empty(&bp->b_lru));
> -		}
> +	if (!xfs_buf_is_uncached(bp)) {
> +		struct xfs_buf_cache	*bch =
> +			xfs_buftarg_buf_cache(bp->b_target, bp->b_pag);
>  
> -		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
>  				xfs_buf_hash_params);
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
