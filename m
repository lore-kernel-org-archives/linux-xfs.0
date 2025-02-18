Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A491B0439
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 20:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910208; cv=none; b=d0If4FKA878Xfbsk+Kcka+mlLS0TgWmEAK4yYR0LY95DYzPAH6CRMQgCyOL83U8C9nY3PTXOBZaHBIE95dv+5fAbtWQduhpLPpBrT8IToxZTZIivpmiNpMkaVZZW81u7VPVoYoASLLy+oA9SpG80rGv4KonmJ1d+RDb7S4rlJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910208; c=relaxed/simple;
	bh=U8IxAfrmqLOjOxUZi2yxRqkfOVhXM6mj/NRTmATZWxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjoMtGkBqaUNWtjCHOmjZ8HHs5QywFJlt6QcsGWOcxoMudKXdm+XNth8uBSY1xYNTVK0CWvbwYX2AhA2XziHxnSZUrGYIWHgluTLIBnDZIyUCcO8524Ya2RkULQUC6uUYPJicuQb1Z8YLfu35AE5kE8N11OyFb/qjh5e+1/3cDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdZbKoFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdZbKoFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99751C4CEE2;
	Tue, 18 Feb 2025 20:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739910207;
	bh=U8IxAfrmqLOjOxUZi2yxRqkfOVhXM6mj/NRTmATZWxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mdZbKoFlbV2PHj0xNwrJF06OYOt1MZCoV20lt089sq0jB+fZQobASqznHd+NnXA2y
	 Xg67SBLKA7r3Tyq/bakSmiPnlbDdKT6vJB8iEKaZFe64ZfGvlQm6n+PhekXwfg11R2
	 MupnYNjAukee8LrjmUUWu0KmzKbdPRo7CUsj9avvKzf+L2Rv6t4hm2hXgB3E4v8A8A
	 BCwcz2fe/QP1TpjO0IR0NjDuyEQYW0DrNowWONrag2PUSvbUhM6Bz9dypzBVX8nr7K
	 Ia3CztY+QO0HOxZqX2/9ZiddbB4skYAz2T8sczgmorPbAMloO8Jmaax3WhVeFPFNkg
	 rlPg31EzaQUzg==
Date: Tue, 18 Feb 2025 12:23:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove most in-flight buffer accounting
Message-ID: <20250218202327.GI21808@frogsfrogsfrogs>
References: <20250217093207.3769550-1-hch@lst.de>
 <20250217093207.3769550-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217093207.3769550-4-hch@lst.de>

On Mon, Feb 17, 2025 at 10:31:28AM +0100, Christoph Hellwig wrote:
> The buffer cache keeps a bt_io_count per-CPU counter to track all
> in-flight I/O, which is used to ensure no I/O is in flight when
> unmounting the file system.
> 
> For most I/O we already keep track of inflight I/O at higher levels:
> 
>  - for synchronous I/O (xfs_buf_read/xfs_bwrite/xfs_buf_delwri_submit),
>    the caller has a reference and waits for I/O completions using
>    xfs_buf_iowait
>  - for xfs_buf_delwri_submit the only caller (AIL writeback) tracks the

Do you mean xfs_buf_delwri_submit_nowait here?

>    log items that the buffer attached to
> 
> This only leaves only xfs_buf_readahead_map as a submitter of
> asynchronous I/O that is not tracked by anything else.  Replace the
> bt_io_count per-cpu counter with a more specific bt_readahead_count
> counter only tracking readahead I/O.  This allows to simply increment
> it when submitting readahead I/O and decrementing it when it completed,
> and thus simplify xfs_buf_rele and remove the needed for the
> XBF_NO_IOACCT flags and the XFS_BSTATE_IN_FLIGHT buffer state.

IOWs, only asynchronous readahead needs an explicit counter in the
xfs_buf to prevent unmount because:

0. Anything done in mount/unmount/freeze holds s_umount
1. Buffer reads done on behalf of a file hold the file open and pin the
   mount
