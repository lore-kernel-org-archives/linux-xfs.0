Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92222CBC7
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 22:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002528; cv=none; b=A1lJy4Tg6hpQ7e5LDEFIYpi/DiZ/X4KCH3mKe+CnOsjLNYej4/k0IZpgGLILodTc3YYvI2b4dQoM2VSLBCrfe4dohQfuxWjhiMZx1dyFRKQMdbGU/05HY/5+P3lVFxohjvZ3eFmZ/goz6e1n5eaGHesQkNRDG7k3qL3Zqx5+adg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002528; c=relaxed/simple;
	bh=6ovtZLUCd95+8Tbr/j0GHvf1S3N78vygVsV1Xwn7/7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5mWd1VjPNJq5DnwIOiVWqNh+jf56Pi7E1HJflydOY45mbT+w56kJLES5QR0rTx4yfTWjUxzh19aChNWpkSlPBdFRxSsRrQ3fiZrtRQmUWA8BvVSqVMVLMsXtb2+sFmcvAzhwYlPe6LUdXKP5UsmlKxXfaJ0/gXsmOcDt6M+p70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKtq4nrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKtq4nrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA679C4CED1;
	Wed, 19 Feb 2025 22:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740002528;
	bh=6ovtZLUCd95+8Tbr/j0GHvf1S3N78vygVsV1Xwn7/7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKtq4nrHuVUsJ35366SQhk0ucNsyx2u73WkmD1OUccZO34ozxR50yiQfAgUAbRhPQ
	 nsdYw0xggTF9mdIxvLfrB702lRZhQ2qFzsabz8jFnDyZRwD28+CEUp0WHJVwAegYoB
	 pBMU+7e8b565O1es4pi2D3MgdN5PdllpsE7gAU/NGkEyEYZUzSrklQ8FjxKdnqc++c
	 LR1xxmdviKkNFGdbkISDYwGHANWOvye9PCQFbcUDy3IS21eg/QAS7jK3DUofvbMpJN
	 +L8r48Ej2Ya5F7eewlHL5RK+yU80n/7H9408lJpSki5q5UHzERhFArKzjcpzwHl2SC
	 /+ne142CMc5/Q==
