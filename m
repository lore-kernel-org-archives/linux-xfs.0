Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58586 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAAC0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:26:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012O78Q173875
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:02 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxedxay1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:26:01 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Q1kN003052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:01 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012Q0LL005527
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:00 GMT
Subject: [PATCH 15/20] xfs: dynamically create the realtime rmapbt inode
 when attaching rtdev
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:59 -0800
Message-ID: <154630955961.8108.12563076199863406958.stgit@magnolia>
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

If the administrator asks us to add a realtime volume to an existing
rmap filesystem, we must allocate and attach the rtrmapbt inode to the
system prior to enabling the rt volume.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rtalloc.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8a7cf57d509b..c39221d86936 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -26,6 +26,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -866,6 +867,60 @@ xfs_growfs_rt_alloc(
  * Visible (exported) functions.
  */
 
+
+/* Add a realtime rmap btree inode. */
+int
+xfs_growfs_rt_rmap(
+	struct xfs_mount	*mp)
+{
+	struct xfs_imeta_end	ic;
+	struct xfs_inode	*ip = NULL;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) || mp->m_rrmapip != NULL)
+		return 0;
+
+	/* rtrmapbt requires metadir */
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb))
+		return -EINVAL;
+
+	/* Ensure the path to the rtrmapbt inode exists. */
+	error = xfs_imeta_ensure_dirpath(mp, &XFS_IMETA_RTRMAPBT);
+	if (error)
+		return error;
+
+	/* Create the rtrmapbt inode. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			xfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		return error;
+
+	error = xfs_rtrmapbt_create(&tp, &ic, &ip);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_finish_inode_setup(ip);
+	xfs_imeta_end_update(mp, &ic, error);
+	if (error) {
+		xfs_irele(ip);
+		return error;
+	}
+
+	mp->m_rrmapip = ip;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_imeta_end_update(mp, &ic, error);
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -946,6 +1001,10 @@ xfs_growfs_rt(
 	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
 	if (error)
 		return error;
+	error = xfs_growfs_rt_rmap(mp);
+	if (error)
+		return error;
+
 	/*
 	 * Allocate a new (fake) mount/sb.
 	 */
