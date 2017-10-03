Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41731 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJCUlz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:41:55 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KfsFM002385
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v93KfsW3011554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:54 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v93KfsN5004197
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:54 GMT
Subject: [PATCH 10/25] xfs: scrub AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:41:52 -0700
Message-ID: <150706331250.19351.3004733994525860282.stgit@magnolia>
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

Check the block references in the AGF and AGFL headers to make sure
they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h  |    4 +
 fs/xfs/scrub/agheader.c |  220 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c   |   60 +++++++++++++
 fs/xfs/scrub/common.h   |    6 +
 fs/xfs/scrub/scrub.c    |    8 ++
 fs/xfs/scrub/scrub.h    |    2 
 6 files changed, 299 insertions(+), 1 deletion(-)


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
index 487c4f4..7fe6630 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -49,6 +49,72 @@ xfs_scrub_setup_ag_header(
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
 
 /* Scrub the filesystem superblock. */
@@ -315,3 +381,157 @@ xfs_scrub_superblock(
 
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
+	if (!xfs_scrub_op_ok(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
+		goto out;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agf->agf_length);
+	if (eoag != xfs_scrub_ag_blocks(mp, agno))
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	/* Check the AGF btree roots and levels */
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	if (agbno <= XFS_AGI_BLOCK(mp) || agbno >= mp->m_sb.sb_agblocks ||
+	    agbno >= eoag || daddr >= eofs)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	if (agbno <= XFS_AGI_BLOCK(mp) || agbno >= mp->m_sb.sb_agblocks ||
+	    agbno >= eoag || daddr >= eofs)
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
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		if (agbno <= XFS_AGI_BLOCK(mp) ||
+		    agbno >= mp->m_sb.sb_agblocks ||
+		    agbno >= eoag ||
+		    daddr >= eofs)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+
+		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_refcount_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		if (agbno <= XFS_AGI_BLOCK(mp) ||
+		    agbno >= mp->m_sb.sb_agblocks ||
+		    agbno >= eoag ||
+		    daddr >= eofs)
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
+	int				error = 0;
+
+	if (agbno <= XFS_AGI_BLOCK(mp) ||
+	    agbno >= mp->m_sb.sb_agblocks ||
+	    agbno >= sagfl->eoag ||
+	    XFS_AGB_TO_DADDR(mp, agno, agbno) >= sagfl->eofs)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
+
+	return error;
+}
+
+/* Scrub the AGFL. */
+int
+xfs_scrub_agfl(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_agfl		sagfl;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agf			*agf;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = sc->sm->sm_agno;
+	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGFL);
+	if (!xfs_scrub_op_ok(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
+		goto out;
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
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b056c9d..ee8e7be 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -471,6 +471,66 @@ xfs_scrub_ag_init(
 	return xfs_scrub_ag_btcur_init(sc, sa);
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
 /* Per-scrubber setup functions */
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 390f772..4d8bb72 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -88,5 +88,11 @@ int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 void xfs_scrub_ag_btcur_free(struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 			    struct xfs_scrub_ag *sa);
+int xfs_scrub_load_ag_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+			      unsigned int type);
+int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
+			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
+				  void *),
+			void *priv);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7f6f997..6f3c4f0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -157,6 +157,14 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
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

