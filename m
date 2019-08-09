Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49636 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYPuH071873
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:45 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LO3Og008010
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6vm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79Lbhf1004873
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v2 14/18] xfs: Add delay context to xfs_da_args
Date: Fri,  9 Aug 2019 14:37:22 -0700
Message-Id: <20190809213726.32336-15-allison.henderson@oracle.com>
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a new struct xfs_delay_context, which we
will use to keep track of the current state of a delayed
attribute operation.

The flags member is used to track various operations that
are in progress so that we know not to repeat them, and
resume where we left off before EAGAIN was returned to
cycle out the transaction.  Other members take the place
of local variables that need to retain their values
across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h     |  6 ++++++
 fs/xfs/libxfs/xfs_da_btree.h | 23 +++++++++++++++++++++++
 fs/xfs/scrub/common.c        |  2 ++
 fs/xfs/xfs_acl.c             |  2 ++
 fs/xfs/xfs_attr_item.c       |  2 +-
 fs/xfs/xfs_attr_list.c       |  1 +
 fs/xfs/xfs_ioctl.c           |  2 ++
 fs/xfs/xfs_ioctl32.c         |  2 ++
 fs/xfs/xfs_iops.c            |  2 ++
 fs/xfs/xfs_xattr.c           |  1 +
 10 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index c082d34..b1172fd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -91,6 +91,12 @@ struct xfs_attr_item {
 	struct list_head  xattri_list;
 
 	/*
+	 * xfs_da_args needs to remain instantiated across transaction rolls
+	 * during the defer finish, so store it here
+	 */
+	struct xfs_da_args	xattri_args;
+
+	/*
 	 * A byte array follows the header containing the file name and
 	 * attribute value.
 	 */
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 84dd865..b4607ad 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -42,6 +42,28 @@ enum xfs_dacmp {
 	XFS_CMP_CASE		/* names are same but differ in case */
 };
 
+#define		XFS_DC_INIT		0x01 /* Init delay info */
+#define		XFS_DC_FOUND_LBLK	0x02 /* We found leaf blk for attr */
+#define		XFS_DC_FOUND_NBLK	0x04 /* We found node blk for attr */
+#define		XFS_DC_ALLOC_LEAF	0x08 /* We are allocating leaf blocks */
+#define		XFS_DC_ALLOC_NODE	0x10 /* We are allocating node blocks */
+#define		XFS_DC_RM_LEAF_BLKS	0x20 /* We are removing leaf blocks */
+#define		XFS_DC_RM_NODE_BLKS	0x40 /* We are removing node blocks */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delay_context {
+	unsigned int		flags;
+	struct xfs_buf		*leaf_bp;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	xfs_fileoff_t		lfileoff;
+	int			blkcnt;
+	struct xfs_da_state	*state;
+	struct xfs_da_state_blk *blk;
+};
+
 /*
  * Structure to ease passing around component names.
  */
@@ -71,6 +93,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	struct xfs_delay_context  dc;	/* context used for delay attr ops */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1887605..9a649d1 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -24,6 +24,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3da2568..74a62d2 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -10,6 +10,8 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include <linux/posix_acl_xattr.h>
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2340589..88efaf9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -22,9 +22,9 @@
 #include "xfs_rmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_attr.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_attr.h"
 #include "xfs_shared.h"
 #include "xfs_attr_item.h"
 #include "xfs_alloc.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 58fc820..a62a4be 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -12,6 +12,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b6a7220..a754116 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -15,6 +15,8 @@
 #include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7fcf756..e48ccee 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -17,6 +17,8 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_rtalloc.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index bdf925c..2cc6b84 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -13,6 +13,8 @@
 #include "xfs_inode.h"
 #include "xfs_acl.h"
 #include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 3c63930..df4b1c8 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 
 #include <linux/posix_acl_xattr.h>
-- 
2.7.4
