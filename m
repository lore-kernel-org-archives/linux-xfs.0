Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178A198831
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740506757; cv=none; b=qieamGy9cZtFSHlUyKIMos4Q1m508xGI1ELfdKTxXdxh7cg+lvcC/tDwR2wj4oEGi36juCxljgLqVRXPnstn/e1iAGRhwqk60zNJCaOPA5Wy3VQnL5zv8swfxc7gRierbPpC3/LnlJ+Xzw9g296z5GhZJklZwBe9vCuaULYl0ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740506757; c=relaxed/simple;
	bh=tDMDfbGB+3oBDq8Ampy4j+50klLNPAZMMAvzRN7Zgug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpMGTClfeEEk09fwZjGGu+TjE3FjwkyRUcMla4hOcOtEfn576cnaQQh8dn780GZd3QprP8g28gF7TR9fseDoRCTkdjZ4nLUXPE4pHsfrGZjOZP9PXb1WwaCZGevUSPZDOwT8PwjaA7TudUtOpzyThK5Y90S3gJDoMaT1rKbBbGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b82OhGfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b82OhGfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D073C4CEE2;
	Tue, 25 Feb 2025 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740506756;
	bh=tDMDfbGB+3oBDq8Ampy4j+50klLNPAZMMAvzRN7Zgug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b82OhGfXPGgho5zdt9e6QdBDp+vywKymywvr8xpjfoFATYFyeUE45zrfBzbSV10Wv
	 Wa9eilZTEWexZdMWDRKHV6+sPHTpFqK5CUc4uQmUwVreIBucG6pQvWSTfyBTUl9fJ3
	 2JuWwmeIa830tJx5hv1AtuYJFCUARp+KvCy3KnWJ29drDETkvpLgF/c1XxCqtYUkb4
	 fU9brODtb2xmmSzgkcvLSzNGTeKaLVIwTcdIyUDQLU36Ni3vYp2esPBq5etPmwzpGP
	 uPzubMkdCOnKSsaXb0P9pdF+qfb43PDo89InxLvne/xzQE6D1rwUzE0QcF3znPbNsv
	 kRUyXLuy16LOQ==
Date: Tue, 25 Feb 2025 10:05:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/45] xfs: support reserved blocks for the rt extent
 counter
