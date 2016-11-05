Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19239 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754371AbcKEA2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:28:16 -0400
Subject: [PATCH 34/39] xfs: repair inode block maps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:28:13 -0700
Message-ID: <147830569369.4165.912811160069227760.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Use the reverse-mapping btree information to rebuild an inode fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |   20 ++++++++++++--------
 libxfs/xfs_bmap.h |    6 +++++-
 2 files changed, 17 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 0e2f450..53d6848 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -2216,9 +2216,12 @@ xfs_bmap_add_extent_delay_real(
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
@@ -3159,9 +3162,12 @@ xfs_bmap_add_extent_hole_real(
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
@@ -4585,8 +4591,6 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!(flags & XFS_BMAPI_REMAP) || whichfork == XFS_DATA_FORK);
-	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || !(flags & XFS_BMAPI_REMAP));
 	ASSERT(!(flags & XFS_BMAPI_CONVERT) || !(flags & XFS_BMAPI_REMAP));
 	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || whichfork != XFS_COW_FORK);
 	ASSERT(!(flags & XFS_BMAPI_CONVERT) || whichfork != XFS_COW_FORK);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 7cae6ec..9d4754f 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -110,6 +110,9 @@ struct xfs_extent_free_item
 /* Map something in the CoW fork. */
 #define XFS_BMAPI_COWFORK	0x200
 
+/* Don't update the rmap btree. */
+#define XFS_BMAPI_NORMAP	0x400
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -120,7 +123,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
-	{ XFS_BMAPI_COWFORK,	"COWFORK" }
+	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
+	{ XFS_BMAPI_NORMAP,	"NORMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)

