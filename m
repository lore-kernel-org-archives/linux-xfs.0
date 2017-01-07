Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51633 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032643AbdAGAhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:37:15 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070bEre022863
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:37:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070bEDa021908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:37:14 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v070bCkE022086
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:37:13 GMT
Subject: [PATCH 13/47] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:37:11 -0800
Message-ID: <148374943109.30431.2724190065869065651.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Add a forgotten check to the AGI verifier, then wire up the scrub
infrastructure to check the AGI contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h   |    3 +
 fs/xfs/repair/agheader.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c   |    7 ++-
 fs/xfs/repair/common.h   |    1 
 fs/xfs/xfs_trace.h       |    3 +
 5 files changed, 106 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b7f2850..f883dcd 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -578,7 +578,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_SB	1	/* superblock */
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
-#define XFS_SCRUB_TYPE_MAX	3
+#define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
+#define XFS_SCRUB_TYPE_MAX	4
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index f937834..3623f4c 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -416,3 +416,99 @@ xfs_scrub_agfl(
 }
 #undef XFS_SCRUB_AGFL_OP_ERROR_GOTO
 #undef XFS_SCRUB_AGFL_CHECK
+
+/* AGI */
+
+#define XFS_SCRUB_AGI_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, sc->sa.agi_bp, "AGI", fs_ok)
+#define XFS_SCRUB_AGI_OP_ERROR_GOTO(error, label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, sc->sm->sm_agno, \
+			XFS_AGI_BLOCK(sc->tp->t_mountp), "AGI", error, label)
+/* Scrub the AGI. */
+int
+xfs_scrub_agi(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
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
+	XFS_SCRUB_AGI_OP_ERROR_GOTO(&error, out);
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agi->agi_length);
+	XFS_SCRUB_AGI_CHECK(eoag == xfs_scrub_ag_blocks(mp, agno));
+
+	/* Check btree roots and levels */
+	agbno = be32_to_cpu(agi->agi_root);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	XFS_SCRUB_AGI_CHECK(agbno > XFS_AGI_BLOCK(mp));
+	XFS_SCRUB_AGI_CHECK(agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_AGI_CHECK(agbno < eoag);
+	XFS_SCRUB_AGI_CHECK(daddr < eofs);
+
+	level = be32_to_cpu(agi->agi_level);
+	XFS_SCRUB_AGI_CHECK(level > 0);
+	XFS_SCRUB_AGI_CHECK(level <= XFS_BTREE_MAXLEVELS);
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agi->agi_free_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		XFS_SCRUB_AGI_CHECK(agbno > XFS_AGI_BLOCK(mp));
+		XFS_SCRUB_AGI_CHECK(agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_AGI_CHECK(agbno < eoag);
+		XFS_SCRUB_AGI_CHECK(daddr < eofs);
+
+		level = be32_to_cpu(agi->agi_free_level);
+		XFS_SCRUB_AGI_CHECK(level > 0);
+		XFS_SCRUB_AGI_CHECK(level <= XFS_BTREE_MAXLEVELS);
+	}
+
+	/* Check inode counters */
+	first_agino = XFS_OFFBNO_TO_AGINO(mp, XFS_AGI_BLOCK(mp) + 1, 0);
+	last_agino = XFS_OFFBNO_TO_AGINO(mp, eoag + 1, 0) - 1;
+	agino = be32_to_cpu(agi->agi_count);
+	XFS_SCRUB_AGI_CHECK(agino <= last_agino - first_agino + 1);
+	XFS_SCRUB_AGI_CHECK(agino >= be32_to_cpu(agi->agi_freecount));
+
+	/* Check inode pointers */
+	agino = be32_to_cpu(agi->agi_newino);
+	if (agino != NULLAGINO) {
+		XFS_SCRUB_AGI_CHECK(agino >= first_agino);
+		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
+	}
+	agino = be32_to_cpu(agi->agi_dirino);
+	if (agino != NULLAGINO) {
+		XFS_SCRUB_AGI_CHECK(agino >= first_agino);
+		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
+	}
+
+	/* Check unlinked inode buckets */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		agino = be32_to_cpu(agi->agi_unlinked[i]);
+		if (agino == NULLAGINO)
+			continue;
+		XFS_SCRUB_AGI_CHECK(agino >= first_agino);
+		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
+	}
+
+out:
+	return error;
+}
+#undef XFS_SCRUB_AGI_CHECK
+#undef XFS_SCRUB_AGI_OP_ERROR_GOTO
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index eb303a3..eb5c03e 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -620,12 +620,14 @@ xfs_scrub_load_ag_headers(
 	struct xfs_mount		*mp = sc->tp->t_mountp;
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
 
@@ -659,6 +661,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag, xfs_scrub_superblock, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agf, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agfl, NULL, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 2f7075d..ec4c230 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -210,5 +210,6 @@ int xfs_scrub_setup_ag(struct xfs_scrub_context *sc, struct xfs_inode *ip,
 int xfs_scrub_superblock(struct xfs_scrub_context *sc);
 int xfs_scrub_agf(struct xfs_scrub_context *sc);
 int xfs_scrub_agfl(struct xfs_scrub_context *sc);
+int xfs_scrub_agi(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b8b0028..38118f5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3356,7 +3356,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_TEST,		"dummy" }, \
 	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
 	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
-	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }
+	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
+	{ XFS_SCRUB_TYPE_AGI,		"AGI" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

