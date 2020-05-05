Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCCDC3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F0C206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o6hCc8Bq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgEEBKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:10:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:10:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513SkQ054737
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SjeeO2fj+iz3gKiDaq+UU0AgJ7CuXLjTWCmomnoY8mk=;
 b=o6hCc8BqSUpboryd8NUaCaxK6VvNmFs36bFfTZaJNxEURbf2AUFmk2wbI+qun9d/rFAr
 h/B6hd1DWZD6SQUUIJQoDorSJmF54/1OvVfi9M6pDaDNzyU8cJqIVR7Kvf5XcNQ/eQWF
 lftppHSvKjDw0JlQaTnr/GxNXFAZuGvBg3VcwVqfm4L4oEHEjzH1lWzsWExAdnuW99Tw
 XRXaeKqaKKEbgyO/8BcLLdvvxnb+oeqtsAjqyI66vz7+75sfgjtAMRRkCLqfc900ZsIS
 RWiGIoZd6MdBwtmgszJjGvP+8z+NxZpxbuf1lF0fvspopMZFReT0JcwO7uw1RGQ/3qhD jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tma165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516rGq004631
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrtt6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:46 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451AkV9014368
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:45 -0700
Subject: [PATCH 02/28] xfs: refactor log recovery item sorting into a generic
 dispatch structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:45 -0700
Message-ID: <158864104502.182683.672673211897001126.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
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
 fs/xfs/Makefile                 |    3 +
 fs/xfs/libxfs/xfs_log_recover.h |   45 ++++++++++++++++++-
 fs/xfs/xfs_bmap_item.c          |    9 ++++
 fs/xfs/xfs_buf_item_recover.c   |   38 ++++++++++++++++
 fs/xfs/xfs_dquot_item_recover.c |   29 ++++++++++++
 fs/xfs/xfs_extfree_item.c       |    9 ++++
 fs/xfs/xfs_icreate_item.c       |   20 ++++++++
 fs/xfs/xfs_inode_item_recover.c |   26 +++++++++++
 fs/xfs/xfs_log_recover.c        |   93 +++++++++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c      |    9 ++++
 fs/xfs/xfs_rmap_item.c          |    9 ++++
 11 files changed, 251 insertions(+), 39 deletions(-)
 create mode 100644 fs/xfs/xfs_buf_item_recover.c
 create mode 100644 fs/xfs/xfs_dquot_item_recover.c
 create mode 100644 fs/xfs/xfs_inode_item_recover.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ff94fb90a2ee..04611a1068b4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -99,9 +99,12 @@ xfs-y				+= xfs_log.o \
 				   xfs_log_cil.o \
 				   xfs_bmap_item.o \
 				   xfs_buf_item.o \
+				   xfs_buf_item_recover.o \
+				   xfs_dquot_item_recover.o \
 				   xfs_extfree_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
+				   xfs_inode_item_recover.o \
 				   xfs_refcount_item.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 148e0cb5d379..271b0741f1e1 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -6,6 +6,47 @@
 #ifndef	__XFS_LOG_RECOVER_H__
 #define __XFS_LOG_RECOVER_H__
 
+/*
+ * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
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
+struct xlog_recover_item_ops {
+	uint16_t	item_type;	/* XFS_LI_* type code. */
+
+	/*
+	 * Help sort recovered log items into the order required to replay them
+	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
+	 * not have to supply a function here.  See the comment preceding
+	 * xlog_recover_reorder_trans for more details about what the return
+	 * values mean.
+	 */
+	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
+};
+
+extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
+extern const struct xlog_recover_item_ops xlog_buf_item_ops;
+extern const struct xlog_recover_item_ops xlog_inode_item_ops;
+extern const struct xlog_recover_item_ops xlog_dquot_item_ops;
+extern const struct xlog_recover_item_ops xlog_quotaoff_item_ops;
+extern const struct xlog_recover_item_ops xlog_bmap_intent_item_ops;
+extern const struct xlog_recover_item_ops xlog_bmap_done_item_ops;
+extern const struct xlog_recover_item_ops xlog_extfree_intent_item_ops;
+extern const struct xlog_recover_item_ops xlog_extfree_done_item_ops;
+extern const struct xlog_recover_item_ops xlog_rmap_intent_item_ops;
+extern const struct xlog_recover_item_ops xlog_rmap_done_item_ops;
+extern const struct xlog_recover_item_ops xlog_refcount_intent_item_ops;
+extern const struct xlog_recover_item_ops xlog_refcount_done_item_ops;
+
 /*
  * Macros, structures, prototypes for internal log manager use.
  */
@@ -24,10 +65,10 @@
  */
 struct xlog_recover_item {
 	struct list_head	ri_list;
-	int			ri_type;
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
-	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
+	struct xfs_log_iovec	*ri_buf;	/* ptr to regions buffer */
+	const struct xlog_recover_item_ops *ri_ops;
 };
 
 struct xlog_recover {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 7768fb2b7135..42354403fec7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -557,3 +558,11 @@ xfs_bui_recover(
 	}
 	return error;
 }
