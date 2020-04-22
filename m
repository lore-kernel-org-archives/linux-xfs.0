Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F46C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF47820724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fQzqUVBS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDVCGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:06:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:06:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M24Ncr167620
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZDxlRY4AAAeAy0KYODBOHd6JmI2arFs7poZ92ONAJw4=;
 b=fQzqUVBSUzEMpkDiVmCR30s3gZAG7gr9WvK6juxmSKqOFSPQzqoXEEimVK7f3tR/2Q6H
 jLIXNy4NeOxH4Cx1W2eh0BcWk7Ub2OzLN2Tv4vIGdBQ34+y+jz1KXXkNbEEhm+BdfB4A
 mhzJeGJtyBmucFwnQkO+ezVTR44e91V2mFJ0Arj5efiqTQRjRJnHFp0Jp+Y25E6yd7NN
 0hRx1XOg0SDtpU5qDrGAshsj6qE40FOoOVWrWjcQmFJIIb7zG6o1E73mXyqbgrEIWJNg
 LpNhTfOJer3dG5Z/YdyF6v1WM0Yy4Sq9TQOJZ2Ci9aDIAEQmJ3pjZuR222HjZLSaWf56 QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30grpgmhj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22F87075428
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1hbewy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M26GIK013964
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:06:16 -0700
Subject: [PATCH 02/19] xfs: refactor log recovery item sorting into a
 generic dispatch structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:06:15 -0700
Message-ID: <158752117554.2140829.4901314701479350791.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
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
 fs/xfs/libxfs/xfs_log_recover.h |   39 +++++++++++++++++
 fs/xfs/xfs_buf_item.c           |   20 ++++++++-
 fs/xfs/xfs_dquot_item.c         |   10 ++++
 fs/xfs/xfs_icreate_item.c       |    6 +++
 fs/xfs/xfs_inode_item.c         |    6 +++
 fs/xfs/xfs_log_recover.c        |   88 +++++++++++++++++++++++++++------------
 6 files changed, 139 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3bf671637a91..60a6afb93049 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -6,6 +6,43 @@
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
+	XLOG_REORDER_UNKNOWN,
+	XLOG_REORDER_BUFFER_LIST,
+	XLOG_REORDER_CANCEL_LIST,
+	XLOG_REORDER_INODE_BUFFER_LIST,
+	XLOG_REORDER_INODE_LIST,
+};
+
+typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
+		struct xlog_recover_item *item);
+
+struct xlog_recover_item_type {
+	/*
+	 * These two items decide how to sort recovered log items during
+	 * recovery.  If reorder_fn is non-NULL it will be called; otherwise,
+	 * reorder will be used to decide.  See the comment above
+	 * xlog_recover_reorder_trans for more details about what the values
+	 * mean.
+	 */
+	enum xlog_recover_reorder	reorder;
+	xlog_recover_reorder_fn		reorder_fn;
+};
+
+extern const struct xlog_recover_item_type xlog_icreate_item_type;
+extern const struct xlog_recover_item_type xlog_buf_item_type;
+extern const struct xlog_recover_item_type xlog_inode_item_type;
+extern const struct xlog_recover_item_type xlog_dquot_item_type;
+extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
+extern const struct xlog_recover_item_type xlog_intent_item_type;
+
 /*
  * Macros, structures, prototypes for internal log manager use.
  */
@@ -24,10 +61,10 @@
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
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1545657c3ca0..bf7480e18889 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -16,7 +16,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_buf_item_zone;
 
@@ -1287,3 +1288,20 @@ xfs_buf_resubmit_failed_buffers(
 
 	return ret;
 }
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
index baad1748d0d1..2558586b4d45 100644
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
@@ -383,3 +385,11 @@ xfs_qm_qoff_logitem_init(
 	qf->qql_flags = flags;
 	return qf;
 }
