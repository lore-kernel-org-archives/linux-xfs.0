Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAAC0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:26:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012PjmT179590
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:14 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx48q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:26:14 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012QD97023652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:13 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012QCou029011
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:12 GMT
Subject: [PATCH 17/20] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:26:11 -0800
Message-ID: <154630957183.8108.698314922192865780.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
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
 fs/xfs/xfs_fsmap.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3d76a9e35870..b63435b1df2e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -28,6 +28,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 void
@@ -550,7 +551,65 @@ xfs_getfsmap_rtdev_rtbitmap(
 	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
 			info);
 }
-#endif /* CONFIG_XFS_RT */
+
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
+	xfs_btree_del_cursor(bt_cur, error);
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
+#endif
 
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
@@ -854,7 +913,10 @@ xfs_getfsmap(
 #ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 #endif /* CONFIG_XFS_RT */
 
