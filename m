Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8243522654D
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824383; cv=none; b=qjDT2vwv74YJ8QvGAsLNX5NL6XpzE3WsUgybNAk98Tae4pUrUhJ3qkz4VSiXp4w069VF8nmOZrlNiNroVUqf7eOlJueIloae6ejGlMiS2qcNo7KOdkNXhKsTNPpkaTEAN7Gxr6yONP4mvEPHsqnKbzZfLKGWsmFJiHu8lAK3OGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824383; c=relaxed/simple;
	bh=UOeFDUHHNmFUrn5LZn0e2rvFnlCQbPe8gjnA1zU8bd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3d8psCPr3L+KcUVUWf0H5wjZhzN07GHe8K6vuTx3MiaBGFmL7B4w2dRtFo6r2R5FND+KtBUjVSyA0zLiCYZ9fnwD8gLMwgn6vk3HJdX2jJQuV9bCZsGa3sRYuas/NUGsh+eVsWdWnqJCw9A+vs22n0ghUBwvd6UFik1XsuZnyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lzKqnQEG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lzKqnQEG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OUCdd/fMvat9TK7P44ce5ZWUMsTQmCCGRbSh2fg3kZI=; b=lzKqnQEGr5IcTTp+9bz9JhrYz3
	RRXu29f6yMjl0TlCt0PyRW7W97S7lno66P3kNEBXj9dlgC6zSQ3cXlDEU0OraG04r2Ds6Lou0oAUD
	b5guTWhERk5B0BenzHVsTO99f5SMnx0b1vaYfpS/8RhFrULe9/ekaBspxcpo0A6pRCZBg9g2QxWrU
	bKCYRXT/5WqHXy0B5CoWsCWRabidHb4orHGBt4Pduu0ty8nJQNccRcC8ugZE434VYIHLUC5gMol6O
	YJPEn2RmHhL+0COlaO7nl7Z9MO2DpGUrgg9VMZ54IE/ZSsLOpZTjg2QycmCQ2TRgwM93UK+JRG0lx
	+jet/WtQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveW-00000005QS2-3ZJ2;
	Thu, 06 Feb 2025 06:46:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 23/43] xfs: add support for zoned space reservations
Date: Thu,  6 Feb 2025 07:44:39 +0100
Message-ID: <20250206064511.2323878-24-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For zoned file systems garbage collection (GC) has to take the iolock
and mmaplock after moving data to a new place to synchronize with
readers.  This means waiting for garbage collection with the iolock can
deadlock.

To avoid this, the worst case required blocks have to be reserved before
taking the iolock, which is done using a new RTAVAILABLE counter that
tracks blocks that are free to write into and don't require garbage
collection.  The new helpers try to take these available blocks, and
if there aren't enough available it wakes and waits for GC.  This is
done using a list of on-stack reservations to ensure fairness.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile              |   3 +-
 fs/xfs/libxfs/xfs_bmap.c     |  15 ++-
 fs/xfs/xfs_mount.c           |  35 ++---
 fs/xfs/xfs_zone_alloc.h      |  27 ++++
 fs/xfs/xfs_zone_priv.h       |   2 +
 fs/xfs/xfs_zone_space_resv.c | 244 +++++++++++++++++++++++++++++++++++
 6 files changed, 306 insertions(+), 20 deletions(-)
 create mode 100644 fs/xfs/xfs_zone_space_resv.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 28bd2627e9ef..bdedf4bdb1db 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -138,7 +138,8 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
-				   xfs_zone_alloc.o
+				   xfs_zone_alloc.o \
+				   xfs_zone_space_resv.o
 
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 522c126e52fb..63255820b58a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -40,6 +40,7 @@
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -4788,12 +4789,18 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	fdblocks = da_diff;
 
-	if (bflags & XFS_BMAPI_REMAP)
+	if (bflags & XFS_BMAPI_REMAP) {
 		;
-	else if (isrt)
-		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
-	else
+	} else if (isrt) {
+		xfs_rtbxlen_t	rtxlen;
+
+		rtxlen = xfs_blen_to_rtbxlen(mp, del->br_blockcount);
+		if (xfs_is_zoned_inode(ip))
+			xfs_zoned_add_available(mp, rtxlen);
+		xfs_add_frextents(mp, rtxlen);
+	} else {
 		fdblocks += del->br_blockcount;
+	}
 
 	xfs_add_fdblocks(mp, fdblocks);
 	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 06e34c43cc94..2b8b392a7336 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -476,22 +476,27 @@ xfs_default_resblks(
 	struct xfs_mount	*mp,
 	enum xfs_free_counter	ctr)
 {
-	uint64_t resblks;
-
-	if (ctr == XC_FREE_RTEXTENTS)
+	switch (ctr) {
+	case XC_FREE_BLOCKS:
+		/*
+		 * Default to 5% or 8192 FSBs of space reserved, whichever is
+		 * smaller.
+		 *
+		 * This is intended to cover concurrent allocation transactions
+		 * when we initially hit ENOSPC.  These each require a 4 block
+		 * reservation. Hence by default we cover roughly 2000
+		 * concurrent allocation reservations.
+		 */
+		return min(div_u64(mp->m_sb.sb_dblocks, 20), 8192ULL);
+	case XC_FREE_RTEXTENTS:
+	case XC_FREE_RTAVAILABLE:
+		if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp))
+			return xfs_zoned_default_resblks(mp, ctr);
 		return 0;
