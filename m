Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41804 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdJCUmC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:42:02 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93Kg1dl002485
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93Kg08Z003283
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:00 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v93Kg0Xl004467
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:00 GMT
Subject: [PATCH 11/25] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:41:59 -0700
Message-ID: <150706331918.19351.1010060377239825093.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
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
index 7fe6630..3d269c2 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -535,3 +535,91 @@ xfs_scrub_agfl(
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
+	if (eoag != xfs_scrub_ag_blocks(mp, agno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check btree roots and levels */
+	agbno = be32_to_cpu(agi->agi_root);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	if (agbno <= XFS_AGI_BLOCK(mp) || agbno >= mp->m_sb.sb_agblocks ||
+	    agbno >= eoag || daddr >= eofs)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	level = be32_to_cpu(agi->agi_level);
+	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agi->agi_free_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		if (agbno <= XFS_AGI_BLOCK(mp) ||
+		    agbno >= mp->m_sb.sb_agblocks ||
+		    agbno >= eoag ||
+		    daddr >= eofs)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+		level = be32_to_cpu(agi->agi_free_level);
+		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+	}
+
+	/* Check inode counters */
+	first_agino = XFS_OFFBNO_TO_AGINO(mp, XFS_AGI_BLOCK(mp) + 1, 0);
+	last_agino = XFS_OFFBNO_TO_AGINO(mp, eoag + 1, 0) - 1;
+	agino = be32_to_cpu(agi->agi_count);
+	if (agino > last_agino - first_agino + 1 ||
+	    agino < be32_to_cpu(agi->agi_freecount))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check inode pointers */
+	agino = be32_to_cpu(agi->agi_newino);
+	if (agino != NULLAGINO && (agino < first_agino || agino > last_agino))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+	agino = be32_to_cpu(agi->agi_dirino);
+	if (agino != NULLAGINO && (agino < first_agino || agino > last_agino))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check unlinked inode buckets */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		agino = be32_to_cpu(agi->agi_unlinked[i]);
+		if (agino == NULLAGINO)
+			continue;
+		if (agino < first_agino || agino > last_agino)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+	}
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ee8e7be..4f42401 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -507,12 +507,14 @@ xfs_scrub_load_ag_headers(
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
index 6f3c4f0..a62f53b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -165,6 +165,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
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

