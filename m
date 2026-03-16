Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33BE372EE1
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773700223; cv=none; b=tWxNvHDhk2Cbd4ehKwix677CdxySJlKmBoFEbTEnnNzbwDQOJ3hB3shiCcjbsi47ZN4gn/K/VG5BwvhdTjApSX6cx35A9shIAsvCZ3auYWVP26sxIW+pP4DQttRSTXeHi+JLp8vOoYw8Fe40cWC2g6l0FLFD4fk9c4tmpmsTkXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773700223; c=relaxed/simple;
	bh=evgHt/O0dUqwptpx4j6l/maKv8GnaWgD0LC4KLZ0ZNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcc77UBTeUagHYb//hMuSAd7Guob9esaY5SfFwVWgfrIdsNxVCtiUHuEXkO8yLjRFmpKI6zwTT2pWoENECfQ0atJG7zrQ24i8q+2LwrMv7FAAC2qNx0bEm/r0KS8G9G/76Bu8vyhkECkyHcLDjKipjd97Y7hcN/9OhV+/YiK0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOp5Lmgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOp5Lmgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E27C19421;
	Mon, 16 Mar 2026 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773700222;
	bh=evgHt/O0dUqwptpx4j6l/maKv8GnaWgD0LC4KLZ0ZNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DOp5LmgfysFFEMjM4HSOVufJU2js6RHDe7uraJrPXe9QLTAP9B3T3WCceILQiK2lf
	 fCf5VidaRAnVAy84NSWGo1BMJi0qFwFwWNjblhY/iyXgotVG6LuxW0qujH0RBlSlT4
	 u2aX+nAhF2vDWIrn/xOwSIHhqmb3oSP9q95RSCi8t8YtREuE/BDm1qjNTCQfjJcdpI
	 jLD4fLZBwADp/ErAPEsAxEYBcAs4yMiyLCAEwuk57BtBXfHyMHvAIprmsCEBXKHaH8
	 2qOlK1Qh730yk5qKS8Bx3daEMtM41dGz4d21fuDrDKagIUFONH/4fxVPgYquIOBnO9
	 q9DdYXKdMLDGA==
Date: Mon, 16 Mar 2026 15:30:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/3] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <20260316223021.GB1770774@frogsfrogsfrogs>
References: <20260316154216.1598410-1-hch@lst.de>
 <20260316154216.1598410-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316154216.1598410-3-hch@lst.de>

