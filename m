Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17773 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753021AbcKEAUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:20:34 -0400
Subject: [PATCH 13/41] xfs: scrub AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:20:28 -0700
Message-ID: <147830522820.2155.2667939413198025333.stgit@birch.djwong.org>
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

Check the block references in the AGF and AGFL headers to make sure
they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +
 fs/xfs/xfs_scrub.c     |  218 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    4 +
 3 files changed, 224 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e176147..fd2649f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -576,7 +576,9 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
 #define XFS_SCRUB_TYPE_SB	1	/* superblock */
-#define XFS_SCRUB_TYPE_MAX	1
+#define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
+#define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
+#define XFS_SCRUB_TYPE_MAX	3
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 9237103..f3ca32a 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1318,6 +1318,27 @@ xfs_scrub_setup_ag(
 	return xfs_scrub_setup(sc, ip, sm, retry_deadlocked);
 }
 
+/* Set us up with AG headers and btree cursors. */
+STATIC int
+xfs_scrub_setup_ag_header(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	int				error;
+
+	error = xfs_scrub_setup_ag(sc, ip, sm, retry_deadlocked);
+	if (error)
+		goto out;
+
+	error = xfs_scrub_ag_init(sc, sm->sm_agno, &sc->sa);
+	if (error)
+		xfs_trans_cancel(sc->tp);
+out:
+	return error;
+}
+
 /* Metadata scrubbers */
 
 #define XFS_SCRUB_SB_CHECK(fs_ok) \
@@ -1396,6 +1417,201 @@ xfs_scrub_superblock(
 #undef XFS_SCRUB_SB_OP_ERROR_GOTO
 #undef XFS_SCRUB_SB_CHECK
 
+#define XFS_SCRUB_AGF_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, sc->sa.agf_bp, "AGF", fs_ok)
+/* Scrub the AGF. */
+STATIC int
+xfs_scrub_agf(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_agf			*agf;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
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
+	agno = sc->sa.agno;
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agf->agf_length);
+	if (agno == mp->m_sb.sb_agcount - 1) {
+		XFS_SCRUB_AGF_CHECK(eoag <= mp->m_sb.sb_agblocks);
+	} else {
+		XFS_SCRUB_AGF_CHECK(eoag == mp->m_sb.sb_agblocks);
+	}
+	daddr = XFS_AGB_TO_DADDR(mp, agno, eoag);
+	XFS_SCRUB_AGF_CHECK(daddr <= eofs);
+
+	/* Check the AGF btree roots and levels */
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	XFS_SCRUB_AGF_CHECK(agbno > XFS_AGI_BLOCK(mp));
+	XFS_SCRUB_AGF_CHECK(agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_AGF_CHECK(agbno < eoag);
+	XFS_SCRUB_AGF_CHECK(daddr < eofs);
+
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	XFS_SCRUB_AGF_CHECK(agbno > XFS_AGI_BLOCK(mp));
+	XFS_SCRUB_AGF_CHECK(agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_AGF_CHECK(agbno < eoag);
+	XFS_SCRUB_AGF_CHECK(daddr < eofs);
+
+	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	XFS_SCRUB_AGF_CHECK(level > 0);
+	XFS_SCRUB_AGF_CHECK(level <= XFS_BTREE_MAXLEVELS);
+
+	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	XFS_SCRUB_AGF_CHECK(level > 0);
+	XFS_SCRUB_AGF_CHECK(level <= XFS_BTREE_MAXLEVELS);
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		XFS_SCRUB_AGF_CHECK(agbno > XFS_AGI_BLOCK(mp));
+		XFS_SCRUB_AGF_CHECK(agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_AGF_CHECK(agbno < eoag);
+		XFS_SCRUB_AGF_CHECK(daddr < eofs);
+
+		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		XFS_SCRUB_AGF_CHECK(level > 0);
+		XFS_SCRUB_AGF_CHECK(level <= XFS_BTREE_MAXLEVELS);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_refcount_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		XFS_SCRUB_AGF_CHECK(agbno > XFS_AGI_BLOCK(mp));
+		XFS_SCRUB_AGF_CHECK(agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_AGF_CHECK(agbno < eoag);
+		XFS_SCRUB_AGF_CHECK(daddr < eofs);
+
+		level = be32_to_cpu(agf->agf_refcount_level);
+		XFS_SCRUB_AGF_CHECK(level > 0);
+		XFS_SCRUB_AGF_CHECK(level <= XFS_BTREE_MAXLEVELS);
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
+	XFS_SCRUB_AGF_CHECK(agfl_count == 0 || fl_count == agfl_count);
+
+	return error;
+}
+#undef XFS_SCRUB_AGF_CHECK
+
+/* Walk all the blocks in the AGFL. */
+STATIC int
+xfs_scrub_walk_agfl(
+	struct xfs_scrub_context	*sc,
+	int				(*fn)(struct xfs_scrub_context *,
+					      xfs_agblock_t bno, void *),
+	void				*priv)
+{
+	struct xfs_agf			*agf;
+	__be32				*agfl_bno;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
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
+	/* Skip an empty AGFL. */
+	if (agf->agf_flcount == cpu_to_be32(0))
+		return 0;
+
+	/* first to last is a consecutive list. */
+	if (fllast >= flfirst) {
+		for (i = flfirst; i <= fllast; i++) {
+			error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
+			if (error)
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
+	}
+
+	/* the start to last. */
+	for (i = 0; i <= fllast; i++) {
+		error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+#define XFS_SCRUB_AGFL_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, sc->sa.agfl_bp, "AGFL", fs_ok)
+struct xfs_scrub_agfl {
+	xfs_agblock_t			eoag;
+	xfs_daddr_t			eofs;
+};
+
+/* Scrub an AGFL block. */
+STATIC int
+xfs_scrub_agfl_block(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	void				*priv)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	xfs_agnumber_t			agno = sc->sa.agno;
+	struct xfs_scrub_agfl		*sagfl = priv;
+
+	XFS_SCRUB_AGFL_CHECK(agbno > XFS_AGI_BLOCK(mp));
+	XFS_SCRUB_AGFL_CHECK(XFS_AGB_TO_DADDR(mp, agno, agbno) < sagfl->eofs);
+	XFS_SCRUB_AGFL_CHECK(agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_AGFL_CHECK(agbno < sagfl->eoag);
+
+	return 0;
+}
+
+/* Scrub the AGFL. */
+STATIC int
+xfs_scrub_agfl(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_agfl		sagfl;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_agf			*agf;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	sagfl.eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	sagfl.eoag = be32_to_cpu(agf->agf_length);
+
+	/* Check the blocks in the AGFL. */
+	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
+}
+#undef XFS_SCRUB_AGFL_CHECK
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1409,6 +1625,8 @@ struct xfs_scrub_meta_fns {
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup, xfs_scrub_dummy, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_superblock, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_agf, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_agfl, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 94bae99..dd907f6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3463,7 +3463,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 /* scrub */
 #define XFS_SCRUB_TYPE_DESC \
 	{ XFS_SCRUB_TYPE_TEST,		"dummy" }, \
-	{ XFS_SCRUB_TYPE_SB,		"superblock" }
+	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
+	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
+	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

