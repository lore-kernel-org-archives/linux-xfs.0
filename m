Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbfAACZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:25:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012OQQx024367
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:20 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp7dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:25:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012PKhL001538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:20 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012PJcn005229
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:19 GMT
Subject: [PATCH 09/20] xfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:18 -0800
Message-ID: <154630951849.8108.6567404795735656814.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_refcount.c   |    4 ++--
 fs/xfs/libxfs/xfs_rmap.c       |   24 +++++++++++++++---------
 fs/xfs/libxfs/xfs_rmap.h       |    5 +++--
 fs/xfs/xfs_rmap_item.c         |    4 +++-
 fs/xfs/xfs_trans.h             |    2 +-
 fs/xfs/xfs_trans_rmap.c        |    9 +++++++--
 7 files changed, 34 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..c8184a0d9290 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -637,11 +637,13 @@ struct xfs_map_extent {
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
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 198f0c96ccae..9e07350159bd 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1560,7 +1560,7 @@ xfs_refcount_alloc_cow_extent(
 		return error;
 
 	/* Add rmap entry */
-	return xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	return xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW, false);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1577,7 +1577,7 @@ xfs_refcount_free_cow_extent(
 		return 0;
 
 	/* Remove rmap entry */
-	error = xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	error = xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW, false);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 1ba04510b9d0..0031799ac45f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2331,11 +2331,12 @@ __xfs_rmap_add(
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
 	int				whichfork,
-	struct xfs_bmbt_irec		*bmap)
+	struct xfs_bmbt_irec		*bmap,
+	bool				realtime)
 {
 	struct xfs_rmap_intent		*ri;
 
-	trace_xfs_rmap_defer(tp->t_mountp,
+	trace_xfs_rmap_defer(tp->t_mountp, realtime ? NULLAGNUMBER :
 			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
 			type,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
@@ -2350,6 +2351,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = realtime;
 
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 	return 0;
@@ -2368,7 +2370,7 @@ xfs_rmap_map_extent(
 
 	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Unmap an extent out of a file. */
@@ -2384,7 +2386,7 @@ xfs_rmap_unmap_extent(
 
 	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /*
@@ -2406,7 +2408,7 @@ xfs_rmap_convert_extent(
 
 	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Schedule the creation of an rmap for non-file data. */
@@ -2415,7 +2417,8 @@ xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
 	xfs_fsblock_t		fsbno,
 	xfs_filblks_t		len,
-	uint64_t		owner)
+	uint64_t		owner,
+	bool			isrt)
 {
 	struct xfs_bmbt_irec	bmap;
 
@@ -2427,7 +2430,8 @@ xfs_rmap_alloc_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	return __xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap);
+	return __xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap,
+			isrt);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
@@ -2436,7 +2440,8 @@ xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
 	xfs_fsblock_t		fsbno,
 	xfs_filblks_t		len,
-	uint64_t		owner)
+	uint64_t		owner,
+	bool			isrt)
 {
 	struct xfs_bmbt_irec	bmap;
 
@@ -2448,7 +2453,8 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	return __xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	return __xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap,
+			isrt);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 2edb6e93860a..92be7585b4c8 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -158,6 +158,7 @@ struct xfs_rmap_intent {
 	uint64_t				ri_owner;
 	int					ri_whichfork;
 	struct xfs_bmbt_irec			ri_bmap;
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
@@ -169,9 +170,9 @@ int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
 int xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
-		xfs_filblks_t len, uint64_t owner);
+		xfs_filblks_t len, uint64_t owner, bool isrt);
 int xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
-		xfs_filblks_t len, uint64_t owner);
+		xfs_filblks_t len, uint64_t owner, bool isrt);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 127dc9c32a54..2fe98a300d0e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -415,6 +415,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	bool				rt;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -469,6 +470,7 @@ xfs_rui_recover(
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 		whichfork = (rmap->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
 				XFS_ATTR_FORK : XFS_DATA_FORK;
+		rt = !!(rmap->me_flags & XFS_RMAP_EXTENT_REALTIME);
 		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 		case XFS_RMAP_EXTENT_MAP:
 			type = XFS_RMAP_MAP;
@@ -501,7 +503,7 @@ xfs_rui_recover(
 		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
-				rmap->me_len, state, &rcur);
+				rmap->me_len, state, rt, &rcur);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9b1bfb3847b4..93143ff2c4e8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -256,7 +256,7 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
 		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		xfs_exntst_t state, bool rt, struct xfs_btree_cur **pcur);
 
 /* refcount updates */
 enum xfs_refcount_intent_type;
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index a42890931ecd..da135e959eb9 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -24,13 +24,16 @@ xfs_trans_set_rmap_flags(
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
@@ -89,6 +92,7 @@ xfs_trans_log_finish_rmap_update(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				rt,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
@@ -177,7 +181,7 @@ xfs_rmap_update_log_item(
 	map->me_startoff = rmap->ri_bmap.br_startoff;
 	map->me_len = rmap->ri_bmap.br_blockcount;
 	xfs_trans_set_rmap_flags(map, rmap->ri_type, rmap->ri_whichfork,
-			rmap->ri_bmap.br_state);
+			rmap->ri_bmap.br_state, rmap->ri_realtime);
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
@@ -209,6 +213,7 @@ xfs_rmap_update_finish_item(
 			rmap->ri_bmap.br_startblock,
 			rmap->ri_bmap.br_blockcount,
 			rmap->ri_bmap.br_state,
+			rmap->ri_realtime,
 			(struct xfs_btree_cur **)state);
 	kmem_free(rmap);
 	return error;