+
+const struct xlog_recover_item_type xlog_dquot_item_type = {
+	.reorder		= XLOG_REORDER_INODE_LIST,
+};
+
+const struct xlog_recover_item_type xlog_quotaoff_item_type = {
+	.reorder		= XLOG_REORDER_INODE_LIST,
+};
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 490fee22b878..0a1ed4dc1c3d 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -11,6 +11,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -107,3 +109,7 @@ xfs_icreate_log(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
 }
+
+const struct xlog_recover_item_type xlog_icreate_item_type = {
+	.reorder		= XLOG_REORDER_BUFFER_LIST,
+};
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f779cca2346f..b04e9c5330b7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -18,6 +18,8 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 #include <linux/iversion.h>
 
@@ -843,3 +845,7 @@ xfs_inode_item_format_convert(
 	in_f->ilf_boffset = in_f32->ilf_boffset;
 	return 0;
 }
+
+const struct xlog_recover_item_type xlog_inode_item_type = {
+	.reorder		= XLOG_REORDER_INODE_LIST,
+};
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f803083ddc3..e7a9f899f657 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1779,6 +1779,12 @@ xlog_clear_stale_blocks(
 	return 0;
 }
 
+/* Log intent item dispatching. */
+
+const struct xlog_recover_item_type xlog_intent_item_type = {
+	.reorder		= XLOG_REORDER_INODE_LIST,
+};
+
 /******************************************************************************
  *
  *		Log recover routines
@@ -1786,6 +1792,39 @@ xlog_clear_stale_blocks(
  ******************************************************************************
  */
 
+static const struct xlog_recover_item_type *
+xlog_item_for_type(
+	unsigned short	type)
+{
+	switch (type) {
+	case XFS_LI_ICREATE:
+		return &xlog_icreate_item_type;
+	case XFS_LI_BUF:
+		return &xlog_buf_item_type;
+	case XFS_LI_EFD:
+	case XFS_LI_EFI:
+	case XFS_LI_RUI:
+	case XFS_LI_RUD:
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
+		return &xlog_intent_item_type;
+	case XFS_LI_INODE:
+		return &xlog_inode_item_type;
+	case XFS_LI_DQUOT:
+		return &xlog_dquot_item_type;
+	case XFS_LI_QUOTAOFF:
+		return &xlog_quotaoff_item_type;
+	case XFS_LI_IUNLINK:
+		/* Not implemented? */
+		return NULL;
+	default:
+		/* Unknown type, go away. */
+		return NULL;
+	}
+}
+
 /*
  * Sort the log items in the transaction.
  *
@@ -1851,41 +1890,34 @@ xlog_recover_reorder_trans(
 
 	list_splice_init(&trans->r_itemq, &sort_list);
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
-		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
+		enum xlog_recover_reorder	fate = XLOG_REORDER_UNKNOWN;
+
+		item->ri_type = xlog_item_for_type(ITEM_TYPE(item));
+		if (item->ri_type) {
+			if (item->ri_type->reorder_fn)
+				fate = item->ri_type->reorder_fn(item);
+			else
+				fate = item->ri_type->reorder;
+		}
 
-		switch (ITEM_TYPE(item)) {
-		case XFS_LI_ICREATE:
+		switch (fate) {
+		case XLOG_REORDER_BUFFER_LIST:
 			list_move_tail(&item->ri_list, &buffer_list);
 			break;
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
+		case XLOG_REORDER_CANCEL_LIST:
+			trace_xfs_log_recover_item_reorder_head(log,
+					trans, item, pass);
+			list_move(&item->ri_list, &cancel_list);
 			break;
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
+		case XLOG_REORDER_INODE_BUFFER_LIST:
+			list_move(&item->ri_list, &inode_buffer_list);
+			break;
+		case XLOG_REORDER_INODE_LIST:
 			trace_xfs_log_recover_item_reorder_tail(log,
-							trans, item, pass);
+					trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
 			break;
-		default:
+		case XLOG_REORDER_UNKNOWN:
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));

