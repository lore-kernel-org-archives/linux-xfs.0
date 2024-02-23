Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560012AAE0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708195; cv=none; b=H79w4c6SpIupyNtAymmxuugAULKV9fwx2CtGy7PeHD+NiwP8poySFSVgWLmzHlXHzCEPRGDR/71561vT/imLemO7t17eKlh66cqeXRvWPbVMFKc8Iy72LkksRyA3NMuYpZYs694rzAxPfhmMNKxTMooaYpSseSC42T0qVkHIt0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708195; c=relaxed/simple;
	bh=hHewdCGbS32gOvjgkdUh/VgNJPIzbLGN3aEJ0U2YbiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQCDrvaQmTWxOlIIe7xeMecYCnmzDRHeCymESM7SBhF4wxbOuqVUsLbtmdtBhWLumtII6JKKgIhGHRNgMdOX91xLdKXUxm92cX6dUai50IMDhoeFTczaNyWquTlg9HYoUbrw/Q1sFUmT5LskabyMciiIXk0ksTENbk0mtAz5tc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jjdl5rtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jjdl5rtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C8FC433C7;
	Fri, 23 Feb 2024 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708708194;
	bh=hHewdCGbS32gOvjgkdUh/VgNJPIzbLGN3aEJ0U2YbiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jjdl5rtNPFJvS8b8hU/uPdPIGkno1fwjZ7eCz7tbscV8lsuc09s84AxiSlFenyBd5
	 BESSCPMeuqisBp2dV3FV8rC9GnPMqqvIusQ1TyuGNPcscbfYcWYt+QzmUfdj3tLpLY
	 51lxvmdZ6OaDpA249ZTpf1X/kWpAg8OVhQljfJC+vaCiGRkrirhyHTXRoby4bvG+uI
	 XqcrWDStIT47d+dD6qWDk9oI1rQY348l3AoqO3IZ5r+tMHz9qHNz9Do4Cqrts/6N0Q
	 Ou/zA8g/xiq36qWVo20oM1jhA5hpiy6sAe/7IdCuHBlrpMSDrcdhjSphg7ab4ihuK3
	 BvmldpsGFC7Sg==
