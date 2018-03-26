Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeCZX42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 19:56:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2QNpjY9005263
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:27 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2gyawe8097-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuRgh008932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:27 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuR20022820
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:27 GMT
Subject: [PATCH 05/20] xfs: add BMAPI_NORMAP flag to perform block remapping
 without updating rmpabt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 26 Mar 2018 16:56:25 -0700
Message-ID: <152210858579.13184.11212409465147497211.stgit@magnolia>
In-Reply-To: <152210855435.13184.6475770131389744177.stgit@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new flag, XFS_BMAPI_NORMAP, which will perform file block
remapping without updating the rmapbt.  This will be used by the repair
code to reconstruct bmbts from the rmapbt, in which case we don't want
the rmapbt update.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   59 ++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap.h |   10 +++++++-
 2 files changed, 47 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3b03d88..c676d5c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1998,9 +1998,12 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
-	if (error)
-		goto done;
+	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
+		error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip,
+				whichfork, new);
+		if (error)
+			goto done;
+	}
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -2664,7 +2667,8 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	*new,
 	xfs_fsblock_t		*first,
 	struct xfs_defer_ops	*dfops,
-	int			*logflagsp)
+	int			*logflagsp,
+	int			flags)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -2842,9 +2846,11 @@ xfs_bmap_add_extent_hole_real(
 	}
 
 	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, dfops, ip, whichfork, new);
-	if (error)
-		goto done;
+	if (!(flags & XFS_BMAPI_NORMAP)) {
+		error = xfs_rmap_map_extent(mp, dfops, ip, whichfork, new);
+		if (error)
+			goto done;
+	}
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
@@ -4119,7 +4125,8 @@ xfs_bmapi_allocate(
 	else
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
-				bma->firstblock, bma->dfops, &bma->logflags);
+				bma->firstblock, bma->dfops, &bma->logflags,
+				bma->flags);
 
 	bma->logflags |= tmp_logflags;
 	if (error)
@@ -4505,30 +4512,37 @@ xfs_bmapi_write(
 	return error;
 }
 
-static int
+int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		bno,
 	xfs_filblks_t		len,
 	xfs_fsblock_t		startblock,
-	struct xfs_defer_ops	*dfops)
+	struct xfs_defer_ops	*dfops,
+	int			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp;
 	struct xfs_btree_cur	*cur = NULL;
 	xfs_fsblock_t		firstblock = NULLFSBLOCK;
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 	int			logflags = 0, error;
 
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!(flags & (XFS_BMAPI_DELALLOC | XFS_BMAPI_COWFORK |
+			  XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT |
+			  XFS_BMAPI_IGSTATE | XFS_BMAPI_METADATA |
+			  XFS_BMAPI_ENTIRE | XFS_BMAPI_CONVERT_ONLY)));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4538,7 +4552,7 @@ xfs_bmapi_remap(
 		return -EIO;
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
 			return error;
 	}
@@ -4553,7 +4567,7 @@ xfs_bmapi_remap(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
-		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = firstblock;
 		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
@@ -4562,18 +4576,21 @@ xfs_bmapi_remap(
 	got.br_startoff = bno;
 	got.br_startblock = startblock;
 	got.br_blockcount = len;
-	got.br_state = XFS_EXT_NORM;
+	if (flags & XFS_BMAPI_PREALLOC)
+		got.br_state = XFS_EXT_UNWRITTEN;
+	else
+		got.br_state = XFS_EXT_NORM;
 
-	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &icur,
-			&cur, &got, &firstblock, dfops, &logflags);
+	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
+			&cur, &got, &firstblock, dfops, &logflags, flags);
 	if (error)
 		goto error0;
 
-	if (xfs_bmap_wants_extents(ip, XFS_DATA_FORK)) {
+	if (xfs_bmap_wants_extents(ip, whichfork)) {
 		int		tmp_logflags = 0;
 
 		error = xfs_bmap_btree_to_extents(tp, ip, cur,
-			&tmp_logflags, XFS_DATA_FORK);
+			&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
 
@@ -6145,7 +6162,7 @@ xfs_bmap_finish_one(
 	switch (type) {
 	case XFS_BMAP_MAP:
 		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
-				startblock, dfops);
+				startblock, dfops, 0);
 		*blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f3be641..a08ee28 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -116,6 +116,9 @@ struct xfs_extent_free_item
 /* Only convert unwritten extents, don't allocate new blocks */
 #define XFS_BMAPI_CONVERT_ONLY	0x800
 
+/* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
+#define XFS_BMAPI_NORMAP	0x1000
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -128,7 +131,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
 	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
-	{ XFS_BMAPI_CONVERT_ONLY, "CONVERT_ONLY" }
+	{ XFS_BMAPI_CONVERT_ONLY, "CONVERT_ONLY" }, \
+	{ XFS_BMAPI_NORMAP,	"NORMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)
@@ -277,4 +281,8 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
 
+int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
+		struct xfs_defer_ops *dfops, int flags);
+
 #endif	/* __XFS_BMAP_H__ */

