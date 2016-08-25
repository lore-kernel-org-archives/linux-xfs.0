Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 471F28061
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:45:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18073304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id b2DusGrEfdHBjPPa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:17 -0700 (PDT)
Subject: [PATCH 17/20] xfs: wire up getfsmap to the realtime reverse mapping
	btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:45:13 -0700
Message-ID: <147216871382.3688.13083744368929762457.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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

Connect the getfsmap ioctl to the realtime rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 1c5ce01..a816955 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -41,6 +41,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /* getfsmap query state */
 struct xfs_getfsmap_info {
@@ -431,6 +432,81 @@ xfs_getfsmap_logdev(
 	return xfs_getfsmap_rtdev_helper(&cur, &rmap, info);
 }
 
+/* Execute a getfsmap query against the realtime data device. */
+STATIC int
+xfs_getfsmap_rtdev(
+	struct xfs_mount		*mp,
+	struct getfsmap			*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct getfsmap			*lowkey;
+	struct getfsmap			*highkey;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_daddr_t			eofs;
+	int				error = 0;
+
+	lowkey = keys;
+	highkey = keys + 1;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (lowkey->fmv_block >= eofs)
+		return 0;
+	if (highkey->fmv_block >= eofs)
+		highkey->fmv_block = eofs - 1;
+	start_fsb = XFS_BB_TO_FSBT(mp, lowkey->fmv_block);
+	end_fsb = XFS_BB_TO_FSB(mp, highkey->fmv_block);
+
+	/* Set up search keys */
+	info->low.rm_startblock = start_fsb;
+	info->low.rm_owner = lowkey->fmv_owner;
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, lowkey->fmv_offset);
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, lowkey);
+
+	info->high.rm_startblock = end_fsb;
+	info->high.rm_owner = highkey->fmv_owner;
+	info->high.rm_offset = XFS_BB_TO_FSBT(mp, highkey->fmv_offset);
+	info->high.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->high, highkey);
+
+	info->missing_owner = FMV_OWN_FREE;
+
+	trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
+			info->low.rm_startblock,
+			info->low.rm_blockcount,
+			info->low.rm_owner,
+			info->low.rm_offset);
+
+	trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+			info->high.rm_startblock,
+			info->high.rm_blockcount,
+			info->high.rm_owner,
+			info->high.rm_offset);
+
+	/* Query the rtrmapbt */
+	xfs_ilock(mp->m_rrmapip, XFS_ILOCK_EXCL);
+	bt_cur = xfs_rtrmapbt_init_cursor(mp, NULL, mp->m_rrmapip);
+
+	error = xfs_rmap_query_range(bt_cur, &info->low, &info->high,
+			xfs_getfsmap_rtdev_helper, info);
+	if (error)
+		goto err;
+
+	/* Report any free space at the end of the rtdev */
+	info->last = true;
+	error = xfs_getfsmap_rtdev_helper(bt_cur, &info->high, info);
+	if (error)
+		goto err;
+
+err:
+	xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+						 XFS_BTREE_NOERROR);
+	xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
 /* Execute a getfsmap query against the realtime data device (rtbitmap). */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap(
@@ -769,6 +845,9 @@ xfs_getfsmap_is_valid_device(
 	if (mp->m_logdev_targp &&
 	    fmv->fmv_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
 		return true;
+	if (mp->m_rtdev_targp &&
+	    fmv->fmv_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
+		return true;
 	return false;
 }
 
@@ -824,6 +903,8 @@ xfs_getfsmap(
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
 		if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev;
 	}
 
 	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
