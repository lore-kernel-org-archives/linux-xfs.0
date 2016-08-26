Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D0BF8481
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95BEDAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EzP2cMqkCG3QSRzc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:19 -0700 (PDT)
Subject: [PATCH 24/29] xfs_repair: extend ag_rmap[] for realtime mapping
	collection
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:14 -0700
Message-ID: <147216967425.7022.18324030801464543217.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Extend the ag_rmap[] infrastructure to have an extra group to store
realtime extent reverse mappings.  Since we're pretending that the
realtime device is AG "-1", we can just play some pointer arithmetic
to make this work out.  In the next patch we'll actually use this
data for something.  Extend the ag_locks[] array in a similar manner.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    2 +
 repair/incore.c |    9 ++++-
 repair/phase4.c |   10 +++--
 repair/rmap.c   |  105 ++++++++++++++++++++++++++++++++++++-------------------
 repair/rmap.h   |   10 +++++
 5 files changed, 91 insertions(+), 45 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 6718cd2..f768cdf 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -801,7 +801,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 			}
 		}
 		if (collect_rmaps) { /* && !check_dups */
-			error = rmap_add_rec(mp, ino, whichfork, &irec);
+			error = rmap_add_rec(mp, ino, whichfork, &irec, false);
 			if (error)
 				do_error(
 _("couldn't add reverse mapping\n")
diff --git a/repair/incore.c b/repair/incore.c
index cb57316..fbb05ad 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -294,14 +294,17 @@ init_bmaps(xfs_mount_t *mp)
 	if (!ag_bmap)
 		do_error(_("couldn't allocate block map btree roots\n"));
 
-	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(struct aglock));
+	ag_locks = calloc(mp->m_sb.sb_agcount + 1, sizeof(struct aglock));
 	if (!ag_locks)
 		do_error(_("couldn't allocate block map locks\n"));
 
+	/* One ag_lock per AG, and one more for the realtime device. */
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
 		btree_init(&ag_bmap[i]);
 		pthread_mutex_init(&ag_locks[i].lock, NULL);
 	}
+	pthread_mutex_init(&ag_locks[mp->m_sb.sb_agcount].lock, NULL);
+	ag_locks++;
 
 	init_rt_bmap(mp);
 	reset_bmaps(mp);
