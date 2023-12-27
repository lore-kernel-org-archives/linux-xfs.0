Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573DD63D
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Es6sHkmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB0CC433C7;
	Mon,  1 Jan 2024 00:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068378;
	bh=A4tu//OTTh63oqfXl9wFUs+X8BNmS5pKxdvXdBH61RA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Es6sHkmBHhoteOAQ9EcXK6mJ0LvcAvRLr85lBItjkU4X20hznAiEnX7QPo7cLNCWq
	 J/Bj9o6KS2F//7l/s2DjA32Jpalv4RFMjT4YyxkOFu/1nc1KewNkcP36rBlLE68Opm
	 /36adUtuu/uKSrzyGXa+pynYU2CCoLIFkaWF4Qb1hejoXjkLcAhQgDDa+XyRDimaIP
	 +jocj7k0GJtXyEvW8ErTpOToo6mNsXa78EFELz4+4/9UWEQ8emzVlPkRjRAQInaPov
	 SMoV4amCkYWCr6K9yqE5jx5Ts5OftID2hOQHZy/xj2ETbktsJ9OkrTKfRXH85EOU5R
	 qZfd0lofgyc9w==
Date: Sun, 31 Dec 2023 16:19:38 +9900
Subject: [PATCH 35/47] xfs_repair: create a new set of incore rmap information
 for rt groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015779.1815505.123166879092121202.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a parallel set of "xfs_ag_rmap" structures to cache information
about reverse mappings for the realtime groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    3 +
 repair/agbtree.c         |    5 +-
 repair/dinode.c          |    2 -
 repair/rmap.c            |  143 +++++++++++++++++++++++++++++++++++++---------
 repair/rmap.h            |    7 +-
 5 files changed, 126 insertions(+), 34 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 85a4a131c75..e65b4d6fea5 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -284,6 +284,7 @@
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_rtgroup_get			libxfs_rtgroup_get
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
@@ -292,6 +293,8 @@
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
+#define xfs_rtrmapbt_mem_create		libxfs_rtrmapbt_mem_create
+#define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/repair/agbtree.c b/repair/agbtree.c
index dccb15f9667..a401c80da38 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -645,7 +645,7 @@ init_rmapbt_cursor(
 
 	/* Compute how many blocks we'll need. */
 	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
-			rmap_record_count(sc->mp, agno));
+			rmap_record_count(sc->mp, false, agno));
 	if (error)
 		do_error(
 _("Unable to compute rmap btree geometry, error %d.\n"), error);
