Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BAC1A841F
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 21:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740001667; cv=none; b=G2LC6Rv4NqxnMubuAQI0H/UoP1Av1eZFhob4hj4FXSHJAVni6G+iusOfr5lI6vLHQDJ8B77Pmjviomxzs0QEZkaD6wEnGIzhQd/fbwtTvmmBRt+J2Vup5DELwWQjuej7voK2oRJI31YLzU3RjQlZdRwZUTEO1D+GrKxDZkC6vt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740001667; c=relaxed/simple;
	bh=A+8J/TIk0mMRXuE+hlh0jfJYjLs6WO7czRyfX96X8lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccA2F6JNlp0/jpKwsbvpIIuZF0RFaFd4RDz3wUsUngaucvRyBYsctHemt02vNSAgJtDPkI5md1UGuLtYUVz3QJUaEFAGug78qUKREoc30CDzAIKfTNw2bNomQUAI4D8VlNB3oBZTyKsKc1YHYbwWdAScrUSIaRQyT7F++l9lJiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmnhBzR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmnhBzR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5709C4CED1;
	Wed, 19 Feb 2025 21:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740001667;
	bh=A+8J/TIk0mMRXuE+hlh0jfJYjLs6WO7czRyfX96X8lw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dmnhBzR+NGfH86CMbYOzczYKVa8BXnYKitmlCy7Kr58RsVxDoSFrCmd5fHxtBI/vM
	 1FF/ffXCcURZTpU775FY9WAC7gFKeF9Qsobj3O406qdFittV5Lv6ZnccCwIYkGWaWe
	 yw8vTGyY4IcG9g93SnA0W/j7Uo4ub2K8kTf1U/pMNZj6f3pV1eg6xSRDV5qgXoywHJ
	 ptyHbSm/hoHzpmcJ2mlbVA30CtIXkQKBnp01RGKvuskFockXpsq9eBmvwKFoGLOFkk
	 rFAhohE8Woa4pjTfi/wfFdi8K2P9x0TlF9v/HfKaVgsWQtT3f/l3d5+pB+jV+5wGBx
	 VDdOTXhoBm3mw==
