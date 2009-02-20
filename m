Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8rW1p164864 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E77741975A88
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:53:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jIP5JZh6ObJs7Ftw for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:53:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaR7V-00040v-CC
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 08:52:29 +0000
Message-Id: <20090220085229.204188000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: cleanup xlog_recover_do_trans
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xlog_recover_do_trans
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

Change the big if-elsif-else block handling the different item types
into a more natural switch, remove assignments in conditionals and
remove an out of place comment from centuries ago on IRIX.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-19 20:39:19.268070123 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-19 20:42:06.038944151 +0100
@@ -2763,51 +2763,48 @@ xlog_recover_do_trans(
 	int			error = 0;
 	xlog_recover_item_t	*item, *first_item;
 
-	if ((error = xlog_recover_reorder_trans(trans)))
+	error = xlog_recover_reorder_trans(trans);
+	if (error)
 		return error;
+
 	first_item = item = trans->r_itemq;
 	do {
-		/*
-		 * we don't need to worry about the block number being
-		 * truncated in > 1 TB buffers because in user-land,
-		 * we're now n32 or 64-bit so xfs_daddr_t is 64-bits so
-		 * the blknos will get through the user-mode buffer
-		 * cache properly.  The only bad case is o32 kernels
-		 * where xfs_daddr_t is 32-bits but mount will warn us
-		 * off a > 1 TB filesystem before we get here.
-		 */
-		if ((ITEM_TYPE(item) == XFS_LI_BUF)) {
-			if  ((error = xlog_recover_do_buffer_trans(log, item,
-								 pass)))
-				break;
-		} else if ((ITEM_TYPE(item) == XFS_LI_INODE)) {
-			if ((error = xlog_recover_do_inode_trans(log, item,
-								pass)))
-				break;
-		} else if (ITEM_TYPE(item) == XFS_LI_EFI) {
-			if ((error = xlog_recover_do_efi_trans(log, item, trans->r_lsn,
-						  pass)))
-				break;
-		} else if (ITEM_TYPE(item) == XFS_LI_EFD) {
+		switch (ITEM_TYPE(item)) {
+		case XFS_LI_BUF:
+			error = xlog_recover_do_buffer_trans(log, item, pass);
+			break;
+		case XFS_LI_INODE:
+			error = xlog_recover_do_inode_trans(log, item, pass);
+			break;
+		case XFS_LI_EFI:
+			error = xlog_recover_do_efi_trans(log, item,
+							  trans->r_lsn, pass);
+			break;
+		case XFS_LI_EFD:
 			xlog_recover_do_efd_trans(log, item, pass);
-		} else if (ITEM_TYPE(item) == XFS_LI_DQUOT) {
-			if ((error = xlog_recover_do_dquot_trans(log, item,
-								   pass)))
-					break;
-		} else if ((ITEM_TYPE(item) == XFS_LI_QUOTAOFF)) {
-			if ((error = xlog_recover_do_quotaoff_trans(log, item,
-								   pass)))
-					break;
-		} else {
-			xlog_warn("XFS: xlog_recover_do_trans");
+			error = 0;
+			break;
+		case XFS_LI_DQUOT:
+			error = xlog_recover_do_dquot_trans(log, item, pass);
+			break;
+		case XFS_LI_QUOTAOFF:
+			error = xlog_recover_do_quotaoff_trans(log, item,
+							       pass);
+			break;
+		default:
+			xlog_warn(
+	"XFS: invalid item type (%d) xlog_recover_do_trans", ITEM_TYPE(item));
 			ASSERT(0);
 			error = XFS_ERROR(EIO);
 			break;
 		}
+
+		if (error)
+			return error;
 		item = item->ri_next;
 	} while (first_item != item);
 
-	return error;
+	return 0;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
