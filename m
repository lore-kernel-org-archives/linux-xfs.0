Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1194127B32C
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 19:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769455132; cv=none; b=OcQLxCYLX1A8cnbe7cvNl4vDKK+nndAHH9Vxw4KePqYZLDJ6Cjc56e+RwMnNa0jzHOTi+7wPrKrr/P9/czJoDkYBs4BNv0wpeC6G8NPYpailWFG7ovwXtH484K0k15i50uyBPRiIj7uZOTzmCYhEU63BKxb9FIaN2Qjjlv8/R6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769455132; c=relaxed/simple;
	bh=4TcNLXCz9O8YK62s4tCmShtwA9T5U/xETxnlyVv+Fpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/+hrd3300dmyT9vDaLHqayb5gYV9HoEroHbgZJVZtC09gDPDWUde7/svsfj9Vbup+mM0HT+054f78LqB6lKWe6CykfDSdn3r/k0Q3iTEQOkeq5c/DSf28GUDUkW/TnbW3AG0TzqZYihlo5YF5tcJv+tb1TzPtxZ28tf9Y2j3Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fWnXIsVW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fWnXIsVW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769455130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9E8IXCwEslGFC/ohfleE1Tud9q/jsg7WWI5WQUpiIXA=;
	b=fWnXIsVW+jAGJBhIi9/oUDcQEiXrOh2/136fnMjJsvM3zaLyoDH1mlE6cMDzAWrFek9YMu
	5Kmo5mzTWAwk/gW4DBgBMvcoBr0l2Mz3KE/ZfK7ulmo3XBrzO749zGJv6KKcb1+xRBTXLG
	wNhNv4bj1ps/MjbBEAkcqRrkr8qxQXg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-ljGjo8S8MuCAS_LuqmGRBQ-1; Mon,
 26 Jan 2026 14:18:46 -0500
X-MC-Unique: ljGjo8S8MuCAS_LuqmGRBQ-1
X-Mimecast-MFC-AGG-ID: ljGjo8S8MuCAS_LuqmGRBQ_1769455125
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A7551800357;
	Mon, 26 Jan 2026 19:18:45 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A345D19560B2;
	Mon, 26 Jan 2026 19:18:44 +0000 (UTC)
Date: Mon, 26 Jan 2026 14:18:42 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <aXe-EkVrEB-UhNy2@bfoster>
References: <20260126053825.1420158-1-hch@lst.de>
 <20260126053825.1420158-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126053825.1420158-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jan 26, 2026 at 06:38:00AM +0100, Christoph Hellwig wrote:
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
> This also removes the b_lock protection for removing buffers from the
> buffer hash.  This is the desired outcome because the rhashtable is
> fully internally synchronized, and previously the lock was mostly
> held out of ordering constrains in xfs_buf_rele_cached.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Thanks for the tweaks..

>  fs/xfs/xfs_buf.c | 140 ++++++++++++++++++-----------------------------
>  fs/xfs/xfs_buf.h |   8 +--
>  2 files changed, 54 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index db46883991de..aacdf080e400 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
...
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

Sorry I missed this on my first look at this, but I don't think I quite
realized why this was here. This looks like a subtle change in behavior
where a buffer that makes it onto the LRU and then is subsequently held
can no longer be cycled off the LRU by background shrinker activity.
Instead, we drop the buffer off the LRU entirely where it will no longer
be visible from ongoing shrinker activity.

AFAICT the reason for this is we no longer support the ability for the
shrinker to drop the LRU b_hold ref to indicate a buffer is fully cycled
out and can go direct to freeing when the current b_hold lifecycle ends.
Am I following that correctly?

If so, that doesn't necessarily seem like a showstopper as I'm not sure
realistically a significant amount of memory would be caught up like
this in practice, even under significant pressure. But regardless, why
not do this preventative LRU removal only after the lru ref count is
fully depleted? Wouldn't that more accurately preserve existing
behavior, or am I missing something?

Brian

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
> index e25cd2a160f3..e7324d58bd96 100644
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
> @@ -159,7 +154,7 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> -	unsigned int		b_hold;		/* reference count */
> +	int			b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
>  	struct semaphore	b_sema;		/* semaphore for lockables */
> @@ -170,7 +165,6 @@ struct xfs_buf {
>  	 */
>  	struct list_head	b_lru;		/* lru list */
>  	spinlock_t		b_lock;		/* internal state lock */
> -	unsigned int		b_state;	/* internal state flags */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
>  	struct xfs_perag	*b_pag;
> -- 
> 2.47.3
> 
> 

