Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 212DE7CA6
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:25:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA3518F8035
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:25:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rcBDPqxXmNnFBb6q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:59 -0700 (PDT)
Subject: [PATCH 5/7] misc: fix Coverity errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:24:56 -0700
Message-ID: <147200549633.15538.18051281375686885659.stgit@birch.djwong.org>
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

Fix various code sloppinesses pointed out by Coverity.

Coverity-id: 1371628 - 1371638
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fsmap.c      |    1 +
 repair/phase5.c |   12 ++++++++----
 repair/rmap.c   |    5 +++--
 repair/scan.c   |    1 +
 4 files changed, 13 insertions(+), 6 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index b2ba55d..4b245b9 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -75,6 +75,7 @@ fsmap(
 	high.rm_owner = ULLONG_MAX;
 	high.rm_offset = ULLONG_MAX;
 	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK | XFS_RMAP_UNWRITTEN;
+	high.rm_blockcount = low.rm_blockcount = 0;
 
 	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
diff --git a/repair/phase5.c b/repair/phase5.c
index e583879..5a7185c 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1464,7 +1464,7 @@ prop_rmap_cursor(
 		 * and set the rightsib pointer of current block
 		 */
 #ifdef XR_BLD_INO_TRACE
-		fprintf(stderr, " ino prop agbno %d ", lptr->prev_agbno);
+		fprintf(stderr, " rmap prop agbno %d ", lptr->prev_agbno);
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
@@ -1502,7 +1502,7 @@ prop_rmap_cursor(
 		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
 	}
 	/*
-	 * add inode info to current block
+	 * add rmap info to current block
 	 */
 	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
 
@@ -1548,6 +1548,7 @@ prop_rmap_highkey(
 		bt_key->rm_offset = cpu_to_be64(
 				libxfs_rmap_irec_offset_pack(&high_key));
 
+		key.rm_blockcount = 0;
 		for (i = 1; i < numrecs - 1; i++) {
 			bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, i);
 			key.rm_startblock = be32_to_cpu(bt_key->rm_startblock);
@@ -1621,7 +1622,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 	rm_rec = pop_slab_cursor(rmap_cur);
 	lptr = &btree_curs->level[0];
 
-	for (i = 0; i < lptr->num_blocks; i++)  {
+	for (i = 0; i < lptr->num_blocks && rm_rec != NULL; i++)  {
 		/*
 		 * block initialization, lay in block header
 		 */
@@ -1639,14 +1640,17 @@ _("Insufficient memory to construct reverse-map cursor."));
 		if (lptr->modulo > 0)
 			lptr->modulo--;
 
-		if (lptr->num_recs_pb > 0)
+		if (lptr->num_recs_pb > 0) {
+			ASSERT(rm_rec != NULL);
 			prop_rmap_cursor(mp, agno, btree_curs, rm_rec, 0);
+		}
 
 		bt_rec = (struct xfs_rmap_rec *)
 			  ((char *)bt_hdr + XFS_RMAP_BLOCK_LEN);
 		highest_key.rm_startblock = 0;
 		highest_key.rm_owner = 0;
 		highest_key.rm_offset = 0;
+		highest_key.rm_blockcount = 0;
 		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
 			ASSERT(rm_rec != NULL);
 			bt_rec[j].rm_startblock =
diff --git a/repair/rmap.c b/repair/rmap.c
index f22f4f0..b3d4c25 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -316,7 +316,7 @@ fold_raw_rmaps(
 	struct xfs_slab_cursor	*cur = NULL;
 	struct xfs_rmap_irec	*prev, *rec;
 	size_t			old_sz;
-	int			error;
+	int			error = 0;
 
 	old_sz = slab_count(ag_rmaps[agno].ar_rmaps);
 	if (slab_count(ag_rmaps[agno].ar_raw_rmaps) == 0)
@@ -329,7 +329,7 @@ fold_raw_rmaps(
 
 	prev = pop_slab_cursor(cur);
 	rec = pop_slab_cursor(cur);
-	while (rec) {
+	while (prev && rec) {
 		if (mergeable_rmaps(prev, rec)) {
 			prev->rm_blockcount += rec->rm_blockcount;
 			rec = pop_slab_cursor(cur);
@@ -843,6 +843,7 @@ rmap_high_key_from_rec(
 	    (rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
 		return;
 	key->rm_offset += adj;
+	key->rm_blockcount = 0;
 }
 
 /*
diff --git a/repair/scan.c b/repair/scan.c
index 9a46dd0..253e3de 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1109,6 +1109,7 @@ advance:
 		key.rm_flags = 0;
 		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
 		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		key.rm_blockcount = 0;
 		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
 				&key)) {
 			/* Look for impossible flags. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
