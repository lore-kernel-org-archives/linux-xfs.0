Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47241 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:31:27 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MVQU1027615
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v52MVQYs028517
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:26 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52MVPOm027175
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:25 GMT
Subject: [PATCH 06/19] xfs: scrub AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 15:31:24 -0700
Message-ID: <149644268473.19430.1651565439833874377.stgit@birch.djwong.org>
In-Reply-To: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
References: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
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
 fs/xfs/scrub/agheader.c |  227 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c   |   68 ++++++++++++++
 fs/xfs/scrub/common.h   |    8 ++
 fs/xfs/xfs_trace.h      |    4 +
 5 files changed, 309 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 0d98a82..2fb0de2 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -494,7 +494,9 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
 #define XFS_SCRUB_TYPE_SB	1	/* superblock */
-#define XFS_SCRUB_TYPE_MAX	1
+#define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
+#define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
+#define XFS_SCRUB_TYPE_MAX	3
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 820e34a..4fed3c8 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -46,6 +46,72 @@ xfs_scrub_setup_ag_header(
 	return xfs_scrub_setup_fs(sc, ip);
 }
 
+/* Find the size of the AG, in blocks. */
+static inline xfs_agblock_t
+xfs_scrub_ag_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	if (agno < mp->m_sb.sb_agcount - 1)
+		return mp->m_sb.sb_agblocks;
+	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
+}
+
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
 /* Superblock */
 
 #define XFS_SCRUB_SB_CHECK(fs_ok) \
@@ -194,3 +260,164 @@ xfs_scrub_superblock(
 }
 #undef XFS_SCRUB_SB_OP_ERROR_GOTO
 #undef XFS_SCRUB_SB_CHECK
+
+/* AGF */
+
+#define XFS_SCRUB_AGF_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, sc->sa.agf_bp, "AGF", fs_ok)
+#define XFS_SCRUB_AGF_OP_ERROR_GOTO(error, label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, sc->sm->sm_agno, \
+			XFS_AGF_BLOCK(sc->mp), "AGF", error, label)
+/* Scrub the AGF. */
+int
+xfs_scrub_agf(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
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
+	agno = sc->sm->sm_agno;
+	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGF);
+	XFS_SCRUB_AGF_OP_ERROR_GOTO(&error, out);
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agf->agf_length);
+	XFS_SCRUB_AGF_CHECK(eoag == xfs_scrub_ag_blocks(mp, agno));
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
+out:
+	return error;
+}
+#undef XFS_SCRUB_AGF_OP_ERROR_GOTO
+#undef XFS_SCRUB_AGF_CHECK
+
+/* AGFL */
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
+	struct xfs_mount		*mp = sc->mp;
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
+#define XFS_SCRUB_AGFL_OP_ERROR_GOTO(error, label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, sc->sm->sm_agno, \
+			XFS_AGFL_BLOCK(sc->mp), "AGFL", error, label)
+/* Scrub the AGFL. */
+int
+xfs_scrub_agfl(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_agfl		sagfl;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agf			*agf;
+	int				error;
+
+	error = xfs_scrub_load_ag_headers(sc, sc->sm->sm_agno,
+			XFS_SCRUB_TYPE_AGFL);
+	XFS_SCRUB_AGFL_OP_ERROR_GOTO(&error, out);
+	if (!sc->sa.agf_bp)
+		return -EFSCORRUPTED;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	sagfl.eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	sagfl.eoag = be32_to_cpu(agf->agf_length);
+
+	/* Check the blocks in the AGFL. */
+	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
+out:
+	return error;
+}
+#undef XFS_SCRUB_AGFL_OP_ERROR_GOTO
+#undef XFS_SCRUB_AGFL_CHECK
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5d3e98c..3bfaa65 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -576,6 +576,66 @@ xfs_scrub_setup(
 	return sc->fns->setup(sc, ip);
 }
 
+/*
+ * Load and verify an AG header for further AG header examination.
+ * If this header is not the target of the examination, don't return
+ * the buffer if a runtime or verifier error occurs.
+ */
+STATIC int
+xfs_scrub_load_ag_header(
+	struct xfs_scrub_context	*sc,
+	xfs_daddr_t			daddr,
+	struct xfs_buf			**bpp,
+	const struct xfs_buf_ops	*ops,
+	bool				is_target)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error;
+
+	*bpp = NULL;
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, sc->sa.agno, daddr),
+			XFS_FSS_TO_BB(mp, 1), 0, bpp, ops);
+	return is_target ? error : 0;
+}
+
+/*
+ * Load as many of the AG headers and btree cursors as we can for an
+ * examination and cross-reference of an AG header.
+ */
+int
+xfs_scrub_load_ag_headers(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	unsigned int			type)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error;
+
+	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL);
+	memset(&sc->sa, 0, sizeof(sc->sa));
+	sc->sa.agno = agno;
+
+	error = xfs_scrub_load_ag_header(sc, XFS_AGI_DADDR(mp),
+			&sc->sa.agi_bp, &xfs_agi_buf_ops, false);
+	if (error)
+		return error;
+
+	error = xfs_scrub_load_ag_header(sc, XFS_AGF_DADDR(mp),
+			&sc->sa.agf_bp, &xfs_agf_buf_ops,
+			type == XFS_SCRUB_TYPE_AGF);
+	if (error)
+		return error;
+
+	error = xfs_scrub_load_ag_header(sc, XFS_AGFL_DADDR(mp),
+			&sc->sa.agfl_bp, &xfs_agfl_buf_ops,
+			type == XFS_SCRUB_TYPE_AGFL);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 /* Scrubbing dispatch. */
 
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
@@ -587,6 +647,14 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
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
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 83f266e..5514afd 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -185,6 +185,12 @@ int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 			      struct xfs_buf **agfl);
 int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 			    struct xfs_scrub_ag *sa);
+int xfs_scrub_load_ag_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+			      unsigned int type);
+int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
+			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
+				  void *),
+			void *priv);
 
 /* Setup functions */
 
@@ -197,6 +203,8 @@ SETUP_FN(xfs_scrub_setup_ag_header);
 
 #define SCRUB_FN(name) int name(struct xfs_scrub_context *sc)
 SCRUB_FN(xfs_scrub_superblock);
+SCRUB_FN(xfs_scrub_agf);
+SCRUB_FN(xfs_scrub_agfl);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3c967fb..f3f7cb8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3331,7 +3331,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 /* scrub */
 #define XFS_SCRUB_TYPE_DESC \
 	{ XFS_SCRUB_TYPE_TEST,		"dummy" }, \
-	{ XFS_SCRUB_TYPE_SB,		"superblock" }
+	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
+	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
+	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

