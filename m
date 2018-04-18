Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRClB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2ag4J042465
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:00 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2hdrxp0jyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2ex6L015509
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:00 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2ex9P030782
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:59 GMT
Subject: [PATCH 1/9] xfs: hoist xfs_scrub_agfl_walk to libxfs as
 xfs_agfl_walk
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:52 -0700
Message-ID: <152401925221.11792.6582685122071970769.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
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
index 4bcc095..6dd0984 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3116,3 +3116,40 @@ xfs_alloc_has_record(
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
+
+/*
+ * Walk all the blocks in the AGFL.  The @walk_fn can return any negative
+ * error code or XFS_BTREE_QUERY_RANGE_ABORT.
+ */
+int
+xfs_agfl_walk(
+	struct xfs_mount	*mp,
+	struct xfs_agf		*agf,
+	struct xfs_buf		*agflbp,
+	xfs_agfl_walk_fn	walk_fn,
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
+		error = walk_fn(mp, be32_to_cpu(agfl_bno[i]), priv);
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
index cbf789e..490f210 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -248,4 +248,9 @@ bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exist);
 
+typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
+		void *priv);
+int xfs_agfl_walk(struct xfs_mount *mp, struct xfs_agf *agf,
+		struct xfs_buf *agflbp, xfs_agfl_walk_fn walk_fn, void *priv);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6c6e4d8..c5b5429 100644
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
@@ -681,6 +619,7 @@ struct xfs_scrub_agfl_info {
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
 	xfs_agblock_t			*entries;
+	struct xfs_scrub_context	*sc;
 };
 
 /* Cross-reference with the other btrees. */
@@ -702,12 +641,12 @@ xfs_scrub_agfl_block_xref(
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
@@ -718,6 +657,9 @@ xfs_scrub_agfl_block(
 
 	xfs_scrub_agfl_block_xref(sc, agbno, priv);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
+
 	return 0;
 }
 
@@ -797,6 +739,7 @@ xfs_scrub_agfl(
 		goto out;
 	}
 	memset(&sai, 0, sizeof(sai));
+	sai.sc = sc;
 	sai.sz_entries = agflcount;
 	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
 			KM_MAYFAIL);
@@ -807,7 +750,12 @@ xfs_scrub_agfl(
 
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
index 191c369..5d3e9c5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -129,10 +129,6 @@ int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
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

