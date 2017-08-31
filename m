Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48667 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdHaUfI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:35:08 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKZ791015404
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZ753011767
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:07 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZ6x0018576
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:07 GMT
Subject: [PATCH 16/19] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:35:04 -0700
Message-ID: <150421170412.17458.11699552904651014512.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Connect the getfsmap ioctl to the realtime rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 814ed729..b886e62 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -42,6 +42,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 void
@@ -562,6 +563,65 @@ xfs_getfsmap_rtdev_rtbitmap(
 			info);
 }
 
+/* Transform a absolute-startblock rmap (rtdev, logdev) into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_daddr_t			rec_daddr;
+
+	rec_daddr = XFS_FSB_TO_BB(mp, rec->rm_startblock);
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+}
+
+/* Actually query the rtrmap btree. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*bt_cur;
+	int				error;
+
+	/* Query the rtrmapbt */
+	xfs_ilock(mp->m_rrmapip, XFS_ILOCK_SHARED);
+	bt_cur = xfs_rtrmapbt_init_cursor(mp, tp, mp->m_rrmapip);
+	error = xfs_rmap_query_range(bt_cur, &info->low, &info->high,
+			xfs_getfsmap_rtdev_helper, info);
+	if (error)
+		goto err;
+
+	/* Report any gaps at the end of the rtrmapbt */
+	info->last = true;
+	error = xfs_getfsmap_rtdev_helper(bt_cur, &info->high, info);
+	if (error)
+		goto err;
+
+err:
+	xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+						 XFS_BTREE_NOERROR);
+	xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_SHARED);
+	return error;
+}
+
+/* Execute a getfsmap query against the realtime device rmapbt. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	info->missing_owner = XFS_FMR_OWN_FREE;
+	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rmapbt_query,
+			info);
+}
+
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
 __xfs_getfsmap_datadev(
@@ -855,7 +915,10 @@ xfs_getfsmap(
 	}
 	if (mp->m_rtdev_targp) {
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 
 	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),

