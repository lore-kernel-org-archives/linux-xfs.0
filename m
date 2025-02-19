Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CF1B87D3
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 22:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002432; cv=none; b=ThQPvGJBPtvqy7Bn1HskKkLGu5f3jgFHCm5mlxYcpD2KDyWU6MTUWr08ZvXLkKrwIpv4OJrglAOljSnNHTSdMKIo4a/87L5tMWlx057T1wpOYvcBi2M9XtiiI9bT3Dh9c4fIyF37O9kX/e0OiVv4dmVD0YzpcPd7nN2x4ugXq0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002432; c=relaxed/simple;
	bh=zDidpYIyWjmCNFH0QoilyQTYOu9+1xeY8u/Ul9PtmXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvBHkx2n918Y3UQGFLb36B49K6KrIa0lvoqvj1g0W2R2De05zGgnwRNuWe+T3QdjalFaBxH/0Zd7ajWK3uLoia18oOFp8pRkDau6rsSP6PnVq1Z0V94ngtoZyCERar4uzrK/mbrj2PtS5DxoFHWrCh2mNbNbnofs24qRlsOqq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHeFwT3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHeFwT3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34666C4CED1;
	Wed, 19 Feb 2025 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740002432;
	bh=zDidpYIyWjmCNFH0QoilyQTYOu9+1xeY8u/Ul9PtmXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fHeFwT3be/KeCuwF1PVs0EyUL7gckGueVaSPlRKmjlJrXoWUnu7RjvWQPAnNAxJaz
	 xAlqao1i7565VmbPr/d8CRWbTBdF3gNs6bh/b/gg8O2IT4tVCkIUtviCJgy8FWvLNp
	 YHGrvUDAyyu7blTgaCglb8f5J9wgJImPUPhq9ThEZzzRfe9Qn1Ad5uOfEuomWDVbxg
	 kryijCONoLV+ymgbvkCZtnzKIHzi3j1D7fR7OArFctQPgv++Q210pJIJIeJjt/VNjL
	 CiEietxEId/ThmzdGoV9oqej7I6aEiJypkMbunq3rLaVl+82OhQyWwICQIeEXTabQJ
	 gwTETDnFhEysA==
