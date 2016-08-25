Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 822437E7D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:38:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45D858F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3ESJmNep2NaHKYXD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:36 -0700 (PDT)
Subject: [PATCH 61/71] xfs: add shared rmap map/unmap/convert log item types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:38:32 -0700
Message-ID: <147216831268.867.9941303230739520022.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
index d788d01..75f9890 100644
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
index 2500f28..f4bf026 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -459,8 +459,11 @@ xfs_rui_recover(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
