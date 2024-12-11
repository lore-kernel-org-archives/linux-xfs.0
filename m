Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B931F2360
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907467; cv=none; b=n/QbwDRJfgnbcU7J3mk2yU8DrETcMj9UnXitNZDnkAY3BZDlhxzWTmuml5WZrF9X4yIxTxtY/rssLzYdoETLqQy36hTiVQJCK5ML0frUah+8FQMLqmHG9nOdBT4eXU49AzbpMm/xbmXw1q6RA/qVK3705/97gjQQp2EXzLoBv/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907467; c=relaxed/simple;
	bh=JV+zrYjVDgTWXdvktiUYleJdqgE1jMzZVFNcEgB+NtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONIlnxiJMQaPwX3ESD1Ea5twdO0ClVcW1yL5SW7pN0eNQe+hpBviRgPx2HFmeT6MWC8Ru/jRJPufXEj85/hCWMjFN5F/L3AyO0A0OGjTCDJtGkJcBjNLXZiPwGIs99kzbWZqV4TmQEVvmDcq7ePF6MvygA4gWTYkR5M596CClSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FWwStP3W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FWwStP3W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J/JGFq1YyTnZZRvmxzCR7Z+scMkTEfeY/w10B0oYfDM=; b=FWwStP3WcCq6bU479K0HjCBMmn
	TgPQVpq55n+AwQSnfuhxV3L9G5RKH2yvliVnj9ZOjKu8zluoGAU6v1H4+u4o7khw0Pf4+swSBo1/s
	zHCfzWb8yzJh2y7Fey+8325wyY2Zsi14O6Tz01sJKnfvDCD+Da/zuD8KEUlzYfUiRSdOiTeVzv7aM
	SXmsV9qA5vb/05nr6pev6WwNgzWwsf7x1JDi0lj4pDeJVJkcRgMFlsUJwb4iLKehJjRMVXg65XRVe
	a6dKBDj2jE3BXcMMCvvV4gQLhZOR9Tjh21U2PDPE03air1kGeTNLwB8sNABkKmmFNUj66VlN88eLR
	wdF7IFQg==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXQ-0000000EJI7-07sp;
	Wed, 11 Dec 2024 08:57:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 24/43] xfs: add the zoned space allocator
Date: Wed, 11 Dec 2024 09:54:49 +0100
Message-ID: <20241211085636.1380516-25-hch@lst.de>
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

For zoned RT devices space is always allocated at the write pointer, that
is right after the last written block and only recorded on I/O completion.

Because the actual allocation algorithm is very simple and just involves
picking a good zone - preferably the one used for the last write to the
inode.  As the number of zones that can written at the same time is
usually limited by the hardware, selecting a zone is done as late as
possible from the iomap dio and buffered writeback bio submissions
helpers just before submitting the bio.

Given that the writers already took a reservation before acquiring the
iolock, space will always be readily available if an open zone slot is
available.  A new structure is used to track these open zones, and
pointed to by the xfs_rtgroup.  Because zoned file systems don't have
a rsum cache the space for that pointer can be reused.

Allocations are only recorded at I/O completion time.  The scheme used
for that is very similar to the reflink COW end I/O path.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile             |   3 +-
 fs/xfs/libxfs/xfs_rtgroup.h |  28 +-
 fs/xfs/xfs_log.c            |   4 +
 fs/xfs/xfs_mount.c          |  52 +-
 fs/xfs/xfs_mount.h          |   3 +
 fs/xfs/xfs_rtalloc.c        |   6 +-
 fs/xfs/xfs_trace.c          |   2 +
 fs/xfs/xfs_trace.h          |  96 ++++
 fs/xfs/xfs_zone_alloc.c     | 971 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_zone_alloc.h     |  36 ++
 fs/xfs/xfs_zone_priv.h      |  85 ++++
 11 files changed, 1262 insertions(+), 24 deletions(-)
 create mode 100644 fs/xfs/xfs_zone_alloc.c
 create mode 100644 fs/xfs/xfs_zone_alloc.h
 create mode 100644 fs/xfs/xfs_zone_priv.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ea8e66c1e969..28bd2627e9ef 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -137,7 +137,8 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 				   xfs_quotaops.o
 
 # xfs_rtbitmap is shared with libxfs
-xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
+xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
+				   xfs_zone_alloc.o
 
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index d4c15c706b17..85d8d329d417 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -37,15 +37,33 @@ struct xfs_rtgroup {
 	xfs_rtxnum_t		rtg_extents;
 
 	/*
-	 * Cache of rt summary level per bitmap block with the invariant that
-	 * rtg_rsum_cache[bbno] > the maximum i for which rsum[i][bbno] != 0,
-	 * or 0 if rsum[i][bbno] == 0 for all i.
-	 *
+	 * For bitmap based RT devices this points to a cache of rt summary
+	 * level per bitmap block with the invariant that rtg_rsum_cache[bbno]
+	 * > the maximum i for which rsum[i][bbno] != 0, or 0 if
+	 * rsum[i][bbno] == 0 for all i.
 	 * Reads and writes are serialized by the rsumip inode lock.
+	 *
+	 * For zoned RT devices this points to the open zone structure for
+	 * a group that is open for writers, or is NULL.
 	 */
-	uint8_t			*rtg_rsum_cache;
+	union {
+		uint8_t			*rtg_rsum_cache;
+		struct xfs_open_zone	*rtg_open_zone;
+	};
 };
 
