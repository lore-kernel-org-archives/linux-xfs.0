Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5197D7CC7
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:25:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23A138F8039
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:25:15 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HRL6tUnrDlw1J2iH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:25:12 -0700 (PDT)
Subject: [PATCH 7/7] xfs_repair: fix naming problems in repair/rmap.c
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:25:08 -0700
Message-ID: <147200550894.15538.9346863758990497173.stgit@birch.djwong.org>
In-Reply-To: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
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

The utility functions in repair/rmap.c should all have a prefix
of 'rmap_' so that they are easily identifiable.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c     |    2 +
 repair/phase4.c     |   12 ++++----
 repair/phase5.c     |    6 ++--
 repair/rmap.c       |   76 ++++++++++++++++++++++++++-------------------------
 repair/rmap.h       |   26 +++++++++--------
 repair/scan.c       |    4 +--
 repair/xfs_repair.c |    4 +--
 7 files changed, 65 insertions(+), 65 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index db55860..512a668 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -782,7 +782,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 			}
 		}
 		if (collect_rmaps) { /* && !check_dups */
-			error = add_rmap(mp, ino, whichfork, &irec);
+			error = rmap_add_rec(mp, ino, whichfork, &irec);
 			if (error)
 				do_error(
 _("couldn't add reverse mapping\n")
diff --git a/repair/phase4.c b/repair/phase4.c
index 3be3786..9da1bb1 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -159,7 +159,7 @@ process_ags(
 
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		error = finish_collecting_fork_rmaps(mp, i);
+		error = rmap_finish_collecting_fork_recs(mp, i);
 		if (error)
 			do_error(
 _("unable to finish adding attr/data fork reverse-mapping data for AG %u.\n"),
@@ -175,17 +175,17 @@ check_rmap_btrees(
 {
 	int		error;
 
-	error = add_fixed_ag_rmap_data(wq->mp, agno);
+	error = rmap_add_fixed_ag_rec(wq->mp, agno);
 	if (error)
 		do_error(
 _("unable to add AG %u metadata reverse-mapping data.\n"), agno);
 
-	error = fold_raw_rmaps(wq->mp, agno);
+	error = rmap_fold_raw_recs(wq->mp, agno);
 	if (error)
 		do_error(
 _("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
 
-	error = check_rmaps(wq->mp, agno);
+	error = rmaps_verify_btree(wq->mp, agno);
 	if (error)
 		do_error(
 _("%s while checking reverse-mappings"),
@@ -199,7 +199,7 @@ process_rmap_data(
 	struct work_queue	wq;
 	xfs_agnumber_t		i;
 
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return;
 
 	create_work_queue(&wq, mp, libxfs_nproc());
@@ -223,7 +223,7 @@ phase4(xfs_mount_t *mp)
 	int			ag_hdr_block;
 	int			bstate;
 
-	if (needs_rmap_work(mp))
+	if (rmap_needs_work(mp))
 		collect_rmaps = true;
 	ag_hdr_block = howmany(ag_hdr_len, mp->m_sb.sb_blocksize);
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 93b1f75..4c7655c 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -251,7 +251,7 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 			blocks_allocated++;
 		}
 
-		error = add_ag_rmap(mp, agno, ext_ptr->ex_startblock, u,
+		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, u,
 				curs->owner);
 		if (error)
 			do_error(_("could not set up btree rmaps: %s\n"),
@@ -1615,7 +1615,7 @@ build_rmap_tree(
 	 * pointers for the parent.  that can recurse up to the root
 	 * if required.  set the sibling pointers for leaf level here.
 	 */
-	error = init_rmap_cursor(agno, &rmap_cur);
+	error = rmap_init_cursor(agno, &rmap_cur);
 	if (error)
 		do_error(
 _("Insufficient memory to construct reverse-map cursor."));
@@ -2137,7 +2137,7 @@ phase5_func(
 		/*
 		 * Put the per-AG btree rmap data into the rmapbt
 		 */
-		error = store_ag_btree_rmap_data(mp, agno);
+		error = rmap_store_ag_btree_rec(mp, agno);
 		if (error)
 			do_error(
 _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
diff --git a/repair/rmap.c b/repair/rmap.c
index 43b821d..a493388 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -85,7 +85,7 @@ rmap_compare(
  * mapping trees.
  */
 bool
-needs_rmap_work(
+rmap_needs_work(
 	struct xfs_mount	*mp)
 {
 	return xfs_sb_version_hasrmapbt(&mp->m_sb);
@@ -95,13 +95,13 @@ needs_rmap_work(
  * Initialize per-AG reverse map data.
  */
 void
-init_rmaps(
+rmaps_init(
 	struct xfs_mount	*mp)
 {
 	xfs_agnumber_t		i;
 	int			error;
 
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return;
 
 	ag_rmaps = calloc(mp->m_sb.sb_agcount, sizeof(struct xfs_ag_rmap));
@@ -127,12 +127,12 @@ _("Insufficient memory while allocating raw metadata reverse mapping slabs."));
  * Free the per-AG reverse-mapping data.
  */
 void
-free_rmaps(
+rmaps_free(
 	struct xfs_mount	*mp)
 {
 	xfs_agnumber_t		i;
 
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return;
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
@@ -147,7 +147,7 @@ free_rmaps(
  * Decide if two reverse-mapping records can be merged.
  */
 bool
-mergeable_rmaps(
+rmaps_are_mergeable(
 	struct xfs_rmap_irec	*r1,
 	struct xfs_rmap_irec	*r2)
 {
@@ -173,7 +173,7 @@ mergeable_rmaps(
  * fork for later btree reconstruction.
  */
 int
-add_rmap(
+rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	int			whichfork,
@@ -185,7 +185,7 @@ add_rmap(
 	struct xfs_rmap_irec	*last_rmap;
 	int			error = 0;
 
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return 0;
 
 	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
@@ -208,7 +208,7 @@ add_rmap(
 	last_rmap = &ag_rmaps[agno].ar_last_rmap;
 	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
 		*last_rmap = rmap;
-	else if (mergeable_rmaps(last_rmap, &rmap))
+	else if (rmaps_are_mergeable(last_rmap, &rmap))
 		last_rmap->rm_blockcount += rmap.rm_blockcount;
 	else {
 		error = slab_add(ag_rmaps[agno].ar_rmaps, last_rmap);
@@ -222,11 +222,11 @@ add_rmap(
 
 /* Finish collecting inode data/attr fork rmaps. */
 int
-finish_collecting_fork_rmaps(
+rmap_finish_collecting_fork_recs(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	if (!needs_rmap_work(mp) ||
+	if (!rmap_needs_work(mp) ||
 	    ag_rmaps[agno].ar_last_rmap.rm_owner == XFS_RMAP_OWN_UNKNOWN)
 		return 0;
 	return slab_add(ag_rmaps[agno].ar_rmaps, &ag_rmaps[agno].ar_last_rmap);
@@ -234,7 +234,7 @@ finish_collecting_fork_rmaps(
 
 /* add a raw rmap; these will be merged later */
 static int
-__add_raw_rmap(
+__rmap_add_raw_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
@@ -262,7 +262,7 @@ __add_raw_rmap(
  * Add a reverse mapping for an inode fork's block mapping btree block.
  */
 int
-add_bmbt_rmap(
+rmap_add_bmbt_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	int			whichfork,
@@ -271,7 +271,7 @@ add_bmbt_rmap(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return 0;
 
 	agno = XFS_FSB_TO_AGNO(mp, fsbno);
@@ -280,7 +280,7 @@ add_bmbt_rmap(
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(agbno + 1 <= mp->m_sb.sb_agblocks);
 
-	return __add_raw_rmap(mp, agno, agbno, 1, ino,
+	return __rmap_add_raw_rec(mp, agno, agbno, 1, ino,
 			whichfork == XFS_ATTR_FORK, true);
 }
 
@@ -288,28 +288,28 @@ add_bmbt_rmap(
  * Add a reverse mapping for a per-AG fixed metadata extent.
  */
 int
-add_ag_rmap(
+rmap_add_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return 0;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 
-	return __add_raw_rmap(mp, agno, agbno, len, owner, false, false);
+	return __rmap_add_raw_rec(mp, agno, agbno, len, owner, false, false);
 }
 
 /*
  * Merge adjacent raw rmaps and add them to the main rmap list.
  */
 int
-fold_raw_rmaps(
+rmap_fold_raw_recs(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
@@ -330,7 +330,7 @@ fold_raw_rmaps(
 	prev = pop_slab_cursor(cur);
 	rec = pop_slab_cursor(cur);
 	while (prev && rec) {
-		if (mergeable_rmaps(prev, rec)) {
+		if (rmaps_are_mergeable(prev, rec)) {
 			prev->rm_blockcount += rec->rm_blockcount;
 			rec = pop_slab_cursor(cur);
 			continue;
@@ -395,7 +395,7 @@ popcnt(
  * sb/agi/agf/agfl headers, inode chunks, and the log.
  */
 int
-add_fixed_ag_rmap_data(
+rmap_add_fixed_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
@@ -407,11 +407,11 @@ add_fixed_ag_rmap_data(
 	int			startidx;
 	int			nr;
 
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return 0;
 
 	/* sb/agi/agf/agfl headers */
-	error = add_ag_rmap(mp, agno, 0, XFS_BNO_BLOCK(mp),
+	error = rmap_add_ag_rec(mp, agno, 0, XFS_BNO_BLOCK(mp),
 			XFS_RMAP_OWN_FS);
 	if (error)
 		goto out;
@@ -432,7 +432,7 @@ add_fixed_ag_rmap_data(
 		agino = ino_rec->ino_startnum + startidx;
 		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 		if (XFS_AGINO_TO_OFFSET(mp, agino) == 0) {
-			error = add_ag_rmap(mp, agno, agbno, nr,
+			error = rmap_add_ag_rec(mp, agno, agbno, nr,
 					XFS_RMAP_OWN_INODES);
 			if (error)
 				goto out;
@@ -443,7 +443,7 @@ add_fixed_ag_rmap_data(
 	fsbno = mp->m_sb.sb_logstart;
 	if (fsbno && XFS_FSB_TO_AGNO(mp, fsbno) == agno) {
 		agbno = XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart);
-		error = add_ag_rmap(mp, agno, agbno, mp->m_sb.sb_logblocks,
+		error = rmap_add_ag_rec(mp, agno, agbno, mp->m_sb.sb_logblocks,
 				XFS_RMAP_OWN_LOG);
 		if (error)
 			goto out;
@@ -473,7 +473,7 @@ out:
  * the rmapbt, after which it is fully regenerated.
  */
 int
-store_ag_btree_rmap_data(
+rmap_store_ag_btree_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
@@ -509,7 +509,7 @@ store_ag_btree_rmap_data(
 	agfl_bno += ag_rmaps[agno].ar_flcount;
 	b = agfl_bno;
 	while (*b != NULLAGBLOCK && b - agfl_bno <= XFS_AGFL_SIZE(mp)) {
-		error = add_ag_rmap(mp, agno, be32_to_cpu(*b), 1,
+		error = rmap_add_ag_rec(mp, agno, be32_to_cpu(*b), 1,
 				XFS_RMAP_OWN_AG);
 		if (error)
 			goto err;
@@ -519,7 +519,7 @@ store_ag_btree_rmap_data(
 	agflbp = NULL;
 
 	/* Merge all the raw rmaps into the main list */
-	error = fold_raw_rmaps(mp, agno);
+	error = rmap_fold_raw_recs(mp, agno);
 	if (error)
 		goto err;
 
@@ -572,7 +572,7 @@ err:
 
 #ifdef RMAP_DEBUG
 static void
-dump_rmap(
+rmap_dump(
 	const char		*msg,
 	xfs_agnumber_t		agno,
 	struct xfs_rmap_irec	*rmap)
@@ -587,7 +587,7 @@ dump_rmap(
 		(unsigned int)rmap->rm_flags);
 }
 #else
-# define dump_rmap(m, a, r)
+# define rmap_dump(m, a, r)
 #endif
 
 /*
@@ -605,7 +605,7 @@ rmap_record_count(
  * Return a slab cursor that will return rmap objects in order.
  */
 int
-init_rmap_cursor(
+rmap_init_cursor(
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
@@ -623,7 +623,7 @@ rmap_avoid_check(void)
 
 /* Look for an rmap in the rmapbt that matches a given rmap. */
 static int
-lookup_rmap(
+rmap_lookup(
 	struct xfs_btree_cur	*bt_cur,
 	struct xfs_rmap_irec	*rm_rec,
 	struct xfs_rmap_irec	*tmp,
@@ -647,7 +647,7 @@ lookup_rmap(
 #define NEXTP(x)	((x)->rm_startblock + (x)->rm_blockcount)
 #define NEXTL(x)	((x)->rm_offset + (x)->rm_blockcount)
 static bool
-is_good_rmap(
+rmap_is_good(
 	struct xfs_rmap_irec	*observed,
 	struct xfs_rmap_irec	*btree)
 {
@@ -685,7 +685,7 @@ is_good_rmap(
  * Compare the observed reverse mappings against what's in the ag btree.
  */
 int
-check_rmaps(
+rmaps_verify_btree(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
@@ -707,7 +707,7 @@ check_rmaps(
 	}
 
 	/* Create cursors to refcount structures */
-	error = init_rmap_cursor(agno, &rm_cur);
+	error = rmap_init_cursor(agno, &rm_cur);
 	if (error)
 		return error;
 
@@ -728,7 +728,7 @@ check_rmaps(
 
 	rm_rec = pop_slab_cursor(rm_cur);
 	while (rm_rec) {
-		error = lookup_rmap(bt_cur, rm_rec, &tmp, &have);
+		error = rmap_lookup(bt_cur, rm_rec, &tmp, &have);
 		if (error)
 			goto err;
 		if (!have) {
@@ -749,7 +749,7 @@ _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
 		}
 
 		/* Compare each refcount observation against the btree's */
-		if (!is_good_rmap(rm_rec, &tmp)) {
+		if (!rmap_is_good(rm_rec, &tmp)) {
 			do_warn(
 _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 %"PRIu64"; should be (%u/%u) %slen %u owner %"PRId64" %s%soff %"PRIu64"\n"),
@@ -918,7 +918,7 @@ rmap_store_agflcount(
 	xfs_agnumber_t		agno,
 	int			count)
 {
-	if (!needs_rmap_work(mp))
+	if (!rmap_needs_work(mp))
 		return;
 
 	ag_rmaps[agno].ar_flcount = count;
diff --git a/repair/rmap.h b/repair/rmap.h
index 69215e8..7106dfc 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -22,27 +22,27 @@
 
 extern bool collect_rmaps;
 
-extern bool needs_rmap_work(struct xfs_mount *);
+extern bool rmap_needs_work(struct xfs_mount *);
 
-extern void init_rmaps(struct xfs_mount *);
-extern void free_rmaps(struct xfs_mount *);
+extern void rmaps_init(struct xfs_mount *);
+extern void rmaps_free(struct xfs_mount *);
 
-extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
-extern int finish_collecting_fork_rmaps(struct xfs_mount *mp,
+extern int rmap_add_rec(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
+extern int rmap_finish_collecting_fork_recs(struct xfs_mount *mp,
 		xfs_agnumber_t agno);
-extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
+extern int rmap_add_ag_rec(struct xfs_mount *, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
-extern int add_bmbt_rmap(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
-extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
-extern bool mergeable_rmaps(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
+extern int rmap_add_bmbt_rec(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
+extern int rmap_fold_raw_recs(struct xfs_mount *mp, xfs_agnumber_t agno);
+extern bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
-extern int add_fixed_ag_rmap_data(struct xfs_mount *, xfs_agnumber_t);
-extern int store_ag_btree_rmap_data(struct xfs_mount *, xfs_agnumber_t);
+extern int rmap_add_fixed_ag_rec(struct xfs_mount *, xfs_agnumber_t);
+extern int rmap_store_ag_btree_rec(struct xfs_mount *, xfs_agnumber_t);
 
 extern size_t rmap_record_count(struct xfs_mount *, xfs_agnumber_t);
-extern int init_rmap_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
+extern int rmap_init_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void rmap_avoid_check(void);
-extern int check_rmaps(struct xfs_mount *, xfs_agnumber_t);
+extern int rmaps_verify_btree(struct xfs_mount *, xfs_agnumber_t);
 
 extern __int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
 		struct xfs_rmap_irec *kp2);
diff --git a/repair/scan.c b/repair/scan.c
index 253e3de..8fc4592 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -383,7 +383,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 
 	/* Record BMBT blocks in the reverse-mapping data. */
 	if (check_dups && collect_rmaps) {
-		error = add_bmbt_rmap(mp, ino, whichfork, bno);
+		error = rmap_add_bmbt_rec(mp, ino, whichfork, bno);
 		if (error)
 			do_error(
 _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
@@ -1040,7 +1040,7 @@ advance:
 			}
 
 			/* Is this mergeable with the previous record? */
-			if (mergeable_rmaps(&rmap_priv->last_rec, &key)) {
+			if (rmaps_are_mergeable(&rmap_priv->last_rec, &key)) {
 				do_warn(
 	_("record %d in block (%u/%u) of %s tree should be merged with previous record\n"),
 					i, agno, bno, name);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3040c46..dc38ece 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -900,7 +900,7 @@ main(int argc, char **argv)
 	init_bmaps(mp);
 	incore_ino_init(mp);
 	incore_ext_init(mp);
-	init_rmaps(mp);
+	rmaps_init(mp);
 
 	/* initialize random globals now that we know the fs geometry */
 	inodes_per_block = mp->m_sb.sb_inopblock;
@@ -934,7 +934,7 @@ main(int argc, char **argv)
 	/*
 	 * Done with the block usage maps, toss them...
 	 */
-	free_rmaps(mp);
+	rmaps_free(mp);
 	free_bmaps(mp);
 
 	if (!bad_ino_btree)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
