Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A33C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiLaCuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764E612AD7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD54B81E70
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEB9C433D2;
        Sat, 31 Dec 2022 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455016;
        bh=DeES1zD13XX4eI3Ih622FY7tLtSs9GQ5L2m6Nrn/5YY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y17uLWN1f8tO3NQ/k1EKQu1GOCTINEherFOwQ1eIoa3jTmlK2GZgqfX1e41FVIg5Y
         WZvvoVAKhmT5p1EMod5suoZKCvChfh6N6jIC/YoasfKRJhumv3mrVDtOHJaq6mJ4SQ
         2thJ/++8W2A2L0XFgZL4OCWvleyHzV7FiNU9M+CCaB+ge1OzINMuJprAv5N4alDSIu
         Cg19CMLrv0jfRwGvuSXtZyi01Q8nbwvf3M+HdL8cfBXfsIwbw/sU6oDb0N1dUV+Pem
         qbLdHa3nVdqIsgsdnh6qsQKqLnxLiAuLE6brA5Zvsdr3Zhc4+sMV9zGRFUVIfw642Z
         bcODSRJcqKivQ==
Subject: [PATCH 30/41] xfs_repair: create a new set of incore rmap information
 for rt groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879992.732820.17684698780642209424.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a parallel set of "xfs_ag_rmap" structures to cache information
about reverse mappings for the realtime groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    3 +
 repair/agbtree.c         |    5 +-
 repair/dinode.c          |    2 -
 repair/rmap.c            |  144 +++++++++++++++++++++++++++++++++++++---------
 repair/rmap.h            |    7 +-
 5 files changed, 127 insertions(+), 34 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index f59f9aa2060..2a07a717215 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -241,6 +241,7 @@
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_rtgroup_get			libxfs_rtgroup_get
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
@@ -249,6 +250,8 @@
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
+#define xfs_rtrmapbt_mem_create		libxfs_rtrmapbt_mem_create
+#define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 26e282d57c8..e340e9cfc04 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -637,7 +637,7 @@ init_rmapbt_cursor(
 
 	/* Compute how many blocks we'll need. */
 	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
-			rmap_record_count(sc->mp, agno));
+			rmap_record_count(sc->mp, false, agno));
 	if (error)
 		do_error(
 _("Unable to compute rmap btree geometry, error %d.\n"), error);
@@ -654,7 +654,8 @@ build_rmap_tree(
 {
 	int			error;
 
-	error = rmap_init_mem_cursor(sc->mp, NULL, agno, &btr->rmapbt_cursor);
+	error = rmap_init_mem_cursor(sc->mp, NULL, false, agno,
+			&btr->rmapbt_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct rmap cursor.\n"));
diff --git a/repair/dinode.c b/repair/dinode.c
index 93ef89272fd..6f44261907e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -657,7 +657,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 			}
 		}
 		if (collect_rmaps && !zap_metadata) /* && !check_dups */
-			rmap_add_rec(mp, ino, whichfork, &irec);
+			rmap_add_rec(mp, ino, whichfork, &irec, false);
 		*tot += irec.br_blockcount;
 	}
 	error = 0;
diff --git a/repair/rmap.c b/repair/rmap.c
index db85b747e53..9550377df16 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -25,7 +25,7 @@
 # define dbg_printf(f, a...)
 #endif
 
