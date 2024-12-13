Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9828D19992C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734128332; cv=none; b=i0owchZWLgXIgAB9IQz+qqUTZrnD/F+n1DtjrhF2gf322GbI9UnNjB1YKmnREY6KnaPW56HF6zjQR9SunQeC+KSgoWvXKtN5CXhsys8it2SZNHwi9jBK8ogIztkEHKFdjHQlW60PI8Wvy5FQjYpdKbAujPAU2YZofMwe9Kymmt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734128332; c=relaxed/simple;
	bh=r+hB+dKjYXros+vwuGtT0fO6s+d5Vs9VDQHhts1U/3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SU1uTgij0MxGo7mzSPA6cvQFhfkMXvtElRo+SXT6E/7HBpkp+hY7WCW3JEmuKF6LgrecE5loe//ORH1VCjL012a25iRldLbFdURA6+jm195D7QceaTcrOjHyJ/jKasQqSG7u1qfa1h2zCdytk85K2sns+0kTBsXQJ02fcA1a/pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8h2WHXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8h2WHXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF3CC4CED4;
	Fri, 13 Dec 2024 22:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734128332;
	bh=r+hB+dKjYXros+vwuGtT0fO6s+d5Vs9VDQHhts1U/3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C8h2WHXYTj2pjZe3qjt+/OpDgrl6vZHIsJKt0MONPouIiaM846qan9tHRXhI/Qoac
	 9Dk0fjhOt0S29RRgNklTyuDtX8Vq4bGtSFLurjGNdeM0b0RQTZYKlaOlHmeEJNwB05
	 NuAfID46zk7t5icndQTD/aXZtUL9Un8XrkAu9k2/7Gu4bMe2PYCm6oYt7YjaJdQvQa
	 bBTqIYAG9gjipzpFeE9CG5TT/P2p/FsIwrPiJ5QEzW0qksJetbg06gEuTswYEcKN4E
	 nOsVEFe4I8qSAvqqZX+dqG/pvT0AZag2y89M+5wX98T57z32m16X9DIibzSHKRNPjO
	 7slXsgj7ndqtQ==
Date: Fri, 13 Dec 2024 14:18:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] xfs: implement zoned garbage collection
Message-ID: <20241213221851.GP6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-27-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:51AM +0100, Christoph Hellwig wrote:
> RT groups on a zoned file system need to be completely empty before their
> space can be reused.  This means that partially empty groups need to be
> emptied entirely to free up space if no entirely free groups are
> available.
> 
> Add a garbage collection thread that moves all data out of the least used
> zone when not enough free zones are available, and which resets all zones
> that have been emptied.  To empty zones, the rmap is walked to find the
> owners and the data is read and then written to the new place.
> 
> To automatically defragment files the rmap records are sorted by inode
> and logical offset.  This means defragmentation of parallel writes into
> a single zone happens automatically when performing garbage collection.
> Because holding the iolock over the entire GC cycle would inject very
> noticeable latency for other accesses to the inodes, the iolock is not
> taken while performing I/O.  Instead the I/O completion handler checks
> that the mapping hasn't changed over the one recorded at the start of
> the GC cycle and doesn't update the mapping if it change.
> 
> Note: selection of garbage collection victims is extremely simple at the
> moment and will probably see additional near term improvements.

Can we do the garbage collection from userspace?  I've had a freespace
defragmenter banging around in my dev tree for years:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace_2024-12-12

Which has the nice property that it knows how to query the refcount
btree to try to move the most heavily shared blocks first.  For zoned
that might not matter since we /must/ evacuate the whole zone.

Regardless, it could be nice to have a userspace process that we could
trigger from the kernel at some threshold (e.g. 70% space used) to see
if it can clean out some zones before the kernel one kicks in and slows
everyone down.

Anyway I'll keep going; that was just a thought I had.

> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile              |    1 +
>  fs/xfs/libxfs/xfs_group.h    |   15 +-
>  fs/xfs/xfs_extent_busy.c     |    2 +-
>  fs/xfs/xfs_mount.c           |    4 +
>  fs/xfs/xfs_mount.h           |    3 +
>  fs/xfs/xfs_super.c           |    7 +
>  fs/xfs/xfs_trace.h           |    4 +
>  fs/xfs/xfs_zone_alloc.c      |   52 +-
>  fs/xfs/xfs_zone_alloc.h      |    8 +
>  fs/xfs/xfs_zone_gc.c         | 1045 ++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_zone_priv.h       |    5 +
>  fs/xfs/xfs_zone_space_resv.c |    7 +
>  12 files changed, 1146 insertions(+), 7 deletions(-)
>  create mode 100644 fs/xfs/xfs_zone_gc.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index bdedf4bdb1db..e38838409271 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -139,6 +139,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  # xfs_rtbitmap is shared with libxfs
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
>  				   xfs_zone_alloc.o \
> +				   xfs_zone_gc.o \
>  				   xfs_zone_space_resv.o
>  
>  xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
> index a70096113384..430a43e1591e 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -19,10 +19,17 @@ struct xfs_group {
>  #ifdef __KERNEL__
>  	/* -- kernel only structures below this line -- */
>  
> -	/*
> -	 * Track freed but not yet committed extents.
> -	 */
> -	struct xfs_extent_busy_tree *xg_busy_extents;
> +	union {
> +		/*
> +		 * Track freed but not yet committed extents.
> +		 */
> +		struct xfs_extent_busy_tree	*xg_busy_extents;
> +
> +		/*
> +		 * List of groups that need a zone reset for zoned file systems.
> +		 */
> +		struct xfs_group		*xg_next_reset;
> +	};

Don't we need busy extents for zoned rtgroups?  I was under the
impression that the busy extents code prevents us from reallocating
recently freed space until the EFI (and hence the bunmapi) transaction
are persisted to the log so that new contents written after a
reallocation + write + fdatasync won't reappear in the old file?

>  	/*
>  	 * Bitsets of per-ag metadata that have been checked and/or are sick.
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ea43c9a6e54c..da3161572735 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -671,7 +671,7 @@ xfs_extent_busy_wait_all(
>  	while ((pag = xfs_perag_next(mp, pag)))
>  		xfs_extent_busy_wait_group(pag_group(pag));
>  
> -	if (xfs_has_rtgroups(mp))
> +	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp))
>  		while ((rtg = xfs_rtgroup_next(mp, rtg)))
>  			xfs_extent_busy_wait_group(rtg_group(rtg));
>  }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 70ecbbaba7fd..20d564b3b564 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1088,6 +1088,8 @@ xfs_mountfs(
>  		error = xfs_fs_reserve_ag_blocks(mp);
>  		if (error && error != -ENOSPC)
>  			goto out_agresv;
> +
> +		xfs_zone_gc_start(mp);
>  	}
>  
>  	return 0;
> @@ -1176,6 +1178,8 @@ xfs_unmountfs(
>  	xfs_inodegc_flush(mp);
>  
>  	xfs_blockgc_stop(mp);
> +	if (!test_bit(XFS_OPSTATE_READONLY, &mp->m_opstate))
> +		xfs_zone_gc_stop(mp);
>  	xfs_fs_unreserve_ag_blocks(mp);
>  	xfs_qm_unmount_quotas(mp);
>  	if (xfs_has_zoned(mp))
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 02a3609a3322..831d9e09fe72 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -548,6 +548,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_OPSTATE_RESUMING_QUOTAON	18
>  /* Kernel has logged a warning about zoned RT device being used on this fs. */
>  #define XFS_OPSTATE_WARNED_ZONED	19
> +/* (Zoned) GC is in progress */
> +#define XFS_OPSTATE_IN_GC		20
>  
>  #define __XFS_IS_OPSTATE(name, NAME) \
>  static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
> @@ -592,6 +594,7 @@ static inline bool xfs_clear_resuming_quotaon(struct xfs_mount *mp)
>  #endif /* CONFIG_XFS_QUOTA */
>  __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
>  __XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
> +__XFS_IS_OPSTATE(in_gc, IN_GC)

Nit: I might've called this ZONEGC_RUNNING.

	if (xfs_is_zonegc_running(mp))
		frob();

>  
>  static inline bool
>  xfs_should_warn(struct xfs_mount *mp, long nr)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d0b7e0d02366..b289b2ba78b1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -46,6 +46,7 @@
>  #include "xfs_exchmaps_item.h"
>  #include "xfs_parent.h"
>  #include "xfs_rtalloc.h"
> +#include "xfs_zone_alloc.h"
>  #include "scrub/stats.h"
>  #include "scrub/rcbag_btree.h"
>  
> @@ -1947,6 +1948,9 @@ xfs_remount_rw(
>  	/* Re-enable the background inode inactivation worker. */
>  	xfs_inodegc_start(mp);
>  
> +	/* Restart zone reclaim */
> +	xfs_zone_gc_start(mp);
> +
>  	return 0;
>  }
>  
> @@ -1991,6 +1995,9 @@ xfs_remount_ro(
>  	 */
>  	xfs_inodegc_stop(mp);
>  
> +	/* Stop zone reclaim */
> +	xfs_zone_gc_stop(mp);
> +
>  	/* Free the per-AG metadata reservation pool. */
>  	xfs_fs_unreserve_ag_blocks(mp);
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 763dd3d271b9..bbaf9b2665c7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -290,8 +290,12 @@ DECLARE_EVENT_CLASS(xfs_zone_class,
>  DEFINE_EVENT(xfs_zone_class, name,			\
>  	TP_PROTO(struct xfs_rtgroup *rtg),		\
>  	TP_ARGS(rtg))
> +DEFINE_ZONE_EVENT(xfs_zone_emptied);
>  DEFINE_ZONE_EVENT(xfs_zone_full);
>  DEFINE_ZONE_EVENT(xfs_zone_activate);
> +DEFINE_ZONE_EVENT(xfs_zone_reset);
> +DEFINE_ZONE_EVENT(xfs_zone_reclaim);
> +DEFINE_ZONE_EVENT(xfs_gc_zone_activate);
>  
>  TRACE_EVENT(xfs_zone_free_blocks,
>  	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 1a746e9cfbf4..291cf39a5989 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -34,11 +34,43 @@ xfs_open_zone_put(
>  	}
>  }
>  
> +static void
> +xfs_zone_emptied(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +
> +	trace_xfs_zone_emptied(rtg);
> +
> +	/*
> +	 * This can be called from log recovery, where the zone_info structure
> +	 * hasn't been allocated yet.  But we'll look for empty zones when
> +	 * setting it up, so don't need to track the empty zone here in that
> +	 * case.
> +	 */
> +	if (!zi)
> +		return;
> +
> +	xfs_group_clear_mark(&rtg->rtg_group, XFS_RTG_RECLAIMABLE);
> +
> +	spin_lock(&zi->zi_reset_list_lock);
> +	rtg_group(rtg)->xg_next_reset = zi->zi_reset_list;
> +	zi->zi_reset_list = rtg_group(rtg);
> +	spin_unlock(&zi->zi_reset_list_lock);
> +
> +	wake_up_process(zi->zi_gc_thread);
> +}
> +
>  static void
>  xfs_zone_mark_reclaimable(
>  	struct xfs_rtgroup	*rtg)
>  {
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
>  	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_RECLAIMABLE);
> +	if (xfs_zoned_need_gc(mp))
> +		wake_up_process(mp->m_zone_info->zi_gc_thread);
>  }
>  
>  static void
> @@ -278,9 +310,12 @@ xfs_zone_free_blocks(
>  	if (!READ_ONCE(rtg->rtg_open_zone)) {
>  		/*
>  		 * If the zone is not open, mark it reclaimable when the first
> -		 * block is freed.
> +		 * block is freed. As an optimization kick of a zone reset if

"...kick off a zone reset..."

> +		 * the usage counter hits zero.
>  		 */
> -		if (rmapip->i_used_blocks + len == rtg_blocks(rtg))
> +		if (rmapip->i_used_blocks == 0)
> +			xfs_zone_emptied(rtg);
> +		else if (rmapip->i_used_blocks + len == rtg_blocks(rtg))
>  			xfs_zone_mark_reclaimable(rtg);
>  	}
>  	xfs_add_frextents(mp, len);
> @@ -415,6 +450,8 @@ xfs_activate_zone(
>  	atomic_inc(&oz->oz_ref);
>  	zi->zi_nr_open_zones++;
>  	list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
> +	if (xfs_zoned_need_gc(mp))
> +		wake_up_process(zi->zi_gc_thread);
>  
>  	/* XXX: this is a little verbose, but let's keep it for now */
>  	xfs_info(mp, "using zone %u (%u)",
> @@ -747,6 +784,13 @@ xfs_init_zone(
>  		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
>  	}
>  
> +	if (write_pointer == rtg_blocks(rtg) && used == 0) {
> +		error = xfs_zone_reset_sync(rtg);
> +		if (error)
> +			return error;
> +		write_pointer = 0;
> +	}
> +
>  	if (write_pointer == 0) {
>  		/* zone is empty */
>  		atomic_inc(&zi->zi_nr_free_zones);
> @@ -954,6 +998,9 @@ xfs_mount_zones(
>  	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
>  		iz.available + iz.reclaimable);
>  
> +	error = xfs_zone_gc_mount(mp);
> +	if (error)
> +		goto out_free_open_zones;
>  	return 0;
>  
>  out_free_open_zones:
> @@ -966,6 +1013,7 @@ void
>  xfs_unmount_zones(
>  	struct xfs_mount	*mp)
>  {
> +	xfs_zone_gc_unmount(mp);
>  	xfs_free_open_zones(mp->m_zone_info);
>  	kfree(mp->m_zone_info);
>  }
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index 6d0404c2c46c..44fa1594f73e 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -38,6 +38,8 @@ uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
>  #ifdef CONFIG_XFS_RT
>  int xfs_mount_zones(struct xfs_mount *mp);
>  void xfs_unmount_zones(struct xfs_mount *mp);
> +void xfs_zone_gc_start(struct xfs_mount *mp);
> +void xfs_zone_gc_stop(struct xfs_mount *mp);
>  #else
>  static inline int xfs_mount_zones(struct xfs_mount *mp)
>  {
> @@ -46,6 +48,12 @@ static inline int xfs_mount_zones(struct xfs_mount *mp)
>  static inline void xfs_unmount_zones(struct xfs_mount *mp)
>  {
>  }
> +static inline void xfs_zone_gc_start(struct xfs_mount *mp)
> +{
> +}
> +static inline void xfs_zone_gc_stop(struct xfs_mount *mp)
> +{
> +}
>  #endif /* CONFIG_XFS_RT */
>  
>  #endif /* _XFS_ZONE_ALLOC_H */
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> new file mode 100644
> index 000000000000..085d7001935e
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -0,0 +1,1045 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2024 Christoph Hellwig.
> + * Copyright (c) 2024, Western Digital Corporation or its affiliates.
> + */
> +#include "xfs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_btree.h"
> +#include "xfs_trans.h"
> +#include "xfs_icache.h"
> +#include "xfs_rmap.h"
> +#include "xfs_rtbitmap.h"
> +#include "xfs_rtrmap_btree.h"
> +#include "xfs_zone_alloc.h"
> +#include "xfs_zone_priv.h"
> +#include "xfs_zones.h"
> +#include "xfs_trace.h"
> +
> +/*
> + * Size of each GC scratch pad.  This is also the upper bound for each
> + * GC I/O, which helps to keep latency down.
> + */
> +#define XFS_GC_CHUNK_SIZE	SZ_1M
> +
> +/*
> + * Scratchpad data to read GCed data into.
> + *
> + * The offset member tracks where the next allocation starts, and freed tracks
> + * the amount of space that is not used anymore.
> + */
> +#define XFS_ZONE_GC_NR_SCRATCH	2
> +struct xfs_zone_scratch {
> +	struct folio			*folio;
> +	unsigned int			offset;
> +	unsigned int			freed;
> +};
> +
> +/*
> + * Chunk that is read and written for each GC operation.
> + *
> + * Note that for writes to actual zoned devices, the chunk can be split when
> + * reaching the hardware limit.
> + */
> +struct xfs_gc_bio {
> +	struct xfs_zone_gc_data		*data;
> +
> +	/*
> +	 * Entry into the reading/writing/resetting list.  Only accessed from
> +	 * the GC thread, so no locking needed.
> +	 */
> +	struct list_head		entry;
> +
> +	/*
> +	 * State of this gc_bio.  Done means the current I/O completed.
> +	 * Set from the bio end I/O handler, read from the GC thread.
> +	 */
> +	unsigned long			state;
> +#define XFS_GC_BIO_NEW			0
> +#define XFS_GC_BIO_DONE			1

Are these bits, or a enum in disguise?

> +
> +	/*
> +	 * Pointer to the inode and range of the inode that the GC is performed
> +	 * for.
> +	 */
> +	struct xfs_inode		*ip;
> +	loff_t				offset;
> +	unsigned int			len;

Are offset/len in bytes?  It looks like they are.

> +	/*
> +	 * Existing startblock (in the zone to be freed) and newly assigned
> +	 * daddr in the zone GCed into.
> +	 */
> +	xfs_fsblock_t			old_startblock;
> +	xfs_daddr_t			new_daddr;
> +	struct xfs_zone_scratch		*scratch;
> +
> +	/* Are we writing to a sequential write required zone? */
> +	bool				is_seq;
> +
> +	/* Bio used for reads and writes, including the bvec used by it */
> +	struct bio_vec			bv;
> +	struct bio			bio;	/* must be last */
> +};
> +
> +/*
> + * Per-mount GC state.
> + */
> +struct xfs_zone_gc_data {
> +	struct xfs_mount		*mp;
> +
> +	/* bioset used to allocate the gc_bios */
> +	struct bio_set			bio_set;
> +
> +	/*
> +	 * Scratchpad used, and index to indicated which one is used.
> +	 */
> +	struct xfs_zone_scratch		scratch[XFS_ZONE_GC_NR_SCRATCH];
> +	unsigned int			scratch_idx;
> +
> +	/*
> +	 * List of bios currently being read, written and reset.
> +	 * These lists are only accessed by the GC thread itself, and must only
> +	 * be processed in order.
> +	 */
> +	struct list_head		reading;
> +	struct list_head		writing;
> +	struct list_head		resetting;
> +};
> +
> +/*
> + * We aim to keep enough zones free in stock to fully use the open zone limit
> + * for data placement purposes.
> + */
> +bool
> +xfs_zoned_need_gc(
> +	struct xfs_mount	*mp)
> +{
> +	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
> +		return false;
> +	if (xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE) <
> +	    mp->m_groups[XG_TYPE_RTG].blocks *
> +	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))

Is the righthand side of the comparison the number of blocks in the
zones that are open for userspace can write to?

> +		return true;
> +	return false;
> +}
> +
> +static struct xfs_zone_gc_data *
> +xfs_zone_gc_data_alloc(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_gc_data	*data;
> +	int i;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return NULL;
> +
> +	/*
> +	 * We actually only need a single bio_vec.  It would be nice to have
> +	 * a flag that only allocates the inline bvecs and not the separate
> +	 * bvec pool.
> +	 */
> +	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
> +			BIOSET_NEED_BVECS))
> +		goto out_free_data;
> +	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++) {
> +		data->scratch[i].folio =
> +			folio_alloc(GFP_KERNEL, get_order(XFS_GC_CHUNK_SIZE));
> +		if (!data->scratch[i].folio)
> +			goto out_free_scratch;
> +	}
> +	INIT_LIST_HEAD(&data->reading);
> +	INIT_LIST_HEAD(&data->writing);
> +	INIT_LIST_HEAD(&data->resetting);
> +	data->mp = mp;
> +	return data;
> +
> +out_free_scratch:
> +	while (--i >= 0)
> +		folio_put(data->scratch[i].folio);
> +	bioset_exit(&data->bio_set);
> +out_free_data:
> +	kfree(data);
> +	return NULL;
> +}
> +
> +static void
> +xfs_zone_gc_data_free(
> +	struct xfs_zone_gc_data	*data)
> +{
> +	int			i;
> +
> +	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++)
> +		folio_put(data->scratch[i].folio);
> +	bioset_exit(&data->bio_set);
> +	kfree(data);
> +}
> +
> +#define XFS_ZONE_GC_RECS		1024
> +
> +/* iterator, needs to be reinitialized for each victim zone */
> +struct xfs_zone_gc_iter {
> +	struct xfs_rtgroup		*victim_rtg;
> +	unsigned int			rec_count;
> +	unsigned int			rec_idx;
> +	xfs_agblock_t			next_startblock;
> +	struct xfs_rmap_irec		recs[XFS_ZONE_GC_RECS];
> +};

Hmm, each xfs_rmap_irec is 32 bytes, so this structure consumes a little
bit more than 32K of memory.  How about 1023 records to be nicer to the
slab allocator?

> +
> +static void
> +xfs_zone_gc_iter_init(
> +	struct xfs_zone_gc_iter	*iter,
> +	struct xfs_rtgroup	*victim_rtg)
> +
> +{
> +	iter->next_startblock = 0;
> +	iter->rec_count = 0;
> +	iter->rec_idx = 0;
> +	iter->victim_rtg = victim_rtg;
> +}
> +
> +static int
> +xfs_zone_gc_query_cb(

This function gathers rmaps for file blocks to evacuate, right?

> +	struct xfs_btree_cur	*cur,
> +	const struct xfs_rmap_irec *irec,
> +	void			*private)
> +{
> +	struct xfs_zone_gc_iter	*iter = private;
> +
> +	ASSERT(!XFS_RMAP_NON_INODE_OWNER(irec->rm_owner));
> +	ASSERT(!xfs_is_sb_inum(cur->bc_mp, irec->rm_owner));
> +	ASSERT(!(irec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)));

I wonder if you actually want to return EFSCORRUPTED for these?

> +	iter->recs[iter->rec_count] = *irec;
> +	if (++iter->rec_count == XFS_ZONE_GC_RECS) {
> +		iter->next_startblock =
> +			irec->rm_startblock + irec->rm_blockcount;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static int
> +xfs_zone_gc_rmap_rec_cmp(
> +	const void			*a,
> +	const void			*b)
> +{
> +	const struct xfs_rmap_irec	*reca = a;
> +	const struct xfs_rmap_irec	*recb = b;
> +	int64_t				diff;
> +
> +	diff = reca->rm_owner - recb->rm_owner;
> +	if (!diff)
> +		diff = reca->rm_offset - recb->rm_offset;
> +	return clamp(diff, -1, 1);
> +}

A silly trick I learned from Kent is that this avoids problems with
unsigned comparisons and other weird C behavior:

#define cmp_int(l, r)            ((l > r) - (l < r))

and then this becomes:

	int diff = cmp_int(reca->rm_owner, recb->rm_owner);
	if (!diff)
		diff = cmp_int(reca->rm_offset, recb->rm_offset);
	return diff;

> +
> +static int
> +xfs_zone_gc_query(
> +	struct xfs_mount	*mp,
> +	struct xfs_zone_gc_iter	*iter)
> +{
> +	struct xfs_rtgroup	*rtg = iter->victim_rtg;
> +	struct xfs_rmap_irec	ri_low = { };
> +	struct xfs_rmap_irec	ri_high;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	ASSERT(iter->next_startblock <= rtg_blocks(rtg));
> +	if (iter->next_startblock == rtg_blocks(rtg))
> +		goto done;
> +
> +	ASSERT(iter->next_startblock < rtg_blocks(rtg));
> +	ri_low.rm_startblock = iter->next_startblock;
> +	memset(&ri_high, 0xFF, sizeof(ri_high));
> +
> +	iter->rec_idx = 0;
> +	iter->rec_count = 0;
> +
> +	error = xfs_trans_alloc_empty(mp, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);

Why join the rtrmap inode when this is an empty transaction?

> +	cur = xfs_rtrmapbt_init_cursor(tp, rtg);
> +	error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
> +			xfs_zone_gc_query_cb, iter);
> +	xfs_btree_del_cursor(cur, error < 0 ? error : 0);
> +	xfs_trans_cancel(tp);
> +
> +	if (error < 0)
> +		return error;
> +
> +	/*
> +	 * Sort the rmap records by inode number and increasing offset to
> +	 * defragment the mappings.
> +	 *
> +	 * This could be further enhanced by an even bigger look ahead window,
> +	 * but that's better left until we have better detection of changes to
> +	 * inode mapping to avoid the potential of GCing already dead data.
> +	 */
> +	sort(iter->recs, iter->rec_count, sizeof(iter->recs[0]),
> +		xfs_zone_gc_rmap_rec_cmp, NULL);

Indenting here  ^

> +
> +	if (error == 0) {
> +		/*
> +		 * We finished iterating through the zone.
> +		 */
> +		iter->next_startblock = rtg_blocks(rtg);
> +		if (iter->rec_count == 0)
> +			goto done;
> +	}
> +
> +	return 0;
> +done:
> +	xfs_rtgroup_rele(iter->victim_rtg);
> +	iter->victim_rtg = NULL;
> +	return 0;
> +}
> +
> +static bool
> +xfs_zone_gc_iter_next(
> +	struct xfs_mount	*mp,
> +	struct xfs_zone_gc_iter	*iter,
> +	struct xfs_rmap_irec	*chunk_rec,
> +	struct xfs_inode	**ipp)
> +{
> +	struct xfs_rmap_irec	*irec;
> +	int			error;
> +
> +	if (!iter->victim_rtg)
> +		return false;
> +
> +retry:
> +	if (iter->rec_idx == iter->rec_count) {
> +		error = xfs_zone_gc_query(mp, iter);
> +		if (error)
> +			goto fail;
> +		if (!iter->victim_rtg)
> +			return false;
> +	}
> +
> +	irec = &iter->recs[iter->rec_idx];
> +	error = xfs_iget(mp, NULL, irec->rm_owner,
> +			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, ipp);
> +	if (error) {
> +		/*
> +		 * If the inode was already deleted, skip over it.
> +		 */
> +		if (error == -ENOENT) {
> +			iter->rec_idx++;
> +			goto retry;
> +		}
> +		goto fail;
> +	}
> +
> +	if (!S_ISREG(VFS_I(*ipp)->i_mode)) {

if (!S_ISREG() || !XFS_IS_REALTIME_INODE(ip)) ?

> +		iter->rec_idx++;
> +		xfs_irele(*ipp);
> +		goto retry;
> +	}
> +
> +	*chunk_rec = *irec;
> +	return true;
> +
> +fail:
> +	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +	return false;
> +}
> +
> +static void
> +xfs_zone_gc_iter_advance(
> +	struct xfs_zone_gc_iter	*iter,
> +	xfs_extlen_t		count_fsb)
> +{
> +	struct xfs_rmap_irec	*irec = &iter->recs[iter->rec_idx];
> +
> +	irec->rm_offset += count_fsb;
> +	irec->rm_startblock += count_fsb;
> +	irec->rm_blockcount -= count_fsb;
> +	if (!irec->rm_blockcount)
> +		iter->rec_idx++;
> +}
> +
> +/*
> + * Iterate through all zones marked as reclaimable and find a candidate that is
> + * either good enough for instant reclaim, or the one with the least used space.

What is instant reclaim?  Is there a non-instant(aneous) reclaim?
Are we biasing towards reclaiming zones with fewer blocks to evacuate?

> + */
> +static bool
> +xfs_zone_reclaim_pick(
> +	struct xfs_mount	*mp,
> +	struct xfs_zone_gc_iter	*iter)
> +{
> +	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
> +	struct xfs_rtgroup	*victim_rtg = NULL, *rtg;
> +	uint32_t		victim_used = U32_MAX;
> +	bool			easy = false;
> +
> +	if (xfs_is_shutdown(mp))
> +		return false;
> +
> +	if (iter->victim_rtg)
> +		return true;
> +
> +	/*
> +	 * Don't start new work if we are asked to stop or park.
> +	 */
> +	if (kthread_should_stop() || kthread_should_park())
> +		return false;
> +
> +	if (!xfs_zoned_need_gc(mp))
> +		return false;
> +
> +	rcu_read_lock();
> +	xas_for_each_marked(&xas, rtg, ULONG_MAX, XFS_RTG_RECLAIMABLE) {
> +		u64 used = rtg_rmap(rtg)->i_used_blocks;
> +
> +		/* skip zones that are just waiting for a reset */
> +		if (used == 0)
> +			continue;
> +
> +		if (used >= victim_used)
> +			continue;
> +		if (!atomic_inc_not_zero(&rtg->rtg_group.xg_active_ref))
> +			continue;
> +
> +		if (victim_rtg)
> +			xfs_rtgroup_rele(victim_rtg);
> +		victim_rtg = rtg;
> +		victim_used = used;
> +
> +		/*
> +		 * Any zone that is less than 1 percent used is fair game for
> +		 * instant reclaim.
> +		 */
> +		if (used < div_u64(rtg_blocks(rtg), 100)) {
> +			easy = true;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	if (!victim_rtg)
> +		return false;
> +
> +	xfs_info(mp, "reclaiming zone %d, used = %u/%u (%s)",
> +		rtg_rgno(victim_rtg), victim_used,
> +		rtg_blocks(victim_rtg),
> +		easy ? "easy" : "best");
> +	trace_xfs_zone_reclaim(victim_rtg);
> +	xfs_zone_gc_iter_init(iter, victim_rtg);
> +	return true;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_steal_open_zone_for_gc(
> +	struct xfs_zone_info	*zi)
> +{
> +	struct xfs_open_zone	*oz, *found = NULL;
> +
> +	lockdep_assert_held(&zi->zi_zone_list_lock);
> +
> +	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry) {
> +		if (!found ||
> +		    oz->oz_write_pointer < found->oz_write_pointer)
> +			found = oz;
> +	}
> +
> +	if (found) {
> +		found->oz_is_gc = true;
> +		list_del_init(&found->oz_entry);
> +		zi->zi_nr_open_zones--;
> +	}
> +	return found;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_select_gc_zone(

For what purpose are we selecting a gc zone?  I guess this is the zone
that we're evacuating blocks *into*?  As opposed to choosing a zone to
evacuate, which I think is what xfs_zone_reclaim_pick does?

(This could use a short comment for readers to perform their own grok
checking.)

> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
> +
> +	if (oz && oz->oz_write_pointer == rtg_blocks(oz->oz_rtg)) {
> +		/*
> +		 * We need to wait for pending writes to finish.
> +		 */
> +		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
> +			return NULL;
> +		xfs_open_zone_put(oz);
> +		oz = NULL;
> +	}
> +
> +	if (!oz) {
> +		/*
> +		 * If there are no free zones available for GC, pick the open
> +		 * zone with the least used space to GC into.  This should
> +		 * only happen after an unclean shutdown near ENOSPC while
> +		 * GC was ongoing.
> +		 */
> +		spin_lock(&zi->zi_zone_list_lock);
> +		if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE))
> +			oz = xfs_steal_open_zone_for_gc(zi);
> +		else
> +			oz = xfs_open_zone(mp, true);
> +		spin_unlock(&zi->zi_zone_list_lock);
> +
> +		if (oz)
> +			trace_xfs_gc_zone_activate(oz->oz_rtg);
> +		zi->zi_open_gc_zone = oz;
> +	}
> +
> +	return oz;
> +}
> +
> +static unsigned int
> +xfs_zone_gc_scratch_available(
> +	struct xfs_zone_gc_data	*data)
> +{
> +	return XFS_GC_CHUNK_SIZE - data->scratch[data->scratch_idx].offset;
> +}
> +
> +static bool
> +xfs_zone_gc_space_available(
> +	struct xfs_zone_gc_data	*data)
> +{
> +	struct xfs_open_zone	*oz;
> +
> +	oz = xfs_select_gc_zone(data->mp);
> +	if (!oz)
> +		return false;
> +	return oz->oz_write_pointer < rtg_blocks(oz->oz_rtg) &&
> +		xfs_zone_gc_scratch_available(data);
> +}
> +
> +static void
> +xfs_zone_gc_end_io(
> +	struct bio		*bio)
> +{
> +	struct xfs_gc_bio	*chunk =
> +		container_of(bio, struct xfs_gc_bio, bio);
> +	struct xfs_zone_gc_data	*data = chunk->data;
> +
> +	WRITE_ONCE(chunk->state, XFS_GC_BIO_DONE);
> +	wake_up_process(data->mp->m_zone_info->zi_gc_thread);
> +}
> +
> +static bool
> +xfs_zone_gc_allocate(

What are allocating here?  The @data and the xfs_open_zone already
exist, right?  AFAICT we're really just picking a zone to evacuate into,
and then returning the daddr/rtbcount so the caller can allocate a bio,
right?

> +	struct xfs_zone_gc_data	*data,
> +	xfs_extlen_t		*count_fsb,
> +	xfs_daddr_t		*daddr,
> +	bool			*is_seq)
> +{
> +	struct xfs_mount	*mp = data->mp;
> +	struct xfs_open_zone	*oz;
> +
> +	oz = xfs_select_gc_zone(mp);
> +	if (!oz)
> +		return false;
> +
> +	*count_fsb = min(*count_fsb,
> +		XFS_B_TO_FSB(mp, xfs_zone_gc_scratch_available(data)));
> +
> +	/*
> +	 * Directly allocate GC blocks from the reserved pool.
> +	 *
> +	 * If we'd take them from the normal pool we could be stealing blocks a
> +	 * regular writer, which would then have to wait for GC and deadlock.

"...stealing blocks from a regular writer..." ?

> +	 */
> +	spin_lock(&mp->m_sb_lock);
> +	*count_fsb = min(*count_fsb,
> +			rtg_blocks(oz->oz_rtg) - oz->oz_write_pointer);
> +	*count_fsb = min3(*count_fsb,
> +			mp->m_resblks[XC_FREE_RTEXTENTS].avail,
> +			mp->m_resblks[XC_FREE_RTAVAILABLE].avail);
> +	mp->m_resblks[XC_FREE_RTEXTENTS].avail -= *count_fsb;
> +	mp->m_resblks[XC_FREE_RTAVAILABLE].avail -= *count_fsb;
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	if (!*count_fsb)
> +		return false;
> +
> +	*daddr = xfs_gbno_to_daddr(&oz->oz_rtg->rtg_group, 0);
> +	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
> +	if (!*is_seq)
> +		*daddr += XFS_FSB_TO_BB(mp, oz->oz_write_pointer);
> +	oz->oz_write_pointer += *count_fsb;
> +	return true;
> +}
> +
> +static bool
> +xfs_zone_gc_start_chunk(
> +	struct xfs_zone_gc_data	*data,
> +	struct xfs_zone_gc_iter	*iter)
> +{
> +	struct xfs_mount	*mp = data->mp;
> +	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
> +	struct xfs_rmap_irec	irec;
> +	struct xfs_gc_bio	*chunk;
> +	struct xfs_inode	*ip;
> +	struct bio		*bio;
> +	xfs_daddr_t		daddr;
> +	bool			is_seq;
> +
> +	if (xfs_is_shutdown(mp))
> +		return false;
> +
> +	if (!xfs_zone_gc_iter_next(mp, iter, &irec, &ip))
> +		return false;
> +	if (!xfs_zone_gc_allocate(data, &irec.rm_blockcount, &daddr, &is_seq)) {
> +		xfs_irele(ip);
> +		return false;
> +	}
> +
> +	bio = bio_alloc_bioset(bdev, 1, REQ_OP_READ, GFP_NOFS, &data->bio_set);
> +
> +	chunk = container_of(bio, struct xfs_gc_bio, bio);
> +	chunk->ip = ip;
> +	chunk->offset = XFS_FSB_TO_B(mp, irec.rm_offset);
> +	chunk->len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
> +	chunk->old_startblock =
> +		xfs_rgbno_to_rtb(iter->victim_rtg, irec.rm_startblock);
> +	chunk->new_daddr = daddr;
> +	chunk->is_seq = is_seq;
> +	chunk->scratch = &data->scratch[data->scratch_idx];
> +	chunk->data = data;
> +
> +	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
> +	bio->bi_end_io = xfs_zone_gc_end_io;
> +	bio_add_folio_nofail(bio, chunk->scratch->folio, chunk->len,
> +			chunk->scratch->offset);
> +	chunk->scratch->offset += chunk->len;
> +	if (chunk->scratch->offset == XFS_GC_CHUNK_SIZE) {
> +		data->scratch_idx =
> +			(data->scratch_idx + 1) % XFS_ZONE_GC_NR_SCRATCH;
> +	}
> +	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
> +	list_add_tail(&chunk->entry, &data->reading);
> +	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
> +
> +	submit_bio(bio);
> +	return true;
> +}
> +
> +static void
> +xfs_zone_gc_free_chunk(
> +	struct xfs_gc_bio	*chunk)
> +{
> +	list_del(&chunk->entry);
> +	xfs_irele(chunk->ip);
> +	bio_put(&chunk->bio);
> +}
> +
> +static void
> +xfs_gc_submit_write(
> +	struct xfs_zone_gc_data	*data,
> +	struct xfs_gc_bio	*chunk)
> +{
> +	if (chunk->is_seq) {
> +		chunk->bio.bi_opf &= ~REQ_OP_WRITE;
> +		chunk->bio.bi_opf |= REQ_OP_ZONE_APPEND;
> +	}
> +	chunk->bio.bi_iter.bi_sector = chunk->new_daddr;
> +	chunk->bio.bi_end_io = xfs_zone_gc_end_io;
> +	submit_bio(&chunk->bio);
> +}
> +
> +static struct xfs_gc_bio *
> +xfs_gc_split_write(
> +	struct xfs_zone_gc_data	*data,
> +	struct xfs_gc_bio	*chunk)
> +{
> +	struct queue_limits	*lim =
> +		&bdev_get_queue(chunk->bio.bi_bdev)->limits;
> +	struct xfs_gc_bio	*split_chunk;
> +	int			split_sectors;
> +	unsigned int		split_len;
> +	struct bio		*split;
> +	unsigned int		nsegs;
> +
> +	if (!chunk->is_seq)
> +		return NULL;
> +
> +	split_sectors = bio_split_rw_at(&chunk->bio, lim, &nsegs,
> +			lim->max_zone_append_sectors << SECTOR_SHIFT);
> +	if (!split_sectors)
> +		return NULL;
> +	split_len = split_sectors << SECTOR_SHIFT;
> +
> +	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS, &data->bio_set);
> +	split_chunk = container_of(split, struct xfs_gc_bio, bio);
> +	split_chunk->data = data;
> +	ihold(VFS_I(chunk->ip));
> +	split_chunk->ip = chunk->ip;
> +	split_chunk->is_seq = chunk->is_seq;
> +	split_chunk->scratch = chunk->scratch;
> +	split_chunk->offset = chunk->offset;
> +	split_chunk->len = split_len;
> +	split_chunk->old_startblock = chunk->old_startblock;
> +	split_chunk->new_daddr = chunk->new_daddr;
> +
> +	chunk->offset += split_len;
> +	chunk->len -= split_len;
> +	chunk->old_startblock += XFS_B_TO_FSB(data->mp, split_len);
> +
> +	/* add right before the original chunk */
> +	WRITE_ONCE(split_chunk->state, XFS_GC_BIO_NEW);
> +	list_add_tail(&split_chunk->entry, &chunk->entry);
> +	return split_chunk;
> +}
> +
> +static void
> +xfs_zone_gc_write_chunk(
> +	struct xfs_gc_bio	*chunk)
> +{
> +	struct xfs_zone_gc_data	*data = chunk->data;
> +	struct xfs_mount	*mp = chunk->ip->i_mount;
> +	unsigned int		folio_offset = chunk->bio.bi_io_vec->bv_offset;
> +	struct xfs_gc_bio	*split_chunk;
> +
> +	if (chunk->bio.bi_status)
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);

Media errors happen, is there a gentler way to handle a read error
besides shutting down the fs?  We /do/ have all that infrastructure for
retrying IOs.

> +	if (xfs_is_shutdown(mp)) {
> +		xfs_zone_gc_free_chunk(chunk);
> +		return;
> +	}
> +
> +	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
> +	list_move_tail(&chunk->entry, &data->writing);
> +
> +	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> +	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> +			folio_offset);
> +
> +	while ((split_chunk = xfs_gc_split_write(data, chunk)))
> +		xfs_gc_submit_write(data, split_chunk);
> +	xfs_gc_submit_write(data, chunk);
> +}
> +
> +static void
> +xfs_zone_gc_finish_chunk(
> +	struct xfs_gc_bio	*chunk)
> +{
> +	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> +	struct xfs_inode	*ip = chunk->ip;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
> +
> +	if (chunk->bio.bi_status)
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);

