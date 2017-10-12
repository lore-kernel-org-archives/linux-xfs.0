Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753070AbdJLBmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:42:32 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1gUeJ032690
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1gU0i030486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:30 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C1gUw4020741
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:30 GMT
Subject: [PATCH 16/30] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:42:28 -0700
Message-ID: <150777254886.1724.15075712654473670561.stgit@magnolia>
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

Add a forgotten check to the AGI verifier, then wire up the scrub
infrastructure to check the AGI contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 +-
 fs/xfs/scrub/agheader.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c   |    5 ++-
 fs/xfs/scrub/scrub.c    |    4 ++
 fs/xfs/scrub/scrub.h    |    1 +
 5 files changed, 92 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index aeb2a66..1e326dd 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -487,9 +487,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_SB	1	/* superblock */
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
+#define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	4
+#define XFS_SCRUB_TYPE_NR	5
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 594ef34..3e181c3 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -512,3 +513,84 @@ xfs_scrub_agfl(
 out:
 	return error;
 }
+
+/* AGI */
+
+/* Scrub the AGI. */
+int
+xfs_scrub_agi(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agi			*agi;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			eoag;
+	xfs_agino_t			agino;
+	xfs_agino_t			first_agino;
+	xfs_agino_t			last_agino;
+	xfs_agino_t			icount;
+	int				i;
+	int				level;
+	int				error = 0;
+
+	agno = sc->sa.agno = sc->sm->sm_agno;
+	error = xfs_scrub_ag_read_headers(sc, agno, &sc->sa.agi_bp,
+			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	if (!xfs_scrub_process_error(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
+		goto out;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agi->agi_length);
+	if (eoag != xfs_ag_block_count(mp, agno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check btree roots and levels */
+	agbno = be32_to_cpu(agi->agi_root);
+	if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	level = be32_to_cpu(agi->agi_level);
+	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agi->agi_free_root);
+		if (!xfs_verify_agbno_ptr(mp, agno, agbno))
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+		level = be32_to_cpu(agi->agi_free_level);
+		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+	}
+
+	/* Check inode counters */
+	xfs_ialloc_aginode_range(mp, agno, &first_agino, &last_agino);
+	icount = be32_to_cpu(agi->agi_count);
+	if (icount > last_agino - first_agino + 1 ||
+	    icount < be32_to_cpu(agi->agi_freecount))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check inode pointers */
+	agino = be32_to_cpu(agi->agi_newino);
+	if (agino != NULLAGINO && !xfs_verify_agino_ptr(mp, agno, agino))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	agino = be32_to_cpu(agi->agi_dirino);
+	if (agino != NULLAGINO && !xfs_verify_agino_ptr(mp, agno, agino))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check unlinked inode buckets */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		agino = be32_to_cpu(agi->agi_unlinked[i]);
+		if (agino == NULLAGINO)
+			continue;
+		if (!xfs_verify_agino_ptr(mp, agno, agino))
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+	}
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index f0bb9dd..b0ba14c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -254,7 +254,8 @@ want_ag_read_header_failure(
 {
 	/* Return all AG header read failures when scanning btrees. */
 	if (sc->sm->sm_type != XFS_SCRUB_TYPE_AGF &&
-	    sc->sm->sm_type != XFS_SCRUB_TYPE_AGFL)
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_AGFL &&
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_AGI)
 		return true;
 	/*
 	 * If we're scanning a given type of AG header, we only want to
@@ -285,7 +286,7 @@ xfs_scrub_ag_read_headers(
 	int				error;
 
 	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
-	if (error)
+	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		goto out;
 
 	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8d0d5c8..07c45d6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -160,6 +160,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_ag_header,
 		.scrub	= xfs_scrub_agfl,
 	},
+	{ /* agi */
+		.setup	= xfs_scrub_setup_ag_header,
+		.scrub	= xfs_scrub_agi,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 50f8641..09952c2 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -70,5 +70,6 @@ int xfs_scrub_tester(struct xfs_scrub_context *sc);
 int xfs_scrub_superblock(struct xfs_scrub_context *sc);
 int xfs_scrub_agf(struct xfs_scrub_context *sc);
 int xfs_scrub_agfl(struct xfs_scrub_context *sc);
+int xfs_scrub_agi(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

