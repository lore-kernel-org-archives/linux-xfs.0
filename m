Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE07C29E72
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:10:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A40A78F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:10 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id hb6sTvDUkj5T4o6W (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:07 -0800 (PST)
Subject: [PATCH 46/53] xfs_repair: process reverse-mapping data into
	refcount data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:10:01 -0800
Message-ID: <20151219091001.14255.66683.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

Take all the reverse-mapping data we've acquired and use it to generate
reference count data.  This data is used in phase 5 to rebuild the
refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   27 ++++++
 repair/rmap.c   |  236 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    2 
 3 files changed, 263 insertions(+), 2 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 98aab35..0be8579 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -183,6 +183,21 @@ _("%s while checking reverse-mappings"),
 }
 
 static void
+compute_ag_refcounts(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		error;
+
+	error = compute_refcounts(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while computing reference count records.\n"),
+			 strerror(-error));
+}
+
+static void
 process_rmap_data(
 	struct xfs_mount	*mp)
 {
@@ -196,6 +211,14 @@ process_rmap_data(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return;
+
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, compute_ag_refcounts, i, NULL);
+	destroy_work_queue(&wq);
 }
 
 void
@@ -349,7 +372,9 @@ phase4(xfs_mount_t *mp)
 
 	/*
 	 * Process all the reverse-mapping data that we collected.  This
-	 * involves checking the rmap data against the btree.
+	 * involves checking the rmap data against the btree, computing
+	 * reference counts based on the rmap data, and checking the counts
+	 * against the refcount btree.
 	 */
 	process_rmap_data(mp);
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 5d49eef..677de14 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -40,6 +40,7 @@ struct xfs_ag_rmap {
 	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
 	int		ar_flcount;		/* agfl entries from leftover */
 						/* agbt allocations */
+	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -83,7 +84,8 @@ bool
 needs_rmap_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_sb_version_hasrmapbt(&mp->m_sb);
+	return xfs_sb_version_hasreflink(&mp->m_sb) ||
+	       xfs_sb_version_hasrmapbt(&mp->m_sb);
 }
 
 /**
@@ -116,6 +118,11 @@ _("Insufficient memory while allocating reverse mapping slabs."));
 		if (error)
 			do_error(
 _("Insufficient memory while allocating raw metadata reverse mapping slabs."));
+		error = init_slab(&ag_rmaps[i].ar_refcount_items,
+				  sizeof(struct xfs_refcount_irec));
+		if (error)
+			do_error(
+_("Insufficient memory while allocating refcount item slabs."));
 	}
 }
 
@@ -136,6 +143,7 @@ free_rmaps(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		free_slab(&ag_rmaps[i].ar_rmaps);
 		free_slab(&ag_rmaps[i].ar_raw_rmaps);
+		free_slab(&ag_rmaps[i].ar_refcount_items);
 	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
@@ -595,6 +603,232 @@ dump_rmap(
 # define dump_rmap(m, a, r)
 #endif
 
+/*
+ * Rebuilding the Reference Count & Reverse Mapping Btrees
+ *
+ * The reference count (refcnt) and reverse mapping (rmap) btrees are rebuilt
+ * during phase 5, like all other AG btrees.  Therefore, reverse mappings must
+ * be processed into reference counts at the end of phase 4, and the rmaps must
+ * be recorded during phase 4.  There is a need to access the rmaps in physical
+ * block order, but no particular need for random access, so the slab.c code
+ * provides a big logical array (consisting of smaller slabs) and some inorder
+ * iterator functions.
+ *
+ * Once we've recorded all the reverse mappings, we're ready to translate the
+ * rmaps into refcount entries.  Imagine the rmap entries as rectangles
+ * representing extents of physical blocks, and that the rectangles can be laid
+ * down to allow them to overlap each other; then we know that we must emit
+ * a refcnt btree entry wherever the amount of overlap changes, i.e. the
+ * emission stimulus is level-triggered:
+ *
+ *                 -    ---
+ *       --      ----- ----   ---        ------
+ * --   ----     ----------- ----     ---------
+ * -------------------------------- -----------
+ * ^ ^  ^^ ^^    ^ ^^ ^^^  ^^^^  ^ ^^ ^  ^     ^
+ * 2 1  23 21    3 43 234  2123  1 01 2  3     0
+ *
+ * For our purposes, a rmap is a tuple (startblock, len, fileoff, owner).
+ *
+ * Note that in the actual refcnt btree we don't store the refcount < 2 cases
+ * because the bnobt tells us which blocks are free; single-use blocks aren't
+ * recorded in the bnobt or the refcntbt.  If the rmapbt supports storing
+ * multiple entries covering a given block we could theoretically dispense with
+ * the refcntbt and simply count rmaps, but that's inefficient in the (hot)
+ * write path, so we'll take the cost of the extra tree to save time.  Also
+ * there's no guarantee that rmap will be enabled.
+ *
+ * Given an array of rmaps sorted by physical block number, a starting physical
+ * block (sp), a bag to hold rmaps that cover sp, and the next physical
+ * block where the level changes (np), we can reconstruct the refcount
+ * btree as follows:
+ *
+ * While there are still unprocessed rmaps in the array,
+ *  - Set sp to the physical block (pblk) of the next unprocessed rmap.
+ *  - Add to the bag all rmaps in the array where startblock == sp.
+ *  - Set np to the physical block where the bag size will change.
+ *    This is the minimum of (the pblk of the next unprocessed rmap) and
+ *    (startblock + len of each rmap in the bag).
+ *  - Record the bag size as old_bag_size.
+ *
+ *  - While the bag isn't empty,
+ *     - Remove from the bag all rmaps where startblock + len == np.
+ *     - Add to the bag all rmaps in the array where startblock == np.
+ *     - If the bag size isn't old_bag_size, store the refcount entry
+ *       (sp, np - sp, bag_size) in the refcnt btree.
+ *     - If the bag is empty, break out of the inner loop.
+ *     - Set old_bag_size to the bag size
+ *     - Set sp = np.
+ *     - Set np to the physical block where the bag size will change.
+ *       This is the minimum of (the pblk of the next unprocessed rmap) and
+ *       (startblock + len of each rmap in the bag).
+ *
+ * An implementation detail is that because this processing happens during
+ * phase 4, the refcount entries are stored in an array so that phase 5 can
+ * load them into the refcount btree.  The rmaps can be loaded directly into
+ * the rmap btree during phase 5 as well.
+ */
+
+/*
+ * Emit a refcount object for refcntbt reconstruction during phase 5.
+ */
+#define REFCOUNT_CLAMP(nr)	((nr) > MAXREFCOUNT ? MAXREFCOUNT : (nr))
+static void
+refcount_emit(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	size_t			nr_rmaps)
+{
+	struct xfs_refcount_irec	rlrec;
+	int			error;
+	struct xfs_slab		*rlslab;
+
+	rlslab = ag_rmaps[agno].ar_refcount_items;
+	ASSERT(nr_rmaps > 0);
+
+	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
+		agno, agbno, len, nr_rmaps);
+	rlrec.rc_startblock = agbno;
+	rlrec.rc_blockcount = len;
+	rlrec.rc_refcount = REFCOUNT_CLAMP(nr_rmaps);
+	error = slab_add(rlslab, &rlrec);
+	if (error)
+		do_error(
+_("Insufficient memory while recreating refcount tree."));
+}
+#undef REFCOUNT_CLAMP
+
+/**
+ * compute_refcounts() - Transform a pile of physical block mapping
+ *			 observations into refcount data for eventual
+ *			 rebuilding of the btrees.
+ *
+ * @mp: XFS mount object.
+ * @agno: AG number.
+ */
+#define RMAP_END(r)	((r)->rm_startblock + XFS_RMAP_LEN((r)->rm_blockcount))
+int
+compute_refcounts(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_bag		*stack_top = NULL;
+	struct xfs_slab		*rmaps;
+	struct xfs_slab_cursor	*rmaps_cur;
+	struct xfs_rmap_irec	*array_cur;
+	struct xfs_rmap_irec	*rmap;
+	xfs_agblock_t		sbno;	/* first bno of this rmap set */
+	xfs_agblock_t		cbno;	/* first bno of this refcount set */
+	xfs_agblock_t		nbno;	/* next bno where rmap set changes */
+	size_t			n, idx;
+	size_t			old_stack_nr;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	rmaps = ag_rmaps[agno].ar_rmaps;
+
+	error = init_slab_cursor(rmaps, rmap_compare, &rmaps_cur);
+	if (error)
+		return error;
+
+	error = init_bag(&stack_top);
+	if (error)
+		goto err;
+
+	/* While there are rmaps to be processed... */
+	n = 0;
+	while (n < slab_count(rmaps)) {
+		array_cur = peek_slab_cursor(rmaps_cur);
+		sbno = cbno = array_cur->rm_startblock;
+		/* Push all rmaps with pblk == sbno onto the stack */
+		for (;
+		     array_cur && array_cur->rm_startblock == sbno;
+		     array_cur = peek_slab_cursor(rmaps_cur)) {
+			advance_slab_cursor(rmaps_cur); n++;
+			dump_rmap("push0", agno, array_cur);
+			error = bag_add(stack_top, array_cur);
+			if (error)
+				goto err;
+		}
+
+		/* Set nbno to the bno of the next refcount change */
+		if (n < slab_count(rmaps))
+			nbno = array_cur->rm_startblock;
+		else
+			nbno = NULLAGBLOCK;
+		foreach_bag_ptr(stack_top, idx, rmap) {
+			nbno = min(nbno, RMAP_END(rmap));
+		}
+
+		/* Emit reverse mappings, if needed */
+		ASSERT(nbno > sbno);
+		old_stack_nr = bag_count(stack_top);
+
+		/* While stack isn't empty... */
+		while (bag_count(stack_top)) {
+			/* Pop all rmaps that end at nbno */
+			foreach_bag_ptr_reverse(stack_top, idx, rmap) {
+				if (RMAP_END(rmap) != nbno)
+					continue;
+				dump_rmap("pop", agno, rmap);
+				error = bag_remove(stack_top, idx);
+				if (error)
+					goto err;
+			}
+
+			/* Push array items that start at nbno */
+			for (;
+			     array_cur && array_cur->rm_startblock == nbno;
+			     array_cur = peek_slab_cursor(rmaps_cur)) {
+				advance_slab_cursor(rmaps_cur); n++;
+				dump_rmap("push1", agno, array_cur);
+				error = bag_add(stack_top, array_cur);
+				if (error)
+					goto err;
+			}
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (bag_count(stack_top) != old_stack_nr) {
+				if (old_stack_nr > 1) {
+					refcount_emit(mp, agno, cbno,
+						      nbno - cbno,
+						      old_stack_nr);
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (bag_count(stack_top) == 0)
+				break;
+			old_stack_nr = bag_count(stack_top);
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			if (n < slab_count(rmaps))
+				nbno = array_cur->rm_startblock;
+			else
+				nbno = NULLAGBLOCK;
+			foreach_bag_ptr(stack_top, idx, rmap) {
+				nbno = min(nbno, RMAP_END(rmap));
+			}
+
+			/* Emit reverse mappings, if needed */
+			ASSERT(nbno > sbno);
+		}
+	}
+err:
+	free_bag(&stack_top);
+	free_slab_cursor(&rmaps_cur);
+
+	return error;
+}
+#undef RMAP_END
+
 /**
  * rmap_record_count() -- Return the number of rmap objects for an AG.
  *
diff --git a/repair/rmap.h b/repair/rmap.h
index 0b4e73b..13df5d6 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -39,6 +39,8 @@ extern int init_rmap_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void rmap_avoid_check(void);
 extern int check_rmaps(struct xfs_mount *, xfs_agnumber_t);
 
+extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
+
 extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
 extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
