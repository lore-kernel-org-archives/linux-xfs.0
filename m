Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfDPAUL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:20:11 -0400
Subject: [PATCH 5/5] xfs: scrub should only cross-reference with healthy
 btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Apr 2019 17:20:01 -0700
Message-ID: <155537400192.27935.5071586825961103642.stgit@magnolia>
In-Reply-To: <155537397092.27935.16073573221774618735.stgit@magnolia>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Skip cross-referencing with a btree if the health report tells us that
it's known to be bad.  This should reduce the dmesg spew considerably.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   20 ++++++++++---
 fs/xfs/scrub/health.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h |    2 +
 3 files changed, 93 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 0c54ff55b901..7076d5c98151 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -38,6 +38,7 @@
 #include "scrub/trace.h"
 #include "scrub/btree.h"
 #include "scrub/repair.h"
+#include "scrub/health.h"
 
 /* Common code for the metadata scrubbers. */
 
@@ -458,13 +459,18 @@ xchk_ag_btcur_init(
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agnumber_t		agno = sa->agno;
 
-	if (sa->agf_bp) {
+	xchk_perag_get(sc->mp, sa);
+	if (sa->agf_bp &&
+	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_BNO)) {
 		/* Set up a bnobt cursor for cross-referencing. */
 		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno, XFS_BTNUM_BNO);
 		if (!sa->bno_cur)
 			goto err;
+	}
 
+	if (sa->agf_bp &&
+	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_CNT)) {
 		/* Set up a cntbt cursor for cross-referencing. */
 		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno, XFS_BTNUM_CNT);
@@ -473,7 +479,8 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a inobt cursor for cross-referencing. */
-	if (sa->agi_bp) {
+	if (sa->agi_bp &&
+	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_INO)) {
 		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
 					agno, XFS_BTNUM_INO);
 		if (!sa->ino_cur)
@@ -481,7 +488,8 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a finobt cursor for cross-referencing. */
-	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_FINO)) {
 		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
 				agno, XFS_BTNUM_FINO);
 		if (!sa->fino_cur)
@@ -489,7 +497,8 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a rmapbt cursor for cross-referencing. */
-	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
 		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno);
 		if (!sa->rmap_cur)
@@ -497,7 +506,8 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a refcountbt cursor for cross-referencing. */
-	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_REFC)) {
 		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
 				sa->agf_bp, agno);
 		if (!sa->refc_cur)
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 770ab0723a38..bc0715eea123 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -174,3 +174,79 @@ xchk_update_health(
 		break;
 	}
 }
+
+/* Is the given per-AG btree healthy enough for scanning? */
+bool
+xchk_ag_btree_healthy_enough(
+	struct xfs_scrub	*sc,
+	struct xfs_perag	*pag,
+	xfs_btnum_t		btnum)
+{
+	unsigned int		mask = 0;
+
+	/*
+	 * We always want the cursor if it's the same type as whatever we're
+	 * scrubbing, even if we already know the structure is corrupt.
+	 */
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_BNOBT:
+		if (btnum == XFS_BTNUM_BNO)
+			return true;
+		break;
+	case XFS_SCRUB_TYPE_CNTBT:
+		if (btnum == XFS_BTNUM_CNT)
+			return true;
+		break;
+	case XFS_SCRUB_TYPE_INOBT:
+		if (btnum == XFS_BTNUM_INO)
+			return true;
+		break;
+	case XFS_SCRUB_TYPE_FINOBT:
+		if (btnum == XFS_BTNUM_FINO)
+			return true;
+		break;
+	case XFS_SCRUB_TYPE_RMAPBT:
+		if (btnum == XFS_BTNUM_RMAP)
+			return true;
+		break;
+	case XFS_SCRUB_TYPE_REFCNTBT:
+		if (btnum == XFS_BTNUM_REFC)
+			return true;
+		break;
+	}
+
+	/*
+	 * Otherwise, we're only interested in the btree for cross-referencing.
+	 * If we know the btree is bad then don't bother, just set XFAIL.
+	 */
+	switch (btnum) {
+	case XFS_BTNUM_BNO:
+		mask = XFS_SICK_AG_BNOBT;
+		break;
+	case XFS_BTNUM_CNT:
+		mask = XFS_SICK_AG_CNTBT;
+		break;
+	case XFS_BTNUM_INO:
+		mask = XFS_SICK_AG_INOBT;
+		break;
+	case XFS_BTNUM_FINO:
+		mask = XFS_SICK_AG_FINOBT;
+		break;
+	case XFS_BTNUM_RMAP:
+		mask = XFS_SICK_AG_RMAPBT;
+		break;
+	case XFS_BTNUM_REFC:
+		mask = XFS_SICK_AG_REFCNTBT;
+		break;
+	default:
+		ASSERT(0);
+		return true;
+	}
+
+	if (xfs_ag_has_sickness(pag, mask)) {
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
+		return false;
+	}
+
+	return true;
+}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index fd0d466c8658..d0b938d3d028 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -8,5 +8,7 @@
 
 unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc);
+bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
+		xfs_btnum_t btnum);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
