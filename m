Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614F6BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHjbNSCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E83EC433C8;
	Sun, 31 Dec 2023 21:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057525;
	bh=HNd/hE4iYzNpHP6mDwbkWFjS4bHwx7bRu2NRqNSnA+Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jHjbNSCXbiSiqOKzxNPzcwi1UQC6uuw2lbbZNC6agtXe+PiJ5DFoJYFKaMTaIsRzY
	 +8OpTj9BJz42I9Vop3vqJEom+EwN9z2FZo1NB3UtGPJFeiUwfVfWNQuWZ+NNcWy3yO
	 Yr64Xr3kgBNw8mOIb2eaM2sZNWUm+/sVfzYAnc0TJNf/A13+KPFr50fPIrwdZw2OWa
	 yygYavDApejRZeHBWNaqBASoGLIhO1TKSRHNSKU5cRjbgtMUA6BSzQV/6gSK/qufDK
	 BtH8GSAeM+ll/FZT5sl2FAGVS5tv/TrnPhIv7afDTJcMErQHNzXrUhfPpXqs1uGXjv
	 AvG0ZShx818aQ==
Date: Sun, 31 Dec 2023 13:18:44 -0800
Subject: [PATCH 12/24] xfs: record rt group superblock errors in the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846432.1763124.13705528400720269212.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Record the state of per-rtgroup metadata sickness in the rtgroup
structure for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h  |   28 ++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    8 ++++
 fs/xfs/scrub/health.c       |   24 ++++++++++++
 fs/xfs/xfs_health.c         |   86 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h          |   25 +++++++++++++
 5 files changed, 170 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 1816c67351ac8..f5449a804c6c8 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -52,6 +52,7 @@ struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
 struct xfs_da_args;
