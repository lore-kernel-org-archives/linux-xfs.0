Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC9DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiLaBcb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaBc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:32:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF81DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C93BB81E01
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F62C433D2;
        Sat, 31 Dec 2022 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450344;
        bh=/KF70EJzvgd7fcguBqJo/W+FA1CLAQkzyn7JHFNbGtE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ns9Sc6i0DSpuZuprC/GQ6lOvJyYWLORo5W4I37rAwY6/CpALrjK9U3KYnu2YJviC1
         bUoMXQgnarBhTXY3qDDquhi/xdgIYV2+26uebYxJRnZ6dvOpd5ad/0ZHjaXy0FG8TQ
         milHVc4sHCOHFiQTCVoiFrxR+ywFOX/P1errg/TMlFefFMAa2+0et3a6qFZl2sCUoB
         R7qU7d+GR6w22mEVzvuNRJ4VO15Jk7D5BwVJ+owRa1GLQhwZMNv+BhBK9unKg6cYH+
         i+MFNNCTrQcqbXOy/wKyhA3I99BCcvFdHjnJSgsNLaiUQKWOdZTh1sMYqq8+Ta5HQl
         3JQOc5tZY3NmA==
Subject: [PATCH 19/22] xfs: scrub the realtime group superblock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867539.712847.15291040944782337347.stgit@magnolia>
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

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/scrub/common.c  |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |   46 ++++++++++++++-----------
 fs/xfs/scrub/health.c  |    1 +
 fs/xfs/scrub/rgsuper.c |   77 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   20 ++++++++++-
 fs/xfs/scrub/scrub.h   |   40 ++++++++++------------
 fs/xfs/scrub/trace.h   |    4 ++
 9 files changed, 236 insertions(+), 44 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 135a403c0edc..a02fb09fed64 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -178,6 +178,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rgsuper.o \
 				   rtbitmap.o \
 				   rtsummary.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e3d87665e4a5..c12be9dbb59d 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -741,9 +741,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
+#define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	28
+#define XFS_SCRUB_TYPE_NR	29
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1b48726fcc65..b63b5c016841 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -34,6 +34,7 @@
 #include "xfs_quota.h"
 #include "xfs_swapext.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -121,6 +122,17 @@ xchk_process_error(
 			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
 }
 
+bool
+xchk_process_rt_error(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno,
+	int			*error)
+{
+	return __xchk_process_error(sc, rgno, rgbno, error,
+			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
+}
+
 bool
 xchk_xref_process_error(
 	struct xfs_scrub	*sc,
@@ -132,6 +144,17 @@ xchk_xref_process_error(
 			XFS_SCRUB_OFLAG_XFAIL, __return_address);
 }
 
+bool
+xchk_xref_process_rt_error(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno,
+	int			*error)
+{
+	return __xchk_process_error(sc, rgno, rgbno, error,
+			XFS_SCRUB_OFLAG_XFAIL, __return_address);
+}
+
 /* Check for operational errors for a file offset. */
 static bool
 __xchk_fblock_process_error(
@@ -691,6 +714,7 @@ xchk_rt_init(
 					 XCHK_RTLOCK_BITMAP_SHARED)) < 2);
 	ASSERT(hweight32(rtlock_flags & (XCHK_RTLOCK_SUMMARY |
 					 XCHK_RTLOCK_SUMMARY_SHARED)) < 2);
+	ASSERT(sr->rtg == NULL);
 
 	if (rtlock_flags & XCHK_RTLOCK_BITMAP)
 		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_EXCL);