Date: Wed, 19 Feb 2025 14:00:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/45] xfs: add support for zoned space reservations
Message-ID: <20250219220031.GY21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-26-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-26-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:28AM +0100, Christoph Hellwig wrote:
> For zoned file systems garbage collection (GC) has to take the iolock
> and mmaplock after moving data to a new place to synchronize with
> readers.  This means waiting for garbage collection with the iolock can
> deadlock.
> 
> To avoid this, the worst case required blocks have to be reserved before
> taking the iolock, which is done using a new RTAVAILABLE counter that
> tracks blocks that are free to write into and don't require garbage
> collection.  The new helpers try to take these available blocks, and
> if there aren't enough available it wakes and waits for GC.  This is
> done using a list of on-stack reservations to ensure fairness.
> 
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/Makefile              |   3 +-
>  fs/xfs/libxfs/xfs_bmap.c     |  15 ++-
>  fs/xfs/libxfs/xfs_types.h    |  12 +-
>  fs/xfs/xfs_mount.c           |  36 +++---
>  fs/xfs/xfs_trace.h           |  23 ++++
>  fs/xfs/xfs_zone_alloc.c      |   2 +
>  fs/xfs/xfs_zone_alloc.h      |  27 ++++
>  fs/xfs/xfs_zone_priv.h       |   2 +
>  fs/xfs/xfs_zone_space_resv.c | 244 +++++++++++++++++++++++++++++++++++
>  9 files changed, 343 insertions(+), 21 deletions(-)
>  create mode 100644 fs/xfs/xfs_zone_space_resv.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 28bd2627e9ef..bdedf4bdb1db 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -138,7 +138,8 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  
>  # xfs_rtbitmap is shared with libxfs
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
> -				   xfs_zone_alloc.o
> +				   xfs_zone_alloc.o \
> +				   xfs_zone_space_resv.o
>  
>  xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
>  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 522c126e52fb..63255820b58a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -40,6 +40,7 @@
>  #include "xfs_symlink_remote.h"
>  #include "xfs_inode_util.h"
>  #include "xfs_rtgroup.h"
> +#include "xfs_zone_alloc.h"
>  
>  struct kmem_cache		*xfs_bmap_intent_cache;
>  
> @@ -4788,12 +4789,18 @@ xfs_bmap_del_extent_delay(
>  	da_diff = da_old - da_new;
>  	fdblocks = da_diff;
>  
> -	if (bflags & XFS_BMAPI_REMAP)
> +	if (bflags & XFS_BMAPI_REMAP) {
>  		;
> -	else if (isrt)
> -		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
> -	else
> +	} else if (isrt) {
> +		xfs_rtbxlen_t	rtxlen;
> +
> +		rtxlen = xfs_blen_to_rtbxlen(mp, del->br_blockcount);
> +		if (xfs_is_zoned_inode(ip))
> +			xfs_zoned_add_available(mp, rtxlen);
> +		xfs_add_frextents(mp, rtxlen);
> +	} else {
>  		fdblocks += del->br_blockcount;
> +	}
>  
>  	xfs_add_fdblocks(mp, fdblocks);
>  	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index dc1db15f0be5..f6f4f2d4b5db 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -244,12 +244,22 @@ enum xfs_free_counter {
>  	 */
>  	XC_FREE_RTEXTENTS,
>  
> +	/*
> +	 * Number of available for use RT extents.
> +	 *
> +	 * This counter only exists for zoned RT device and indicates the number
> +	 * of RT extents that can be directly used by writes.  XC_FREE_RTEXTENTS
> +	 * also includes blocks that have been written previously and freed, but
> +	 * sit in a rtgroup that still needs a zone reset.
> +	 */
> +	XC_FREE_RTAVAILABLE,
>  	XC_FREE_NR,
>  };
>  
>  #define XFS_FREECOUNTER_STR \
>  	{ XC_FREE_BLOCKS,		"blocks" }, \
> -	{ XC_FREE_RTEXTENTS,		"rtextents" }
> +	{ XC_FREE_RTEXTENTS,		"rtextents" }, \
> +	{ XC_FREE_RTAVAILABLE,		"rtavailable" }
>  
>  /*
>   * Type verifier functions
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 3edb9fc74640..a953383d691a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -468,6 +468,7 @@ xfs_mount_reset_sbqflags(
>  static const char *const xfs_free_pool_name[] = {
>  	[XC_FREE_BLOCKS]	= "free blocks",
>  	[XC_FREE_RTEXTENTS]	= "free rt extents",
> +	[XC_FREE_RTAVAILABLE]	= "available rt extents",
>  };
>  
>  uint64_t
> @@ -475,22 +476,27 @@ xfs_default_resblks(
>  	struct xfs_mount	*mp,
>  	enum xfs_free_counter	ctr)
>  {
> -	uint64_t resblks;
> -
> -	if (ctr == XC_FREE_RTEXTENTS)
> +	switch (ctr) {
> +	case XC_FREE_BLOCKS:
> +		/*
> +		 * Default to 5% or 8192 FSBs of space reserved, whichever is
> +		 * smaller.
> +		 *
> +		 * This is intended to cover concurrent allocation transactions
> +		 * when we initially hit ENOSPC.  These each require a 4 block
> +		 * reservation. Hence by default we cover roughly 2000
> +		 * concurrent allocation reservations.
> +		 */
> +		return min(div_u64(mp->m_sb.sb_dblocks, 20), 8192ULL);
> +	case XC_FREE_RTEXTENTS:
> +	case XC_FREE_RTAVAILABLE:
> +		if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp))
> +			return xfs_zoned_default_resblks(mp, ctr);
>  		return 0;
> -
> -	/*
> -	 * We default to 5% or 8192 fsbs of space reserved, whichever is
> -	 * smaller.  This is intended to cover concurrent allocation
> -	 * transactions when we initially hit enospc. These each require a 4
> -	 * block reservation. Hence by default we cover roughly 2000 concurrent
> -	 * allocation reservations.
> -	 */
> -	resblks = mp->m_sb.sb_dblocks;
> -	do_div(resblks, 20);
> -	resblks = min_t(uint64_t, resblks, 8192);
> -	return resblks;
> +	default:
> +		ASSERT(0);
> +		return 0;
> +	}
>  }
>  
>  /* Ensure the summary counts are correct. */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index bdafdedb9ff8..a4134fc1db4f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -363,6 +363,28 @@ DEFINE_EVENT(xfs_zone_alloc_class, name,			\
>  	TP_ARGS(oz, rgbno, len))
>  DEFINE_ZONE_ALLOC_EVENT(xfs_zone_record_blocks);
>  DEFINE_ZONE_ALLOC_EVENT(xfs_zone_alloc_blocks);
> +
> +TRACE_EVENT(xfs_zones_mount,
> +	TP_PROTO(struct xfs_mount *mp),
> +	TP_ARGS(mp),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_rgnumber_t, rgcount)
> +		__field(uint32_t, blocks)
> +		__field(unsigned int, max_open_zones)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->rgcount = mp->m_sb.sb_rgcount;
> +		__entry->blocks = mp->m_groups[XG_TYPE_RTG].blocks;
> +		__entry->max_open_zones = mp->m_max_open_zones;
> +	),
> +	TP_printk("dev %d:%d zoned %u blocks_per_zone %u, max_open %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		__entry->rgcount,
> +		__entry->blocks,
> +		__entry->max_open_zones)
> +);
>  #endif /* CONFIG_XFS_RT */
>  
>  TRACE_EVENT(xfs_inodegc_worker,
> @@ -5766,6 +5788,7 @@ TRACE_EVENT(xfs_growfs_check_rtgeom,
>  
>  TRACE_DEFINE_ENUM(XC_FREE_BLOCKS);
>  TRACE_DEFINE_ENUM(XC_FREE_RTEXTENTS);
> +TRACE_DEFINE_ENUM(XC_FREE_RTAVAILABLE);
>  
>  DECLARE_EVENT_CLASS(xfs_freeblocks_resv_class,
>  	TP_PROTO(struct xfs_mount *mp, enum xfs_free_counter ctr,
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 0e03b4d35979..4f433741f646 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -921,6 +921,7 @@ xfs_mount_zones(
>  	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
>  		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
>  		 mp->m_max_open_zones);
> +	trace_xfs_zones_mount(mp);
>  
>  	if (bdev_is_zoned(bt->bt_bdev)) {
>  		error = blkdev_report_zones(bt->bt_bdev,
> @@ -938,6 +939,7 @@ xfs_mount_zones(
>  		}
>  	}
>  
> +	xfs_set_freecounter(mp, XC_FREE_RTAVAILABLE, iz.available);
>  	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
>  			iz.available + iz.reclaimable);
>  	return 0;
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index 78cd7bfc6ac8..28c9cffb72d5 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -5,6 +5,30 @@
>  struct iomap_ioend;
>  struct xfs_open_zone;
>  
> +struct xfs_zone_alloc_ctx {
> +	struct xfs_open_zone	*open_zone;
> +	xfs_filblks_t		reserved_blocks;
> +};
> +
> +/*
> + * Grab any available space, even if it is less than what the caller asked for.
> + */
> +#define XFS_ZR_GREEDY		(1U << 0)
> +/*
> + * Only grab instantly available space, don't wait or GC.
> + */
> +#define XFS_ZR_NOWAIT		(1U << 1)
> +/*
> + * Dip into the reserved pool.
> + */
> +#define XFS_ZR_RESERVED		(1U << 2)
> +
> +int xfs_zoned_space_reserve(struct xfs_inode *ip, xfs_filblks_t count_fsb,
> +		unsigned int flags, struct xfs_zone_alloc_ctx *ac);
> +void xfs_zoned_space_unreserve(struct xfs_inode *ip,
> +		struct xfs_zone_alloc_ctx *ac);
> +void xfs_zoned_add_available(struct xfs_mount *mp, xfs_filblks_t count_fsb);
> +
>  void xfs_zone_alloc_and_submit(struct iomap_ioend *ioend,
>  		struct xfs_open_zone **oz);
>  int xfs_zone_free_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
> @@ -18,6 +42,9 @@ void xfs_zoned_wake_all(struct xfs_mount *mp);
>  bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
>  void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
>  
> +uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr);
> +
>  #ifdef CONFIG_XFS_RT
>  int xfs_mount_zones(struct xfs_mount *mp);
>  void xfs_unmount_zones(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index 23d2fd6088ae..5283d77482d4 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -86,4 +86,6 @@ struct xfs_zone_info {
>  
>  struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
>  
> +void xfs_zoned_resv_wake_all(struct xfs_mount *mp);
> +
>  #endif /* _XFS_ZONE_PRIV_H */
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> new file mode 100644
> index 000000000000..eff9be026425
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -0,0 +1,244 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2025 Christoph Hellwig.
> + * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
> + */
> +#include "xfs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_rtbitmap.h"
> +#include "xfs_zone_alloc.h"
> +#include "xfs_zone_priv.h"
> +#include "xfs_zones.h"
> +
> +/*
> + * Note: the zoned allocator does not support a rtextsize > 1, so this code and
> + * the allocator itself uses file system blocks interchangeable with realtime
> + * extents without doing the otherwise required conversions.
> + */
> +
> +/*
> + * Per-task space reservation.
> + *
> + * Tasks that need to wait for GC to free up space allocate one of these
> + * on-stack and adds it to the per-mount zi_reclaim_reservations lists.
> + * The GC thread will then wake the tasks in order when space becomes available.
> + */
> +struct xfs_zone_reservation {
> +	struct list_head	entry;
> +	struct task_struct	*task;
> +	xfs_filblks_t		count_fsb;
> +};
> +
> +/*
> + * Calculate the number of reserved blocks.
> + *
> + * XC_FREE_RTEXTENTS counts the user available capacity, to which the file
> + * system can be filled, while XC_FREE_RTAVAILABLE counts the blocks instantly
> + * available for writes without waiting for GC.
> + *
> + * For XC_FREE_RTAVAILABLE only the smaller reservation required for GC and
> + * block zeroing is excluded from the user capacity, while XC_FREE_RTEXTENTS
> + * is further restricted by at least one zone as well as the optional
> + * persistently reserved blocks.  This allows the allocator to run more
> + * smoothly by not always triggering GC.
> + */
> +uint64_t
> +xfs_zoned_default_resblks(
> +	struct xfs_mount	*mp,
> +	enum xfs_free_counter	ctr)
> +{
> +	switch (ctr) {
> +	case XC_FREE_RTEXTENTS:
> +		return (uint64_t)XFS_RESERVED_ZONES *
> +			mp->m_groups[XG_TYPE_RTG].blocks +
> +			mp->m_sb.sb_rtreserved;
> +	case XC_FREE_RTAVAILABLE:
> +		return (uint64_t)XFS_GC_ZONES *
> +			mp->m_groups[XG_TYPE_RTG].blocks;
> +	default:
> +		ASSERT(0);
> +		return 0;
> +	}
> +}
> +
> +void
> +xfs_zoned_resv_wake_all(
> +	struct xfs_mount		*mp)
> +{
> +	struct xfs_zone_info		*zi = mp->m_zone_info;
> +	struct xfs_zone_reservation	*reservation;
> +
> +	spin_lock(&zi->zi_reservation_lock);
> +	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry)
> +		wake_up_process(reservation->task);
> +	spin_unlock(&zi->zi_reservation_lock);
> +}
> +
> +void
> +xfs_zoned_add_available(
> +	struct xfs_mount		*mp,
> +	xfs_filblks_t			count_fsb)
> +{
> +	struct xfs_zone_info		*zi = mp->m_zone_info;
> +	struct xfs_zone_reservation	*reservation;
> +
> +	if (list_empty_careful(&zi->zi_reclaim_reservations)) {
> +		xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> +		return;
> +	}
> +
> +	spin_lock(&zi->zi_reservation_lock);
> +	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> +	count_fsb = xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE);
> +	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry) {
> +		if (reservation->count_fsb > count_fsb)
> +			break;
> +		wake_up_process(reservation->task);
> +		count_fsb -= reservation->count_fsb;
> +
> +	}
> +	spin_unlock(&zi->zi_reservation_lock);
> +}
> +
> +static int
> +xfs_zoned_space_wait_error(
> +	struct xfs_mount		*mp)
> +{
> +	if (xfs_is_shutdown(mp))
> +		return -EIO;
> +	if (fatal_signal_pending(current))
> +		return -EINTR;
> +	return 0;
> +}
> +
> +static int
> +xfs_zoned_reserve_available(
> +	struct xfs_inode		*ip,
> +	xfs_filblks_t			count_fsb,
> +	unsigned int			flags)
> +{
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_zone_info		*zi = mp->m_zone_info;
> +	struct xfs_zone_reservation	reservation = {
> +		.task		= current,
> +		.count_fsb	= count_fsb,
> +	};
> +	int				error;
> +
> +	/*
> +	 * If there are no waiters, try to directly grab the available blocks
> +	 * from the percpu counter.
> +	 *
> +	 * If the caller wants to dip into the reserved pool also bypass the
> +	 * wait list.  This relies on the fact that we have a very graciously
> +	 * sized reserved pool that always has enough space.  If the reserved
> +	 * allocations fail we're in trouble.
> +	 */
> +	if (likely(list_empty_careful(&zi->zi_reclaim_reservations) ||
> +	    (flags & XFS_ZR_RESERVED))) {
> +		error = xfs_dec_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb,
> +				flags & XFS_ZR_RESERVED);
> +		if (error != -ENOSPC)
> +			return error;
> +	}
> +
> +	if (flags & XFS_ZR_NOWAIT)
> +		return -EAGAIN;
> +
> +	spin_lock(&zi->zi_reservation_lock);
> +	list_add_tail(&reservation.entry, &zi->zi_reclaim_reservations);
> +	while ((error = xfs_zoned_space_wait_error(mp)) == 0) {
> +		set_current_state(TASK_KILLABLE);
> +
> +		error = xfs_dec_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb,
> +				flags & XFS_ZR_RESERVED);
> +		if (error != -ENOSPC)
> +			break;
> +
> +		spin_unlock(&zi->zi_reservation_lock);
> +		schedule();
> +		spin_lock(&zi->zi_reservation_lock);
> +	}
> +	list_del(&reservation.entry);
> +	spin_unlock(&zi->zi_reservation_lock);
> +
> +	__set_current_state(TASK_RUNNING);
> +	return error;
> +}
> +
> +/*
> + * Implement greedy space allocation for short writes by trying to grab all
> + * that is left after locking out other threads from trying to do the same.
> + *
> + * This isn't exactly optimal and can hopefully be replaced by a proper
> + * percpu_counter primitive one day.
> + */
> +static int
> +xfs_zoned_reserve_extents_greedy(
> +	struct xfs_inode		*ip,
> +	xfs_filblks_t			*count_fsb,
> +	unsigned int			flags)
> +{
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_zone_info		*zi = mp->m_zone_info;
> +	s64				len = *count_fsb;
> +	int				error = -ENOSPC;
> +
> +	spin_lock(&zi->zi_reservation_lock);
> +	len = min(len, xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
> +	if (len > 0) {
> +		*count_fsb = len;
> +		error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, *count_fsb,
> +				flags & XFS_ZR_RESERVED);
> +	}
> +	spin_unlock(&zi->zi_reservation_lock);
> +	return error;
> +}
> +
> +int
> +xfs_zoned_space_reserve(
> +	struct xfs_inode		*ip,
> +	xfs_filblks_t			count_fsb,
> +	unsigned int			flags,
> +	struct xfs_zone_alloc_ctx	*ac)
> +{
> +	struct xfs_mount		*mp = ip->i_mount;
> +	int				error;
> +
> +	ASSERT(ac->reserved_blocks == 0);
> +	ASSERT(ac->open_zone == NULL);
> +
> +	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
> +			flags & XFS_ZR_RESERVED);
> +	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
> +		error = xfs_zoned_reserve_extents_greedy(ip, &count_fsb, flags);
> +	if (error)
> +		return error;
> +
> +	error = xfs_zoned_reserve_available(ip, count_fsb, flags);
> +	if (error) {
> +		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb);
> +		return error;
> +	}
> +	ac->reserved_blocks = count_fsb;
> +	return 0;
> +}
> +
> +void
> +xfs_zoned_space_unreserve(
> +	struct xfs_inode		*ip,
> +	struct xfs_zone_alloc_ctx	*ac)
> +{
> +	if (ac->reserved_blocks > 0) {
> +		struct xfs_mount	*mp = ip->i_mount;
> +
> +		xfs_zoned_add_available(mp, ac->reserved_blocks);
> +		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, ac->reserved_blocks);
> +	}
> +	if (ac->open_zone)
> +		xfs_open_zone_put(ac->open_zone);
> +}
> -- 
> 2.45.2
> 
> 
