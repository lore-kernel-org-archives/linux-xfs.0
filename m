Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3bxG145265 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61877203840
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QN2gfiWCQenJZSIc for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHj-0002r9-Ji
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:35 +0000
Message-Id: <20111028100335.558259060@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/45] xfs: constify xfs_item_ops
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-constify-xfs_item_ops
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

The log item ops aren't nessecarily the biggest exploit vector, but marking
them const is easy enough.  Also remove the unused xfs_item_ops_t typedef
while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_buf_item.c     |    2 +-
 fs/xfs/xfs_dquot_item.c   |    6 +++---
 fs/xfs/xfs_extfree_item.c |    4 ++--
 fs/xfs/xfs_inode_item.c   |    2 +-
 fs/xfs/xfs_log.c          |    2 +-
 fs/xfs/xfs_log.h          |    2 +-
 fs/xfs/xfs_trans.h        |    6 +++---
 7 files changed, 12 insertions(+), 12 deletions(-)

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-27 22:39:37.124671335 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-27 22:39:42.528674212 +0200
@@ -656,7 +656,7 @@ xfs_buf_item_committing(
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
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-10-27 22:39:37.128671186 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-10-27 22:39:42.528674212 +0200
@@ -295,7 +295,7 @@ xfs_qm_dquot_logitem_committing(
 /*
  * This is the ops vector for dquots
  */
-static struct xfs_item_ops xfs_dquot_item_ops = {
+static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
@@ -483,7 +483,7 @@ xfs_qm_qoff_logitem_committing(
 {
 }
 
-static struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
+static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
@@ -498,7 +498,7 @@ static struct xfs_item_ops xfs_qm_qoffen
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
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2011-10-27 22:39:37.136671437 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2011-10-27 22:39:42.528674212 +0200
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
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-27 22:39:37.148670941 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-27 22:39:42.528674212 +0200
@@ -795,7 +795,7 @@ xfs_inode_item_committing(
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
--- xfs.orig/fs/xfs/xfs_log.c	2011-10-27 22:39:37.152670108 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-10-27 22:39:42.532670748 +0200
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
--- xfs.orig/fs/xfs/xfs_log.h	2011-10-27 22:39:37.160671381 +0200
+++ xfs/fs/xfs/xfs_log.h	2011-10-27 22:39:42.536670491 +0200
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
--- xfs.orig/fs/xfs/xfs_trans.h	2011-10-27 22:39:37.168672757 +0200
+++ xfs/fs/xfs/xfs_trans.h	2011-10-27 22:39:42.536670491 +0200
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
 	bool (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
-} xfs_item_ops_t;
+};
 
 #define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
