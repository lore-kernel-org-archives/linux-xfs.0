Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A409F1F0E23
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907473; cv=none; b=VULcQoMBdx/mmpZCZIN61iDFWp0tCYOYSHqpXTKSSu3PdDAkhY5KG7eVwqAKkNTEBow4XwNVhWW8UNu4iDukGgJFcxfaJ5BMFDAGmJ5+x2MR8o9/hsPTRsMRCpKf/52exZk/PSjAcwVOUD+SjIzS3ows+Ts8IJkaIga+5dgZaqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907473; c=relaxed/simple;
	bh=fBSbaYGkb11Mxc2+ZVRIBBVfEM3kQg0OkKwKJZvKjS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tm+uk6WYyKNXLkhe5I2BicEhsn0nOb896RAd4es4/gKvAUKNXDX8HSfF+wTZT+d6gm3uWDa6x2mWmit4ZRKbtUy7joiDZ7xMMtNwN6jX0xCSaUOiRcw1C4HSIIDc6XeOFJS5xt1DbLTQwj/RkjCtRsmou/JxExIRupD5G8T1Q2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nbOleRzU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nbOleRzU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fVbKR8UMm1dgjrJ5Hfg5hxnfTGeAen61C6hJbJwyLlA=; b=nbOleRzUCvuqawSz99N9W7+Nkw
	3WAuyRNdqHfEcYdfXJDzdlPF43Vlo4LcBKlFKk+Q8hUJYVNzRiqJ5w3R4xqYyX6Pg0d07vWE3lpos
	MTCDSx07mxQrXSpOzYccClnEZTS3oV93sizq65GrpSOhtY5eWQT1wxwuEHv41hHy8RI3wP5Hr6pkS
	hks9Q0mVy53YWIep285q/rfJc8I9LsYKEvzR4Ri0QKqtWcduFZQIQHsheG535zG8bz//ES7qG4tfi
	RFh6HGPxAmVLD2SzJ7+rD/GCWW17/+gatrJF/S65kzGA8HzNGQpGDSBrQKOxw/2oxiMAVKhajjo/I
	1cCBtjlw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXV-0000000EJJs-2R2g;
	Wed, 11 Dec 2024 08:57:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 26/43] xfs: implement zoned garbage collection
Date: Wed, 11 Dec 2024 09:54:51 +0100
Message-ID: <20241211085636.1380516-27-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

RT groups on a zoned file system need to be completely empty before their
space can be reused.  This means that partially empty groups need to be
emptied entirely to free up space if no entirely free groups are
available.

Add a garbage collection thread that moves all data out of the least used
zone when not enough free zones are available, and which resets all zones
that have been emptied.  To empty zones, the rmap is walked to find the
owners and the data is read and then written to the new place.

To automatically defragment files the rmap records are sorted by inode
and logical offset.  This means defragmentation of parallel writes into
a single zone happens automatically when performing garbage collection.
Because holding the iolock over the entire GC cycle would inject very
noticeable latency for other accesses to the inodes, the iolock is not
taken while performing I/O.  Instead the I/O completion handler checks
that the mapping hasn't changed over the one recorded at the start of
the GC cycle and doesn't update the mapping if it change.

Note: selection of garbage collection victims is extremely simple at the
moment and will probably see additional near term improvements.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile              |    1 +
 fs/xfs/libxfs/xfs_group.h    |   15 +-
 fs/xfs/xfs_extent_busy.c     |    2 +-
 fs/xfs/xfs_mount.c           |    4 +
 fs/xfs/xfs_mount.h           |    3 +
 fs/xfs/xfs_super.c           |    7 +
 fs/xfs/xfs_trace.h           |    4 +
 fs/xfs/xfs_zone_alloc.c      |   52 +-
 fs/xfs/xfs_zone_alloc.h      |    8 +
 fs/xfs/xfs_zone_gc.c         | 1045 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_zone_priv.h       |    5 +
 fs/xfs/xfs_zone_space_resv.c |    7 +
 12 files changed, 1146 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/xfs_zone_gc.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index bdedf4bdb1db..e38838409271 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -139,6 +139,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
 				   xfs_zone_alloc.o \
+				   xfs_zone_gc.o \
 				   xfs_zone_space_resv.o
 
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index a70096113384..430a43e1591e 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -19,10 +19,17 @@ struct xfs_group {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
-	/*
-	 * Track freed but not yet committed extents.
-	 */
-	struct xfs_extent_busy_tree *xg_busy_extents;
+	union {
+		/*
+		 * Track freed but not yet committed extents.
+		 */
+		struct xfs_extent_busy_tree	*xg_busy_extents;
+
+		/*
+		 * List of groups that need a zone reset for zoned file systems.
+		 */
+		struct xfs_group		*xg_next_reset;
+	};
 
 	/*
 	 * Bitsets of per-ag metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ea43c9a6e54c..da3161572735 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -671,7 +671,7 @@ xfs_extent_busy_wait_all(
 	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_extent_busy_wait_group(pag_group(pag));
 
-	if (xfs_has_rtgroups(mp))
+	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp))
 		while ((rtg = xfs_rtgroup_next(mp, rtg)))
 			xfs_extent_busy_wait_group(rtg_group(rtg));
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 70ecbbaba7fd..20d564b3b564 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1088,6 +1088,8 @@ xfs_mountfs(
 		error = xfs_fs_reserve_ag_blocks(mp);
 		if (error && error != -ENOSPC)
 			goto out_agresv;
+
+		xfs_zone_gc_start(mp);
 	}
 
 	return 0;
@@ -1176,6 +1178,8 @@ xfs_unmountfs(
 	xfs_inodegc_flush(mp);
 
 	xfs_blockgc_stop(mp);
+	if (!test_bit(XFS_OPSTATE_READONLY, &mp->m_opstate))
+		xfs_zone_gc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	if (xfs_has_zoned(mp))
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 02a3609a3322..831d9e09fe72 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -548,6 +548,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_RESUMING_QUOTAON	18
 /* Kernel has logged a warning about zoned RT device being used on this fs. */
 #define XFS_OPSTATE_WARNED_ZONED	19
+/* (Zoned) GC is in progress */
+#define XFS_OPSTATE_IN_GC		20
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -592,6 +594,7 @@ static inline bool xfs_clear_resuming_quotaon(struct xfs_mount *mp)
 #endif /* CONFIG_XFS_QUOTA */
 __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
 __XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
+__XFS_IS_OPSTATE(in_gc, IN_GC)
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d0b7e0d02366..b289b2ba78b1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -46,6 +46,7 @@
 #include "xfs_exchmaps_item.h"
 #include "xfs_parent.h"
 #include "xfs_rtalloc.h"
+#include "xfs_zone_alloc.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -1947,6 +1948,9 @@ xfs_remount_rw(
 	/* Re-enable the background inode inactivation worker. */
 	xfs_inodegc_start(mp);
 
+	/* Restart zone reclaim */
+	xfs_zone_gc_start(mp);
+
 	return 0;
 }
 