Date: Fri, 23 Feb 2024 09:09:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: split xfs_mod_freecounter
Message-ID: <20240223170953.GQ616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-5-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:00AM +0100, Christoph Hellwig wrote:
> xfs_mod_freecounter has two entirely separate code paths for adding or
> subtracting from the free counters.  Only the subtract case looks at the
> rsvd flag and can return an error.
> 
> Split xfs_mod_freecounter into separate helpers for subtracting or
> adding the freecounter, and remove all the impossible to reach error
> handling for the addition case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag.c      |   4 +-
>  fs/xfs/libxfs/xfs_ag_resv.c |  24 +++------
>  fs/xfs/libxfs/xfs_ag_resv.h |   2 +-
>  fs/xfs/libxfs/xfs_alloc.c   |   4 +-
>  fs/xfs/libxfs/xfs_bmap.c    |  23 ++++----
>  fs/xfs/scrub/fscounters.c   |   2 +-
>  fs/xfs/scrub/repair.c       |   5 +-
>  fs/xfs/xfs_fsops.c          |  29 +++--------
>  fs/xfs/xfs_fsops.h          |   2 +-
>  fs/xfs/xfs_mount.c          | 101 ++++++++++++++++--------------------
>  fs/xfs/xfs_mount.h          |  32 +++++++++---
>  fs/xfs/xfs_super.c          |   6 +--
>  fs/xfs/xfs_trace.h          |   1 -
>  fs/xfs/xfs_trans.c          |  25 ++++-----
>  14 files changed, 115 insertions(+), 145 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 036f4ee43fd3c7..f89fa03b2db7f9 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -967,9 +967,7 @@ xfs_ag_shrink_space(
>  	 * Disable perag reservations so it doesn't cause the allocation request
>  	 * to fail. We'll reestablish reservation before we return.
>  	 */
> -	error = xfs_ag_resv_free(pag);
> -	if (error)
> -		return error;
> +	xfs_ag_resv_free(pag);
>  
>  	/* internal log shouldn't also show up in the free space btrees */
>  	error = xfs_alloc_vextent_exact_bno(&args,
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index da1057bd0e6067..216423df939e5c 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -126,14 +126,13 @@ xfs_ag_resv_needed(
>  }
>  
>  /* Clean out a reservation */
> -static int
> +static void
>  __xfs_ag_resv_free(
>  	struct xfs_perag		*pag,
>  	enum xfs_ag_resv_type		type)
>  {
>  	struct xfs_ag_resv		*resv;
>  	xfs_extlen_t			oldresv;
> -	int				error;
>  
>  	trace_xfs_ag_resv_free(pag, type, 0);
>  
> @@ -149,30 +148,19 @@ __xfs_ag_resv_free(
>  		oldresv = resv->ar_orig_reserved;
>  	else
>  		oldresv = resv->ar_reserved;
> -	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
> +	xfs_add_fdblocks(pag->pag_mount, oldresv);
>  	resv->ar_reserved = 0;
>  	resv->ar_asked = 0;
>  	resv->ar_orig_reserved = 0;
> -
> -	if (error)
> -		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
> -				error, _RET_IP_);
> -	return error;
>  }
>  
>  /* Free a per-AG reservation. */
> -int
> +void
>  xfs_ag_resv_free(
>  	struct xfs_perag		*pag)
>  {
> -	int				error;
> -	int				err2;
> -
> -	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
> -	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
> -	if (err2 && !error)
> -		error = err2;
> -	return error;
> +	__xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
> +	__xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
>  }
>  
>  static int
> @@ -216,7 +204,7 @@ __xfs_ag_resv_init(
>  	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
>  		error = -ENOSPC;
>  	else
> -		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
> +		error = xfs_dec_fdblocks(mp, hidden_space, true);
>  	if (error) {
>  		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
>  				error, _RET_IP_);
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index b74b210008ea7e..ff20ed93de7724 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -6,7 +6,7 @@
>  #ifndef __XFS_AG_RESV_H__
>  #define	__XFS_AG_RESV_H__
>  
> -int xfs_ag_resv_free(struct xfs_perag *pag);
> +void xfs_ag_resv_free(struct xfs_perag *pag);
>  int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
>  
>  bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3bd0a33fee0a64..ba131fecbd236d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -78,7 +78,7 @@ xfs_prealloc_blocks(
>  }
>  
>  /*
> - * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
> + * The number of blocks per AG that we withhold from xfs_dec_fdblocks to
>   * guarantee that we can refill the AGFL prior to allocating space in a nearly
>   * full AG.  Although the space described by the free space btrees, the
>   * blocks used by the freesp btrees themselves, and the blocks owned by the
> @@ -88,7 +88,7 @@ xfs_prealloc_blocks(
>   * until the fs goes down, we subtract this many AG blocks from the incore
>   * fdblocks to ensure user allocation does not overcommit the space the
>   * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
> - * withhold space from xfs_mod_fdblocks, so we do not account for that here.
> + * withhold space from xfs_dec_fdblocks, so we do not account for that here.
>   */
>  #define XFS_ALLOCBT_AGFL_RESERVE	4
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f8cc7c510d7bd5..cc788cde8bffd6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1934,10 +1934,11 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	/* adjust for changes in reserved delayed indirect blocks */
> -	if (da_new != da_old) {
> -		ASSERT(state == 0 || da_new < da_old);
> -		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
> -				false);
> +	if (da_new < da_old) {
> +		xfs_add_fdblocks(mp, da_old - da_new);
> +	} else if (da_new > da_old) {
> +		ASSERT(state == 0);
> +		error = xfs_dec_fdblocks(mp, da_new - da_old, false);
>  	}
>  
>  	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
> @@ -2616,8 +2617,8 @@ xfs_bmap_add_extent_hole_delay(
>  	}
>  	if (oldlen != newlen) {
>  		ASSERT(oldlen > newlen);
> -		xfs_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen),
> -				 false);
> +		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
> +
>  		/*
>  		 * Nothing to do for disk quota accounting here.
>  		 */
> @@ -4025,11 +4026,11 @@ xfs_bmapi_reserve_delalloc(
>  	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
>  	ASSERT(indlen > 0);
>  
> -	error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
> +	error = xfs_dec_fdblocks(mp, alen, false);
>  	if (error)
>  		goto out_unreserve_quota;
>  
> -	error = xfs_mod_fdblocks(mp, -((int64_t)indlen), false);
> +	error = xfs_dec_fdblocks(mp, indlen, false);
>  	if (error)
>  		goto out_unreserve_blocks;
>  
> @@ -4057,7 +4058,7 @@ xfs_bmapi_reserve_delalloc(
>  	return 0;
>  
>  out_unreserve_blocks:
> -	xfs_mod_fdblocks(mp, alen, false);
> +	xfs_add_fdblocks(mp, alen);
>  out_unreserve_quota:
>  	if (XFS_IS_QUOTA_ON(mp))
>  		xfs_quota_unreserve_blkres(ip, alen);
> @@ -4842,7 +4843,7 @@ xfs_bmap_del_extent_delay(
>  	ASSERT(got_endoff >= del_endoff);
>  
>  	if (isrt)
> -		xfs_mod_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
> +		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
>  
>  	/*
>  	 * Update the inode delalloc counter now and wait to update the
> @@ -4929,7 +4930,7 @@ xfs_bmap_del_extent_delay(
>  	if (!isrt)
>  		da_diff += del->br_blockcount;
>  	if (da_diff) {
> -		xfs_mod_fdblocks(mp, da_diff, false);
> +		xfs_add_fdblocks(mp, da_diff);
>  		xfs_mod_delalloc(mp, -da_diff);
>  	}
>  	return error;
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 5799e9a94f1f66..5c6d7244078942 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -516,7 +516,7 @@ xchk_fscounters(
>  
>  	/*
>  	 * If the filesystem is not frozen, the counter summation calls above
> -	 * can race with xfs_mod_freecounter, which subtracts a requested space
> +	 * can race with xfs_dec_freecounter, which subtracts a requested space
>  	 * reservation from the counter and undoes the subtraction if that made
>  	 * the counter go negative.  Therefore, it's possible to see negative
>  	 * values here, and we should only flag that as a corruption if we
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 745d5b8f405a91..0412bf7c78e727 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -929,9 +929,7 @@ xrep_reset_perag_resv(
>  	ASSERT(sc->tp);
>  
>  	sc->flags &= ~XREP_RESET_PERAG_RESV;
> -	error = xfs_ag_resv_free(sc->sa.pag);
> -	if (error)
> -		goto out;
> +	xfs_ag_resv_free(sc->sa.pag);
>  	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
>  	if (error == -ENOSPC) {
>  		xfs_err(sc->mp,
> @@ -940,7 +938,6 @@ xrep_reset_perag_resv(
>  		error = 0;
>  	}
>  
> -out:
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 83f708f62ed9f2..c211ea2b63c4dd 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -213,10 +213,8 @@ xfs_growfs_data_private(
>  			struct xfs_perag	*pag;
>  
>  			pag = xfs_perag_get(mp, id.agno);
> -			error = xfs_ag_resv_free(pag);
> +			xfs_ag_resv_free(pag);
>  			xfs_perag_put(pag);
> -			if (error)
> -				return error;
>  		}
>  		/*
>  		 * Reserve AG metadata blocks. ENOSPC here does not mean there
> @@ -385,14 +383,14 @@ xfs_reserve_blocks(
>  	 */
>  	if (mp->m_resblks > request) {
>  		lcounter = mp->m_resblks_avail - request;
> -		if (lcounter  > 0) {		/* release unused blocks */
> +		if (lcounter > 0) {		/* release unused blocks */
>  			fdblks_delta = lcounter;
>  			mp->m_resblks_avail -= lcounter;
>  		}
>  		mp->m_resblks = request;
>  		if (fdblks_delta) {
>  			spin_unlock(&mp->m_sb_lock);
> -			error = xfs_mod_fdblocks(mp, fdblks_delta, 0);
> +			xfs_add_fdblocks(mp, fdblks_delta);
>  			spin_lock(&mp->m_sb_lock);
>  		}
>  
> @@ -428,9 +426,9 @@ xfs_reserve_blocks(
>  		 */
>  		fdblks_delta = min(free, delta);
>  		spin_unlock(&mp->m_sb_lock);
> -		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> +		error = xfs_dec_fdblocks(mp, fdblks_delta, 0);
>  		if (!error)
> -			xfs_mod_fdblocks(mp, fdblks_delta, 0);
> +			xfs_add_fdblocks(mp, fdblks_delta);
>  		spin_lock(&mp->m_sb_lock);
>  	}
>  out:
> @@ -556,24 +554,13 @@ xfs_fs_reserve_ag_blocks(
>  /*
>   * Free space reserved for per-AG metadata.
>   */
> -int
> +void
>  xfs_fs_unreserve_ag_blocks(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_agnumber_t		agno;
>  	struct xfs_perag	*pag;
> -	int			error = 0;
> -	int			err2;
>  
> -	for_each_perag(mp, agno, pag) {
> -		err2 = xfs_ag_resv_free(pag);
> -		if (err2 && !error)
> -			error = err2;
> -	}
> -
> -	if (error)
> -		xfs_warn(mp,
> -	"Error %d freeing per-AG metadata reserve pool.", error);
> -
> -	return error;
> +	for_each_perag(mp, agno, pag)
> +		xfs_ag_resv_free(pag);
>  }
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 44457b0a059376..3e2f73bcf8314b 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -12,6 +12,6 @@ int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
>  int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
>  
>  int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> -int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
> +void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_FSOPS_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7328034d42ed8d..2e06837051d6b0 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1129,50 +1129,40 @@ xfs_fs_writable(
>  	return true;
>  }
>  
> -/* Adjust m_fdblocks or m_frextents. */
> +void
> +__xfs_add_fdblocks(
> +	struct xfs_mount	*mp,
> +	uint64_t		delta)
> +{
> +	long long		res_used;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
> +	if (res_used > delta) {
> +		mp->m_resblks_avail += delta;
> +	} else {
> +		delta -= res_used;
> +		mp->m_resblks_avail = mp->m_resblks;
> +		percpu_counter_add(&mp->m_fdblocks, delta);
> +	}
> +	spin_unlock(&mp->m_sb_lock);
> +}
> +
>  int
> -xfs_mod_freecounter(
> +xfs_dec_freecounter(
>  	struct xfs_mount	*mp,
>  	struct percpu_counter	*counter,
> -	int64_t			delta,
> +	uint64_t		delta,
>  	bool			rsvd)
>  {
> -	int64_t			lcounter;
> -	long long		res_used;
> +	bool			has_resv_pool = (counter == &mp->m_fdblocks);
>  	uint64_t		set_aside = 0;
>  	s32			batch;
> -	bool			has_resv_pool;
>  
>  	ASSERT(counter == &mp->m_fdblocks || counter == &mp->m_frextents);
> -	has_resv_pool = (counter == &mp->m_fdblocks);
>  	if (rsvd)
>  		ASSERT(has_resv_pool);
>  
> -	if (delta > 0) {
> -		/*
> -		 * If the reserve pool is depleted, put blocks back into it
> -		 * first. Most of the time the pool is full.
> -		 */
> -		if (likely(!has_resv_pool ||
> -			   mp->m_resblks == mp->m_resblks_avail)) {
> -			percpu_counter_add(counter, delta);
> -			return 0;
> -		}
> -
> -		spin_lock(&mp->m_sb_lock);
> -		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
> -
> -		if (res_used > delta) {
> -			mp->m_resblks_avail += delta;
> -		} else {
> -			delta -= res_used;
> -			mp->m_resblks_avail = mp->m_resblks;
> -			percpu_counter_add(counter, delta);
> -		}
> -		spin_unlock(&mp->m_sb_lock);
> -		return 0;
> -	}
> -
>  	/*
>  	 * Taking blocks away, need to be more accurate the closer we
>  	 * are to zero.
> @@ -1200,34 +1190,35 @@ xfs_mod_freecounter(
>  	 */
>  	if (has_resv_pool)
>  		set_aside = xfs_fdblocks_unavailable(mp);
> -	percpu_counter_add_batch(counter, delta, batch);
> -	if (__percpu_counter_compare(counter, set_aside,
> -				     XFS_FDBLOCKS_BATCH) >= 0) {
> -		/* we had space! */
> -		return 0;
> -	}
>  
> -	/*
> -	 * lock up the sb for dipping into reserves before releasing the space
> -	 * that took us to ENOSPC.
> -	 */
> -	spin_lock(&mp->m_sb_lock);
> -	percpu_counter_add(counter, -delta);
> -	if (!has_resv_pool || !rsvd)
> -		goto fdblocks_enospc;
> +	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
> +	if (__percpu_counter_compare(counter, set_aside,
> +				     XFS_FDBLOCKS_BATCH) < 0) {
> +		/*
> +		 * Take the SB lock to prevent other thread from racing from us
> +		 * before putting back the reserved blocks, and then try to dip
> +		 * into the reserved pool if we are allowed to.
> +		 */
> +		spin_lock(&mp->m_sb_lock);
> +		percpu_counter_add(counter, delta);
> +		if (has_resv_pool && rsvd) {
> +			int64_t	lcounter;
> +
> +			lcounter = (long long)mp->m_resblks_avail - delta;
> +			if (lcounter >= 0) {
> +				mp->m_resblks_avail = lcounter;
> +				spin_unlock(&mp->m_sb_lock);
> +				return 0;
> +			}
> +		}
>  
> -	lcounter = (long long)mp->m_resblks_avail + delta;
> -	if (lcounter >= 0) {
> -		mp->m_resblks_avail = lcounter;
> +		xfs_warn_once(mp,
> +"Reserve blocks depleted! Consider increasing reserve pool size.");

Hmm.  This message gets logged if the __percpu_counter_compare above
returns a negative value and we don't have a reserve pool.  I think
that's a change from the current code, where running out of m_frextents
returns ENOSPC without generating (misleading) log messages about the
reserve pool.

That was a /really/ convoluted way of me saying that decrementing
m_frextents could be a much more cohesive function:

	if (__percpu_counter_compare(&mp->m_frextents, 2 * XFS_FDBLOCKS_BATCH,
				     XFS_FDBLOCKS_BATCH) < 0)
		batch = 1;
	else
		batch = XFS_FDBLOCKS_BATCH;
	percpu_counter_add_batch(&mp->m_frextents, delta, batch);
	if (__percpu_counter_compare(&mp->m_frextents, 0,
				     XFS_FDBLOCKS_BATCH) < 0) {
		spin_lock(&mp->m_sb_lock);
		percpu_counter_add(&mp->m_frextents, -delta);
		spin_unlock(&mp->m_sb_lock);
		return -ENOSPC;
	}

	return 0;

without all the reserve pool machinery that fdblocks has.  The original
code to implement m_frextents did exactly that, but Dave really wanted
me to optimize this for icache footprint[1] so we ended up with (IMO)
harder to understand xfs_mod_freecounter.

--D

[1] https://lore.kernel.org/linux-xfs/20220407231725.GM1544202@dread.disaster.area/

>  		spin_unlock(&mp->m_sb_lock);
> -		return 0;
> +		return -ENOSPC;
>  	}
> -	xfs_warn_once(mp,
> -"Reserve blocks depleted! Consider increasing reserve pool size.");
>  
> -fdblocks_enospc:
> -	spin_unlock(&mp->m_sb_lock);
> -	return -ENOSPC;
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 503fe3c7edbf82..891a54d57f576d 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -534,19 +534,39 @@ xfs_fdblocks_unavailable(
>  	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
>  }
>  
> -int xfs_mod_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> -		int64_t delta, bool rsvd);
> +int xfs_dec_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +		uint64_t delta, bool rsvd);
>  
>  static inline int
> -xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta, bool reserved)
> +xfs_dec_fdblocks(struct xfs_mount *mp, uint64_t delta, bool reserved)
>  {
> -	return xfs_mod_freecounter(mp, &mp->m_fdblocks, delta, reserved);
> +	return xfs_dec_freecounter(mp, &mp->m_fdblocks, delta, reserved);
> +}
> +
> +
> +void __xfs_add_fdblocks(struct xfs_mount *mp, uint64_t delta);
> +static inline void xfs_add_fdblocks(struct xfs_mount *mp, uint64_t delta)
> +{
> +	/*
> +	 * If the reserve pool is depleted, put blocks back into it first.
> +	 * Most of the time the pool is full.
> +	 */
> +	if (unlikely(mp->m_resblks != mp->m_resblks_avail))
> +		__xfs_add_fdblocks(mp, delta);
> +	else
> +		percpu_counter_add(&mp->m_fdblocks, delta);
>  }
>  
>  static inline int
> -xfs_mod_frextents(struct xfs_mount *mp, int64_t delta)
> +xfs_dec_frextents(struct xfs_mount *mp, uint64_t delta)
> +{
> +	return xfs_dec_freecounter(mp, &mp->m_frextents, delta, false);
> +}
> +
> +static inline void
> +xfs_add_frextents(struct xfs_mount *mp, uint64_t delta)
>  {
> -	return xfs_mod_freecounter(mp, &mp->m_frextents, delta, false);
> +	percpu_counter_add(&mp->m_frextents, delta);
>  }
>  
>  extern int	xfs_readsb(xfs_mount_t *, int);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6ce1e6deb7ec5f..b16828410ec19b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1875,11 +1875,7 @@ xfs_remount_ro(
>  	xfs_inodegc_stop(mp);
>  
>  	/* Free the per-AG metadata reservation pool. */
> -	error = xfs_fs_unreserve_ag_blocks(mp);
> -	if (error) {
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return error;
> -	}
> +	xfs_fs_unreserve_ag_blocks(mp);
>  
>  	/*
>  	 * Before we sync the metadata, we need to free up the reserve block
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c7e57efe035666..d7abb3539d2d92 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2932,7 +2932,6 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
>  DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
>  DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
>  
> -DEFINE_AG_ERROR_EVENT(xfs_ag_resv_free_error);
>  DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
>  
>  /* refcount tracepoint classes */
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index befb508638ca1f..9913dfa5b8340d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -163,7 +163,7 @@ xfs_trans_reserve(
>  	 * fail if the count would go below zero.
>  	 */
>  	if (blocks > 0) {
> -		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
> +		error = xfs_dec_fdblocks(mp, blocks, rsvd);
>  		if (error != 0)
>  			return -ENOSPC;
>  		tp->t_blk_res += blocks;
> @@ -210,7 +210,7 @@ xfs_trans_reserve(
>  	 * fail if the count would go below zero.
>  	 */
>  	if (rtextents > 0) {
> -		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
> +		error = xfs_dec_frextents(mp, rtextents);
>  		if (error) {
>  			error = -ENOSPC;
>  			goto undo_log;
> @@ -234,7 +234,7 @@ xfs_trans_reserve(
>  
>  undo_blocks:
>  	if (blocks > 0) {
> -		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
> +		xfs_add_fdblocks(mp, blocks);
>  		tp->t_blk_res = 0;
>  	}
>  	return error;
> @@ -593,12 +593,10 @@ xfs_trans_unreserve_and_mod_sb(
>  	struct xfs_trans	*tp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
>  	int64_t			blkdelta = tp->t_blk_res;
>  	int64_t			rtxdelta = tp->t_rtx_res;
>  	int64_t			idelta = 0;
>  	int64_t			ifreedelta = 0;
> -	int			error;
>  
>  	/*
>  	 * Calculate the deltas.
> @@ -631,10 +629,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	/* apply the per-cpu counters */
> -	if (blkdelta) {
> -		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
> -		ASSERT(!error);
> -	}
> +	if (blkdelta)
> +		xfs_add_fdblocks(mp, blkdelta);
>  
>  	if (idelta)
>  		percpu_counter_add_batch(&mp->m_icount, idelta,
> @@ -643,10 +639,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	if (ifreedelta)
>  		percpu_counter_add(&mp->m_ifree, ifreedelta);
>  
> -	if (rtxdelta) {
> -		error = xfs_mod_frextents(mp, rtxdelta);
> -		ASSERT(!error);
> -	}
> +	if (rtxdelta)
> +		xfs_add_frextents(mp, rtxdelta);
>  
>  	if (!(tp->t_flags & XFS_TRANS_SB_DIRTY))
>  		return;
> @@ -682,7 +676,6 @@ xfs_trans_unreserve_and_mod_sb(
>  	 */
>  	ASSERT(mp->m_sb.sb_imax_pct >= 0);
>  	ASSERT(mp->m_sb.sb_rextslog >= 0);
> -	return;
>  }
>  
>  /* Add the given log item to the transaction's list of log items. */
> @@ -1301,9 +1294,9 @@ xfs_trans_reserve_more_inode(
>  		return 0;
>  
>  	/* Quota failed, give back the new reservation. */
> -	xfs_mod_fdblocks(mp, dblocks, tp->t_flags & XFS_TRANS_RESERVE);
> +	xfs_add_fdblocks(mp, dblocks);
>  	tp->t_blk_res -= dblocks;
> -	xfs_mod_frextents(mp, rtx);
> +	xfs_add_frextents(mp, rtx);
>  	tp->t_rtx_res -= rtx;
>  	return error;
>  }
> -- 
> 2.39.2
> 
> 