2. Dirty buffers have log items, and we can't unmount until those are
   dealt with
3. Fsck holds an open fd and hence pins the mount
4. Unmount blocks until background gc finishes

Right?  I almost wonder if you could just have a percpu counter in the
xfs_mount but that sounds pretty hot.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c     | 90 ++++++++------------------------------------
>  fs/xfs/xfs_buf.h     |  5 +--
>  fs/xfs/xfs_buf_mem.c |  2 +-
>  fs/xfs/xfs_mount.c   |  7 +---
>  fs/xfs/xfs_rtalloc.c |  2 +-
>  5 files changed, 20 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 52fb85c42e94..f8efdee3c8b4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -29,11 +29,6 @@ struct kmem_cache *xfs_buf_cache;
>  /*
>   * Locking orders
>   *
> - * xfs_buf_ioacct_inc:
> - * xfs_buf_ioacct_dec:
> - *	b_sema (caller holds)
> - *	  b_lock
> - *
>   * xfs_buf_stale:
>   *	b_sema (caller holds)
>   *	  b_lock
> @@ -81,51 +76,6 @@ xfs_buf_vmap_len(
>  	return (bp->b_page_count * PAGE_SIZE);
>  }
>  
> -/*
> - * Bump the I/O in flight count on the buftarg if we haven't yet done so for
> - * this buffer. The count is incremented once per buffer (per hold cycle)
> - * because the corresponding decrement is deferred to buffer release. Buffers
> - * can undergo I/O multiple times in a hold-release cycle and per buffer I/O
> - * tracking adds unnecessary overhead. This is used for sychronization purposes
> - * with unmount (see xfs_buftarg_drain()), so all we really need is a count of
> - * in-flight buffers.
> - *
> - * Buffers that are never released (e.g., superblock, iclog buffers) must set
> - * the XBF_NO_IOACCT flag before I/O submission. Otherwise, the buftarg count
> - * never reaches zero and unmount hangs indefinitely.
> - */
> -static inline void
> -xfs_buf_ioacct_inc(
> -	struct xfs_buf	*bp)
> -{
> -	if (bp->b_flags & XBF_NO_IOACCT)
> -		return;
> -
> -	ASSERT(bp->b_flags & XBF_ASYNC);
> -	spin_lock(&bp->b_lock);
> -	if (!(bp->b_state & XFS_BSTATE_IN_FLIGHT)) {
> -		bp->b_state |= XFS_BSTATE_IN_FLIGHT;
> -		percpu_counter_inc(&bp->b_target->bt_io_count);
> -	}
> -	spin_unlock(&bp->b_lock);
> -}
> -
> -/*
> - * Clear the in-flight state on a buffer about to be released to the LRU or
> - * freed and unaccount from the buftarg.
> - */
> -static inline void
> -__xfs_buf_ioacct_dec(
> -	struct xfs_buf	*bp)
> -{
> -	lockdep_assert_held(&bp->b_lock);
> -
> -	if (bp->b_state & XFS_BSTATE_IN_FLIGHT) {
> -		bp->b_state &= ~XFS_BSTATE_IN_FLIGHT;
> -		percpu_counter_dec(&bp->b_target->bt_io_count);
> -	}
> -}
> -
>  /*
>   * When we mark a buffer stale, we remove the buffer from the LRU and clear the
>   * b_lru_ref count so that the buffer is freed immediately when the buffer
> @@ -156,8 +106,6 @@ xfs_buf_stale(
>  	 * status now to preserve accounting consistency.
>  	 */
>  	spin_lock(&bp->b_lock);
> -	__xfs_buf_ioacct_dec(bp);
> -
>  	atomic_set(&bp->b_lru_ref, 0);
>  	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
>  	    (list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru)))
> @@ -946,6 +894,7 @@ xfs_buf_readahead_map(
>  	bp->b_ops = ops;
>  	bp->b_flags &= ~(XBF_WRITE | XBF_DONE);
>  	bp->b_flags |= flags;
> +	percpu_counter_inc(&target->bt_readahead_count);
>  	xfs_buf_submit(bp);
>  }
>  
> @@ -1002,10 +951,12 @@ xfs_buf_get_uncached(
>  	struct xfs_buf		*bp;
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
>  
> +	/* there are currently no valid flags for xfs_buf_get_uncached */
> +	ASSERT(flags == 0);

Can we just get rid of flags then?  AFAICT nobody uses it either here or
in xfsprogs, and in fact I think there's a nasty bug in the userspace
rtsb code:

	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
			XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR, &rtsb_bp);

