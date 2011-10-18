Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I9Bm3K073774 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 04:11:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0E681D5CA1
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 02:11:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	K3lQRNsFECPvmvqo for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 02:11:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RG5i4-0003Rd-Ta
	for xfs@oss.sgi.com; Tue, 18 Oct 2011 09:11:44 +0000
Date: Tue, 18 Oct 2011 05:11:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: constify xfs_item_ops
Message-ID: <20111018091144.GA13240@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The log item ops aren't nessecarily the biggest exploit vector, but marking
them const is easy enough.  Also remove the unused xfs_item_ops_t typedef
while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-17 09:39:24.984149009 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-17 09:40:46.159148043 +0200
@@ -655,7 +655,7 @@ xfs_buf_item_committing(
 /*
  * This is the ops vector shared by all buf log items.
  */
-static struct xfs_item_ops xfs_buf_item_ops = {
+static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
 	.iop_format	= xfs_buf_item_format,
 	.iop_pin	= xfs_buf_item_pin,
Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-10-17 09:39:25.000177142 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-10-17 09:39:46.987721456 +0200
@@ -291,7 +291,7 @@ xfs_qm_dquot_logitem_committing(
 /*
  * This is the ops vector for dquots
  */
-static struct xfs_item_ops xfs_dquot_item_ops = {
+static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
@@ -479,7 +479,7 @@ xfs_qm_qoff_logitem_committing(
 {
 }
 
-static struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
+static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
@@ -494,7 +494,7 @@ static struct xfs_item_ops xfs_qm_qoffen
 /*
  * This is the ops vector shared by all quotaoff-start log items.
  */
-static struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
+static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2011-10-17 09:39:25.012151231 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2011-10-17 09:39:56.063648786 +0200
@@ -217,7 +217,7 @@ xfs_efi_item_committing(
 /*
  * This is the ops vector shared by all efi log items.
  */
-static struct xfs_item_ops xfs_efi_item_ops = {
+static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_pin	= xfs_efi_item_pin,
@@ -477,7 +477,7 @@ xfs_efd_item_committing(
 /*
  * This is the ops vector shared by all efd log items.
  */
-static struct xfs_item_ops xfs_efd_item_ops = {
+static const struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
 	.iop_pin	= xfs_efd_item_pin,
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-17 09:39:25.036150634 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-17 09:40:01.535150792 +0200
@@ -791,7 +791,7 @@ xfs_inode_item_committing(
 /*
  * This is the ops vector shared by all buf log items.
  */
-static struct xfs_item_ops xfs_inode_item_ops = {
+static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_size	= xfs_inode_item_size,
 	.iop_format	= xfs_inode_item_format,
 	.iop_pin	= xfs_inode_item_pin,
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-10-17 09:39:25.060149025 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-10-17 09:40:13.259151558 +0200
@@ -626,7 +626,7 @@ xfs_log_item_init(
 	struct xfs_mount	*mp,
 	struct xfs_log_item	*item,
 	int			type,
-	struct xfs_item_ops	*ops)
+	const struct xfs_item_ops *ops)
 {
 	item->li_mountp = mp;
 	item->li_ailp = mp->m_ail;
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2011-10-17 09:39:25.084150915 +0200
+++ xfs/fs/xfs/xfs_log.h	2011-10-17 09:40:22.839623827 +0200
@@ -137,7 +137,7 @@ struct xfs_trans;
 void	xfs_log_item_init(struct xfs_mount	*mp,
 			struct xfs_log_item	*item,
 			int			type,
-			struct xfs_item_ops	*ops);
+			const struct xfs_item_ops *ops);
 
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       struct xlog_ticket *ticket,
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-10-17 09:39:07.011650225 +0200
+++ xfs/fs/xfs/xfs_trans.h	2011-10-17 09:40:43.715147584 +0200
@@ -326,7 +326,7 @@ typedef struct xfs_log_item {
 						 struct xfs_log_item *);
 							/* buffer item iodone */
 							/* callback func */
-	struct xfs_item_ops		*li_ops;	/* function list */
+	const struct xfs_item_ops	*li_ops;	/* function list */
 
 	/* delayed logging */
 	struct list_head		li_cil;		/* CIL pointers */
@@ -341,7 +341,7 @@ typedef struct xfs_log_item {
 	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
 	{ XFS_LI_ABORTED,	"ABORTED" }
 
-typedef struct xfs_item_ops {
+struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
@@ -352,7 +352,7 @@ typedef struct xfs_item_ops {
 	void (*iop_push)(xfs_log_item_t *);
 	void (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
-} xfs_item_ops_t;
+};
 
 #define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
