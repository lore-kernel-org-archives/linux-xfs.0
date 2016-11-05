Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38563 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753021AbcKEAUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:20:39 -0400
Subject: [PATCH 14/41] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:20:34 -0700
Message-ID: <147830523446.2155.7904094039469467216.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Add a forgotten check to the AGI verifier, then wire up the scrub
infrastructure to check the AGI contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |    3 +
 fs/xfs/libxfs/xfs_ialloc.c |    5 ++
 fs/xfs/xfs_scrub.c         |   89 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h         |    3 +
 4 files changed, 98 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fd2649f..d93787b 100644
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c507c1b..c4f17d2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2515,6 +2515,11 @@ xfs_agi_verify(
 
 	if (be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
 		return false;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index f3ca32a..35bb141 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1612,6 +1612,94 @@ xfs_scrub_agfl(
 }
 #undef XFS_SCRUB_AGFL_CHECK
 
+#define XFS_SCRUB_AGI_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, sc->sa.agi_bp, "AGI", fs_ok)
+/* Scrub the AGI. */
+STATIC int
+xfs_scrub_agi(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_agi			*agi;
+	struct xfs_agf			*agf;
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
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	eoag = be32_to_cpu(agi->agi_length);
+
+	/* Check length */
+	XFS_SCRUB_AGI_CHECK(eoag == be32_to_cpu(agf->agf_length));
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
+	return error;
+}
+#undef XFS_SCRUB_AGI_CHECK
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1627,6 +1715,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag, xfs_scrub_superblock, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_agf, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_agfl, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_agi, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index dd907f6..8454a72 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3465,7 +3465,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_TEST,		"dummy" }, \
 	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
 	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
-	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }
+	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
+	{ XFS_SCRUB_TYPE_AGI,		"AGI" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