On Mon, Mar 16, 2026 at 04:41:34PM +0100, Christoph Hellwig wrote:
> The per-AG buffer hashes were added when all buffer lookups took a
> per-hash look.  Since then we've made lookups entirely lockless and
> removed the need for a hash-wide lock for inserts and removals as
> well.  With this there is no need to sharding the hash, so reduce the
> used resources by using a per-buftarg hash for all buftargs.
> 
> Long after writing this initially, syzbot found a problem in the buffer
> cache teardown order, which this happens to fix as well by doing the
> entire buffer cache teardown in one places instead of splitting it
> between destroying the buftarg and the perag structures.
> 
> Link: https://lore.kernel.org/linux-xfs/aLeUdemAZ5wmtZel@dread.disaster.area/
> Reported-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
> Tested-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks reasonable to me, though it deserves a cursory glance from
the author of the original triage message.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 13 ++---------
>  fs/xfs/libxfs/xfs_ag.h |  2 --
>  fs/xfs/xfs_buf.c       | 51 +++++++++++-------------------------------
>  fs/xfs/xfs_buf.h       | 10 +--------
>  fs/xfs/xfs_buf_mem.c   | 11 ++-------
>  5 files changed, 18 insertions(+), 69 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index bd8fbb40b49e..dcd2f93b6a6c 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -110,10 +110,7 @@ xfs_perag_uninit(
>  	struct xfs_group	*xg)
>  {
>  #ifdef __KERNEL__
> -	struct xfs_perag	*pag = to_perag(xg);
> -
> -	cancel_delayed_work_sync(&pag->pag_blockgc_work);
> -	xfs_buf_cache_destroy(&pag->pag_bcache);
> +	cancel_delayed_work_sync(&to_perag(xg)->pag_blockgc_work);
>  #endif
>  }
>  
> @@ -235,10 +232,6 @@ xfs_perag_alloc(
>  	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
>  #endif /* __KERNEL__ */
>  
> -	error = xfs_buf_cache_init(&pag->pag_bcache);
> -	if (error)
> -		goto out_free_perag;
> -
>  	/*
>  	 * Pre-calculated geometry
>  	 */
> @@ -250,12 +243,10 @@ xfs_perag_alloc(
>  
>  	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
>  	if (error)
> -		goto out_buf_cache_destroy;
> +		goto out_free_perag;
>  
>  	return 0;
>  
> -out_buf_cache_destroy:
> -	xfs_buf_cache_destroy(&pag->pag_bcache);
>  out_free_perag:
>  	kfree(pag);
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 3cd4790768ff..16a9b43a3c27 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -85,8 +85,6 @@ struct xfs_perag {
>  	int		pag_ici_reclaimable;	/* reclaimable inodes */
>  	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
>  
> -	struct xfs_buf_cache	pag_bcache;
> -
>  	/* background prealloc block trimming */
>  	struct delayed_work	pag_blockgc_work;
>  #endif /* __KERNEL__ */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d585848a6be1..c0a4d0a37f57 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -363,20 +363,6 @@ static const struct rhashtable_params xfs_buf_hash_params = {
>  	.obj_cmpfn		= _xfs_buf_obj_cmp,
>  };
>  
> -int
> -xfs_buf_cache_init(
> -	struct xfs_buf_cache	*bch)
> -{
> -	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
> -}
> -
> -void
> -xfs_buf_cache_destroy(
> -	struct xfs_buf_cache	*bch)
> -{
> -	rhashtable_destroy(&bch->bc_hash);
> -}
> -
>  static int
>  xfs_buf_map_verify(
>  	struct xfs_buftarg	*btp,
> @@ -434,7 +420,7 @@ xfs_buf_find_lock(
>  
>  static inline int
>  xfs_buf_lookup(
> -	struct xfs_buf_cache	*bch,
> +	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp)
> @@ -443,7 +429,7 @@ xfs_buf_lookup(
>  	int			error;
>  
>  	rcu_read_lock();
> -	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
> +	bp = rhashtable_lookup(&btp->bt_hash, map, xfs_buf_hash_params);
>  	if (!bp || !lockref_get_not_dead(&bp->b_lockref)) {
>  		rcu_read_unlock();
>  		return -ENOENT;
> @@ -468,7 +454,6 @@ xfs_buf_lookup(
>  static int
>  xfs_buf_find_insert(
>  	struct xfs_buftarg	*btp,
> -	struct xfs_buf_cache	*bch,
>  	struct xfs_perag	*pag,
>  	struct xfs_buf_map	*cmap,
>  	struct xfs_buf_map	*map,
> @@ -488,7 +473,7 @@ xfs_buf_find_insert(
>  	new_bp->b_pag = pag;
>  
>  	rcu_read_lock();
> -	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
> +	bp = rhashtable_lookup_get_insert_fast(&btp->bt_hash,
>  			&new_bp->b_rhash_head, xfs_buf_hash_params);
>  	if (IS_ERR(bp)) {
>  		rcu_read_unlock();
> @@ -530,16 +515,6 @@ xfs_buftarg_get_pag(
>  	return xfs_perag_get(mp, xfs_daddr_to_agno(mp, map->bm_bn));
>  }
>  
> -static inline struct xfs_buf_cache *
> -xfs_buftarg_buf_cache(
> -	struct xfs_buftarg		*btp,
> -	struct xfs_perag		*pag)
> -{
> -	if (pag)
> -		return &pag->pag_bcache;
> -	return btp->bt_cache;
> -}
> -
>  /*
>   * Assembles a buffer covering the specified range. The code is optimised for
>   * cache hits, as metadata intensive workloads will see 3 orders of magnitude
> @@ -553,7 +528,6 @@ xfs_buf_get_map(
>  	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp)
>  {
> -	struct xfs_buf_cache	*bch;
>  	struct xfs_perag	*pag;
>  	struct xfs_buf		*bp = NULL;
>  	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
> @@ -570,9 +544,8 @@ xfs_buf_get_map(
>  		return error;
>  
>  	pag = xfs_buftarg_get_pag(btp, &cmap);
> -	bch = xfs_buftarg_buf_cache(btp, pag);
>  
> -	error = xfs_buf_lookup(bch, &cmap, flags, &bp);
> +	error = xfs_buf_lookup(btp, &cmap, flags, &bp);
>  	if (error && error != -ENOENT)
>  		goto out_put_perag;
>  
> @@ -584,7 +557,7 @@ xfs_buf_get_map(
>  			goto out_put_perag;
>  
>  		/* xfs_buf_find_insert() consumes the perag reference. */
> -		error = xfs_buf_find_insert(btp, bch, pag, &cmap, map, nmaps,
> +		error = xfs_buf_find_insert(btp, pag, &cmap, map, nmaps,
>  				flags, &bp);
>  		if (error)
>  			return error;
> @@ -848,11 +821,8 @@ xfs_buf_destroy(
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
>  	if (!xfs_buf_is_uncached(bp)) {
> -		struct xfs_buf_cache	*bch =
> -			xfs_buftarg_buf_cache(bp->b_target, bp->b_pag);
> -
> -		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
> -				xfs_buf_hash_params);
> +		rhashtable_remove_fast(&bp->b_target->bt_hash,
> +				&bp->b_rhash_head, xfs_buf_hash_params);
>  
>  		if (bp->b_pag)
>  			xfs_perag_put(bp->b_pag);
> @@ -1618,6 +1588,7 @@ xfs_destroy_buftarg(
>  	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
>  	percpu_counter_destroy(&btp->bt_readahead_count);
>  	list_lru_destroy(&btp->bt_lru);
> +	rhashtable_destroy(&btp->bt_hash);
>  }
>  
>  void
> @@ -1712,8 +1683,10 @@ xfs_init_buftarg(
>  	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
>  			     DEFAULT_RATELIMIT_BURST);
>  
> -	if (list_lru_init(&btp->bt_lru))
> +	if (rhashtable_init(&btp->bt_hash, &xfs_buf_hash_params))
>  		return -ENOMEM;
> +	if (list_lru_init(&btp->bt_lru))
> +		goto out_destroy_hash;
>  	if (percpu_counter_init(&btp->bt_readahead_count, 0, GFP_KERNEL))
>  		goto out_destroy_lru;
>  
> @@ -1731,6 +1704,8 @@ xfs_init_buftarg(
>  	percpu_counter_destroy(&btp->bt_readahead_count);
>  out_destroy_lru:
>  	list_lru_destroy(&btp->bt_lru);
> +out_destroy_hash:
> +	rhashtable_destroy(&btp->bt_hash);
>  	return -ENOMEM;
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3a1d066e1c13..bf39d89f0f6d 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -69,13 +69,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_INCORE,		"INCORE" }, \
>  	{ XBF_TRYLOCK,		"TRYLOCK" }
>  
> -struct xfs_buf_cache {
> -	struct rhashtable	bc_hash;
> -};
> -
> -int xfs_buf_cache_init(struct xfs_buf_cache *bch);
> -void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
> -
>  /*
>   * The xfs_buftarg contains 2 notions of "sector size" -
>   *
> @@ -113,8 +106,7 @@ struct xfs_buftarg {
>  	unsigned int		bt_awu_min;
>  	unsigned int		bt_awu_max;
>  
> -	/* built-in cache, if we're not using the perag one */
> -	struct xfs_buf_cache	bt_cache[];
> +	struct rhashtable	bt_hash;
>  };
>  
>  struct xfs_buf_map {
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index b0b3696bf599..b2fd7276b131 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -58,7 +58,7 @@ xmbuf_alloc(
>  	struct xfs_buftarg	*btp;
>  	int			error;
>  
> -	btp = kzalloc_flex(*btp, bt_cache, 1);
> +	btp = kzalloc_obj(*btp);
>  	if (!btp)
>  		return -ENOMEM;
>  
> @@ -81,10 +81,6 @@ xmbuf_alloc(
>  	/* ensure all writes are below EOF to avoid pagecache zeroing */
>  	i_size_write(inode, inode->i_sb->s_maxbytes);
>  
> -	error = xfs_buf_cache_init(btp->bt_cache);
> -	if (error)
> -		goto out_file;
> -
>  	/* Initialize buffer target */
>  	btp->bt_mount = mp;
>  	btp->bt_dev = (dev_t)-1U;
> @@ -95,15 +91,13 @@ xmbuf_alloc(
>  
>  	error = xfs_init_buftarg(btp, XMBUF_BLOCKSIZE, descr);
>  	if (error)
> -		goto out_bcache;
> +		goto out_file;
>  
>  	trace_xmbuf_create(btp);
>  
>  	*btpp = btp;
>  	return 0;
>  
> -out_bcache:
> -	xfs_buf_cache_destroy(btp->bt_cache);
>  out_file:
>  	fput(file);
>  out_free_btp:
> @@ -122,7 +116,6 @@ xmbuf_free(
>  	trace_xmbuf_free(btp);
>  
>  	xfs_destroy_buftarg(btp);
> -	xfs_buf_cache_destroy(btp->bt_cache);
>  	fput(btp->bt_file);
>  	kfree(btp);
>  }
> -- 
> 2.47.3
> 
> 
