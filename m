Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9D62D6E71
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 02:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768877596; cv=none; b=kB6Nk5SKRppAEkWbSjQkBQ3lQnXTXooUFbWQTllc/+6Tim3QeQL7mZZQKUGqYNTXorGSad2ZjHvZTHaCCjYLADOBGIZ99vzI6lBuE1xDxVf87647eUwUkfzS0BiaCMF1c1BCUls4Z3ZxjWuNkugN2SMmKAZh8Dt6mitMLAH5VZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768877596; c=relaxed/simple;
	bh=6VgRxrvaljDFTvsDvnbTffQkW+5v+56L6QPbE5mWZMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8dzmFYxrzLDgoK2pAj094xY3ugq0tHqeq7jvn13OyFK1Ga0uDMnlGIIyJmZtL3bR74eiqZGpUu4/xZM6pc2AhBIsIOF1SxrwTb0qnrkPWZI5wawrk0Ia2E1XVon+3Jl8jfCos8FPoOgxeMaGflSugUH0ECPIaFChIdm5VZCLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=me3cl9w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="me3cl9w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152F2C116C6;
	Tue, 20 Jan 2026 02:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768877596;
	bh=6VgRxrvaljDFTvsDvnbTffQkW+5v+56L6QPbE5mWZMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=me3cl9w5ewGTKOHGCmfUD0VcdB0ZqNXtatLkgVU3+QLSw9Z/kH5wZWttUpasdqAhI
	 ilulxtWSeJcpOF626rwDetqKzJl49at4YvSMIwkz9NWQFe7jZndtICk6r6VJ85lpku
	 BCwj/aAQE0F8ClZ3PB2c8+mXhhPrSFHAPPt4ij27OKvDcRF9GQWYQIgMcbeQGYKk6Z
	 W9AdQeWzNQKWNwHDS1yRe4fFpUFa1DFKbXbXsXWAEZJSZnBdrlU9BeAAkH4zyZjbRH
	 AGGK9SyxIHSG/N2oHGdBsYaHAx2ZXAPHOVnrFVZaP8GtKTwRODTTS3uozkbw7Ya9s8
	 Mo3y6SsX7awFw==
Date: Mon, 19 Jan 2026 18:53:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <20260120025315.GH15551@frogsfrogsfrogs>
References: <20260119153156.4088290-1-hch@lst.de>
 <20260119153156.4088290-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119153156.4088290-2-hch@lst.de>

On Mon, Jan 19, 2026 at 04:31:35PM +0100, Christoph Hellwig wrote:
> Currently the buffer cache adds a reference to b_hold for buffers that
> are on the LRU.  This seems to go all the way back and allows releasing
> buffers from the LRU using xfs_buf_rele.  But it makes xfs_buf_rele
> really complicated in differs from how other LRUs are implemented in
> Linux.

I'd noticed that.

So under the current code, a cached buffer gets created with b_hold=1
and b_lru_ref=1.  Calling xfs_buf_hold can bump up b_hold.  Calling
xfs_buf_rele immediately will either transfer ownership of the buf to
the lru (if it wasn't on the lru ref) or decrement b_hold.

Higher level xfs code might boost b_lru_ref for buffers that it thinks
we should try to hang on to (e.g. AG headers).

xfs_buftarg_isolate will decrement b_lru_ref unless it was already zero,
in which case it'll actually free the buffer.  If xfs_buf_rele finds a
buffer with b_lru_ref==0 it'll drop b_hold and try to free the buffer if
b_hold drops to zero.

Right?

> Switch to not having a reference for buffers in the LRU, and use a
> separate negative hold value to mark buffers as dead.  This simplifies
> xfs_buf_rele, which now just deal with the last "real" reference,
> and prepares for using the lockref primitive.

And now, b_hold is the number of higher-level owners of the buffer.  If
that drops to zero the buffer gets put on the lru list if it hasn't
already run out of lru refs, in which case it's freed directly.  If a
buffer on the lru list runs out of lru refs then it'll get freed.
b_hodl < 0 means "headed for destruction".

Is that also correct?

If yes to both then I've understood what's going on here well enough to 
say:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
