Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752997AbdDDVgO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 17:36:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2AE3E61BA6
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 21:36:14 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3D5A77ECB
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 21:36:13 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: pass btnum not magic to phase5 functions
Message-ID: <904ac9a2-83e4-f534-c9f5-e071844b6a5e@redhat.com>
Date: Tue, 4 Apr 2017 16:36:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

When ed849ef xfs: remove boilerplate around xfs_btree_init_block
was merged from kernelspace, I made only minimal changes at the
libxfs boundary to accommodate the new libxfs_btree_init_block
interface.

We can chase that up a bit higher and remove more code by
passing in btnum from the start; we can also remove the
"finobt" argument from build_ino_tree() because that is
known from type of tree passed in.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 phase5.c |   63 +++++++++++++++++++++++----------------------------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index d00b078..4574eae 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -630,19 +630,15 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 static void
 prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, xfs_agblock_t startblock,
-		xfs_extlen_t blockcount, int level, __uint32_t magic)
+		xfs_extlen_t blockcount, int level, xfs_btnum_t btnum)
 {
 	struct xfs_btree_block	*bt_hdr;
 	xfs_alloc_key_t		*bt_key;
 	xfs_alloc_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
-	xfs_btnum_t		btnum;
 
-	if (magic == XFS_ABTB_MAGIC)
-		btnum = XFS_BTNUM_BNO;
-	else
-		btnum = XFS_BTNUM_CNT;
+	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
 	level++;
 
@@ -658,7 +654,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		 * left-hand side of the tree.
 		 */
 		prop_freespace_cursor(mp, agno, btree_curs, startblock,
-				blockcount, level, magic);
+				blockcount, level, btnum);
 	}
 
 	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
@@ -703,7 +699,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		 * propagate extent record for first extent in new block up
 		 */
 		prop_freespace_cursor(mp, agno, btree_curs, startblock,
-				blockcount, level, magic);
+				blockcount, level, btnum);
 	}
 	/*
 	 * add extent info to current block
@@ -722,13 +718,13 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 }
 
 /*
- * rebuilds a freespace tree given a cursor and magic number of type
+ * rebuilds a freespace tree given a cursor and type
  * of tree to build (bno or bcnt).  returns the number of free blocks
  * represented by the tree.
  */
 static xfs_extlen_t
 build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, __uint32_t magic)
+		bt_status_t *btree_curs, xfs_btnum_t btnum)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -739,7 +735,8 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	extent_tree_node_t	*ext_ptr;
 	bt_stat_level_t		*lptr;
 	xfs_extlen_t		freeblks;
-	xfs_btnum_t		btnum;
+
+	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "in build_freespace_tree, agno = %d\n", agno);
@@ -748,10 +745,6 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	freeblks = 0;
 
 	ASSERT(level > 0);
-	if (magic == XFS_ABTB_MAGIC)
-		btnum = XFS_BTNUM_BNO;
-	else
-		btnum = XFS_BTNUM_CNT;
 
 	/*
 	 * initialize the first block on each btree level
@@ -784,7 +777,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * pointers for the parent.  that can recurse up to the root
 	 * if required.  set the sibling pointers for leaf level here.
 	 */
-	if (magic == XFS_ABTB_MAGIC)
+	if (btnum == XFS_BTNUM_BNO)
 		ext_ptr = findfirst_bno_extent(agno);
 	else
 		ext_ptr = findfirst_bcnt_extent(agno);
@@ -824,7 +817,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			prop_freespace_cursor(mp, agno, btree_curs,
 					ext_ptr->ex_startblock,
 					ext_ptr->ex_blockcount,
-					0, magic);
+					0, btnum);
 
 		bt_rec = (xfs_alloc_rec_t *)
 			  ((char *)bt_hdr + XFS_ALLOC_BLOCK_LEN(mp));
@@ -835,7 +828,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			bt_rec[j].ar_blockcount = cpu_to_be32(
 							ext_ptr->ex_blockcount);
 			freeblks += ext_ptr->ex_blockcount;
