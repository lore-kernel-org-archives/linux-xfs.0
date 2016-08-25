Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB7358407
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FB3CAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JkfbdXhdDRXMKQh0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:43 -0700 (PDT)
Subject: [PATCH 10/29] xfs: add a realtime flag to the rmap update log redo
	items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:39 -0700
Message-ID: <147216957908.7022.9194503620104116045.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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

Extend the rmap update (RUI) log items with a new realtime flag that
indicates that the updates apply against the realtime rmapbt.  We'll
wire up the actual rmap code later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_log_format.h |    4 +++-
 libxfs/xfs_rmap.c       |   17 ++++++++++-------
 libxfs/xfs_rmap.h       |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 75f9890..34c4cc7 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -647,11 +647,13 @@ struct xfs_map_extent {
 #define XFS_RMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_RMAP_EXTENT_BMBT_BLOCK	(1U << 30)
 #define XFS_RMAP_EXTENT_UNWRITTEN	(1U << 29)
+#define XFS_RMAP_EXTENT_REALTIME	(1U << 28)
 
 #define XFS_RMAP_EXTENT_FLAGS		(XFS_RMAP_EXTENT_TYPE_MASK | \
 					 XFS_RMAP_EXTENT_ATTR_FORK | \
 					 XFS_RMAP_EXTENT_BMBT_BLOCK | \
-					 XFS_RMAP_EXTENT_UNWRITTEN)
+					 XFS_RMAP_EXTENT_UNWRITTEN | \
+					 XFS_RMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an rui log item in the
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index d5057b3..dc1e3a7 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2203,11 +2203,13 @@ __xfs_rmap_add(
 	enum xfs_rmap_intent_type	type,
 	__uint64_t			owner,
 	int				whichfork,
-	struct xfs_bmbt_irec		*bmap)
+	struct xfs_bmbt_irec		*bmap,
+	bool				realtime)
 {
 	struct xfs_rmap_intent	*ri;
 
-	trace_xfs_rmap_defer(mp, XFS_FSB_TO_AGNO(mp, bmap->br_startblock),
+	trace_xfs_rmap_defer(mp, realtime ? NULLAGNUMBER :
+			XFS_FSB_TO_AGNO(mp, bmap->br_startblock),
 			type,
 			XFS_FSB_TO_AGBNO(mp, bmap->br_startblock),
 			owner, whichfork,
@@ -2221,6 +2223,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = realtime;
 
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 	return 0;
@@ -2240,7 +2243,7 @@ xfs_rmap_map_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Unmap an extent out of a file. */
@@ -2257,7 +2260,7 @@ xfs_rmap_unmap_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Convert a data fork extent from unwritten to real or vice versa. */
@@ -2274,7 +2277,7 @@ xfs_rmap_convert_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Schedule the creation of an rmap for non-file data. */
@@ -2298,7 +2301,7 @@ xfs_rmap_alloc_extent(
 	bmap.br_state = XFS_EXT_NORM;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_ALLOC, owner,
-			XFS_DATA_FORK, &bmap);
+			XFS_DATA_FORK, &bmap, false);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
@@ -2322,7 +2325,7 @@ xfs_rmap_free_extent(
 	bmap.br_state = XFS_EXT_NORM;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
-			XFS_DATA_FORK, &bmap);
+			XFS_DATA_FORK, &bmap, false);
 }
 
 /* Is there a record covering a given extent? */
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 3574377..0850310 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -180,6 +180,7 @@ struct xfs_rmap_intent {
 	__uint64_t				ri_owner;
 	int					ri_whichfork;
 	struct xfs_bmbt_irec			ri_bmap;
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
