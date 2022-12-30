Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B78C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiLaBaW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiLaBaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B581C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A2B61CBD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65FFC433EF;
        Sat, 31 Dec 2022 01:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450219;
        bh=xDt0LxEVdf6t3YtUYl+tYYZaWTXMaeF/lgg0bLFFQf4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MlqCCXMI7XkvazPK+tpBlZxHuKufTS0NBw4dUXe0UI4plIEbtx/6FY4PFI9/O0Ft+
         nRKiYZ+YbwugjjURohEooY1pc8TKc3hXBGNhwSNWAbG6DisnDNvyeo5M5JBJEg01rb
         GVViI+OId57DfVUDb0Utq1TMibWhkufKsQrmIQBNScBYGGxzYxkVs97/NOkqyPyv6O
         wU4oycRmYFsYBYSE3AVPcPV6sKUkAbvMG8CGObYV7YKaggzGaHiBK32rdINjjKF2PS
         kh6FljDJFQsAQRLiCK4LH5D5E88M/nbaV2TV1oyhyP9P3dAKklbST8Ca4fkD7G2ul1
         M2YUUM+GG9xdA==
Subject: [PATCH 11/22] xfs: record rt group superblock errors in the health
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:54 -0800
Message-ID: <167243867425.712847.12469199718186901143.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Record the state of per-rtgroup metadata sickness in the rtgroup
structure for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h  |   28 ++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    8 ++++
 fs/xfs/scrub/health.c       |   24 ++++++++++++
 fs/xfs/xfs_health.c         |   86 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.c          |    1 +
 fs/xfs/xfs_trace.h          |   26 +++++++++++++
 6 files changed, 172 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 99d53bae9c13..0beb4153a43e 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -52,6 +52,7 @@ struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
 struct xfs_da_args;
+struct xfs_rtgroup;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -65,6 +66,7 @@ struct xfs_da_args;
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+#define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -101,7 +103,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+				 XFS_SICK_RT_SUMMARY | \
+				 XFS_SICK_RT_SUPER)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
@@ -176,6 +179,14 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
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
@@ -225,6 +236,15 @@ xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
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
@@ -246,6 +266,12 @@ xfs_rt_is_healthy(struct xfs_mount *mp)
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
index d8723fabeb57..0e664e2436b0 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -23,6 +23,14 @@ struct xfs_rtgroup {
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
index cdf059f47656..9a8d4c348cc9 100644
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
@@ -130,12 +132,16 @@ xchk_mark_all_healthy(
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
@@ -153,6 +159,7 @@ xchk_update_health(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	bool			bad;
 
 	/*
@@ -215,6 +222,15 @@ xchk_update_health(
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
@@ -302,7 +318,9 @@ xchk_health_record(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 
 	unsigned int		sick;
 	unsigned int		checked;
@@ -321,5 +339,11 @@ xchk_health_record(
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
index 61f7a6aca6b1..fe05b565427f 100644
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
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index e38814f4380c..36109a57fca6 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -42,6 +42,7 @@
 #include "xfs_bmap.h"
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
+#include "xfs_rtgroup.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f72f694b4656..ec9aa1914a93 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -82,6 +82,7 @@ struct xfs_icwalk;
 struct xfs_bmap_intent;
 struct xfs_swapext_intent;
 struct xfs_swapext_req;
+struct xfs_rtgroup;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -4233,6 +4234,31 @@ DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
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

