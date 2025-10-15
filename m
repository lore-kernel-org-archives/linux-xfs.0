Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CFE7494
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760562141; cv=none; b=Zu9oYzz2Wd5UYIHDXeEKad6mRkp4g+O0PVtxUGzHj/6EdfPLhU7wPcJ8JAeFabKTWnEaufAJ22XDqQr062XeJbBhKR/akvH5e9cqWBhdw1jC1cKciAcn/KDyS+kjkh9L8qYjebMxxTbEFTCs01TPuGCLjsxOG8EwS8LmUf6Qiss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760562141; c=relaxed/simple;
	bh=t3+2Gm7QCjEYlemxfMSDlRCGd2W9hlF28/CzdZnJ/oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRACDe9+AiIFHieR/xD1Iqiyoi7QaxALltFvsJsdGJgxt1GCZ9sLrxe06gpc9lqlfk2YtF9IC3LIJpMrEReYwUy5O+PKuXwaXC8lx+oj05VlbrwxUOKsqCOtEP+XtdOO4iJ75s1KL219qqNrIeGCUjh+nt9/dFlMqCB/IJOZkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QliIm1Rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QliIm1Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61546C4CEFB;
	Wed, 15 Oct 2025 21:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760562140;
	bh=t3+2Gm7QCjEYlemxfMSDlRCGd2W9hlF28/CzdZnJ/oI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QliIm1Rhl31lodnfg7VjyRe6x8uleH+sOGzQNSej0pyuQTM4RU0VS8mrTXzyQPDOi
	 QvObgUHnObWS7AQfPg8rjOHDpk5OU5MJ+jimLPdujPKLeuVTlDnh8/JFIqovluIIEx
	 LWyVmScCiACx6Z9DHjw72UNvKQbrzLf/CN/NEr12C60HxeVcCDPT+xHEaWGDLZXrU1
	 CPkfGFRHDmr/qYVVC4b/fj8Lr1mHNQyPSk4oSDMFbUTqob/Ynk6UapyWo6koWGcPed
	 CzgmrS3NAk9QKFR6tFcUh4R4TKWn/e9FEkt9ren2T98BSYG1++lprghC5ejsY1SB9W
	 wgLVhUC0K1w2g==
Date: Wed, 15 Oct 2025 14:02:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] xfs: use a lockref for the xfs_dquot reference
 count
Message-ID: <20251015210219.GA2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-6-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:06AM +0900, Christoph Hellwig wrote:
> The xfs_dquot structure currently uses the anti-pattern of using the
> in-object lock that protects the content to also serialize reference
> count updates for the structure, leading to a cumbersome free path.
> This is partiall papered over by the fact that we never free the dquot

partially

