Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0852112
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmbknC95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F289C433C7;
	Thu, 14 Dec 2023 20:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702586919;
	bh=kNIJB7aUK6QZMH+2PEiCOklExzCMJZobezOPMEwNW9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QmbknC958eF7RAnOrCwYEQOubI1NesHmbOr2ShipjTNsy/54z8y9hFkZmI15X8MKr
	 9Hyu4eczn43AEQtjtDJPyCSfqpQVWakH4gkVt/R96hupivZ6ZNSmJCXaL/59+A6j+c
	 vI5GV2IvpIh4i7J3vkd9TWwAeEnDAV9DFrad6HgyjNePQvCMNNAIZZBwUKZ3DVErrT
	 ykXQSh9loghRpOXkwmxVl9BQ8Sq3ZtkVfRNE56uiRwZP9riab8nxFjcrLl4YWAYknq
	 sEl7lnCbDijN3lLDMqVDKsZ1riMHK7ndzyWh4s2NCZjpcx8KvMjSiHOTv3oickeXt8
	 L03ByWkocfkBw==
Date: Thu, 14 Dec 2023 12:48:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/19] xfs: move xfs_bmap_rtalloc to xfs_rtalloc.c
Message-ID: <20231214204838.GT361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-6-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:24AM +0100, Christoph Hellwig wrote:
> xfs_bmap_rtalloc is currently in xfs_bmap_util.c, which is a somewhat
> odd spot for it, given that is only called from xfs_bmap.c and calls
> into xfs_rtalloc.c to do the actual work.  Move xfs_bmap_rtalloc to
> xfs_rtalloc.c and mark xfs_rtpick_extent xfs_rtallocate_extent and
> xfs_rtallocate_extent static now that they aren't called from outside
> of xfs_rtalloc.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I never understood why xfs_bmap_rtalloc was there either, aside from the
namespacing.  But even then, xfs_rtalloc_bmap?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 131 ---------------------------------------
>  fs/xfs/xfs_rtalloc.c   | 135 ++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_rtalloc.h   |  37 -----------
>  3 files changed, 133 insertions(+), 170 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d6432a7ef2857d..c2531c28905c09 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -69,137 +69,6 @@ xfs_zero_extent(
>  		GFP_NOFS, 0);
>  }
>  
> -#ifdef CONFIG_XFS_RT
> -int
> -xfs_bmap_rtalloc(
> -	struct xfs_bmalloca	*ap)
> -{
> -	struct xfs_mount	*mp = ap->ip->i_mount;
> -	xfs_fileoff_t		orig_offset = ap->offset;
> -	xfs_rtxnum_t		rtx;
> -	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
> -	xfs_extlen_t		mod = 0;   /* product factor for allocators */
> -	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
> -	xfs_extlen_t		align;     /* minimum allocation alignment */
> -	xfs_extlen_t		orig_length = ap->length;
> -	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
> -	xfs_rtxlen_t		raminlen;
> -	bool			rtlocked = false;
> -	bool			ignore_locality = false;
> -	int			error;
> -
> -	align = xfs_get_extsz_hint(ap->ip);
> -retry:
> -	prod = xfs_extlen_to_rtxlen(mp, align);
> -	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> -					align, 1, ap->eof, 0,
> -					ap->conv, &ap->offset, &ap->length);
> -	if (error)
> -		return error;
> -	ASSERT(ap->length);
> -	ASSERT(xfs_extlen_to_rtxmod(mp, ap->length) == 0);
> -
> -	/*
> -	 * If we shifted the file offset downward to satisfy an extent size
> -	 * hint, increase minlen by that amount so that the allocator won't
> -	 * give us an allocation that's too short to cover at least one of the
> -	 * blocks that the caller asked for.
> -	 */
> -	if (ap->offset != orig_offset)
> -		minlen += orig_offset - ap->offset;
> -
> -	/*
> -	 * If the offset & length are not perfectly aligned
> -	 * then kill prod, it will just get us in trouble.
> -	 */
> -	div_u64_rem(ap->offset, align, &mod);
> -	if (mod || ap->length % align)
> -		prod = 1;
> -	/*
> -	 * Set ralen to be the actual requested length in rtextents.
> -	 *
> -	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
> -	 * we rounded up to it, cut it back so it's valid again.
> -	 * Note that if it's a really large request (bigger than
> -	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
> -	 * adjust the starting point to match it.
> -	 */
> -	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
> -
> -	/*
> -	 * Lock out modifications to both the RT bitmap and summary inodes
> -	 */
> -	if (!rtlocked) {
> -		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> -		xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> -		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> -		xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> -		rtlocked = true;
> -	}
> -
> -	/*
> -	 * If it's an allocation to an empty file at offset 0,
> -	 * pick an extent that will space things out in the rt area.
> -	 */
> -	if (ap->eof && ap->offset == 0) {
> -		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
> -		if (error)
> -			return error;
> -		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
> -	} else {
> -		ap->blkno = 0;
> -	}
> -
> -	xfs_bmap_adjacent(ap);
> -
> -	/*
> -	 * Realtime allocation, done through xfs_rtallocate_extent.
> -	 */
> -	if (ignore_locality)
> -		rtx = 0;
> -	else
> -		rtx = xfs_rtb_to_rtx(mp, ap->blkno);
> -	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
> -	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
> -			ap->wasdel, prod, &rtx);
> -	if (error)
> -		return error;
> -
> -	if (rtx != NULLRTEXTNO) {
> -		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
> -		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
> -		xfs_bmap_alloc_account(ap);
> -		return 0;
> -	}
> -
> -	if (align > mp->m_sb.sb_rextsize) {
> -		/*
> -		 * We previously enlarged the request length to try to satisfy
> -		 * an extent size hint.  The allocator didn't return anything,
> -		 * so reset the parameters to the original values and try again
> -		 * without alignment criteria.
> -		 */
> -		ap->offset = orig_offset;
> -		ap->length = orig_length;
> -		minlen = align = mp->m_sb.sb_rextsize;
> -		goto retry;
> -	}
> -
> -	if (!ignore_locality && ap->blkno != 0) {
> -		/*
> -		 * If we can't allocate near a specific rt extent, try again
> -		 * without locality criteria.
> -		 */
> -		ignore_locality = true;
> -		goto retry;
> -	}
> -
> -	ap->blkno = NULLFSBLOCK;
> -	ap->length = 0;
> -	return 0;
> -}
> -#endif /* CONFIG_XFS_RT */
> -
>  /*
>   * Extent tree block counting routines.
>   */
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index fe98a96a26484f..74edea8579818d 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -14,12 +14,14 @@
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_bmap_util.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_icache.h"
>  #include "xfs_rtalloc.h"
>  #include "xfs_sb.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_quota.h"
>  
>  /*
>   * Read and return the summary information for a given extent size,
> @@ -1166,7 +1168,7 @@ xfs_growfs_rt(
>   * parameters.  The length units are all in realtime extents, as is the
>   * result block number.
>   */
> -int
> +static int
>  xfs_rtallocate_extent(
>  	struct xfs_trans	*tp,
>  	xfs_rtxnum_t		start,	/* starting rtext number to allocate */
> @@ -1414,7 +1416,7 @@ xfs_rtunmount_inodes(
>   * of rtextents and the fraction.
>   * The fraction sequence is 0, 1/2, 1/4, 3/4, 1/8, ..., 7/8, 1/16, ...
>   */
> -int						/* error */
> +static int
>  xfs_rtpick_extent(
>  	xfs_mount_t		*mp,		/* file system mount point */
>  	xfs_trans_t		*tp,		/* transaction pointer */
> @@ -1453,3 +1455,132 @@ xfs_rtpick_extent(
>  	*pick = b;
>  	return 0;
>  }
> +
> +int
> +xfs_bmap_rtalloc(
> +	struct xfs_bmalloca	*ap)
> +{
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	xfs_fileoff_t		orig_offset = ap->offset;
> +	xfs_rtxnum_t		rtx;
> +	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
> +	xfs_extlen_t		mod = 0;   /* product factor for allocators */
> +	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
> +	xfs_extlen_t		align;     /* minimum allocation alignment */
> +	xfs_extlen_t		orig_length = ap->length;
> +	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
> +	xfs_rtxlen_t		raminlen;
> +	bool			rtlocked = false;
> +	bool			ignore_locality = false;
> +	int			error;
> +
> +	align = xfs_get_extsz_hint(ap->ip);
> +retry:
> +	prod = xfs_extlen_to_rtxlen(mp, align);
> +	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> +					align, 1, ap->eof, 0,
> +					ap->conv, &ap->offset, &ap->length);
> +	if (error)
> +		return error;
> +	ASSERT(ap->length);
> +	ASSERT(xfs_extlen_to_rtxmod(mp, ap->length) == 0);
> +
> +	/*
> +	 * If we shifted the file offset downward to satisfy an extent size
> +	 * hint, increase minlen by that amount so that the allocator won't
> +	 * give us an allocation that's too short to cover at least one of the
> +	 * blocks that the caller asked for.
> +	 */
> +	if (ap->offset != orig_offset)
> +		minlen += orig_offset - ap->offset;
> +
> +	/*
> +	 * If the offset & length are not perfectly aligned
> +	 * then kill prod, it will just get us in trouble.
> +	 */
> +	div_u64_rem(ap->offset, align, &mod);
> +	if (mod || ap->length % align)
> +		prod = 1;
> +	/*
> +	 * Set ralen to be the actual requested length in rtextents.
> +	 *
> +	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
> +	 * we rounded up to it, cut it back so it's valid again.
> +	 * Note that if it's a really large request (bigger than
> +	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
> +	 * adjust the starting point to match it.
> +	 */
> +	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
> +
> +	/*
> +	 * Lock out modifications to both the RT bitmap and summary inodes
> +	 */
> +	if (!rtlocked) {
> +		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> +		xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> +		xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> +		rtlocked = true;
> +	}
> +
> +	/*
> +	 * If it's an allocation to an empty file at offset 0,
> +	 * pick an extent that will space things out in the rt area.
> +	 */
> +	if (ap->eof && ap->offset == 0) {
> +		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
> +		if (error)
> +			return error;
> +		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
> +	} else {
> +		ap->blkno = 0;
> +	}
> +
> +	xfs_bmap_adjacent(ap);
> +
> +	/*
> +	 * Realtime allocation, done through xfs_rtallocate_extent.
> +	 */
> +	if (ignore_locality)
> +		rtx = 0;
> +	else
> +		rtx = xfs_rtb_to_rtx(mp, ap->blkno);
> +	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
> +	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
> +			ap->wasdel, prod, &rtx);
> +	if (error)
> +		return error;
> +
> +	if (rtx != NULLRTEXTNO) {
> +		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
> +		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
> +		xfs_bmap_alloc_account(ap);
> +		return 0;
> +	}
> +
> +	if (align > mp->m_sb.sb_rextsize) {
> +		/*
> +		 * We previously enlarged the request length to try to satisfy
> +		 * an extent size hint.  The allocator didn't return anything,
> +		 * so reset the parameters to the original values and try again
> +		 * without alignment criteria.
> +		 */
> +		ap->offset = orig_offset;
> +		ap->length = orig_length;
> +		minlen = align = mp->m_sb.sb_rextsize;
> +		goto retry;
> +	}
> +
> +	if (!ignore_locality && ap->blkno != 0) {
> +		/*
> +		 * If we can't allocate near a specific rt extent, try again
> +		 * without locality criteria.
> +		 */
> +		ignore_locality = true;
> +		goto retry;
> +	}
> +
> +	ap->blkno = NULLFSBLOCK;
> +	ap->length = 0;
> +	return 0;
> +}
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index f7cb9ffe51ca68..a6836da9bebef5 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -12,27 +12,6 @@ struct xfs_mount;
>  struct xfs_trans;
>  
>  #ifdef CONFIG_XFS_RT
> -/*
> - * Function prototypes for exported functions.
> - */
> -
> -/*
> - * Allocate an extent in the realtime subvolume, with the usual allocation
> - * parameters.  The length units are all in realtime extents, as is the
> - * result block number.
> - */
> -int					/* error */
> -xfs_rtallocate_extent(
> -	struct xfs_trans	*tp,	/* transaction pointer */
> -	xfs_rtxnum_t		start,	/* starting rtext number to allocate */
> -	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
> -	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
> -	xfs_rtxlen_t		*len,	/* out: actual length allocated */
> -	int			wasdel,	/* was a delayed allocation extent */
> -	xfs_rtxlen_t		prod,	/* extent product factor */
> -	xfs_rtxnum_t		*rtblock); /* out: start rtext allocated */
> -
> -
>  /*
>   * Initialize realtime fields in the mount structure.
>   */
> @@ -51,20 +30,6 @@ int					/* error */
>  xfs_rtmount_inodes(
>  	struct xfs_mount	*mp);	/* file system mount structure */
>  
> -/*
> - * Pick an extent for allocation at the start of a new realtime file.
> - * Use the sequence number stored in the atime field of the bitmap inode.
> - * Translate this to a fraction of the rtextents, and return the product
> - * of rtextents and the fraction.
> - * The fraction sequence is 0, 1/2, 1/4, 3/4, 1/8, ..., 7/8, 1/16, ...
> - */
> -int					/* error */
> -xfs_rtpick_extent(
> -	struct xfs_mount	*mp,	/* file system mount point */
> -	struct xfs_trans	*tp,	/* transaction pointer */
> -	xfs_rtxlen_t		len,	/* allocation length (rtextents) */
> -	xfs_rtxnum_t		*pick);	/* result rt extent */
> -
>  /*
>   * Grow the realtime area of the filesystem.
>   */
> @@ -75,8 +40,6 @@ xfs_growfs_rt(
>  
>  int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
>  #else
> -# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
> -# define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
>  # define xfs_growfs_rt(mp,in)				(-ENOSYS)
>  # define xfs_rtalloc_reinit_frextents(m)		(0)
>  static inline int		/* error */
> -- 
> 2.39.2
> 
> 
