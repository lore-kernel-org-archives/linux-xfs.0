Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E3FC83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3371920787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qVuXNqaS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgD3Atq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46456 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgD3Atq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0muf6193052
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rKyDKKP/e9KjrBmNi2BePajZkwH9N/I8H57Zos3g7c8=;
 b=qVuXNqaSvO5xJ4VugWoRR1UnpuDoge5BPcxQg3FxQGiWelISLOEWgsGaHP3D0T8TX3hT
 2AvJ/q1ZMocRbXc4Uf0LbNs1pAPfkH7rUD8cmiTDzoD2okDEYt2Xon3rQffL0y49EgpC
 75rG4lBlH6U7BNg1a9gaKKA3FkCaPkVG20Jcv4c8ozgYJiPSCMqxmzTFj9dng7NrGt8H
 3xZBWLWm8WTzlhJEXpmWor549xo74x09Wq21W2BFZqkZbaPkFbWsuR6biiaRDf4zr/BM
 RuB7SZyZhggDcWTgOaBwjTxKLSiQYoFWYgMdn2itsDiZ3G5Z3IA+hufKCx/Dq0YF2ZLt Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucg8qa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0cEcG040217
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30mxrw8hqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0lgoQ012355
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:47:42 -0700
Subject: [PATCH 01/21] xfs: refactor log recovery item sorting into a
 generic dispatch structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:47:41 -0700
Message-ID: <158820766135.467894.13993542565087629835.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=1 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a generic dispatch structure to delegate recovery of different
log item types into various code modules.  This will enable us to move
code specific to a particular log item type out of xfs_log_recover.c and
into the log item source.

The first operation we virtualize is the log item sorting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                 |    2 +
 fs/xfs/libxfs/xfs_log_recover.h |   41 ++++++++++++++
 fs/xfs/xfs_bmap_item.c          |    7 ++
 fs/xfs/xfs_buf_item.c           |    1 
 fs/xfs/xfs_buf_item_recover.c   |   37 +++++++++++++
 fs/xfs/xfs_dquot_item.c         |    8 +++
 fs/xfs/xfs_extfree_item.c       |    7 ++
 fs/xfs/xfs_icreate_item.c       |   13 ++++
 fs/xfs/xfs_inode_item_recover.c |   25 ++++++++
 fs/xfs/xfs_log_recover.c        |  115 ++++++++++++++++++++++++++-------------
 fs/xfs/xfs_refcount_item.c      |    7 ++
 fs/xfs/xfs_rmap_item.c          |    7 ++
 12 files changed, 231 insertions(+), 39 deletions(-)
 create mode 100644 fs/xfs/xfs_buf_item_recover.c
 create mode 100644 fs/xfs/xfs_inode_item_recover.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ee375b67ac71..5e52c2dc6078 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -120,9 +120,11 @@ xfs-y				+= xfs_log.o \
 				   xfs_log_cil.o \
 				   xfs_bmap_item.o \
 				   xfs_buf_item.o \
+				   xfs_buf_item_recover.o \
 				   xfs_extfree_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
+				   xfs_inode_item_recover.o \
 				   xfs_refcount_item.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3bf671637a91..38ae9c371edb 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -6,6 +6,45 @@
 #ifndef	__XFS_LOG_RECOVER_H__
 #define __XFS_LOG_RECOVER_H__
 
+/*
+ * Each log item type (XFS_LI_*) gets its own xlog_recover_item_type to
+ * define how recovery should work for that type of log item.
+ */
+struct xlog_recover_item;
+
+/* Sorting hat for log items as they're read in. */
+enum xlog_recover_reorder {
+	XLOG_REORDER_BUFFER_LIST,
+	XLOG_REORDER_ITEM_LIST,
+	XLOG_REORDER_INODE_BUFFER_LIST,
+	XLOG_REORDER_CANCEL_LIST,
+};
+
+struct xlog_recover_item_type {
+	/*
+	 * Help sort recovered log items into the order required to replay them
+	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
+	 * not have to supply a function here.  See the comment preceding
+	 * xlog_recover_reorder_trans for more details about what the return
+	 * values mean.
+	 */
+	enum xlog_recover_reorder (*reorder_fn)(struct xlog_recover_item *item);
+};
+
+extern const struct xlog_recover_item_type xlog_icreate_item_type;
+extern const struct xlog_recover_item_type xlog_buf_item_type;
+extern const struct xlog_recover_item_type xlog_inode_item_type;
+extern const struct xlog_recover_item_type xlog_dquot_item_type;
+extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
+extern const struct xlog_recover_item_type xlog_bmap_intent_item_type;
+extern const struct xlog_recover_item_type xlog_bmap_done_item_type;
+extern const struct xlog_recover_item_type xlog_extfree_intent_item_type;
+extern const struct xlog_recover_item_type xlog_extfree_done_item_type;
+extern const struct xlog_recover_item_type xlog_rmap_intent_item_type;
+extern const struct xlog_recover_item_type xlog_rmap_done_item_type;
+extern const struct xlog_recover_item_type xlog_refcount_intent_item_type;
+extern const struct xlog_recover_item_type xlog_refcount_done_item_type;
+
 /*
  * Macros, structures, prototypes for internal log manager use.
  */