Date: Wed, 19 Feb 2025 14:02:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] xfs: implement zoned garbage collection
Message-ID: <20250219220207.GZ21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-27-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:29AM +0100, Christoph Hellwig wrote:
> RT groups on a zoned file system need to be completely empty before their
> space can be reused.  This means that partially empty groups need to be
> emptied entirely to free up space if no entirely free groups are
> available.
> 
> Add a garbage collection thread that moves all data out of the least used
> zone when not enough free zones are available, and which resets all zones
> that have been emptied.  To find empty zone a simple set of 10 buckets
> based on the amount of space used in the zone is used.  To empty zones,
> the rmap is walked to find the owners and the data is read and then
> written to the new place.
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
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me now!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/Makefile              |    1 +
>  fs/xfs/libxfs/xfs_group.h    |   21 +-
>  fs/xfs/libxfs/xfs_rtgroup.h  |    6 +
>  fs/xfs/xfs_extent_busy.c     |    2 +-
>  fs/xfs/xfs_mount.c           |    4 +
>  fs/xfs/xfs_mount.h           |    3 +
>  fs/xfs/xfs_super.c           |   10 +
>  fs/xfs/xfs_trace.h           |   25 +
>  fs/xfs/xfs_zone_alloc.c      |  155 +++++
>  fs/xfs/xfs_zone_alloc.h      |    8 +
>  fs/xfs/xfs_zone_gc.c         | 1133 ++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_zone_priv.h       |   21 +
>  fs/xfs/xfs_zone_space_resv.c |    9 +
>  13 files changed, 1393 insertions(+), 5 deletions(-)
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
> index a70096113384..cff3f815947b 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -19,10 +19,23 @@ struct xfs_group {
>  #ifdef __KERNEL__
>  	/* -- kernel only structures below this line -- */
>  
> -	/*
> -	 * Track freed but not yet committed extents.
> -	 */
> -	struct xfs_extent_busy_tree *xg_busy_extents;
> +	union {
> +		/*
> +		 * For perags and non-zoned RT groups:
> +		 * Track freed but not yet committed extents.
> +		 */
> +		struct xfs_extent_busy_tree	*xg_busy_extents;
> +
> +		/*
> +		 * For zoned RT groups:
> +		 * List of groups that need a zone reset.
> +		 *
> +		 * The zonegc code forces a log flush of the rtrmap inode before
> +		 * resetting the write pointer, so there is no need for
> +		 * individual busy extent tracking.
> +		 */
> +		struct xfs_group		*xg_next_reset;
> +	};
>  
>  	/*
>  	 * Bitsets of per-ag metadata that have been checked and/or are sick.
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index 5d8777f819f4..b325aff28264 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -58,6 +58,12 @@ struct xfs_rtgroup {
>   */
>  #define XFS_RTG_FREE			XA_MARK_0
>  
> +/*
> + * For zoned RT devices this is set on groups that are fully written and that
> + * have unused blocks.  Used by the garbage collection to pick targets.
> + */
> +#define XFS_RTG_RECLAIMABLE		XA_MARK_1
> +
>  static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
>  {
>  	return container_of(xg, struct xfs_rtgroup, rtg_group);
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
> index a953383d691a..dc67ff417ad5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1093,6 +1093,8 @@ xfs_mountfs(
>  		error = xfs_fs_reserve_ag_blocks(mp);
>  		if (error && error != -ENOSPC)
>  			goto out_agresv;
> +
> +		xfs_zone_gc_start(mp);
>  	}
>  
>  	return 0;
> @@ -1181,6 +1183,8 @@ xfs_unmountfs(
>  	xfs_inodegc_flush(mp);
>  
>  	xfs_blockgc_stop(mp);
> +	if (!test_bit(XFS_OPSTATE_READONLY, &mp->m_opstate))
> +		xfs_zone_gc_stop(mp);
>  	xfs_fs_unreserve_ag_blocks(mp);
>  	xfs_qm_unmount_quotas(mp);
>  	if (xfs_has_zoned(mp))
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 0772b74fc8fd..4b406f57548a 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -556,6 +556,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_OPSTATE_RESUMING_QUOTAON	18
>  /* Kernel has logged a warning about zoned RT device being used on this fs. */
>  #define XFS_OPSTATE_WARNED_ZONED	19
> +/* (Zoned) GC is in progress */
> +#define XFS_OPSTATE_ZONEGC_RUNNING	20
>  
>  #define __XFS_IS_OPSTATE(name, NAME) \
>  static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
> @@ -600,6 +602,7 @@ static inline bool xfs_clear_resuming_quotaon(struct xfs_mount *mp)
>  #endif /* CONFIG_XFS_QUOTA */
>  __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
>  __XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
> +__XFS_IS_OPSTATE(zonegc_running, ZONEGC_RUNNING)
>  
>  static inline bool
>  xfs_should_warn(struct xfs_mount *mp, long nr)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a840e1c68ff2..39b2bad67fcd 100644
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
> @@ -822,6 +823,7 @@ xfs_fs_sync_fs(
>  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
>  		xfs_inodegc_stop(mp);
>  		xfs_blockgc_stop(mp);
> +		xfs_zone_gc_stop(mp);
>  	}
>  
>  	return 0;
> @@ -994,6 +996,7 @@ xfs_fs_freeze(
>  	if (ret && !xfs_is_readonly(mp)) {
>  		xfs_blockgc_start(mp);
>  		xfs_inodegc_start(mp);
> +		xfs_zone_gc_start(mp);
>  	}
>  
>  	return ret;
> @@ -1015,6 +1018,7 @@ xfs_fs_unfreeze(
>  	 * filesystem.
>  	 */
>  	if (!xfs_is_readonly(mp)) {
> +		xfs_zone_gc_start(mp);
>  		xfs_blockgc_start(mp);
>  		xfs_inodegc_start(mp);
>  	}
> @@ -1948,6 +1952,9 @@ xfs_remount_rw(
>  	/* Re-enable the background inode inactivation worker. */
>  	xfs_inodegc_start(mp);
>  
> +	/* Restart zone reclaim */
> +	xfs_zone_gc_start(mp);
> +
>  	return 0;
>  }
>  
> @@ -1992,6 +1999,9 @@ xfs_remount_ro(
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
> index a4134fc1db4f..7de1ed0ca13a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -295,8 +295,11 @@ DECLARE_EVENT_CLASS(xfs_zone_class,
>  DEFINE_EVENT(xfs_zone_class, name,			\
>  	TP_PROTO(struct xfs_rtgroup *rtg),		\
>  	TP_ARGS(rtg))
> +DEFINE_ZONE_EVENT(xfs_zone_emptied);
>  DEFINE_ZONE_EVENT(xfs_zone_full);
>  DEFINE_ZONE_EVENT(xfs_zone_opened);
> +DEFINE_ZONE_EVENT(xfs_zone_reset);
> +DEFINE_ZONE_EVENT(xfs_zone_gc_target_opened);
>  
>  TRACE_EVENT(xfs_zone_free_blocks,
>  	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
> @@ -364,6 +367,28 @@ DEFINE_EVENT(xfs_zone_alloc_class, name,			\
>  DEFINE_ZONE_ALLOC_EVENT(xfs_zone_record_blocks);
>  DEFINE_ZONE_ALLOC_EVENT(xfs_zone_alloc_blocks);
>  
> +TRACE_EVENT(xfs_zone_gc_select_victim,
> +	TP_PROTO(struct xfs_rtgroup *rtg, unsigned int bucket),
> +	TP_ARGS(rtg, bucket),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_rgnumber_t, rgno)
> +		__field(xfs_rgblock_t, used)
> +		__field(unsigned int, bucket)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
> +		__entry->rgno = rtg_rgno(rtg);
> +		__entry->used = rtg_rmap(rtg)->i_used_blocks;
> +		__entry->bucket = bucket;
> +	),
> +	TP_printk("dev %d:%d rgno 0x%x used 0x%x bucket %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->rgno,
> +		  __entry->used,
> +		  __entry->bucket)
> +);
> +
>  TRACE_EVENT(xfs_zones_mount,
>  	TP_PROTO(struct xfs_mount *mp),
>  	TP_ARGS(mp),
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 4f433741f646..7537ad4c51d1 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -35,6 +35,104 @@ xfs_open_zone_put(
>  	}
>  }
>  
> +static inline uint32_t
> +xfs_zone_bucket(
> +	struct xfs_mount	*mp,
> +	uint32_t		used_blocks)
> +{
> +	return XFS_ZONE_USED_BUCKETS * used_blocks /
> +			mp->m_groups[XG_TYPE_RTG].blocks;
> +}
> +
> +static inline void
> +xfs_zone_add_to_bucket(
> +	struct xfs_zone_info	*zi,
> +	xfs_rgnumber_t		rgno,
> +	uint32_t		to_bucket)
> +{
> +	__set_bit(rgno, zi->zi_used_bucket_bitmap[to_bucket]);
> +	zi->zi_used_bucket_entries[to_bucket]++;
> +}
> +
> +static inline void
> +xfs_zone_remove_from_bucket(
> +	struct xfs_zone_info	*zi,
> +	xfs_rgnumber_t		rgno,
> +	uint32_t		from_bucket)
> +{
> +	__clear_bit(rgno, zi->zi_used_bucket_bitmap[from_bucket]);
> +	zi->zi_used_bucket_entries[from_bucket]--;
> +}
> +
> +static void
> +xfs_zone_account_reclaimable(
> +	struct xfs_rtgroup	*rtg,
> +	uint32_t		freed)
> +{
> +	struct xfs_group	*xg = &rtg->rtg_group;
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
> +	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
> +	uint32_t		from_bucket = xfs_zone_bucket(mp, used + freed);
> +	uint32_t		to_bucket = xfs_zone_bucket(mp, used);
> +	bool			was_full = (used + freed == rtg_blocks(rtg));
> +
> +	/*
> +	 * This can be called from log recovery, where the zone_info structure
> +	 * hasn't been allocated yet.  Skip all work as xfs_mount_zones will
> +	 * add the zones to the right buckets before the file systems becomes
> +	 * active.
> +	 */
> +	if (!zi)
> +		return;
> +
> +	if (!used) {
> +		/*
> +		 * The zone is now empty, remove it from the bottom bucket and
> +		 * trigger a reset.
> +		 */
> +		trace_xfs_zone_emptied(rtg);
> +
> +		if (!was_full)
> +			xfs_group_clear_mark(xg, XFS_RTG_RECLAIMABLE);
> +
> +		spin_lock(&zi->zi_used_buckets_lock);
> +		if (!was_full)
> +			xfs_zone_remove_from_bucket(zi, rgno, from_bucket);
> +		spin_unlock(&zi->zi_used_buckets_lock);
> +
> +		spin_lock(&zi->zi_reset_list_lock);
> +		xg->xg_next_reset = zi->zi_reset_list;
> +		zi->zi_reset_list = xg;
> +		spin_unlock(&zi->zi_reset_list_lock);
> +
> +		if (zi->zi_gc_thread)
> +			wake_up_process(zi->zi_gc_thread);
> +	} else if (was_full) {
> +		/*
> +		 * The zone transitioned from full, mark it up as reclaimable
> +		 * and wake up GC which might be waiting for zones to reclaim.
> +		 */
> +		spin_lock(&zi->zi_used_buckets_lock);
> +		xfs_zone_add_to_bucket(zi, rgno, to_bucket);
> +		spin_unlock(&zi->zi_used_buckets_lock);
> +
> +		xfs_group_set_mark(xg, XFS_RTG_RECLAIMABLE);
> +		if (zi->zi_gc_thread && xfs_zoned_need_gc(mp))
> +			wake_up_process(zi->zi_gc_thread);
> +	} else if (to_bucket != from_bucket) {
> +		/*
> +		 * Move the zone to a new bucket if it dropped below the
> +		 * threshold.
> +		 */
> +		spin_lock(&zi->zi_used_buckets_lock);
> +		xfs_zone_add_to_bucket(zi, rgno, to_bucket);
> +		xfs_zone_remove_from_bucket(zi, rgno, from_bucket);
> +		spin_unlock(&zi->zi_used_buckets_lock);
> +	}
> +}
> +
>  static void
>  xfs_open_zone_mark_full(
>  	struct xfs_open_zone	*oz)
> @@ -42,6 +140,7 @@ xfs_open_zone_mark_full(
>  	struct xfs_rtgroup	*rtg = oz->oz_rtg;
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
>  
>  	trace_xfs_zone_full(rtg);
>  
> @@ -59,6 +158,8 @@ xfs_open_zone_mark_full(
>  	xfs_open_zone_put(oz);
>  
>  	wake_up_all(&zi->zi_zone_wait);
> +	if (used < rtg_blocks(rtg))
> +		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
>  }
>  
>  static void
> @@ -243,6 +344,13 @@ xfs_zone_free_blocks(
>  	trace_xfs_zone_free_blocks(rtg, xfs_rtb_to_rgbno(mp, fsbno), len);
>  
>  	rmapip->i_used_blocks -= len;
> +	/*
> +	 * Don't add open zones to the reclaimable buckets.  The I/O completion
> +	 * for writing the last block will take care of accounting for already
> +	 * unused blocks instead.
> +	 */
> +	if (!READ_ONCE(rtg->rtg_open_zone))
> +		xfs_zone_account_reclaimable(rtg, len);
>  	xfs_add_frextents(mp, len);
>  	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
>  	return 0;
> @@ -394,6 +502,9 @@ xfs_try_open_zone(
>  	 */
>  	wake_up_all(&zi->zi_zone_wait);
>  
> +	if (xfs_zoned_need_gc(mp))
> +		wake_up_process(zi->zi_gc_thread);
> +
>  	trace_xfs_zone_opened(oz->oz_rtg);
>  	return oz;
>  }
> @@ -701,6 +812,7 @@ xfs_init_zone(
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  	uint64_t		used = rtg_rmap(rtg)->i_used_blocks;
>  	xfs_rgblock_t		write_pointer, highest_rgbno;
> +	int			error;
>  
>  	if (zone && !xfs_zone_validate(zone, rtg, &write_pointer))
>  		return -EFSCORRUPTED;
> @@ -727,6 +839,18 @@ xfs_init_zone(
>  		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
>  	}
>  
> +	/*
> +	 * If there are no used blocks, but the zone is not in empty state yet
> +	 * we lost power before the zoned reset.  In that case finish the work
> +	 * here.
> +	 */
> +	if (write_pointer == rtg_blocks(rtg) && used == 0) {
> +		error = xfs_zone_gc_reset_sync(rtg);
> +		if (error)
> +			return error;
> +		write_pointer = 0;
> +	}
> +
>  	if (write_pointer == 0) {
>  		/* zone is empty */
>  		atomic_inc(&zi->zi_nr_free_zones);
> @@ -745,6 +869,7 @@ xfs_init_zone(
>  		iz->reclaimable += write_pointer - used;
>  	} else if (used < rtg_blocks(rtg)) {
>  		/* zone fully written, but has freed blocks */
> +		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
>  		iz->reclaimable += (rtg_blocks(rtg) - used);
>  	}
>  
> @@ -855,11 +980,20 @@ xfs_calc_open_zones(
>  	return 0;
>  }
>  
> +static unsigned long *
> +xfs_alloc_bucket_bitmap(
> +	struct xfs_mount	*mp)
> +{
> +	return kvmalloc_array(BITS_TO_LONGS(mp->m_sb.sb_rgcount),
> +			sizeof(unsigned long), GFP_KERNEL | __GFP_ZERO);
> +}
> +
>  static struct xfs_zone_info *
>  xfs_alloc_zone_info(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_zone_info	*zi;
> +	int			i;
>  
>  	zi = kzalloc(sizeof(*zi), GFP_KERNEL);
>  	if (!zi)
> @@ -870,14 +1004,30 @@ xfs_alloc_zone_info(
>  	spin_lock_init(&zi->zi_open_zones_lock);
>  	spin_lock_init(&zi->zi_reservation_lock);
>  	init_waitqueue_head(&zi->zi_zone_wait);
> +	spin_lock_init(&zi->zi_used_buckets_lock);
> +	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++) {
> +		zi->zi_used_bucket_bitmap[i] = xfs_alloc_bucket_bitmap(mp);
> +		if (!zi->zi_used_bucket_bitmap[i])
> +			goto out_free_bitmaps;
> +	}
>  	return zi;
> +
> +out_free_bitmaps:
> +	while (--i > 0)
> +		kvfree(zi->zi_used_bucket_bitmap[i]);
> +	kfree(zi);
> +	return NULL;
>  }
>  
>  static void
>  xfs_free_zone_info(
>  	struct xfs_zone_info	*zi)
>  {
> +	int			i;
> +
>  	xfs_free_open_zones(zi);
> +	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++)
> +		kvfree(zi->zi_used_bucket_bitmap[i]);
>  	kfree(zi);
>  }
>  
> @@ -942,6 +1092,10 @@ xfs_mount_zones(
>  	xfs_set_freecounter(mp, XC_FREE_RTAVAILABLE, iz.available);
>  	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
>  			iz.available + iz.reclaimable);
> +
> +	error = xfs_zone_gc_mount(mp);
> +	if (error)
> +		goto out_free_zone_info;
>  	return 0;
>  
>  out_free_zone_info:
> @@ -953,5 +1107,6 @@ void
>  xfs_unmount_zones(
>  	struct xfs_mount	*mp)
>  {
> +	xfs_zone_gc_unmount(mp);
>  	xfs_free_zone_info(mp->m_zone_info);
>  }
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index 28c9cffb72d5..1269390bfcda 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -48,6 +48,8 @@ uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
>  #ifdef CONFIG_XFS_RT
>  int xfs_mount_zones(struct xfs_mount *mp);
>  void xfs_unmount_zones(struct xfs_mount *mp);
> +void xfs_zone_gc_start(struct xfs_mount *mp);
> +void xfs_zone_gc_stop(struct xfs_mount *mp);
>  #else
>  static inline int xfs_mount_zones(struct xfs_mount *mp)
>  {
> @@ -56,6 +58,12 @@ static inline int xfs_mount_zones(struct xfs_mount *mp)
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
> index 000000000000..36cc167522c8
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -0,0 +1,1133 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2025 Christoph Hellwig.
> + * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
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
> +	enum {
> +		XFS_GC_BIO_NEW,
> +		XFS_GC_BIO_DONE,
> +	} state;
> +
> +	/*
> +	 * Pointer to the inode and byte range in the inode that this
> +	 * GC chunk is operating on.
> +	 */
> +	struct xfs_inode		*ip;
> +	loff_t				offset;
> +	unsigned int			len;
> +
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
> +	/* Open Zone being written to */
> +	struct xfs_open_zone		*oz;
> +
> +	/* Bio used for reads and writes, including the bvec used by it */
> +	struct bio_vec			bv;
> +	struct bio			bio;	/* must be last */
> +};
> +
> +#define XFS_ZONE_GC_RECS		1024
> +
> +/* iterator, needs to be reinitialized for each victim zone */
> +struct xfs_zone_gc_iter {
> +	struct xfs_rtgroup		*victim_rtg;
> +	unsigned int			rec_count;
> +	unsigned int			rec_idx;
> +	xfs_agblock_t			next_startblock;
> +	struct xfs_rmap_irec		*recs;
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
> +
> +	/*
> +	 * Iterator for the victim zone.
> +	 */
> +	struct xfs_zone_gc_iter		iter;
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
> +		return true;
> +	return false;
> +}
> +
> +static struct xfs_zone_gc_data *
> +xfs_zone_gc_data_alloc(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_gc_data	*data;
> +	int			i;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return NULL;
> +	data->iter.recs = kcalloc(XFS_ZONE_GC_RECS, sizeof(*data->iter.recs),
> +			GFP_KERNEL);
> +	if (!data->iter.recs)
> +		goto out_free_data;
> +
> +	/*
> +	 * We actually only need a single bio_vec.  It would be nice to have
> +	 * a flag that only allocates the inline bvecs and not the separate
> +	 * bvec pool.
> +	 */
> +	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
> +			BIOSET_NEED_BVECS))
> +		goto out_free_recs;
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
> +out_free_recs:
> +	kfree(data->iter.recs);
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
> +	kfree(data->iter.recs);
> +	kfree(data);
> +}
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
> +/*
> + * Query the rmap of the victim zone to gather the records to evacuate.
> + */
> +static int
> +xfs_zone_gc_query_cb(
> +	struct xfs_btree_cur	*cur,
> +	const struct xfs_rmap_irec *irec,
> +	void			*private)
> +{
> +	struct xfs_zone_gc_iter	*iter = private;
> +
> +	ASSERT(!XFS_RMAP_NON_INODE_OWNER(irec->rm_owner));
> +	ASSERT(!xfs_is_sb_inum(cur->bc_mp, irec->rm_owner));
> +	ASSERT(!(irec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)));
> +
> +	iter->recs[iter->rec_count] = *irec;
> +	if (++iter->rec_count == XFS_ZONE_GC_RECS) {
> +		iter->next_startblock =
> +			irec->rm_startblock + irec->rm_blockcount;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +#define cmp_int(l, r)		((l > r) - (l < r))
> +
> +static int
> +xfs_zone_gc_rmap_rec_cmp(
> +	const void			*a,
> +	const void			*b)
> +{
> +	const struct xfs_rmap_irec	*reca = a;
> +	const struct xfs_rmap_irec	*recb = b;
> +	int				diff;
> +
> +	diff = cmp_int(reca->rm_owner, recb->rm_owner);
> +	if (diff)
> +		return diff;
> +	return cmp_int(reca->rm_offset, recb->rm_offset);
> +}
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
> +	cur = xfs_rtrmapbt_init_cursor(tp, rtg);
> +	error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
> +			xfs_zone_gc_query_cb, iter);
> +	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
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
> +			xfs_zone_gc_rmap_rec_cmp, NULL);
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
> +	if (!S_ISREG(VFS_I(*ipp)->i_mode) || !XFS_IS_REALTIME_INODE(*ipp)) {
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
> +static struct xfs_rtgroup *
> +xfs_zone_gc_pick_victim_from(
> +	struct xfs_mount	*mp,
> +	uint32_t		bucket)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	uint32_t		victim_used = U32_MAX;
> +	struct xfs_rtgroup	*victim_rtg = NULL;
> +	uint32_t		bit;
> +
> +	if (!zi->zi_used_bucket_entries[bucket])
> +		return NULL;
> +
> +	for_each_set_bit(bit, zi->zi_used_bucket_bitmap[bucket],
> +			mp->m_sb.sb_rgcount) {
> +		struct xfs_rtgroup *rtg = xfs_rtgroup_grab(mp, bit);
> +
> +		if (!rtg)
> +			continue;
> +
> +		/* skip zones that are just waiting for a reset */
> +		if (rtg_rmap(rtg)->i_used_blocks == 0 ||
> +		    rtg_rmap(rtg)->i_used_blocks >= victim_used) {
> +			xfs_rtgroup_rele(rtg);
> +			continue;
> +		}
> +
> +		if (victim_rtg)
> +			xfs_rtgroup_rele(victim_rtg);
> +		victim_rtg = rtg;
> +		victim_used = rtg_rmap(rtg)->i_used_blocks;
> +
> +		/*
> +		 * Any zone that is less than 1 percent used is fair game for
> +		 * instant reclaim. All of these zones are in the last
> +		 * bucket, so avoid the expensive division for the zones
> +		 * in the other buckets.
> +		 */
> +		if (bucket == 0 &&
> +		    rtg_rmap(rtg)->i_used_blocks < rtg_blocks(rtg) / 100)
> +			break;
> +	}
> +
> +	return victim_rtg;
> +}
> +
> +/*
> + * Iterate through all zones marked as reclaimable and find a candidate to
> + * reclaim.
> + */
> +static bool
> +xfs_zone_gc_select_victim(
> +	struct xfs_zone_gc_data	*data)
> +{
> +	struct xfs_zone_gc_iter	*iter = &data->iter;
> +	struct xfs_mount	*mp = data->mp;
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_rtgroup	*victim_rtg = NULL;
> +	unsigned int		bucket;
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
> +	spin_lock(&zi->zi_used_buckets_lock);
> +	for (bucket = 0; bucket < XFS_ZONE_USED_BUCKETS; bucket++) {
> +		victim_rtg = xfs_zone_gc_pick_victim_from(mp, bucket);
> +		if (victim_rtg)
> +			break;
> +	}
> +	spin_unlock(&zi->zi_used_buckets_lock);
> +
> +	if (!victim_rtg)
> +		return false;
> +
> +	trace_xfs_zone_gc_select_victim(victim_rtg, bucket);
> +	xfs_zone_gc_iter_init(iter, victim_rtg);
> +	return true;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_zone_gc_steal_open(
> +	struct xfs_zone_info	*zi)
> +{
> +	struct xfs_open_zone	*oz, *found = NULL;
> +
> +	spin_lock(&zi->zi_open_zones_lock);
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
> +
> +	spin_unlock(&zi->zi_open_zones_lock);
> +	return found;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_zone_gc_select_target(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
> +
> +	/*
> +	 * We need to wait for pending writes to finish.
> +	 */
> +	if (oz && oz->oz_written < rtg_blocks(oz->oz_rtg))
> +		return NULL;
> +
> +	ASSERT(zi->zi_nr_open_zones <=
> +		mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
> +	oz = xfs_open_zone(mp, true);
> +	if (oz)
> +		trace_xfs_zone_gc_target_opened(oz->oz_rtg);
> +	spin_lock(&zi->zi_open_zones_lock);
> +	zi->zi_open_gc_zone = oz;
> +	spin_unlock(&zi->zi_open_zones_lock);
> +	return oz;
> +}
> +
> +/*
> + * Ensure we have a valid open zone to write the GC data to.
> + *
> + * If the current target zone has space keep writing to it, else first wait for
> + * all pending writes and then pick a new one.
> + */
> +static struct xfs_open_zone *
> +xfs_zone_gc_ensure_target(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
> +
> +	if (!oz || oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
> +		return xfs_zone_gc_select_target(mp);
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
> +	oz = xfs_zone_gc_ensure_target(data->mp);
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
> +static struct xfs_open_zone *
> +xfs_zone_gc_alloc_blocks(
> +	struct xfs_zone_gc_data	*data,
> +	xfs_extlen_t		*count_fsb,
> +	xfs_daddr_t		*daddr,
> +	bool			*is_seq)
> +{
> +	struct xfs_mount	*mp = data->mp;
> +	struct xfs_open_zone	*oz;
> +
> +	oz = xfs_zone_gc_ensure_target(mp);
> +	if (!oz)
> +		return NULL;
> +
> +	*count_fsb = min(*count_fsb,
> +		XFS_B_TO_FSB(mp, xfs_zone_gc_scratch_available(data)));
> +
> +	/*
> +	 * Directly allocate GC blocks from the reserved pool.
> +	 *
> +	 * If we'd take them from the normal pool we could be stealing blocks
> +	 * from a regular writer, which would then have to wait for GC and
> +	 * deadlock.
> +	 */
> +	spin_lock(&mp->m_sb_lock);
> +	*count_fsb = min(*count_fsb,
> +			rtg_blocks(oz->oz_rtg) - oz->oz_write_pointer);
> +	*count_fsb = min3(*count_fsb,
> +			mp->m_free[XC_FREE_RTEXTENTS].res_avail,
> +			mp->m_free[XC_FREE_RTAVAILABLE].res_avail);
> +	mp->m_free[XC_FREE_RTEXTENTS].res_avail -= *count_fsb;
> +	mp->m_free[XC_FREE_RTAVAILABLE].res_avail -= *count_fsb;
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	if (!*count_fsb)
> +		return NULL;
> +
> +	*daddr = xfs_gbno_to_daddr(&oz->oz_rtg->rtg_group, 0);
> +	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
> +	if (!*is_seq)
> +		*daddr += XFS_FSB_TO_BB(mp, oz->oz_write_pointer);
> +	oz->oz_write_pointer += *count_fsb;
> +	atomic_inc(&oz->oz_ref);
> +	return oz;
> +}
> +
> +static bool
> +xfs_zone_gc_start_chunk(
> +	struct xfs_zone_gc_data	*data)
> +{
> +	struct xfs_zone_gc_iter	*iter = &data->iter;
> +	struct xfs_mount	*mp = data->mp;
> +	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
> +	struct xfs_open_zone	*oz;
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
> +	oz = xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
> +			&is_seq);
> +	if (!oz) {
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
> +	chunk->oz = oz;
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
> +	xfs_open_zone_put(chunk->oz);
> +	xfs_irele(chunk->ip);
> +	bio_put(&chunk->bio);
> +}
> +
> +static void
> +xfs_zone_gc_submit_write(
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
> +xfs_zone_gc_split_write(
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
> +
> +	/* ensure the split chunk is still block size aligned */
> +	split_sectors = ALIGN_DOWN(split_sectors << SECTOR_SHIFT,
> +			data->mp->m_sb.sb_blocksize) >> SECTOR_SHIFT;
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
> +	split_chunk->oz = chunk->oz;
> +	atomic_inc(&chunk->oz->oz_ref);
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
> +	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
> +		xfs_zone_gc_submit_write(data, split_chunk);
> +	xfs_zone_gc_submit_write(data, chunk);
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
> +	if (error)
> +		goto free;
> +
> +	if (chunk->is_seq)
> +		chunk->new_daddr = chunk->bio.bi_iter.bi_sector;
> +	error = xfs_zoned_end_io(ip, chunk->offset, chunk->len,
> +			chunk->new_daddr, chunk->oz, chunk->old_startblock);
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
> +	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
> +	atomic_inc(&zi->zi_nr_free_zones);
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
> +xfs_zone_gc_prepare_reset(
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
> +xfs_zone_gc_reset_sync(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	int			error = 0;
> +	struct bio		bio;
> +
> +	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
> +			REQ_OP_ZONE_RESET);
> +	if (xfs_zone_gc_prepare_reset(&bio, rtg))
> +		error = submit_bio_wait(&bio);
> +	bio_uninit(&bio);
> +
> +	return error;
> +}
> +
> +static void
> +xfs_zone_gc_reset_zones(
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
> +		/*
> +		 * Also use the bio to drive the state machine when neither
> +		 * zone reset nor discard is supported to keep things simple.
> +		 */
> +		if (xfs_zone_gc_prepare_reset(bio, rtg))
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
> +	struct xfs_zone_gc_data	*data)
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
> +	if (!xfs_zone_gc_select_victim(data) ||
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
> +		xfs_zone_gc_reset_zones(data, reset_list);
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
> +	while (xfs_zone_gc_start_chunk(data))
> +		;
> +	blk_finish_plug(&plug);
> +	return true;
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
> +	struct xfs_zone_gc_data	*data = private;
> +	struct xfs_mount	*mp = data->mp;
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	unsigned int		nofs_flag;
> +
> +	nofs_flag = memalloc_nofs_save();
> +	set_freezable();
> +
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
> +		xfs_set_zonegc_running(mp);
> +		if (xfs_zone_gc_handle_work(data))
> +			continue;
> +
> +		if (list_empty(&data->reading) &&
> +		    list_empty(&data->writing) &&
> +		    list_empty(&data->resetting) &&
> +		    !zi->zi_reset_list) {
> +			xfs_clear_zonegc_running(mp);
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
> +	xfs_clear_zonegc_running(mp);
> +
> +	if (data->iter.victim_rtg)
> +		xfs_rtgroup_rele(data->iter.victim_rtg);
> +
> +	memalloc_nofs_restore(nofs_flag);
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
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_zone_gc_data	*data;
> +	struct xfs_open_zone	*oz;
> +	int			error;
> +
> +	/*
> +	 * If there are no free zones available for GC, pick the open zone with
> +	 * the least used space to GC into.  This should only happen after an
> +	 * unclean shutdown near ENOSPC while GC was ongoing.
> +	 *
> +	 * We also need to do this for the first gc zone allocation if we
> +	 * unmounted while at the open limit.
> +	 */
> +	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE) ||
> +	    zi->zi_nr_open_zones == mp->m_max_open_zones)
> +		oz = xfs_zone_gc_steal_open(zi);
> +	else
> +		oz = xfs_open_zone(mp, true);
> +	if (!oz) {
> +		xfs_warn(mp, "unable to allocate a zone for gc");
> +		error = -EIO;
> +		goto out;
> +	}
> +
> +	trace_xfs_zone_gc_target_opened(oz->oz_rtg);
> +	zi->zi_open_gc_zone = oz;
> +
> +	data = xfs_zone_gc_data_alloc(mp);
> +	if (!data) {
> +		error = -ENOMEM;
> +		goto out_put_gc_zone;
> +	}
> +
> +	mp->m_zone_info->zi_gc_thread = kthread_create(xfs_zoned_gcd, data,
> +			"xfs-zone-gc/%s", mp->m_super->s_id);
> +	if (IS_ERR(mp->m_zone_info->zi_gc_thread)) {
> +		xfs_warn(mp, "unable to create zone gc thread");
> +		error = PTR_ERR(mp->m_zone_info->zi_gc_thread);
> +		goto out_free_gc_data;
> +	}
> +
> +	/* xfs_zone_gc_start will unpark for rw mounts */
> +	kthread_park(mp->m_zone_info->zi_gc_thread);
> +	return 0;
> +
> +out_free_gc_data:
> +	kfree(data);
> +out_put_gc_zone:
> +	xfs_open_zone_put(zi->zi_open_gc_zone);
> +out:
> +	return error;
> +}
> +
> +void
> +xfs_zone_gc_unmount(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +
> +	kthread_stop(zi->zi_gc_thread);
> +	if (zi->zi_open_gc_zone)
> +		xfs_open_zone_put(zi->zi_open_gc_zone);
> +}
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index 5283d77482d4..f6c76d751a49 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -40,6 +40,13 @@ struct xfs_open_zone {
>  	struct xfs_rtgroup	*oz_rtg;
>  };
>  
> +/*
> + * Number of bitmap buckets to track reclaimable zones.  There are 10 buckets
> + * so that each 10% of the usable capacity get their own bucket and GC can
> + * only has to walk the bitmaps of the lesser used zones if there are any.
> + */
> +#define XFS_ZONE_USED_BUCKETS		10u
> +
>  struct xfs_zone_info {
>  	/*
>  	 * List of pending space reservations:
> @@ -82,10 +89,24 @@ struct xfs_zone_info {
>  	 */
>  	spinlock_t		zi_reset_list_lock;
>  	struct xfs_group	*zi_reset_list;
> +
> +	/*
> +	 * A set of bitmaps to bucket-sort reclaimable zones by used blocks to help
> +	 * garbage collection to quickly find the best candidate for reclaim.
> +	 */
> +	spinlock_t		zi_used_buckets_lock;
> +	unsigned int		zi_used_bucket_entries[XFS_ZONE_USED_BUCKETS];
> +	unsigned long		*zi_used_bucket_bitmap[XFS_ZONE_USED_BUCKETS];
> +
>  };
>  
>  struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
>  
> +int xfs_zone_gc_reset_sync(struct xfs_rtgroup *rtg);
> +bool xfs_zoned_need_gc(struct xfs_mount *mp);
> +int xfs_zone_gc_mount(struct xfs_mount *mp);
> +void xfs_zone_gc_unmount(struct xfs_mount *mp);
> +
>  void xfs_zoned_resv_wake_all(struct xfs_mount *mp);
>  
>  #endif /* _XFS_ZONE_PRIV_H */
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index eff9be026425..4bf1b18aa7a7 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -159,6 +159,15 @@ xfs_zoned_reserve_available(
>  		if (error != -ENOSPC)
>  			break;
>  
> +		/*
> +		 * If there is no reclaimable group left and we aren't still
> +		 * processing a pending GC request give up as we're fully out
> +		 * of space.
> +		 */
> +		if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE) &&
> +		    !xfs_is_zonegc_running(mp))
> +			break;
> +
>  		spin_unlock(&zi->zi_reservation_lock);
>  		schedule();
>  		spin_lock(&zi->zi_reservation_lock);
> -- 
> 2.45.2
> 
> 
