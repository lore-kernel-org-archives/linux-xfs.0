Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3DB28024
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:44:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76A34304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bX2spJI8NUiUd8Ak (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:34 -0700 (PDT)
Subject: [PATCH 10/20] xfs: add a realtime flag to the rmap update log redo
	items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:44:30 -0700
Message-ID: <147216867011.3688.5459904823282801857.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/libxfs/xfs_rmap.c       |   17 ++++++++++-------
 fs/xfs/libxfs/xfs_rmap.h       |    1 +
 fs/xfs/xfs_rmap_item.c         |    4 +++-
 fs/xfs/xfs_trans.h             |    2 +-
 fs/xfs/xfs_trans_rmap.c        |    9 +++++++--
 6 files changed, 25 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 75f9890..34c4cc7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
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
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index c654816..71704d6 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2205,11 +2205,13 @@ __xfs_rmap_add(
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
@@ -2223,6 +2225,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = realtime;
 
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 	return 0;
@@ -2242,7 +2245,7 @@ xfs_rmap_map_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Unmap an extent out of a file. */
@@ -2259,7 +2262,7 @@ xfs_rmap_unmap_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Convert a data fork extent from unwritten to real or vice versa. */
@@ -2276,7 +2279,7 @@ xfs_rmap_convert_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Schedule the creation of an rmap for non-file data. */
@@ -2300,7 +2303,7 @@ xfs_rmap_alloc_extent(
 	bmap.br_state = XFS_EXT_NORM;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_ALLOC, owner,
-			XFS_DATA_FORK, &bmap);
+			XFS_DATA_FORK, &bmap, false);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
@@ -2324,7 +2327,7 @@ xfs_rmap_free_extent(
 	bmap.br_state = XFS_EXT_NORM;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
-			XFS_DATA_FORK, &bmap);
+			XFS_DATA_FORK, &bmap, false);
 }
 
 /* Is there a record covering a given extent? */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 3574377..0850310 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -180,6 +180,7 @@ struct xfs_rmap_intent {
 	__uint64_t				ri_owner;
 	int					ri_whichfork;
 	struct xfs_bmbt_irec			ri_bmap;
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0c96e41..01d6edf 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -445,6 +445,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	bool				rt;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -498,6 +499,7 @@ xfs_rui_recover(
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 		whichfork = (rmap->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
 				XFS_ATTR_FORK : XFS_DATA_FORK;
+		rt = !!(rmap->me_flags & XFS_RMAP_EXTENT_REALTIME);
 		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 		case XFS_RMAP_EXTENT_MAP:
 			type = XFS_RMAP_MAP;
@@ -530,7 +532,7 @@ xfs_rui_recover(
 		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
-				rmap->me_len, state, &rcur);
+				rmap->me_len, state, rt, &rcur);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7a4ea0c..fbd7bc8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -251,7 +251,7 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
 		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		xfs_exntst_t state, bool rt, struct xfs_btree_cur **pcur);
 
 /* refcount updates */
 enum xfs_refcount_intent_type;
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 9ead064..9240157b 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -37,13 +37,16 @@ xfs_trans_set_rmap_flags(
 	struct xfs_map_extent		*rmap,
 	enum xfs_rmap_intent_type	type,
 	int				whichfork,
-	xfs_exntst_t			state)
+	xfs_exntst_t			state,
+	bool				rt)
 {
 	rmap->me_flags = 0;
 	if (state == XFS_EXT_UNWRITTEN)
 		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
 	if (whichfork == XFS_ATTR_FORK)
 		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+	if (rt)
+		rmap->me_flags |= XFS_RMAP_EXTENT_REALTIME;
 	switch (type) {
 	case XFS_RMAP_MAP:
 		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
@@ -102,6 +105,7 @@ xfs_trans_log_finish_rmap_update(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				rt,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
@@ -190,7 +194,7 @@ xfs_rmap_update_log_item(
 	map->me_startoff = rmap->ri_bmap.br_startoff;
 	map->me_len = rmap->ri_bmap.br_blockcount;
 	xfs_trans_set_rmap_flags(map, rmap->ri_type, rmap->ri_whichfork,
-			rmap->ri_bmap.br_state);
+			rmap->ri_bmap.br_state, rmap->ri_realtime);
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
@@ -223,6 +227,7 @@ xfs_rmap_update_finish_item(
 			rmap->ri_bmap.br_startblock,
 			rmap->ri_bmap.br_blockcount,
 			rmap->ri_bmap.br_state,
+			rmap->ri_realtime,
 			(struct xfs_btree_cur **)state);
 	kmem_free(rmap);
 	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