> directly but always through the LRU.  Switch to use a lockref instead and
> move the reference counter manipulations out of q_qlock.
> 
> To make this work, xfs_qm_flush_one and xfs_qm_flush_one are converted to
> acquire a dquot reference while flushing to integrate with the lockref
> "get if not dead" scheme.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |  4 +--
>  fs/xfs/xfs_dquot.c             | 17 ++++++------
>  fs/xfs/xfs_dquot.h             |  6 ++--
>  fs/xfs/xfs_qm.c                | 50 ++++++++++++++++------------------
>  fs/xfs/xfs_trace.h             |  2 +-
>  5 files changed, 37 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 763d941a8420..551d7ae46c5c 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -29,11 +29,9 @@ typedef uint8_t		xfs_dqtype_t;
>   * flags for q_flags field in the dquot.
>   */
>  #define XFS_DQFLAG_DIRTY	(1u << 0)	/* dquot is dirty */
> -#define XFS_DQFLAG_FREEING	(1u << 1)	/* dquot is being torn down */
>  
>  #define XFS_DQFLAG_STRINGS \
> -	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
> -	{ XFS_DQFLAG_FREEING,	"FREEING" }
> +	{ XFS_DQFLAG_DIRTY,	"DIRTY" }
>  
>  /*
>   * We have the possibility of all three quota types being active at once, and
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 97f037fa4181..e53dffe2dcab 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -816,20 +816,17 @@ xfs_qm_dqget_cache_lookup(
>  		return NULL;
>  	}
>  
> -	mutex_lock(&dqp->q_qlock);
> -	if (dqp->q_flags & XFS_DQFLAG_FREEING) {
> -		mutex_unlock(&dqp->q_qlock);
> +	if (!lockref_get_not_dead(&dqp->q_lockref)) {
>  		mutex_unlock(&qi->qi_tree_lock);
>  		trace_xfs_dqget_freeing(dqp);
>  		delay(1);
>  		goto restart;
>  	}
> -
> -	dqp->q_nrefs++;
>  	mutex_unlock(&qi->qi_tree_lock);
>  
>  	trace_xfs_dqget_hit(dqp);
>  	XFS_STATS_INC(mp, xs_qm_dqcachehits);
> +	mutex_lock(&dqp->q_qlock);
>  	return dqp;
>  }
>  
> @@ -867,7 +864,7 @@ xfs_qm_dqget_cache_insert(
>  
>  	/* Return a locked dquot to the caller, with a reference taken. */
>  	mutex_lock(&dqp->q_qlock);
> -	dqp->q_nrefs = 1;
> +	lockref_init(&dqp->q_lockref);
>  	qi->qi_dquots++;
>  
>  out_unlock:
> @@ -1119,18 +1116,22 @@ void
>  xfs_qm_dqput(
>  	struct xfs_dquot	*dqp)
>  {
> -	ASSERT(dqp->q_nrefs > 0);
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  
>  	trace_xfs_dqput(dqp);
>  
> -	if (--dqp->q_nrefs == 0) {
> +	if (lockref_put_or_lock(&dqp->q_lockref))
> +		goto out_unlock;
> +
> +	if (!--dqp->q_lockref.count) {
>  		struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
>  		trace_xfs_dqput_free(dqp);
>  
>  		if (list_lru_add_obj(&qi->qi_lru, &dqp->q_lru))
>  			XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_unused);
>  	}
> +	spin_unlock(&dqp->q_lockref.lock);
> +out_unlock:
>  	mutex_unlock(&dqp->q_qlock);
>  }
>  
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 10c39b8cdd03..c56fbc39d089 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -71,7 +71,7 @@ struct xfs_dquot {
>  	xfs_dqtype_t		q_type;
>  	uint16_t		q_flags;
>  	xfs_dqid_t		q_id;
> -	uint			q_nrefs;
> +	struct lockref		q_lockref;
>  	int			q_bufoffset;
>  	xfs_daddr_t		q_blkno;
>  	xfs_fileoff_t		q_fileoffset;
> @@ -231,9 +231,7 @@ void xfs_dquot_detach_buf(struct xfs_dquot *dqp);
>  
>  static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
>  {
> -	mutex_lock(&dqp->q_qlock);
> -	dqp->q_nrefs++;
> -	mutex_unlock(&dqp->q_qlock);
> +	lockref_get(&dqp->q_lockref);
>  	return dqp;
>  }
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ca3cbff9d873..0d2243d549ad 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -126,14 +126,16 @@ xfs_qm_dqpurge(
>  	void			*data)
>  {
>  	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
> -	int			error = -EAGAIN;
>  
> -	mutex_lock(&dqp->q_qlock);
> -	if ((dqp->q_flags & XFS_DQFLAG_FREEING) || dqp->q_nrefs != 0)
> -		goto out_unlock;
> -
> -	dqp->q_flags |= XFS_DQFLAG_FREEING;
> +	spin_lock(&dqp->q_lockref.lock);
> +	if (dqp->q_lockref.count > 0 || __lockref_is_dead(&dqp->q_lockref)) {
> +		spin_unlock(&dqp->q_lockref.lock);
> +		return -EAGAIN;
> +	}
> +	lockref_mark_dead(&dqp->q_lockref);
> +	spin_unlock(&dqp->q_lockref.lock);
>  
> +	mutex_lock(&dqp->q_qlock);
>  	xfs_qm_dqunpin_wait(dqp);
>  	xfs_dqflock(dqp);
>  
> @@ -144,6 +146,7 @@ xfs_qm_dqpurge(
>  	 */
>  	if (XFS_DQ_IS_DIRTY(dqp)) {
>  		struct xfs_buf	*bp = NULL;
> +		int		error;
>  
>  		/*
>  		 * We don't care about getting disk errors here. We need
> @@ -151,9 +154,9 @@ xfs_qm_dqpurge(
>  		 */
>  		error = xfs_dquot_use_attached_buf(dqp, &bp);
>  		if (error == -EAGAIN) {
> -			xfs_dqfunlock(dqp);
> -			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
> -			goto out_unlock;
> +			/* resurrect the refcount from the dead. */
> +			dqp->q_lockref.count = 0;

Heh, undead dquots.  With the typo fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +			goto out_funlock;
>  		}
>  		if (!bp)
>  			goto out_funlock;
> @@ -192,10 +195,6 @@ xfs_qm_dqpurge(
>  
>  	xfs_qm_dqdestroy(dqp);
>  	return 0;
> -
> -out_unlock:
> -	mutex_unlock(&dqp->q_qlock);
> -	return error;
>  }
>  
>  /*
> @@ -468,7 +467,7 @@ xfs_qm_dquot_isolate(
>  	struct xfs_qm_isolate	*isol = arg;
>  	enum lru_status		ret = LRU_SKIP;
>  
> -	if (!mutex_trylock(&dqp->q_qlock))
> +	if (!spin_trylock(&dqp->q_lockref.lock))
>  		goto out_miss_busy;
>  
>  	/*
> @@ -476,7 +475,7 @@ xfs_qm_dquot_isolate(
>  	 * from the LRU, leave it for the freeing task to complete the freeing
>  	 * process rather than risk it being free from under us here.
>  	 */
> -	if (dqp->q_flags & XFS_DQFLAG_FREEING)
> +	if (__lockref_is_dead(&dqp->q_lockref))
>  		goto out_miss_unlock;
>  
>  	/*
> @@ -485,16 +484,15 @@ xfs_qm_dquot_isolate(
>  	 * again.
>  	 */
>  	ret = LRU_ROTATE;
> -	if (XFS_DQ_IS_DIRTY(dqp) || atomic_read(&dqp->q_pincount) > 0) {
> +	if (XFS_DQ_IS_DIRTY(dqp) || atomic_read(&dqp->q_pincount) > 0)
>  		goto out_miss_unlock;
> -	}
>  
>  	/*
>  	 * This dquot has acquired a reference in the meantime remove it from
>  	 * the freelist and try again.
>  	 */
> -	if (dqp->q_nrefs) {
> -		mutex_unlock(&dqp->q_qlock);
> +	if (dqp->q_lockref.count) {
> +		spin_unlock(&dqp->q_lockref.lock);
>  		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
>  
>  		trace_xfs_dqreclaim_want(dqp);
> @@ -518,10 +516,9 @@ xfs_qm_dquot_isolate(
>  	/*
>  	 * Prevent lookups now that we are past the point of no return.
>  	 */
> -	dqp->q_flags |= XFS_DQFLAG_FREEING;
> -	mutex_unlock(&dqp->q_qlock);
> +	lockref_mark_dead(&dqp->q_lockref);
> +	spin_unlock(&dqp->q_lockref.lock);
>  
> -	ASSERT(dqp->q_nrefs == 0);
>  	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
>  	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
>  	trace_xfs_dqreclaim_done(dqp);
> @@ -529,7 +526,7 @@ xfs_qm_dquot_isolate(
>  	return LRU_REMOVED;
>  
>  out_miss_unlock:
> -	mutex_unlock(&dqp->q_qlock);
> +	spin_unlock(&dqp->q_lockref.lock);
>  out_miss_busy:
>  	trace_xfs_dqreclaim_busy(dqp);
>  	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
> @@ -1466,9 +1463,10 @@ xfs_qm_flush_one(
>  	struct xfs_buf		*bp = NULL;
>  	int			error = 0;
>  
> +	if (!lockref_get_not_dead(&dqp->q_lockref))
> +		return 0;
> +
>  	mutex_lock(&dqp->q_qlock);
> -	if (dqp->q_flags & XFS_DQFLAG_FREEING)
> -		goto out_unlock;
>  	if (!XFS_DQ_IS_DIRTY(dqp))
>  		goto out_unlock;
>  
> @@ -1488,7 +1486,7 @@ xfs_qm_flush_one(
>  		xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
>  out_unlock:
> -	mutex_unlock(&dqp->q_qlock);
> +	xfs_qm_dqput(dqp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 79b8641880ab..46d21eb11ccb 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1350,7 +1350,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  		__entry->id = dqp->q_id;
>  		__entry->type = dqp->q_type;
>  		__entry->flags = dqp->q_flags;
> -		__entry->nrefs = dqp->q_nrefs;
> +		__entry->nrefs = data_race(dqp->q_lockref.count);
>  
>  		__entry->res_bcount = dqp->q_blk.reserved;
>  		__entry->res_rtbcount = dqp->q_rtb.reserved;
> -- 
> 2.47.3
> 
> 
