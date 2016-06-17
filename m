Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E044D7FA7
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77865AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:20 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iAaYGxuYe4XwmKNm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:18 -0700 (PDT)
Subject: [PATCH 004/145] libxfs: backport kernel 4.6 changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:10 -0700
Message-ID: <146612707046.16048.7170232600634665075.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Backport the changes from kernel 4.5 -> 4.6.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h     |    1 
 libxfs/libxfs_priv.h    |    2 -
 libxfs/trans.c          |    1 
 libxfs/xfs_bmap.c       |  170 +++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_bmap_btree.c |    4 +
 libxfs/xfs_dir2_node.c  |    4 +
 libxfs/xfs_ialloc.c     |    4 +
 7 files changed, 129 insertions(+), 57 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 5467c7f..d7ee1fd 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -81,6 +81,7 @@ typedef struct xfs_trans {
 	long		t_fdblocks_delta;	/* superblock fdblocks chg */
 	long		t_frextents_delta;	/* superblock freextents chg */
 	struct list_head	t_items;	/* first log item desc chunk */
+	unsigned int	t_blk_res;
 } xfs_trans_t;
 
 void	xfs_trans_init(struct xfs_mount *);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ef9ff3b..ecd75e7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -187,7 +187,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
  */
 #define prandom_u32()		0
 
