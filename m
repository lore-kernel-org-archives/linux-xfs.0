Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1M5Su1236341 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 16:05:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C7E91609CBA
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 14:07:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MJc2InuiI1XHceIf for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 14:07:12 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PNupS-0007nl-GC
	for xfs@oss.sgi.com; Wed, 01 Dec 2010 22:07:10 +0000
Message-Id: <20101201220710.454838485@bombadil.infradead.org>
Date: Wed, 01 Dec 2010 17:06:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: refactor xlog_recover_commit_trans
References: <20101201220620.340188389@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xlog_recover_commit_trans
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Merge the call to xlog_recover_reorder_trans and the loop over the
recovery items from xlog_recover_do_trans into xlog_recover_commit_trans,
and keep the switch statement over the log item types as a separate helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-11-29 15:15:58.174005517 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2010-11-29 15:27:26.298253879 +0100
@@ -2674,71 +2674,13 @@ xlog_recover_do_efd_trans(
 }
 
 /*
- * Perform the transaction
- *
- * If the transaction modifies a buffer or inode, do it now.  Otherwise,
- * EFIs and EFDs get queued up by adding entries into the AIL for them.
- */
-STATIC int
-xlog_recover_do_trans(
-	xlog_t			*log,
-	xlog_recover_t		*trans,
-	int			pass)
-{
-	int			error = 0;
-	xlog_recover_item_t	*item;
-
-	error = xlog_recover_reorder_trans(log, trans, pass);
-	if (error)
-		return error;
-
-	list_for_each_entry(item, &trans->r_itemq, ri_list) {
-		trace_xfs_log_recover_item_recover(log, trans, item, pass);
-		switch (ITEM_TYPE(item)) {
-		case XFS_LI_BUF:
-			error = xlog_recover_do_buffer_trans(log, item, pass);
-			break;
-		case XFS_LI_INODE:
-			error = xlog_recover_do_inode_trans(log, item, pass);
-			break;
-		case XFS_LI_EFI:
-			error = xlog_recover_do_efi_trans(log, item,
-							  trans->r_lsn, pass);
-			break;
-		case XFS_LI_EFD:
-			xlog_recover_do_efd_trans(log, item, pass);
-			error = 0;
-			break;
-		case XFS_LI_DQUOT:
-			error = xlog_recover_do_dquot_trans(log, item, pass);
-			break;
-		case XFS_LI_QUOTAOFF:
-			error = xlog_recover_do_quotaoff_trans(log, item,
-							       pass);
-			break;
-		default:
-			xlog_warn(
-	"XFS: invalid item type (%d) xlog_recover_do_trans", ITEM_TYPE(item));
-			ASSERT(0);
-			error = XFS_ERROR(EIO);
-			break;
-		}
-
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
-
-/*
  * Free up any resources allocated by the transaction
  *
  * Remember that EFIs, EFDs, and IUNLINKs are handled later.
  */
 STATIC void
 xlog_recover_free_trans(
-	xlog_recover_t		*trans)
+	struct xlog_recover	*trans)
 {
 	xlog_recover_item_t	*item, *n;
 	int			i;
@@ -2757,17 +2699,65 @@ xlog_recover_free_trans(
 }
 
 STATIC int
+xlog_recover_commit_item(
+	struct log		*log,
+	struct xlog_recover	*trans,
+	xlog_recover_item_t	*item,
+	int			pass)
+{
+	trace_xfs_log_recover_item_recover(log, trans, item, pass);
+
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_BUF:
+		return xlog_recover_do_buffer_trans(log, item, pass);
+		break;
+	case XFS_LI_INODE:
+		return xlog_recover_do_inode_trans(log, item, pass);
+	case XFS_LI_EFI:
+		return xlog_recover_do_efi_trans(log, item, trans->r_lsn, pass);
+	case XFS_LI_EFD:
+		xlog_recover_do_efd_trans(log, item, pass);
+		return 0;
+	case XFS_LI_DQUOT:
+		return xlog_recover_do_dquot_trans(log, item, pass);
+	case XFS_LI_QUOTAOFF:
+		return xlog_recover_do_quotaoff_trans(log, item, pass);
+	default:
+		xlog_warn(
+	"XFS: invalid item type (%d) xlog_recover_do_trans", ITEM_TYPE(item));
+		ASSERT(0);
+		return XFS_ERROR(EIO);
+	}
+}
+
+/*
+ * Perform the transaction.
+ *
+ * If the transaction modifies a buffer or inode, do it now.  Otherwise,
+ * EFIs and EFDs get queued up by adding entries into the AIL for them.
+ */
+STATIC int
 xlog_recover_commit_trans(
-	xlog_t			*log,
-	xlog_recover_t		*trans,
+	struct log		*log,
+	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error;
+	int			error = 0;
+	xlog_recover_item_t	*item;
 
 	hlist_del(&trans->r_list);
-	if ((error = xlog_recover_do_trans(log, trans, pass)))
+
+	error = xlog_recover_reorder_trans(log, trans, pass);
+	if (error)
 		return error;
-	xlog_recover_free_trans(trans);			/* no error */
+
+	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+		error = xlog_recover_commit_item(log, trans, item, pass);
+		if (error)
+			return error;
+	}
+
+	xlog_recover_free_trans(trans);
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
