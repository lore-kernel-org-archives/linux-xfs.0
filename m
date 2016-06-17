Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1D378235
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B412B8F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aSJZyinT5X0Z067m (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:47 -0700 (PDT)
Subject: [PATCH 065/145] xfs_repair: add per-AG btree blocks to rmap data
	and add to rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:39 -0700
Message-ID: <146612745922.16048.15574181384571390206.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Since we can't know the location of the new per-AG btree blocks prior
to constructing the rmapbt, we must record raw reverse-mapping data for
btree blocks while the new btrees are under construction.  After the
rmapbt has been rebuilt, merge the btree rmap entries into the rmapbt
with the libxfs code.

Also refactor the freelist fixing code since we need it to tidy up
the AGFL after each rmapbt allocation.

v2: Use xfs_rmap_alloc to add rmap records for AG metadata blocks
because it knows how to merge adjacent rmaps.  This particular bug was
discovered while running xfs_repair twice on generic/175 wherein block
X was originally allocated to the rmapbt, then X+1 got allocated to
the rmapbt when we expanded it to hold all the entries for the rmapbt
blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   52 +++++++-------
 repair/rmap.c   |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    4 +
 3 files changed, 226 insertions(+), 28 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index bb065ec..db84440 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -74,6 +74,7 @@ typedef struct bt_status  {
 	 * per-level status info
 	 */
 	bt_stat_level_t		level[XFS_BTREE_MAXLEVELS];
+	uint64_t		owner;		/* owner */
 } bt_status_t;
 
 /*
@@ -205,6 +206,7 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 	extent_tree_node_t	*bno_ext_ptr;
 	xfs_extlen_t		blocks_allocated;
 	xfs_agblock_t		*agb_ptr;
+	int			error;
 
 	/*
 	 * get the number of blocks we need to allocate, then
@@ -249,6 +251,12 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 			blocks_allocated++;
 		}
 
+		error = add_ag_rmap(mp, agno, ext_ptr->ex_startblock, u,
+				curs->owner);
+		if (error)
+			do_error(_("could not set up btree rmaps: %s\n"),
+				strerror(-error));
+
 		/*
 		 * if we only used part of this last extent, then we
 		 * need only to reset the extent in the extent
@@ -916,6 +924,7 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 
 	lptr = &btree_curs->level[0];
 	btree_curs->init = 1;
+	btree_curs->owner = XFS_RMAP_OWN_INOBT;
 
 	/*
 	 * build up statistics
@@ -1355,6 +1364,7 @@ init_rmapbt_cursor(
 
 	lptr = &btree_curs->level[0];
 	btree_curs->init = 1;
+	btree_curs->owner = XFS_RMAP_OWN_AG;
 
 	/*
 	 * build up statistics
@@ -1834,6 +1844,7 @@ build_agf_agfl(
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(i - 1);
 		agf->agf_flcount = cpu_to_be32(i);
+		rmap_store_agflcount(mp, agno, i);
 
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "writing agfl for ag %u\n", agno);
@@ -1858,35 +1869,8 @@ build_agf_agfl(
 
 	/*
 	 * now fix up the free list appropriately
-	 * XXX: code lifted from mkfs, should be shared.
 	 */
-	{
-		xfs_alloc_arg_t	args;
-		xfs_trans_t	*tp;
-		struct xfs_trans_res tres = {0};
-		int		error;
-
-		memset(&args, 0, sizeof(args));
-		args.mp = mp;
-		args.agno = agno;
-		args.alignment = 1;
-		args.pag = xfs_perag_get(mp,agno);
-		error = -libxfs_trans_alloc(mp, &tres,
-				xfs_alloc_min_freelist(mp, args.pag),
-				0, 0, &tp);
-		if (error) {
-			do_error(_("failed to fix AGFL on AG %d, error %d\n"),
-					agno, error);
-		}
-		args.tp = tp;
-		error = -libxfs_alloc_fix_freelist(&args, 0);
-		xfs_perag_put(args.pag);
-		if (error) {
-			do_error(_("failed to fix AGFL on AG %d, error %d\n"),
-					agno, error);
-		}
-		libxfs_trans_commit(tp);
-	}
+	fix_freelist(mp, agno, true);
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "wrote agf for ag %u\n", agno);
@@ -1958,6 +1942,7 @@ phase5_func(
 	xfs_agblock_t	num_extents;
 	__uint32_t	magic;
 	struct agi_stat	agi_stat = {0,};
+	int		error;
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -2063,6 +2048,8 @@ phase5_func(
 
 		bcnt_btree_curs = bno_btree_curs;
 
+		bno_btree_curs.owner = XFS_RMAP_OWN_AG;
+		bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
 		setup_cursor(mp, agno, &bno_btree_curs);
 		setup_cursor(mp, agno, &bcnt_btree_curs);
 
@@ -2140,6 +2127,15 @@ phase5_func(
 		if (xfs_sb_version_hasfinobt(&mp->m_sb))
 			finish_cursor(&fino_btree_curs);
 		finish_cursor(&bcnt_btree_curs);
+
+		/*
+		 * Put the per-AG btree rmap data into the rmapbt
+		 */
+		error = store_ag_btree_rmap_data(mp, agno);
+		if (error)
+			do_error(
+_("unable to add AG %u reverse-mapping data to btree.\n"), agno);
+
 		/*
 		 * release the incore per-AG bno/bcnt trees so
 		 * the extent nodes can be recycled
diff --git a/repair/rmap.c b/repair/rmap.c
index 4648425..9c17ee8 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -39,6 +39,8 @@
 struct xfs_ag_rmap {
 	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
 	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
+	int		ar_flcount;		/* agfl entries from leftover */
+						/* agbt allocations */
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -424,6 +426,124 @@ out:
 	return error;
 }
 
+/*
+ * Copy the per-AG btree reverse-mapping data into the rmapbt.
+ *
+ * At rmapbt reconstruction time, the rmapbt will be populated _only_ with
+ * rmaps for file extents, inode chunks, AG headers, and bmbt blocks.  While
+ * building the AG btrees we can record all the blocks allocated for each
+ * btree, but we cannot resolve the conflict between the fact that one has to
+ * finish allocating the space for the rmapbt before building the bnobt and the
+ * fact that allocating blocks for the bnobt requires adding rmapbt entries.
+ * Therefore we record in-core the rmaps for each btree and here use the
+ * libxfs rmap functions to finish building the rmap btree.
+ *
+ * During AGF/AGFL reconstruction in phase 5, rmaps for the AG btrees are
+ * recorded in memory.  The rmapbt has not been set up yet, so we need to be
+ * able to "expand" the AGFL without updating the rmapbt.  After we've written
+ * out the new AGF header the new rmapbt is available, so this function reads
+ * each AGFL to generate rmap entries.  These entries are merged with the AG
+ * btree rmap entries, and then we use libxfs' rmap functions to add them to
+ * the rmapbt, after which it is fully regenerated.
+ */
+int
+store_ag_btree_rmap_data(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_slab_cursor	*rm_cur;
+	struct xfs_rmap_irec	*rm_rec = NULL;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_buf		*agflbp = NULL;
+	struct xfs_trans	*tp;
+	struct xfs_trans_res tres = {0};
+	__be32			*agfl_bno, *b;
+	int			error = 0;
+	struct xfs_owner_info	oinfo;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	/* Release the ar_rmaps; they were put into the rmapbt during p5. */
+	free_slab(&ag_rmaps[agno].ar_rmaps);
+	error = init_slab(&ag_rmaps[agno].ar_rmaps,
+				  sizeof(struct xfs_rmap_irec));
+	if (error)
+		goto err;
+
+	/* Add the AGFL blocks to the rmap list */
+	error = xfs_trans_read_buf(
+			mp, NULL, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &agflbp, &xfs_agfl_buf_ops);
+	if (error)
+		goto err;
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno += ag_rmaps[agno].ar_flcount;
+	b = agfl_bno;
+	while (*b != NULLAGBLOCK && b - agfl_bno <= XFS_AGFL_SIZE(mp)) {
+		error = add_ag_rmap(mp, agno, be32_to_cpu(*b), 1,
+				XFS_RMAP_OWN_AG);
+		if (error)
+			goto err;
+		b++;
+	}
+	libxfs_putbuf(agflbp);
+	agflbp = NULL;
+
+	/* Merge all the raw rmaps into the main list */
+	error = fold_raw_rmaps(mp, agno);
+	if (error)
+		goto err;
+
+	/* Create cursors to refcount structures */
+	error = init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare,
+			&rm_cur);
+	if (error)
+		goto err;
+
+	/* Insert rmaps into the btree one at a time */
+	rm_rec = pop_slab_cursor(rm_cur);
+	while (rm_rec) {
+		error = -libxfs_trans_alloc(mp, &tres, 16, 0, 0, &tp);
+		if (error)
+			goto err_slab;
+
+		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+		if (error)
+			goto err_trans;
+
+		ASSERT(XFS_RMAP_NON_INODE_OWNER(rm_rec->rm_owner));
+		xfs_rmap_ag_owner(&oinfo, rm_rec->rm_owner);
+		error = xfs_rmap_alloc(tp, agbp, agno, rm_rec->rm_startblock,
+				rm_rec->rm_blockcount, &oinfo);
+		if (error)
+			goto err_trans;
+
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			goto err_slab;
+
+		fix_freelist(mp, agno, false);
+
+		rm_rec = pop_slab_cursor(rm_cur);
+	}
+
+	free_slab_cursor(&rm_cur);
+	return 0;
+
+err_trans:
+	libxfs_trans_cancel(tp);
+err_slab:
+	free_slab_cursor(&rm_cur);
+err:
+	if (agflbp)
+		libxfs_putbuf(agflbp);
+	printf("FAIL err %d\n", error);
+	return error;
+}
+
 #ifdef RMAP_DEBUG
 static void
 dump_rmap(
@@ -695,3 +815,81 @@ rmap_high_key_from_rec(
 		return;
 	key->rm_offset += adj;
 }
+
+/*
+ * Regenerate the AGFL so that we don't run out of it while rebuilding the
+ * rmap btree.  If skip_rmapbt is true, don't update the rmapbt (most probably
+ * because we're updating the rmapbt).
+ */
+void
+fix_freelist(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	bool			skip_rmapbt)
+{
+	xfs_alloc_arg_t		args;
+	xfs_trans_t		*tp;
+	struct xfs_trans_res	tres = {0};
+	int			flags;
+	int			error;
+
+	memset(&args, 0, sizeof(args));
+	args.mp = mp;
+	args.agno = agno;
+	args.alignment = 1;
+	args.pag = xfs_perag_get(mp, agno);
+	error = -libxfs_trans_alloc(mp, &tres,
+			xfs_alloc_min_freelist(mp, args.pag), 0, 0, &tp);
+	if (error)
+		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
+				agno, error);
+	args.tp = tp;
+
+	/*
+	 * Prior to rmapbt, all we had to do to fix the freelist is "expand"
+	 * the fresh AGFL header from empty to full.  That hasn't changed.  For
+	 * rmapbt, however, things change a bit.
+	 *
+	 * When we're stuffing the rmapbt with the AG btree rmaps the tree can
+	 * expand, so we need to keep the AGFL well-stocked for the expansion.
+	 * However, this expansion can cause the bnobt/cntbt to shrink, which
+	 * can make the AGFL eligible for shrinking.  Shrinking involves
+	 * freeing rmapbt entries, but since we haven't finished loading the
+	 * rmapbt with the btree rmaps it's possible for the remove operation
+	 * to fail.  The AGFL block is large enough at this point to absorb any
+	 * blocks freed from the bnobt/cntbt, so we can disable shrinking.
+	 *
+	 * During the initial AGFL regeneration during AGF generation in phase5
+	 * we must also disable rmapbt modifications because the AGF that
+	 * libxfs reads does not yet point to the new rmapbt.  These initial
+	 * AGFL entries are added just prior to adding the AG btree block rmaps
+	 * to the rmapbt.  It's ok to pass NOSHRINK here too, since the AGFL is
+	 * empty and cannot shrink.
+	 */
+	flags = XFS_ALLOC_FLAG_NOSHRINK;
+	if (skip_rmapbt)
+		flags |= XFS_ALLOC_FLAG_NORMAP;
+	error = libxfs_alloc_fix_freelist(&args, flags);
+	xfs_perag_put(args.pag);
+	if (error) {
+		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
+				agno, error);
+	}
+	libxfs_trans_commit(tp);
+}
+
+/*
+ * Remember how many AGFL entries came from excess AG btree allocations and
+ * therefore already have rmap entries.
+ */
+void
+rmap_store_agflcount(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			count)
+{
+	if (!needs_rmap_work(mp))
+		return;
+
+	ag_rmaps[agno].ar_flcount = count;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index d9d08d4..4722266 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -35,6 +35,7 @@ extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern bool mergeable_rmaps(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
 extern int add_fixed_ag_rmap_data(struct xfs_mount *, xfs_agnumber_t);
+extern int store_ag_btree_rmap_data(struct xfs_mount *, xfs_agnumber_t);
 
 extern size_t rmap_record_count(struct xfs_mount *, xfs_agnumber_t);
 extern int init_rmap_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
@@ -46,4 +47,7 @@ extern __int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
 extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 		struct xfs_rmap_irec *key);
 
+extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
+extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
+
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
