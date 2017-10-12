Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27967 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752622AbdJLBmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:42:12 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1gCs0032532
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1gBPx031724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:11 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1gBSl020304
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:11 GMT
Subject: [PATCH 13/30] xfs: create helpers to scan an allocation group
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:42:08 -0700
Message-ID: <150777252881.1724.797907625131044293.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some helpers to enable us to lock an AG's headers, create btree
cursors for all btrees in that allocation group, and clean up
afterwards.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |  179 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |   10 +++
 fs/xfs/scrub/scrub.c  |    4 +
 fs/xfs/scrub/scrub.h  |   21 ++++++
 4 files changed, 214 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 709d491..cd6fada 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -44,6 +44,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
+#include "scrub/btree.h"
 
 /* Common code for the metadata scrubbers. */
 
@@ -237,6 +238,184 @@ xfs_scrub_set_incomplete(
 	trace_xfs_scrub_incomplete(sc, __return_address);
 }
 
+/*
+ * AG scrubbing
+ *
+ * These helpers facilitate locking an allocation group's header
+ * buffers, setting up cursors for all btrees that are present, and
+ * cleaning everything up once we're through.
+ */
+
+/*
+ * Grab all the headers for an AG.
+ *
+ * The headers should be released by xfs_scrub_ag_free, but as a fail
+ * safe we attach all the buffers we grab to the scrub transaction so
+ * they'll all be freed when we cancel it.
+ */
+int
+xfs_scrub_ag_read_headers(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	struct xfs_buf			**agi,
+	struct xfs_buf			**agf,
+	struct xfs_buf			**agfl)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error;
+
+	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
+	if (error)
+		goto out;
+
+	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
+	if (error)
+		goto out;
+	if (!*agf) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
+	if (error)
+		goto out;
+
+out:
+	return error;
+}
+
+/* Release all the AG btree cursors. */
+void
+xfs_scrub_ag_btcur_free(
+	struct xfs_scrub_ag		*sa)
+{
+	if (sa->refc_cur)
+		xfs_btree_del_cursor(sa->refc_cur, XFS_BTREE_ERROR);
+	if (sa->rmap_cur)
+		xfs_btree_del_cursor(sa->rmap_cur, XFS_BTREE_ERROR);
+	if (sa->fino_cur)
+		xfs_btree_del_cursor(sa->fino_cur, XFS_BTREE_ERROR);
+	if (sa->ino_cur)
+		xfs_btree_del_cursor(sa->ino_cur, XFS_BTREE_ERROR);
+	if (sa->cnt_cur)
+		xfs_btree_del_cursor(sa->cnt_cur, XFS_BTREE_ERROR);
+	if (sa->bno_cur)
+		xfs_btree_del_cursor(sa->bno_cur, XFS_BTREE_ERROR);
+
+	sa->refc_cur = NULL;
+	sa->rmap_cur = NULL;
+	sa->fino_cur = NULL;
+	sa->ino_cur = NULL;
+	sa->bno_cur = NULL;
+	sa->cnt_cur = NULL;
+}
+
+/* Initialize all the btree cursors for an AG. */
+int
+xfs_scrub_ag_btcur_init(
+	struct xfs_scrub_context	*sc,
+	struct xfs_scrub_ag		*sa)
+{
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agnumber_t			agno = sa->agno;
+
+	if (sa->agf_bp) {
+		/* Set up a bnobt cursor for cross-referencing. */
+		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				agno, XFS_BTNUM_BNO);
+		if (!sa->bno_cur)
+			goto err;
+
+		/* Set up a cntbt cursor for cross-referencing. */
+		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				agno, XFS_BTNUM_CNT);
+		if (!sa->cnt_cur)
+			goto err;
+	}
+
+	/* Set up a inobt cursor for cross-referencing. */
+	if (sa->agi_bp) {
+		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
+					agno, XFS_BTNUM_INO);
+		if (!sa->ino_cur)
+			goto err;
+	}
+
+	/* Set up a finobt cursor for cross-referencing. */
+	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
+				agno, XFS_BTNUM_FINO);
+		if (!sa->fino_cur)
+			goto err;
+	}
+
+	/* Set up a rmapbt cursor for cross-referencing. */
+	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				agno);
+		if (!sa->rmap_cur)
+			goto err;
+	}
+
+	/* Set up a refcountbt cursor for cross-referencing. */
+	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb)) {
+		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
+				sa->agf_bp, agno, NULL);
+		if (!sa->refc_cur)
+			goto err;
+	}
+
+	return 0;
+err:
+	return -ENOMEM;
+}
+
+/* Release the AG header context and btree cursors. */
+void
+xfs_scrub_ag_free(
+	struct xfs_scrub_context	*sc,
+	struct xfs_scrub_ag		*sa)
+{
+	xfs_scrub_ag_btcur_free(sa);
+	if (sa->agfl_bp) {
+		xfs_trans_brelse(sc->tp, sa->agfl_bp);
+		sa->agfl_bp = NULL;
+	}
+	if (sa->agf_bp) {
+		xfs_trans_brelse(sc->tp, sa->agf_bp);
+		sa->agf_bp = NULL;
+	}
+	if (sa->agi_bp) {
+		xfs_trans_brelse(sc->tp, sa->agi_bp);
+		sa->agi_bp = NULL;
+	}
+	sa->agno = NULLAGNUMBER;
+}
+
+/*
+ * For scrub, grab the AGI and the AGF headers, in that order.  Locking
+ * order requires us to get the AGI before the AGF.  We use the
+ * transaction to avoid deadlocking on crosslinked metadata buffers;
+ * either the caller passes one in (bmap scrub) or we have to create a
+ * transaction ourselves.
+ */
+int
+xfs_scrub_ag_init(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	struct xfs_scrub_ag		*sa)
+{
+	int				error;
+
+	sa->agno = agno;
+	error = xfs_scrub_ag_read_headers(sc, agno, &sa->agi_bp,
+			&sa->agf_bp, &sa->agfl_bp);
+	if (error)
+		return error;
+
+	return xfs_scrub_ag_btcur_init(sc, sa);
+}
+
 /* Per-scrubber setup functions */
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 414bbb8..aca39b5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -77,4 +77,14 @@ void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
 /* Setup functions */
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 
+void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
+int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		      struct xfs_scrub_ag *sa);
+int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+			      struct xfs_buf **agi, struct xfs_buf **agf,
+			      struct xfs_buf **agfl);
+void xfs_scrub_ag_btcur_free(struct xfs_scrub_ag *sa);
+int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
+			    struct xfs_scrub_ag *sa);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 92eac98..3a98060 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -44,6 +44,8 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
+#include "scrub/scrub.h"
+#include "scrub/btree.h"
 
 /*
  * Online Scrub and Repair
@@ -131,6 +133,7 @@ xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
 	int				error)
 {
+	xfs_scrub_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
@@ -231,6 +234,7 @@ xfs_scrub_metadata(
 	sc.sm = sm;
 	sc.ops = ops;
 	sc.try_harder = try_harder;
+	sc.sa.agno = NULLAGNUMBER;
 	error = sc.ops->setup(&sc, ip);
 	if (error)
 		goto out_teardown;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b7b9422..1385295 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -34,6 +34,24 @@ struct xfs_scrub_meta_ops {
 	bool		(*has)(struct xfs_sb *);
 };
 
+/* Buffer pointers and btree cursors for an entire AG. */
+struct xfs_scrub_ag {
+	xfs_agnumber_t			agno;
+
+	/* AG btree roots */
+	struct xfs_buf			*agf_bp;
+	struct xfs_buf			*agfl_bp;
+	struct xfs_buf			*agi_bp;
+
+	/* AG btrees */
+	struct xfs_btree_cur		*bno_cur;
+	struct xfs_btree_cur		*cnt_cur;
+	struct xfs_btree_cur		*ino_cur;
+	struct xfs_btree_cur		*fino_cur;
+	struct xfs_btree_cur		*rmap_cur;
+	struct xfs_btree_cur		*refc_cur;
+};
+
 struct xfs_scrub_context {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
@@ -42,6 +60,9 @@ struct xfs_scrub_context {
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
 	bool				try_harder;
+
+	/* State tracking for single-AG operations. */
+	struct xfs_scrub_ag		sa;
 };
 
 /* Metadata scrubbers */