-
-	/*
-	 * We default to 5% or 8192 fsbs of space reserved, whichever is
-	 * smaller.  This is intended to cover concurrent allocation
-	 * transactions when we initially hit enospc. These each require a 4
-	 * block reservation. Hence by default we cover roughly 2000 concurrent
-	 * allocation reservations.
-	 */
-	resblks = mp->m_sb.sb_dblocks;
-	do_div(resblks, 20);
-	resblks = min_t(uint64_t, resblks, 8192);
-	return resblks;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 /* Ensure the summary counts are correct. */
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index 78cd7bfc6ac8..28c9cffb72d5 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -5,6 +5,30 @@
 struct iomap_ioend;
 struct xfs_open_zone;
 
+struct xfs_zone_alloc_ctx {
+	struct xfs_open_zone	*open_zone;
+	xfs_filblks_t		reserved_blocks;
+};
+
+/*
+ * Grab any available space, even if it is less than what the caller asked for.
+ */
+#define XFS_ZR_GREEDY		(1U << 0)
+/*
+ * Only grab instantly available space, don't wait or GC.
+ */
+#define XFS_ZR_NOWAIT		(1U << 1)
+/*
+ * Dip into the reserved pool.
+ */
+#define XFS_ZR_RESERVED		(1U << 2)
+
+int xfs_zoned_space_reserve(struct xfs_inode *ip, xfs_filblks_t count_fsb,
+		unsigned int flags, struct xfs_zone_alloc_ctx *ac);
+void xfs_zoned_space_unreserve(struct xfs_inode *ip,
+		struct xfs_zone_alloc_ctx *ac);
+void xfs_zoned_add_available(struct xfs_mount *mp, xfs_filblks_t count_fsb);
+
 void xfs_zone_alloc_and_submit(struct iomap_ioend *ioend,
 		struct xfs_open_zone **oz);
 int xfs_zone_free_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
@@ -18,6 +42,9 @@ void xfs_zoned_wake_all(struct xfs_mount *mp);
 bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
 void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
 
+uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
+		enum xfs_free_counter ctr);
+
 #ifdef CONFIG_XFS_RT
 int xfs_mount_zones(struct xfs_mount *mp);
 void xfs_unmount_zones(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index 23d2fd6088ae..5283d77482d4 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -86,4 +86,6 @@ struct xfs_zone_info {
 
 struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
 
+void xfs_zoned_resv_wake_all(struct xfs_mount *mp);
+
 #endif /* _XFS_ZONE_PRIV_H */
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
new file mode 100644
index 000000000000..eff9be026425
--- /dev/null
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023-2025 Christoph Hellwig.
+ * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_zone_priv.h"
+#include "xfs_zones.h"
+
+/*
+ * Note: the zoned allocator does not support a rtextsize > 1, so this code and
+ * the allocator itself uses file system blocks interchangeable with realtime
+ * extents without doing the otherwise required conversions.
+ */
+
+/*
+ * Per-task space reservation.
+ *
+ * Tasks that need to wait for GC to free up space allocate one of these
+ * on-stack and adds it to the per-mount zi_reclaim_reservations lists.
+ * The GC thread will then wake the tasks in order when space becomes available.
+ */
+struct xfs_zone_reservation {
+	struct list_head	entry;
+	struct task_struct	*task;
+	xfs_filblks_t		count_fsb;
+};
+
+/*
+ * Calculate the number of reserved blocks.
+ *
+ * XC_FREE_RTEXTENTS counts the user available capacity, to which the file
+ * system can be filled, while XC_FREE_RTAVAILABLE counts the blocks instantly
+ * available for writes without waiting for GC.
+ *
+ * For XC_FREE_RTAVAILABLE only the smaller reservation required for GC and
+ * block zeroing is excluded from the user capacity, while XC_FREE_RTEXTENTS
+ * is further restricted by at least one zone as well as the optional
+ * persistently reserved blocks.  This allows the allocator to run more
+ * smoothly by not always triggering GC.
+ */
+uint64_t
+xfs_zoned_default_resblks(
+	struct xfs_mount	*mp,
+	enum xfs_free_counter	ctr)
+{
+	switch (ctr) {
+	case XC_FREE_RTEXTENTS:
+		return (uint64_t)XFS_RESERVED_ZONES *
+			mp->m_groups[XG_TYPE_RTG].blocks +
+			mp->m_sb.sb_rtreserved;
+	case XC_FREE_RTAVAILABLE:
+		return (uint64_t)XFS_GC_ZONES *
+			mp->m_groups[XG_TYPE_RTG].blocks;
+	default:
+		ASSERT(0);
+		return 0;
+	}
+}
+
+void
+xfs_zoned_resv_wake_all(
+	struct xfs_mount		*mp)
+{
+	struct xfs_zone_info		*zi = mp->m_zone_info;
+	struct xfs_zone_reservation	*reservation;
+
+	spin_lock(&zi->zi_reservation_lock);
+	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry)
+		wake_up_process(reservation->task);
+	spin_unlock(&zi->zi_reservation_lock);
+}
+
+void
+xfs_zoned_add_available(
+	struct xfs_mount		*mp,
+	xfs_filblks_t			count_fsb)
+{
+	struct xfs_zone_info		*zi = mp->m_zone_info;
+	struct xfs_zone_reservation	*reservation;
+
+	if (list_empty_careful(&zi->zi_reclaim_reservations)) {
+		xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
+		return;
+	}
+
+	spin_lock(&zi->zi_reservation_lock);
+	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
+	count_fsb = xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE);
+	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry) {
+		if (reservation->count_fsb > count_fsb)
+			break;
+		wake_up_process(reservation->task);
+		count_fsb -= reservation->count_fsb;
+
+	}
+	spin_unlock(&zi->zi_reservation_lock);
+}
+
+static int
+xfs_zoned_space_wait_error(
+	struct xfs_mount		*mp)
+{
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+	if (fatal_signal_pending(current))
+		return -EINTR;
+	return 0;
+}
+
+static int
+xfs_zoned_reserve_available(
+	struct xfs_inode		*ip,
+	xfs_filblks_t			count_fsb,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_zone_info		*zi = mp->m_zone_info;
+	struct xfs_zone_reservation	reservation = {
+		.task		= current,
+		.count_fsb	= count_fsb,
+	};
+	int				error;
+
+	/*
+	 * If there are no waiters, try to directly grab the available blocks
+	 * from the percpu counter.
+	 *
+	 * If the caller wants to dip into the reserved pool also bypass the
+	 * wait list.  This relies on the fact that we have a very graciously
+	 * sized reserved pool that always has enough space.  If the reserved
+	 * allocations fail we're in trouble.
+	 */
+	if (likely(list_empty_careful(&zi->zi_reclaim_reservations) ||
+	    (flags & XFS_ZR_RESERVED))) {
+		error = xfs_dec_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb,
+				flags & XFS_ZR_RESERVED);
+		if (error != -ENOSPC)
+			return error;
+	}
+
+	if (flags & XFS_ZR_NOWAIT)
+		return -EAGAIN;
+
+	spin_lock(&zi->zi_reservation_lock);
+	list_add_tail(&reservation.entry, &zi->zi_reclaim_reservations);
+	while ((error = xfs_zoned_space_wait_error(mp)) == 0) {
+		set_current_state(TASK_KILLABLE);
+
+		error = xfs_dec_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb,
+				flags & XFS_ZR_RESERVED);
+		if (error != -ENOSPC)
+			break;
+
+		spin_unlock(&zi->zi_reservation_lock);
+		schedule();
+		spin_lock(&zi->zi_reservation_lock);
+	}
+	list_del(&reservation.entry);
+	spin_unlock(&zi->zi_reservation_lock);
+
+	__set_current_state(TASK_RUNNING);
+	return error;
+}
+
+/*
+ * Implement greedy space allocation for short writes by trying to grab all
+ * that is left after locking out other threads from trying to do the same.
+ *
+ * This isn't exactly optimal and can hopefully be replaced by a proper
+ * percpu_counter primitive one day.
+ */
+static int
+xfs_zoned_reserve_extents_greedy(
+	struct xfs_inode		*ip,
+	xfs_filblks_t			*count_fsb,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_zone_info		*zi = mp->m_zone_info;
+	s64				len = *count_fsb;
+	int				error = -ENOSPC;
+
+	spin_lock(&zi->zi_reservation_lock);
+	len = min(len, xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
+	if (len > 0) {
+		*count_fsb = len;
+		error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, *count_fsb,
+				flags & XFS_ZR_RESERVED);
+	}
+	spin_unlock(&zi->zi_reservation_lock);
+	return error;
+}
+
+int
+xfs_zoned_space_reserve(
+	struct xfs_inode		*ip,
+	xfs_filblks_t			count_fsb,
+	unsigned int			flags,
+	struct xfs_zone_alloc_ctx	*ac)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	int				error;
+
+	ASSERT(ac->reserved_blocks == 0);
+	ASSERT(ac->open_zone == NULL);
+
+	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
+			flags & XFS_ZR_RESERVED);
+	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
+		error = xfs_zoned_reserve_extents_greedy(ip, &count_fsb, flags);
+	if (error)
+		return error;
+
+	error = xfs_zoned_reserve_available(ip, count_fsb, flags);
+	if (error) {
+		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb);
+		return error;
+	}
+	ac->reserved_blocks = count_fsb;
+	return 0;
+}
+
+void
+xfs_zoned_space_unreserve(
+	struct xfs_inode		*ip,
+	struct xfs_zone_alloc_ctx	*ac)
+{
+	if (ac->reserved_blocks > 0) {
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_zoned_add_available(mp, ac->reserved_blocks);
+		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, ac->reserved_blocks);
+	}
+	if (ac->open_zone)
+		xfs_open_zone_put(ac->open_zone);
+}
-- 
2.45.2