Can we pick a different zone and try again?

> +	if (xfs_is_shutdown(mp)) {
> +		xfs_zone_gc_free_chunk(chunk);
> +		return;
> +	}
> +
> +	chunk->scratch->freed += chunk->len;
> +	if (chunk->scratch->freed == chunk->scratch->offset) {
> +		chunk->scratch->offset = 0;
> +		chunk->scratch->freed = 0;
> +	}
> +
> +	/*
> +	 * Cycle through the iolock and wait for direct I/O and layouts to
> +	 * ensure no one is reading from the old mapping before it goes away.
> +	 */
> +	xfs_ilock(ip, iolock);
> +	error = xfs_break_layouts(VFS_I(ip), &iolock, BREAK_UNMAP);
> +	if (!error)
> +		inode_dio_wait(VFS_I(ip));
> +	xfs_iunlock(ip, iolock);

But we drop the io/mmaplocks, which means someone can wander in and
change the file before we get to xfs_zoned_end_io.  Is that a problem?

> +	if (error)
> +		goto free;
> +
> +	if (chunk->is_seq)
> +		chunk->new_daddr = chunk->bio.bi_iter.bi_sector;
> +	error = xfs_zoned_end_io(ip, chunk->offset, chunk->len,
> +			chunk->new_daddr, chunk->old_startblock);
> +free:
> +	if (error)
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +	xfs_zone_gc_free_chunk(chunk);
> +}
> +
> +static void
> +xfs_zone_gc_finish_reset(
> +	struct xfs_gc_bio	*chunk)
> +{
> +	struct xfs_rtgroup	*rtg = chunk->bio.bi_private;
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +
> +	if (chunk->bio.bi_status) {
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		goto out;
> +	}
> +
> +	spin_lock(&zi->zi_zone_list_lock);
> +	atomic_inc(&zi->zi_nr_free_zones);
> +	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
> +	spin_unlock(&zi->zi_zone_list_lock);
> +
> +	xfs_zoned_add_available(mp, rtg_blocks(rtg));
> +
> +	wake_up_all(&zi->zi_zone_wait);
> +out:
> +	list_del(&chunk->entry);
> +	bio_put(&chunk->bio);
> +}
> +
> +static bool
> +xfs_prepare_zone_reset(
> +	struct bio		*bio,
> +	struct xfs_rtgroup	*rtg)
> +{
> +	trace_xfs_zone_reset(rtg);
> +
> +	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
> +	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
> +	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
> +		if (!bdev_max_discard_sectors(bio->bi_bdev))
> +			return false;
> +		bio->bi_opf = REQ_OP_DISCARD | REQ_SYNC;
> +		bio->bi_iter.bi_size =
> +			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
> +	}
> +
> +	return true;
> +}
> +
> +int
> +xfs_zone_reset_sync(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	int			error = 0;
> +	struct bio		bio;
> +
> +	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
> +			REQ_OP_ZONE_RESET);
> +	if (xfs_prepare_zone_reset(&bio, rtg))
> +		error = submit_bio_wait(&bio);
> +	bio_uninit(&bio);
> +
> +	return error;
> +}

