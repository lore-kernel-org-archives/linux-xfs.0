Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48594 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbcI3DII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:08 -0400
Subject: [PATCH 22/63] xfs: pass bmapi flags through to bmap_del_extent
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:08:04 -0700
Message-ID: <147520488414.29434.16678847819397941715.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Pass BMAPI_ flags from bunmapi into bmap_del_extent and extend
BMAPI_REMAP (which means "don't touch the allocator or the quota
accounting") to apply to bunmapi as well.  This will be used to
implement the unmap operation, which will be used by swapext.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    9 +++++----
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9f145ed..51124e6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4760,7 +4760,8 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork) /* data or attr fork */
+	int			whichfork, /* data or attr fork */
+	int			bflags)	/* bmapi flags */
 {
 	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
 	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
@@ -5052,7 +5053,7 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx) {
+	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			error = xfs_refcount_decrease_extent(mp, dfops, del);
 			if (error)
@@ -5070,7 +5071,7 @@ xfs_bmap_del_extent(
 	/*
 	 * Adjust quota data.
 	 */
-	if (qfield)
+	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
 	/*
@@ -5395,7 +5396,7 @@ xfs_bunmapi(
 			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
 
 		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
-				&tmp_logflags, whichfork);
+				&tmp_logflags, whichfork, flags);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 877b6f9..89c9c8e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -101,6 +101,9 @@ struct xfs_extent_free_item
  * Map the inode offset to the block given in ap->firstblock.  Primarily
  * used for reflink.  The range must be in a hole, and this flag cannot be
  * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ *
+ * For bunmapi, this flag unmaps the range without adjusting quota, reducing
+ * refcount, or freeing the blocks.
  */
 #define XFS_BMAPI_REMAP		0x100
 