@@ -312,6 +315,10 @@ free_bmaps(xfs_mount_t *mp)
 {
 	xfs_agnumber_t i;
 
+	ag_locks--;
+	free(ag_locks);
+	ag_locks = NULL;
+
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		btree_destroy(ag_bmap[i]);
 	free(ag_bmap);
diff --git a/repair/phase4.c b/repair/phase4.c
index 395d373..512f774 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -158,7 +158,7 @@ process_ags(
 	int			error;
 
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+	for_each_rmap_group(mp, i) {
 		error = rmap_finish_collecting_fork_recs(mp, i);
 		if (error)
 			do_error(
@@ -248,7 +248,7 @@ process_rmap_data(
 		return;
 
 	create_work_queue(&wq, mp, libxfs_nproc());
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+	for_each_rmap_group(mp, i)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
 
@@ -256,17 +256,17 @@ process_rmap_data(
 		return;
 
 	create_work_queue(&wq, mp, libxfs_nproc());
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+	for_each_ag(mp, i)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
 	destroy_work_queue(&wq);
 
 	create_work_queue(&wq, mp, libxfs_nproc());
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+	for_each_ag(mp, i)
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 	destroy_work_queue(&wq);
 
 	create_work_queue(&wq, mp, libxfs_nproc());
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+	for_each_ag(mp, i)
 		queue_work(&wq, check_refcount_btrees, i, NULL);
 	destroy_work_queue(&wq);
 }
diff --git a/repair/rmap.c b/repair/rmap.c
index 3b3a195..37da251 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -45,6 +45,7 @@ struct xfs_ag_rmap {
 	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
 };
 
+/* One ag_rmap per AG, and one more for the realtime device. */
 static struct xfs_ag_rmap *ag_rmaps;
 static bool rmapbt_suspect;
 static bool refcbt_suspect;
@@ -83,6 +84,17 @@ rmap_compare(
 }
 
 /*
+ * Return the ag_rmap for a given AG.
+ * Note that NULLAGNUMBER (-1) is the realtime device.
+ */
+static struct xfs_ag_rmap*
+rmap_for_ag(
+	xfs_agnumber_t		agno)
+{
+	return &ag_rmaps[(signed)agno];
+}
+
+/*
  * Returns true if we must reconstruct either the reference count or reverse
  * mapping trees.
  */
@@ -107,11 +119,12 @@ rmaps_init(
 	if (!rmap_needs_work(mp))
 		return;
 
-	ag_rmaps = calloc(mp->m_sb.sb_agcount, sizeof(struct xfs_ag_rmap));
+	/* One ag_rmap per AG, and one more for the realtime device. */
+	ag_rmaps = calloc(mp->m_sb.sb_agcount + 1, sizeof(struct xfs_ag_rmap));
 	if (!ag_rmaps)
 		do_error(_("couldn't allocate per-AG reverse map roots\n"));
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+	for (i = 0; i < mp->m_sb.sb_agcount + 1; i++) {
 		error = init_slab(&ag_rmaps[i].ar_rmaps,
 				sizeof(struct xfs_rmap_irec));
 		if (error)
@@ -129,6 +142,7 @@ _("Insufficient memory while allocating raw metadata reverse mapping slabs."));
 			do_error(
 _("Insufficient memory while allocating refcount item slabs."));
 	}
+	ag_rmaps++;
 }
 
 /*
@@ -143,7 +157,8 @@ rmaps_free(
 	if (!rmap_needs_work(mp))
 		return;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+	ag_rmaps--;
+	for (i = 0; i < mp->m_sb.sb_agcount + 1; i++) {
 		free_slab(&ag_rmaps[i].ar_rmaps);
 		free_slab(&ag_rmaps[i].ar_raw_rmaps);
 		free_slab(&ag_rmaps[i].ar_refcount_items);
@@ -186,22 +201,31 @@ rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	int			whichfork,
-	struct xfs_bmbt_irec	*irec)
+	struct xfs_bmbt_irec	*irec,
+	bool			realtime)
 {
+	struct xfs_ag_rmap	*ag_rmap;
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
+	xfs_fsblock_t		agbno;
 	struct xfs_rmap_irec	*last_rmap;
 	int			error = 0;
 
 	if (!rmap_needs_work(mp))
 		return 0;
 
-	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_agblocks);
+	if (realtime) {
+		agno = NULLAGNUMBER;
+		agbno = irec->br_startblock;
+		ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_rblocks);
+	} else {
+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+		agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+		ASSERT(agno != NULLAGNUMBER);
+		ASSERT(agno < mp->m_sb.sb_agcount);
+		ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_agblocks);
+	}
+	ag_rmap = rmap_for_ag(agno);
 	ASSERT(ino != NULLFSINO);
 	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
 
@@ -214,13 +238,13 @@ rmap_add_rec(
 	rmap.rm_blockcount = irec->br_blockcount;
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
-	last_rmap = &ag_rmaps[agno].ar_last_rmap;
+	last_rmap = &ag_rmap->ar_last_rmap;
 	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
 		*last_rmap = rmap;
 	else if (rmaps_are_mergeable(last_rmap, &rmap))
 		last_rmap->rm_blockcount += rmap.rm_blockcount;
 	else {
-		error = slab_add(ag_rmaps[agno].ar_rmaps, last_rmap);
+		error = slab_add(ag_rmap->ar_rmaps, last_rmap);
 		if (error)
 			return error;
 		*last_rmap = rmap;
@@ -236,9 +260,10 @@ rmap_finish_collecting_fork_recs(
 	xfs_agnumber_t		agno)
 {
 	if (!rmap_needs_work(mp) ||
-	    ag_rmaps[agno].ar_last_rmap.rm_owner == XFS_RMAP_OWN_UNKNOWN)
+	    rmap_for_ag(agno)->ar_last_rmap.rm_owner == XFS_RMAP_OWN_UNKNOWN)
 		return 0;
-	return slab_add(ag_rmaps[agno].ar_rmaps, &ag_rmaps[agno].ar_last_rmap);
+	return slab_add(rmap_for_ag(agno)->ar_rmaps,
+			&rmap_for_ag(agno)->ar_last_rmap);
 }
 
 /* add a raw rmap; these will be merged later */
@@ -264,7 +289,7 @@ __rmap_add_raw_rec(
 		rmap.rm_flags |= XFS_RMAP_BMBT_BLOCK;
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = len;
-	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
+	return slab_add(rmap_for_ag(agno)->ar_raw_rmaps, &rmap);
 }
 
 /*
@@ -322,16 +347,18 @@ rmap_fold_raw_recs(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
+	struct xfs_ag_rmap	*ag_rmap;
 	struct xfs_slab_cursor	*cur = NULL;
 	struct xfs_rmap_irec	*prev, *rec;
 	size_t			old_sz;
 	int			error = 0;
 
-	old_sz = slab_count(ag_rmaps[agno].ar_rmaps);
-	if (slab_count(ag_rmaps[agno].ar_raw_rmaps) == 0)
+	ag_rmap = rmap_for_ag(agno);
+	old_sz = slab_count(ag_rmap->ar_rmaps);
+	if (slab_count(ag_rmap->ar_raw_rmaps) == 0)
 		goto no_raw;
-	qsort_slab(ag_rmaps[agno].ar_raw_rmaps, rmap_compare);
-	error = init_slab_cursor(ag_rmaps[agno].ar_raw_rmaps, rmap_compare,
+	qsort_slab(ag_rmap->ar_raw_rmaps, rmap_compare);
+	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare,
 			&cur);
 	if (error)
 		goto err;
@@ -344,26 +371,26 @@ rmap_fold_raw_recs(
 			rec = pop_slab_cursor(cur);
 			continue;
 		}
-		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
+		error = slab_add(ag_rmap->ar_rmaps, prev);
 		if (error)
 			goto err;
 		prev = rec;
 		rec = pop_slab_cursor(cur);
 	}
 	if (prev) {
-		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
+		error = slab_add(ag_rmap->ar_rmaps, prev);
 		if (error)
 			goto err;
 	}
-	free_slab(&ag_rmaps[agno].ar_raw_rmaps);
-	error = init_slab(&ag_rmaps[agno].ar_raw_rmaps,
+	free_slab(&ag_rmap->ar_raw_rmaps);
+	error = init_slab(&ag_rmap->ar_raw_rmaps,
 			sizeof(struct xfs_rmap_irec));
 	if (error)
 		do_error(
 _("Insufficient memory while allocating raw metadata reverse mapping slabs."));
 no_raw:
 	if (old_sz)
-		qsort_slab(ag_rmaps[agno].ar_rmaps, rmap_compare);
+		qsort_slab(ag_rmap->ar_rmaps, rmap_compare);
 err:
 	free_slab_cursor(&cur);
 	return error;
@@ -419,6 +446,9 @@ rmap_add_fixed_ag_rec(
 	if (!rmap_needs_work(mp))
 		return 0;
 
+	if (agno == NULLAGNUMBER)
+		return 0;
+
 	/* sb/agi/agf/agfl headers */
 	error = rmap_add_ag_rec(mp, agno, 0, XFS_BNO_BLOCK(mp),
 			XFS_RMAP_OWN_FS);
@@ -493,6 +523,7 @@ rmap_store_ag_btree_rec(
 	struct xfs_trans	*tp;
 	struct xfs_trans_res tres = {0};
 	__be32			*agfl_bno, *b;
+	struct xfs_ag_rmap	*ag_rmap;
 	int			error = 0;
 	struct xfs_owner_info	oinfo;
 
@@ -500,9 +531,9 @@ rmap_store_ag_btree_rec(
 		return 0;
 
 	/* Release the ar_rmaps; they were put into the rmapbt during p5. */
-	free_slab(&ag_rmaps[agno].ar_rmaps);
-	error = init_slab(&ag_rmaps[agno].ar_rmaps,
-				  sizeof(struct xfs_rmap_irec));
+	ag_rmap = rmap_for_ag(agno);
+	free_slab(&ag_rmap->ar_rmaps);
+	error = init_slab(&ag_rmap->ar_rmaps, sizeof(struct xfs_rmap_irec));
 	if (error)
 		goto err;
 
@@ -515,7 +546,7 @@ rmap_store_ag_btree_rec(
 		goto err;
 
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
-	agfl_bno += ag_rmaps[agno].ar_flcount;
+	agfl_bno += ag_rmap->ar_flcount;
 	b = agfl_bno;
 	while (*b != NULLAGBLOCK && b - agfl_bno <= XFS_AGFL_SIZE(mp)) {
 		error = rmap_add_ag_rec(mp, agno, be32_to_cpu(*b), 1,
@@ -533,7 +564,7 @@ rmap_store_ag_btree_rec(
 		goto err;
 
 	/* Create cursors to refcount structures */
-	error = init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare,
+	error = init_slab_cursor(ag_rmap->ar_rmaps, rmap_compare,
 			&rm_cur);
 	if (error)
 		goto err;
@@ -714,7 +745,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = ag_rmaps[agno].ar_refcount_items;
+	rlslab = rmap_for_ag(agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -736,7 +767,7 @@ _("Insufficient memory while recreating refcount tree."));
 #define RMAP_END(r)	((r)->rm_startblock + (r)->rm_blockcount)
 int
 compute_refcounts(
-	struct xfs_mount		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
 	struct xfs_bag		*stack_top = NULL;
@@ -754,7 +785,7 @@ compute_refcounts(
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
-	rmaps = ag_rmaps[agno].ar_rmaps;
+	rmaps = rmap_for_ag(agno)->ar_rmaps;
 
 	error = init_slab_cursor(rmaps, rmap_compare, &rmaps_cur);
 	if (error)
@@ -864,7 +895,7 @@ rmap_record_count(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_rmaps);
+	return slab_count(rmap_for_ag(agno)->ar_rmaps);
 }
 
 /*
@@ -875,7 +906,7 @@ rmap_init_cursor(
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
-	return init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare, cur);
+	return init_slab_cursor(rmap_for_ag(agno)->ar_rmaps, rmap_compare, cur);
 }
 
 /*
@@ -1269,7 +1300,7 @@ refcount_record_count(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_refcount_items);
+	return slab_count(rmap_for_ag(agno)->ar_refcount_items);
 }
 
 /*
@@ -1280,7 +1311,7 @@ init_refcount_cursor(
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
-	return init_slab_cursor(ag_rmaps[agno].ar_refcount_items, NULL, cur);
+	return init_slab_cursor(rmap_for_ag(agno)->ar_refcount_items, NULL, cur);
 }
 
 /*
@@ -1461,5 +1492,5 @@ rmap_store_agflcount(
 	if (!rmap_needs_work(mp))
 		return;
 
-	ag_rmaps[agno].ar_flcount = count;
+	rmap_for_ag(agno)->ar_flcount = count;
 }
diff --git a/repair/rmap.h b/repair/rmap.h
index 752ece8..7069b6b 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -27,7 +27,8 @@ extern bool rmap_needs_work(struct xfs_mount *);
 extern void rmaps_init(struct xfs_mount *);
 extern void rmaps_free(struct xfs_mount *);
 
-extern int rmap_add_rec(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
+extern int rmap_add_rec(struct xfs_mount *, xfs_ino_t, int,
+		struct xfs_bmbt_irec *, bool realtime);
 extern int rmap_finish_collecting_fork_recs(struct xfs_mount *mp,
 		xfs_agnumber_t agno);
 extern int rmap_add_ag_rec(struct xfs_mount *, xfs_agnumber_t agno,
@@ -62,4 +63,11 @@ extern int fix_inode_reflink_flags(struct xfs_mount *, xfs_agnumber_t);
 extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
 extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 
+#define for_each_ag(mp, agno) \
+	for ((agno) = 0; (agno) < (mp)->m_sb.sb_agcount; (agno)++)
+
+#define for_each_rmap_group(mp, agno) \
+	for ((agno) = NULLAGNUMBER; (agno) == NULLAGNUMBER || \
+	(agno) < (mp)->m_sb.sb_agcount; (agno)++)
+
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
