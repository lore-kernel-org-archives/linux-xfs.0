Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30498 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753066AbdJLBmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:42:25 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1gOC1028313
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1gOvo026923
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:24 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1gNpi001321
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:24 GMT
Subject: [PATCH 15/30] xfs: scrub AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:42:22 -0700
Message-ID: <150777254274.1724.15950286721367258242.stgit@magnolia>
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

Check the block references in the AGF and AGFL headers to make sure
they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h  |    4 +
 fs/xfs/scrub/agheader.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c   |   28 ++++++-
 fs/xfs/scrub/common.h   |    4 +
 fs/xfs/scrub/scrub.c    |    8 ++
 fs/xfs/scrub/scrub.h    |    2 +
 6 files changed, 223 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8543cbb..aeb2a66 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -485,9 +485,11 @@ struct xfs_scrub_metadata {
 /* Scrub subcommands. */
 #define XFS_SCRUB_TYPE_PROBE	0	/* presence test ioctl */
 #define XFS_SCRUB_TYPE_SB	1	/* superblock */
+#define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
+#define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	2
+#define XFS_SCRUB_TYPE_NR	4
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index aa1025f..594ef34 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -52,6 +53,65 @@ xfs_scrub_setup_ag_header(
 	return xfs_scrub_setup_fs(sc, ip);
 }
 
+/* Walk all the blocks in the AGFL. */
+int
+xfs_scrub_walk_agfl(
+	struct xfs_scrub_context	*sc,
+	int				(*fn)(struct xfs_scrub_context *,
+					      xfs_agblock_t bno, void *),
+	void				*priv)
+{
+	struct xfs_agf			*agf;
+	__be32				*agfl_bno;
+	struct xfs_mount		*mp = sc->mp;
+	unsigned int			flfirst;
+	unsigned int			fllast;
+	int				i;
+	int				error;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, sc->sa.agfl_bp);
+	flfirst = be32_to_cpu(agf->agf_flfirst);
+	fllast = be32_to_cpu(agf->agf_fllast);
+
+	/* Nothing to walk in an empty AGFL. */
+	if (agf->agf_flcount == cpu_to_be32(0))
+		return 0;
+
+	/* first to last is a consecutive list. */
+	if (fllast >= flfirst) {
+		for (i = flfirst; i <= fllast; i++) {
+			error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
+			if (error)
+				return error;
+			if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+				return error;
+		}
+
+		return 0;
+	}
+
+	/* first to the end */
+	for (i = flfirst; i < XFS_AGFL_SIZE(mp); i++) {
+		error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
+		if (error)
+			return error;
+		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return error;
+	}
+
+	/* the start to last. */
+	for (i = 0; i <= fllast; i++) {
+		error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
+		if (error)
+			return error;
+		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Superblock */
 
 /*
@@ -328,3 +388,127 @@ xfs_scrub_superblock(
 
 	return error;
 }
+
+/* AGF */
+
+/* Scrub the AGF. */
+int
+xfs_scrub_agf(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agf			*agf;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			eoag;
+	xfs_agblock_t			agfl_first;
+	xfs_agblock_t			agfl_last;
+	xfs_agblock_t			agfl_count;
+	xfs_agblock_t			fl_count;
+	int				level;
+	int				error = 0;
+
+	agno = sc->sa.agno = sc->sm->sm_agno;
+	error = xfs_scrub_ag_read_headers(sc, agno, &sc->sa.agi_bp,
+			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	if (!xfs_scrub_process_error(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
+		goto out;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agf->agf_length);
+	if (eoag != xfs_ag_block_count(mp, agno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	/* Check the AGF btree roots and levels */
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+		if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_refcount_root);
+		if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+		level = be32_to_cpu(agf->agf_refcount_level);
+		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+	}
+
+	/* Check the AGFL counters */
+	agfl_first = be32_to_cpu(agf->agf_flfirst);
+	agfl_last = be32_to_cpu(agf->agf_fllast);
+	agfl_count = be32_to_cpu(agf->agf_flcount);
+	if (agfl_last > agfl_first)
+		fl_count = agfl_last - agfl_first + 1;
+	else
+		fl_count = XFS_AGFL_SIZE(mp) - agfl_first + agfl_last + 1;
+	if (agfl_count != 0 && fl_count != agfl_count)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+out:
+	return error;
+}
+
+/* AGFL */
+
+/* Scrub an AGFL block. */
+STATIC int
+xfs_scrub_agfl_block(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	void				*priv)
+{
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agnumber_t			agno = sc->sa.agno;
+
+	if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
+
+	return 0;
+}
+
+/* Scrub the AGFL. */
+int
+xfs_scrub_agfl(
+	struct xfs_scrub_context	*sc)
+{
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = sc->sa.agno = sc->sm->sm_agno;
+	error = xfs_scrub_ag_read_headers(sc, agno, &sc->sa.agi_bp,
+			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	if (!xfs_scrub_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
+		goto out;
+	if (!sc->sa.agf_bp)
+		return -EFSCORRUPTED;
+
+	/* Check the blocks in the AGFL. */
+	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, NULL);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index cd6fada..f0bb9dd 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -246,6 +246,26 @@ xfs_scrub_set_incomplete(
  * cleaning everything up once we're through.
  */
 
+/* Decide if we want to return an AG header read failure. */
+static inline bool
+want_ag_read_header_failure(
+	struct xfs_scrub_context	*sc,
+	unsigned int			type)
+{
+	/* Return all AG header read failures when scanning btrees. */
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_AGF &&
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_AGFL)
+		return true;
+	/*
+	 * If we're scanning a given type of AG header, we only want to
+	 * see read failures from that specific header.  We'd like the
+	 * other headers to cross-check them, but this isn't required.
+	 */
+	if (sc->sm->sm_type == type)
+		return true;
+	return false;
+}
+
 /*
  * Grab all the headers for an AG.
  *
@@ -269,15 +289,11 @@ xfs_scrub_ag_read_headers(
 		goto out;
 
 	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
-	if (error)
-		goto out;
-	if (!*agf) {
-		error = -ENOMEM;
+	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
 		goto out;
-	}
 
 	error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
-	if (error)
+	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGFL))
 		goto out;
 
 out:
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b0a5adf..251a195 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -88,5 +88,9 @@ int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 void xfs_scrub_ag_btcur_free(struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 			    struct xfs_scrub_ag *sa);
+int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
+			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
+				  void *),
+			void *priv);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 702812b..8d0d5c8 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -152,6 +152,14 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_ag_header,
 		.scrub	= xfs_scrub_superblock,
 	},
+	{ /* agf */
+		.setup	= xfs_scrub_setup_ag_header,
+		.scrub	= xfs_scrub_agf,
+	},
+	{ /* agfl */
+		.setup	= xfs_scrub_setup_ag_header,
+		.scrub	= xfs_scrub_agfl,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 13e3f9b..50f8641 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -68,5 +68,7 @@ struct xfs_scrub_context {
 /* Metadata scrubbers */
 int xfs_scrub_tester(struct xfs_scrub_context *sc);
 int xfs_scrub_superblock(struct xfs_scrub_context *sc);
+int xfs_scrub_agf(struct xfs_scrub_context *sc);
+int xfs_scrub_agfl(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

