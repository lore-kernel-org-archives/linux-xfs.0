Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36418 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdB1ToR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 14:44:17 -0500
Subject: [PATCH 7/9] xfs: have getfsmap fall back to the freesp btrees when
 rmap is not present
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Feb 2017 10:46:35 -0800
Message-ID: <148830759554.22089.6408995371724685885.stgit@birch.djwong.org>
In-Reply-To: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
References: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the reverse-mapping btree isn't available, fall back to the
free space btrees to provide partial reverse mapping information.
The online scrub tool can make use of even partial information to
speed up the data block scan.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 2d0fa2a..56bbd24 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -40,6 +40,7 @@
 #include "xfs_fsmap.h"
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_alloc_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 void
@@ -158,6 +159,9 @@ xfs_fsmap_owner_from_rmap(
 	case XFS_RMAP_OWN_COW:
 		dest->fmr_owner = XFS_FMR_OWN_COW;
 		break;
+	case XFS_RMAP_OWN_NULL:	/* "free" */
+		dest->fmr_owner = XFS_FMR_OWN_FREE;
+		break;
 	default:
 		return -EFSCORRUPTED;
 	}
@@ -411,6 +415,31 @@ xfs_getfsmap_rtdev_helper(
 	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
 }
 
+/* Transform a bnobt irec into a fsmap */
+STATIC int
+xfs_getfsmap_datadev_bnobt_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	struct xfs_rmap_irec		irec;
+	xfs_fsblock_t			fsb;
+	xfs_daddr_t			rec_daddr;
+
+	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno, rec->ar_startblock);
+	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
+
+	irec.rm_startblock = rec->ar_startblock;
+	irec.rm_blockcount = rec->ar_blockcount;
+	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
+	irec.rm_offset = 0;
+	irec.rm_flags = 0;
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr);
+}
+
 /* Set rmap flags based on the getfsmap flags */
 static void
 xfs_getfsmap_set_irec_flags(
@@ -633,6 +662,51 @@ xfs_getfsmap_datadev_rmapbt(
 			xfs_getfsmap_datadev_rmapbt_end, NULL);
 }
 
+/* Report any gap at the end of bnobt records. */
+STATIC int
+xfs_getfsmap_datadev_bnobt_end(
+	struct xfs_btree_cur		*cur,
+	struct xfs_getfsmap_info	*info,
+	void				*priv)
+{
+	struct xfs_alloc_rec_incore	*key = priv;
+
+	return xfs_getfsmap_datadev_bnobt_helper(cur, key + 1, info);
+}
+
+/* Actually query the bno btree. */
+STATIC int
+xfs_getfsmap_datadev_bnobt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		**curpp,
+	void				*priv)
+{
+	struct xfs_alloc_rec_incore	*key = priv;
+
+	*curpp = xfs_allocbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
+			info->agno, XFS_BTNUM_BNO);
+	key->ar_startblock = info->low.rm_startblock;
+	(key + 1)->ar_startblock = info->high.rm_startblock;
+	return xfs_alloc_query_range(*curpp, key, key + 1,
+			xfs_getfsmap_datadev_bnobt_helper, info);
+}
+
+/* Execute a getfsmap query against the regular data device's bnobt. */
+STATIC int
+xfs_getfsmap_datadev_bnobt(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_alloc_rec_incore	akeys[2];
+
+	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
+	return __xfs_getfsmap_datadev(tp, keys, info,
+			xfs_getfsmap_datadev_bnobt_query,
+			xfs_getfsmap_datadev_bnobt_end, &akeys[0]);
+}
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(
@@ -714,8 +788,6 @@ xfs_getfsmap(
 	int				i;
 	int				error = 0;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return -EOPNOTSUPP;
 	if (head->fmh_iflags & ~FMH_IF_VALID)
 		return -EINVAL;
 	if (!xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[0]) ||
@@ -727,7 +799,10 @@ xfs_getfsmap(
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
 	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
-	handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
+	else
+		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;

