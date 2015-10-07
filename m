Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD80829E82
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:06:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CE23AC007
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:06:54 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id l2NSKi1PLOOryhau (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:06:52 -0700 (PDT)
Subject: [PATCH 15/51] libxfs: add the RMAP CRC to the xfs_magics list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:06:50 -0700
Message-ID: <20151007050650.1504.47762.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c  |    7 +++++--
 libxfs/xfs_shared.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a16ae7d..2138d2d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -39,9 +39,9 @@ kmem_zone_t	*xfs_btree_cur_zone;
  * Btree magic numbers.
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
-	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
+	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
 	  XFS_FIBT_MAGIC },
-	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC,
+	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
 	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
@@ -1113,6 +1113,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_BMAP:
 		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
 		break;
+	case XFS_BTNUM_RMAP:
+		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 84360bb..88efbb4 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -211,6 +211,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_BTREE_REF	3
 #define	XFS_ALLOC_BTREE_REF	2
 #define	XFS_BMAP_BTREE_REF	2
+#define	XFS_RMAP_BTREE_REF	2
 #define	XFS_DIR_BTREE_REF	2
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
