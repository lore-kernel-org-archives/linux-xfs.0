Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJP3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:29:43 -0400
Subject: [PATCH 05/14] xfs: delegate dqget input checks to helper function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:29:22 -0700
Message-ID: <152596616281.27525.12348626795138291174.stgit@magnolia>
In-Reply-To: <152596612549.27525.9876256551560849585.stgit@magnolia>
References: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

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
index 299d4ce90ded..1ee05e5ab1d9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -761,6 +761,34 @@ xfs_qm_dqget_cache_insert(
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
@@ -783,16 +811,10 @@ xfs_qm_dqget(
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

