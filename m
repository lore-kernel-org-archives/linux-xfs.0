Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeIZQ3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAE9d3079744
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:28 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mndpphg67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:28 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHMhh020297
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:22 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHMKa014107
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:22 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 10/28] xfs: Add attr context to log item
Date: Wed, 26 Sep 2018 03:14:49 -0700
Message-Id: <1537956907-10244-11-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch modifies xfs_attr_item to store a xfs_da_args, a xfs_buf pointer
and a new state type. We will use these in the next patch when
we modify xfs_set_attr_args to roll transactions by returning EAGAIN.
Because the subroutines of this function modify the contents of these
structures, we need to find a place to store them where they remain
instantiated across multiple calls to xfs_set_attr_args.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 17 ++++++++++++++++-
 fs/xfs/scrub/common.c    |  2 ++
 fs/xfs/xfs_acl.c         |  2 ++
 fs/xfs/xfs_attr_item.c   |  2 +-
 fs/xfs/xfs_ioctl.c       |  2 ++
 fs/xfs/xfs_ioctl32.c     |  2 ++
 fs/xfs/xfs_iops.c        |  1 +
 fs/xfs/xfs_xattr.c       |  1 +
 8 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b85c9c7..38334e0 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -77,6 +77,12 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 	char	a_name[1];	/* attr name (NULL terminated) */
 } attrlist_ent_t;
 
+/* Attr state machine types */
+typedef enum {
+	XFS_ATTR_STATE1 = 1,
+	XFS_ATTR_STATE2 = 2,
+} xfs_attr_state_t;
+
 /*
  * List of attrs to commit later.
  */
@@ -88,7 +94,16 @@ struct xfs_attr_item {
 	void*		  xattri_name;	      /* attr name */
 	uint32_t	  xattri_name_len;    /* length of name */
 	uint32_t	  xattri_flags;       /* attr flags */
-	struct list_head  xattri_list;
+
+	/*
+	 * Delayed attr parameters that need to remain instantiated
+	 * across transaction rolls during the defer finish
+	 */
+	struct xfs_buf		*xattri_leaf_bp;  /* Leaf buf to release */
+	xfs_attr_state_t	xattri_state;	  /* state machine marker */
+	struct xfs_da_args	xattri_args;	  /* args context */
+
+	struct list_head	xattri_list;
 
 	/*
 	 * A byte array follows the header containing the file name and
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 346b02a..5d07411 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -30,6 +30,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "scrub/xfs_scrub.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 8039e35..48166df 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -10,6 +10,8 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_acl.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include <linux/slab.h>
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index dc09b52..56fc0b0 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -30,10 +30,10 @@
 #include "xfs_rmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_attr.h"
 #include "xfs_shared.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_attr.h"
 
 static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
 {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0ef5ece..6cd9218 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -16,6 +16,8 @@
 #include "xfs_rtalloc.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fba115f..42889fc 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -21,6 +21,8 @@
 #include "xfs_fsops.h"
 #include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c3e74f9..638020b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -17,6 +17,7 @@
 #include "xfs_acl.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 63ee1d5..031f720 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -11,6 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_acl.h"
-- 
2.7.4
