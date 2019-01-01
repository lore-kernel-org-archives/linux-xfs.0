Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbfAACRz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012DnfY018635
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:54 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp781-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:54 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012HrwO021508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:53 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012HrCn000846
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:53 GMT
Subject: [PATCH 10/12] xfs: force inactivation before fallocate when space
 is low
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:52 -0800
Message-ID: <154630907242.16693.12710819379298518271.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we think that inactivation will free enough blocks to make it easier
to satisfy an fallocate request, force inactivation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index aa7f7fe241ec..aa7a678d4874 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -33,6 +33,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_refcount.h"
+#include "xfs_sb.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -839,6 +840,38 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * If we suspect that the target device isn't going to be able to satisfy the
+ * entire request, try forcing inode inactivation to free up space.
+ */
+static void
+xfs_alloc_reclaim_inactive_space(
+	struct xfs_mount	*mp,
+	bool			is_rt,
+	xfs_filblks_t		allocatesize_fsb)
+{
+	struct xfs_perag	*pag;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_extlen_t		free;
+	xfs_agnumber_t		agno;
+
+	if (is_rt) {
+		if (sbp->sb_frextents * sbp->sb_rextsize >= allocatesize_fsb)
+			return;
+	} else {
+		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+			pag = xfs_perag_get(mp, agno);
+			free = pag->pagf_freeblks;
+			xfs_perag_put(pag);
+
+			if (free >= allocatesize_fsb)
+				return;
+		}
+	}
+
+	xfs_inactive_force(mp);
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
@@ -925,6 +958,8 @@ xfs_alloc_file_space(
 			quota_flag = XFS_QMOPT_RES_REGBLKS;
 		}
 
+		xfs_alloc_reclaim_inactive_space(mp, rt, allocatesize_fsb);
+
 		/*
 		 * Allocate and setup the transaction.
 		 */
