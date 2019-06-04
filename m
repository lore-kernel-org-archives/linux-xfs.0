Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:49:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lndhd060600
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:49 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0qfjua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LmpPG172125
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2swngkkhwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LnmW6024903
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:48 GMT
Subject: [PATCH 03/10] xfs: bulkstat should copy lastip whenever userspace
 supplies one
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:49:47 -0700
Message-ID: <155968498711.1657646.16552958514650953190.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When userspace passes in a @lastip pointer we should copy the results
back, even if the @ocount pointer is NULL.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
