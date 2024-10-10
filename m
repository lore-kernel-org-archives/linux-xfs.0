Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC48413774D
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 19:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728586908; cv=none; b=OMLy6l7bXzTLsPzAWFDrxpehFgMBDTfBCSyw0n4CZJt6eSi5yO/nIpAGFgRDkJdoHwTKVb8iuvkVoAfSDwKdYfBqaqD1a14Lx3PNg4PFizTrSCWiaMGWFyctnqKgVc6lKzQYX9QOnFt2rDU8G2Z7hLTvXEgrhabpc29O7ppbCsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728586908; c=relaxed/simple;
	bh=g4y+UofWw+cQgc2W+i97hdt+/HiB2b1ROvC6bmk7nWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jE0BdsTq/v29S6SS5D50PbUYzhlz21/zeksP3R/170FfWQ13GJ0T7rKCZXxepgScERWr1KmXCqkAIbcgdOHAA6EXedVFwQZXf7zjKXpTH0ru1JITVBRRfP6cLx8vAmyTQm3gROccIXfBFW41aCfAcgk8t6YjzqtxcdZoGL1i7gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2sKh2Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2sKh2Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9EBC4CEC5;
	Thu, 10 Oct 2024 19:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728586908;
	bh=g4y+UofWw+cQgc2W+i97hdt+/HiB2b1ROvC6bmk7nWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2sKh2ZhOSISyagO1YuIb8nezDsdDzC6zj2FxH27HGt5dsDx0H7xPkpM9LYl7GG9T
	 H1/Je2KdCIZsytXUIOQ/tjw1slcxcicG/OJ9pJAS9Y45E9EWb+0grmjbBKaPd7/3hx
	 xU27y91CqPyQbddeODMAJafA/PNt9UKou2uBcO5kVrhmlWQ62u+4Fw64jP0Jiobq8B
	 fHVohOCk3ESYJ9SntDPwrp6uys7wrOkA//FJI7Pz7imGpMDos5RxALg896SNVRw4GJ
	 KoqhoowzIyrXQbwaz/X6rUNwrXNwL16F/OEl/bBucIEofPqP/s9bHBkHaWO+ndQXeC
	 y5dfmdWISln+g==
Date: Thu, 10 Oct 2024 12:01:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241010190147.GU21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-7-hch@lst.de>

On Mon, Sep 30, 2024 at 06:41:47PM +0200, Christoph Hellwig wrote:
> Updates to the file system geometry in growfs need to be committed to
> stable store before the allocator can see them to avoid that they are
> in the same CIL checkpoint as transactions that make use of this new
> information, which will make recovery impossible or broken.
> 
> To do this add two new helpers to prepare a superblock for direct
> manipulation of the on-disk buffer, and to commit these updates while
> holding the buffer locked (similar to what xfs_sync_sb_buf does) and use
> those in growfs instead of applying the changes through the deltas in the
> xfs_trans structure (which also happens to shrink the xfs_trans structure
> a fair bit).

Yay for shrinking xfs_trans!

> The rtbmimap repair code was also using the transaction deltas and is
> converted to also update the superblock buffer directly under the buffer
> lock.
> 
> This new method establishes a locking protocol where even in-core
> superblock fields must only be updated with the superblock buffer
> locked.  For now it is only applied to affected geometry fields,
> but in the future it would make sense to apply it universally.

Hmm.  One thing that I don't quite like here is the separation between
updating the ondisk sb fields and updating the incore sb/recomputing the
cached geometry fields.  I think that's been handled correctly here, but
the pending changes in growfsrt for rtgroups is going to make this more
ugly.

What if instead this took the form of a new defer_ops type?  The
xfs_prepare_sb_update function would allocate a tracking object where
we'd pin the sb buffer and record which fields get changed, as well as
the new values.  xfs_commit_sb_update then xfs_defer_add()s it to the
transaction and commits it.  (The ->create_intent function would return
NULL so that no log item is created.)

The ->finish_item function would then bhold the sb buffer, update the
ondisk super like how xfs_commit_sb_update does in this patch, set
XFS_SB_TRANS_SYNC, and return -EAGAIN.  The defer ops would commit and
flush that transaction and call ->finish_item again, at which point it
would recompute the incore/cached geometry as necessary, bwrite the sb
buffer, and release it.

The downside is that it's more complexity, but the upside is that the
geometry changes are contained in one place instead of being scattered
around, and the incore changes only happen if the synchronous
transaction actually gets written to disk.  IOWs, the end result is the
same as what you propose here, but structured differently.  