@@ -662,7 +662,8 @@ build_rmap_tree(
 {
 	int			error;
 
-	error = rmap_init_mem_cursor(sc->mp, NULL, agno, &btr->rmapbt_cursor);
+	error = rmap_init_mem_cursor(sc->mp, NULL, false, agno,
+			&btr->rmapbt_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct rmap cursor.\n"));
diff --git a/repair/dinode.c b/repair/dinode.c
index 23cec00ad9e..41b44e6faad 100644
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
index 265199d2117..aa47013baec 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -26,7 +26,7 @@
 # define dbg_printf(f, a...)
 #endif
 
-/* per-AG rmap object anchor */
+/* allocation group (AG or rtgroup) rmap object anchor */
 struct xfs_ag_rmap {
 	struct xfbtree	*ar_xfbtree;		/* rmap observations */
 	struct xfs_slab	*ar_agbtree_rmaps;	/* rmaps for rebuilt ag btrees */
@@ -36,9 +36,17 @@ struct xfs_ag_rmap {
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
@@ -76,6 +84,44 @@ rmaps_destroy(
 	xfile_free_buftarg(target);
 }
 
+/* Initialize the in-memory rmap btree for collecting realtime rmap records. */
+STATIC void
+rmaps_init_rt(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_ag_rmap	*ag_rmap)
+{
+	struct xfs_buftarg	*target;
+	char			*descr;
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
+	descr = kasprintf("xfs_repair (%s): rtgroup %u rmap records",
+			mp->m_fsname, rgno);
+	error = -xfile_alloc_buftarg(mp, descr, maxbytes, &target);
+	kfree(descr);
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
@@ -135,6 +181,13 @@ rmaps_init(
 
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
@@ -149,6 +202,11 @@ rmaps_free(
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
@@ -184,26 +242,38 @@ int
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
 
@@ -248,6 +318,7 @@ rmap_get_mem_rec(
 static void
 rmap_add_mem_rec(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	struct xfs_rmap_irec	*rmap)
 {
@@ -256,12 +327,12 @@ rmap_add_mem_rec(
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
 
@@ -286,7 +357,8 @@ rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	int			whichfork,
-	struct xfs_bmbt_irec	*irec)
+	struct xfs_bmbt_irec	*irec,
+	bool			isrt)
 {
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
@@ -295,11 +367,19 @@ rmap_add_rec(
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
 
@@ -313,7 +393,7 @@ rmap_add_rec(
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
 
-	rmap_add_mem_rec(mp, agno, &rmap);
+	rmap_add_mem_rec(mp, isrt, agno, &rmap);
 }
 
 /* add a raw rmap; these will be merged later */
@@ -340,7 +420,7 @@ __rmap_add_raw_rec(
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = len;
 
-	rmap_add_mem_rec(mp, agno, &rmap);
+	rmap_add_mem_rec(mp, false, agno, &rmap);
 }
 
 /*
@@ -409,6 +489,7 @@ rmap_add_agbtree_mapping(
 		.rm_blockcount	= len,
 	};
 	struct xfs_perag	*pag;
+	struct xfs_ag_rmap	*x;
 
 	if (!rmap_needs_work(mp))
 		return 0;
@@ -417,7 +498,8 @@ rmap_add_agbtree_mapping(
 	assert(libxfs_verify_agbext(pag, agbno, len));
 	libxfs_perag_put(pag);
 
-	return slab_add(ag_rmaps[agno].ar_agbtree_rmaps, &rmap);
+	x = rmaps_for_group(false, agno);
+	return slab_add(x->ar_agbtree_rmaps, &rmap);
 }
 
 static int
@@ -533,7 +615,7 @@ rmap_commit_agbtree_mappings(
 	struct xfs_buf		*agflbp = NULL;
 	struct xfs_trans	*tp;
 	__be32			*agfl_bno, *b;
-	struct xfs_ag_rmap	*ag_rmap = &ag_rmaps[agno];
+	struct xfs_ag_rmap	*ag_rmap = rmaps_for_group(false, agno);
 	struct bitmap		*own_ag_bitmap = NULL;
 	int			error = 0;
 
@@ -796,7 +878,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = ag_rmaps[agno].ar_refcount_items;
+	rlslab = rmaps_for_group(false, agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -930,12 +1012,12 @@ compute_refcounts(
 
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
 
@@ -1040,16 +1122,17 @@ count_btree_records(
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
@@ -1165,7 +1248,7 @@ rmaps_verify_btree(
 	}
 
 	/* Create cursors to rmap structures */
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rm_cur);
+	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rm_cur);
 	if (error) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		return;
@@ -1485,7 +1568,9 @@ refcount_record_count(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_refcount_items);
+	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+
+	return slab_count(x->ar_refcount_items);
 }
 
 /*
@@ -1496,7 +1581,9 @@ init_refcount_cursor(
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
-	return init_slab_cursor(ag_rmaps[agno].ar_refcount_items, NULL, cur);
+	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+
+	return init_slab_cursor(x->ar_refcount_items, NULL, cur);
 }
 
 /*
@@ -1697,7 +1784,7 @@ rmap_store_agflcount(
 	if (!rmap_needs_work(mp))
 		return;
 
-	ag_rmaps[agno].ar_flcount = count;
+	rmaps_for_group(false, agno)->ar_flcount = count;
 }
 
 /* Estimate the size of the ondisk rmapbt from the incore data. */
diff --git a/repair/rmap.h b/repair/rmap.h
index 50268b2f8ca..7a94ed6f90a 100644
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
 
@@ -57,7 +58,7 @@ struct rmap_mem_cur {
 };
 
 int rmap_init_mem_cursor(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, struct rmap_mem_cur *rmcur);
+		bool isrt, xfs_agnumber_t agno, struct rmap_mem_cur *rmcur);
 void rmap_free_mem_cursor(struct xfs_trans *tp, struct rmap_mem_cur *rmcur,
 		int error);
 int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);

