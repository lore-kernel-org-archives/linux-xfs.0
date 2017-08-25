Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41863 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbdHYWR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:17:27 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMHQWh013389
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMHQWV022353
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:26 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMHQVV009070
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:26 GMT
Subject: [PATCH 05/19] xfs: add BMAPI_NORMAP flag to perform block remapping
 without updating rmpabt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:17:24 -0700
Message-ID: <150369944480.9957.24315921266715864.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_bmap.c |   57 +++++++++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_bmap.h |   10 +++++++-
 2 files changed, 45 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c09c16b..2a58e1a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2101,9 +2101,12 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2845,7 +2848,8 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	*new,
 	xfs_fsblock_t		*first,
 	struct xfs_defer_ops	*dfops,
-	int			*logflagsp)
+	int			*logflagsp,
+	int			flags)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -3059,9 +3063,11 @@ xfs_bmap_add_extent_hole_real(
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
@@ -4293,7 +4299,8 @@ xfs_bmapi_allocate(
 	else
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->idx, &bma->cur, &bma->got,
-				bma->firstblock, bma->dfops, &bma->logflags);
+				bma->firstblock, bma->dfops, &bma->logflags,
+				bma->flags);
 
 	bma->logflags |= tmp_logflags;
 	if (error)
@@ -4670,30 +4677,37 @@ xfs_bmapi_write(
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
 	xfs_extnum_t		idx;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 	int			logflags = 0, error;
 
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!(flags & (XFS_BMAPI_DELALLOC | XFS_BMAPI_COWFORK |
+			  XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT |
+			  XFS_BMAPI_IGSTATE | XFS_BMAPI_METADATA |
+			  XFS_BMAPI_ENTIRE)));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4703,7 +4717,7 @@ xfs_bmapi_remap(
 		return -EIO;
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
 			return error;
 	}
@@ -4718,7 +4732,7 @@ xfs_bmapi_remap(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
-		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = firstblock;
 		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
@@ -4727,18 +4741,19 @@ xfs_bmapi_remap(
 	got.br_startoff = bno;
 	got.br_startblock = startblock;
 	got.br_blockcount = len;
-	got.br_state = XFS_EXT_NORM;
+	got.br_state = (flags & XFS_BMAPI_PREALLOC) ? XFS_EXT_UNWRITTEN :
+						      XFS_EXT_NORM;
 
-	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &idx, &cur,
-			&got, &firstblock, dfops, &logflags);
+	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &idx, &cur,
+			&got, &firstblock, dfops, &logflags, flags);
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
 
@@ -6535,7 +6550,7 @@ xfs_bmap_finish_one(
 	switch (type) {
 	case XFS_BMAP_MAP:
 		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
-				startblock, dfops);
+				startblock, dfops, 0);
 		*blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 851982a..d6cb130 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -113,6 +113,9 @@ struct xfs_extent_free_item
 /* Only convert delalloc space, don't allocate entirely new extents */
 #define XFS_BMAPI_DELALLOC	0x400
 
+/* Don't update the rmap btree. */
+#define XFS_BMAPI_NORMAP	0x800
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -124,7 +127,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
-	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }
+	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
+	{ XFS_BMAPI_NORMAP,	"NORMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)
@@ -277,4 +281,8 @@ int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
 
+int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
+		struct xfs_defer_ops *dfops, int flags);
+
 #endif	/* __XFS_BMAP_H__ */