Message-ID: <20250225180556.GI6242@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-4-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:06AM +0100, Christoph Hellwig wrote:
> The zoned space allocator will need reserved RT extents for garbage
> collection and zeroing of partial blocks.  Move the resblks related
> fields into the freecounter array so that they can be used for all
> counters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/fscounters.c |  2 +-
>  fs/xfs/xfs_fsops.c        | 25 ++++++++++++----------
>  fs/xfs/xfs_fsops.h        |  3 ++-
>  fs/xfs/xfs_ioctl.c        |  6 +++---
>  fs/xfs/xfs_mount.c        | 44 ++++++++++++++++++---------------------
>  fs/xfs/xfs_mount.h        | 12 ++++++++---
>  fs/xfs/xfs_super.c        | 32 +++++++++++++++++-----------
>  7 files changed, 69 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 207a238de429..9dd893ece188 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -350,7 +350,7 @@ xchk_fscount_aggregate_agcounts(
>  	 * The global incore space reservation is taken from the incore
>  	 * counters, so leave that out of the computation.
>  	 */
> -	fsc->fdblocks -= mp->m_resblks_avail;
> +	fsc->fdblocks -= mp->m_free[XC_FREE_BLOCKS].res_avail;
>  
>  	/*
>  	 * Delayed allocation reservations are taken out of the incore counters
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 58249f37a7ad..f055aebe4c7a 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -366,6 +366,7 @@ xfs_growfs_log(
>  int
>  xfs_reserve_blocks(
>  	struct xfs_mount	*mp,
> +	enum xfs_free_counter	ctr,
>  	uint64_t		request)
>  {
>  	int64_t			lcounter, delta;
> @@ -373,6 +374,8 @@ xfs_reserve_blocks(
>  	int64_t			free;
>  	int			error = 0;
>  
> +	ASSERT(ctr < XC_FREE_NR);
> +
>  	/*
>  	 * With per-cpu counters, this becomes an interesting problem. we need
>  	 * to work out if we are freeing or allocation blocks first, then we can
> @@ -391,16 +394,16 @@ xfs_reserve_blocks(
>  	 * counters directly since we shouldn't have any problems unreserving
>  	 * space.
>  	 */
> -	if (mp->m_resblks > request) {
> -		lcounter = mp->m_resblks_avail - request;
> +	if (mp->m_free[ctr].res_total > request) {
> +		lcounter = mp->m_free[ctr].res_avail - request;
>  		if (lcounter > 0) {		/* release unused blocks */
>  			fdblks_delta = lcounter;
> -			mp->m_resblks_avail -= lcounter;
> +			mp->m_free[ctr].res_avail -= lcounter;
>  		}
> -		mp->m_resblks = request;
> +		mp->m_free[ctr].res_total = request;
>  		if (fdblks_delta) {
>  			spin_unlock(&mp->m_sb_lock);
> -			xfs_add_fdblocks(mp, fdblks_delta);
> +			xfs_add_freecounter(mp, ctr, fdblks_delta);
>  			spin_lock(&mp->m_sb_lock);
>  		}
>  
> @@ -419,10 +422,10 @@ xfs_reserve_blocks(
>  	 * space to fill it because mod_fdblocks will refill an undersized
>  	 * reserve when it can.
>  	 */
> -	free = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS) -
> -		xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS);
> -	delta = request - mp->m_resblks;
> -	mp->m_resblks = request;
> +	free = xfs_sum_freecounter_raw(mp, ctr) -
> +		xfs_freecounter_unavailable(mp, ctr);
> +	delta = request - mp->m_free[ctr].res_total;
> +	mp->m_free[ctr].res_total = request;
>  	if (delta > 0 && free > 0) {
>  		/*
>  		 * We'll either succeed in getting space from the free block
> @@ -436,9 +439,9 @@ xfs_reserve_blocks(
>  		 */
>  		fdblks_delta = min(free, delta);
>  		spin_unlock(&mp->m_sb_lock);
> -		error = xfs_dec_fdblocks(mp, fdblks_delta, 0);
> +		error = xfs_dec_freecounter(mp, ctr, fdblks_delta, 0);
>  		if (!error)
> -			xfs_add_fdblocks(mp, fdblks_delta);
> +			xfs_add_freecounter(mp, ctr, fdblks_delta);
>  		spin_lock(&mp->m_sb_lock);
>  	}
>  out:
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 3e2f73bcf831..9d23c361ef56 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -8,7 +8,8 @@
>  
>  int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
>  int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
> -int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
> +int xfs_reserve_blocks(struct xfs_mount *mp, enum xfs_free_counter cnt,
> +		uint64_t request);
>  int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
>  
>  int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0418aad2db91..d250f7f74e3b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1131,15 +1131,15 @@ xfs_ioctl_getset_resblocks(
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -		error = xfs_reserve_blocks(mp, fsop.resblks);
> +		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS, fsop.resblks);
>  		mnt_drop_write_file(filp);
>  		if (error)
>  			return error;
>  	}
>  
>  	spin_lock(&mp->m_sb_lock);
> -	fsop.resblks = mp->m_resblks;
> -	fsop.resblks_avail = mp->m_resblks_avail;
> +	fsop.resblks = mp->m_free[XC_FREE_BLOCKS].res_total;
> +	fsop.resblks_avail = mp->m_free[XC_FREE_BLOCKS].res_avail;
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	if (copy_to_user(arg, &fsop, sizeof(fsop)))
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ee97a927bc3b..c401fd47c763 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1056,7 +1056,8 @@ xfs_mountfs(
>  	 * we were already there on the last unmount. Warn if this occurs.
>  	 */
>  	if (!xfs_is_readonly(mp)) {
> -		error = xfs_reserve_blocks(mp, xfs_default_resblks(mp));
> +		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS,
> +				xfs_default_resblks(mp));
>  		if (error)
>  			xfs_warn(mp,
>  	"Unable to allocate reserve blocks. Continuing without reserve pool.");
> @@ -1176,7 +1177,7 @@ xfs_unmountfs(
>  	 * we only every apply deltas to the superblock and hence the incore
>  	 * value does not matter....
>  	 */
> -	error = xfs_reserve_blocks(mp, 0);
> +	error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS, 0);
>  	if (error)
>  		xfs_warn(mp, "Unable to free reserved block pool. "
>  				"Freespace may not be correct on next mount.");
> @@ -1247,26 +1248,26 @@ xfs_add_freecounter(
>  	enum xfs_free_counter	ctr,
>  	uint64_t		delta)
>  {
> -	bool			has_resv_pool = (ctr == XC_FREE_BLOCKS);
> +	struct xfs_freecounter	*counter = &mp->m_free[ctr];
>  	uint64_t		res_used;
>  
>  	/*
>  	 * If the reserve pool is depleted, put blocks back into it first.
>  	 * Most of the time the pool is full.
>  	 */
> -	if (!has_resv_pool || mp->m_resblks == mp->m_resblks_avail) {
> -		percpu_counter_add(&mp->m_free[ctr].count, delta);
> +	if (likely(counter->res_avail == counter->res_total)) {
> +		percpu_counter_add(&counter->count, delta);
>  		return;
>  	}
>  
>  	spin_lock(&mp->m_sb_lock);
> -	res_used = mp->m_resblks - mp->m_resblks_avail;
> +	res_used = counter->res_total - counter->res_avail;
>  	if (res_used > delta) {
> -		mp->m_resblks_avail += delta;
> +		counter->res_avail += delta;
>  	} else {
>  		delta -= res_used;
> -		mp->m_resblks_avail = mp->m_resblks;
> -		percpu_counter_add(&mp->m_free[ctr].count, delta);
> +		counter->res_avail = counter->res_total;
> +		percpu_counter_add(&counter->count, delta);
>  	}
>  	spin_unlock(&mp->m_sb_lock);
>  }
> @@ -1280,15 +1281,10 @@ xfs_dec_freecounter(
>  	uint64_t		delta,
>  	bool			rsvd)
>  {
> -	struct percpu_counter	*counter = &mp->m_free[ctr].count;
> -	uint64_t		set_aside = 0;
> +	struct xfs_freecounter	*counter = &mp->m_free[ctr];
>  	s32			batch;
> -	bool			has_resv_pool;
>  
>  	ASSERT(ctr < XC_FREE_NR);
> -	has_resv_pool = (ctr == XC_FREE_BLOCKS);
> -	if (rsvd)
> -		ASSERT(has_resv_pool);
>  
>  	/*
>  	 * Taking blocks away, need to be more accurate the closer we
> @@ -1298,7 +1294,7 @@ xfs_dec_freecounter(
>  	 * then make everything serialise as we are real close to
>  	 * ENOSPC.
>  	 */
> -	if (__percpu_counter_compare(counter, 2 * XFS_FDBLOCKS_BATCH,
> +	if (__percpu_counter_compare(&counter->count, 2 * XFS_FDBLOCKS_BATCH,
>  				     XFS_FDBLOCKS_BATCH) < 0)
>  		batch = 1;
>  	else
> @@ -1315,25 +1311,25 @@ xfs_dec_freecounter(
>  	 * problems (i.e. transaction abort, pagecache discards, etc.) than
>  	 * slightly premature -ENOSPC.
>  	 */
> -	if (has_resv_pool)
> -		set_aside = xfs_freecounter_unavailable(mp, ctr);
> -	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
> -	if (__percpu_counter_compare(counter, set_aside,
> +	percpu_counter_add_batch(&counter->count, -((int64_t)delta), batch);
> +	if (__percpu_counter_compare(&counter->count,
> +			xfs_freecounter_unavailable(mp, ctr),
>  			XFS_FDBLOCKS_BATCH) < 0) {
>  		/*
>  		 * Lock up the sb for dipping into reserves before releasing the
>  		 * space that took us to ENOSPC.
>  		 */
>  		spin_lock(&mp->m_sb_lock);
> -		percpu_counter_add(counter, delta);
> +		percpu_counter_add(&counter->count, delta);
>  		if (!rsvd)
>  			goto fdblocks_enospc;
> -		if (delta > mp->m_resblks_avail) {
> -			xfs_warn_once(mp,
> +		if (delta > counter->res_avail) {
> +			if (ctr == XC_FREE_BLOCKS)
> +				xfs_warn_once(mp,
>  "Reserve blocks depleted! Consider increasing reserve pool size.");
>  			goto fdblocks_enospc;
>  		}
> -		mp->m_resblks_avail -= delta;
> +		counter->res_avail -= delta;
>  		spin_unlock(&mp->m_sb_lock);
>  	}
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7f3265d669bc..f63410acc8fd 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -108,6 +108,15 @@ struct xfs_groups {
>  struct xfs_freecounter {
>  	/* free blocks for general use: */
>  	struct percpu_counter	count;
> +
> +	/* total reserved blocks: */
> +	uint64_t		res_total;
> +
> +	/* available reserved blocks: */
> +	uint64_t		res_avail;
> +
> +	/* reserved blks @ remount,ro: */
> +	uint64_t		res_saved;
>  };
>  
>  /*
> @@ -250,9 +259,6 @@ typedef struct xfs_mount {
>  	atomic64_t		m_allocbt_blks;
>  
>  	struct xfs_groups	m_groups[XG_TYPE_MAX];
> -	uint64_t		m_resblks;	/* total reserved blocks */
> -	uint64_t		m_resblks_avail;/* available reserved blocks */
> -	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct dentry		*m_debugfs;	/* debugfs parent */
>  	struct xfs_kobj		m_kobj;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b08d28a895cb..1e61283efdfe 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -924,24 +924,32 @@ xfs_fs_statfs(
>  }
>  
>  STATIC void
> -xfs_save_resvblks(struct xfs_mount *mp)
> +xfs_save_resvblks(
> +	struct xfs_mount	*mp)
>  {
> -	mp->m_resblks_save = mp->m_resblks;
> -	xfs_reserve_blocks(mp, 0);
> +	enum xfs_free_counter	i;
> +
> +	for (i = 0; i < XC_FREE_NR; i++) {
> +		mp->m_free[i].res_saved = mp->m_free[i].res_total;
> +		xfs_reserve_blocks(mp, i, 0);
> +	}
>  }
>  
>  STATIC void
> -xfs_restore_resvblks(struct xfs_mount *mp)
> +xfs_restore_resvblks(
> +	struct xfs_mount	*mp)
>  {
> -	uint64_t resblks;
> -
> -	if (mp->m_resblks_save) {
> -		resblks = mp->m_resblks_save;
> -		mp->m_resblks_save = 0;
> -	} else
> -		resblks = xfs_default_resblks(mp);
> +	uint64_t		resblks;
> +	enum xfs_free_counter	i;
>  
> -	xfs_reserve_blocks(mp, resblks);
> +	for (i = 0; i < XC_FREE_NR; i++) {
> +		if (mp->m_free[i].res_saved) {
> +			resblks = mp->m_free[i].res_saved;
> +			mp->m_free[i].res_saved = 0;
> +		} else
> +			resblks = xfs_default_resblks(mp);

Until "xfs: preserve RT reservations across remounts", this should be:

		if (mp->m_free[i].res_saved) {
			resblks = mp->m_free[i].res_saved;
			mp->m_free[i].res_saved = 0;
		} else if (i == XC_FREE_BLOCKS) {
			resblks = xfs_default_resblks(mp);
		} else {
			resblks = 0;
		}

Because otherwise we can end up "restoring" 8192 extents into
XC_FREE_RTEXTENTS even though we don't actually have reserved free
rtextents yet.  I /think/ this fixes the frextents accounting errors
that I saw while trying to bisect to figure out the fdblocks accounting
errors.

--D

> +		xfs_reserve_blocks(mp, i, resblks);
> +	}
>  }
>  
>  /*
> -- 
> 2.45.2
> 
> 
