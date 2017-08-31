Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48360 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdHaUeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:34:23 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKYMZg014596
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKYMMd032671
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:22 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKYMbR024343
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:22 GMT
Subject: [PATCH 09/19] xfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:34:20 -0700
Message-ID: <150421166007.17458.12558380953001911329.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

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
index 8372e9b..73d3c65 100644
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
index bf63a25..efcd63d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2246,11 +2246,13 @@ __xfs_rmap_add(
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
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
@@ -2264,6 +2266,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = realtime;
 
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 	return 0;
@@ -2283,7 +2286,7 @@ xfs_rmap_map_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Unmap an extent out of a file. */
@@ -2300,7 +2303,7 @@ xfs_rmap_unmap_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Convert a data fork extent from unwritten to real or vice versa. */
@@ -2317,7 +2320,7 @@ xfs_rmap_convert_extent(
 
 	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Schedule the creation of an rmap for non-file data. */
@@ -2341,7 +2344,7 @@ xfs_rmap_alloc_extent(
 	bmap.br_state = XFS_EXT_NORM;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_ALLOC, owner,
-			XFS_DATA_FORK, &bmap);
+			XFS_DATA_FORK, &bmap, false);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
@@ -2365,7 +2368,7 @@ xfs_rmap_free_extent(
 	bmap.br_state = XFS_EXT_NORM;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
-			XFS_DATA_FORK, &bmap);
+			XFS_DATA_FORK, &bmap, false);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 8b1791e..1e58e02 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -182,6 +182,7 @@ struct xfs_rmap_intent {
 	uint64_t				ri_owner;
 	int					ri_whichfork;
 	struct xfs_bmbt_irec			ri_bmap;
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index f3b139c..13490b5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -428,6 +428,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	bool				rt;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -481,6 +482,7 @@ xfs_rui_recover(
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 		whichfork = (rmap->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
 				XFS_ATTR_FORK : XFS_DATA_FORK;
+		rt = !!(rmap->me_flags & XFS_RMAP_EXTENT_REALTIME);
 		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 		case XFS_RMAP_EXTENT_MAP:
 			type = XFS_RMAP_MAP;
@@ -513,7 +515,7 @@ xfs_rui_recover(
 		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
-				rmap->me_len, state, &rcur);
+				rmap->me_len, state, rt, &rcur);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6bdad6f..cef1971 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -247,7 +247,7 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
 		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		xfs_exntst_t state, bool rt, struct xfs_btree_cur **pcur);
 
 /* refcount updates */
 enum xfs_refcount_intent_type;
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 9b577be..aab0d31 100644
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