-			if (magic == XFS_ABTB_MAGIC)
+			if (btnum == XFS_BTNUM_BNO)
 				ext_ptr = findnext_bno_extent(ext_ptr);
 			else
 				ext_ptr = findnext_bcnt_extent(agno, ext_ptr);
@@ -1138,8 +1131,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
  */
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, __uint32_t magic,
-		struct agi_stat *agi_stat, int finobt)
+		bt_status_t *btree_curs, xfs_btnum_t btnum,
+		struct agi_stat *agi_stat)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -1158,14 +1151,8 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	int			spmask;
 	uint64_t		sparse;
 	uint16_t		holemask;
-	xfs_btnum_t		btnum;
 
-	if (magic == XFS_IBT_CRC_MAGIC || magic == XFS_IBT_MAGIC)
-		btnum = XFS_BTNUM_INO;
-	else if (magic == XFS_FIBT_CRC_MAGIC || magic == XFS_FIBT_MAGIC)
-		btnum = XFS_BTNUM_FINO;
-	else 
-		ASSERT(0);
+	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
 
 	for (i = 0; i < level; i++)  {
 		lptr = &btree_curs->level[i];
@@ -1197,7 +1184,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * pointers for the parent.  that can recurse up to the root
 	 * if required.  set the sibling pointers for leaf level here.
 	 */
-	if (finobt)
+	if (btnum == XFS_BTNUM_FINO)
 		ino_rec = findfirst_free_inode_rec(agno);
 	else
 		ino_rec = findfirst_inode_rec(agno);
@@ -1280,7 +1267,7 @@ nextrec:
 			freecount += finocnt;
 			count += inocnt;
 
-			if (finobt)
+			if (btnum == XFS_BTNUM_FINO)
 				ino_rec = next_free_ino_rec(ino_rec);
 			else
 				ino_rec = next_ino_rec(ino_rec);
@@ -2223,7 +2210,6 @@ phase5_func(
 	xfs_extlen_t	freeblks2;
 #endif
 	xfs_agblock_t	num_extents;
-	__uint32_t	magic;
 	struct agi_stat	agi_stat = {0,};
 	int		error;
 
@@ -2350,7 +2336,7 @@ phase5_func(
 		 * now rebuild the freespace trees
 		 */
 		freeblks1 = build_freespace_tree(mp, agno,
-					&bno_btree_curs, XFS_ABTB_MAGIC);
+					&bno_btree_curs, XFS_BTNUM_BNO);
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "# of free blocks == %d\n", freeblks1);
 #endif
@@ -2358,10 +2344,10 @@ phase5_func(
 
 #ifdef DEBUG
 		freeblks2 = build_freespace_tree(mp, agno,
-					&bcnt_btree_curs, XFS_ABTC_MAGIC);
+					&bcnt_btree_curs, XFS_BTNUM_CNT);
 #else
 		(void) build_freespace_tree(mp, agno,
-					&bcnt_btree_curs, XFS_ABTC_MAGIC);
+					&bcnt_btree_curs, XFS_BTNUM_CNT);
 #endif
 		write_cursor(&bcnt_btree_curs);
 
@@ -2388,19 +2374,16 @@ phase5_func(
 		/*
 		 * build inode allocation tree.
 		 */
-		magic = xfs_sb_version_hascrc(&mp->m_sb) ?
-				XFS_IBT_CRC_MAGIC : XFS_IBT_MAGIC;
-		build_ino_tree(mp, agno, &ino_btree_curs, magic, &agi_stat, 0);
+		build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
+				&agi_stat);
 		write_cursor(&ino_btree_curs);
 
 		/*
 		 * build free inode tree
 		 */
 		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
-					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
-			build_ino_tree(mp, agno, &fino_btree_curs, magic,
-					NULL, 1);
+			build_ino_tree(mp, agno, &fino_btree_curs,
+					XFS_BTNUM_FINO, NULL);
 			write_cursor(&fino_btree_curs);
 		}
 

