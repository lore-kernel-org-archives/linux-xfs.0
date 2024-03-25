Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0AE839EC
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711410245; cv=none; b=KcNRf1oJY4/Cd12/5Edri5/NylyIaoB0SIg/YvwTMgObYywvA2RLZEd6vq5X/k9uoL9A9tAmEthW7QhcB5RaLOblPlblJUeGFHOxM9h9i61WS79k2teULwH0ro0v5sCImvX2imZxND9eDK3Hz6DXt5om25Tv1o6gsf3zS2GFMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711410245; c=relaxed/simple;
	bh=NUaUW5y13rhw1Z89ugIm3ZVnYh1BMVC+IDhxqWilceM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUu0oOz2Ckuh9lRj3uo5dBYFvG/ZGT55xVgSZi9oeH6f5RZM3/1cuPouo3/D/CTsOkvHTJef8dWwTanI0BHMpJLoCuF10elLkPlFHUfv6QjekbvW4V2DZyh1E0iwDotO38zO7XkvlhJcKpGsxdKdrj3q3pawxCrBkubX/tDKa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3lwpdRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3lwpdRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCD5C433F1;
	Mon, 25 Mar 2024 23:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711410245;
	bh=NUaUW5y13rhw1Z89ugIm3ZVnYh1BMVC+IDhxqWilceM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J3lwpdRVfr3phLE5tRa/szFJDXcifqDa41cUSPxjOEf5Hybga4TiE95eUlJSLX/B0
	 G4ayCH80Z+kO1+s0cHRnGLyOKhJvKXG3HAhr5cctxtzkZVrDcztphNWFr/wl3GvQoR
	 3GssjLkg0fYMbHWNv4bpalmKrmX+Ui+IavZ631GBAd/PLAc8l7CYDJWaOVrKokK30R
	 DeQ7+dIMpp4conVWqpiynDBamWb0hduCROMxCtWNVA6/kMlckdFaWmkjDqiDpqj9hH
	 OpzN8GMe3/7OTiv4NUMDE7sdyjAF1mXGkd4SUYJT3VN+btvJWijoF0/vuE1PIy44ED
	 1wZ7dr20bVKqw==
Date: Mon, 25 Mar 2024 16:44:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240325234404.GE6414@frogsfrogsfrogs>
References: <20240325022411.2045794-1-hch@lst.de>
 <20240325022411.2045794-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325022411.2045794-8-hch@lst.de>