The only caller of this is in xfs_zone_alloc, maybe it belongs there?

TBH I sorta expected all the functions in here to be xfs_zonegc_XXX.

> +static void
> +xfs_reset_zones(
> +	struct xfs_zone_gc_data	*data,
> +	struct xfs_group	*reset_list)
> +{
> +	struct xfs_group	*next = reset_list;
> +
> +	if (blkdev_issue_flush(data->mp->m_rtdev_targp->bt_bdev) < 0) {
> +		xfs_force_shutdown(data->mp, SHUTDOWN_META_IO_ERROR);
> +		return;
> +	}
> +
> +	do {
> +		struct xfs_rtgroup	*rtg = to_rtg(next);
> +		struct xfs_gc_bio	*chunk;
> +		struct bio		*bio;
> +
> +		xfs_log_force_inode(rtg_rmap(rtg));
> +
> +		next = rtg_group(rtg)->xg_next_reset;
> +		rtg_group(rtg)->xg_next_reset = NULL;
> +
> +		bio = bio_alloc_bioset(rtg_mount(rtg)->m_rtdev_targp->bt_bdev,
> +				0, REQ_OP_ZONE_RESET, GFP_NOFS, &data->bio_set);
> +		bio->bi_private = rtg;
> +		bio->bi_end_io = xfs_zone_gc_end_io;
> +
> +		chunk = container_of(bio, struct xfs_gc_bio, bio);
> +		chunk->data = data;
> +		WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
> +		list_add_tail(&chunk->entry, &data->resetting);
> +	

   ^^^^^ weird indentation here

> +		/*
> +		 * Also use the bio to drive the state machine when neither
> +		 * zone reset nor discard is supported to keep things simple.
> +		 */
> +		if (xfs_prepare_zone_reset(bio, rtg))
> +			submit_bio(bio);
> +		else
> +			bio_endio(bio);
> +	} while (next);
> +}
> +
> +/*
> + * Handle the work to read and write data for GC and to reset the zones,
> + * including handling all completions.
> + *
> + * Note that the order of the chunks is preserved so that we don't undo the
> + * optimal order established by xfs_zone_gc_query().
> + */
> +static bool
> +xfs_zone_gc_handle_work(
> +	struct xfs_zone_gc_data	*data,
> +	struct xfs_zone_gc_iter	*iter)
> +{
> +	struct xfs_zone_info	*zi = data->mp->m_zone_info;
> +	struct xfs_gc_bio	*chunk, *next;
> +	struct xfs_group	*reset_list;
> +	struct blk_plug		plug;
> +
> +	spin_lock(&zi->zi_reset_list_lock);
> +	reset_list = zi->zi_reset_list;
> +	zi->zi_reset_list = NULL;
> +	spin_unlock(&zi->zi_reset_list_lock);
> +
> +	if (!xfs_zone_reclaim_pick(data->mp, iter) ||
> +	    !xfs_zone_gc_space_available(data)) {
> +		if (list_empty(&data->reading) &&
> +		    list_empty(&data->writing) &&
> +		    list_empty(&data->resetting) &&
> +		    !reset_list)
> +			return false;
> +	}
> +
> +	__set_current_state(TASK_RUNNING);
> +	try_to_freeze();
> +
> +	if (reset_list)
> +		xfs_reset_zones(data, reset_list);
> +
> +	list_for_each_entry_safe(chunk, next, &data->resetting, entry) {
> +		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
> +			break;
> +		xfs_zone_gc_finish_reset(chunk);
> +	}
> +
> +	list_for_each_entry_safe(chunk, next, &data->writing, entry) {
> +		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
> +			break;
> +		xfs_zone_gc_finish_chunk(chunk);
> +	}
> +
> +	blk_start_plug(&plug);
> +	list_for_each_entry_safe(chunk, next, &data->reading, entry) {
> +		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
> +			break;
> +		xfs_zone_gc_write_chunk(chunk);
> +	}
> +	blk_finish_plug(&plug);
> +
> +	blk_start_plug(&plug);
> +	while (xfs_zone_gc_start_chunk(data, iter))
> +		;
> +	blk_finish_plug(&plug);
> +	return true;

For us clueless dolts, it would be useful to have a comment somewhere
explaining the high level operation of the garbage collector -- it picks
a non-empty zone to empty and a not-full zone to write into, queries the
rmap to find all the space mappings, initiates a read of the disk
contents, writes (or zone appends) the data to the new zone, then remaps
the space in the file.  When the zone becomes empty, it is reset.

> +}
> +
> +/*
> + * Note that the current GC algorithm would break reflinks and thus duplicate
> + * data that was shared by multiple owners before.  Because of that reflinks
> + * are currently not supported on zoned file systems and can't be created or
> + * mounted.
> + */
> +static int
> +xfs_zoned_gcd(
> +	void			*private)
> +{
> +	struct xfs_mount	*mp = private;
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	unsigned int		nofs_flag;
> +	struct xfs_zone_gc_data	*data;
> +	struct xfs_zone_gc_iter	*iter;
> +
> +	data = xfs_zone_gc_data_alloc(mp);
> +	if (!data)
> +		return -ENOMEM;

If we return ENOMEM here, who gets the return value from the thread
function?  I thought it was kthread_stop, and kthread_create only
returns errors encountered while setting up the thread?

> +	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> +	if (!iter)
> +		goto out_free_data;
> +
> +	nofs_flag = memalloc_nofs_save();
> +	set_freezable();
> +
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
> +		xfs_set_in_gc(mp);
> +		if (xfs_zone_gc_handle_work(data, iter))
> +			continue;
> +
> +		if (list_empty(&data->reading) &&
> +		    list_empty(&data->writing) &&
> +		    list_empty(&data->resetting) &&
> +		    !zi->zi_reset_list) {
> +			xfs_clear_in_gc(mp);
> +			xfs_zoned_resv_wake_all(mp);
> +
> +			if (kthread_should_stop()) {
> +				__set_current_state(TASK_RUNNING);
> +				break;
> +			}
> +
> +			if (kthread_should_park()) {
> +				__set_current_state(TASK_RUNNING);
> +				kthread_parkme();
> +				continue;
> +			}
> +		}
> +
> +		schedule();
> +	}
> +	xfs_clear_in_gc(mp);
> +
> +	if (iter->victim_rtg)
> +		xfs_rtgroup_rele(iter->victim_rtg);
> +	if (zi->zi_open_gc_zone)
> +		xfs_open_zone_put(zi->zi_open_gc_zone);
> +
> +	memalloc_nofs_restore(nofs_flag);
> +	kfree(iter);
> +out_free_data:
> +	xfs_zone_gc_data_free(data);
> +	return 0;
> +}
> +
> +void
> +xfs_zone_gc_start(
> +	struct xfs_mount	*mp)
> +{
> +	if (xfs_has_zoned(mp))
> +		kthread_unpark(mp->m_zone_info->zi_gc_thread);
> +}
> +
> +void
> +xfs_zone_gc_stop(
> +	struct xfs_mount	*mp)
> +{
> +	if (xfs_has_zoned(mp))
> +		kthread_park(mp->m_zone_info->zi_gc_thread);
> +}
> +
> +int
> +xfs_zone_gc_mount(
> +	struct xfs_mount	*mp)
> +{
> +	mp->m_zone_info->zi_gc_thread = kthread_create(xfs_zoned_gcd, mp,
> +			"xfs-zone-gc/%s", mp->m_super->s_id);
> +	if (IS_ERR(mp->m_zone_info->zi_gc_thread)) {
> +		xfs_warn(mp, "unable to create zone gc thread");
> +		return PTR_ERR(mp->m_zone_info->zi_gc_thread);
> +	}
> +
> +	/* xfs_zone_gc_start will unpark for rw mounts */
> +	kthread_park(mp->m_zone_info->zi_gc_thread);
> +	return 0;
> +}
> +
> +void
> +xfs_zone_gc_unmount(
> +	struct xfs_mount	*mp)
> +{
> +	kthread_stop(mp->m_zone_info->zi_gc_thread);
> +}
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index f56f3ca8ea00..0b720026e54a 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -82,6 +82,11 @@ struct xfs_zone_info {
>  
>  struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
>  
> +int xfs_zone_reset_sync(struct xfs_rtgroup *rtg);
> +bool xfs_zoned_need_gc(struct xfs_mount *mp);
> +int xfs_zone_gc_mount(struct xfs_mount *mp);
> +void xfs_zone_gc_unmount(struct xfs_mount *mp);
> +
>  void xfs_zoned_resv_wake_all(struct xfs_mount *mp);
>  
>  #endif /* _XFS_ZONE_PRIV_H */
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 5ee525e18759..77211f4c7033 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -159,6 +159,13 @@ xfs_zoned_reserve_available(
>  		if (error != -ENOSPC)
>  			break;
>  
> +		/*
> +		 * If there is nothing left to reclaim, give up.
> +		 */
> +		if (!xfs_is_in_gc(mp) &&
> +		    !xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
> +			break;

Should the caller try again with a different zone if this happens?

--D

> +
>  		spin_unlock(&zi->zi_reservation_lock);
>  		schedule();
>  		spin_lock(&zi->zi_reservation_lock);
> -- 
> 2.45.2
> 
> 
