Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfDLWwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 18:52:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMe17M010456
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rpkhtgtwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMq7sF101125
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2rtyj2ub7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3CMqkop030871
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:46 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 7/9] xfs: Add attr context to log item
Date: Fri, 12 Apr 2019 15:50:34 -0700
Message-Id: <20190412225036.22939-8-allison.henderson@oracle.com>
In-Reply-To: <20190412225036.22939-1-allison.henderson@oracle.com>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.h | 18 +++++++++++++++++-
 fs/xfs/scrub/common.c    |  2 ++
 fs/xfs/xfs_acl.c         |  2 ++
 fs/xfs/xfs_attr_item.c   |  2 +-
 fs/xfs/xfs_ioctl.c       |  2 ++
 fs/xfs/xfs_ioctl32.c     |  2 ++
 fs/xfs/xfs_iops.c        |  1 +
 fs/xfs/xfs_xattr.c       |  1 +
 8 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 974c963..4ce3b0a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -77,6 +77,13 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 	char	a_name[1];	/* attr name (NULL terminated) */
 } attrlist_ent_t;
 
+/* Attr state machine types */
+enum xfs_attr_state {
+	XFS_ATTR_STATE1 = 1,
+	XFS_ATTR_STATE2 = 2,
+	XFS_ATTR_STATE3 = 3,
+};
+
 /*
  * List of attrs to commit later.
  */
@@ -88,7 +95,16 @@ struct xfs_attr_item {
 	void		  *xattri_name;	      /* attr name */
 	uint32_t	  xattri_name_len;    /* length of name */
 	uint32_t	  xattri_flags;       /* attr flags */
-	struct list_head  xattri_list;
+
+	/*
+	 * Delayed attr parameters that need to remain instantiated
+	 * across transaction rolls during the defer finish
+	 */
+	struct xfs_buf		*xattri_leaf_bp;  /* Leaf buf to release */
+	enum xfs_attr_state	xattri_state;	  /* state machine marker */
+	struct xfs_da_args	xattri_args;	  /* args context */
+
+	struct list_head	xattri_list;
 
 	/*
 	 * A byte array follows the header containing the file name and
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 0c54ff5..270c32e 100644
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
index 142de8d..9b1b93e 100644
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
index 0ea19b4..36e6d1e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -19,10 +19,10 @@
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
index ab341d6..c8728ca 100644
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
index 5001dca..23f6990 100644
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
index e73c21a..561c467 100644
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
index 3013746..938e81d 100644
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
