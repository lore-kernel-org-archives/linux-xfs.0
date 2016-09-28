Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20180 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964876AbcI1C7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:59:23 -0400
Subject: [PATCH 53/63] xfs: add shared rmap map/unmap/convert log item types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:59:19 -0700
Message-ID: <147503155966.30303.5060400359176421058.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Wire up some rmap log redo item type codes to map, unmap, or convert
shared data block extents.  The actual log item recovery comes in a
later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |    3 +++
 fs/xfs/xfs_rmap_item.c         |    3 +++
 fs/xfs/xfs_trans_rmap.c        |    9 +++++++++
 3 files changed, 15 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 38af2c8..f9d09ec 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -635,8 +635,11 @@ struct xfs_map_extent {
 
 /* rmap me_flags: upper bits are flags, lower byte is type code */
 #define XFS_RMAP_EXTENT_MAP		1
+#define XFS_RMAP_EXTENT_MAP_SHARED	2
 #define XFS_RMAP_EXTENT_UNMAP		3
+#define XFS_RMAP_EXTENT_UNMAP_SHARED	4
 #define XFS_RMAP_EXTENT_CONVERT		5
+#define XFS_RMAP_EXTENT_CONVERT_SHARED	6
 #define XFS_RMAP_EXTENT_ALLOC		7
 #define XFS_RMAP_EXTENT_FREE		8
 #define XFS_RMAP_EXTENT_TYPE_MASK	0xFF
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0432a45..19d817e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -441,8 +441,11 @@ xfs_rui_recover(
 				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 		case XFS_RMAP_EXTENT_MAP:
+		case XFS_RMAP_EXTENT_MAP_SHARED:
 		case XFS_RMAP_EXTENT_UNMAP:
+		case XFS_RMAP_EXTENT_UNMAP_SHARED:
 		case XFS_RMAP_EXTENT_CONVERT:
+		case XFS_RMAP_EXTENT_CONVERT_SHARED:
 		case XFS_RMAP_EXTENT_ALLOC:
 		case XFS_RMAP_EXTENT_FREE:
 			op_ok = true;
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 5a50ef8..9ead064 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -48,12 +48,21 @@ xfs_trans_set_rmap_flags(
 	case XFS_RMAP_MAP:
 		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
 		break;
+	case XFS_RMAP_MAP_SHARED:
+		rmap->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
+		break;
 	case XFS_RMAP_UNMAP:
 		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
 		break;
+	case XFS_RMAP_UNMAP_SHARED:
+		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
+		break;
 	case XFS_RMAP_CONVERT:
 		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
 		break;
+	case XFS_RMAP_CONVERT_SHARED:
+		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
+		break;
 	case XFS_RMAP_ALLOC:
 		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
 		break;