+struct xfs_rtgroup;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -66,6 +67,7 @@ struct xfs_da_args;
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+#define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -110,7 +112,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_METAPATH)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+				 XFS_SICK_RT_SUMMARY | \
+				 XFS_SICK_RT_SUPER)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
@@ -192,6 +195,14 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_rgno_mark_sick(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		unsigned int mask);
+void xfs_rtgroup_mark_sick(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_checked(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_healthy(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_measure_sickness(struct xfs_rtgroup *rtg, unsigned int *sick,
+		unsigned int *checked);
+
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
@@ -241,6 +252,15 @@ xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
 	return sick & mask;
 }
 
+static inline bool
+xfs_rtgroup_has_sickness(struct xfs_rtgroup *rtg, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+	return sick & mask;
+}
+
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
 {
@@ -262,6 +282,12 @@ xfs_rt_is_healthy(struct xfs_mount *mp)
 	return !xfs_rt_has_sickness(mp, -1U);
 }
 
+static inline bool
+xfs_rtgroup_is_healthy(struct xfs_rtgroup *rtg)
+{
+	return !xfs_rtgroup_has_sickness(rtg, -1U);
+}
+
 static inline bool
 xfs_ag_is_healthy(struct xfs_perag *pag)
 {
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 2d0422c6712da..c3f4f644ea56b 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -25,6 +25,14 @@ struct xfs_rtgroup {
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
+	/*
+	 * Bitsets of per-rtgroup metadata that have been checked and/or are
+	 * sick.  Callers should hold rtg_state_lock before accessing this
+	 * field.
+	 */
+	uint16_t		rtg_checked;
+	uint16_t		rtg_sick;
+
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 	spinlock_t		rtg_state_lock;
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 4aae9a594cce5..063176c1f35eb 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -14,6 +14,7 @@
 #include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/health.h"
 #include "scrub/common.h"
@@ -76,6 +77,7 @@ enum xchk_health_group {
 	XHG_RT,
 	XHG_AG,
 	XHG_INO,
+	XHG_RTGROUP,
 };
 
 struct xchk_health_map {
@@ -164,12 +166,16 @@ xchk_mark_all_healthy(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 
 	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
 	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
 	for_each_perag(mp, agno, pag)
 		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
+	for_each_rtgroup(mp, rgno, rtg)
+		xfs_rtgroup_mark_healthy(rtg, XFS_SICK_RT_INDIRECT);
 }
 
 /*
@@ -187,6 +193,7 @@ xchk_update_health(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	bool			bad;
 
 	/*
@@ -249,6 +256,15 @@ xchk_update_health(
 		} else
 			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
 		break;
+	case XHG_RTGROUP:
+		rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
+		if (bad) {
+			xfs_rtgroup_mark_sick(rtg, sc->sick_mask);
+			xfs_rtgroup_mark_checked(rtg, sc->sick_mask);
+		} else
+			xfs_rtgroup_mark_healthy(rtg, sc->sick_mask);
+		xfs_rtgroup_put(rtg);
+		break;
 	default:
 		ASSERT(0);
 		break;
@@ -336,7 +352,9 @@ xchk_health_record(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 
 	unsigned int		sick;
 	unsigned int		checked;
@@ -355,5 +373,11 @@ xchk_health_record(
 			xchk_set_corrupt(sc);
 	}
 
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+		if (sick & XFS_SICK_RT_PRIMARY)
+			xchk_set_corrupt(sc);
+	}
+
 	return 0;
 }
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b7aa33a4c9e06..1ec015663a6aa 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -18,6 +18,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -29,7 +30,9 @@ xfs_health_unmount(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	unsigned int		sick = 0;
 	unsigned int		checked = 0;
 	bool			warn = false;
@@ -46,6 +49,15 @@ xfs_health_unmount(
 		}
 	}
 
+	/* Measure realtime group corruption levels. */
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+		if (sick) {
+			trace_xfs_rtgroup_unfixed_corruption(rtg, sick);
+			warn = true;
+		}
+	}
+
 	/* Measure realtime volume corruption levels. */
 	xfs_rt_measure_sickness(mp, &sick, &checked);
 	if (sick) {
@@ -280,6 +292,80 @@ xfs_ag_measure_sickness(
 	spin_unlock(&pag->pag_state_lock);
 }
 
+/* Mark unhealthy per-rtgroup metadata given a raw rt group number. */
+void
+xfs_rgno_mark_sick(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	unsigned int		mask)
+{
+	struct xfs_rtgroup	*rtg = xfs_rtgroup_get(mp, rgno);
+
+	/* per-rtgroup structure not set up yet? */
+	if (!rtg)
+		return;
+
+	xfs_rtgroup_mark_sick(rtg, mask);
+	xfs_rtgroup_put(rtg);
+}
+
+/* Mark unhealthy per-rtgroup metadata. */
+void
+xfs_rtgroup_mark_sick(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
+	trace_xfs_rtgroup_mark_sick(rtg, mask);
+
+	spin_lock(&rtg->rtg_state_lock);
+	rtg->rtg_sick |= mask;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
+/* Mark per-rtgroup metadata as having been checked. */
+void
+xfs_rtgroup_mark_checked(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+
+	spin_lock(&rtg->rtg_state_lock);
+	rtg->rtg_checked |= mask;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
+/* Mark per-rtgroup metadata ok. */
+void
+xfs_rtgroup_mark_healthy(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
+	trace_xfs_rtgroup_mark_healthy(rtg, mask);
+
+	spin_lock(&rtg->rtg_state_lock);
+	rtg->rtg_sick &= ~mask;
+	if (!(rtg->rtg_sick & XFS_SICK_RT_PRIMARY))
+		rtg->rtg_sick &= ~XFS_SICK_RT_SECONDARY;
+	rtg->rtg_checked |= mask;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
+/* Sample which per-rtgroup metadata are unhealthy. */
+void
+xfs_rtgroup_measure_sickness(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		*sick,
+	unsigned int		*checked)
+{
+	spin_lock(&rtg->rtg_state_lock);
+	*sick = rtg->rtg_sick;
+	*checked = rtg->rtg_checked;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
 /* Mark the unhealthy parts of an inode. */
 void
 xfs_inode_mark_sick(
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 81c21000d4fea..d23566e841cba 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4307,6 +4307,31 @@ DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_unfixed_corruption);
 
+DECLARE_EVENT_CLASS(xfs_rtgroup_corrupt_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned int flags),
+	TP_ARGS(rtg, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d rgno 0x%x flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno, __entry->flags)
+);
+#define DEFINE_RTGROUP_CORRUPT_EVENT(name)	\
+DEFINE_EVENT(xfs_rtgroup_corrupt_class, name,	\
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned int flags), \
+	TP_ARGS(rtg, flags))
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_mark_sick);
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_mark_healthy);
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_unfixed_corruption);
+
 DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
 	TP_ARGS(ip, flags),