@@ -24,10 +63,10 @@
  */
 typedef struct xlog_recover_item {
 	struct list_head	ri_list;
-	int			ri_type;
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
 	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
+	const struct xlog_recover_item_type *ri_type;
 } xlog_recover_item_t;
 
 struct xlog_recover {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc..a2824013e2cb 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -563,3 +564,9 @@ xfs_bui_recover(
 	}
 	return error;
 }
+
+const struct xlog_recover_item_type xlog_bmap_intent_item_type = {
+};
+
+const struct xlog_recover_item_type xlog_bmap_done_item_type = {
+};
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1545657c3ca0..a416fc35e444 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -17,7 +17,6 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 
-
 kmem_zone_t	*xfs_buf_item_zone;
 
 static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
new file mode 100644
index 000000000000..07ddf58209c3
--- /dev/null
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_trans_priv.h"
+#include "xfs_trace.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+STATIC enum xlog_recover_reorder
+xlog_buf_reorder_fn(
+	struct xlog_recover_item	*item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+
+	if (buf_f->blf_flags & XFS_BLF_CANCEL)
+		return XLOG_REORDER_CANCEL_LIST;
+	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
+		return XLOG_REORDER_INODE_BUFFER_LIST;
+	return XLOG_REORDER_BUFFER_LIST;
+}
+
+const struct xlog_recover_item_type xlog_buf_item_type = {
+	.reorder_fn		= xlog_buf_reorder_fn,
+};
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index baad1748d0d1..3bd5b6c7e235 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -383,3 +385,9 @@ xfs_qm_qoff_logitem_init(
 	qf->qql_flags = flags;
 	return qf;
 }
+
+const struct xlog_recover_item_type xlog_dquot_item_type = {
+};
+
+const struct xlog_recover_item_type xlog_quotaoff_item_type = {
+};
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e298..c53e5f46ee26 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
@@ -652,3 +653,9 @@ xfs_efi_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
+};
+
+const struct xlog_recover_item_type xlog_extfree_done_item_type = {
+};
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 490fee22b878..9f38a3c200a3 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -11,6 +11,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -107,3 +109,14 @@ xfs_icreate_log(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
 }
