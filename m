Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB532417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882436; cv=none; b=B+SUFtyTnkUdWHQhkD63U1m9VpK/yUCBQek7fXtdkTopNoNqCPGJDxk23HtjLC6mrmEidvYVZ9UKhF2/8LDmZdWF+3r8Lb3ojIMIrW/t4y0yhnRwjFsAl5VhE/cl5koVLTgn01GoE1mXep0rNUWsaksdwRCBHoNfkprF1rG+ADg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882436; c=relaxed/simple;
	bh=4Aw6ie7Qlc7674s9J/lrFk7jcLQB3eXQnWnNf38xsIM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTL6q0l5JyoISZb9xWrS4ryowIJDPB4Ct9iOIa91QVkEeKZGW/Zfi5X+chQzQkuIrrPmJqEokgnu74GFCS1RWnseJc6e8DSOKjBfQKjyzVndp5OPiN/F48OoXv1TfiILim+201S66zzXUMpyhJ5l+CupMCJFMZbAWIku/PcgA4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SW7Bkd99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SW7Bkd99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C88C4CEDD;
	Thu,  6 Feb 2025 22:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882434;
	bh=4Aw6ie7Qlc7674s9J/lrFk7jcLQB3eXQnWnNf38xsIM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SW7Bkd99uqyZ9m/DuV4fH4ZK6cDgY4Wj+cQdprgBYw3EIPZzkC49Y9sY9JnfozbKW
	 vh8V5Q0EuoZk2CBuZ/K/KhNub6WtoORS0v55LekJtCt6fV9q+C6l18nHUzWNN8lXXj
	 L/lVhbV8l3LhROt4Osn/RXj1pOoyG0j7CtRQKIQ2bP8hmAgjP3Ncz4nJfUVZeU+EWx
	 oYzbBluBF240k816xyeRbKElXy2GB205yL6dKtiK1Nc9ssdkRAiSFaYbo4JC2JmZQb
	 C9O9ScN2OxOUO+qxBsj44zj0M8g/K34XEVaO8SJcyXNM2vuLzVW13ym+6UgrjLR5G2
	 mBjz8duJhK+Ww==
Date: Thu, 06 Feb 2025 14:53:54 -0800
Subject: [PATCH 16/27] xfs_repair: create a new set of incore rmap information
 for rt groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088341.2741033.9571711667950343905.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/agbtree.c         |    5 +-
 repair/dinode.c          |    2 -
 repair/rmap.c            |  139 +++++++++++++++++++++++++++++++++++++---------
 repair/rmap.h            |    7 +-
 5 files changed, 121 insertions(+), 34 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9beea4f7ce8535..b62efad757470b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -318,6 +318,8 @@
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
+#define xfs_rtrmapbt_mem_init		libxfs_rtrmapbt_mem_init
+#define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_mount_rextsize		libxfs_sb_mount_rextsize
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 42bfeee9eafbcb..2135147fcf9354 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -646,7 +646,7 @@ init_rmapbt_cursor(
 
 	/* Compute how many blocks we'll need. */
 	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
-			rmap_record_count(sc->mp, agno));
+			rmap_record_count(sc->mp, false, agno));
 	if (error)
 		do_error(
 _("Unable to compute rmap btree geometry, error %d.\n"), error);
@@ -663,7 +663,8 @@ build_rmap_tree(
 {
 	int			error;
 
-	error = rmap_init_mem_cursor(sc->mp, NULL, agno, &btr->rmapbt_cursor);
+	error = rmap_init_mem_cursor(sc->mp, NULL, false, agno,
+			&btr->rmapbt_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct rmap cursor.\n"));
diff --git a/repair/dinode.c b/repair/dinode.c
index 641beab333f793..3f78eb064919be 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -708,7 +708,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 			}
 		}
 		if (collect_rmaps && !zap_metadata) /* && !check_dups */
-			rmap_add_rec(mp, ino, whichfork, &irec);
+			rmap_add_rec(mp, ino, whichfork, &irec, isrt);
 		*tot += irec.br_blockcount;
 	}
 	error = 0;
diff --git a/repair/rmap.c b/repair/rmap.c
index 36e4c9858fba03..13e9a06b04f370 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -24,7 +24,7 @@
 # define dbg_printf(f, a...)
 #endif
 
