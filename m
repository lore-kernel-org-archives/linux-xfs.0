Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfE2W0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:26:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM3jQD022704
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2spw4tmtan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMPSrH096507
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ss1fnqqqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TMQZhB022678
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:35 GMT
Subject: [PATCH 03/11] xfs: convert quotacheck to use the new iwalk functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 May 2019 15:26:34 -0700
Message-ID: <155916879404.757870.10976871618930441712.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert quotacheck to use the new iwalk iterator to dig through the
inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa6b6db3db0e..a5b2260406a8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
+#include "xfs_iwalk.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1118,17 +1119,15 @@ xfs_qm_quotacheck_dqadjust(
 /* ARGSUSED */
 STATIC int
 xfs_qm_dqusage_adjust(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* not used */
-	int		ubsize,		/* not used */
-	int		*ubused,	/* not used */
-	int		*res)		/* result code value */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	void			*data)
 {
-	xfs_inode_t	*ip;
-	xfs_qcnt_t	nblks;
-	xfs_filblks_t	rtblks = 0;	/* total rt blks */
-	int		error;
+	struct xfs_inode	*ip;
+	xfs_qcnt_t		nblks;
+	xfs_filblks_t		rtblks = 0;	/* total rt blks */
+	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
@@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
 	 * rootino must have its resources accounted for, not so with the quota
 	 * inodes.
 	 */
-	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
-		*res = BULKSTAT_RV_NOTHING;
-		return -EINVAL;
-	}
+	if (xfs_is_quota_inode(&mp->m_sb, ino))
+		return 0;
 
 	/*
 	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
 	 * at mount time and therefore nobody will be racing chown/chproj.
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
-	if (error) {
-		*res = BULKSTAT_RV_NOTHING;
+	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
+	if (error == -EINVAL || error == -ENOENT)
+		return 0;
+	if (error)
 		return error;
-	}
 
 	ASSERT(ip->i_delayed_blks == 0);
 
@@ -1157,7 +1154,7 @@ xfs_qm_dqusage_adjust(
 		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 			if (error)
 				goto error0;
 		}
@@ -1200,13 +1197,8 @@ xfs_qm_dqusage_adjust(
 			goto error0;
 	}
 
-	xfs_irele(ip);
-	*res = BULKSTAT_RV_DIDONE;
-	return 0;
-
 error0:
 	xfs_irele(ip);
-	*res = BULKSTAT_RV_GIVEUP;
 	return error;
 }
 
@@ -1270,18 +1262,13 @@ STATIC int
 xfs_qm_quotacheck(
 	xfs_mount_t	*mp)
 {
-	int			done, count, error, error2;
-	xfs_ino_t		lastino;
-	size_t			structsz;
+	int			error, error2;
 	uint			flags;
 	LIST_HEAD		(buffer_list);
 	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
 	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
 	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
 
-	count = INT_MAX;
-	structsz = 1;
-	lastino = 0;
 	flags = 0;
 
 	ASSERT(uip || gip || pip);
@@ -1318,18 +1305,9 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	do {
-		/*
-		 * Iterate thru all the inodes in the file system,
-		 * adjusting the corresponding dquot counters in core.
-		 */
-		error = xfs_bulkstat(mp, &lastino, &count,
-				     xfs_qm_dqusage_adjust,
-				     structsz, NULL, &done);
-		if (error)
-			break;
-
-	} while (!done);
+	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
+	if (error)
+		goto error_return;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