+
+const struct xlog_recover_item_ops xlog_bmap_intent_item_ops = {
+	.item_type		= XFS_LI_BUI,
+};
+
+const struct xlog_recover_item_ops xlog_bmap_done_item_ops = {
+	.item_type		= XFS_LI_BUD,
+};
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
new file mode 100644
index 000000000000..def19025512e
--- /dev/null
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -0,0 +1,38 @@
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
+xlog_recover_buf_reorder(
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
+const struct xlog_recover_item_ops xlog_buf_item_ops = {
+	.item_type		= XFS_LI_BUF,
+	.reorder		= xlog_recover_buf_reorder,
+};
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
new file mode 100644
index 000000000000..78fe644e9907
--- /dev/null
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -0,0 +1,29 @@
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
+#include "xfs_quota.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_trans_priv.h"
+#include "xfs_qm.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+const struct xlog_recover_item_ops xlog_dquot_item_ops = {
+	.item_type		= XFS_LI_DQUOT,
+};
+
+const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
+	.item_type		= XFS_LI_QUOTAOFF,
+};
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c8cde4122a0f..b43bb087aef3 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
@@ -644,3 +645,11 @@ xfs_efi_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+const struct xlog_recover_item_ops xlog_extfree_intent_item_ops = {
+	.item_type		= XFS_LI_EFI,
+};
+
+const struct xlog_recover_item_ops xlog_extfree_done_item_ops = {
+	.item_type		= XFS_LI_EFD,
+};
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 490fee22b878..366c1e722a29 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -11,6 +11,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -107,3 +109,21 @@ xfs_icreate_log(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
 }
+
+static enum xlog_recover_reorder
+xlog_recover_icreate_reorder(
+		struct xlog_recover_item *item)
+{
+	/*
+	 * Inode allocation buffers must be replayed before subsequent inode
+	 * items try to modify those buffers.  ICREATE items are the logical
+	 * equivalent of logging a newly initialized inode buffer, so recover
+	 * these at the same time that we recover logged buffers.
+	 */
+	return XLOG_REORDER_BUFFER_LIST;
+}
+
+const struct xlog_recover_item_ops xlog_icreate_item_ops = {
+	.item_type		= XFS_LI_ICREATE,
+	.reorder		= xlog_recover_icreate_reorder,
+};
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
new file mode 100644
index 000000000000..b19a151efb10
--- /dev/null
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -0,0 +1,26 @@
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
+const struct xlog_recover_item_ops xlog_inode_item_ops = {
+	.item_type		= XFS_LI_INODE,
+};
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c2c06f70fb8a..0ef0d81fd190 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1785,6 +1785,34 @@ xlog_clear_stale_blocks(
  *
  ******************************************************************************
  */
+static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
+	&xlog_buf_item_ops,
+	&xlog_inode_item_ops,
+	&xlog_dquot_item_ops,
+	&xlog_quotaoff_item_ops,
+	&xlog_icreate_item_ops,
+	&xlog_extfree_intent_item_ops,
+	&xlog_extfree_done_item_ops,
+	&xlog_rmap_intent_item_ops,
+	&xlog_rmap_done_item_ops,
+	&xlog_refcount_intent_item_ops,
+	&xlog_refcount_done_item_ops,
+	&xlog_bmap_intent_item_ops,
+	&xlog_bmap_done_item_ops,
+};
+
+static const struct xlog_recover_item_ops *
+xlog_find_item_ops(
+	struct xlog_recover_item		*item)
+{
+	unsigned int				i;
+
+	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
+		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
+			return xlog_recover_item_ops[i];
+
+	return NULL;
+}
 
 /*
  * Sort the log items in the transaction.
@@ -1851,41 +1879,10 @@ xlog_recover_reorder_trans(
 
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
+		item->ri_ops = xlog_find_item_ops(item);
+		if (!item->ri_ops) {
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
@@ -1896,11 +1893,33 @@ xlog_recover_reorder_trans(
 			 */
 			if (!list_empty(&sort_list))
 				list_splice_init(&sort_list, &trans->r_itemq);
-			error = -EIO;
-			goto out;
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		if (item->ri_ops->reorder)
+			fate = item->ri_ops->reorder(item);
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
index 0316eab2fc35..0e8e8bab4344 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -18,6 +18,7 @@
 #include "xfs_log.h"
 #include "xfs_refcount.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
@@ -570,3 +571,11 @@ xfs_cui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+const struct xlog_recover_item_ops xlog_refcount_intent_item_ops = {
+	.item_type		= XFS_LI_CUI,
+};
+
+const struct xlog_recover_item_ops xlog_refcount_done_item_ops = {
+	.item_type		= XFS_LI_CUD,
+};
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e3bba2aec868..3eb538674cb9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -18,6 +18,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_error.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
@@ -585,3 +586,11 @@ xfs_rui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+const struct xlog_recover_item_ops xlog_rmap_intent_item_ops = {
+	.item_type		= XFS_LI_RUI,
+};
+
+const struct xlog_recover_item_ops xlog_rmap_done_item_ops = {
+	.item_type		= XFS_LI_RUD,
+};

