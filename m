Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415C21FC7E9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191162; cv=none; b=pNxY75qmZEKaDvw7fa9s88N33Ve6iuI+Wvec/I2mY8Wcta0DgWum7Kn50ngYIiGz8SZFM8DswEncuUK5TXoPGYjTXEgR3TB+FRbyrxrQcXA4bOEn6H5hWpKdNhbWPcwl1XpiXdO2+Qg4QTuZgyt+s5AOOuCPwydpNpd3L9aqQAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191162; c=relaxed/simple;
	bh=VNU69YKwIpy/a4UfxhxcrkbsrfFjAfOYmIaxch2DHJo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5gCkkZo/6h5RwFRIQZFwol0ColquL0E1zehSPuX8adNuFTf4CGdKIsCoeUW9WZrZXwIfKBWqrxfilVO+euDaWn1r9PewN7CXW96FjCAfXgr+IbhWLawVE+3XqJrYcFyfIGY9f5MzOQCXpxsJaX9fCjdBG/DDrLWkX62cK9xWPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTQ6Dr6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTQ6Dr6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3C1C4CECE;
	Thu, 17 Oct 2024 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191161;
	bh=VNU69YKwIpy/a4UfxhxcrkbsrfFjAfOYmIaxch2DHJo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fTQ6Dr6biHSeRZuFBHctUKkqsfc5wOUMhg5D74C35r9wwihdFd+64qtMQnJM9wY2z
	 A8QLkB7aZkz5pB3ztdZEtnEbg6pXHuGaN73mtFPeOqt80I41cBrDSrVMKIx7PnklKt
	 P8FaB9A9PpYEHZEqr2cP3Dx20sVt5kZSLx6pMoDRzVJM6fuMn6aeOxQQwYX3w8GIlr
	 GMGO/xG4FfOHHyvGoX5/ylfPHuWWXBnyugUdPtoV7KSRm0UD5VhtXnCQEPTOs8tGo5
	 i6jmOk3BCUN0eEkZvVgwkuFIj8DeP6zhnremBbldGfNa44rmV9pyiVUlMhOEe7l5Kb
	 /KA0IRjGgN9kg==