-/* per-AG rmap object anchor */
+/* allocation group (AG or rtgroup) rmap object anchor */
 struct xfs_ag_rmap {
 	/* root of rmap observations btree */
 	struct xfbtree		ar_xfbtree;
@@ -42,9 +42,17 @@ struct xfs_ag_rmap {
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
@@ -83,6 +91,44 @@ rmaps_destroy(
 	xmbuf_free(ag_rmap->ar_xmbtp);
 }
 
+/* Initialize the in-memory rmap btree for collecting realtime rmap records. */
+STATIC void
+rmaps_init_rt(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_ag_rmap	*ag_rmap)
+{
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
+	descr = kasprintf(GFP_KERNEL,
+			"xfs_repair (%s): rtgroup %u rmap records",
+			mp->m_fsname, rgno);
+	error = -xmbuf_alloc(mp, descr, maxbytes, &ag_rmap->ar_xmbtp);
+	kfree(descr);
+	if (error)
+		goto nomem;
+
+	error = -libxfs_rtrmapbt_mem_init(mp, &ag_rmap->ar_xfbtree,
+			ag_rmap->ar_xmbtp, rgno);
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
@@ -150,6 +196,13 @@ rmaps_init(
 
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
@@ -164,6 +217,11 @@ rmaps_free(
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
@@ -199,22 +257,32 @@ int
 rmap_init_mem_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	struct xfs_btree_cur	**rmcurp)
 {
 	struct xfbtree		*xfbt;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
-	xfbt = &ag_rmaps[agno].ar_xfbtree;
-	pag = libxfs_perag_get(mp, agno);
-	*rmcurp = libxfs_rmapbt_mem_cursor(pag, tp, xfbt);
+	xfbt = &rmaps_for_group(isrt, agno)->ar_xfbtree;
+	if (isrt) {
+		rtg = libxfs_rtgroup_get(mp, agno);
+		*rmcurp = libxfs_rtrmapbt_mem_cursor(rtg, tp, xfbt);
+	} else {
+		pag = libxfs_perag_get(mp, agno);
+		*rmcurp = libxfs_rmapbt_mem_cursor(pag, tp, xfbt);
+	}
 
 	error = -libxfs_btree_goto_left_edge(*rmcurp);
 	if (error)
 		libxfs_btree_del_cursor(*rmcurp, error);
 
-	libxfs_perag_put(pag);
+	if (pag)
+		libxfs_perag_put(pag);
+	if (rtg)
+		libxfs_rtgroup_put(rtg);
 	return error;
 }
 
@@ -247,6 +315,7 @@ rmap_get_mem_rec(
 static void
 rmap_add_mem_rec(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	struct xfs_rmap_irec	*rmap)
 {
@@ -255,12 +324,12 @@ rmap_add_mem_rec(
 	struct xfs_trans	*tp;
 	int			error;
 
-	xfbt = &ag_rmaps[agno].ar_xfbtree;
+	xfbt = &rmaps_for_group(isrt, agno)->ar_xfbtree;
 	error = -libxfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		do_error(_("allocating tx for in-memory rmap update\n"));
 
-	error = rmap_init_mem_cursor(mp, tp, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, tp, isrt, agno, &rmcur);
 	if (error)
 		do_error(_("reading in-memory rmap btree head\n"));
 
@@ -285,7 +354,8 @@ rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	int			whichfork,
-	struct xfs_bmbt_irec	*irec)
+	struct xfs_bmbt_irec	*irec,
+	bool			isrt)
 {
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
@@ -294,11 +364,17 @@ rmap_add_rec(
 	if (!rmap_needs_work(mp))
 		return;
 
-	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_agblocks);
+	if (isrt) {
+		agno = xfs_rtb_to_rgno(mp, irec->br_startblock);
+		agbno = xfs_rtb_to_rgbno(mp, irec->br_startblock);
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
 
@@ -312,7 +388,7 @@ rmap_add_rec(
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
 
-	rmap_add_mem_rec(mp, agno, &rmap);
+	rmap_add_mem_rec(mp, isrt, agno, &rmap);
 }
 
 /* add a raw rmap; these will be merged later */
@@ -339,7 +415,7 @@ __rmap_add_raw_rec(
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = len;
 
-	rmap_add_mem_rec(mp, agno, &rmap);
+	rmap_add_mem_rec(mp, false, agno, &rmap);
 }
 
 /*
@@ -408,6 +484,7 @@ rmap_add_agbtree_mapping(
 		.rm_blockcount	= len,
 	};
 	struct xfs_perag	*pag;
+	struct xfs_ag_rmap	*x;
 
 	if (!rmap_needs_work(mp))
 		return 0;
@@ -416,7 +493,8 @@ rmap_add_agbtree_mapping(
 	assert(libxfs_verify_agbext(pag, agbno, len));
 	libxfs_perag_put(pag);
 
-	return slab_add(ag_rmaps[agno].ar_agbtree_rmaps, &rmap);
+	x = rmaps_for_group(false, agno);
+	return slab_add(x->ar_agbtree_rmaps, &rmap);
 }
 
 static int
@@ -532,7 +610,7 @@ rmap_commit_agbtree_mappings(
 	struct xfs_buf		*agflbp = NULL;
 	struct xfs_trans	*tp;
 	__be32			*agfl_bno, *b;
-	struct xfs_ag_rmap	*ag_rmap = &ag_rmaps[agno];
+	struct xfs_ag_rmap	*ag_rmap = rmaps_for_group(false, agno);
 	struct bitmap		*own_ag_bitmap = NULL;
 	int			error = 0;
 
@@ -795,7 +873,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = ag_rmaps[agno].ar_refcount_items;
+	rlslab = rmaps_for_group(false, agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -928,12 +1006,12 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
-	if (!rmaps_has_observations(&ag_rmaps[agno]))
+	if (!rmaps_has_observations(rmaps_for_group(false, agno)))
 		return 0;
 
-	nr_rmaps = rmap_record_count(mp, agno);
+	nr_rmaps = rmap_record_count(mp, false, agno);
 
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rmcur);
 	if (error)
 		return error;
 
@@ -1038,16 +1116,17 @@ count_btree_records(
 uint64_t
 rmap_record_count(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno)
 {
 	struct xfs_btree_cur	*rmcur;
 	uint64_t		nr = 0;
 	int			error;
 
-	if (!rmaps_has_observations(&ag_rmaps[agno]))
+	if (!rmaps_has_observations(rmaps_for_group(isrt, agno)))
 		return 0;
 
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, NULL, isrt, agno, &rmcur);
 	if (error)
 		do_error(_("%s while reading in-memory rmap btree\n"),
 				strerror(error));
@@ -1163,7 +1242,7 @@ rmaps_verify_btree(
 	}
 
 	/* Create cursors to rmap structures */
-	error = rmap_init_mem_cursor(mp, NULL, agno, &rm_cur);
+	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rm_cur);
 	if (error) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		return;
@@ -1483,7 +1562,9 @@ refcount_record_count(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_refcount_items);
+	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+
+	return slab_count(x->ar_refcount_items);
 }
 
 /*
@@ -1494,7 +1575,9 @@ init_refcount_cursor(
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
-	return init_slab_cursor(ag_rmaps[agno].ar_refcount_items, NULL, cur);
+	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+
+	return init_slab_cursor(x->ar_refcount_items, NULL, cur);
 }
 
 /*
@@ -1695,7 +1778,7 @@ rmap_store_agflcount(
 	if (!rmap_needs_work(mp))
 		return;
 
-	ag_rmaps[agno].ar_flcount = count;
+	rmaps_for_group(false, agno)->ar_flcount = count;
 }
 
 /* Estimate the size of the ondisk rmapbt from the incore data. */
diff --git a/repair/rmap.h b/repair/rmap.h
index 57e5d5b216650e..23871e6d60e774 100644
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
 
@@ -52,7 +53,7 @@ xfs_extlen_t estimate_rmapbt_blocks(struct xfs_perag *pag);
 xfs_extlen_t estimate_refcountbt_blocks(struct xfs_perag *pag);
 
 int rmap_init_mem_cursor(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, struct xfs_btree_cur **rmcurp);
+		bool isrt, xfs_agnumber_t agno, struct xfs_btree_cur **rmcurp);
 int rmap_get_mem_rec(struct xfs_btree_cur *rmcur, struct xfs_rmap_irec *irec);
 
 xfs_rgnumber_t rtgroup_for_rtrmap_inode(struct xfs_mount *mp, xfs_ino_t ino);

