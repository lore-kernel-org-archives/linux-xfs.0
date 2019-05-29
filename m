Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfE2W0n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:26:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM4CG0030647
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:42 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2spxbqcp4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQ1qC164418
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sr31vh8pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:41 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TMQfxT022707
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:41 GMT
Subject: [PATCH 04/11] xfs: bulkstat should copy lastip whenever userspace
 supplies one
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 May 2019 15:26:40 -0700
Message-ID: <155916880004.757870.14054258865473950566.stgit@magnolia>
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