Date: Thu, 17 Oct 2024 11:52:41 -0700
Subject: [PATCH 05/16] xfs: move metadata health tracking to the generic group
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068760.3450737.9917555071757060496.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Prepare for also tracking the health status of the upcoming realtime
groups by moving the health tracking code to the generic xfs_group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c     |    1 -
 fs/xfs/libxfs/xfs_ag.h     |    9 ------
 fs/xfs/libxfs/xfs_group.c  |    4 ++
 fs/xfs/libxfs/xfs_group.h  |   12 +++++++
 fs/xfs/libxfs/xfs_health.h |   45 +++++++++++-----------------
 fs/xfs/scrub/health.c      |    8 ++---
 fs/xfs/xfs_health.c        |   71 ++++++++++++++++++++++++--------------------
 fs/xfs/xfs_trace.h         |   35 ++++++++++++----------
 8 files changed, 94 insertions(+), 91 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9ea20e9cf0d4e5..84bd3831297e07 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -232,7 +232,6 @@ xfs_perag_alloc(
 	/* Place kernel structure only init below this point. */
 	spin_lock_init(&pag->pag_ici_lock);
 	spin_lock_init(&pag->pagb_lock);
-	spin_lock_init(&pag->pag_state_lock);
 	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 	xfs_defer_drain_init(&pag->pag_intents_drain);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 80969682dc4746..8271cb72c88387 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -69,13 +69,6 @@ struct xfs_perag {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
-	/*
-	 * Bitsets of per-ag metadata that have been checked and/or are sick.
-	 * Callers should hold pag_state_lock before accessing this field.
-	 */
-	uint16_t	pag_checked;
-	uint16_t	pag_sick;
-
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 	/*
 	 * Alternate btree heights so that online repair won't trip the write
@@ -87,8 +80,6 @@ struct xfs_perag {
 	uint8_t		pagf_repair_rmap_level;
 #endif
 
-	spinlock_t	pag_state_lock;
-
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
 	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 	unsigned int	pagb_gen;	/* generation count for pagb_tree */
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 59e08cfaf9bffd..927e72c0882b88 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -182,6 +182,10 @@ xfs_group_insert(
 	xg->xg_gno = index;
 	xg->xg_type = type;
 
+#ifdef __KERNEL__
+	spin_lock_init(&xg->xg_state_lock);
+#endif
+
 	/* Active ref owned by mount indicates group is online. */
 	atomic_set(&xg->xg_active_ref, 1);
 
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index dd7da90443054b..d2c61dd1f43e44 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -11,6 +11,18 @@ struct xfs_group {
 	enum xfs_group_type	xg_type;
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
+
+#ifdef __KERNEL__
+	/* -- kernel only structures below this line -- */
+
+	/*
+	 * Bitsets of per-ag metadata that have been checked and/or are sick.
+	 * Callers should hold xg_state_lock before accessing this field.
+	 */
+	uint16_t		xg_checked;
+	uint16_t		xg_sick;
+	spinlock_t		xg_state_lock;
+#endif /* __KERNEL__ */
 };
 
 struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index b0edb4288e5929..13301420a2f670 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_HEALTH_H__
 #define __XFS_HEALTH_H__
 
+struct xfs_group;
+
 /*
  * In-Core Filesystem Health Assessments
  * =====================================
@@ -197,10 +199,12 @@ void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask);
-void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
-void xfs_ag_mark_corrupt(struct xfs_perag *pag, unsigned int mask);
-void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
-void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
+void xfs_group_mark_sick(struct xfs_group *xg, unsigned int mask);
+#define xfs_ag_mark_sick(pag, mask) \
+	xfs_group_mark_sick(pag_group(pag), (mask))
+void xfs_group_mark_corrupt(struct xfs_group *xg, unsigned int mask);
+void xfs_group_mark_healthy(struct xfs_group *xg, unsigned int mask);
+void xfs_group_measure_sickness(struct xfs_group *xg, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
@@ -227,22 +231,19 @@ xfs_fs_has_sickness(struct xfs_mount *mp, unsigned int mask)
 }
 
 static inline bool
-xfs_rt_has_sickness(struct xfs_mount *mp, unsigned int mask)
+xfs_group_has_sickness(
+	struct xfs_group	*xg,
+	unsigned int		mask)
 {
-	unsigned int	sick, checked;
+	unsigned int		sick, checked;
 
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	return sick & mask;
-}
-
-static inline bool
-xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
-{
-	unsigned int	sick, checked;
-
-	xfs_ag_measure_sickness(pag, &sick, &checked);
+	xfs_group_measure_sickness(xg, &sick, &checked);
 	return sick & mask;
 }
+#define xfs_ag_has_sickness(pag, mask) \
+	xfs_group_has_sickness(pag_group(pag), (mask))
+#define xfs_ag_is_healthy(pag) \
+	(!xfs_ag_has_sickness((pag), UINT_MAX))
 
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
@@ -259,18 +260,6 @@ xfs_fs_is_healthy(struct xfs_mount *mp)
 	return !xfs_fs_has_sickness(mp, -1U);
 }
 
-static inline bool
-xfs_rt_is_healthy(struct xfs_mount *mp)
-{
-	return !xfs_rt_has_sickness(mp, -1U);
-}
-
-static inline bool
-xfs_ag_is_healthy(struct xfs_perag *pag)
-{
-	return !xfs_ag_has_sickness(pag, -1U);
-}
-
 static inline bool
 xfs_inode_is_healthy(struct xfs_inode *ip)
 {
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 112dd05e5551d3..fce04444c37c2a 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -165,7 +165,7 @@ xchk_mark_all_healthy(
 	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
 	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
 	while ((pag = xfs_perag_next(mp, pag)))
-		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
+		xfs_group_mark_healthy(pag_group(pag), XFS_SICK_AG_INDIRECT);
 }
 
 /*
@@ -206,9 +206,9 @@ xchk_update_health(
 	case XHG_AG:
 		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
 		if (bad)
-			xfs_ag_mark_corrupt(pag, sc->sick_mask);
+			xfs_group_mark_corrupt(pag_group(pag), sc->sick_mask);
 		else
-			xfs_ag_mark_healthy(pag, sc->sick_mask);
+			xfs_group_mark_healthy(pag_group(pag), sc->sick_mask);
 		xfs_perag_put(pag);
 		break;
 	case XHG_INO:
@@ -306,7 +306,7 @@ xchk_health_record(
 		xchk_set_corrupt(sc);
 
 	while ((pag = xfs_perag_next(mp, pag))) {
-		xfs_ag_measure_sickness(pag, &sick, &checked);
+		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
 		if (sick & XFS_SICK_AG_PRIMARY)
 			xchk_set_corrupt(sc);
 	}
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index ff5aca875ab0d0..732246f46680d5 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -38,9 +38,10 @@ xfs_health_unmount(
 
 	/* Measure AG corruption levels. */
 	while ((pag = xfs_perag_next(mp, pag))) {
-		xfs_ag_measure_sickness(pag, &sick, &checked);
+		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
 		if (sick) {
-			trace_xfs_ag_unfixed_corruption(pag, sick);
+			trace_xfs_group_unfixed_corruption(pag_group(pag),
+					sick);
 			warn = true;
 		}
 	}
@@ -227,61 +228,65 @@ xfs_agno_mark_sick(
 
 /* Mark unhealthy per-ag metadata. */
 void
-xfs_ag_mark_sick(
-	struct xfs_perag	*pag,
+xfs_group_mark_sick(
+	struct xfs_group	*xg,
 	unsigned int		mask)
 {
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
-	trace_xfs_ag_mark_sick(pag, mask);
+	trace_xfs_group_mark_sick(xg, mask);
 
-	spin_lock(&pag->pag_state_lock);
-	pag->pag_sick |= mask;
-	spin_unlock(&pag->pag_state_lock);
+	spin_lock(&xg->xg_state_lock);
+	xg->xg_sick |= mask;
+	spin_unlock(&xg->xg_state_lock);
 }
 
-/* Mark per-ag metadata as having been checked and found unhealthy by fsck. */
+/*
+ * Mark per-group metadata as having been checked and found unhealthy by fsck.
+ */
 void
-xfs_ag_mark_corrupt(
-	struct xfs_perag	*pag,
+xfs_group_mark_corrupt(
+	struct xfs_group	*xg,
 	unsigned int		mask)
 {
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
-	trace_xfs_ag_mark_corrupt(pag, mask);
+	trace_xfs_group_mark_corrupt(xg, mask);
 
-	spin_lock(&pag->pag_state_lock);
-	pag->pag_sick |= mask;
-	pag->pag_checked |= mask;
-	spin_unlock(&pag->pag_state_lock);
+	spin_lock(&xg->xg_state_lock);
+	xg->xg_sick |= mask;
+	xg->xg_checked |= mask;
+	spin_unlock(&xg->xg_state_lock);
 }
 
-/* Mark per-ag metadata ok. */
+/*
+ * Mark per-group metadata ok.
+ */
 void
-xfs_ag_mark_healthy(
-	struct xfs_perag	*pag,
+xfs_group_mark_healthy(
+	struct xfs_group	*xg,
 	unsigned int		mask)
 {
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
-	trace_xfs_ag_mark_healthy(pag, mask);
+	trace_xfs_group_mark_healthy(xg, mask);
 
-	spin_lock(&pag->pag_state_lock);
-	pag->pag_sick &= ~mask;
-	if (!(pag->pag_sick & XFS_SICK_AG_PRIMARY))
-		pag->pag_sick &= ~XFS_SICK_AG_SECONDARY;
-	pag->pag_checked |= mask;
-	spin_unlock(&pag->pag_state_lock);
+	spin_lock(&xg->xg_state_lock);
+	xg->xg_sick &= ~mask;
+	if (!(xg->xg_sick & XFS_SICK_AG_PRIMARY))
+		xg->xg_sick &= ~XFS_SICK_AG_SECONDARY;
+	xg->xg_checked |= mask;
+	spin_unlock(&xg->xg_state_lock);
 }
 
 /* Sample which per-ag metadata are unhealthy. */
 void
-xfs_ag_measure_sickness(
-	struct xfs_perag	*pag,
+xfs_group_measure_sickness(
+	struct xfs_group	*xg,
 	unsigned int		*sick,
 	unsigned int		*checked)
 {
-	spin_lock(&pag->pag_state_lock);
-	*sick = pag->pag_sick;
-	*checked = pag->pag_checked;
-	spin_unlock(&pag->pag_state_lock);
+	spin_lock(&xg->xg_state_lock);
+	*sick = xg->xg_sick;
+	*checked = xg->xg_checked;
+	spin_unlock(&xg->xg_state_lock);
 }
 
 /* Mark the unhealthy parts of an inode. */
@@ -447,7 +452,7 @@ xfs_ag_geom_health(
 	ageo->ag_sick = 0;
 	ageo->ag_checked = 0;
 
-	xfs_ag_measure_sickness(pag, &sick, &checked);
+	xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
 	for (m = ag_map; m->sick_mask; m++) {
 		if (checked & m->sick_mask)
 			ageo->ag_checked |= m->ioctl_mask;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c79b8e98156138..5c43db0ddf4526 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4220,31 +4220,34 @@ DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_corrupt);
 DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
 DEFINE_FS_CORRUPT_EVENT(xfs_rt_unfixed_corruption);
 
-DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
-	TP_PROTO(const struct xfs_perag *pag, unsigned int flags),
-	TP_ARGS(pag, flags),
+DECLARE_EVENT_CLASS(xfs_group_corrupt_class,
+	TP_PROTO(const struct xfs_group *xg, unsigned int flags),
+	TP_ARGS(xg, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_group_type, type)
+		__field(uint32_t, index)
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->index = xg->xg_gno;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x flags 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno, __entry->flags)
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
+		  __entry->index, __entry->flags)
 );
-#define DEFINE_AG_CORRUPT_EVENT(name)	\
-DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
-	TP_PROTO(const struct xfs_perag *pag, unsigned int flags), \
-	TP_ARGS(pag, flags))
-DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
-DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_corrupt);
-DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
-DEFINE_AG_CORRUPT_EVENT(xfs_ag_unfixed_corruption);
+#define DEFINE_GROUP_CORRUPT_EVENT(name)	\
+DEFINE_EVENT(xfs_group_corrupt_class, name,	\
+	TP_PROTO(const struct xfs_group *xg, unsigned int flags), \
+	TP_ARGS(xg, flags))
+DEFINE_GROUP_CORRUPT_EVENT(xfs_group_mark_sick);
+DEFINE_GROUP_CORRUPT_EVENT(xfs_group_mark_corrupt);
+DEFINE_GROUP_CORRUPT_EVENT(xfs_group_mark_healthy);
+DEFINE_GROUP_CORRUPT_EVENT(xfs_group_unfixed_corruption);
 
 DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned int flags),

