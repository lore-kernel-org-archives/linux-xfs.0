Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 087C27F5A
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:48:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8199CAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 07MYX2s2Y4a34vyF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:56 -0700 (PDT)
Subject: [PATCH 22/71] xfs: pass bmapi flags through to bmap_del_extent
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:48:51 -0700
Message-ID: <147216893145.4420.4696782319825156598.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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

Pass BMAPI_ flags from bunmapi into bmap_del_extent and extend
BMAPI_REMAP (which means "don't touch the allocator or the quota
accounting") to apply to bunmapi as well.  This will be used to
implement the unmap operation, which will be used by swapext.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |    9 +++++----
 libxfs/xfs_bmap.h |    3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index fab8182..ff99768 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4826,7 +4826,8 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork) /* data or attr fork */
+	int			whichfork, /* data or attr fork */
+	int			bflags)	/* bmapi flags */
 {
 	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
 	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
@@ -5118,7 +5119,7 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx) {
+	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			error = xfs_refcount_decrease_extent(mp, dfops, del);
 			if (error)
@@ -5136,7 +5137,7 @@ xfs_bmap_del_extent(
 	/*
 	 * Adjust quota data.
 	 */
-	if (qfield)
+	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
 	/*
@@ -5461,7 +5462,7 @@ xfs_bunmapi(
 			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
 
 		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
-				&tmp_logflags, whichfork);
+				&tmp_logflags, whichfork, flags);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 42dc49e..4d9b666 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -101,6 +101,9 @@ struct xfs_extent_free_item
  * Map the inode offset to the block given in ap->firstblock.  Primarily
  * used for reflink.  The range must be in a hole, and this flag cannot be
  * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ *
+ * For bunmapi, this flag unmaps the range without adjusting quota, reducing
+ * refcount, or freeing the blocks.
  */
 #define XFS_BMAPI_REMAP		0x100
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
