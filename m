Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754420AbeDBT4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 15:56:50 -0400
Subject: [PATCH 05/21] xfs: add BMAPI_NORMAP flag to perform block remapping
 without updating rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 02 Apr 2018 12:56:47 -0700
Message-ID: <152269900729.16346.3322708934701882860.stgit@magnolia>
In-Reply-To: <152269897182.16346.1710955088267364781.stgit@magnolia>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new flag, XFS_BMAPI_NORMAP, which will perform file block
remapping without updating the rmapbt.  This will be used by the repair
code to reconstruct bmbts from the rmapbt, in which case we don't want
the rmapbt update.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   25 ++++++++++++++++---------
 fs/xfs/libxfs/xfs_bmap.h |    6 +++++-
 2 files changed, 21 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3b03d88..519ef9c 100644
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
@@ -4565,7 +4572,7 @@ xfs_bmapi_remap(
 	got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &icur,
-			&cur, &got, &firstblock, dfops, &logflags);
+			&cur, &got, &firstblock, dfops, &logflags, 0);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f3be641..7cbc9c0 100644
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

