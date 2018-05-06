Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbeEFR1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 May 2018 13:27:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w46HRDDi128390
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hs426a11k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 May 2018 17:27:13 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w46HRDKF011000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:13 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w46HRCse014580
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:12 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 21/21] xfs: Add delayed attributes error tag
Date: Sun,  6 May 2018 10:24:54 -0700
Message-Id: <1525627494-12873-22-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test
delayed attribute recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 5 ++++-
 fs/xfs/xfs_error.c           | 3 +++
 fs/xfs/xfs_trans_attr.c      | 8 ++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index bc1789d..f606ab6 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -65,7 +65,8 @@
 #define XFS_ERRTAG_LOG_BAD_CRC				29
 #define XFS_ERRTAG_LOG_ITEM_PIN				30
 #define XFS_ERRTAG_BUF_LRU_REF				31
-#define XFS_ERRTAG_MAX					32
+#define XFS_ERRTAG_DELAYED_ATTR			32
+#define XFS_ERRTAG_MAX					33
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -102,5 +103,7 @@
 #define XFS_RANDOM_LOG_BAD_CRC				1
 #define XFS_RANDOM_LOG_ITEM_PIN				1
 #define XFS_RANDOM_BUF_LRU_REF				2
+#define XFS_RANDOM_DELAYED_ATTR			1
 
 #endif /* __XFS_ERRORTAG_H_ */
+
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a63f508..0752f20 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -61,6 +61,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_LOG_BAD_CRC,
 	XFS_RANDOM_LOG_ITEM_PIN,
 	XFS_RANDOM_BUF_LRU_REF,
+	XFS_RANDOM_DELAYED_ATTR,
 };
 
 struct xfs_errortag_attr {
@@ -167,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
+XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -201,6 +203,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
+	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
index d1d75bb..7ea0880 100644
--- a/fs/xfs/xfs_trans_attr.c
+++ b/fs/xfs/xfs_trans_attr.c
@@ -35,6 +35,8 @@
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "xfs_quota.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
 
 /*
  * This routine is called to allocate an "extent free done"
@@ -108,6 +110,11 @@ xfs_trans_attr(
 	if (error)
 		return error;
 
+	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op_flags) {
 		case XFS_ATTR_OP_FLAGS_SET:
 			args.op_flags |= XFS_DA_OP_ADDNAME;
@@ -122,6 +129,7 @@ xfs_trans_attr(
 			error = -EFSCORRUPTED;
 	}
 
+out:
 	if (error) {
 		xfs_defer_cancel(&dfops);
 	        if (leaf_bp)
-- 
2.7.4

