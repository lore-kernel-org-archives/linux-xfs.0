Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbeIZQ3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QADww1029226
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mnvtur88q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHTxm026528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:29 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAHTCB014224
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:29 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 28/28] xfs: Add delayed attributes error tag
Date: Wed, 26 Sep 2018 03:15:07 -0700
Message-Id: <1537956907-10244-29-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test
delayed attribute recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 fs/xfs/xfs_trans_attr.c      | 8 ++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 66077a1..5cd408d0 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -54,7 +54,8 @@
 #define XFS_ERRTAG_BUF_LRU_REF				31
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
-#define XFS_ERRTAG_MAX					34
+#define XFS_ERRTAG_DELAYED_ATTR				34
+#define XFS_ERRTAG_MAX					35
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -93,5 +94,6 @@
 #define XFS_RANDOM_BUF_LRU_REF				2
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9866f54..5193ba9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -51,6 +51,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BUF_LRU_REF,
 	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
+	XFS_RANDOM_DELAYED_ATTR,
 };
 
 struct xfs_errortag_attr {
@@ -159,6 +160,7 @@ XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
+XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -195,6 +197,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
+	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
index 7e20721..1b14830 100644
--- a/fs/xfs/xfs_trans_attr.c
+++ b/fs/xfs/xfs_trans_attr.c
@@ -35,6 +35,8 @@
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "xfs_quota.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
 
 /*
  * This routine is called to allocate an "attr free done"
@@ -77,6 +79,11 @@ xfs_trans_attr(
 	if (error)
 		return error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op_flags) {
 		case XFS_ATTR_OP_FLAGS_SET:
 			args->op_flags |= XFS_DA_OP_ADDNAME;
@@ -91,6 +98,7 @@ xfs_trans_attr(
 			error = -EFSCORRUPTED;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
-- 
2.7.4
