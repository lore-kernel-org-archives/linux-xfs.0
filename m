Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 506F57CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:02:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 205328F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 14:02:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hMXev8sui6A6Iyjm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 14:02:22 -0700 (PDT)
Date: Thu, 25 Aug 2016 14:02:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 5/7] misc: fix Coverity errors
Message-ID: <20160825210216.GB22760@birch.djwong.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
	<147200549633.15538.18051281375686885659.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147200549633.15538.18051281375686885659.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Fix various code sloppinesses pointed out by Coverity,
and fix an incorrect comment/debug message.

Coverity-id: 1371628 - 1371638
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fsmap.c      |    7 ++-----
 repair/phase5.c |   17 +++++++++--------
 repair/rmap.c   |    4 ++--
 repair/scan.c   |    2 +-
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/db/fsmap.c b/db/fsmap.c
index b2ba55d..61ccce0 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -57,8 +57,8 @@ fsmap(
 	xfs_agnumber_t		end_ag;
 	xfs_agnumber_t		agno;
 	xfs_daddr_t		eofs;
-	struct xfs_rmap_irec	low;
-	struct xfs_rmap_irec	high;
+	struct xfs_rmap_irec	low = {0};
+	struct xfs_rmap_irec	high = {0};
 	struct xfs_btree_cur	*bt_cur;
 	struct xfs_buf		*agbp;
 	int			error;
@@ -68,9 +68,6 @@ fsmap(
 		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
 
 	low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
-	low.rm_owner = 0;
-	low.rm_offset = 0;
-	low.rm_flags = 0;
 	high.rm_startblock = -1U;
 	high.rm_owner = ULLONG_MAX;
 	high.rm_offset = ULLONG_MAX;
diff --git a/repair/phase5.c b/repair/phase5.c
index e583879..27141cc 100644
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
 
@@ -1529,13 +1529,12 @@ prop_rmap_highkey(
 	struct xfs_btree_block	*bt_hdr;
 	struct xfs_rmap_key	*bt_key;
 	struct bt_stat_level	*lptr;
-	struct xfs_rmap_irec	key;
+	struct xfs_rmap_irec	key = {0};
 	struct xfs_rmap_irec	high_key;
 	int			level;
 	int			i;
 	int			numrecs;
 
-	key.rm_flags = 0;
 	high_key = *rm_highkey;
 	for (level = 1; level < btree_curs->num_levels; level++) {
 		lptr = &btree_curs->level[level];
@@ -1575,8 +1574,8 @@ build_rmap_tree(
 	struct xfs_rmap_irec	*rm_rec;
 	struct xfs_slab_cursor	*rmap_cur;
 	struct xfs_rmap_rec	*bt_rec;
-	struct xfs_rmap_irec	highest_key;
-	struct xfs_rmap_irec	hi_key;
+	struct xfs_rmap_irec	highest_key = {0};
+	struct xfs_rmap_irec	hi_key = {0};
 	struct bt_stat_level	*lptr;
 	int			level = btree_curs->num_levels;
 	int			error;
@@ -1621,7 +1620,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 	rm_rec = pop_slab_cursor(rmap_cur);
 	lptr = &btree_curs->level[0];
 
-	for (i = 0; i < lptr->num_blocks; i++)  {
+	for (i = 0; i < lptr->num_blocks && rm_rec != NULL; i++)  {
 		/*
 		 * block initialization, lay in block header
 		 */
@@ -1639,8 +1638,10 @@ _("Insufficient memory to construct reverse-map cursor."));
 		if (lptr->modulo > 0)
 			lptr->modulo--;
 
-		if (lptr->num_recs_pb > 0)
+		if (lptr->num_recs_pb > 0) {
+			ASSERT(rm_rec != NULL);
 			prop_rmap_cursor(mp, agno, btree_curs, rm_rec, 0);
+		}
 
 		bt_rec = (struct xfs_rmap_rec *)
 			  ((char *)bt_hdr + XFS_RMAP_BLOCK_LEN);
diff --git a/repair/rmap.c b/repair/rmap.c
index f22f4f0..cdd5c3a 100644
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
diff --git a/repair/scan.c b/repair/scan.c
index 9a46dd0..0ef1123 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -898,7 +898,7 @@ scan_rmapbt(
 	int			state;
 	xfs_agblock_t		lastblock = 0;
 	struct xfs_rmap_key	*kp;
-	struct xfs_rmap_irec	key;
+	struct xfs_rmap_irec	key = {0};
 
 	if (magic != XFS_RMAP_CRC_MAGIC) {
 		name = "(unknown)";

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