Date: Wed, 19 Feb 2025 13:47:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/45] xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
Message-ID: <20250219214746.GW21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-12-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:14AM +0100, Christoph Hellwig wrote:
> Delalloc reservations are not supported in userspace, and thus it doesn't
> make sense to share this helper with xfsprogs.c.  Move it to xfs_iomap.c
> toward the two callers.
> 
> Note that there rest of the delalloc handling should probably eventually
> also move out of xfs_bmap.c, but that will require a bit more surgery.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 295 +--------------------------------------
>  fs/xfs/libxfs/xfs_bmap.h |   5 +-
>  fs/xfs/xfs_iomap.c       | 279 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 287 insertions(+), 292 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0ef19f1469ec..5b17e59ed5b8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -34,7 +34,6 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_refcount.h"
> -#include "xfs_icache.h"
>  #include "xfs_iomap.h"
>  #include "xfs_health.h"
>  #include "xfs_bmap_item.h"
> @@ -171,18 +170,16 @@ xfs_bmbt_update(
>   * Compute the worst-case number of indirect blocks that will be used
>   * for ip's delayed extent of length "len".
>   */
> -STATIC xfs_filblks_t
> +xfs_filblks_t
>  xfs_bmap_worst_indlen(
> -	xfs_inode_t	*ip,		/* incore inode pointer */
> -	xfs_filblks_t	len)		/* delayed extent length */
> +	struct xfs_inode	*ip,		/* incore inode pointer */
> +	xfs_filblks_t		len)		/* delayed extent length */
>  {
> -	int		level;		/* btree level number */
> -	int		maxrecs;	/* maximum record count at this level */
> -	xfs_mount_t	*mp;		/* mount structure */
> -	xfs_filblks_t	rval;		/* return value */
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			maxrecs = mp->m_bmap_dmxr[0];
> +	int			level;
> +	xfs_filblks_t		rval;
>  
> -	mp = ip->i_mount;
> -	maxrecs = mp->m_bmap_dmxr[0];
>  	for (level = 0, rval = 0;
>  	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
>  	     level++) {
> @@ -2571,146 +2568,6 @@ xfs_bmap_add_extent_unwritten_real(
>  #undef	PREV
>  }
>  
> -/*
> - * Convert a hole to a delayed allocation.
> - */
> -STATIC void
> -xfs_bmap_add_extent_hole_delay(
> -	xfs_inode_t		*ip,	/* incore inode pointer */
> -	int			whichfork,
> -	struct xfs_iext_cursor	*icur,
> -	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
> -{
> -	struct xfs_ifork	*ifp;	/* inode fork pointer */
> -	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
> -	xfs_filblks_t		newlen=0;	/* new indirect size */
> -	xfs_filblks_t		oldlen=0;	/* old indirect size */
> -	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
> -	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
> -	xfs_filblks_t		temp;	 /* temp for indirect calculations */
> -
> -	ifp = xfs_ifork_ptr(ip, whichfork);
> -	ASSERT(isnullstartblock(new->br_startblock));
> -
> -	/*
> -	 * Check and set flags if this segment has a left neighbor
> -	 */
> -	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
> -		state |= BMAP_LEFT_VALID;
> -		if (isnullstartblock(left.br_startblock))
> -			state |= BMAP_LEFT_DELAY;
> -	}
> -
> -	/*
> -	 * Check and set flags if the current (right) segment exists.
> -	 * If it doesn't exist, we're converting the hole at end-of-file.
> -	 */
> -	if (xfs_iext_get_extent(ifp, icur, &right)) {
> -		state |= BMAP_RIGHT_VALID;
> -		if (isnullstartblock(right.br_startblock))
> -			state |= BMAP_RIGHT_DELAY;
> -	}
> -
> -	/*
> -	 * Set contiguity flags on the left and right neighbors.
> -	 * Don't let extents get too large, even if the pieces are contiguous.
> -	 */
> -	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
> -	    left.br_startoff + left.br_blockcount == new->br_startoff &&
> -	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
> -		state |= BMAP_LEFT_CONTIG;
> -
> -	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
> -	    new->br_startoff + new->br_blockcount == right.br_startoff &&
> -	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
> -	    (!(state & BMAP_LEFT_CONTIG) ||
> -	     (left.br_blockcount + new->br_blockcount +
> -	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
> -		state |= BMAP_RIGHT_CONTIG;
> -
> -	/*
> -	 * Switch out based on the contiguity flags.
> -	 */
> -	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
> -	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> -		/*
> -		 * New allocation is contiguous with delayed allocations
> -		 * on the left and on the right.
> -		 * Merge all three into a single extent record.
> -		 */
> -		temp = left.br_blockcount + new->br_blockcount +
> -			right.br_blockcount;
> -
> -		oldlen = startblockval(left.br_startblock) +
> -			startblockval(new->br_startblock) +
> -			startblockval(right.br_startblock);
> -		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> -					 oldlen);
> -		left.br_startblock = nullstartblock(newlen);
> -		left.br_blockcount = temp;
> -
> -		xfs_iext_remove(ip, icur, state);
> -		xfs_iext_prev(ifp, icur);
> -		xfs_iext_update_extent(ip, state, icur, &left);
> -		break;
> -
> -	case BMAP_LEFT_CONTIG:
> -		/*
> -		 * New allocation is contiguous with a delayed allocation
> -		 * on the left.
> -		 * Merge the new allocation with the left neighbor.
> -		 */
> -		temp = left.br_blockcount + new->br_blockcount;
> -
> -		oldlen = startblockval(left.br_startblock) +
> -			startblockval(new->br_startblock);
> -		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> -					 oldlen);
> -		left.br_blockcount = temp;
> -		left.br_startblock = nullstartblock(newlen);
> -
> -		xfs_iext_prev(ifp, icur);
> -		xfs_iext_update_extent(ip, state, icur, &left);
> -		break;
> -
> -	case BMAP_RIGHT_CONTIG:
> -		/*
> -		 * New allocation is contiguous with a delayed allocation
> -		 * on the right.
> -		 * Merge the new allocation with the right neighbor.
> -		 */
> -		temp = new->br_blockcount + right.br_blockcount;
> -		oldlen = startblockval(new->br_startblock) +
> -			startblockval(right.br_startblock);
> -		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> -					 oldlen);
> -		right.br_startoff = new->br_startoff;
> -		right.br_startblock = nullstartblock(newlen);
> -		right.br_blockcount = temp;
> -		xfs_iext_update_extent(ip, state, icur, &right);
> -		break;
> -
> -	case 0:
> -		/*
> -		 * New allocation is not contiguous with another
> -		 * delayed allocation.
> -		 * Insert a new entry.
> -		 */
> -		oldlen = newlen = 0;
> -		xfs_iext_insert(ip, icur, new, state);
> -		break;
> -	}
> -	if (oldlen != newlen) {
> -		ASSERT(oldlen > newlen);
> -		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
> -
> -		/*
> -		 * Nothing to do for disk quota accounting here.
> -		 */
> -		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
> -	}
> -}
> -
>  /*
>   * Convert a hole to a real allocation.
>   */
> @@ -4039,144 +3896,6 @@ xfs_bmapi_read(
>  	return 0;
>  }
>  
> -/*
> - * Add a delayed allocation extent to an inode. Blocks are reserved from the
> - * global pool and the extent inserted into the inode in-core extent tree.
> - *
> - * On entry, got refers to the first extent beyond the offset of the extent to
> - * allocate or eof is specified if no such extent exists. On return, got refers
> - * to the extent record that was inserted to the inode fork.
> - *
> - * Note that the allocated extent may have been merged with contiguous extents
> - * during insertion into the inode fork. Thus, got does not reflect the current
> - * state of the inode fork on return. If necessary, the caller can use lastx to
> - * look up the updated record in the inode fork.
> - */
> -int
> -xfs_bmapi_reserve_delalloc(
> -	struct xfs_inode	*ip,
> -	int			whichfork,
> -	xfs_fileoff_t		off,
> -	xfs_filblks_t		len,
> -	xfs_filblks_t		prealloc,
> -	struct xfs_bmbt_irec	*got,
> -	struct xfs_iext_cursor	*icur,
> -	int			eof)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> -	xfs_extlen_t		alen;
> -	xfs_extlen_t		indlen;
> -	uint64_t		fdblocks;
> -	int			error;
> -	xfs_fileoff_t		aoff;
> -	bool			use_cowextszhint =
> -					whichfork == XFS_COW_FORK && !prealloc;
> -
> -retry:
> -	/*
> -	 * Cap the alloc length. Keep track of prealloc so we know whether to
> -	 * tag the inode before we return.
> -	 */
> -	aoff = off;
> -	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
> -	if (!eof)
> -		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
> -	if (prealloc && alen >= len)
> -		prealloc = alen - len;
> -
> -	/*
> -	 * If we're targetting the COW fork but aren't creating a speculative
> -	 * posteof preallocation, try to expand the reservation to align with
> -	 * the COW extent size hint if there's sufficient free space.
> -	 *
> -	 * Unlike the data fork, the CoW cancellation functions will free all
> -	 * the reservations at inactivation, so we don't require that every
> -	 * delalloc reservation have a dirty pagecache.
> -	 */
> -	if (use_cowextszhint) {
> -		struct xfs_bmbt_irec	prev;
> -		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
> -
> -		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
> -			prev.br_startoff = NULLFILEOFF;
> -
> -		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
> -					       1, 0, &aoff, &alen);
> -		ASSERT(!error);
> -	}
> -
> -	/*
> -	 * Make a transaction-less quota reservation for delayed allocation
> -	 * blocks.  This number gets adjusted later.  We return if we haven't
> -	 * allocated blocks already inside this loop.
> -	 */
> -	error = xfs_quota_reserve_blkres(ip, alen);
> -	if (error)
> -		goto out;
> -
> -	/*
> -	 * Split changing sb for alen and indlen since they could be coming
> -	 * from different places.
> -	 */
> -	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
> -	ASSERT(indlen > 0);
> -
> -	fdblocks = indlen;
> -	if (XFS_IS_REALTIME_INODE(ip)) {
> -		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
> -		if (error)
> -			goto out_unreserve_quota;
> -	} else {
> -		fdblocks += alen;
> -	}
> -
> -	error = xfs_dec_fdblocks(mp, fdblocks, false);
> -	if (error)
> -		goto out_unreserve_frextents;
> -
> -	ip->i_delayed_blks += alen;
> -	xfs_mod_delalloc(ip, alen, indlen);
> -
> -	got->br_startoff = aoff;
> -	got->br_startblock = nullstartblock(indlen);
> -	got->br_blockcount = alen;
> -	got->br_state = XFS_EXT_NORM;
> -
> -	xfs_bmap_add_extent_hole_delay(ip, whichfork, icur, got);
> -
> -	/*
> -	 * Tag the inode if blocks were preallocated. Note that COW fork
> -	 * preallocation can occur at the start or end of the extent, even when
> -	 * prealloc == 0, so we must also check the aligned offset and length.
> -	 */
> -	if (whichfork == XFS_DATA_FORK && prealloc)
> -		xfs_inode_set_eofblocks_tag(ip);
> -	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
> -		xfs_inode_set_cowblocks_tag(ip);
> -
> -	return 0;
> -
> -out_unreserve_frextents:
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
> -out_unreserve_quota:
> -	if (XFS_IS_QUOTA_ON(mp))
> -		xfs_quota_unreserve_blkres(ip, alen);
> -out:
> -	if (error == -ENOSPC || error == -EDQUOT) {
> -		trace_xfs_delalloc_enospc(ip, off, len);
> -
> -		if (prealloc || use_cowextszhint) {
> -			/* retry without any preallocation */
> -			use_cowextszhint = false;
> -			prealloc = 0;
> -			goto retry;
> -		}
> -	}
> -	return error;
> -}
> -
>  static int
>  xfs_bmapi_allocate(
>  	struct xfs_bmalloca	*bma)
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 4b721d935994..4d48087fd3a8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -219,10 +219,6 @@ int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		bool *done, xfs_fileoff_t stop_fsb);
>  int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t split_offset);
> -int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
> -		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
> -		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
> -		int eof);
>  int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_off_t offset, struct iomap *iomap, unsigned int *seq);
>  int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
> @@ -233,6 +229,7 @@ xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
>  		int fork);
>  int	xfs_bmap_btalloc_low_space(struct xfs_bmalloca *ap,
>  		struct xfs_alloc_arg *args);
> +xfs_filblks_t xfs_bmap_worst_indlen(struct xfs_inode *ip, xfs_filblks_t len);
>  
>  enum xfs_bmap_intent_type {
>  	XFS_BMAP_MAP = 1,
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c669b93bb2d1..a724fc2612e3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -30,6 +30,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_health.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_icache.h"
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -988,6 +989,284 @@ const struct iomap_ops xfs_dax_write_iomap_ops = {
>  	.iomap_end	= xfs_dax_write_iomap_end,
>  };
>  
> +/*
> + * Convert a hole to a delayed allocation.
> + */
> +static void
> +xfs_bmap_add_extent_hole_delay(
> +	struct xfs_inode	*ip,	/* incore inode pointer */
> +	int			whichfork,
> +	struct xfs_iext_cursor	*icur,
> +	struct xfs_bmbt_irec	*new)	/* new data to add to file extents */
> +{
> +	struct xfs_ifork	*ifp;	/* inode fork pointer */
> +	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
> +	xfs_filblks_t		newlen=0;	/* new indirect size */
> +	xfs_filblks_t		oldlen=0;	/* old indirect size */
> +	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
> +	xfs_filblks_t		temp;	 /* temp for indirect calculations */
> +
> +	ifp = xfs_ifork_ptr(ip, whichfork);
> +	ASSERT(isnullstartblock(new->br_startblock));
> +
> +	/*
> +	 * Check and set flags if this segment has a left neighbor
> +	 */
> +	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
> +		state |= BMAP_LEFT_VALID;
> +		if (isnullstartblock(left.br_startblock))
> +			state |= BMAP_LEFT_DELAY;
> +	}
> +
> +	/*
> +	 * Check and set flags if the current (right) segment exists.
> +	 * If it doesn't exist, we're converting the hole at end-of-file.
> +	 */
> +	if (xfs_iext_get_extent(ifp, icur, &right)) {
> +		state |= BMAP_RIGHT_VALID;
> +		if (isnullstartblock(right.br_startblock))
> +			state |= BMAP_RIGHT_DELAY;
> +	}
> +
> +	/*
> +	 * Set contiguity flags on the left and right neighbors.
> +	 * Don't let extents get too large, even if the pieces are contiguous.
> +	 */
> +	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
> +	    left.br_startoff + left.br_blockcount == new->br_startoff &&
> +	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
> +		state |= BMAP_LEFT_CONTIG;
> +
> +	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
> +	    new->br_startoff + new->br_blockcount == right.br_startoff &&
> +	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
> +	    (!(state & BMAP_LEFT_CONTIG) ||
> +	     (left.br_blockcount + new->br_blockcount +
> +	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
> +		state |= BMAP_RIGHT_CONTIG;
> +
> +	/*
> +	 * Switch out based on the contiguity flags.
> +	 */
> +	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
> +	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> +		/*
> +		 * New allocation is contiguous with delayed allocations
> +		 * on the left and on the right.
> +		 * Merge all three into a single extent record.
> +		 */
> +		temp = left.br_blockcount + new->br_blockcount +
> +			right.br_blockcount;
> +
> +		oldlen = startblockval(left.br_startblock) +
> +			startblockval(new->br_startblock) +
> +			startblockval(right.br_startblock);
> +		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> +					 oldlen);
> +		left.br_startblock = nullstartblock(newlen);
> +		left.br_blockcount = temp;
> +
> +		xfs_iext_remove(ip, icur, state);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &left);
> +		break;
> +
> +	case BMAP_LEFT_CONTIG:
> +		/*
> +		 * New allocation is contiguous with a delayed allocation
> +		 * on the left.
> +		 * Merge the new allocation with the left neighbor.
> +		 */
> +		temp = left.br_blockcount + new->br_blockcount;
> +
> +		oldlen = startblockval(left.br_startblock) +
> +			startblockval(new->br_startblock);
> +		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> +					 oldlen);
> +		left.br_blockcount = temp;
> +		left.br_startblock = nullstartblock(newlen);
> +
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &left);
> +		break;
> +
> +	case BMAP_RIGHT_CONTIG:
> +		/*
> +		 * New allocation is contiguous with a delayed allocation
> +		 * on the right.
> +		 * Merge the new allocation with the right neighbor.
> +		 */
> +		temp = new->br_blockcount + right.br_blockcount;
> +		oldlen = startblockval(new->br_startblock) +
> +			startblockval(right.br_startblock);
> +		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> +					 oldlen);
> +		right.br_startoff = new->br_startoff;
> +		right.br_startblock = nullstartblock(newlen);
> +		right.br_blockcount = temp;
> +		xfs_iext_update_extent(ip, state, icur, &right);
> +		break;
> +
> +	case 0:
> +		/*
> +		 * New allocation is not contiguous with another
> +		 * delayed allocation.
> +		 * Insert a new entry.
> +		 */
> +		oldlen = newlen = 0;
> +		xfs_iext_insert(ip, icur, new, state);
> +		break;
> +	}
> +	if (oldlen != newlen) {
> +		ASSERT(oldlen > newlen);
> +		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
> +
> +		/*
> +		 * Nothing to do for disk quota accounting here.
> +		 */
> +		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
> +	}
> +}
> +
> +/*
> + * Add a delayed allocation extent to an inode. Blocks are reserved from the
> + * global pool and the extent inserted into the inode in-core extent tree.
> + *
> + * On entry, got refers to the first extent beyond the offset of the extent to
> + * allocate or eof is specified if no such extent exists. On return, got refers
> + * to the extent record that was inserted to the inode fork.
> + *
> + * Note that the allocated extent may have been merged with contiguous extents
> + * during insertion into the inode fork. Thus, got does not reflect the current
> + * state of the inode fork on return. If necessary, the caller can use lastx to
> + * look up the updated record in the inode fork.
> + */
> +static int
> +xfs_bmapi_reserve_delalloc(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	xfs_fileoff_t		off,
> +	xfs_filblks_t		len,
> +	xfs_filblks_t		prealloc,
> +	struct xfs_bmbt_irec	*got,
> +	struct xfs_iext_cursor	*icur,
> +	int			eof)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> +	xfs_extlen_t		alen;
> +	xfs_extlen_t		indlen;
> +	uint64_t		fdblocks;
> +	int			error;
> +	xfs_fileoff_t		aoff;
> +	bool			use_cowextszhint =
> +					whichfork == XFS_COW_FORK && !prealloc;
> +
> +retry:
> +	/*
> +	 * Cap the alloc length. Keep track of prealloc so we know whether to
> +	 * tag the inode before we return.
> +	 */
> +	aoff = off;
> +	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
> +	if (!eof)
> +		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
> +	if (prealloc && alen >= len)
> +		prealloc = alen - len;
> +
> +	/*
> +	 * If we're targetting the COW fork but aren't creating a speculative
> +	 * posteof preallocation, try to expand the reservation to align with
> +	 * the COW extent size hint if there's sufficient free space.
> +	 *
> +	 * Unlike the data fork, the CoW cancellation functions will free all
> +	 * the reservations at inactivation, so we don't require that every
> +	 * delalloc reservation have a dirty pagecache.
> +	 */
> +	if (use_cowextszhint) {
> +		struct xfs_bmbt_irec	prev;
> +		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
> +
> +		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
> +			prev.br_startoff = NULLFILEOFF;
> +
> +		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
> +					       1, 0, &aoff, &alen);
> +		ASSERT(!error);
> +	}
> +
> +	/*
> +	 * Make a transaction-less quota reservation for delayed allocation
> +	 * blocks.  This number gets adjusted later.  We return if we haven't
> +	 * allocated blocks already inside this loop.
> +	 */
> +	error = xfs_quota_reserve_blkres(ip, alen);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Split changing sb for alen and indlen since they could be coming
> +	 * from different places.
> +	 */
> +	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
> +	ASSERT(indlen > 0);
> +
> +	fdblocks = indlen;
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
> +		if (error)
> +			goto out_unreserve_quota;
> +	} else {
> +		fdblocks += alen;
> +	}
> +
> +	error = xfs_dec_fdblocks(mp, fdblocks, false);
> +	if (error)
> +		goto out_unreserve_frextents;
> +
> +	ip->i_delayed_blks += alen;
> +	xfs_mod_delalloc(ip, alen, indlen);
> +
> +	got->br_startoff = aoff;
> +	got->br_startblock = nullstartblock(indlen);
> +	got->br_blockcount = alen;
> +	got->br_state = XFS_EXT_NORM;
> +
> +	xfs_bmap_add_extent_hole_delay(ip, whichfork, icur, got);
> +
> +	/*
> +	 * Tag the inode if blocks were preallocated. Note that COW fork
> +	 * preallocation can occur at the start or end of the extent, even when
> +	 * prealloc == 0, so we must also check the aligned offset and length.
> +	 */
> +	if (whichfork == XFS_DATA_FORK && prealloc)
> +		xfs_inode_set_eofblocks_tag(ip);
> +	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
> +		xfs_inode_set_cowblocks_tag(ip);
> +
> +	return 0;
> +
> +out_unreserve_frextents:
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
> +out_unreserve_quota:
> +	if (XFS_IS_QUOTA_ON(mp))
> +		xfs_quota_unreserve_blkres(ip, alen);
> +out:
> +	if (error == -ENOSPC || error == -EDQUOT) {
> +		trace_xfs_delalloc_enospc(ip, off, len);
> +
> +		if (prealloc || use_cowextszhint) {
> +			/* retry without any preallocation */
> +			use_cowextszhint = false;
> +			prealloc = 0;
> +			goto retry;
> +		}
> +	}
> +	return error;
> +}
> +
>  static int
>  xfs_buffered_write_iomap_begin(
>  	struct inode		*inode,
> -- 
> 2.45.2
> 
> 