I guess the biggest downside is that log recovery has to call the
incore/cached geometry recomputation function directly because there's
no actual log intent item to recover.

(The code changes themselves look acceptable to me.)

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_sb.c         |  97 ++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_sb.h         |   3 +
>  fs/xfs/libxfs/xfs_shared.h     |   8 ---
>  fs/xfs/scrub/rtbitmap_repair.c |  26 +++++----
>  fs/xfs/xfs_fsops.c             |  80 ++++++++++++++++----------
>  fs/xfs/xfs_rtalloc.c           |  92 +++++++++++++++++-------------
>  fs/xfs/xfs_trans.c             | 101 ++-------------------------------
>  fs/xfs/xfs_trans.h             |   8 ---
>  8 files changed, 198 insertions(+), 217 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d95409f3cba667..2c83ab7441ade5 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1025,6 +1025,80 @@ xfs_sb_mount_common(
>  	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
>  }
>  
> +/*
> + * Mirror the lazy sb counters to the in-core superblock.
> + *
> + * If this is at unmount, the counters will be exactly correct, but at any other
> + * time they will only be ballpark correct because of reservations that have
> + * been taken out percpu counters.  If we have an unclean shutdown, this will be
> + * corrected by log recovery rebuilding the counters from the AGF block counts.
> + *
> + * Do not update sb_frextents here because it is not part of the lazy sb
> + * counters, despite having a percpu counter.  It is always kept consistent with
> + * the ondisk rtbitmap by xfs_trans_apply_sb_deltas() and hence we don't need
> + * have to update it here.
> + */
> +static void
> +xfs_flush_sb_counters(
> +	struct xfs_mount	*mp)
> +{
> +	if (xfs_has_lazysbcount(mp)) {
> +		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
> +		mp->m_sb.sb_ifree = min_t(uint64_t,
> +				percpu_counter_sum_positive(&mp->m_ifree),
> +				mp->m_sb.sb_icount);
> +		mp->m_sb.sb_fdblocks =
> +				percpu_counter_sum_positive(&mp->m_fdblocks);
> +	}
> +}
> +
> +/*
> + * Prepare a direct update to the superblock through the on-disk buffer.
> + *
> + * This locks out other modifications through the buffer lock and then syncs all
> + * in-core values to the on-disk buffer (including the percpu counters).
> + *
> + * The caller then directly manipulates the on-disk fields and calls
> + * xfs_commit_sb_update to the updates to disk them.  The caller is responsible
> + * to also update the in-core field, but it can do so after the transaction has
> + * been committed to disk.
> + *
> + * Updating the in-core field only after xfs_commit_sb_update ensures that other
> + * processes only see the update once it is stable on disk, and is usually the
> + * right thing to do for superblock updates.
> + *
> + * Note that writes to superblock fields updated using this helper are
> + * synchronized using the superblock buffer lock, which must be taken around
> + * all updates to the in-core fields as well.
> + */
> +struct xfs_dsb *
> +xfs_prepare_sb_update(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		**bpp)
> +{
> +	*bpp = xfs_trans_getsb(tp);
> +	xfs_flush_sb_counters(tp->t_mountp);
> +	xfs_sb_to_disk((*bpp)->b_addr, &tp->t_mountp->m_sb);
> +	return (*bpp)->b_addr;
> +}
> +
> +/*
> + * Commit a direct update to the on-disk superblock.  Keeps @bp locked and
> + * referenced, so the caller must call xfs_buf_relse() manually.
> + */
> +int
> +xfs_commit_sb_update(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	xfs_trans_bhold(tp, bp);
> +	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> +	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
> +
> +	xfs_trans_set_sync(tp);
> +	return xfs_trans_commit(tp);
> +}
> +
>  /*
>   * xfs_log_sb() can be used to copy arbitrary changes to the in-core superblock
>   * into the superblock buffer to be logged.  It does not provide the higher
> @@ -1038,28 +1112,7 @@ xfs_log_sb(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*bp = xfs_trans_getsb(tp);
>  
> -	/*
> -	 * Lazy sb counters don't update the in-core superblock so do that now.
> -	 * If this is at unmount, the counters will be exactly correct, but at
> -	 * any other time they will only be ballpark correct because of
> -	 * reservations that have been taken out percpu counters. If we have an
> -	 * unclean shutdown, this will be corrected by log recovery rebuilding
> -	 * the counters from the AGF block counts.
> -	 *
> -	 * Do not update sb_frextents here because it is not part of the lazy
> -	 * sb counters, despite having a percpu counter. It is always kept
> -	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
> -	 * and hence we don't need have to update it here.
> -	 */
> -	if (xfs_has_lazysbcount(mp)) {
> -		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
> -		mp->m_sb.sb_ifree = min_t(uint64_t,
> -				percpu_counter_sum_positive(&mp->m_ifree),
> -				mp->m_sb.sb_icount);
> -		mp->m_sb.sb_fdblocks =
> -				percpu_counter_sum_positive(&mp->m_fdblocks);
> -	}
> -
> +	xfs_flush_sb_counters(mp);
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
>  	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 885c837559914d..3649d071687e33 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -13,6 +13,9 @@ struct xfs_trans;
>  struct xfs_fsop_geom;
>  struct xfs_perag;
>  
> +struct xfs_dsb *xfs_prepare_sb_update(struct xfs_trans *tp,
> +			struct xfs_buf **bpp);
> +int		xfs_commit_sb_update(struct xfs_trans *tp, struct xfs_buf *bp);
>  extern void	xfs_log_sb(struct xfs_trans *tp);
>  extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
>  extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 33b84a3a83ff63..45a32ea426164a 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -149,14 +149,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
>  #define	XFS_TRANS_SB_FREXTENTS		0x00000010
>  #define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
> -#define	XFS_TRANS_SB_DBLOCKS		0x00000040
> -#define	XFS_TRANS_SB_AGCOUNT		0x00000080
> -#define	XFS_TRANS_SB_IMAXPCT		0x00000100
> -#define	XFS_TRANS_SB_REXTSIZE		0x00000200
> -#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
> -#define	XFS_TRANS_SB_RBLOCKS		0x00000800
> -#define	XFS_TRANS_SB_REXTENTS		0x00001000
> -#define	XFS_TRANS_SB_REXTSLOG		0x00002000
>  
>  /*
>   * Here we centralize the specification of XFS meta-data buffer reference count
> diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
> index 0fef98e9f83409..be9d31f032b1bf 100644
> --- a/fs/xfs/scrub/rtbitmap_repair.c
> +++ b/fs/xfs/scrub/rtbitmap_repair.c
> @@ -16,6 +16,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_sb.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> @@ -127,20 +128,21 @@ xrep_rtbitmap_geometry(
>  	struct xchk_rtbitmap	*rtb)
>  {
>  	struct xfs_mount	*mp = sc->mp;
> -	struct xfs_trans	*tp = sc->tp;
>  
>  	/* Superblock fields */
> -	if (mp->m_sb.sb_rextents != rtb->rextents)
> -		xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_REXTENTS,
> -				rtb->rextents - mp->m_sb.sb_rextents);
> -
> -	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBMBLOCKS,
> -				rtb->rbmblocks - mp->m_sb.sb_rbmblocks);
> -
> -	if (mp->m_sb.sb_rextslog != rtb->rextslog)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
> -				rtb->rextslog - mp->m_sb.sb_rextslog);
> +	if (mp->m_sb.sb_rextents != rtb->rextents ||
> +	    mp->m_sb.sb_rbmblocks != rtb->rbmblocks ||
> +	    mp->m_sb.sb_rextslog != rtb->rextslog) {
> +		struct xfs_buf		*bp = xfs_trans_getsb(sc->tp);
> +
> +		mp->m_sb.sb_rextents = rtb->rextents;
> +		mp->m_sb.sb_rbmblocks = rtb->rbmblocks;
> +		mp->m_sb.sb_rextslog = rtb->rextslog;
> +		xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +
> +		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> +		xfs_trans_log_buf(sc->tp, bp, 0, sizeof(struct xfs_dsb) - 1);
> +	}
>  
>  	/* Fix broken isize */
>  	sc->ip->i_disk_size = roundup_64(sc->ip->i_disk_size,
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b247d895c276d2..4168ccf21068cb 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -79,6 +79,46 @@ xfs_resizefs_init_new_ags(
>  	return error;
>  }
>  
> +static int
> +xfs_growfs_data_update_sb(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		nagcount,
> +	xfs_rfsblock_t		nb,
> +	xfs_agnumber_t		nagimax)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_dsb		*sbp;
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	/*
> +	 * Update the geometry in the on-disk superblock first, and ensure
> +	 * they make it to disk before the superblock can be relogged.
> +	 */
> +	sbp = xfs_prepare_sb_update(tp, &bp);
> +	sbp->sb_agcount = cpu_to_be32(nagcount);
> +	sbp->sb_dblocks = cpu_to_be64(nb);
> +	error = xfs_commit_sb_update(tp, bp);
> +	if (error)
> +		goto out_unlock;
> +
> +	/*
> +	 * Propagate the new values to the live mount structure after they made
> +	 * it to disk with the superblock buffer still locked.
> +	 */
> +	mp->m_sb.sb_agcount = nagcount;
> +	mp->m_sb.sb_dblocks = nb;
> +
> +	if (nagimax)
> +		mp->m_maxagi = nagimax;
> +	xfs_set_low_space_thresholds(mp);
> +	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> +
> +out_unlock:
> +	xfs_buf_relse(bp);
> +	return error;
> +}
> +
>  /*
>   * growfs operations
>   */
> @@ -171,37 +211,13 @@ xfs_growfs_data_private(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	/*
> -	 * Update changed superblock fields transactionally. These are not
> -	 * seen by the rest of the world until the transaction commit applies
> -	 * them atomically to the superblock.
> -	 */
> -	if (nagcount > oagcount)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (delta)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
>  
> -	/*
> -	 * Sync sb counters now to reflect the updated values. This is
> -	 * particularly important for shrink because the write verifier
> -	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
> -	 */
> -	if (xfs_has_lazysbcount(mp))
> -		xfs_log_sb(tp);
> -
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_growfs_data_update_sb(tp, nagcount, nb, nagimax);
>  	if (error)
>  		return error;
>  
> -	/* New allocation groups fully initialized, so update mount struct */
> -	if (nagimax)
> -		mp->m_maxagi = nagimax;
> -	xfs_set_low_space_thresholds(mp);
> -	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> -
>  	if (delta > 0) {
>  		/*
>  		 * If we expanded the last AG, free the per-AG reservation
> @@ -260,8 +276,9 @@ xfs_growfs_imaxpct(
>  	struct xfs_mount	*mp,
>  	__u32			imaxpct)
>  {
> +	struct xfs_dsb		*sbp;
> +	struct xfs_buf		*bp;
>  	struct xfs_trans	*tp;
> -	int			dpct;
>  	int			error;
>  
>  	if (imaxpct > 100)
> @@ -272,10 +289,13 @@ xfs_growfs_imaxpct(
>  	if (error)
>  		return error;
>  
> -	dpct = imaxpct - mp->m_sb.sb_imax_pct;
> -	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> -	xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> +	sbp = xfs_prepare_sb_update(tp, &bp);
> +	sbp->sb_imax_pct = imaxpct;
> +	error = xfs_commit_sb_update(tp, bp);
> +	if (!error)
> +		mp->m_sb.sb_imax_pct = imaxpct;
> +	xfs_buf_relse(bp);
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 3a2005a1e673dc..994e5efedab20f 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -698,6 +698,56 @@ xfs_growfs_rt_fixup_extsize(
>  	return error;
>  }
>  
> +static int
> +xfs_growfs_rt_update_sb(
> +	struct xfs_trans	*tp,
> +	struct xfs_mount	*mp,
> +	struct xfs_mount	*nmp,
> +	xfs_rtbxlen_t		freed_rtx)
> +{
> +	struct xfs_dsb		*sbp;
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	/*
> +	 * Update the geometry in the on-disk superblock first, and ensure
> +	 * they make it to disk before the superblock can be relogged.
> +	 */
> +	sbp = xfs_prepare_sb_update(tp, &bp);
> +	sbp->sb_rextsize = cpu_to_be32(nmp->m_sb.sb_rextsize);
> +	sbp->sb_rbmblocks = cpu_to_be32(nmp->m_sb.sb_rbmblocks);
> +	sbp->sb_rblocks = cpu_to_be64(nmp->m_sb.sb_rblocks);
> +	sbp->sb_rextents = cpu_to_be64(nmp->m_sb.sb_rextents);
> +	sbp->sb_rextslog = nmp->m_sb.sb_rextslog;
> +	error = xfs_commit_sb_update(tp, bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Propagate the new values to the live mount structure after they made
> +	 * it to disk with the superblock buffer still locked.
> +	 */
> +	mp->m_sb.sb_rextsize = nmp->m_sb.sb_rextsize;
> +	mp->m_sb.sb_rbmblocks = nmp->m_sb.sb_rbmblocks;
> +	mp->m_sb.sb_rblocks = nmp->m_sb.sb_rblocks;
> +	mp->m_sb.sb_rextents = nmp->m_sb.sb_rextents;
> +	mp->m_sb.sb_rextslog = nmp->m_sb.sb_rextslog;
> +	mp->m_rsumlevels = nmp->m_rsumlevels;
> +	mp->m_rsumblocks = nmp->m_rsumblocks;
> +
> +	/*
> +	 * Recompute the growfsrt reservation from the new rsumsize.
> +	 */
> +	xfs_trans_resv_calc(mp, &mp->m_resv);
> +
> +	/*
> +	 * Ensure the mount RT feature flag is now set.
> +	 */
> +	mp->m_features |= XFS_FEAT_REALTIME;
> +	xfs_buf_relse(bp);
> +	return 0;
> +}
> +
>  static int
>  xfs_growfs_rt_bmblock(
>  	struct xfs_mount	*mp,
> @@ -780,25 +830,6 @@ xfs_growfs_rt_bmblock(
>  			goto out_cancel;
>  	}
>  
> -	/*
> -	 * Update superblock fields.
> -	 */
> -	if (nmp->m_sb.sb_rextsize != mp->m_sb.sb_rextsize)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSIZE,
> -			nmp->m_sb.sb_rextsize - mp->m_sb.sb_rextsize);
> -	if (nmp->m_sb.sb_rbmblocks != mp->m_sb.sb_rbmblocks)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBMBLOCKS,
> -			nmp->m_sb.sb_rbmblocks - mp->m_sb.sb_rbmblocks);
> -	if (nmp->m_sb.sb_rblocks != mp->m_sb.sb_rblocks)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBLOCKS,
> -			nmp->m_sb.sb_rblocks - mp->m_sb.sb_rblocks);
> -	if (nmp->m_sb.sb_rextents != mp->m_sb.sb_rextents)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTENTS,
> -			nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents);
> -	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSLOG,
> -			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
> -
>  	/*
>  	 * Free the new extent.
>  	 */
> @@ -807,33 +838,12 @@ xfs_growfs_rt_bmblock(
>  	xfs_rtbuf_cache_relse(&nargs);
>  	if (error)
>  		goto out_cancel;
> -
> -	/*
> -	 * Mark more blocks free in the superblock.
> -	 */
>  	xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
>  
> -	/*
> -	 * Update the calculated values in the real mount structure.
> -	 */
> -	mp->m_rsumlevels = nmp->m_rsumlevels;
> -	mp->m_rsumblocks = nmp->m_rsumblocks;
> -	xfs_mount_sb_set_rextsize(mp, &mp->m_sb);
> -
> -	/*
> -	 * Recompute the growfsrt reservation from the new rsumsize.
> -	 */
> -	xfs_trans_resv_calc(mp, &mp->m_resv);
> -
> -	error = xfs_trans_commit(args.tp);
> +	error = xfs_growfs_rt_update_sb(args.tp, mp, nmp, freed_rtx);
>  	if (error)
>  		goto out_free;
>  
> -	/*
> -	 * Ensure the mount RT feature flag is now set.
> -	 */
> -	mp->m_features |= XFS_FEAT_REALTIME;
> -
>  	kfree(nmp);
>  	return 0;
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bdf3704dc30118..56505cb94f877d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -430,31 +430,6 @@ xfs_trans_mod_sb(
>  		ASSERT(delta < 0);
>  		tp->t_res_frextents_delta += delta;
>  		break;
> -	case XFS_TRANS_SB_DBLOCKS:
> -		tp->t_dblocks_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_AGCOUNT:
> -		ASSERT(delta > 0);
> -		tp->t_agcount_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_IMAXPCT:
> -		tp->t_imaxpct_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_REXTSIZE:
> -		tp->t_rextsize_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_RBMBLOCKS:
> -		tp->t_rbmblocks_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_RBLOCKS:
> -		tp->t_rblocks_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_REXTENTS:
> -		tp->t_rextents_delta += delta;
> -		break;
> -	case XFS_TRANS_SB_REXTSLOG:
> -		tp->t_rextslog_delta += delta;
> -		break;
>  	default:
>  		ASSERT(0);
>  		return;
> @@ -475,12 +450,8 @@ STATIC void
>  xfs_trans_apply_sb_deltas(
>  	xfs_trans_t	*tp)
>  {
> -	struct xfs_dsb	*sbp;
> -	struct xfs_buf	*bp;
> -	int		whole = 0;
> -
> -	bp = xfs_trans_getsb(tp);
> -	sbp = bp->b_addr;
> +	struct xfs_buf	*bp = xfs_trans_getsb(tp);
> +	struct xfs_dsb	*sbp = bp->b_addr;
>  
>  	/*
>  	 * Only update the superblock counters if we are logging them
> @@ -522,53 +493,10 @@ xfs_trans_apply_sb_deltas(
>  		spin_unlock(&mp->m_sb_lock);
>  	}
>  
> -	if (tp->t_dblocks_delta) {
> -		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
> -		whole = 1;
> -	}
> -	if (tp->t_agcount_delta) {
> -		be32_add_cpu(&sbp->sb_agcount, tp->t_agcount_delta);
> -		whole = 1;
> -	}
> -	if (tp->t_imaxpct_delta) {
> -		sbp->sb_imax_pct += tp->t_imaxpct_delta;
> -		whole = 1;
> -	}
> -	if (tp->t_rextsize_delta) {
> -		be32_add_cpu(&sbp->sb_rextsize, tp->t_rextsize_delta);
> -		whole = 1;
> -	}
> -	if (tp->t_rbmblocks_delta) {
> -		be32_add_cpu(&sbp->sb_rbmblocks, tp->t_rbmblocks_delta);
> -		whole = 1;
> -	}
> -	if (tp->t_rblocks_delta) {
> -		be64_add_cpu(&sbp->sb_rblocks, tp->t_rblocks_delta);
> -		whole = 1;
> -	}
> -	if (tp->t_rextents_delta) {
> -		be64_add_cpu(&sbp->sb_rextents, tp->t_rextents_delta);
> -		whole = 1;
> -	}
> -	if (tp->t_rextslog_delta) {
> -		sbp->sb_rextslog += tp->t_rextslog_delta;
> -		whole = 1;
> -	}
> -
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> -	if (whole)
> -		/*
> -		 * Log the whole thing, the fields are noncontiguous.
> -		 */
> -		xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
> -	else
> -		/*
> -		 * Since all the modifiable fields are contiguous, we
> -		 * can get away with this.
> -		 */
> -		xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
> -				  offsetof(struct xfs_dsb, sb_frextents) +
> -				  sizeof(sbp->sb_frextents) - 1);
> +	xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
> +			  offsetof(struct xfs_dsb, sb_frextents) +
> +			  sizeof(sbp->sb_frextents) - 1);
>  }
>  
>  /*
> @@ -656,26 +584,7 @@ xfs_trans_unreserve_and_mod_sb(
>  	 * must be consistent with the ondisk rtbitmap and must never include
>  	 * incore reservations.
>  	 */
> -	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> -	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> -	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
> -	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
> -	if (tp->t_rextsize_delta) {
> -		mp->m_rtxblklog = log2_if_power2(mp->m_sb.sb_rextsize);
> -		mp->m_rtxblkmask = mask64_if_power2(mp->m_sb.sb_rextsize);
> -	}
> -	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
> -	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
> -	mp->m_sb.sb_rextents += tp->t_rextents_delta;
> -	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
>  	spin_unlock(&mp->m_sb_lock);
> -
> -	/*
> -	 * Debug checks outside of the spinlock so they don't lock up the
> -	 * machine if they fail.
> -	 */
> -	ASSERT(mp->m_sb.sb_imax_pct >= 0);
> -	ASSERT(mp->m_sb.sb_rextslog >= 0);
>  }
>  
>  /* Add the given log item to the transaction's list of log items. */
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index f06cc0f41665ad..e5911cf09be444 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -140,14 +140,6 @@ typedef struct xfs_trans {
>  	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
>  	int64_t			t_frextents_delta;/* superblock freextents chg*/
>  	int64_t			t_res_frextents_delta; /* on-disk only chg */
> -	int64_t			t_dblocks_delta;/* superblock dblocks change */
> -	int64_t			t_agcount_delta;/* superblock agcount change */
> -	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
> -	int64_t			t_rextsize_delta;/* superblock rextsize chg */
> -	int64_t			t_rbmblocks_delta;/* superblock rbmblocks chg */
> -	int64_t			t_rblocks_delta;/* superblock rblocks change */
> -	int64_t			t_rextents_delta;/* superblocks rextents chg */
> -	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
>  	struct list_head	t_items;	/* log item descriptors */
>  	struct list_head	t_busy;		/* list of busy extents */
>  	struct list_head	t_dfops;	/* deferred operations */
> -- 
> 2.45.2
> 
> 