-#define PAGE_CACHE_SIZE		getpagesize()
+#define PAGE_SIZE		getpagesize()
 
 static inline int __do_div(unsigned long long *n, unsigned base)
 {
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 0388950..18ea010 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -193,6 +193,7 @@ libxfs_trans_reserve(
 	if (blocks > 0) {
 		if (mpsb->sb_fdblocks < blocks)
 			return -ENOSPC;
+		tp->t_blk_res += blocks;
 	}
 	/* user space, don't need log/RT stuff (preserve the API though) */
 	return 0;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 40286e4..cbcfd72 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -469,10 +469,7 @@ xfs_bmap_check_leaf_extents(
 		}
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
-	if (bp_release) {
-		bp_release = 0;
-		xfs_trans_brelse(NULL, bp);
-	}
+
 	return;
 
 error0:
@@ -3737,11 +3734,11 @@ xfs_bmap_btalloc(
 		args.prod = align;
 		if ((args.mod = (xfs_extlen_t)do_mod(ap->offset, args.prod)))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
-	} else if (mp->m_sb.sb_blocksize >= PAGE_CACHE_SIZE) {
+	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
 		args.prod = 1;
 		args.mod = 0;
 	} else {
-		args.prod = PAGE_CACHE_SIZE >> mp->m_sb.sb_blocklog;
+		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
 		if ((args.mod = (xfs_extlen_t)(do_mod(ap->offset, args.prod))))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
 	}
@@ -4713,6 +4710,66 @@ error0:
 }
 
 /*
+ * When a delalloc extent is split (e.g., due to a hole punch), the original
+ * indlen reservation must be shared across the two new extents that are left
+ * behind.
+ *
+ * Given the original reservation and the worst case indlen for the two new
+ * extents (as calculated by xfs_bmap_worst_indlen()), split the original
+ * reservation fairly across the two new extents. If necessary, steal available
+ * blocks from a deleted extent to make up a reservation deficiency (e.g., if
+ * ores == 1). The number of stolen blocks is returned. The availability and
+ * subsequent accounting of stolen blocks is the responsibility of the caller.
+ */
+static xfs_filblks_t
+xfs_bmap_split_indlen(
+	xfs_filblks_t			ores,		/* original res. */
+	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
+	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
+	xfs_filblks_t			avail)		/* stealable blocks */
+{
+	xfs_filblks_t			len1 = *indlen1;
+	xfs_filblks_t			len2 = *indlen2;
+	xfs_filblks_t			nres = len1 + len2; /* new total res. */
+	xfs_filblks_t			stolen = 0;
+
+	/*
+	 * Steal as many blocks as we can to try and satisfy the worst case
+	 * indlen for both new extents.
+	 */
+	while (nres > ores && avail) {
+		nres--;
+		avail--;
+		stolen++;
+	}
+
+	/*
+	 * The only blocks available are those reserved for the original
+	 * extent and what we can steal from the extent being removed.
+	 * If this still isn't enough to satisfy the combined
+	 * requirements for the two new extents, skim blocks off of each
+	 * of the new reservations until they match what is available.
+	 */
+	while (nres > ores) {
+		if (len1) {
+			len1--;
+			nres--;
+		}
+		if (nres == ores)
+			break;
+		if (len2) {
+			len2--;
+			nres--;
+		}
+	}
+
+	*indlen1 = len1;
+	*indlen2 = len2;
+
+	return stolen;
+}
+
+/*
  * Called by xfs_bmapi to update file extent records and the btree
  * after removing space (or undoing a delayed allocation).
  */
@@ -4976,28 +5033,29 @@ xfs_bmap_del_extent(
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
+			xfs_filblks_t	stolen;
 			ASSERT(whichfork == XFS_DATA_FORK);
-			temp = xfs_bmap_worst_indlen(ip, temp);
+
+			/*
+			 * Distribute the original indlen reservation across the
+			 * two new extents. Steal blocks from the deleted extent
+			 * if necessary. Stealing blocks simply fudges the
+			 * fdblocks accounting in xfs_bunmapi().
+			 */
+			temp = xfs_bmap_worst_indlen(ip, got.br_blockcount);
+			temp2 = xfs_bmap_worst_indlen(ip, new.br_blockcount);
+			stolen = xfs_bmap_split_indlen(da_old, &temp, &temp2,
+						       del->br_blockcount);
+			da_new = temp + temp2 - stolen;
+			del->br_blockcount -= stolen;
+
+			/*
+			 * Set the reservation for each extent. Warn if either
+			 * is zero as this can lead to delalloc problems.
+			 */
+			WARN_ON_ONCE(!temp || !temp2);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			temp2 = xfs_bmap_worst_indlen(ip, temp2);
 			new.br_startblock = nullstartblock((int)temp2);
-			da_new = temp + temp2;
-			while (da_new > da_old) {
-				if (temp) {
-					temp--;
-					da_new--;
-					xfs_bmbt_set_startblock(ep,
-						nullstartblock((int)temp));
-				}
-				if (da_new == da_old)
-					break;
-				if (temp2) {
-					temp2--;
-					da_new--;
-					new.br_startblock =
-						nullstartblock((int)temp2);
-				}
-			}
 		}
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
@@ -5202,7 +5260,7 @@ xfs_bunmapi(
 			 * This is better than zeroing it.
 			 */
 			ASSERT(del.br_state == XFS_EXT_NORM);
-			ASSERT(xfs_trans_get_block_res(tp) > 0);
+			ASSERT(tp->t_blk_res > 0);
 			/*
 			 * If this spans a realtime extent boundary,
 			 * chop it back to the start of the one we end at.
@@ -5233,7 +5291,7 @@ xfs_bunmapi(
 				del.br_startblock += mod;
 			} else if ((del.br_startoff == start &&
 				    (del.br_state == XFS_EXT_UNWRITTEN ||
-				     xfs_trans_get_block_res(tp) == 0)) ||
+				     tp->t_blk_res == 0)) ||
 				   !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 				/*
 				 * Can't make it unwritten.  There isn't
@@ -5288,9 +5346,37 @@ xfs_bunmapi(
 				goto nodelete;
 			}
 		}
+
+		/*
+		 * If it's the case where the directory code is running
+		 * with no block reservation, and the deleted block is in
+		 * the middle of its extent, and the resulting insert
+		 * of an extent would cause transformation to btree format,
+		 * then reject it.  The calling code will then swap
+		 * blocks around instead.
+		 * We have to do this now, rather than waiting for the
+		 * conversion to btree format, since the transaction
+		 * will be dirty.
+		 */
+		if (!wasdel && tp->t_blk_res == 0 &&
+		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
+			XFS_IFORK_MAXEXT(ip, whichfork) &&
+		    del.br_startoff > got.br_startoff &&
+		    del.br_startoff + del.br_blockcount <
+		    got.br_startoff + got.br_blockcount) {
+			error = -ENOSPC;
+			goto error0;
+		}
+
+		/*
+		 * Unreserve quota and update realtime free space, if
+		 * appropriate. If delayed allocation, update the inode delalloc
+		 * counter now and wait to update the sb counters as
+		 * xfs_bmap_del_extent() might need to borrow some blocks.
+		 */
 		if (wasdel) {
 			ASSERT(startblockval(del.br_startblock) > 0);
-			/* Update realtime/data freespace, unreserve quota */
 			if (isrt) {
 				xfs_filblks_t rtexts;
 
@@ -5301,8 +5387,6 @@ xfs_bunmapi(
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount,
-						 false);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
@@ -5313,32 +5397,16 @@ xfs_bunmapi(
 					XFS_BTCUR_BPRV_WASDEL;
 		} else if (cur)
 			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
-		/*
-		 * If it's the case where the directory code is running
-		 * with no block reservation, and the deleted block is in
-		 * the middle of its extent, and the resulting insert
-		 * of an extent would cause transformation to btree format,
-		 * then reject it.  The calling code will then swap
-		 * blocks around instead.
-		 * We have to do this now, rather than waiting for the
-		 * conversion to btree format, since the transaction
-		 * will be dirty.
-		 */
-		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
-		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
-			XFS_IFORK_MAXEXT(ip, whichfork) &&
-		    del.br_startoff > got.br_startoff &&
-		    del.br_startoff + del.br_blockcount <
-		    got.br_startoff + got.br_blockcount) {
-			error = -ENOSPC;
-			goto error0;
-		}
+
 		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
 				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
+
+		if (!isrt && wasdel)
+			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
+
 		bno = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index a63379b..022d4b6 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -458,7 +458,7 @@ xfs_bmbt_alloc_block(
 		 * reservation amount is insufficient then we may fail a
 		 * block allocation here and corrupt the filesystem.
 		 */
-		args.minleft = xfs_trans_get_block_res(args.tp);
+		args.minleft = args.tp->t_blk_res;
 	} else if (cur->bc_private.b.flist->xbf_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -467,7 +467,7 @@ xfs_bmbt_alloc_block(
 
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
+	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
 	}
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 04fecf1..b75b432 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2232,6 +2232,9 @@ xfs_dir2_node_trim_free(
 
 	dp = args->dp;
 	tp = args->trans;
+
+	*rvalp = 0;
+
 	/*
 	 * Read the freespace block.
 	 */
@@ -2252,7 +2255,6 @@ xfs_dir2_node_trim_free(
 	 */
 	if (freehdr.nused > 0) {
 		xfs_trans_brelse(tp, bp);
-		*rvalp = 0;
 		return 0;
 	}
 	/*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 72e9ff7..4f0e4ee 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2396,8 +2396,8 @@ xfs_ialloc_compute_maxlevels(
 
 	maxleafents = (1LL << XFS_INO_AGINO_BITS(mp)) >>
 		XFS_INODES_PER_CHUNK_LOG;
-	minleafrecs = mp->m_alloc_mnr[0];
-	minnoderecs = mp->m_alloc_mnr[1];
+	minleafrecs = mp->m_inobt_mnr[0];
+	minnoderecs = mp->m_inobt_mnr[1];
 	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
 	for (level = 1; maxblocks > 1; level++)
 		maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
