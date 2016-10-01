Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22577 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbcJAGsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Oct 2016 02:48:15 -0400
Subject: [PATCH 2/2] xfs_repair: add freesp btree block overflow to the free
 space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 30 Sep 2016 23:48:10 -0700
Message-ID: <147530449030.24875.9675301750628540145.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If we overestimate the number of blocks needed to rebuild the free
space btrees to the point that we have more blocks than fit in the
AGFL, save those blocks and reinsert them into the free space at
the end of phase 5.  Previously, the overflow blocks would simply
be lost.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/phase5.c          |  102 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 76 insertions(+), 27 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 626c79f..b30228d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -136,5 +136,6 @@
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
 #define xfs_dinode_good_version		libxfs_dinode_good_version
+#define xfs_free_extent			libxfs_free_extent
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index 28aaefe..f7c86d8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1708,15 +1708,17 @@ build_agf_agfl(
 	struct bt_status	*bcnt_bt,
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
-	struct bt_status	*rmap_bt)
+	struct bt_status	*rmap_bt,
+	struct xfs_slab		*lost_fsb)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
 	int			i;
-	int			j;
 	struct xfs_agfl		*agfl;
 	struct xfs_agf		*agf;
+	xfs_fsblock_t		fsb;
 	__be32			*freelist;
+	int			error;
 
 	agf_buf = libxfs_getbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
@@ -1811,7 +1813,7 @@ build_agf_agfl(
 		/*
 		 * yes, now grab as many blocks as we can
 		 */
-		i = j = 0;
+		i = 0;
 		while (bno_bt->num_free_blocks > 0 && i < XFS_AGFL_SIZE(mp))  {
 			freelist[i] = cpu_to_be32(
 					get_next_blockaddr(agno, 0, bno_bt));
@@ -1826,24 +1828,21 @@ build_agf_agfl(
 		/*
 		 * now throw the rest of the blocks away and complain
 		 */
-		while (bno_bt->num_free_blocks > 0)  {
-			(void) get_next_blockaddr(agno, 0, bno_bt);
-			j++;
-		}
-		while (bcnt_bt->num_free_blocks > 0)  {
-			(void) get_next_blockaddr(agno, 0, bcnt_bt);
-			j++;
+		while (bno_bt->num_free_blocks > 0) {
+			fsb = XFS_AGB_TO_FSB(mp, agno,
+					get_next_blockaddr(agno, 0, bno_bt));
+			error = slab_add(lost_fsb, &fsb);
+			if (error)
+				do_error(
+_("Insufficient memory saving lost blocks.\n"));
 		}
-
-		if (j > 0)  {
-			if (j == lostblocks)
-				do_warn(_("lost %d blocks in ag %u\n"),
-					j, agno);
-			else
-				do_warn(_("thought we were going to lose %d "
-					  "blocks in ag %u, actually lost "
-					  "%d\n"),
-					lostblocks, j, agno);
+		while (bcnt_bt->num_free_blocks > 0) {
+			fsb = XFS_AGB_TO_FSB(mp, agno,
+					get_next_blockaddr(agno, 0, bcnt_bt));
+			error = slab_add(lost_fsb, &fsb);
+			if (error)
+				do_error(
+_("Insufficient memory saving lost blocks.\n"));
 		}
 
 		agf->agf_flfirst = 0;
@@ -1927,7 +1926,8 @@ keep_fsinos(xfs_mount_t *mp)
 static void
 phase5_func(
 	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
+	xfs_agnumber_t	agno,
+	struct xfs_slab	*lost_fsb)
 {
 	__uint64_t	num_inos;
 	__uint64_t	num_free_inos;
@@ -2045,11 +2045,8 @@ phase5_func(
 				? extra_blocks - XFS_AGFL_SIZE(mp)
 				: 0;
 
-		if (extra_blocks > 0)  {
-			do_warn(_("lost %d blocks in agno %d, sorry.\n"),
-				extra_blocks, agno);
+		if (extra_blocks > 0)
 			sb_fdblocks_ag[agno] -= extra_blocks;
-		}
 
 		bcnt_btree_curs = bno_btree_curs;
 
@@ -2098,7 +2095,7 @@ phase5_func(
 		 */
 		build_agf_agfl(mp, agno, &bno_btree_curs,
 				&bcnt_btree_curs, freeblks1, extra_blocks,
-				&rmap_btree_curs);
+				&rmap_btree_curs, lost_fsb);
 		/*
 		 * build inode allocation tree.
 		 */
@@ -2151,10 +2148,52 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
 }
 
+/* Inject lost blocks back into the filesystem. */
+static int
+inject_lost_blocks(
+	struct xfs_mount	*mp,
+	struct xfs_slab		*lost_fsbs)
+{
+	struct xfs_trans	*tp = NULL;
+	struct xfs_slab_cursor	*cur = NULL;
+	xfs_fsblock_t		*fsb;
+	struct xfs_trans_res	tres = {0};
+	struct xfs_owner_info	oinfo;
+	int			error;
+
+	libxfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = init_slab_cursor(lost_fsbs, NULL, &cur);
+	if (error)
+		return error;
+
+	while ((fsb = pop_slab_cursor(cur)) != NULL) {
+		error = -libxfs_trans_alloc(mp, &tres, 16, 0, 0, &tp);
+		if (error)
+			goto out_cancel;
+
+		error = -libxfs_free_extent(tp, *fsb, 1, &oinfo);
+		if (error)
+			goto out_cancel;
+
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			goto out_cancel;
+		tp = NULL;
+	}
+
+out_cancel:
+	if (tp)
+		libxfs_trans_cancel(tp);
+	free_slab_cursor(&cur);
+	return error;
+}
+
 void
 phase5(xfs_mount_t *mp)
 {
+	struct xfs_slab		*lost_fsb;
 	xfs_agnumber_t		agno;
+	int			error;
 
 	do_log(_("Phase 5 - rebuild AG headers and trees...\n"));
 	set_progress_msg(PROG_FMT_REBUILD_AG, (__uint64_t )glob_agcount);
@@ -2195,8 +2234,12 @@ phase5(xfs_mount_t *mp)
 	if (sb_fdblocks_ag == NULL)
 		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
 
+	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
+	if (error)
+		do_error(_("cannot alloc lost block slab\n"));
+
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-		phase5_func(mp, agno);
+		phase5_func(mp, agno, lost_fsb);
 
 	print_final_rpt();
 
@@ -2224,6 +2267,11 @@ phase5(xfs_mount_t *mp)
 	 */
 	sync_sb(mp);
 
+	error = inject_lost_blocks(mp, lost_fsb);
+	if (error)
+		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
+	free_slab(&lost_fsb);
+
 	bad_ino_btree = 0;
 
 }

