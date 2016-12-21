Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46816 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933376AbcLUDJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 22:09:51 -0500
Date: Tue, 20 Dec 2016 19:09:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: change null check to assertion
Message-ID: <20161221030945.GD5487@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

It /should/ be the case that we never run out of records
before we run out of btree blocks, so change the null check
(that was only to appease Coverity) to an assert.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index cbda556..ebe1f7d 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1579,6 +1579,7 @@ build_rmap_tree(
 	struct xfs_rmap_irec	highest_key = {0};
 	struct xfs_rmap_irec	hi_key = {0};
 	struct bt_stat_level	*lptr;
+	int			numrecs;
 	int			level = btree_curs->num_levels;
 	int			error;
 
@@ -1622,7 +1623,10 @@ _("Insufficient memory to construct reverse-map cursor."));
 	rm_rec = pop_slab_cursor(rmap_cur);
 	lptr = &btree_curs->level[0];
 
-	for (i = 0; i < lptr->num_blocks && rm_rec != NULL; i++)  {
+	for (i = 0; i < lptr->num_blocks; i++)  {
+		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
+		ASSERT(rm_rec != NULL || numrecs == 0);
+
 		/*
 		 * block initialization, lay in block header
 		 */
@@ -1634,8 +1638,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 					XFS_BTREE_CRC_BLOCKS);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
-							(lptr->modulo > 0));
+		bt_hdr->bb_numrecs = cpu_to_be16(numrecs);
 
 		if (lptr->modulo > 0)
 			lptr->modulo--;
@@ -1883,6 +1886,7 @@ build_refcount_tree(
 	struct xfs_slab_cursor	*refc_cur;
 	struct xfs_refcount_rec	*bt_rec;
 	struct bt_stat_level	*lptr;
+	int			numrecs;
 	int			level = btree_curs->num_levels;
 	int			error;
 
@@ -1925,7 +1929,10 @@ _("Insufficient memory to construct refcount cursor."));
 	refc_rec = pop_slab_cursor(refc_cur);
 	lptr = &btree_curs->level[0];
 
-	for (i = 0; i < lptr->num_blocks && refc_rec != NULL; i++)  {
+	for (i = 0; i < lptr->num_blocks; i++)  {
+		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
+		ASSERT(refc_rec != NULL || numrecs == 0);
+
 		/*
 		 * block initialization, lay in block header
 		 */
@@ -1937,8 +1944,7 @@ _("Insufficient memory to construct refcount cursor."));
 					XFS_BTREE_CRC_BLOCKS);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
-							(lptr->modulo > 0));
+		bt_hdr->bb_numrecs = cpu_to_be16(numrecs);
 
 		if (lptr->modulo > 0)
 			lptr->modulo--;
