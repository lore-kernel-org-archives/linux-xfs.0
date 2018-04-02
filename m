Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40282 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754686AbeDBTzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 15:55:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w32JicCg019769
        for <linux-xfs@vger.kernel.org>; Mon, 2 Apr 2018 19:55:43 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2h3txp01kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Apr 2018 19:55:43 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w32JtgeS027486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 2 Apr 2018 19:55:42 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w32Jtg4Q007533
        for <linux-xfs@vger.kernel.org>; Mon, 2 Apr 2018 19:55:42 GMT
Subject: [PATCH 2/2] xfs: hoist xfs_scrub_agfl_walk to libxfs as
 xfs_agfl_walk
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 02 Apr 2018 12:55:42 -0700
Message-ID: <152269894202.16253.2257249480679291752.stgit@magnolia>
In-Reply-To: <152269892987.16253.3900560313483881560.stgit@magnolia>
References: <152269892987.16253.3900560313483881560.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This function is basically a generic AGFL block iterator, so promote it
to libxfs ahead of online repair wanting to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   37 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |    5 +++
 fs/xfs/scrub/agheader.c   |   78 ++++++++-------------------------------------
 fs/xfs/scrub/common.h     |    4 --
 4 files changed, 55 insertions(+), 69 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4c03ec2..d860116 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3128,3 +3128,40 @@ xfs_alloc_has_record(
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
+
+/*
+ * Walk all the blocks in the AGFL.  The fn function can return any negative
+ * error code or XFS_BTREE_QUERY_RANGE_ABORT.
+ */
+int
+xfs_agfl_walk(
+	struct xfs_mount	*mp,
+	struct xfs_agf		*agf,
+	struct xfs_buf		*agflbp,
+	xfs_agfl_walk_fn	fn,
+	void			*priv)
+{
+	__be32			*agfl_bno;
+	unsigned int		i;
+	int			error;
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	i = be32_to_cpu(agf->agf_flfirst);
+
+	/* Nothing to walk in an empty AGFL. */
+	if (agf->agf_flcount == cpu_to_be32(0))
+		return 0;
+
+	/* Otherwise, walk from first to last, wrapping as needed. */
+	for (;;) {
+		error = fn(mp, be32_to_cpu(agfl_bno[i]), priv);
+		if (error)
+			return error;
+		if (i == be32_to_cpu(agf->agf_fllast))
+			break;
+		if (++i == xfs_agfl_size(mp))
+			i = 0;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a311a24..d4b83d1 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -249,4 +249,9 @@ bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exist);
 
+typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
+		void *priv);
+int xfs_agfl_walk(struct xfs_mount *mp, struct xfs_agf *agf,
+		struct xfs_buf *agflbp, xfs_agfl_walk_fn fn, void *priv);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 018aabbd..9bf1a1a 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -38,68 +38,6 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 
-/*
- * Walk all the blocks in the AGFL.  The fn function can return any negative
- * error code or XFS_BTREE_QUERY_RANGE_ABORT.
- */
-int
-xfs_scrub_walk_agfl(
-	struct xfs_scrub_context	*sc,
-	int				(*fn)(struct xfs_scrub_context *,
-					      xfs_agblock_t bno, void *),
-	void				*priv)
-{
-	struct xfs_agf			*agf;
-	__be32				*agfl_bno;
-	struct xfs_mount		*mp = sc->mp;
-	unsigned int			flfirst;
-	unsigned int			fllast;
-	int				i;
-	int				error;
-
-	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, sc->sa.agfl_bp);
-	flfirst = be32_to_cpu(agf->agf_flfirst);
-	fllast = be32_to_cpu(agf->agf_fllast);
-
-	/* Nothing to walk in an empty AGFL. */
-	if (agf->agf_flcount == cpu_to_be32(0))
-		return 0;
-
-	/* first to last is a consecutive list. */
-	if (fllast >= flfirst) {
-		for (i = flfirst; i <= fllast; i++) {
-			error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
-			if (error)
-				return error;
-			if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-				return error;
-		}
-
-		return 0;
-	}
-
-	/* first to the end */
-	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
-		error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
-		if (error)
-			return error;
-		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-			return error;
-	}
-
-	/* the start to last. */
-	for (i = 0; i <= fllast; i++) {
-		error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
-		if (error)
-			return error;
-		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-			return error;
-	}
-
-	return 0;
-}
-
 /* Superblock */
 
 /* Cross-reference with the other btrees. */
@@ -680,6 +618,7 @@ struct xfs_scrub_agfl_info {
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
 	xfs_agblock_t			*entries;
+	struct xfs_scrub_context	*sc;
 };
 
 /* Cross-reference with the other btrees. */
@@ -701,12 +640,12 @@ xfs_scrub_agfl_block_xref(
 /* Scrub an AGFL block. */
 STATIC int
 xfs_scrub_agfl_block(
-	struct xfs_scrub_context	*sc,
+	struct xfs_mount		*mp,
 	xfs_agblock_t			agbno,
 	void				*priv)
 {
-	struct xfs_mount		*mp = sc->mp;
 	struct xfs_scrub_agfl_info	*sai = priv;
+	struct xfs_scrub_context	*sc = sai->sc;
 	xfs_agnumber_t			agno = sc->sa.agno;
 
 	if (xfs_verify_agbno(mp, agno, agbno) &&
@@ -717,6 +656,9 @@ xfs_scrub_agfl_block(
 
 	xfs_scrub_agfl_block_xref(sc, agbno, priv);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
+
 	return 0;
 }
 
@@ -796,6 +738,7 @@ xfs_scrub_agfl(
 		goto out;
 	}
 	memset(&sai, 0, sizeof(sai));
+	sai.sc = sc;
 	sai.sz_entries = agflcount;
 	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount, KM_NOFS);
 	if (!sai.entries) {
@@ -805,7 +748,12 @@ xfs_scrub_agfl(
 
 	/* Check the blocks in the AGFL. */
 	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
-	error = xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sai);
+	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xfs_scrub_agfl_block, &sai);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
+		error = 0;
+		goto out_free;
+	}
 	if (error)
 		goto out_free;
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index deaf604..140e90c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -141,10 +141,6 @@ int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 void xfs_scrub_ag_btcur_free(struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 			    struct xfs_scrub_ag *sa);
-int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
-			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
-				  void *),
-			void *priv);
 int xfs_scrub_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
 				    struct xfs_btree_cur *cur,
 				    struct xfs_owner_info *oinfo,

