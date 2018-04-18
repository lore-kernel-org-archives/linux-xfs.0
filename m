Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49818 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:48 -0400
Subject: [PATCH 6/9] xfs: add BMAPI_NORMAP flag to perform block remapping
 without updating rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:29 -0700
Message-ID: <152401928967.11792.13559881375675511571.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new flag, XFS_BMAPI_NORMAP, which will perform file block
remapping without updating the rmapbt.  This will be used by the repair
code to reconstruct bmbts from the rmapbt, in which case we don't want
the rmapbt update.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   29 ++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.h |    6 +++++-
 2 files changed, 23 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a7c2f0..ee07c2d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1997,10 +1997,13 @@ xfs_bmap_add_extent_delay_real(
 		ASSERT(0);
 	}
 
-	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
-	if (error)
-		goto done;
+	/* add reverse mapping unless caller opted out */
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
@@ -2841,10 +2845,12 @@ xfs_bmap_add_extent_hole_real(
 		break;
 	}
 
-	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, dfops, ip, whichfork, new);
-	if (error)
-		goto done;
+	/* add reverse mapping unless caller opted out */
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
@@ -4565,7 +4572,7 @@ xfs_bmapi_remap(
 	got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &icur,
-			&cur, &got, &firstblock, dfops, &logflags);
+			&cur, &got, &firstblock, dfops, &logflags, 0);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2b766b3..5c9675a 100644
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