@@ -714,6 +738,8 @@ xchk_rt_unlock(
 	struct xfs_scrub	*sc,
 	struct xchk_rt		*sr)
 {
+	ASSERT(sr->rtg == NULL);
+
 	if (!sr->rtlock_flags)
 		return;
 
@@ -730,6 +756,68 @@ xchk_rt_unlock(
 	sr->rtlock_flags = 0;
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * For scrubbing a realtime group, grab all the in-core resources we'll need to
+ * check the metadata, which means taking the ILOCK of the realtime group's
+ * metadata inodes.  Callers must not join these inodes to the transaction with
+ * non-zero lockflags or concurrency problems will result.  The @rtglock_flags
+ * argument takes XFS_RTGLOCK_* flags.
+ */
+int
+xchk_rtgroup_init(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(sr->rtg == NULL);
+	ASSERT(sr->rtlock_flags == 0);
+
+	sr->rtg = xfs_rtgroup_get(sc->mp, rgno);
+	if (!sr->rtg)
+		return -ENOENT;
+
+	xfs_rtgroup_lock(NULL, sr->rtg, rtglock_flags);
+	sr->rtlock_flags = rtglock_flags;
+	return 0;
+}
+
+/*
+ * Unlock the realtime group.  This must be done /after/ committing (or
+ * cancelling) the scrub transaction.
+ */
+void
+xchk_rtgroup_unlock(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg != NULL);
+
+	if (sr->rtlock_flags) {
+		xfs_rtgroup_unlock(sr->rtg, sr->rtlock_flags);
+		sr->rtlock_flags = 0;
+	}
+}
+
+/*
+ * Unlock the realtime group and release its resources.  This must be done
+ * /after/ committing (or cancelling) the scrub transaction.
+ */
+void
+xchk_rtgroup_free(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg != NULL);
+
+	xchk_rtgroup_unlock(sc, sr);
+
+	xfs_rtgroup_put(sr->rtg);
+	sr->rtg = NULL;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Per-scrubber setup functions */
 
 void
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e41224065421..96bb8bc676e7 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -37,11 +37,15 @@ void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
+bool xchk_process_rt_error(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		xfs_rgblock_t rgbno, int *error);
 bool xchk_fblock_process_error(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
 bool xchk_xref_process_error(struct xfs_scrub *sc,
 		xfs_agnumber_t agno, xfs_agblock_t bno, int *error);
+bool xchk_xref_process_rt_error(struct xfs_scrub *sc,
+		xfs_rgnumber_t rgno, xfs_rgblock_t rgbno, int *error);
 bool xchk_fblock_xref_process_error(struct xfs_scrub *sc,
 		int whichfork, xfs_fileoff_t offset, int *error);
 
@@ -78,6 +82,11 @@ int xchk_checkpoint_log(struct xfs_mount *mp);
 bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
+static inline int xchk_setup_nothing(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+
 /* Setup functions */
 int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
@@ -95,17 +104,11 @@ int xchk_setup_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
+int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_setup_rtbitmap(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_setup_rtsummary(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_setup_rtbitmap		xchk_setup_nothing
+# define xchk_setup_rtsummary		xchk_setup_nothing
+# define xchk_setup_rgsuperblock	xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -117,16 +120,8 @@ xchk_ino_dqattach(struct xfs_scrub *sc)
 {
 	return 0;
 }
-static inline int
-xchk_setup_quota(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_setup_quotacheck(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_setup_quota		xchk_setup_nothing
+# define xchk_setup_quotacheck		xchk_setup_nothing
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc);
 int xchk_setup_nlinks(struct xfs_scrub *sc);
@@ -169,6 +164,17 @@ xchk_ag_init_existing(
 void xchk_rt_init(struct xfs_scrub *sc, struct xchk_rt *sr,
 		unsigned int xchk_rtlock_flags);
 void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
+
+#ifdef CONFIG_XFS_RT
+int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		struct xchk_rt *sr, unsigned int rtglock_flags);
+void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
+void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+#else
+# define xchk_rtgroup_init(sc, rgno, sr, lockflags)	(-ENOSYS)
+# define xchk_rtgroup_free(sc, sr)			((void)0)
+#endif /* CONFIG_XFS_RT */
+
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 9a8d4c348cc9..a71d4d9087b2 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -112,6 +112,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
+	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RT_SUPER },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
new file mode 100644
index 000000000000..a85ad580aa62
--- /dev/null
+++ b/fs/xfs/scrub/rgsuper.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_rtgroup.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+
+/* Set us up with a transaction and an empty context. */
+int
+xchk_setup_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	return xchk_trans_alloc(sc, 0);
+}
+
+/* Cross-reference with the other rt metadata. */
+STATIC void
+xchk_rgsuperblock_xref(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	xfs_rgnumber_t		rgno = sc->sr.rtg->rtg_rgno;
+	xfs_rtblock_t		rtbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+	xchk_xref_is_used_rt_space(sc, rtbno, 1);
+}
+
+int
+xchk_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_buf		*bp;
+	xfs_rgnumber_t		rgno = sc->sm->sm_agno;
+	int			error;
+
+	/*
+	 * Grab an active reference to the rtgroup structure.  If we can't get
+	 * it, we're racing with something that's tearing down the group, so
+	 * signal that the group no longer exists.  Take the rtbitmap in shared
+	 * mode so that the group can't change while we're doing things.
+	 */
+	error = xchk_rtgroup_init(sc, rgno, &sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+	if (error)
+		return error;
+
+	/*
+	 * If this is the primary rtgroup superblock, we know it passed the
+	 * verifier checks at mount time and do not need to load the buffer
+	 * again.
+	 */
+	if (sc->sr.rtg->rtg_rgno == 0) {
+		xchk_rgsuperblock_xref(sc);
+		return 0;
+	}
+
+	/* The secondary rt super is checked by the read verifier. */
+	error = xfs_buf_read_uncached(sc->mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
+	if (!xchk_process_rt_error(sc, rgno, 0, &error))
+		return error;
+
+	xchk_rgsuperblock_xref(sc);
+	xfs_buf_relse(bp);
+	return 0;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1b3820b30384..6c54f00b516c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -189,7 +189,10 @@ xchk_teardown(
 			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
-	xchk_rt_unlock(sc, &sc->sr);
+	if (sc->sr.rtg)
+		xchk_rtgroup_free(sc, &sc->sr);
+	else
+		xchk_rt_unlock(sc, &sc->sr);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);
@@ -406,6 +409,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_health_record,
 		.repair = xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_RGSUPER] = {	/* realtime group superblock */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rgsuperblock,
+		.scrub	= xchk_rgsuperblock,
+		.has	= xfs_has_rtgroups,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
@@ -453,6 +463,14 @@ xchk_validate_inputs(
 		if (sm->sm_agno || (sm->sm_gen && !sm->sm_ino))
 			goto out;
 		break;
+	case ST_RTGROUP:
+		if (sm->sm_ino || sm->sm_gen)
+			goto out;
+		if (!xfs_has_rtgroups(mp) && sm->sm_agno != 0)
+			goto out;
+		if (xfs_has_rtgroups(mp) && sm->sm_agno >= mp->m_sb.sb_rgcount)
+			goto out;
+		break;
 	default:
 		goto out;
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 38437104fc86..6e5b96b6db81 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -23,6 +23,7 @@ enum xchk_type {
 	ST_PERAG,	/* per-AG metadata */
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
+	ST_RTGROUP,	/* rtgroup metadata */
 };
 
 struct xchk_meta_ops {
@@ -69,7 +70,13 @@ struct xchk_ag {
 
 /* Inode lock state for the RT volume. */
 struct xchk_rt {
-	/* XCHK_RTLOCK_* lock state */
+	/* incore rtgroup, if applicable */
+	struct xfs_rtgroup	*rtg;
+
+	/*
+	 * XCHK_RTLOCK_* lock state if rtg == NULL, or XFS_RTGLOCK_* lock state
+	 * if rtg != NULL.
+	 */
 	unsigned int		rtlock_flags;
 };
 
@@ -153,6 +160,11 @@ struct xfs_scrub {
 				 XCHK_FSHOOKS_NLINKS | \
 				 XCHK_FSHOOKS_RMAP)
 
+static inline int xchk_nothing(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
@@ -176,32 +188,18 @@ int xchk_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
+int xchk_rgsuperblock(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_rtbitmap(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_rtsummary(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_rtbitmap		xchk_nothing
+# define xchk_rtsummary		xchk_nothing
+# define xchk_rgsuperblock	xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
 int xchk_quotacheck(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_quota(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_quotacheck(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_quota		xchk_nothing
+# define xchk_quotacheck	xchk_nothing
 #endif
 int xchk_fscounters(struct xfs_scrub *sc);
 int xchk_nlinks(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 749cf4333c8a..a88ad16c90db 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -74,6 +74,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -103,7 +104,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
-	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
+	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

