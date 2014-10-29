Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B14A29DFB
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 22:09:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD5D6AC00B
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 20:09:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nNiAoYDpXqYCvoBY for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 20:09:13 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] repair: AGFL rebuild fails if btree split required
Date: Wed, 29 Oct 2014 14:09:04 +1100
Message-Id: <1414552144-12627-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1414552144-12627-1-git-send-email-david@fromorbit.com>
References: <1414552144-12627-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bvowk@box.com

From: Dave Chinner <dchinner@redhat.com>

In phase 5 we rebuild the freelist btrees, the AGF and the AGFL from
all the free space information we have gathered and resolved during
pahses 3 and 4. If the freespace information is laid out just right,
we end up having to allocate free space for the AGFL blocks.

If the size of the free space we allocate from is larger than the
space we need, then we have to insert the remainder back into the
freespace btree. For the by-size tree, this means we are likely to
be removing a record from one leaf, and then inserting the remainder
- a smaller size - into another leaf.

The issue is that the leaf blocks to the left of the original leaf
block we removed the extent record from are full and hence require a
split to insert the new record. That, of course, requires a free
block in the AGFL to allocate from, and now we have a chicken and
egg situation: there are no free blocks in the AGFL because we are
setting it up.

As a result, setting up the free list silently fails, leaving the
freespace btrees in an inconsistent state and the AGFL in question
empty. When the filesystem is next mounted, the first allocation
from that AGF results in attempting to fix the AGFL, and it then
does exactly the same thing as the repair code, fails to allocate a
block during the split and fails. This results in an immediate
shutdown because the transaction doing the allocation is dirty by
this stage.

The fix for the problem is to make repair handle rebulding the btree
differently. If we leave ispace for a couple of records in each
btree leaf and node, there is never a need for a split to occur when
initially setting up the AGFL. This results in repair doing the
right thing, and hence the runtime problems after mount don't occur.
Further, add error checking the the AGFL setup code and abort repair
if we have a failure to correctly set up the AGFL so we catch this
problem at repair time, not mount time...

Reported-by: Barkley Vowk <bvowk@box.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase5.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index d6d3c6d..3d58936 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -335,11 +335,22 @@ finish_cursor(bt_status_t *curs)
 }
 
 /*
+ * We need to leave some free records in the tree for the corner case of
+ * setting up the AGFL. This may require allocation of blocks, and as
+ * such can require insertion of new records into the tree (e.g. moving
+ * a record in the by-count tree when a long extent is shortened). If we
+ * pack the records into the leaves with no slack space, this requires a
+ * leaf split to occur and a block to be allocated from the free list.
+ * If we don't have any blocks on the free list (because we are setting
+ * it up!), then we fail, and the filesystem will fail with the same
+ * failure at runtime. Hence leave a couple of records slack space in
+ * each block to allow immediate modification of the tree without
+ * requiring splits to be done.
+ *
  * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
  */
 #define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
-			xfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
-						(level) == 0)
+	(xfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
 
 /*
  * this calculates a freespace cursor for an ag.
@@ -361,10 +372,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	bt_stat_level_t		*p_lptr;
 	extent_tree_node_t	*ext_ptr;
 	int			level;
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr,
-		"in init_freespace_cursor, agno = %d\n", agno);
-#endif
 
 	num_extents = *extents;
 	extents_used = 0;
@@ -385,6 +392,13 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	lptr->num_recs_tot = num_extents;
 	level = 1;
 
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "%s 0 %d %d %d %d\n", __func__,
+			lptr->num_blocks,
+			lptr->num_recs_pb,
+			lptr->modulo,
+			lptr->num_recs_tot);
+#endif
 	/*
 	 * if we need more levels, set them up.  # of records
 	 * per level is the # of blocks in the level below it
@@ -402,6 +416,14 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 			lptr->num_recs_pb = p_lptr->num_blocks
 					/ lptr->num_blocks;
 			lptr->num_recs_tot = p_lptr->num_blocks;
+#ifdef XR_BLD_FREE_TRACE
+			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
+					level,
+					lptr->num_blocks,
+					lptr->num_recs_pb,
+					lptr->modulo,
+					lptr->num_recs_tot);
+#endif
 		}
 	}
 
@@ -546,8 +568,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 				lptr = &btree_curs->level[level];
 				p_lptr = &btree_curs->level[level-1];
 				lptr->num_blocks = howmany(p_lptr->num_blocks,
-						XR_ALLOC_BLOCK_MAXRECS(mp,
-								level));
+					XR_ALLOC_BLOCK_MAXRECS(mp, level));
 				lptr->modulo = p_lptr->num_blocks
 						% lptr->num_blocks;
 				lptr->num_recs_pb = p_lptr->num_blocks
@@ -1434,6 +1455,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 		xfs_alloc_arg_t	args;
 		xfs_trans_t	*tp;
 		struct xfs_trans_res tres = {0};
+		int		error;
 
 		memset(&args, 0, sizeof(args));
 		args.tp = tp = libxfs_trans_alloc(mp, 0);
@@ -1442,8 +1464,12 @@ build_agf_agfl(xfs_mount_t	*mp,
 		args.alignment = 1;
 		args.pag = xfs_perag_get(mp,agno);
 		libxfs_trans_reserve(tp, &tres, XFS_MIN_FREELIST(agf, mp), 0);
-		libxfs_alloc_fix_freelist(&args, 0);
+		error = libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
+		if (error) {
+			do_error(_("failed to fix AGFL on AG %d, error %d\n"),
+					agno, error);
+		}
 		libxfs_trans_commit(tp, 0);
 	}
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