@@ -1991,6 +1995,9 @@ xfs_remount_ro(
 	 */
 	xfs_inodegc_stop(mp);
 
+	/* Stop zone reclaim */
+	xfs_zone_gc_stop(mp);
+
 	/* Free the per-AG metadata reservation pool. */
 	xfs_fs_unreserve_ag_blocks(mp);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 763dd3d271b9..bbaf9b2665c7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -290,8 +290,12 @@ DECLARE_EVENT_CLASS(xfs_zone_class,
 DEFINE_EVENT(xfs_zone_class, name,			\
 	TP_PROTO(struct xfs_rtgroup *rtg),		\
 	TP_ARGS(rtg))
+DEFINE_ZONE_EVENT(xfs_zone_emptied);
 DEFINE_ZONE_EVENT(xfs_zone_full);
 DEFINE_ZONE_EVENT(xfs_zone_activate);
+DEFINE_ZONE_EVENT(xfs_zone_reset);
+DEFINE_ZONE_EVENT(xfs_zone_reclaim);
+DEFINE_ZONE_EVENT(xfs_gc_zone_activate);
 
 TRACE_EVENT(xfs_zone_free_blocks,
 	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1a746e9cfbf4..291cf39a5989 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -34,11 +34,43 @@ xfs_open_zone_put(
 	}
 }
 
+static void
+xfs_zone_emptied(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+
+	trace_xfs_zone_emptied(rtg);
+
+	/*
+	 * This can be called from log recovery, where the zone_info structure
+	 * hasn't been allocated yet.  But we'll look for empty zones when
+	 * setting it up, so don't need to track the empty zone here in that
+	 * case.
+	 */
+	if (!zi)
+		return;
+
+	xfs_group_clear_mark(&rtg->rtg_group, XFS_RTG_RECLAIMABLE);
+
+	spin_lock(&zi->zi_reset_list_lock);
+	rtg_group(rtg)->xg_next_reset = zi->zi_reset_list;
+	zi->zi_reset_list = rtg_group(rtg);
+	spin_unlock(&zi->zi_reset_list_lock);
+
+	wake_up_process(zi->zi_gc_thread);
+}
+
 static void
 xfs_zone_mark_reclaimable(
 	struct xfs_rtgroup	*rtg)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
 	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_RECLAIMABLE);
+	if (xfs_zoned_need_gc(mp))
+		wake_up_process(mp->m_zone_info->zi_gc_thread);
 }
 
 static void
