Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbeD3Fnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:43:41 -0400
Subject: [PATCH 03/13] xfs: delegate dqget input checks to helper function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Apr 2018 22:43:20 -0700
Message-ID: <152506700078.21553.13318579090724249199.stgit@magnolia>
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the dqget input checks to a separate function in preparation for
splitting up the dqget functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 43b0b32effd4..028d0d513cdf 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -753,6 +753,34 @@ xfs_qm_dqget_cache_insert(
 	return 0;
 }
 
+/* Check our input parameters. */
+static int
+xfs_qm_dqget_checks(
+	struct xfs_mount	*mp,
+	uint			type)
+{
+	if (WARN_ON_ONCE(!XFS_IS_QUOTA_RUNNING(mp)))
+		return -ESRCH;
+
+	switch (type) {
+	case XFS_DQ_USER:
+		if (!XFS_IS_UQUOTA_ON(mp))
+			return -ESRCH;
+		return 0;
+	case XFS_DQ_GROUP:
+		if (!XFS_IS_GQUOTA_ON(mp))
+			return -ESRCH;
+		return 0;
+	case XFS_DQ_PROJ:
+		if (!XFS_IS_PQUOTA_ON(mp))
+			return -ESRCH;
+		return 0;
+	default:
+		WARN_ON_ONCE(0);
+		return -EINVAL;
+	}
+}
+
 /*
  * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
  * a locked dquot, doing an allocation (if requested) as needed.
@@ -775,16 +803,10 @@ xfs_qm_dqget(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-	if ((! XFS_IS_UQUOTA_ON(mp) && type == XFS_DQ_USER) ||
-	    (! XFS_IS_PQUOTA_ON(mp) && type == XFS_DQ_PROJ) ||
-	    (! XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
-		return -ESRCH;
-	}
+	error = xfs_qm_dqget_checks(mp, type);
+	if (error)
+		return error;
 
-	ASSERT(type == XFS_DQ_USER ||
-	       type == XFS_DQ_PROJ ||
-	       type == XFS_DQ_GROUP);
 	if (ip) {
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT(xfs_inode_dquot(ip, type) == NULL);

