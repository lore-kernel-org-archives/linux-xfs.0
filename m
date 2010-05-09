Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49Hmb9C231767 for <xfs@oss.sgi.com>; Sun, 9 May 2010 12:48:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D1468FB1B5
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 10:51:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mHKBod0nkVTuvSCp for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 10:51:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OBAeO-0000cP-CF
	for xfs@oss.sgi.com; Sun, 09 May 2010 17:50:48 +0000
Date: Sun, 9 May 2010 13:50:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: add discard support (at transaction commit)
Message-ID: <20100509175048.GA1435@infradead.org>
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

Now that we have reliably tracking of deleted extents in a transaction
we can easily implement "online" discard support which calls
blkdev_issue_discard once a transaction commits.  We simply have to
walk the list of busy extents after transaction commit, but before deleting
it from the rbtree tracking these busy extents.

This does not replace by background discard support patch which is probably
better for thin provisioned arrays - I will updated it to apply ontop of
this patch when I'm ready to re-submit it.

[Note: this patch needs Dave's delayed-logging series any patch titled
 "xfs: simplify log item descriptor tracking" applied]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-05-09 19:08:34.544262404 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-05-09 19:09:24.975032203 +0200
@@ -2761,3 +2761,25 @@ xfs_alloc_busy_clear(
 
 	kmem_free(busyp);
 }
+
+int
+xfs_discard_extent(
+	struct xfs_mount	*mp,
+	struct xfs_busy_extent	*busyp)
+{
+	int			error = 0;
+	xfs_daddr_t		bno;
+	__int64_t		len;
+
+	if ((mp->m_flags & XFS_MOUNT_DISCARD) == 0)
+		return 0;
+
+	bno = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
+	len = XFS_FSB_TO_BB(mp, busyp->length);
+
+	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, bno, len,
+				      GFP_NOFS, DISCARD_FL_BARRIER);
+	if (error && error != EOPNOTSUPP)
+		xfs_fs_cmn_err(CE_NOTE, mp, "discard failed, error %d", error);
+	return error;
+}
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2010-05-09 19:08:34.551265756 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2010-05-09 19:09:16.213023263 +0200
@@ -128,6 +128,9 @@ xfs_alloc_busy_insert(xfs_trans_t *tp,
 void
 xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
 
+int
+xfs_discard_extent(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
+
 #endif	/* __KERNEL__ */
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-05-09 19:08:34.562254302 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-05-09 19:09:16.223693748 +0200
@@ -120,6 +120,8 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_DELAYLOG   "delaylog"	/* Delayed loging enabled */
 #define MNTOPT_NODELAYLOG "nodelaylog"	/* Delayed loging disabled */
+#define MNTOPT_DISCARD	"discard"	/* Discard unused blocks */
+#define MNTOPT_NODISCARD "nodiscard"	/* Do not discard unused blocks */
 
 /*
  * Table driven mount option parser.
@@ -382,6 +384,10 @@ xfs_parseargs(
 				"- use at your own risk.\n");
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
 			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
+		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
+			mp->m_flags |= XFS_MOUNT_DISCARD;
+		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
+			mp->m_flags &= ~XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			cmn_err(CE_WARN,
 	"XFS: ihashsize no longer used, option is deprecated.");
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-05-09 19:08:34.571254232 +0200
+++ xfs/fs/xfs/xfs_mount.h	2010-05-09 19:09:16.231005734 +0200
@@ -274,6 +274,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
+#define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
 #define XFS_MOUNT_RETERR	(1ULL << 6)     /* return alignment errors to
 						   user */
 #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2010-05-09 19:08:34.580004407 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2010-05-09 19:09:16.241255699 +0200
@@ -415,6 +415,7 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 	struct xfs_log_vec	*lv;
 	int			abortflag = abort ? XFS_LI_ABORTED : 0;
 	struct xfs_busy_extent	*busyp, *n;
@@ -425,8 +426,10 @@ xlog_cil_committed(
 							abortflag);
 	}
 
-	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
-		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
+	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list) {
+		xfs_discard_extent(mp, busyp);
+		xfs_alloc_busy_clear(mp, busyp);
+	}
 
 	spin_lock(&ctx->cil->xc_cil_lock);
 	list_del(&ctx->committing);
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-09 19:08:34.596025010 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-09 19:09:16.252005804 +0200
@@ -1398,6 +1398,7 @@ xfs_trans_committed(
 	int			abortflag)
 {
 	struct xfs_log_item_desc *lidp, *next;
+	struct xfs_busy_extent	*busyp;
 
 	/* Call the transaction's completion callback if there is one. */
 	if (tp->t_callback != NULL)
@@ -1408,6 +1409,9 @@ xfs_trans_committed(
 		xfs_trans_free_item_desc(lidp);
 	}
 
+	list_for_each_entry(busyp, &tp->t_busy, list)
+		xfs_discard_extent(tp->t_mountp, busyp);
+
 	xfs_trans_free(tp);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