@@ -278,9 +310,12 @@ xfs_zone_free_blocks(
 	if (!READ_ONCE(rtg->rtg_open_zone)) {
 		/*
 		 * If the zone is not open, mark it reclaimable when the first
-		 * block is freed.
+		 * block is freed. As an optimization kick of a zone reset if
+		 * the usage counter hits zero.
 		 */
-		if (rmapip->i_used_blocks + len == rtg_blocks(rtg))
+		if (rmapip->i_used_blocks == 0)
+			xfs_zone_emptied(rtg);
+		else if (rmapip->i_used_blocks + len == rtg_blocks(rtg))
 			xfs_zone_mark_reclaimable(rtg);
 	}
 	xfs_add_frextents(mp, len);
@@ -415,6 +450,8 @@ xfs_activate_zone(
 	atomic_inc(&oz->oz_ref);
 	zi->zi_nr_open_zones++;
 	list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
+	if (xfs_zoned_need_gc(mp))
+		wake_up_process(zi->zi_gc_thread);
 
 	/* XXX: this is a little verbose, but let's keep it for now */
 	xfs_info(mp, "using zone %u (%u)",
@@ -747,6 +784,13 @@ xfs_init_zone(
 		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 	}
 
+	if (write_pointer == rtg_blocks(rtg) && used == 0) {
+		error = xfs_zone_reset_sync(rtg);
+		if (error)
+			return error;
+		write_pointer = 0;
+	}
+
 	if (write_pointer == 0) {
 		/* zone is empty */
 		atomic_inc(&zi->zi_nr_free_zones);
@@ -954,6 +998,9 @@ xfs_mount_zones(
 	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
 		iz.available + iz.reclaimable);
 
+	error = xfs_zone_gc_mount(mp);
+	if (error)
+		goto out_free_open_zones;
 	return 0;
 
 out_free_open_zones:
@@ -966,6 +1013,7 @@ void
 xfs_unmount_zones(
 	struct xfs_mount	*mp)
 {
+	xfs_zone_gc_unmount(mp);
 	xfs_free_open_zones(mp->m_zone_info);
 	kfree(mp->m_zone_info);
 }
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index 6d0404c2c46c..44fa1594f73e 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -38,6 +38,8 @@ uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
 #ifdef CONFIG_XFS_RT
 int xfs_mount_zones(struct xfs_mount *mp);
 void xfs_unmount_zones(struct xfs_mount *mp);
+void xfs_zone_gc_start(struct xfs_mount *mp);
+void xfs_zone_gc_stop(struct xfs_mount *mp);
 #else
 static inline int xfs_mount_zones(struct xfs_mount *mp)
 {
@@ -46,6 +48,12 @@ static inline int xfs_mount_zones(struct xfs_mount *mp)
 static inline void xfs_unmount_zones(struct xfs_mount *mp)
 {
 }
+static inline void xfs_zone_gc_start(struct xfs_mount *mp)
+{
+}
+static inline void xfs_zone_gc_stop(struct xfs_mount *mp)
+{
+}
 #endif /* CONFIG_XFS_RT */
 
 #endif /* _XFS_ZONE_ALLOC_H */
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
new file mode 100644
index 000000000000..085d7001935e
--- /dev/null
+++ b/fs/xfs/xfs_zone_gc.c
@@ -0,0 +1,1045 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023-2024 Christoph Hellwig.
+ * Copyright (c) 2024, Western Digital Corporation or its affiliates.
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_trans.h"
+#include "xfs_icache.h"
+#include "xfs_rmap.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_zone_priv.h"
+#include "xfs_zones.h"
+#include "xfs_trace.h"
+
+/*
+ * Size of each GC scratch pad.  This is also the upper bound for each
+ * GC I/O, which helps to keep latency down.
+ */
+#define XFS_GC_CHUNK_SIZE	SZ_1M
+
+/*
+ * Scratchpad data to read GCed data into.
+ *
+ * The offset member tracks where the next allocation starts, and freed tracks
+ * the amount of space that is not used anymore.
+ */
+#define XFS_ZONE_GC_NR_SCRATCH	2
+struct xfs_zone_scratch {
+	struct folio			*folio;
+	unsigned int			offset;
+	unsigned int			freed;
+};
+
+/*
+ * Chunk that is read and written for each GC operation.
+ *
+ * Note that for writes to actual zoned devices, the chunk can be split when
+ * reaching the hardware limit.
+ */
+struct xfs_gc_bio {
+	struct xfs_zone_gc_data		*data;
+
+	/*
+	 * Entry into the reading/writing/resetting list.  Only accessed from
+	 * the GC thread, so no locking needed.
+	 */
+	struct list_head		entry;
+
+	/*
+	 * State of this gc_bio.  Done means the current I/O completed.
+	 * Set from the bio end I/O handler, read from the GC thread.
+	 */
+	unsigned long			state;
+#define XFS_GC_BIO_NEW			0
+#define XFS_GC_BIO_DONE			1
+
+	/*
+	 * Pointer to the inode and range of the inode that the GC is performed
+	 * for.
+	 */
+	struct xfs_inode		*ip;
+	loff_t				offset;
+	unsigned int			len;
+
+	/*
+	 * Existing startblock (in the zone to be freed) and newly assigned
+	 * daddr in the zone GCed into.
+	 */
+	xfs_fsblock_t			old_startblock;
+	xfs_daddr_t			new_daddr;
+	struct xfs_zone_scratch		*scratch;
+
+	/* Are we writing to a sequential write required zone? */
+	bool				is_seq;
+
+	/* Bio used for reads and writes, including the bvec used by it */
+	struct bio_vec			bv;
+	struct bio			bio;	/* must be last */
+};
+
+/*
+ * Per-mount GC state.
+ */
+struct xfs_zone_gc_data {
+	struct xfs_mount		*mp;
+
+	/* bioset used to allocate the gc_bios */
+	struct bio_set			bio_set;
+
+	/*
+	 * Scratchpad used, and index to indicated which one is used.
+	 */
+	struct xfs_zone_scratch		scratch[XFS_ZONE_GC_NR_SCRATCH];
+	unsigned int			scratch_idx;
+
+	/*
+	 * List of bios currently being read, written and reset.
+	 * These lists are only accessed by the GC thread itself, and must only
+	 * be processed in order.
+	 */
+	struct list_head		reading;
+	struct list_head		writing;
+	struct list_head		resetting;
+};
+
+/*
+ * We aim to keep enough zones free in stock to fully use the open zone limit
+ * for data placement purposes.
+ */
+bool
+xfs_zoned_need_gc(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
+		return false;
+	if (xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE) <
+	    mp->m_groups[XG_TYPE_RTG].blocks *
+	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
+		return true;
+	return false;
+}
+
+static struct xfs_zone_gc_data *
+xfs_zone_gc_data_alloc(
+	struct xfs_mount	*mp)
+{
+	struct xfs_zone_gc_data	*data;
+	int i;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	/*
+	 * We actually only need a single bio_vec.  It would be nice to have
+	 * a flag that only allocates the inline bvecs and not the separate
+	 * bvec pool.
+	 */
+	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
+			BIOSET_NEED_BVECS))
+		goto out_free_data;
+	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++) {
+		data->scratch[i].folio =
+			folio_alloc(GFP_KERNEL, get_order(XFS_GC_CHUNK_SIZE));
+		if (!data->scratch[i].folio)
+			goto out_free_scratch;
+	}
+	INIT_LIST_HEAD(&data->reading);
+	INIT_LIST_HEAD(&data->writing);
+	INIT_LIST_HEAD(&data->resetting);
+	data->mp = mp;
+	return data;
+
+out_free_scratch:
+	while (--i >= 0)
+		folio_put(data->scratch[i].folio);
+	bioset_exit(&data->bio_set);
+out_free_data:
+	kfree(data);
+	return NULL;
+}
+
+static void
+xfs_zone_gc_data_free(
+	struct xfs_zone_gc_data	*data)
+{
+	int			i;
+
+	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++)
+		folio_put(data->scratch[i].folio);
+	bioset_exit(&data->bio_set);
+	kfree(data);
+}
+
+#define XFS_ZONE_GC_RECS		1024
+
+/* iterator, needs to be reinitialized for each victim zone */
+struct xfs_zone_gc_iter {
+	struct xfs_rtgroup		*victim_rtg;
+	unsigned int			rec_count;
+	unsigned int			rec_idx;
+	xfs_agblock_t			next_startblock;
+	struct xfs_rmap_irec		recs[XFS_ZONE_GC_RECS];
+};
+
+static void
+xfs_zone_gc_iter_init(
+	struct xfs_zone_gc_iter	*iter,
+	struct xfs_rtgroup	*victim_rtg)
+
+{
+	iter->next_startblock = 0;
+	iter->rec_count = 0;
+	iter->rec_idx = 0;
+	iter->victim_rtg = victim_rtg;
+}
+
+static int
+xfs_zone_gc_query_cb(
+	struct xfs_btree_cur	*cur,
+	const struct xfs_rmap_irec *irec,
+	void			*private)
+{
+	struct xfs_zone_gc_iter	*iter = private;
+
+	ASSERT(!XFS_RMAP_NON_INODE_OWNER(irec->rm_owner));
+	ASSERT(!xfs_is_sb_inum(cur->bc_mp, irec->rm_owner));
+	ASSERT(!(irec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)));
+
+	iter->recs[iter->rec_count] = *irec;
+	if (++iter->rec_count == XFS_ZONE_GC_RECS) {
+		iter->next_startblock =
+			irec->rm_startblock + irec->rm_blockcount;
+		return 1;
+	}
+	return 0;
+}
+
+static int
+xfs_zone_gc_rmap_rec_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_rmap_irec	*reca = a;
+	const struct xfs_rmap_irec	*recb = b;
+	int64_t				diff;
+
+	diff = reca->rm_owner - recb->rm_owner;
+	if (!diff)
+		diff = reca->rm_offset - recb->rm_offset;
+	return clamp(diff, -1, 1);
+}
+
+static int
+xfs_zone_gc_query(
+	struct xfs_mount	*mp,
+	struct xfs_zone_gc_iter	*iter)
+{
+	struct xfs_rtgroup	*rtg = iter->victim_rtg;
+	struct xfs_rmap_irec	ri_low = { };
+	struct xfs_rmap_irec	ri_high;
+	struct xfs_btree_cur	*cur;
+	struct xfs_trans	*tp;
+	int			error;
+
+	ASSERT(iter->next_startblock <= rtg_blocks(rtg));
+	if (iter->next_startblock == rtg_blocks(rtg))
+		goto done;
+
+	ASSERT(iter->next_startblock < rtg_blocks(rtg));
+	ri_low.rm_startblock = iter->next_startblock;
+	memset(&ri_high, 0xFF, sizeof(ri_high));
+
+	iter->rec_idx = 0;
+	iter->rec_count = 0;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
+	cur = xfs_rtrmapbt_init_cursor(tp, rtg);
+	error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
+			xfs_zone_gc_query_cb, iter);
+	xfs_btree_del_cursor(cur, error < 0 ? error : 0);
+	xfs_trans_cancel(tp);
+
+	if (error < 0)
+		return error;
+
+	/*
+	 * Sort the rmap records by inode number and increasing offset to
+	 * defragment the mappings.
+	 *
+	 * This could be further enhanced by an even bigger look ahead window,
+	 * but that's better left until we have better detection of changes to
+	 * inode mapping to avoid the potential of GCing already dead data.
+	 */
+	sort(iter->recs, iter->rec_count, sizeof(iter->recs[0]),
+		xfs_zone_gc_rmap_rec_cmp, NULL);
+
+	if (error == 0) {
+		/*
+		 * We finished iterating through the zone.
+		 */
+		iter->next_startblock = rtg_blocks(rtg);
+		if (iter->rec_count == 0)
+			goto done;
+	}
+
+	return 0;
+done:
+	xfs_rtgroup_rele(iter->victim_rtg);
+	iter->victim_rtg = NULL;
+	return 0;
+}
+
+static bool
+xfs_zone_gc_iter_next(
+	struct xfs_mount	*mp,
+	struct xfs_zone_gc_iter	*iter,
+	struct xfs_rmap_irec	*chunk_rec,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_rmap_irec	*irec;
+	int			error;
+
+	if (!iter->victim_rtg)
+		return false;
+
+retry:
+	if (iter->rec_idx == iter->rec_count) {
+		error = xfs_zone_gc_query(mp, iter);
+		if (error)
+			goto fail;
+		if (!iter->victim_rtg)
+			return false;
+	}
+
+	irec = &iter->recs[iter->rec_idx];
+	error = xfs_iget(mp, NULL, irec->rm_owner,
+			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, ipp);
+	if (error) {
+		/*
+		 * If the inode was already deleted, skip over it.
+		 */
+		if (error == -ENOENT) {
+			iter->rec_idx++;
+			goto retry;
+		}
+		goto fail;
+	}
+
+	if (!S_ISREG(VFS_I(*ipp)->i_mode)) {
+		iter->rec_idx++;
+		xfs_irele(*ipp);
+		goto retry;
+	}
+
+	*chunk_rec = *irec;
+	return true;
+
+fail:
+	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+	return false;
+}
+
+static void
+xfs_zone_gc_iter_advance(
+	struct xfs_zone_gc_iter	*iter,
+	xfs_extlen_t		count_fsb)
+{
+	struct xfs_rmap_irec	*irec = &iter->recs[iter->rec_idx];
+
+	irec->rm_offset += count_fsb;
+	irec->rm_startblock += count_fsb;
+	irec->rm_blockcount -= count_fsb;
+	if (!irec->rm_blockcount)
+		iter->rec_idx++;
+}
+
+/*
+ * Iterate through all zones marked as reclaimable and find a candidate that is
+ * either good enough for instant reclaim, or the one with the least used space.
+ */
+static bool
+xfs_zone_reclaim_pick(
+	struct xfs_mount	*mp,
+	struct xfs_zone_gc_iter	*iter)
+{
+	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
+	struct xfs_rtgroup	*victim_rtg = NULL, *rtg;
+	uint32_t		victim_used = U32_MAX;
+	bool			easy = false;
+
+	if (xfs_is_shutdown(mp))
+		return false;
+
+	if (iter->victim_rtg)
+		return true;
+
+	/*
+	 * Don't start new work if we are asked to stop or park.
+	 */
+	if (kthread_should_stop() || kthread_should_park())
+		return false;
+
+	if (!xfs_zoned_need_gc(mp))
+		return false;
+
+	rcu_read_lock();
+	xas_for_each_marked(&xas, rtg, ULONG_MAX, XFS_RTG_RECLAIMABLE) {
+		u64 used = rtg_rmap(rtg)->i_used_blocks;
+
+		/* skip zones that are just waiting for a reset */
+		if (used == 0)
+			continue;
+
+		if (used >= victim_used)
+			continue;
+		if (!atomic_inc_not_zero(&rtg->rtg_group.xg_active_ref))
+			continue;
+
+		if (victim_rtg)
+			xfs_rtgroup_rele(victim_rtg);
+		victim_rtg = rtg;
+		victim_used = used;
+
+		/*
+		 * Any zone that is less than 1 percent used is fair game for
+		 * instant reclaim.
+		 */
+		if (used < div_u64(rtg_blocks(rtg), 100)) {
+			easy = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (!victim_rtg)
+		return false;
+
+	xfs_info(mp, "reclaiming zone %d, used = %u/%u (%s)",
+		rtg_rgno(victim_rtg), victim_used,
+		rtg_blocks(victim_rtg),
+		easy ? "easy" : "best");
+	trace_xfs_zone_reclaim(victim_rtg);
+	xfs_zone_gc_iter_init(iter, victim_rtg);
+	return true;
+}
+
+static struct xfs_open_zone *
+xfs_steal_open_zone_for_gc(
+	struct xfs_zone_info	*zi)
+{
+	struct xfs_open_zone	*oz, *found = NULL;
+
+	lockdep_assert_held(&zi->zi_zone_list_lock);
+
+	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry) {
+		if (!found ||
+		    oz->oz_write_pointer < found->oz_write_pointer)
+			found = oz;
+	}
+
+	if (found) {
+		found->oz_is_gc = true;
+		list_del_init(&found->oz_entry);
+		zi->zi_nr_open_zones--;
+	}
+	return found;
+}
+
+static struct xfs_open_zone *
+xfs_select_gc_zone(
+	struct xfs_mount	*mp)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
+
+	if (oz && oz->oz_write_pointer == rtg_blocks(oz->oz_rtg)) {
+		/*
+		 * We need to wait for pending writes to finish.
+		 */
+		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
+			return NULL;
+		xfs_open_zone_put(oz);
+		oz = NULL;
+	}
+
+	if (!oz) {
+		/*
+		 * If there are no free zones available for GC, pick the open
+		 * zone with the least used space to GC into.  This should
+		 * only happen after an unclean shutdown near ENOSPC while
+		 * GC was ongoing.
+		 */
+		spin_lock(&zi->zi_zone_list_lock);
+		if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE))
+			oz = xfs_steal_open_zone_for_gc(zi);
+		else
+			oz = xfs_open_zone(mp, true);
+		spin_unlock(&zi->zi_zone_list_lock);
+
+		if (oz)
+			trace_xfs_gc_zone_activate(oz->oz_rtg);
+		zi->zi_open_gc_zone = oz;
+	}
+
+	return oz;
+}
+
+static unsigned int
+xfs_zone_gc_scratch_available(
+	struct xfs_zone_gc_data	*data)
+{
+	return XFS_GC_CHUNK_SIZE - data->scratch[data->scratch_idx].offset;
+}
+
+static bool
+xfs_zone_gc_space_available(
+	struct xfs_zone_gc_data	*data)
+{
+	struct xfs_open_zone	*oz;
+
+	oz = xfs_select_gc_zone(data->mp);
+	if (!oz)
+		return false;
+	return oz->oz_write_pointer < rtg_blocks(oz->oz_rtg) &&
+		xfs_zone_gc_scratch_available(data);
+}
+
+static void
+xfs_zone_gc_end_io(
+	struct bio		*bio)
+{
+	struct xfs_gc_bio	*chunk =
+		container_of(bio, struct xfs_gc_bio, bio);
+	struct xfs_zone_gc_data	*data = chunk->data;
+
+	WRITE_ONCE(chunk->state, XFS_GC_BIO_DONE);
+	wake_up_process(data->mp->m_zone_info->zi_gc_thread);
+}
+
+static bool
+xfs_zone_gc_allocate(
+	struct xfs_zone_gc_data	*data,
+	xfs_extlen_t		*count_fsb,
+	xfs_daddr_t		*daddr,
+	bool			*is_seq)
+{
+	struct xfs_mount	*mp = data->mp;
+	struct xfs_open_zone	*oz;
+
+	oz = xfs_select_gc_zone(mp);
+	if (!oz)
+		return false;
+
+	*count_fsb = min(*count_fsb,
+		XFS_B_TO_FSB(mp, xfs_zone_gc_scratch_available(data)));
+
+	/*
+	 * Directly allocate GC blocks from the reserved pool.
+	 *
+	 * If we'd take them from the normal pool we could be stealing blocks a
+	 * regular writer, which would then have to wait for GC and deadlock.
+	 */
+	spin_lock(&mp->m_sb_lock);
+	*count_fsb = min(*count_fsb,
+			rtg_blocks(oz->oz_rtg) - oz->oz_write_pointer);
+	*count_fsb = min3(*count_fsb,
+			mp->m_resblks[XC_FREE_RTEXTENTS].avail,
+			mp->m_resblks[XC_FREE_RTAVAILABLE].avail);
+	mp->m_resblks[XC_FREE_RTEXTENTS].avail -= *count_fsb;
+	mp->m_resblks[XC_FREE_RTAVAILABLE].avail -= *count_fsb;
+	spin_unlock(&mp->m_sb_lock);
+
+	if (!*count_fsb)
+		return false;
+
+	*daddr = xfs_gbno_to_daddr(&oz->oz_rtg->rtg_group, 0);
+	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
+	if (!*is_seq)
+		*daddr += XFS_FSB_TO_BB(mp, oz->oz_write_pointer);
+	oz->oz_write_pointer += *count_fsb;
+	return true;
+}
+
+static bool
+xfs_zone_gc_start_chunk(
+	struct xfs_zone_gc_data	*data,
+	struct xfs_zone_gc_iter	*iter)
+{
+	struct xfs_mount	*mp = data->mp;
+	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
+	struct xfs_rmap_irec	irec;
+	struct xfs_gc_bio	*chunk;
+	struct xfs_inode	*ip;
+	struct bio		*bio;
+	xfs_daddr_t		daddr;
+	bool			is_seq;
+
+	if (xfs_is_shutdown(mp))
+		return false;
+
+	if (!xfs_zone_gc_iter_next(mp, iter, &irec, &ip))
+		return false;
+	if (!xfs_zone_gc_allocate(data, &irec.rm_blockcount, &daddr, &is_seq)) {
+		xfs_irele(ip);
+		return false;
+	}
+
+	bio = bio_alloc_bioset(bdev, 1, REQ_OP_READ, GFP_NOFS, &data->bio_set);
+
+	chunk = container_of(bio, struct xfs_gc_bio, bio);
+	chunk->ip = ip;
+	chunk->offset = XFS_FSB_TO_B(mp, irec.rm_offset);
+	chunk->len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
+	chunk->old_startblock =
+		xfs_rgbno_to_rtb(iter->victim_rtg, irec.rm_startblock);
+	chunk->new_daddr = daddr;
+	chunk->is_seq = is_seq;
+	chunk->scratch = &data->scratch[data->scratch_idx];
+	chunk->data = data;
+
+	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
+	bio->bi_end_io = xfs_zone_gc_end_io;
+	bio_add_folio_nofail(bio, chunk->scratch->folio, chunk->len,
+			chunk->scratch->offset);
+	chunk->scratch->offset += chunk->len;
+	if (chunk->scratch->offset == XFS_GC_CHUNK_SIZE) {
+		data->scratch_idx =
+			(data->scratch_idx + 1) % XFS_ZONE_GC_NR_SCRATCH;
+	}
+	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
+	list_add_tail(&chunk->entry, &data->reading);
+	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
+
+	submit_bio(bio);
+	return true;
+}
+
+static void
+xfs_zone_gc_free_chunk(
+	struct xfs_gc_bio	*chunk)
+{
+	list_del(&chunk->entry);
+	xfs_irele(chunk->ip);
+	bio_put(&chunk->bio);
+}
+
+static void
+xfs_gc_submit_write(
+	struct xfs_zone_gc_data	*data,
+	struct xfs_gc_bio	*chunk)
+{
+	if (chunk->is_seq) {
+		chunk->bio.bi_opf &= ~REQ_OP_WRITE;
+		chunk->bio.bi_opf |= REQ_OP_ZONE_APPEND;
+	}
+	chunk->bio.bi_iter.bi_sector = chunk->new_daddr;
+	chunk->bio.bi_end_io = xfs_zone_gc_end_io;
+	submit_bio(&chunk->bio);
+}
+
+static struct xfs_gc_bio *
+xfs_gc_split_write(
+	struct xfs_zone_gc_data	*data,
+	struct xfs_gc_bio	*chunk)
+{
+	struct queue_limits	*lim =
+		&bdev_get_queue(chunk->bio.bi_bdev)->limits;
+	struct xfs_gc_bio	*split_chunk;
+	int			split_sectors;
+	unsigned int		split_len;
+	struct bio		*split;
+	unsigned int		nsegs;
+
+	if (!chunk->is_seq)
+		return NULL;
+
+	split_sectors = bio_split_rw_at(&chunk->bio, lim, &nsegs,
+			lim->max_zone_append_sectors << SECTOR_SHIFT);
+	if (!split_sectors)
+		return NULL;
+	split_len = split_sectors << SECTOR_SHIFT;
+
+	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS, &data->bio_set);
+	split_chunk = container_of(split, struct xfs_gc_bio, bio);
+	split_chunk->data = data;
+	ihold(VFS_I(chunk->ip));
+	split_chunk->ip = chunk->ip;
+	split_chunk->is_seq = chunk->is_seq;
+	split_chunk->scratch = chunk->scratch;
+	split_chunk->offset = chunk->offset;
+	split_chunk->len = split_len;
+	split_chunk->old_startblock = chunk->old_startblock;
+	split_chunk->new_daddr = chunk->new_daddr;
+
+	chunk->offset += split_len;
+	chunk->len -= split_len;
+	chunk->old_startblock += XFS_B_TO_FSB(data->mp, split_len);
+
+	/* add right before the original chunk */
+	WRITE_ONCE(split_chunk->state, XFS_GC_BIO_NEW);
+	list_add_tail(&split_chunk->entry, &chunk->entry);
+	return split_chunk;
+}
+
+static void
+xfs_zone_gc_write_chunk(
+	struct xfs_gc_bio	*chunk)
+{
+	struct xfs_zone_gc_data	*data = chunk->data;
+	struct xfs_mount	*mp = chunk->ip->i_mount;
+	unsigned int		folio_offset = chunk->bio.bi_io_vec->bv_offset;
+	struct xfs_gc_bio	*split_chunk;
+
+	if (chunk->bio.bi_status)
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+	if (xfs_is_shutdown(mp)) {
+		xfs_zone_gc_free_chunk(chunk);
+		return;
+	}
+
+	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
+	list_move_tail(&chunk->entry, &data->writing);
+
+	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
+	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
+			folio_offset);
+
+	while ((split_chunk = xfs_gc_split_write(data, chunk)))
+		xfs_gc_submit_write(data, split_chunk);
+	xfs_gc_submit_write(data, chunk);
+}
+
+static void
+xfs_zone_gc_finish_chunk(
+	struct xfs_gc_bio	*chunk)
+{
+	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	struct xfs_inode	*ip = chunk->ip;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	if (chunk->bio.bi_status)
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+	if (xfs_is_shutdown(mp)) {
+		xfs_zone_gc_free_chunk(chunk);
+		return;
+	}
+
+	chunk->scratch->freed += chunk->len;
+	if (chunk->scratch->freed == chunk->scratch->offset) {
+		chunk->scratch->offset = 0;
+		chunk->scratch->freed = 0;
+	}
+
+	/*
+	 * Cycle through the iolock and wait for direct I/O and layouts to
+	 * ensure no one is reading from the old mapping before it goes away.
+	 */
+	xfs_ilock(ip, iolock);
+	error = xfs_break_layouts(VFS_I(ip), &iolock, BREAK_UNMAP);
+	if (!error)
+		inode_dio_wait(VFS_I(ip));
+	xfs_iunlock(ip, iolock);
+	if (error)
+		goto free;
+
+	if (chunk->is_seq)
+		chunk->new_daddr = chunk->bio.bi_iter.bi_sector;
+	error = xfs_zoned_end_io(ip, chunk->offset, chunk->len,
+			chunk->new_daddr, chunk->old_startblock);
+free:
+	if (error)
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+	xfs_zone_gc_free_chunk(chunk);
+}
+
+static void
+xfs_zone_gc_finish_reset(
+	struct xfs_gc_bio	*chunk)
+{
+	struct xfs_rtgroup	*rtg = chunk->bio.bi_private;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+
+	if (chunk->bio.bi_status) {
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		goto out;
+	}
+
+	spin_lock(&zi->zi_zone_list_lock);
+	atomic_inc(&zi->zi_nr_free_zones);
+	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
+	spin_unlock(&zi->zi_zone_list_lock);
+
+	xfs_zoned_add_available(mp, rtg_blocks(rtg));
+
+	wake_up_all(&zi->zi_zone_wait);
+out:
+	list_del(&chunk->entry);
+	bio_put(&chunk->bio);
+}
+
+static bool
+xfs_prepare_zone_reset(
+	struct bio		*bio,
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_zone_reset(rtg);
+
+	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
+	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
+	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
+		if (!bdev_max_discard_sectors(bio->bi_bdev))
+			return false;
+		bio->bi_opf = REQ_OP_DISCARD | REQ_SYNC;
+		bio->bi_iter.bi_size =
+			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
+	}
+
+	return true;
+}
+
+int
+xfs_zone_reset_sync(
+	struct xfs_rtgroup	*rtg)
+{
+	int			error = 0;
+	struct bio		bio;
+
+	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
+			REQ_OP_ZONE_RESET);
+	if (xfs_prepare_zone_reset(&bio, rtg))
+		error = submit_bio_wait(&bio);
+	bio_uninit(&bio);
+
+	return error;
+}
+
+static void
+xfs_reset_zones(
+	struct xfs_zone_gc_data	*data,
+	struct xfs_group	*reset_list)
+{
+	struct xfs_group	*next = reset_list;
+
+	if (blkdev_issue_flush(data->mp->m_rtdev_targp->bt_bdev) < 0) {
+		xfs_force_shutdown(data->mp, SHUTDOWN_META_IO_ERROR);
+		return;
+	}
+
+	do {
+		struct xfs_rtgroup	*rtg = to_rtg(next);
+		struct xfs_gc_bio	*chunk;
+		struct bio		*bio;
+
+		xfs_log_force_inode(rtg_rmap(rtg));
+
+		next = rtg_group(rtg)->xg_next_reset;
+		rtg_group(rtg)->xg_next_reset = NULL;
+
+		bio = bio_alloc_bioset(rtg_mount(rtg)->m_rtdev_targp->bt_bdev,
+				0, REQ_OP_ZONE_RESET, GFP_NOFS, &data->bio_set);
+		bio->bi_private = rtg;
+		bio->bi_end_io = xfs_zone_gc_end_io;
+
+		chunk = container_of(bio, struct xfs_gc_bio, bio);
+		chunk->data = data;
+		WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
+		list_add_tail(&chunk->entry, &data->resetting);
+	
+		/*
+		 * Also use the bio to drive the state machine when neither
+		 * zone reset nor discard is supported to keep things simple.
+		 */
+		if (xfs_prepare_zone_reset(bio, rtg))
+			submit_bio(bio);
+		else
+			bio_endio(bio);
+	} while (next);
+}
+
+/*
+ * Handle the work to read and write data for GC and to reset the zones,
+ * including handling all completions.
+ *
+ * Note that the order of the chunks is preserved so that we don't undo the
+ * optimal order established by xfs_zone_gc_query().
+ */
+static bool
+xfs_zone_gc_handle_work(
+	struct xfs_zone_gc_data	*data,
+	struct xfs_zone_gc_iter	*iter)
+{
+	struct xfs_zone_info	*zi = data->mp->m_zone_info;
+	struct xfs_gc_bio	*chunk, *next;
+	struct xfs_group	*reset_list;
+	struct blk_plug		plug;
+
+	spin_lock(&zi->zi_reset_list_lock);
+	reset_list = zi->zi_reset_list;
+	zi->zi_reset_list = NULL;
+	spin_unlock(&zi->zi_reset_list_lock);
+
+	if (!xfs_zone_reclaim_pick(data->mp, iter) ||
+	    !xfs_zone_gc_space_available(data)) {
+		if (list_empty(&data->reading) &&
+		    list_empty(&data->writing) &&
+		    list_empty(&data->resetting) &&
+		    !reset_list)
+			return false;
+	}
+
+	__set_current_state(TASK_RUNNING);
+	try_to_freeze();
+
+	if (reset_list)
+		xfs_reset_zones(data, reset_list);
+
+	list_for_each_entry_safe(chunk, next, &data->resetting, entry) {
+		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
+			break;
+		xfs_zone_gc_finish_reset(chunk);
+	}
+
+	list_for_each_entry_safe(chunk, next, &data->writing, entry) {
+		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
+			break;
+		xfs_zone_gc_finish_chunk(chunk);
+	}
+
+	blk_start_plug(&plug);
+	list_for_each_entry_safe(chunk, next, &data->reading, entry) {
+		if (READ_ONCE(chunk->state) != XFS_GC_BIO_DONE)
+			break;
+		xfs_zone_gc_write_chunk(chunk);
+	}
+	blk_finish_plug(&plug);
+
+	blk_start_plug(&plug);
+	while (xfs_zone_gc_start_chunk(data, iter))
+		;
+	blk_finish_plug(&plug);
+	return true;
+}
+
+/*
+ * Note that the current GC algorithm would break reflinks and thus duplicate
+ * data that was shared by multiple owners before.  Because of that reflinks
+ * are currently not supported on zoned file systems and can't be created or
+ * mounted.
+ */
+static int
+xfs_zoned_gcd(
+	void			*private)
+{
+	struct xfs_mount	*mp = private;
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	unsigned int		nofs_flag;
+	struct xfs_zone_gc_data	*data;
+	struct xfs_zone_gc_iter	*iter;
+
+	data = xfs_zone_gc_data_alloc(mp);
+	if (!data)
+		return -ENOMEM;
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		goto out_free_data;
+
+	nofs_flag = memalloc_nofs_save();
+	set_freezable();
+
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
+		xfs_set_in_gc(mp);
+		if (xfs_zone_gc_handle_work(data, iter))
+			continue;
+
+		if (list_empty(&data->reading) &&
+		    list_empty(&data->writing) &&
+		    list_empty(&data->resetting) &&
+		    !zi->zi_reset_list) {
+			xfs_clear_in_gc(mp);
+			xfs_zoned_resv_wake_all(mp);
+
+			if (kthread_should_stop()) {
+				__set_current_state(TASK_RUNNING);
+				break;
+			}
+
+			if (kthread_should_park()) {
+				__set_current_state(TASK_RUNNING);
+				kthread_parkme();
+				continue;
+			}
+		}
+
+		schedule();
+	}
+	xfs_clear_in_gc(mp);
+
+	if (iter->victim_rtg)
+		xfs_rtgroup_rele(iter->victim_rtg);
+	if (zi->zi_open_gc_zone)
+		xfs_open_zone_put(zi->zi_open_gc_zone);
+
+	memalloc_nofs_restore(nofs_flag);
+	kfree(iter);
+out_free_data:
+	xfs_zone_gc_data_free(data);
+	return 0;
+}
+
+void
+xfs_zone_gc_start(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_zoned(mp))
+		kthread_unpark(mp->m_zone_info->zi_gc_thread);
+}
+
+void
+xfs_zone_gc_stop(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_zoned(mp))
+		kthread_park(mp->m_zone_info->zi_gc_thread);
+}
+
+int
+xfs_zone_gc_mount(
+	struct xfs_mount	*mp)
+{
+	mp->m_zone_info->zi_gc_thread = kthread_create(xfs_zoned_gcd, mp,
+			"xfs-zone-gc/%s", mp->m_super->s_id);
+	if (IS_ERR(mp->m_zone_info->zi_gc_thread)) {
+		xfs_warn(mp, "unable to create zone gc thread");
+		return PTR_ERR(mp->m_zone_info->zi_gc_thread);
+	}
+
+	/* xfs_zone_gc_start will unpark for rw mounts */
+	kthread_park(mp->m_zone_info->zi_gc_thread);
+	return 0;
+}
+
+void
+xfs_zone_gc_unmount(
+	struct xfs_mount	*mp)
+{
+	kthread_stop(mp->m_zone_info->zi_gc_thread);
+}
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index f56f3ca8ea00..0b720026e54a 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -82,6 +82,11 @@ struct xfs_zone_info {
 
 struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
 
+int xfs_zone_reset_sync(struct xfs_rtgroup *rtg);
+bool xfs_zoned_need_gc(struct xfs_mount *mp);
+int xfs_zone_gc_mount(struct xfs_mount *mp);
+void xfs_zone_gc_unmount(struct xfs_mount *mp);
+
 void xfs_zoned_resv_wake_all(struct xfs_mount *mp);
 
 #endif /* _XFS_ZONE_PRIV_H */
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 5ee525e18759..77211f4c7033 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -159,6 +159,13 @@ xfs_zoned_reserve_available(
 		if (error != -ENOSPC)
 			break;
 
+		/*
+		 * If there is nothing left to reclaim, give up.
+		 */
+		if (!xfs_is_in_gc(mp) &&
+		    !xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
+			break;
+
 		spin_unlock(&zi->zi_reservation_lock);
 		schedule();
 		spin_lock(&zi->zi_reservation_lock);
-- 
2.45.2

