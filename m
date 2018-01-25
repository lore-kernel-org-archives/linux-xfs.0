Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57018 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbeAYBUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 20:20:41 -0500
Date: Wed, 24 Jan 2018 17:20:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 04/11] xfs: CoW fork operations should only update quota
 reservations
Message-ID: <20180125012035.GE9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030319.12349.11227408793644481553.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676030319.12349.11227408793644481553.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the CoW fork only exists in memory, it is incorrect to update the
on-disk quota block counts when we modify the CoW fork.  Unlike the data
fork, even real extents in the CoW fork are only reservations (on-disk
they're owned by the refcountbt) so they must not be tracked in the on
disk quota info.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: make documentation more crisp and to the point
---
 fs/xfs/libxfs/xfs_bmap.c |  118 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_quota.h       |   14 ++++-
 fs/xfs/xfs_reflink.c     |    8 ++-
 3 files changed, 122 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0c9c9cd..7f0ac40 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,6 +52,71 @@
 #include "xfs_refcount.h"
 #include "xfs_icache.h"
 
+/*
+ * Data/Attribute Fork Mapping Lifecycle
+ *
+ * The data fork contains the block mappings between logical blocks in a file
+ * and physical blocks on the disk.  The XFS notions of delayed allocation
+ * reservations, unwritten extents, and real extents follow well known
+ * conventions in the filesystem world.
+ *
+ * Data fork extent states follow these transitions:
+ *
+ *    +--------> UNWRITTEN <------+
+ *    |              ^            |
+ *    |              v            v
+ * DELALLOC <----> HOLE <------> REAL
+ *    |                           ^
+ *    |                           |
+ *    +---------------------------+
+ *
+ * Every delayed allocation reserves in-memory quota blocks (q_res_bcount) and
+ * in-memory fs free blocks (fdblocks), and increases the in-memory per-inode
+ * i_delayed_blks.  The reservation includes potentially required bmbt blocks.
+ *
+ * Every transaction reserves quota blocks (qt_blk_res) from the in-memory
+ * quota blocks and free blocks (t_blk_res) from the in-memory fs free blocks.
+ * The transaction tracks both the number of blocks used from its own
+ * reservation as well as the number of blocks used that came from a delayed
+ * allocation.  When the transaction commits, it gives back the unused parts
+ * of its own block reservations.  Next, it adds any block usage that came
+ * from a delayed allocation to the on-disk counters without changing the
+ * in-memory reservations (q_res_bcount and fdblocks).
+ *
+ * To convert a delayed allocation to a real or unwritten extent, we use a
+ * transaction to allocate the blocks.  At commit time, the block reservations
+ * are given back or added to the on-disk counters as noted above.
+ * i_delayed_blks is decreased while the on-disk per-inode di_nblocks is
+ * increased.
+ *
+ * The attribute fork works in the same way as the data fork except that the
+ * only valid states are REAL and HOLE.
+ *
+ * Copy on Write Fork Mapping Lifecycle
+ *
+ * The CoW fork exists only in memory and is used to stage copy writes for
+ * file data and has fewer transitions:
+ *
+ *    +--------> UNWRITTEN -------+
+ *    |              ^            |
+ *    |              v            v
+ * DELALLOC <----> HOLE <------- REAL
+ *
+ * Delayed allocation extents here are treated the same as in the data fork
+ * except that they are counted by the per-inode i_cow_blocks instead of
+ * i_delayed_blks.
+ *
+ * Unwritten and real extents are counted by the quota code as block
+ * reservations (q_res_bcount) and not on-disk quota blocks (d_bcount), and
+ * are counted by the free block counters as in-memory reservations (fdblocks)
+ * and not on-disk free blocks (sb_fdblocks).  These blocks are also counted
+ * by i_cow_blocks and not the on-disk di_nblocks.
+ *
+ * When a CoW fork extent is remapped to the data fork, the reservations are
+ * converted into on-disk counts in the same manner as a delayed allocation
+ * conversion in the data fork.  The number of blocks being remapped is
+ * subtracted from i_cow_blocks and added to di_nblocks.
+ */
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
@@ -3337,6 +3402,28 @@ xfs_bmap_btalloc_filestreams(
 	return 0;
 }
 
+/* Deal with CoW fork accounting when we allocate a block. */
+static void
+xfs_bmap_btalloc_quota_cow(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	/* Filling a previously reserved extent; nothing to do here. */
+	if (ap->wasdel)
+		return;
+
+	/*
+	 * If we get here, we're filling a CoW hole with a real (non-delalloc)
+	 * CoW extent having reserved enough blocks from both q_res_bcount and
+	 * qt_blk_res to guarantee that we won't run out of space.  The unused
+	 * qt_blk_res is given back to q_res_bcount when the transaction
+	 * commits, so we must decrease qt_blk_res without decreasing
+	 * q_res_bcount.
+	 */
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
+			-(long)args->len);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3571,19 +3658,22 @@ xfs_bmap_btalloc(
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
-		if (!(ap->flags & XFS_BMAPI_COWFORK))
-			ap->ip->i_d.di_nblocks += args.len;
-		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
 			ap->ip->i_delayed_blks -= args.len;
-		/*
-		 * Adjust the disk quota also. This was reserved
-		 * earlier.
-		 */
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
-					XFS_TRANS_DQ_BCOUNT,
-			(long) args.len);
+		if (ap->flags & XFS_BMAPI_COWFORK) {
+			xfs_bmap_btalloc_quota_cow(ap, &args);
+		} else {
+			ap->ip->i_d.di_nblocks += args.len;
+			xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+			/*
+			 * Adjust the disk quota also. This was reserved
+			 * earlier.
+			 */
+			xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+				ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
+						XFS_TRANS_DQ_BCOUNT,
+				(long) args.len);
+		}
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
@@ -4760,6 +4850,7 @@ xfs_bmap_del_extent_cow(
 	struct xfs_bmbt_irec	new;
 	xfs_fileoff_t		del_endoff, got_endoff;
 	int			state = BMAP_COWFORK;
+	int			error;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -4816,6 +4907,11 @@ xfs_bmap_del_extent_cow(
 		xfs_iext_insert(ip, icur, &new, state);
 		break;
 	}
+
+	/* Remove the quota reservation */
+	error = xfs_trans_reserve_quota_nblks(NULL, ip,
+			-(long)del->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
+	ASSERT(error == 0);
 }
 
 /*
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index ce6506a..34b4ec2 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -54,11 +54,19 @@ struct xfs_trans;
  */
 typedef struct xfs_dqtrx {
 	struct xfs_dquot *qt_dquot;	  /* the dquot this refers to */
-	ulong		qt_blk_res;	  /* blks reserved on a dquot */
+
+	/* dquot bcount blks reserved for this transaction */
+	ulong		qt_blk_res;
+
 	ulong		qt_ino_res;	  /* inode reserved on a dquot */
 	ulong		qt_ino_res_used;  /* inodes used from the reservation */
-	long		qt_bcount_delta;  /* dquot blk count changes */
-	long		qt_delbcnt_delta; /* delayed dquot blk count changes */
+
+	/* dquot block count changes taken from qt_blk_res */
+	long		qt_bcount_delta;
+
+	/* dquot block count changes taken from delalloc reservation */
+	long		qt_delbcnt_delta;
+
 	long		qt_icount_delta;  /* dquot inode count changes */
 	ulong		qt_rtblk_res;	  /* # blks reserved on a dquot */
 	ulong		qt_rtblk_res_used;/* # blks used from reservation */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 82abff6..e367351 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -599,10 +599,6 @@ xfs_reflink_cancel_cow_blocks(
 					del.br_startblock, del.br_blockcount,
 					NULL);
 
-			/* Update quota accounting */
-			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
-					-(long)del.br_blockcount);
-
 			/* Roll the transaction */
 			xfs_defer_ijoin(&dfops, ip);
 			error = xfs_defer_finish(tpp, &dfops);
@@ -795,6 +791,10 @@ xfs_reflink_end_cow(
 		if (error)
 			goto out_defer;
 
+		/* Charge this new data fork mapping to the on-disk quota. */
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+				(long)del.br_blockcount);
+
 		/* Remove the mapping from the CoW fork. */
 		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
