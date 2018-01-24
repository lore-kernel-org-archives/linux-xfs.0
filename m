Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56970 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbeAXCS0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:18:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27ZJp035667
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:25 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fpgu1838w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:25 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2IOKA030555
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:24 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0O2IO0w020494
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:24 GMT
Subject: [PATCH 04/11] xfs: CoW fork operations should only update quota
 reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:18:23 -0800
Message-ID: <151676030319.12349.11227408793644481553.stgit@magnolia>
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the CoW fork only exists in memory, it is incorrect to update the
on-disk quota block counts when we modify the CoW fork.  Unlike the data
fork, even real extents in the CoW fork are only reservations (on-disk
they're owned by the refcountbt) so they must not be tracked in the on
disk quota info.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  203 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_reflink.c     |    8 +-
 2 files changed, 196 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6e6f3cb..e3e8f7c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,6 +52,145 @@
 #include "xfs_refcount.h"
 #include "xfs_icache.h"
 
+/*
+ * Data/Attr Fork Mapping Lifecycle
+ *
+ * The data fork contains the block mappings between logical blocks in a file
+ * and physical blocks on the disk.  The XFS notions of delayed allocation
+ * reservations, unwritten extents, and real extents follow well known
+ * conventions in the filesystem world.
+ *
+ * As a side note, the attribute fork does the same for extended attribute
+ * blocks, though the logical block offsets are not available to userspace and
+ * the only valid states are HOLE and REAL.
+ *
+ * Metadata involved outside of the block mapping itself are as follows:
+ *
+ * - i_delayed_blks: Number of blocks that are reserved for delayed allocation.
+ * - i_cow_blocks: Number of blocks reserved for copy on write staging.
+ *
+ * - di_nblocks: Number of blocks (on-disk) assigned to the inode.
+ *
+ * - d_bcount: Number of quota blocks accounted for by on-disk metadata.
+ * - q_res_bcount: Number of quota blocks reserved in-core for future writes +
+ *           blocks mentioned by on-disk metadata.
+ *
+ * - qt_blk_res: Number of quota blocks reserved in-core for this transaction.
+ *           Unused reservation is given back to q_res_bcount on commit.
+ * - qt_bcount: Number of quota blocks used by this transaction from
+ *           qt_blk_res.  d_bcount is increased by this on commit.
+ * - qt_delbcount: Number of quota blocks used by this transaction from
+ *           q_res_bcount but not q_res_bcount.  d_bcount is increased by this
+ *           on commit.
+ *
+ * - sb_fdblocks: Number of free blocks recorded in the superblock on disk.
+ * - fdblocks: Number of free blocks recorded in the superblock minus any
+ *           in-core reservations made in anticipation of future writes.
+ *
+ * - t_blk_res: Number of blocks reserved out of fdblocks for a transaction.
+ *           When the transaction commits, t_blk_res - t_blk_res_used is given
+ *           back to fdblocks.
+ * - t_blk_res_used: Number of blocks used by this transaction that were
+ *           reserved for this transaction.
+ * - t_fdblocks_del: Number of blocks by which fdblocks and sb_fdblocks will
+ *           have to decrease at commit.
+ * - t_res_fdblocks_delta: Number of blocks by which sb_fdblocks will have to
+ *           decrease at commit.  We assume that fdblocks was decreased
+ *           prior to the transaction.
+ *
+ * Data fork block mappings have four logical states:
+ *
+ *    +--------> UNWRITTEN <------+
+ *    |              ^            |
+ *    |              v            v
+ * DELALLOC <----> HOLE <------> REAL
+ *    |                           ^
+ *    |                           |
+ *    +---------------------------+
+ *
+ * The state transitions and required metadata updates are as follows:
+ *
+ * - HOLE to DELALLOC: Increase i_delayed_blks and q_res_bcount, and decrease
+ *           fdblocks.
+ * - HOLE to REAL: Increase di_nblocks and qt_bcount, and decrease fdblocks.
+ * - HOLE to UNWRITTEN: Same as above.
+ *
+ * - DELALLOC to UNWRITTEN: Increase di_nblocks and qt_delbcount, and decrease
+ *           i_delayed_blks.
+ * - DELALLOC to REAL: Same as above.
+ * - DELALLOC to HOLE: Increase fdblocks, and decrease i_delayed_blks and
+ *           q_res_bcount.
+ *
+ * - UNWRITTEN to HOLE: Decrease di_nblocks and q_bcount, and increase fdblocks.
+ * - UNWRITTEN to REAL: No change.
+ *
+ * - REAL to UNWRITTEN: No change.
+ * - REAL to HOLE: Decrease di_nblocks and q_bcount, and increase fdblocks.
+ *
+ * Note in particular that delalloc reservations have "transaction-less"
+ * quota reservations via q_res_bcount.  If the reservation is allocated,
+ * qt_delbcount is used to increment d_bcount without touching q_res_bcount.
+ * Filling a hole with an allocated extent, by contrast, uses qt_blk_res
+ * to make a reservation in q_res_bcount, qt_bcount to record the number
+ * of allocated blocks; at commit qt_bcount is added to d_bcount and
+ * qt_blk_res - qt_bcount is added back to q_res_bcount.
+ *
+ * Copy on Write Fork Mapping Lifecycle
+ *
+ * The CoW fork handles things differently from the data fork because its
+ * mappings only exist in memory-- the refcount btree is the on-disk owner of
+ * the extents until they're remapped into the data fork.  Therefore,
+ * unwritten and real extents in the CoW fork are treated the same way as
+ * delayed allocation extents.  Quota and fdblock changes only exist in
+ * memory, which requires some twists in the bmap functions.
+ *
+ * The CoW fork extent state diagram looks like this:
+ *
+ *    +--------> UNWRITTEN -------+
+ *    |              ^            |
+ *    |              v            v
+ * DELALLOC <----> HOLE <------- REAL
+ *
+ * Holes are still holes.  Delayed allocation extents reserve blocks for
+ * landing future writes, just like they do in the data fork.  However, unlike
+ * the data fork, unwritten extents signal an extent that has been allocated
+ * but is not currently undergoing writeback.  Real extents are undergoing
+ * writeback, and when that writeback finishes the corresponding data fork
+ * extent will be punched out and the CoW fork counterpart moved to the new
+ * hole in the data fork.
+ *
+ * The state transitions and required metadata updates are as follows:
+ *
+ * - HOLE to DELALLOC: Increase i_cow_blocks and q_res_bcount, and decrease
+ *           fdblocks.
+ * - HOLE to UNWRITTEN: Same as above, but since we reserved quota via
+ *           qt_blk_res (which increased q_res_bcount) when we allocate the
+ *           extent we have to decrease qt_blk_res so that the commit doesn't
+ *           give the allocated CoW blocks back.
+ *
+ * - DELALLOC to UNWRITTEN: No change.
+ * - DELALLOC to HOLE: Decrease i_cow_blocks and q_res_bcount, and increase
+ *           fdblocks.
+ *
+ * - UNWRITTEN to HOLE: Same as DELALLOC to HOLE.
+ * - UNWRITTEN to REAL: No change.
+ *
+ * - REAL to HOLE: This transition happens when we've finished a write
+ *           operation and need to move the mapping to the data fork.  We
+ *           punch the correspond data fork mappings, which decreases
+ *           qt_bcount.  Then we map the CoW fork mapping into the hole we
+ *           just cleared out of the data fork, which increases qt_bcount.
+ *           There's a subtlety here -- if we promoted a write over a hole to
+ *           CoW, there will be a net increase in qt_bcount, which is fine
+ *           because we already reserved the quota when we filled the CoW
+ *           fork.  Finally, we punch the CoW fork mapping, which decreases
+ *           q_res_bcount.
+ *
+ * Notice how all CoW fork extents use transactionless quota reservations and
+ * the in-core fdblocks to maintain state, and we avoid updating any on-disk
+ * metadata.  This is essential to maintain metadata correctness if the system
+ * goes down.
+ */
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
@@ -3337,6 +3476,39 @@ xfs_bmap_btalloc_filestreams(
 	return 0;
 }
 
+/* Deal with CoW fork accounting when we allocate a block. */
+static void
+xfs_bmap_btalloc_cow(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	/* Filling a previously reserved extent; nothing to do here. */
+	if (ap->wasdel)
+		return;
+
+	/*
+	 * The CoW fork only exists in memory, so the on-disk quota accounting
+	 * must not incude any CoW fork extents.  Therefore, CoW blocks are
+	 * only tracked in the in-core dquot block count (q_res_bcount).
+	 *
+	 * If we get here, we're filling a CoW hole with a real (non-delalloc)
+	 * CoW extent having reserved enough blocks from both q_res_bcount and
+	 * qt_blk_res to guarantee that we won't run out of space.  The unused
+	 * qt_blk_res is given back to q_res_bcount when the transaction
+	 * commits.
+	 *
+	 * We don't want the quota accounting for our newly allocated blocks
+	 * to be given back, so we must decrease qt_blk_res without decreasing
+	 * q_res_bcount.
+	 *
+	 * Note: If we're allocating a delalloc extent, we already reserved
+	 * the q_res_bcount blocks, so no quota accounting update is needed
+	 * here.
+	 */
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
+			-(long)args->len);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3571,19 +3743,22 @@ xfs_bmap_btalloc(
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
+			xfs_bmap_btalloc_cow(ap, &args);
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
@@ -4776,6 +4951,7 @@ xfs_bmap_del_extent_cow(
 	struct xfs_bmbt_irec	new;
 	xfs_fileoff_t		del_endoff, got_endoff;
 	int			state = BMAP_COWFORK;
+	int			error;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -4832,6 +5008,11 @@ xfs_bmap_del_extent_cow(
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
 