+
+static enum xlog_recover_reorder
+xlog_icreate_reorder(
+		struct xlog_recover_item *item)
+{
+	return XLOG_REORDER_BUFFER_LIST;
+}
+
+const struct xlog_recover_item_type xlog_icreate_item_type = {
+	.reorder_fn		= xlog_icreate_reorder,
+};
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
new file mode 100644
index 000000000000..478f0a5c08ab
--- /dev/null
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_trace.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_log.h"
+#include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+const struct xlog_recover_item_type xlog_inode_item_type = {
+};
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index db47dfc0cada..8ab107680883 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1786,6 +1786,57 @@ xlog_clear_stale_blocks(
  ******************************************************************************
  */
 
+static int
+xlog_set_item_type(
+	struct xlog_recover_item		*item)
+{
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_ICREATE:
+		item->ri_type = &xlog_icreate_item_type;
+		return 0;
+	case XFS_LI_BUF:
+		item->ri_type = &xlog_buf_item_type;
+		return 0;
+	case XFS_LI_EFI:
+		item->ri_type = &xlog_extfree_intent_item_type;
+		return 0;
+	case XFS_LI_EFD:
+		item->ri_type = &xlog_extfree_done_item_type;
+		return 0;
+	case XFS_LI_RUI:
+		item->ri_type = &xlog_rmap_intent_item_type;
+		return 0;
+	case XFS_LI_RUD:
+		item->ri_type = &xlog_rmap_done_item_type;
+		return 0;
+	case XFS_LI_CUI:
+		item->ri_type = &xlog_refcount_intent_item_type;
+		return 0;
+	case XFS_LI_CUD:
+		item->ri_type = &xlog_refcount_done_item_type;
+		return 0;
+	case XFS_LI_BUI:
+		item->ri_type = &xlog_bmap_intent_item_type;
+		return 0;
+	case XFS_LI_BUD:
+		item->ri_type = &xlog_bmap_done_item_type;
+		return 0;
+	case XFS_LI_INODE:
+		item->ri_type = &xlog_inode_item_type;
+		return 0;
+#ifdef CONFIG_XFS_QUOTA
+	case XFS_LI_DQUOT:
+		item->ri_type = &xlog_dquot_item_type;
+		return 0;
+	case XFS_LI_QUOTAOFF:
+		item->ri_type = &xlog_quotaoff_item_type;
+		return 0;
+#endif /* CONFIG_XFS_QUOTA */
+	default:
+		return -EFSCORRUPTED;
+	}
+}
+
 /*
  * Sort the log items in the transaction.
  *
@@ -1851,41 +1902,10 @@ xlog_recover_reorder_trans(
 
 	list_splice_init(&trans->r_itemq, &sort_list);
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
-		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
+		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
-		switch (ITEM_TYPE(item)) {
-		case XFS_LI_ICREATE:
-			list_move_tail(&item->ri_list, &buffer_list);
-			break;
-		case XFS_LI_BUF:
-			if (buf_f->blf_flags & XFS_BLF_CANCEL) {
-				trace_xfs_log_recover_item_reorder_head(log,
-							trans, item, pass);
-				list_move(&item->ri_list, &cancel_list);
-				break;
-			}
-			if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
-				list_move(&item->ri_list, &inode_buffer_list);
-				break;
-			}
-			list_move_tail(&item->ri_list, &buffer_list);
-			break;
-		case XFS_LI_INODE:
-		case XFS_LI_DQUOT:
-		case XFS_LI_QUOTAOFF:
-		case XFS_LI_EFD:
-		case XFS_LI_EFI:
-		case XFS_LI_RUI:
-		case XFS_LI_RUD:
-		case XFS_LI_CUI:
-		case XFS_LI_CUD:
-		case XFS_LI_BUI:
-		case XFS_LI_BUD:
-			trace_xfs_log_recover_item_reorder_tail(log,
-							trans, item, pass);
-			list_move_tail(&item->ri_list, &item_list);
-			break;
-		default:
+		error = xlog_set_item_type(item);
+		if (error) {
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
@@ -1896,11 +1916,32 @@ xlog_recover_reorder_trans(
 			 */
 			if (!list_empty(&sort_list))
 				list_splice_init(&sort_list, &trans->r_itemq);
-			error = -EIO;
-			goto out;
+			break;
+		}
+
+		if (item->ri_type->reorder_fn)
+			fate = item->ri_type->reorder_fn(item);
+
+		switch (fate) {
+		case XLOG_REORDER_BUFFER_LIST:
+			list_move_tail(&item->ri_list, &buffer_list);
+			break;
+		case XLOG_REORDER_CANCEL_LIST:
+			trace_xfs_log_recover_item_reorder_head(log,
+					trans, item, pass);
+			list_move(&item->ri_list, &cancel_list);
+			break;
+		case XLOG_REORDER_INODE_BUFFER_LIST:
+			list_move(&item->ri_list, &inode_buffer_list);
+			break;
+		case XLOG_REORDER_ITEM_LIST:
+			trace_xfs_log_recover_item_reorder_tail(log,
+							trans, item, pass);
+			list_move_tail(&item->ri_list, &item_list);
+			break;
 		}
 	}
-out:
+
 	ASSERT(list_empty(&sort_list));
 	if (!list_empty(&buffer_list))
 		list_splice(&buffer_list, &trans->r_itemq);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cd..ddab09385bfb 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -18,6 +18,7 @@
 #include "xfs_log.h"
 #include "xfs_refcount.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
@@ -590,3 +591,9 @@ xfs_cui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+const struct xlog_recover_item_type xlog_refcount_intent_item_type = {
+};
+
+const struct xlog_recover_item_type xlog_refcount_done_item_type = {
+};
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..bcad3db1f3a4 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -18,6 +18,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
@@ -606,3 +607,9 @@ xfs_rui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+const struct xlog_recover_item_type xlog_rmap_intent_item_type = {
+};
+
+const struct xlog_recover_item_type xlog_rmap_done_item_type = {
+};