(Note: the second to last argument is flags, not daddr.)

Will send a patch for xfsprogs fixing that.

--D

> +
>  	*bpp = NULL;
>  
> -	/* flags might contain irrelevant bits, pass only what we care about */
> -	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
> +	error = _xfs_buf_alloc(target, &map, 1, flags, &bp);
>  	if (error)
>  		return error;
>  
> @@ -1059,7 +1010,6 @@ xfs_buf_rele_uncached(
>  		spin_unlock(&bp->b_lock);
>  		return;
>  	}
> -	__xfs_buf_ioacct_dec(bp);
>  	spin_unlock(&bp->b_lock);
>  	xfs_buf_free(bp);
>  }
> @@ -1078,19 +1028,11 @@ xfs_buf_rele_cached(
>  	spin_lock(&bp->b_lock);
>  	ASSERT(bp->b_hold >= 1);
>  	if (bp->b_hold > 1) {
> -		/*
> -		 * Drop the in-flight state if the buffer is already on the LRU
> -		 * and it holds the only reference. This is racy because we
> -		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
> -		 * ensures the decrement occurs only once per-buf.
> -		 */
> -		if (--bp->b_hold == 1 && !list_empty(&bp->b_lru))
> -			__xfs_buf_ioacct_dec(bp);
> +		bp->b_hold--;
>  		goto out_unlock;
>  	}
>  
>  	/* we are asked to drop the last reference */
> -	__xfs_buf_ioacct_dec(bp);
>  	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
>  		/*
>  		 * If the buffer is added to the LRU, keep the reference to the
> @@ -1369,6 +1311,8 @@ __xfs_buf_ioend(
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
>  			bp->b_flags |= XBF_DONE;
> +		if (bp->b_flags & XBF_READ_AHEAD)
> +			percpu_counter_dec(&bp->b_target->bt_readahead_count);
>  	} else {
>  		if (!bp->b_error) {
>  			bp->b_flags &= ~XBF_WRITE_FAIL;
> @@ -1657,9 +1601,6 @@ xfs_buf_submit(
>  	 */
>  	bp->b_error = 0;
>  
> -	if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_ioacct_inc(bp);
> -
>  	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
>  		xfs_buf_ioend(bp);
> @@ -1785,9 +1726,8 @@ xfs_buftarg_wait(
>  	struct xfs_buftarg	*btp)
>  {
>  	/*
> -	 * First wait on the buftarg I/O count for all in-flight buffers to be
> -	 * released. This is critical as new buffers do not make the LRU until
> -	 * they are released.
> +	 * First wait for all in-flight readahead buffers to be released.  This is
> +	 8 critical as new buffers do not make the LRU until they are released.
>  	 *
>  	 * Next, flush the buffer workqueue to ensure all completion processing
>  	 * has finished. Just waiting on buffer locks is not sufficient for
> @@ -1796,7 +1736,7 @@ xfs_buftarg_wait(
>  	 * all reference counts have been dropped before we start walking the
>  	 * LRU list.
>  	 */
> -	while (percpu_counter_sum(&btp->bt_io_count))
> +	while (percpu_counter_sum(&btp->bt_readahead_count))
>  		delay(100);
>  	flush_workqueue(btp->bt_mount->m_buf_workqueue);
>  }
> @@ -1913,8 +1853,8 @@ xfs_destroy_buftarg(
>  	struct xfs_buftarg	*btp)
>  {
>  	shrinker_free(btp->bt_shrinker);
> -	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
> -	percpu_counter_destroy(&btp->bt_io_count);
> +	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
> +	percpu_counter_destroy(&btp->bt_readahead_count);
>  	list_lru_destroy(&btp->bt_lru);
>  }
>  
> @@ -1968,7 +1908,7 @@ xfs_init_buftarg(
>  
>  	if (list_lru_init(&btp->bt_lru))
>  		return -ENOMEM;
> -	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
> +	if (percpu_counter_init(&btp->bt_readahead_count, 0, GFP_KERNEL))
>  		goto out_destroy_lru;
>  
>  	btp->bt_shrinker =
> @@ -1982,7 +1922,7 @@ xfs_init_buftarg(
>  	return 0;
>  
>  out_destroy_io_count:
> -	percpu_counter_destroy(&btp->bt_io_count);
> +	percpu_counter_destroy(&btp->bt_readahead_count);
>  out_destroy_lru:
>  	list_lru_destroy(&btp->bt_lru);
>  	return -ENOMEM;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 2e747555ad3f..80e06eecaf56 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -27,7 +27,6 @@ struct xfs_buf;
>  #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
>  #define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
>  #define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
> -#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
>  #define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
>  #define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
>  #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
> @@ -58,7 +57,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_READ,		"READ" }, \
>  	{ XBF_WRITE,		"WRITE" }, \
>  	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
> -	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
>  	{ XBF_ASYNC,		"ASYNC" }, \
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
> @@ -77,7 +75,6 @@ typedef unsigned int xfs_buf_flags_t;
>   * Internal state flags.
>   */
>  #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
> -#define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
>  
>  struct xfs_buf_cache {
>  	struct rhashtable	bc_hash;
> @@ -116,7 +113,7 @@ struct xfs_buftarg {
>  	struct shrinker		*bt_shrinker;
>  	struct list_lru		bt_lru;
>  
> -	struct percpu_counter	bt_io_count;
> +	struct percpu_counter	bt_readahead_count;
>  	struct ratelimit_state	bt_ioerror_rl;
>  
>  	/* Atomic write unit values */
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index 07bebbfb16ee..5b64a2b3b113 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -117,7 +117,7 @@ xmbuf_free(
>  	struct xfs_buftarg	*btp)
>  {
>  	ASSERT(xfs_buftarg_is_mem(btp));
> -	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
> +	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
>  
>  	trace_xmbuf_free(btp);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 477c5262cf91..b69356582b86 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -181,14 +181,11 @@ xfs_readsb(
>  
>  	/*
>  	 * Allocate a (locked) buffer to hold the superblock. This will be kept
> -	 * around at all times to optimize access to the superblock. Therefore,
> -	 * set XBF_NO_IOACCT to make sure it doesn't hold the buftarg count
> -	 * elevated.
> +	 * around at all times to optimize access to the superblock.
>  	 */
>  reread:
>  	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
> -				      BTOBB(sector_size), XBF_NO_IOACCT, &bp,
> -				      buf_ops);
> +				      BTOBB(sector_size), 0, &bp, buf_ops);
>  	if (error) {
>  		if (loud)
>  			xfs_warn(mp, "SB validate failed with error %d.", error);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d8e6d073d64d..57bef567e011 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1407,7 +1407,7 @@ xfs_rtmount_readsb(
>  
>  	/* m_blkbb_log is not set up yet */
>  	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
> -			mp->m_sb.sb_blocksize >> BBSHIFT, XBF_NO_IOACCT, &bp,
> +			mp->m_sb.sb_blocksize >> BBSHIFT, 0, &bp,
>  			&xfs_rtsb_buf_ops);
>  	if (error) {
>  		xfs_warn(mp, "rt sb validate failed with error %d.", error);
> -- 
> 2.45.2
> 
> 
