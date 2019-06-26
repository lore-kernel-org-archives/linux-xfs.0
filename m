Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49732 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfFZUqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:40 -0400
Subject: [PATCH 03/15] xfs: convert quotacheck to use the new iwalk functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:44:15 -0700
Message-ID: <156158185592.495087.13186738794490297341.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert quotacheck to use the new iwalk iterator to dig through the
inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm.c |   63 +++++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa6b6db3db0e..52e8ec0aa064 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -14,7 +14,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
-#include "xfs_itable.h"
+#include "xfs_iwalk.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
@@ -1118,17 +1118,15 @@ xfs_qm_quotacheck_dqadjust(
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
 
@@ -1136,20 +1134,18 @@ xfs_qm_dqusage_adjust(
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
 
@@ -1157,7 +1153,7 @@ xfs_qm_dqusage_adjust(
 		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 			if (error)
 				goto error0;
 		}
@@ -1200,13 +1196,8 @@ xfs_qm_dqusage_adjust(
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
 
@@ -1270,18 +1261,13 @@ STATIC int
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
@@ -1318,18 +1304,9 @@ xfs_qm_quotacheck(
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