+/*
+ * For zoned RT devices this is set on groups that have no written blocks
+ * and can be picked by the allocator for opening.
+ */
+#define XFS_RTG_FREE			XA_MARK_0
+
+/*
+ * For zoned RT devices this is set on groups that are fully written and that
+ * have unused blocks.  Used by the garbage collection to pick targets.
+ */
+#define XFS_RTG_RECLAIMABLE		XA_MARK_1
+
 static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
 {
 	return container_of(xg, struct xfs_rtgroup, rtg_group);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 05daad8a8d34..a3c3ab0f3e15 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -20,6 +20,7 @@
 #include "xfs_sysfs.h"
 #include "xfs_sb.h"
 #include "xfs_health.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache	*xfs_log_ticket_cache;
 
@@ -3542,6 +3543,9 @@ xlog_force_shutdown(
 	spin_unlock(&log->l_icloglock);
 
 	wake_up_var(&log->l_opstate);
+	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(log->l_mp))
+		xfs_zoned_wake_all(log->l_mp);
+
 	return log_error;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 72fa28263e14..70ecbbaba7fd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -40,6 +40,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
 #include "scrub/stats.h"
+#include "xfs_zone_alloc.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -469,22 +470,27 @@ xfs_default_resblks(
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
@@ -1042,6 +1048,12 @@ xfs_mountfs(
 	if (xfs_is_readonly(mp) && !xfs_has_norecovery(mp))
 		xfs_log_clean(mp);
 
+	if (xfs_has_zoned(mp)) {
+		error = xfs_mount_zones(mp);
+		if (error)
+			goto out_rtunmount;
+	}
+
 	/*
 	 * Complete the quota initialisation, post-log-replay component.
 	 */
@@ -1083,6 +1095,8 @@ xfs_mountfs(
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
+	if (xfs_has_zoned(mp))
+		xfs_unmount_zones(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
@@ -1164,6 +1178,8 @@ xfs_unmountfs(
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
+	if (xfs_has_zoned(mp))
+		xfs_unmount_zones(mp);
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 	if (mp->m_metadirip)
@@ -1247,7 +1263,7 @@ xfs_freecounter_unavailable(
 	struct xfs_mount	*mp,
 	enum xfs_free_counter	ctr)
 {
-	if (ctr == XC_FREE_RTEXTENTS)
+	if (ctr == XC_FREE_RTEXTENTS || ctr == XC_FREE_RTAVAILABLE)
 		return 0;
 	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
 }
@@ -1345,7 +1361,9 @@ xfs_dec_freecounter(
 		spin_unlock(&mp->m_sb_lock);
 		return 0;
 	}
-	xfs_warn_once(mp,
+
+	if (ctr == XC_FREE_BLOCKS)
+		xfs_warn_once(mp,
 "Reserve blocks depleted! Consider increasing reserve pool size.");
 
 fdblocks_enospc:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d92678d2c3b..02a3609a3322 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -115,6 +115,7 @@ struct xfs_groups {
 enum xfs_free_counter {
 	XC_FREE_BLOCKS,		/* free block counter */
 	XC_FREE_RTEXTENTS,	/* free rt extent counter */
+	XC_FREE_RTAVAILABLE,	/* actually available (zoned) rt extents */
 	XC_FREE_NR,
 };
 
@@ -211,6 +212,7 @@ typedef struct xfs_mount {
 	bool			m_fail_unmount;
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	bool			m_update_sb;	/* sb needs update in mount */
+	unsigned int		m_max_open_zones;
 
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
@@ -263,6 +265,7 @@ typedef struct xfs_mount {
 		uint64_t	save;		/* reserved blks @ remount,ro */
 	} m_resblks[XC_FREE_NR];
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct xfs_zone_info	*m_zone_info;	/* zone allocator information */
 	struct dentry		*m_debugfs;	/* debugfs parent */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7ef62e7a91c1..47c94ac74259 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -33,6 +33,7 @@
 #include "xfs_trace.h"
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_zone_alloc.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -663,7 +664,8 @@ xfs_rtunmount_rtg(
 
 	for (i = 0; i < XFS_RTGI_MAX; i++)
 		xfs_rtginode_irele(&rtg->rtg_inodes[i]);
-	kvfree(rtg->rtg_rsum_cache);
+	if (!xfs_has_zoned(rtg_mount(rtg)))
+		kvfree(rtg->rtg_rsum_cache);
 }
 
 static int
@@ -1614,6 +1616,8 @@ xfs_rtmount_rtg(
 		}
 	}
 
+	if (xfs_has_zoned(mp))
+		return 0;
 	return xfs_alloc_rsum_cache(rtg, mp->m_sb.sb_rbmblocks);
 }
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 8f530e69c18a..a60556dbd172 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -49,6 +49,8 @@
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_zone_priv.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 15dec76fec10..763dd3d271b9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -102,6 +102,7 @@ struct xfs_rmap_intent;
 struct xfs_refcount_intent;
 struct xfs_metadir_update;
 struct xfs_rtgroup;
+struct xfs_open_zone;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -265,6 +266,100 @@ DEFINE_GROUP_REF_EVENT(xfs_group_grab);
 DEFINE_GROUP_REF_EVENT(xfs_group_grab_next_tag);
 DEFINE_GROUP_REF_EVENT(xfs_group_rele);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xfs_zone_class,
+	TP_PROTO(struct xfs_rtgroup *rtg),
+	TP_ARGS(rtg),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, used)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
+		__entry->rgno = rtg_rgno(rtg);
+		__entry->used = rtg_rmap(rtg)->i_used_blocks;
+	),
+	TP_printk("dev %d:%d rgno 0x%x used 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->used)
+);
+
+#define DEFINE_ZONE_EVENT(name)				\
+DEFINE_EVENT(xfs_zone_class, name,			\
+	TP_PROTO(struct xfs_rtgroup *rtg),		\
+	TP_ARGS(rtg))
+DEFINE_ZONE_EVENT(xfs_zone_full);
+DEFINE_ZONE_EVENT(xfs_zone_activate);
+
+TRACE_EVENT(xfs_zone_free_blocks,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
+		 xfs_extlen_t len),
+	TP_ARGS(rtg, rgbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, used)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
+		__entry->rgno = rtg_rgno(rtg);
+		__entry->used = rtg_rmap(rtg)->i_used_blocks;
+		__entry->rgbno = rgbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d rgno 0x%x used 0x%x rgbno 0x%x len 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->used,
+		  __entry->rgbno,
+		  __entry->len)
+);
+
+DECLARE_EVENT_CLASS(xfs_zone_alloc_class,
+	TP_PROTO(struct xfs_open_zone *oz, xfs_rgblock_t rgbno,
+		 xfs_extlen_t len),
+	TP_ARGS(oz, rgbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, used)
+		__field(xfs_rgblock_t, written)
+		__field(xfs_rgblock_t, write_pointer)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(oz->oz_rtg)->m_super->s_dev;
+		__entry->rgno = rtg_rgno(oz->oz_rtg);
+		__entry->used = rtg_rmap(oz->oz_rtg)->i_used_blocks;
+		__entry->written = oz->oz_written;
+		__entry->write_pointer = oz->oz_write_pointer;
+		__entry->rgbno = rgbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d rgno 0x%x used 0x%x written 0x%x wp 0x%x rgbno 0x%x len 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->used,
+		  __entry->written,
+		  __entry->write_pointer,
+		  __entry->rgbno,
+		  __entry->len)
+);
+
+#define DEFINE_ZONE_ALLOC_EVENT(name)				\
+DEFINE_EVENT(xfs_zone_alloc_class, name,			\
+	TP_PROTO(struct xfs_open_zone *oz, xfs_rgblock_t rgbno,	\
+		 xfs_extlen_t len),				\
+	TP_ARGS(oz, rgbno, len))
+DEFINE_ZONE_ALLOC_EVENT(xfs_zone_record_blocks);
+DEFINE_ZONE_ALLOC_EVENT(xfs_zone_alloc_blocks);
+#endif /* CONFIG_XFS_RT */
+
 TRACE_EVENT(xfs_inodegc_worker,
 	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
 	TP_ARGS(mp, shrinker_hits),
@@ -3982,6 +4077,7 @@ DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_from);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_to);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_skip);
 
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
new file mode 100644
index 000000000000..1a746e9cfbf4
--- /dev/null
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -0,0 +1,971 @@
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
+#include "xfs_iomap.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_refcount.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_zone_priv.h"
+#include "xfs_zones.h"
+#include "xfs_trace.h"
+
+void
+xfs_open_zone_put(
+	struct xfs_open_zone	*oz)
+{
+	if (atomic_dec_and_test(&oz->oz_ref)) {
+		xfs_rtgroup_rele(oz->oz_rtg);
+		kfree(oz);
+	}
+}
+
+static void
+xfs_zone_mark_reclaimable(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_RECLAIMABLE);
+}
+
+static void
+xfs_open_zone_mark_full(
+	struct xfs_open_zone	*oz)
+{
+	struct xfs_rtgroup	*rtg = oz->oz_rtg;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+
+	trace_xfs_zone_full(rtg);
+
+	WRITE_ONCE(rtg->rtg_open_zone, NULL);
+
+	/*
+	 * GC zones are fully owned by the GC thread, don't free them here.
+	 */
+	if (!oz->oz_is_gc) {
+		spin_lock(&zi->zi_zone_list_lock);
+		zi->zi_nr_open_zones--;
+		list_del_init(&oz->oz_entry);
+		spin_unlock(&zi->zi_zone_list_lock);
+
+		xfs_open_zone_put(oz);
+	}
+
+	wake_up_all(&zi->zi_zone_wait);
+	if (rtg_rmap(rtg)->i_used_blocks < rtg_blocks(rtg))
+		xfs_zone_mark_reclaimable(rtg);
+}
+
+static int
+xfs_zone_record_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len,
+	bool			used)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rgblock_t		rgbno = xfs_rtb_to_rgbno(mp, fsbno);
+	struct xfs_inode	*rmapip;
+	struct xfs_open_zone	*oz;
+	struct xfs_rtgroup	*rtg;
+	int			error = 0;
+
+	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, fsbno));
+	if (WARN_ON_ONCE(!rtg))
+		return -EIO;
+	rmapip = rtg_rmap(rtg);
+
+	xfs_ilock(rmapip, XFS_ILOCK_EXCL);
+
+	/*
+	 * There is a reference on the oz until all blocks were written, and it
+	 * is only dropped below with the rmapip ILOCK held.  Thus we don't need
+	 * to grab an extra reference here.
+	 */
+	oz = READ_ONCE(rtg->rtg_open_zone);
+	if (WARN_ON_ONCE(!oz)) {
+		xfs_iunlock(rmapip, XFS_ILOCK_EXCL);
+		error = -EIO;
+		goto out_put;
+	}
+
+	trace_xfs_zone_record_blocks(oz, rgbno, len);
+	xfs_trans_ijoin(tp, rmapip, XFS_ILOCK_EXCL);
+	if (used) {
+		rmapip->i_used_blocks += len;
+		ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
+	} else {
+		xfs_add_frextents(mp, len);
+	}
+
+	oz->oz_written += len;
+	ASSERT(oz->oz_written <= oz->oz_write_pointer);
+	if (oz->oz_written == rtg_blocks(rtg))
+		xfs_open_zone_mark_full(oz);
+	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
+out_put:
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+
+static int
+xfs_zoned_end_extent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*new,
+	xfs_fsblock_t		old_startblock)
+{
+	struct xfs_bmbt_irec	data;
+	int			nmaps = 1;
+	int			error;
+
+	/* Grab the corresponding mapping in the data fork. */
+	error = xfs_bmapi_read(ip, new->br_startoff, new->br_blockcount, &data,
+			       &nmaps, 0);
+	if (error)
+		return error;
+
+	/*
+	 * Cap the update to the existing extent in the data fork because we can
+	 * only overwrite one extent at a time.
+	 */
+	ASSERT(new->br_blockcount >= data.br_blockcount);
+	new->br_blockcount = data.br_blockcount;
+
+	/*
+	 * If a data write raced with this GC write, keep the existing data in
+	 * the data fork, mark our newly written GC extent as reclaimable, then
+	 * move on to the next extent.
+	 */
+	if (old_startblock != NULLFSBLOCK &&
+	    old_startblock != data.br_startblock)
+		goto skip;
+
+	trace_xfs_reflink_cow_remap_from(ip, new);
+	trace_xfs_reflink_cow_remap_to(ip, &data);
+
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		return error;
+
+	if (data.br_startblock != HOLESTARTBLOCK) {
+		ASSERT(data.br_startblock != DELAYSTARTBLOCK);
+		ASSERT(!isnullstartblock(data.br_startblock));
+
+		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
+		if (xfs_is_reflink_inode(ip)) {
+			xfs_refcount_decrease_extent(tp, true, &data);
+		} else {
+			error = xfs_free_extent_later(tp, data.br_startblock,
+					data.br_blockcount, NULL,
+					XFS_AG_RESV_NONE,
+					XFS_FREE_EXTENT_REALTIME);
+			if (error)
+				return error;
+		}
+	}
+
+	error = xfs_zone_record_blocks(tp, new->br_startblock,
+			new->br_blockcount, true);
+	if (error)
+		return error;
+
+	/* Map the new blocks into the data fork. */
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, new);
+	return 0;
+
+skip:
+	trace_xfs_reflink_cow_remap_skip(ip, new);
+	return xfs_zone_record_blocks(tp, new->br_startblock,
+			new->br_blockcount, false);
+}
+
+int
+xfs_zoned_end_io(
+	struct xfs_inode		*ip,
+	xfs_off_t			offset,
+	xfs_off_t			count,
+	xfs_daddr_t			daddr,
+	xfs_fsblock_t			old_startblock)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
+	struct xfs_bmbt_irec	new = {
+		.br_startoff	= XFS_B_TO_FSBT(mp, offset),
+		.br_startblock	= xfs_daddr_to_rtb(mp, daddr),
+		.br_state	= XFS_EXT_NORM,
+	};
+	unsigned int		resblks =
+		XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	while (new.br_startoff < end_fsb) {
+		new.br_blockcount = end_fsb - new.br_startoff;
+
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+				XFS_TRANS_RESERVE | XFS_TRANS_RES_FDBLKS, &tp);
+		if (error)
+			return error;
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, 0);
+
+		error = xfs_zoned_end_extent(tp, ip, &new, old_startblock);
+		if (error)
+			xfs_trans_cancel(tp);
+		else
+			error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			return error;
+
+		new.br_startoff += new.br_blockcount;
+		new.br_startblock += new.br_blockcount;
+		if (old_startblock != NULLFSBLOCK)
+			old_startblock += new.br_blockcount;
+	}
+
+	return 0;
+}
+
+/*
+ * "Free" blocks allocated in a zone.
+ *
+ * Just decrement the used blocks counter and report the space as freed.
+ */
+int
+xfs_zone_free_blocks(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*rmapip = rtg_rmap(rtg);
+
+	xfs_assert_ilocked(rmapip, XFS_ILOCK_EXCL);
+
+	if (len > rmapip->i_used_blocks) {
+		xfs_err(mp,
+"trying to free more blocks (%lld) than used counter (%u).",
+			len, rmapip->i_used_blocks);
+		ASSERT(len <= rmapip->i_used_blocks);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return -EFSCORRUPTED;
+	}
+
+	trace_xfs_zone_free_blocks(rtg, xfs_rtb_to_rgbno(mp, fsbno), len);
+
+	rmapip->i_used_blocks -= len;
+	if (!READ_ONCE(rtg->rtg_open_zone)) {
+		/*
+		 * If the zone is not open, mark it reclaimable when the first
+		 * block is freed.
+		 */
+		if (rmapip->i_used_blocks + len == rtg_blocks(rtg))
+			xfs_zone_mark_reclaimable(rtg);
+	}
+	xfs_add_frextents(mp, len);
+	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
+	return 0;
+}
+
+/*
+ * Check if the zone containing the data just before the offset we are
+ * writing to is still open and has space.
+ */
+static struct xfs_open_zone *
+xfs_last_used_zone(
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSB(mp, ioend->io_offset);
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_open_zone	*oz = NULL;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (!xfs_iext_lookup_extent_before(ip, &ip->i_df, &offset_fsb,
+				&icur, &got)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return NULL;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	rtg = xfs_rtgroup_grab(mp, xfs_rtb_to_rgno(mp, got.br_startblock));
+	if (!rtg)
+		return NULL;
+
+	xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
+	oz = READ_ONCE(rtg->rtg_open_zone);
+	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
+		oz = NULL;
+	xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
+
+	xfs_rtgroup_rele(rtg);
+	return oz;
+}
+
+static struct xfs_group *
+xfs_find_free_zone(
+	struct xfs_mount	*mp,
+	unsigned long		start,
+	unsigned long		end)
+{
+	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, start);
+	struct xfs_group	*xg;
+
+	xas_for_each_marked(&xas, xg, end, XFS_RTG_FREE)
+		if (atomic_inc_not_zero(&xg->xg_active_ref))
+			return xg;
+
+	return NULL;
+}
+
+static struct xfs_open_zone *
+xfs_init_open_zone(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		write_pointer,
+	bool			is_gc)
+{
+	struct xfs_open_zone	*oz;
+
+	oz = kzalloc(sizeof(*oz), GFP_NOFS | __GFP_NOFAIL);
+	spin_lock_init(&oz->oz_alloc_lock);
+	atomic_set(&oz->oz_ref, 1);
+	oz->oz_rtg = rtg;
+	oz->oz_write_pointer = write_pointer;
+	oz->oz_written = write_pointer;
+	oz->oz_is_gc = is_gc;
+
+	/*
+	 * All dereferences of rtg->rtg_open_zone hold the ILOCK for the rmap
+	 * inode, but we don't really want to take that here because we are
+	 * under the zone_list_lock.  Ensure the pointer is only set for a fully
+	 * initialized open zone structure so that a racy lookup finding it is
+	 * fine.
+	 */
+	WRITE_ONCE(rtg->rtg_open_zone, oz);
+	return oz;
+}
+
+struct xfs_open_zone *
+xfs_open_zone(
+	struct xfs_mount	*mp,
+	bool			is_gc)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	struct xfs_group	*xg;
+
+	lockdep_assert_held(&zi->zi_zone_list_lock);
+
+	xg = xfs_find_free_zone(mp, zi->zi_free_zone_cursor, ULONG_MAX);
+	if (!xg)
+		xg = xfs_find_free_zone(mp, 0, zi->zi_free_zone_cursor);
+	if (!xg)
+		return NULL;
+	xfs_group_clear_mark(xg, XFS_RTG_FREE);
+	atomic_dec(&zi->zi_nr_free_zones);
+	zi->zi_free_zone_cursor = xg->xg_gno;
+	return xfs_init_open_zone(to_rtg(xg), 0, is_gc);
+}
+
+/*
+ * Activate a free zone.
+ *
+ * This just does the accounting and allows to find the zone on the open
+ * zones list.  Don't bother with an explicit open command, we'll just open it
+ * implicitly with the first write to it.
+ */
+static struct xfs_open_zone *
+xfs_activate_zone(
+	struct xfs_mount	*mp)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	struct xfs_open_zone	*oz;
+
+	if (atomic_read(&zi->zi_nr_free_zones) <
+	    XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
+		return NULL;
+
+	oz = xfs_open_zone(mp, false);
+	if (!oz)
+		return NULL;
+
+	atomic_inc(&oz->oz_ref);
+	zi->zi_nr_open_zones++;
+	list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
+
+	/* XXX: this is a little verbose, but let's keep it for now */
+	xfs_info(mp, "using zone %u (%u)",
+		 rtg_rgno(oz->oz_rtg), zi->zi_nr_open_zones);
+	trace_xfs_zone_activate(oz->oz_rtg);
+	return oz;
+}
+
+static bool
+xfs_try_use_zone(
+	struct xfs_zone_info	*zi,
+	struct xfs_open_zone	*oz)
+{
+	if (oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
+		return false;
+	if (!atomic_inc_not_zero(&oz->oz_ref))
+		return false;
+
+	/*
+	 * If we couldn't match by inode or life time we just pick the first
+	 * zone with enough space above.  For that we want the least busy zone
+	 * for some definition of "least" busy.  For now this simple LRU
+	 * algorithm that rotates every zone to the end of the list will do it,
+	 * even if it isn't exactly cache friendly.
+	 */
+	if (!list_is_last(&oz->oz_entry, &zi->zi_open_zones))
+		list_move_tail(&oz->oz_entry, &zi->zi_open_zones);
+	return true;
+}
+
+static struct xfs_open_zone *
+xfs_select_open_zone_lru(
+	struct xfs_zone_info	*zi)
+{
+	struct xfs_open_zone	*oz;
+
+	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
+		if (xfs_try_use_zone(zi, oz))
+			return oz;
+	return NULL;
+}
+
+static struct xfs_open_zone *
+xfs_select_open_zone_mru(
+	struct xfs_zone_info	*zi)
+{
+	struct xfs_open_zone	*oz;
+
+	list_for_each_entry_reverse(oz, &zi->zi_open_zones, oz_entry)
+		if (xfs_try_use_zone(zi, oz))
+			return oz;
+	return NULL;
+}
+
+/*
+ * Try to pack inodes that are written back after they were closed tight instead
+ * of trying to open new zones for them or spread them to the least recently
+ * used zone.  This optimizes the data layout for workloads that untar or copy
+ * a lot of small files.  Right now this does not separate multiple such
+ * streams.
+ */
+static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
+{
+	return !inode_is_open_for_write(VFS_I(ip)) &&
+		!(ip->i_diflags & XFS_DIFLAG_APPEND);
+}
+
+/*
+ * Pick a new zone for writes.
+ *
+ * If we aren't using up our budget of open zones just open a new one from
+ * the freelist.  Else try to find one that matches the expected allocation
+ * length, or at least the minimum required length.  If we don't find one
+ * that is good enough we pick one anyway and let the caller finish it to
+ * free up open zone resources.
+ */
+static struct xfs_open_zone *
+xfs_select_zone_nowait(
+	struct xfs_inode	*ip,
+	xfs_filblks_t		count_fsb)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	struct xfs_open_zone	*oz = NULL;
+
+	if (xfs_zoned_pack_tight(ip))
+		oz = xfs_select_open_zone_mru(zi);
+	if (oz)
+		return oz;
+
+	/*
+	 * If we are below the open limit try to activate a zone.
+	 */
+	if (zi->zi_nr_open_zones < mp->m_max_open_zones - XFS_OPEN_GC_ZONES) {
+		oz = xfs_activate_zone(mp);
+		if (oz)
+			return oz;
+	}
+
+	return xfs_select_open_zone_lru(zi);
+}
+
+static struct xfs_open_zone *
+xfs_select_zone(
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	xfs_filblks_t		count_fsb = XFS_B_TO_FSB(mp, ioend->io_size);
+	struct xfs_open_zone	*oz = NULL;
+	DEFINE_WAIT		(wait);
+
+	spin_lock(&zi->zi_zone_list_lock);
+	if (xfs_is_shutdown(mp))
+		goto out_unlock;
+
+	oz = xfs_select_zone_nowait(ip, count_fsb);
+	if (oz)
+		goto out_unlock;
+
+	for (;;) {
+		prepare_to_wait(&zi->zi_zone_wait, &wait, TASK_UNINTERRUPTIBLE);
+		if (xfs_is_shutdown(mp))
+			break;
+
+		oz = xfs_select_zone_nowait(ip, count_fsb);
+		if (oz)
+			break;
+
+		spin_unlock(&zi->zi_zone_list_lock);
+		schedule();
+		spin_lock(&zi->zi_zone_list_lock);
+	}
+	finish_wait(&zi->zi_zone_wait, &wait);
+
+out_unlock:
+	spin_unlock(&zi->zi_zone_list_lock);
+	return oz;
+}
+
+static unsigned int
+xfs_zone_alloc_blocks(
+	struct iomap_ioend	*ioend,
+	struct xfs_open_zone	*oz,
+	bool			*is_seq)
+{
+	struct xfs_rtgroup	*rtg = oz->oz_rtg;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_filblks_t		count_fsb = XFS_B_TO_FSB(mp, ioend->io_size);
+	xfs_rgblock_t		rgbno;
+
+	spin_lock(&oz->oz_alloc_lock);
+	count_fsb = min3(count_fsb, XFS_MAX_BMBT_EXTLEN,
+		(xfs_filblks_t)rtg_blocks(rtg) - oz->oz_write_pointer);
+	if (!count_fsb) {
+		spin_unlock(&oz->oz_alloc_lock);
+		return 0;
+	}
+	rgbno = oz->oz_write_pointer;
+	oz->oz_write_pointer += count_fsb;
+	spin_unlock(&oz->oz_alloc_lock);
+
+	trace_xfs_zone_alloc_blocks(oz, rgbno, count_fsb);
+
+	ioend->io_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
+	*is_seq = bdev_zone_is_seq(ioend->io_bio.bi_bdev, ioend->io_sector);
+	if (!*is_seq)
+		ioend->io_sector += XFS_FSB_TO_BB(mp, rgbno);
+	return XFS_FSB_TO_B(mp, count_fsb);
+}
+
+void
+xfs_mark_rtg_boundary(
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
+	sector_t		sector = ioend->io_bio.bi_iter.bi_sector;
+
+	if (xfs_rtb_to_rgbno(mp, xfs_daddr_to_rtb(mp, sector)) == 0)
+		ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
+}
+
+static void
+xfs_submit_zoned_bio(
+	struct iomap_ioend	*ioend,
+	bool			is_seq)
+{
+	ioend->io_bio.bi_iter.bi_sector = ioend->io_sector;
+
+	if (is_seq) {
+		ioend->io_bio.bi_opf &= ~REQ_OP_WRITE;
+		ioend->io_bio.bi_opf |= REQ_OP_ZONE_APPEND;
+	} else {
+		xfs_mark_rtg_boundary(ioend);
+	}
+
+	submit_bio(&ioend->io_bio);
+}
+
+void
+xfs_zone_alloc_and_submit(
+	struct iomap_ioend	*ioend,
+	struct xfs_open_zone	**oz)
+{
+	unsigned int		alloc_len;
+	struct iomap_ioend	*split;
+	bool			is_seq;
+
+	if (xfs_is_shutdown(XFS_I(ioend->io_inode)->i_mount))
+		goto out_error;
+
+	/*
+	 * If we don't have a cached zone in this write context, see if the
+	 * last extent before the one we are writing points of an active zone.
+	 * If so, just continue writing to it.
+	 */
+	if (!*oz && ioend->io_offset)
+		*oz = xfs_last_used_zone(ioend);
+	if (!*oz) {
+select_zone:
+		*oz = xfs_select_zone(ioend);
+		if (!*oz)
+			goto out_error;
+	}
+
+	alloc_len = xfs_zone_alloc_blocks(ioend, *oz, &is_seq);
+	if (!alloc_len) {
+		xfs_open_zone_put(*oz);
+		goto select_zone;
+	}
+
+	while ((split = iomap_split_ioend(ioend, is_seq, &alloc_len))) {
+		xfs_submit_zoned_bio(split, is_seq);
+		if (!alloc_len) {
+			xfs_open_zone_put(*oz);
+			goto select_zone;
+		}
+	}
+
+	xfs_submit_zoned_bio(ioend, is_seq);
+	return;
+
+out_error:
+	bio_io_error(&ioend->io_bio);
+}
+
+void
+xfs_zoned_wake_all(
+	struct xfs_mount	*mp)
+{
+	if (!(mp->m_super->s_flags & SB_ACTIVE))
+		return; /* can happen during log recovery */
+	spin_lock(&mp->m_zone_info->zi_zone_list_lock);
+	wake_up_all(&mp->m_zone_info->zi_zone_wait);
+	spin_unlock(&mp->m_zone_info->zi_zone_list_lock);
+}
+
+/*
+ * Check if @rgbno in @rgb is a potentially valid block.  It might still be
+ * unused, but that information is only found in the rmap.
+ */
+bool
+xfs_zone_rgbno_is_valid(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgnumber_t		rgbno)
+{
+	lockdep_assert_held(&rtg_rmap(rtg)->i_lock);
+
+	if (rtg->rtg_open_zone)
+		return rgbno < rtg->rtg_open_zone->oz_write_pointer;
+	return !xa_get_mark(&rtg_mount(rtg)->m_groups[XG_TYPE_RTG].xa,
+			rtg_rgno(rtg), XFS_RTG_FREE);
+}
+
+static void
+xfs_free_open_zones(
+	struct xfs_zone_info	*zi)
+{
+	struct xfs_open_zone	*oz;
+
+	spin_lock(&zi->zi_zone_list_lock);
+	while ((oz = list_first_entry_or_null(&zi->zi_open_zones,
+			struct xfs_open_zone, oz_entry))) {
+		list_del(&oz->oz_entry);
+		xfs_open_zone_put(oz);
+	}
+	spin_unlock(&zi->zi_zone_list_lock);
+}
+
+struct xfs_init_zones {
+	struct xfs_mount	*mp;
+	uint64_t		available;
+	uint64_t		reclaimable;
+};
+
+static int
+xfs_init_zone(
+	struct xfs_init_zones	*iz,
+	struct xfs_rtgroup	*rtg,
+	struct blk_zone		*zone)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	uint64_t		used = rtg_rmap(rtg)->i_used_blocks;
+	xfs_rgblock_t		write_pointer;
+	int			error;
+
+	if (zone) {
+		error = xfs_zone_validate(zone, rtg, &write_pointer);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * For sequential write required zones we retrieved the hardware write
+	 * pointer above.
+	 *
+	 * For conventional zones or conventional devices we don't have that
+	 * luxury.  Instead query the rmap to find the highest recorded block
+	 * and set the write pointer to the block after that.  In case of a
+	 * power loss this misses blocks where the data I/O has completed but
+	 * not recorded in the rmap yet, and it also rewrites blocks if the most
+	 * recently written ones got deleted again before unmount, but this is
+	 * the best we can do without hardware support.
+	 */
+	if (!zone || zone->cond == BLK_ZONE_COND_NOT_WP) {
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+		write_pointer = xfs_rtrmap_first_unwritten_rgbno(rtg);
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+	}
+
+	if (write_pointer == 0) {
+		/* zone is empty */
+		atomic_inc(&zi->zi_nr_free_zones);
+		xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
+		iz->available += rtg_blocks(rtg);
+	} else if (write_pointer < rtg_blocks(rtg)) {
+		/* zone is open */
+		struct xfs_open_zone *oz;
+
+		atomic_inc(&rtg_group(rtg)->xg_active_ref);
+		oz = xfs_init_open_zone(rtg, write_pointer, false);
+		list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
+		zi->zi_nr_open_zones++;
+
+		iz->available += (rtg_blocks(rtg) - write_pointer);
+		iz->reclaimable += write_pointer - used;
+	} else if (used < rtg_blocks(rtg)) {
+		/* zone fully written, but has freed blocks */
+		xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_RECLAIMABLE);
+		iz->reclaimable += (rtg_blocks(rtg) - used);
+	}
+
+	return 0;
+}
+
+static int
+xfs_get_zone_info_cb(
+	struct blk_zone		*zone,
+	unsigned int		idx,
+	void			*data)
+{
+	struct xfs_init_zones	*iz = data;
+	struct xfs_mount	*mp = iz->mp;
+	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
+	xfs_rgnumber_t		rgno;
+	struct xfs_rtgroup	*rtg;
+	int			error;
+
+	if (xfs_rtb_to_rgbno(mp, zsbno) != 0) {
+		xfs_warn(mp, "mismatched zone start 0x%llx.", zsbno);
+		return -EFSCORRUPTED;
+	}
+
+	rgno = xfs_rtb_to_rgno(mp, zsbno);
+	rtg = xfs_rtgroup_grab(mp, rgno);
+	if (!rtg) {
+		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
+		return -EFSCORRUPTED;
+	}
+	error = xfs_init_zone(iz, rtg, zone);
+	xfs_rtgroup_rele(rtg);
+	return error;
+}
+
+/*
+ * Calculate the max open zone limit based on the of number of
+ * backing zones available
+ */
+static inline uint32_t
+xfs_max_open_zones(
+	struct xfs_mount	*mp)
+{
+	unsigned int		max_open, max_open_data_zones;
+	/*
+	 * We need two zones for every open data zone,
+	 * one in reserve as we don't reclaim open zones. One data zone
+	 * and its spare is included in XFS_MIN_ZONES.
+	 */
+	max_open_data_zones = (mp->m_sb.sb_rgcount - XFS_MIN_ZONES) / 2 + 1;
+	max_open = max_open_data_zones + XFS_OPEN_GC_ZONES;
+
+	/*
+	 * Cap the max open limit to 1/4 of available space
+	 */
+	max_open = min(max_open, mp->m_sb.sb_rgcount / 4);
+
+	return max(XFS_MIN_OPEN_ZONES, max_open);
+}
+
+/*
+ * Normally we use the open zone limit that the device reports.  If there is
+ * none let the user pick one from the command line.
+ *
+ * If the device doesn't report an open zone limit and there is no override,
+ * allow to hold about a quarter of the zones open.  In theory we could allow
+ * all to be open, but at that point we run into GC deadlocks because we can't
+ * reclaim open zones.
+ *
+ * When used on conventional SSDs a lower open limit is advisable as we'll
+ * otherwise overwhelm the FTL just as much as a conventional block allocator.
+ *
+ * Note: To debug the open zone management code, force max_open to 1 here.
+ */
+static int
+xfs_calc_open_zones(
+	struct xfs_mount	*mp)
+{
+	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
+	unsigned int		bdev_open_zones = bdev_max_open_zones(bdev);
+
+	if (!mp->m_max_open_zones) {
+		if (bdev_open_zones)
+			mp->m_max_open_zones = bdev_open_zones;
+		else
+			mp->m_max_open_zones = xfs_max_open_zones(mp);
+	}
+
+	if (mp->m_max_open_zones < XFS_MIN_OPEN_ZONES) {
+		xfs_notice(mp, "need at least %u open zones.",
+			XFS_MIN_OPEN_ZONES);
+		return -EIO;
+	}
+
+	if (bdev_open_zones && bdev_open_zones < mp->m_max_open_zones) {
+		mp->m_max_open_zones = bdev_open_zones;
+		xfs_info(mp, "limiting open zones to %u due to hardware limit.\n",
+			bdev_open_zones);
+	}
+
+	if (mp->m_max_open_zones > xfs_max_open_zones(mp)) {
+		mp->m_max_open_zones = xfs_max_open_zones(mp);
+		xfs_info(mp,
+"limiting open zones to %u due to total zone count (%u)",
+			mp->m_max_open_zones, mp->m_sb.sb_rgcount);
+	}
+
+	return 0;
+}
+
+static struct xfs_zone_info *
+xfs_alloc_zone_info(void)
+{
+	struct xfs_zone_info	*zi;
+
+	zi = kzalloc(sizeof(*zi), GFP_KERNEL);
+	if (!zi)
+		return NULL;
+	INIT_LIST_HEAD(&zi->zi_open_zones);
+	INIT_LIST_HEAD(&zi->zi_reclaim_reservations);
+	spin_lock_init(&zi->zi_reset_list_lock);
+	spin_lock_init(&zi->zi_zone_list_lock);
+	spin_lock_init(&zi->zi_reservation_lock);
+	init_waitqueue_head(&zi->zi_zone_wait);
+	return zi;
+}
+
+int
+xfs_mount_zones(
+	struct xfs_mount	*mp)
+{
+	struct xfs_init_zones	iz = {
+		.mp		= mp,
+	};
+	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
+	int			error;
+
+	if (!bt) {
+		xfs_notice(mp, "RT device missing.");
+		return -EINVAL;
+	}
+
+	if (!xfs_has_rtgroups(mp) || !xfs_has_rmapbt(mp)) {
+		xfs_notice(mp, "invalid flag combination.");
+		return -EFSCORRUPTED;
+	}
+	if (mp->m_sb.sb_rextsize != 1) {
+		xfs_notice(mp, "zoned file systems do not support rextsize.");
+		return -EFSCORRUPTED;
+	}
+	if (mp->m_sb.sb_rgcount < XFS_MIN_ZONES) {
+		xfs_notice(mp,
+"zoned file systems need to have at least %u zones.", XFS_MIN_ZONES);
+		return -EFSCORRUPTED;
+	}
+
+	error = xfs_calc_open_zones(mp);
+	if (error)
+		return error;
+
+	mp->m_zone_info = xfs_alloc_zone_info();
+	if (!mp->m_zone_info)
+		return -ENOMEM;
+
+	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
+		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
+		 mp->m_max_open_zones);
+
+	if (bdev_is_zoned(bt->bt_bdev)) {
+		error = blkdev_report_zones(bt->bt_bdev,
+				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
+				mp->m_sb.sb_rgcount, xfs_get_zone_info_cb, &iz);
+		if (error < 0)
+			goto out_free_open_zones;
+	} else {
+		struct xfs_rtgroup	*rtg = NULL;
+
+		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+			error = xfs_init_zone(&iz, rtg, NULL);
+			if (error)
+				goto out_free_open_zones;
+		}
+	}
+
+	xfs_set_freecounter(mp, XC_FREE_RTAVAILABLE, iz.available);
+	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
+		iz.available + iz.reclaimable);
+
+	return 0;
+
+out_free_open_zones:
+	xfs_free_open_zones(mp->m_zone_info);
+	kfree(mp->m_zone_info);
+	return error;
+}
+
+void
+xfs_unmount_zones(
+	struct xfs_mount	*mp)
+{
+	xfs_free_open_zones(mp->m_zone_info);
+	kfree(mp->m_zone_info);
+}
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
new file mode 100644
index 000000000000..37a49f4ce40c
--- /dev/null
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _XFS_ZONE_ALLOC_H
+#define _XFS_ZONE_ALLOC_H
+
+struct iomap_ioend;
+struct xfs_open_zone;
+
+void xfs_zone_alloc_and_submit(struct iomap_ioend *ioend,
+		struct xfs_open_zone **oz);
+int xfs_zone_free_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		xfs_fsblock_t fsbno, xfs_filblks_t len);
+int xfs_zoned_end_io(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t count,
+		xfs_daddr_t daddr, xfs_fsblock_t old_startblock);
+void xfs_open_zone_put(struct xfs_open_zone *oz);
+
+void xfs_zoned_wake_all(struct xfs_mount *mp);
+bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
+void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
+
+uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
+		enum xfs_free_counter ctr);
+
+#ifdef CONFIG_XFS_RT
+int xfs_mount_zones(struct xfs_mount *mp);
+void xfs_unmount_zones(struct xfs_mount *mp);
+#else
+static inline int xfs_mount_zones(struct xfs_mount *mp)
+{
+	return -EIO;
+}
+static inline void xfs_unmount_zones(struct xfs_mount *mp)
+{
+}
+#endif /* CONFIG_XFS_RT */
+
+#endif /* _XFS_ZONE_ALLOC_H */
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
new file mode 100644
index 000000000000..ae1556871596
--- /dev/null
+++ b/fs/xfs/xfs_zone_priv.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _XFS_ZONE_PRIV_H
+#define _XFS_ZONE_PRIV_H
+
+struct xfs_open_zone {
+	/*
+	 * Entry in the open zone list and refcount.  Protected by
+	 * zi_zone_list_lock in struct xfs_zone_info.
+	 */
+	struct list_head	oz_entry;
+	atomic_t		oz_ref;
+
+	/*
+	 * Protects oz_write_pointer and oz_written.
+	 */
+	spinlock_t		oz_alloc_lock;
+
+	/*
+	 * oz_write_pointer is the write pointer at which space is handed out
+	 * for conventional zones, or simple the count of blocks handed out
+	 * so far for sequential write required zones.
+	 *
+	 * oz_written is the number of blocks for which we've received a
+	 * write completion.  oz_written must always be <= oz_write_pointer.
+	 */
+	xfs_rgblock_t		oz_write_pointer;
+	xfs_rgblock_t		oz_written;
+
+	/*
+	 * Is this open zone used for garbage collection?  There can only be a
+	 * single open GC zone, which is pointed to by zi_open_gc_zone in
+	 * struct xfs_zone_info.  Constant over the life time of an open zone.
+	 */
+	bool			oz_is_gc;
+
+	/*
+	 * Pointer to the RT groups structure for this open zone.  Constant over
+	 * the life time of an open zone.
+	 */
+	struct xfs_rtgroup	*oz_rtg;
+};
+
+struct xfs_zone_info {
+	/*
+	 * List of pending space reservations:
+	 */
+	spinlock_t		zi_reservation_lock;
+	struct list_head	zi_reclaim_reservations;
+
+	/*
+	 * Lock for open and free zone information, and wait queue to wait for
+	 * free zones or open zone resources to become available:
+	 */
+	spinlock_t		zi_zone_list_lock;
+	wait_queue_head_t	zi_zone_wait;
+
+	/*
+	 * List and number of open zones:
+	 */
+	struct list_head	zi_open_zones;
+	unsigned int		zi_nr_open_zones;
+
+	/*
+	 * Free zone search cursor and number of free zones:
+	 */
+	unsigned long		zi_free_zone_cursor;
+	atomic_t		zi_nr_free_zones;
+
+	/*
+	 * Pointer to the GC thread, and the current open zone used by GC
+	 * (if any).
+	 */
+	struct task_struct      *zi_gc_thread;
+	struct xfs_open_zone	*zi_open_gc_zone;
+
+	/*
+	 * List of zones that need a reset:
+	 */
+	spinlock_t		zi_reset_list_lock;
+	struct xfs_group	*zi_reset_list;
+};
+
+struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
+
+#endif /* _XFS_ZONE_PRIV_H */
-- 
2.45.2

