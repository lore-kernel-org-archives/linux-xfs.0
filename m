Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfFLGsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:48:22 -0400
Subject: [PATCH 04/14] xfs: bulkstat should copy lastip whenever userspace
 supplies one
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:47:57 -0700
Message-ID: <156032207698.3774243.8898205522589429271.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

When userspace passes in a @lastip pointer we should copy the results
back, even if the @ocount pointer is NULL.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ioctl.c   |   13 ++++++-------
 fs/xfs/xfs_ioctl32.c |   13 ++++++-------
 2 files changed, 12 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d7dfc13f30f5..5ffbdcff3dba 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -768,14 +768,13 @@ xfs_ioc_bulkstat(
 	if (error)
 		return error;
 
-	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -EFAULT;
+	if (bulkreq.lastip != NULL &&
+	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+		return -EFAULT;
 
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -EFAULT;
-	}
+	if (bulkreq.ocount != NULL &&
+	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+		return -EFAULT;
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 614fc6886d24..814ffe6fbab7 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -310,14 +310,13 @@ xfs_compat_ioc_bulkstat(
 	if (error)
 		return error;
 
-	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -EFAULT;
+	if (bulkreq.lastip != NULL &&
+	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+		return -EFAULT;
 
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -EFAULT;
-	}
+	if (bulkreq.ocount != NULL &&
+	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+		return -EFAULT;
 
 	return 0;
 }
