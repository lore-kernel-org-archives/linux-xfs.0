Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89A7B29DF9
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:06:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C33D8F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hHmGF2x70FWLFRKr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:23 -0800 (PST)
Subject: [PATCH 14/53] libxfs: add the RMAP CRC to the xfs_magics list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:06:20 -0800
Message-ID: <20151219090620.14255.32547.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
index f28e3a5..5cf8ee5 100644
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
@@ -1125,6 +1125,9 @@ xfs_btree_set_refs(
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
index f756920..fa2bb9b 100644
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