-/* per-AG rmap object anchor */
+/* allocation group (AG or rtgroup) rmap object anchor */
 struct xfs_ag_rmap {
 	struct xfbtree	*ar_xfbtree;		/* rmap observations */
 	struct xfs_slab	*ar_agbtree_rmaps;	/* rmaps for rebuilt ag btrees */
@@ -35,9 +35,17 @@ struct xfs_ag_rmap {
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
+static struct xfs_ag_rmap *rg_rmaps;
 bool rmapbt_suspect;
 static bool refcbt_suspect;
 
+static struct xfs_ag_rmap *rmaps_for_group(bool isrt, unsigned int group)
+{
+	if (isrt)
+		return &rg_rmaps[group];
+	return &ag_rmaps[group];
+}
+
 static inline int rmap_compare(const void *a, const void *b)
 {
 	return libxfs_rmap_compare(a, b);
@@ -78,6 +86,45 @@ rmaps_destroy(
 	xfile_destroy(xfile);
 }
 
+/* Initialize the in-memory rmap btree for collecting realtime rmap records. */
+STATIC void
+rmaps_init_rt(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_ag_rmap	*ag_rmap)
+{
+	struct xfile		*xfile;
+	struct xfs_buftarg	*target;
+	unsigned long long	maxbytes;
+	int			error;
+
+	if (!xfs_has_realtime(mp))
+		return;
+
+	/*
+	 * Each rtgroup rmap btree file can consume the entire data device,
+	 * even if the metadata space reservation will be smaller than that.
+	 */
+	maxbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks);
+	error = xfile_create(mp, maxbytes, "rtrmapbt repair", &xfile);
+	if (error)
+		goto nomem;
+
+	error = -libxfs_alloc_memory_buftarg(mp, xfile, &target);
+	if (error)
+		goto nomem;
+
+	error = -libxfs_rtrmapbt_mem_create(mp, rgno, target,
+			&ag_rmap->ar_xfbtree);
+	if (error)
+		goto nomem;
+
+	return;
+nomem:
+	do_error(
+_("Insufficient memory while allocating realtime reverse mapping btree."));
+}
+
 /* Initialize the in-memory rmap btree for collecting per-AG rmap records. */
 STATIC void
 rmaps_init_ag(
@@ -138,6 +185,13 @@ rmaps_init(
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		rmaps_init_ag(mp, i, &ag_rmaps[i]);
+
+	rg_rmaps = calloc(mp->m_sb.sb_rgcount, sizeof(struct xfs_ag_rmap));
+	if (!rg_rmaps)
+		do_error(_("couldn't allocate per-rtgroup reverse map roots\n"));
+
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+		rmaps_init_rt(mp, i, &rg_rmaps[i]);
 }
 
 /*
@@ -152,6 +206,11 @@ rmaps_free(
 	if (!rmap_needs_work(mp))
 		return;
 
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+		rmaps_destroy(mp, &rg_rmaps[i]);
+	free(rg_rmaps);
+	rg_rmaps = NULL;
+
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		rmaps_destroy(mp, &ag_rmaps[i]);
 	free(ag_rmaps);
@@ -187,26 +246,38 @@ int
 rmap_init_mem_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	struct rmap_mem_cur	*rmcur)
 {
 	struct xfbtree		*xfbt;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
-	xfbt = ag_rmaps[agno].ar_xfbtree;
+	xfbt = rmaps_for_group(isrt, agno)->ar_xfbtree;
 	error = -xfbtree_head_read_buf(xfbt, tp, &rmcur->mhead_bp);
 	if (error)
 		return error;
 
-	pag = libxfs_perag_get(mp, agno);
-	rmcur->mcur = libxfs_rmapbt_mem_cursor(pag, tp, rmcur->mhead_bp, xfbt);
+	if (isrt) {
+		rtg = libxfs_rtgroup_get(mp, agno);
+		rmcur->mcur = libxfs_rtrmapbt_mem_cursor(rtg, tp,
+				rmcur->mhead_bp, xfbt);
+	} else {
+		pag = libxfs_perag_get(mp, agno);
+		rmcur->mcur = libxfs_rmapbt_mem_cursor(pag, tp,
+				rmcur->mhead_bp, xfbt);
+	}
 
 	error = -libxfs_btree_goto_left_edge(rmcur->mcur);
 	if (error)
 		rmap_free_mem_cursor(tp, rmcur, error);
 
-	libxfs_perag_put(pag);
+	if (pag)
+		libxfs_perag_put(pag);
+	if (rtg)
+		libxfs_rtgroup_put(rtg);
 	return error;
 }
 
@@ -251,6 +322,7 @@ rmap_get_mem_rec(
 static void
 rmap_add_mem_rec(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	struct xfs_rmap_irec	*rmap)
 {
@@ -259,12 +331,12 @@ rmap_add_mem_rec(
 	struct xfs_trans	*tp;
 	int			error;
 
-	xfbt = ag_rmaps[agno].ar_xfbtree;
+	xfbt = rmaps_for_group(isrt, agno)->ar_xfbtree;
 	error = -libxfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		do_error(_("allocating tx for in-memory rmap update\n"));
 
-	error = rmap_init_mem_cursor(mp, tp, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, tp, isrt, agno, &rmcur);
 	if (error)
 		do_error(_("reading in-memory rmap btree head\n"));
 
@@ -289,7 +361,8 @@ rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	int			whichfork,
-	struct xfs_bmbt_irec	*irec)
+	struct xfs_bmbt_irec	*irec,
+	bool			isrt)
 {
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
@@ -298,11 +371,19 @@ rmap_add_rec(
 	if (!rmap_needs_work(mp))
 		return;
 
-	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_agblocks);
+	if (isrt) {
+		xfs_rgnumber_t	rgno;
+
+		agbno = xfs_rtb_to_rgbno(mp, irec->br_startblock, &rgno);
+		agno = rgno;
+		ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_rblocks);
+	} else {
+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+		agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+		ASSERT(agno != NULLAGNUMBER);
+		ASSERT(agno < mp->m_sb.sb_agcount);
+		ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_agblocks);
+	}
 	ASSERT(ino != NULLFSINO);
 	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
 
@@ -316,7 +397,7 @@ rmap_add_rec(
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
 
-	rmap_add_mem_rec(mp, agno, &rmap);
+	rmap_add_mem_rec(mp, isrt, agno, &rmap);
 }
 
 /* add a raw rmap; these will be merged later */
@@ -343,7 +424,7 @@ __rmap_add_raw_rec(
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = len;
 
-	rmap_add_mem_rec(mp, agno, &rmap);
+	rmap_add_mem_rec(mp, false, agno, &rmap);
 }
 
 /*
@@ -412,6 +493,7 @@ rmap_add_agbtree_mapping(
 		.rm_blockcount	= len,
 	};
 	struct xfs_perag	*pag;
+	struct xfs_ag_rmap	*x;
 
 	if (!rmap_needs_work(mp))
 		return 0;
@@ -420,7 +502,8 @@ rmap_add_agbtree_mapping(
 	assert(libxfs_verify_agbext(pag, agbno, len));
 	libxfs_perag_put(pag);
 
-	return slab_add(ag_rmaps[agno].ar_agbtree_rmaps, &rmap);
+	x = rmaps_for_group(false, agno);
+	return slab_add(x->ar_agbtree_rmaps, &rmap);
 }
 
 static int
@@ -536,7 +619,7 @@ rmap_commit_agbtree_mappings(
 	struct xfs_buf		*agflbp = NULL;
 	struct xfs_trans	*tp;
 	__be32			*agfl_bno, *b;
-	struct xfs_ag_rmap	*ag_rmap = &ag_rmaps[agno];
+	struct xfs_ag_rmap	*ag_rmap = rmaps_for_group(false, agno);
 	struct bitmap		*own_ag_bitmap = NULL;
 	int			error = 0;
 
@@ -799,7 +882,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = ag_rmaps[agno].ar_refcount_items;
+	rlslab = rmaps_for_group(false, agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -933,12 +1016,12 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
-	if (ag_rmaps[agno].ar_xfbtree == NULL)
+	if (rmaps_for_group(false, agno)->ar_xfbtree == NULL)
 		return 0;
 
-	nr_rmaps = rmap_record_count(mp, agno);
+	nr_rmaps = rmap_record_count(mp, false, agno);
 
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rmcur);
 	if (error)
 		return error;
 
@@ -1043,16 +1126,17 @@ count_btree_records(
 uint64_t
 rmap_record_count(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno)
 {
 	struct rmap_mem_cur	rmcur;
 	uint64_t		nr = 0;
 	int			error;
 
-	if (ag_rmaps[agno].ar_xfbtree == NULL)
+	if (rmaps_for_group(isrt, agno)->ar_xfbtree == NULL)
 		return 0;
 
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, NULL, isrt, agno, &rmcur);
 	if (error)
 		do_error(_("%s while reading in-memory rmap btree\n"),
 				strerror(error));
@@ -1168,7 +1252,7 @@ rmaps_verify_btree(
 	}
 
 	/* Create cursors to rmap structures */
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rm_cur);
+	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rm_cur);
 	if (error) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		return;
@@ -1488,7 +1572,9 @@ refcount_record_count(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_refcount_items);
+	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+
+	return slab_count(x->ar_refcount_items);
 }
 
 /*
@@ -1499,7 +1585,9 @@ init_refcount_cursor(
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
-	return init_slab_cursor(ag_rmaps[agno].ar_refcount_items, NULL, cur);
+	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+
+	return init_slab_cursor(x->ar_refcount_items, NULL, cur);
 }
 
 /*
@@ -1700,5 +1788,5 @@ rmap_store_agflcount(
 	if (!rmap_needs_work(mp))
 		return;
 
-	ag_rmaps[agno].ar_flcount = count;
+	rmaps_for_group(false, agno)->ar_flcount = count;
 }
diff --git a/repair/rmap.h b/repair/rmap.h
index cb6c32af62c..008b96a38f4 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -15,7 +15,7 @@ extern void rmaps_init(struct xfs_mount *);
 extern void rmaps_free(struct xfs_mount *);
 
 void rmap_add_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
-		struct xfs_bmbt_irec *irec);
+		struct xfs_bmbt_irec *irec, bool realtime);
 void rmap_add_bmbt_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
 		xfs_fsblock_t fsbno);
 bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
@@ -26,7 +26,8 @@ int rmap_add_agbtree_mapping(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
 int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
-uint64_t rmap_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
+uint64_t rmap_record_count(struct xfs_mount *mp, bool isrt,
+		xfs_agnumber_t agno);
 extern void rmap_avoid_check(void);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
@@ -54,7 +55,7 @@ struct rmap_mem_cur {
 };
 
 int rmap_init_mem_cursor(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, struct rmap_mem_cur *rmcur);
+		bool isrt, xfs_agnumber_t agno, struct rmap_mem_cur *rmcur);
 void rmap_free_mem_cursor(struct xfs_trans *tp, struct rmap_mem_cur *rmcur,
 		int error);
 int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);

