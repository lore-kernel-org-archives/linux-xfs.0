Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93313B7A3
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773784404; cv=none; b=K09Bey9gIHBdfOGvo8V1psBQ+t3yTSMnduVxi9U0KCnOLr/URXQkls5x0qRbotPovTyjVCecUz5v6d/jTxKLTNCsXPBkzFzVJ95+oKBO3j5cQkmG8cm2NN9JqXD7Wrdrxwa4exHhxt0Mk3bL791TPZGWrObUmMF1b19vIwy1BFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773784404; c=relaxed/simple;
	bh=zt8UINgtJgNyeH5/0SoKaP0CrJseC/cP7iGNxy9+82A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZxg0RjqHppYzFS5RBjdrEQpgKR80bfMfwmHh+T6WUU7P7dhDDL+2wcgRBkjTO8x87MNoL5b0X9AAaMGvZDQwxqSwfW2I3rlmLc0fJC+Z7nMBs6sQEiXS6lcoPNCubMXEvNtVHorTr+I1E8J8aBEFdAFHCDEjLXw4ZLUDuaYap8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awu0tx1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awu0tx1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA3DC4CEF7;
	Tue, 17 Mar 2026 21:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773784403;
	bh=zt8UINgtJgNyeH5/0SoKaP0CrJseC/cP7iGNxy9+82A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=awu0tx1SCvDQlLFr5DkWif9oay/dgxD3rpV76kSLTEMAaGT9kRy5qVsSIxGeFciSy
	 NuXlDWL/PccwsJjw9l+JOWfrUEMRW+xfoiQre8jvpNPx3WlyssUB32sf8tmu8+85yX
	 Z4qfJHI01ebe0ibiwyepLcUGdytJSN9iBdw9211TiZtHN/WLAO4ek0IuzYkSkDp4dG
	 wEDoVXaZ5A6MCbjvzZRNc7GXMkpZ0mqsojncKr+/vZnJbigPg62BHSJhIBjht+tZ1p
	 IrfvuHVWiQQLqP8GSC+OdOqpTWkz8KmNPJFl3263hdSUO0UGi+HOSrhZHXkyt/hWbL
	 iu2hgMxmUMtVA==
Date: Wed, 18 Mar 2026 08:53:13 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/4] xfs: use a lockref for the buffer reference count
Message-ID: <abnNSZy-N8ITNKul@dread>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134110.1691097-3-hch@lst.de>

On Tue, Mar 17, 2026 at 02:40:53PM +0100, Christoph Hellwig wrote:
> The lockref structure allows incrementing/decrementing counters like
> an atomic_t for the fast path, while still allowing complex slow path
> operations as if the counter was protected by a lock.  The only slow
> path operations that actually need to take the lock are the final
> put, LRU evictions and marking a buffer stale.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Seems straight forward enough, even if it is more verbose...

> @@ -853,16 +837,14 @@ xfs_buf_hold(
>  {
>  	trace_xfs_buf_hold(bp, _RET_IP_);
>  
> -	spin_lock(&bp->b_lock);
> -	bp->b_hold++;
> -	spin_unlock(&bp->b_lock);
> +	lockref_get(&bp->b_lockref);
>  }

Can we make xfs_buf_hold a static inline in xfs_buf.h now? It is
called quite frequently and it's now just a one line wrapper
around the lockref code...

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

You modify this comment and whitespace in the previous patch without
any code change, and then do it again in this patch with a code
change. Can you collapse that just into a single change in this
patch with the code change?

> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index e7324d58bd96..3a1d066e1c13 100644
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
> @@ -154,7 +155,7 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> -	int			b_hold;		/* reference count */
> +	struct lockref		b_lockref;	/* refcount + lock */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */

IIUC, this adds a 4 byte hole to the structure - b_lockref is an aligned
u64...

>  	xfs_buf_flags_t		b_flags;	/* status flags */

And we end up with another 4 byte hole here because...

>  	struct semaphore	b_sema;		/* semaphore for lockables */

the struct semaphore also ends up being u64 aligned...

The first cacheline of the xfs_buf is explicitly packed
packed with the fields that a hash lookup needs to
minimise cacheline misses during lookup, so we really don't want to
screw that up by wasting space in the first cacheline.

Indeed, seeing as we've simplified the structure of the cache index
over time and are moving back to a global cache index, we probably
need to take another look at exactly where the cacheline boundary
sits and exactly what the lockless lookup fast path accesses. i.e.
make sure that lookups only access the first cacheline, and there is
nothing on that first cacheline that any other concurrent buffer
access might contend on (e.g. lru list scanning, wait queues, pure
read-only accesses, etc.)

Otherwise, the code change looks ok.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
