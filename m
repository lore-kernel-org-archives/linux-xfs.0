Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25899 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdIUAS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:18:58 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0IvB8005708
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0Ivlr007345
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:57 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8L0IvRO019391
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:57 GMT
Subject: [PATCH 13/27] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:18:57 -0700
Message-ID: <150595313719.18473.6302219895702186082.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
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
 fs/xfs/scrub/agheader.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c   |    6 ++-
 fs/xfs/scrub/scrub.c    |    4 ++
 fs/xfs/scrub/scrub.h    |    1 +
 5 files changed, 99 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a22d90f..2ac0049 100644
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
index c2cc2af..cfbbe9e 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -544,3 +544,91 @@ xfs_scrub_agfl(
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
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			eoag;
+	xfs_agino_t			agino;
+	xfs_agino_t			first_agino;
+	xfs_agino_t			last_agino;
+	int				i;
+	int				level;
+	int				error = 0;
+
+	agno = sc->sm->sm_agno;
+	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGI);
+	if (!xfs_scrub_op_ok(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
+		goto out;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agi->agi_length);
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+			eoag == xfs_scrub_ag_blocks(mp, agno));
+
+	/* Check btree roots and levels */
+	agbno = be32_to_cpu(agi->agi_root);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+			agbno > XFS_AGI_BLOCK(mp) &&
+			agbno < mp->m_sb.sb_agblocks &&
+			agbno < eoag && daddr < eofs);
+
+	level = be32_to_cpu(agi->agi_level);
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+			level > 0 && level <= XFS_BTREE_MAXLEVELS);
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agi->agi_free_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+				agbno > XFS_AGI_BLOCK(mp) &&
+				agbno < mp->m_sb.sb_agblocks &&
+				agbno < eoag && daddr < eofs);
+
+		level = be32_to_cpu(agi->agi_free_level);
+		xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+				level > 0 && level <= XFS_BTREE_MAXLEVELS);
+	}
+
+	/* Check inode counters */
+	first_agino = XFS_OFFBNO_TO_AGINO(mp, XFS_AGI_BLOCK(mp) + 1, 0);
+	last_agino = XFS_OFFBNO_TO_AGINO(mp, eoag + 1, 0) - 1;
+	agino = be32_to_cpu(agi->agi_count);
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+			agino <= last_agino - first_agino + 1 &&
+			agino >= be32_to_cpu(agi->agi_freecount));
+
+	/* Check inode pointers */
+	agino = be32_to_cpu(agi->agi_newino);
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp, agino == NULLAGINO ||
+			(agino >= first_agino && agino <= last_agino));
+	agino = be32_to_cpu(agi->agi_dirino);
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp, agino == NULLAGINO ||
+			(agino >= first_agino && agino <= last_agino));
+
+	/* Check unlinked inode buckets */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		agino = be32_to_cpu(agi->agi_unlinked[i]);
+		if (agino == NULLAGINO)
+			continue;
+		xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+				(agino >= first_agino && agino <= last_agino));
+	}
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e0e611d..b62f084 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -499,12 +499,14 @@ xfs_scrub_load_ag_headers(
 	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
-	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL);
+	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL ||
+	       type == XFS_SCRUB_TYPE_AGI);
 	memset(&sc->sa, 0, sizeof(sc->sa));
 	sc->sa.agno = agno;
 
 	error = xfs_scrub_load_ag_header(sc, XFS_AGI_DADDR(mp),
-			&sc->sa.agi_bp, &xfs_agi_buf_ops, false);
+			&sc->sa.agi_bp, &xfs_agi_buf_ops,
+			type == XFS_SCRUB_TYPE_AGI);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1afce7b..5fc34a6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -174,6 +174,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_ag_header,
 		.scrub	= xfs_scrub_agfl,
 	},
+	{ /* agi */
+		.setup	= xfs_scrub_setup_ag_header,
+		.scrub	= xfs_scrub_agi,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index cb31a01..00020a3 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -65,5 +65,6 @@ int xfs_scrub_tester(struct xfs_scrub_context *sc);
 int xfs_scrub_superblock(struct xfs_scrub_context *sc);
 int xfs_scrub_agf(struct xfs_scrub_context *sc);
 int xfs_scrub_agfl(struct xfs_scrub_context *sc);
+int xfs_scrub_agi(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