On Mon, Mar 25, 2024 at 10:24:07AM +0800, Christoph Hellwig wrote:
> To prepare for re-enabling delalloc on RT devices, track the data blocks
> (which use the RT device when the inode sits on it) and the indirect
> blocks (which don't) separately to xfs_mod_delalloc, and add a new
> percpu counter to also track the RT delalloc blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c         | 12 ++++++------
>  fs/xfs/scrub/fscounters.c        |  6 +++++-
>  fs/xfs/scrub/fscounters.h        |  1 +
>  fs/xfs/scrub/fscounters_repair.c |  3 ++-
>  fs/xfs/xfs_mount.c               | 18 +++++++++++++++---
>  fs/xfs/xfs_mount.h               |  9 ++++++++-
>  fs/xfs/xfs_super.c               | 11 ++++++++++-
>  7 files changed, 47 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 94b4aad1989bec..cc250c33890bac 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1975,7 +1975,7 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	if (da_new != da_old)
> -		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
> +		xfs_mod_delalloc(bma->ip, 0, (int64_t)da_new - da_old);
>  
>  	if (bma->cur) {
>  		da_new += bma->cur->bc_bmap.allocated;
> @@ -2694,7 +2694,7 @@ xfs_bmap_add_extent_hole_delay(
>  		/*
>  		 * Nothing to do for disk quota accounting here.
>  		 */
> -		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
> +		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
>  	}
>  }
>  
> @@ -3371,7 +3371,7 @@ xfs_bmap_alloc_account(
>  		 * yet.
>  		 */
>  		if (ap->wasdel) {
> -			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
> +			xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
>  			return;
>  		}
>  
> @@ -3395,7 +3395,7 @@ xfs_bmap_alloc_account(
>  	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
>  	if (ap->wasdel) {
>  		ap->ip->i_delayed_blks -= ap->length;
> -		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
> +		xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
>  		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
>  	} else {
>  		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
> @@ -4124,7 +4124,7 @@ xfs_bmapi_reserve_delalloc(
>  		goto out_unreserve_frextents;
>  
>  	ip->i_delayed_blks += alen;
> -	xfs_mod_delalloc(ip->i_mount, alen + indlen);
> +	xfs_mod_delalloc(ip, alen, indlen);
>  
>  	got->br_startoff = aoff;
>  	got->br_startblock = nullstartblock(indlen);
> @@ -5022,7 +5022,7 @@ xfs_bmap_del_extent_delay(
>  		fdblocks += del->br_blockcount;
>  
>  	xfs_add_fdblocks(mp, fdblocks);
> -	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
> +	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 6f465373aa2027..424fb9770f1920 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -412,6 +412,7 @@ xchk_fscount_count_frextents(
>  	int			error;
>  
>  	fsc->frextents = 0;
> +	fsc->frextents_delayed = 0;
>  	if (!xfs_has_realtime(mp))
>  		return 0;
>  
> @@ -423,6 +424,8 @@ xchk_fscount_count_frextents(
>  		goto out_unlock;
>  	}
>  
> +	fsc->frextents_delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
> +
>  out_unlock:
>  	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
>  	return error;
> @@ -434,6 +437,7 @@ xchk_fscount_count_frextents(
>  	struct xchk_fscounters	*fsc)
>  {
>  	fsc->frextents = 0;
> +	fsc->frextents_delayed = 0;
>  	return 0;
>  }
>  #endif /* CONFIG_XFS_RT */
> @@ -593,7 +597,7 @@ xchk_fscounters(
>  	}
>  
>  	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
> -			fsc->frextents)) {
> +			fsc->frextents - fsc->frextents_delayed)) {
>  		if (fsc->frozen)
>  			xchk_set_corrupt(sc);
>  		else
> diff --git a/fs/xfs/scrub/fscounters.h b/fs/xfs/scrub/fscounters.h
> index 461a13d25f4b38..bcf56e1c36f91c 100644
> --- a/fs/xfs/scrub/fscounters.h
> +++ b/fs/xfs/scrub/fscounters.h
> @@ -12,6 +12,7 @@ struct xchk_fscounters {
>  	uint64_t		ifree;
>  	uint64_t		fdblocks;
>  	uint64_t		frextents;
> +	uint64_t		frextents_delayed;
>  	unsigned long long	icount_min;
>  	unsigned long long	icount_max;
>  	bool			frozen;
> diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
> index 94cdb852bee462..210ebbcf3e1520 100644
> --- a/fs/xfs/scrub/fscounters_repair.c
> +++ b/fs/xfs/scrub/fscounters_repair.c
> @@ -65,7 +65,8 @@ xrep_fscounters(
>  	percpu_counter_set(&mp->m_icount, fsc->icount);
>  	percpu_counter_set(&mp->m_ifree, fsc->ifree);
>  	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
> -	percpu_counter_set(&mp->m_frextents, fsc->frextents);
> +	percpu_counter_set(&mp->m_frextents,
> +		fsc->frextents - fsc->frextents_delayed);
>  	mp->m_sb.sb_frextents = fsc->frextents;
>  
>  	return 0;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 575a3b98cdb514..7430a3c7765be8 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -34,6 +34,7 @@
>  #include "xfs_health.h"
>  #include "xfs_trace.h"
>  #include "xfs_ag.h"
> +#include "xfs_rtbitmap.h"
>  #include "scrub/stats.h"
>  
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
> @@ -1400,9 +1401,20 @@ xfs_clear_incompat_log_features(
>  #define XFS_DELALLOC_BATCH	(4096)
>  void
>  xfs_mod_delalloc(
> -	struct xfs_mount	*mp,
> -	int64_t			delta)
> +	struct xfs_inode	*ip,
> +	int64_t			data_delta,
> +	int64_t			ind_delta)
>  {
> -	percpu_counter_add_batch(&mp->m_delalloc_blks, delta,
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		percpu_counter_add_batch(&mp->m_delalloc_rtextents,
> +				xfs_rtb_to_rtx(mp, data_delta),
> +				XFS_DELALLOC_BATCH);
> +		if (!ind_delta)
> +			return;
> +		data_delta = 0;
> +	}
> +	percpu_counter_add_batch(&mp->m_delalloc_blks, data_delta + ind_delta,
>  			XFS_DELALLOC_BATCH);
>  }
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index d941437a0c7369..0e8d7779c0a561 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -195,6 +195,12 @@ typedef struct xfs_mount {
>  	 * extents or anything related to the rt device.
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
> +
> +	/*
> +	 * RT version of the above.
> +	 */
> +	struct percpu_counter	m_delalloc_rtextents;
> +
>  	/*
>  	 * Global count of allocation btree blocks in use across all AGs. Only
>  	 * used when perag reservation is enabled. Helps prevent block
> @@ -577,6 +583,7 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
>  void xfs_force_summary_recalc(struct xfs_mount *mp);
>  int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
>  bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
> -void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
> +void xfs_mod_delalloc(struct xfs_inode *ip, int64_t data_delta,
> +		int64_t ind_delta);
>  
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0afcb005a28fc1..71732457583370 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1052,12 +1052,18 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_fdblocks;
>  
> -	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> +	error = percpu_counter_init(&mp->m_delalloc_rtextents, 0, GFP_KERNEL);
>  	if (error)
>  		goto free_delalloc;
>  
> +	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_delalloc_rt;
> +
>  	return 0;
>  
> +free_delalloc_rt:
> +	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  free_delalloc:
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
>  free_fdblocks:
> @@ -1086,6 +1092,9 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_icount);
>  	percpu_counter_destroy(&mp->m_ifree);
>  	percpu_counter_destroy(&mp->m_fdblocks);
> +	ASSERT(xfs_is_shutdown(mp) ||
> +	       percpu_counter_sum(&mp->m_delalloc_rtextents) == 0);
> +	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> -- 
> 2.39.2
> 
