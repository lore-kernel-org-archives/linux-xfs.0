Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2VBQfTG137793 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 06:26:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B12339184C
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XtbgDi0hRhwuXgOR for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:53 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q5G4W-0006QZ-Lj
	for xfs@oss.sgi.com; Thu, 31 Mar 2011 11:29:52 +0000
Message-Id: <20110331112952.612138557@bombadil.infradead.org>
Date: Thu, 31 Mar 2011 07:28:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: add online discard support
References: <20110331112850.980290062@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-online-discard-support
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

Now that we have reliably tracking of deleted extents in a transaction
we can easily implement "online" discard support which calls
blkdev_issue_discard once a transaction commits.

The actual discard is a two stage operation as we first have to mark
the busy extent as not available for reuse before we can start the
actual discard.  Note that we don't bother supporting discard for
the non-delaylog mode.  While that would be possible with this patch
performance is awfull, and the optimization in the next patch won't
work as easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-03-31 12:27:53.514091439 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-03-31 12:27:55.467590841 +0200
@@ -112,6 +112,8 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
 #define MNTOPT_DELAYLOG   "delaylog"	/* Delayed loging enabled */
 #define MNTOPT_NODELAYLOG "nodelaylog"	/* Delayed loging disabled */
+#define MNTOPT_DISCARD	"discard"	/* Discard unused blocks */
+#define MNTOPT_NODISCARD "nodiscard"	/* Do not discard unused blocks */
 
 /*
  * Table driven mount option parser.
@@ -356,6 +358,10 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DELAYLOG;
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
 			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
+		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
+			mp->m_flags |= XFS_MOUNT_DISCARD;
+		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
+			mp->m_flags &= ~XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			xfs_warn(mp,
 	"ihashsize no longer used, option is deprecated.");
@@ -489,6 +495,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DELAYLOG,		"," MNTOPT_DELAYLOG },
+		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-03-31 12:27:27.447588560 +0200
+++ xfs/fs/xfs/xfs_mount.h	2011-03-31 12:27:55.467590841 +0200
@@ -227,6 +227,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
+#define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
 #define XFS_MOUNT_RETERR	(1ULL << 6)     /* return alignment errors to
 						   user */
 #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-03-31 12:27:54.635590592 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2011-03-31 12:27:55.471596336 +0200
@@ -29,6 +29,7 @@
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
+#include "xfs_discard.h"
 
 static void
 xlog_cil_ctx_free(
@@ -396,10 +397,18 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
+	if ((mp->m_flags & XFS_MOUNT_DISCARD) && !abort) {
+		struct xfs_busy_extent *busyp;
+
+		list_for_each_entry(busyp, &ctx->busy_extents, list)
+			xfs_discard_extent(mp, busyp);
+	}
+
 	spin_lock(&ctx->cil->xc_cil_lock);
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_cil_lock);
Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-03-31 12:27:27.431588558 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-03-31 12:27:55.471596336 +0200
@@ -191,3 +191,30 @@ xfs_ioc_trim(
 		return -XFS_ERROR(EFAULT);
 	return 0;
 }
+
+int
+xfs_discard_extent(
+	struct xfs_mount	*mp,
+	struct xfs_busy_extent	*busyp)
+{
+	int			error = 0;
+
+	if (!xfs_alloc_busy_prepare_discard(mp, busyp))
+		return 0;
+
+	trace_xfs_discard_extent(mp, busyp->agno, busyp->bno, busyp->length);
+
+	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+			XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+			XFS_FSB_TO_BB(mp, busyp->length),
+			GFP_NOFS, 0);
+	if (error && error != EOPNOTSUPP) {
+		xfs_info(mp,
+			 "discard failed for extent [0x%llu,%u], error %d",
+			 (unsigned long long)busyp->bno,
+			 busyp->length,
+			 error);
+	}
+
+	return error;
+}
Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.h	2011-03-31 12:27:27.443588438 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-03-31 12:27:55.475651908 +0200
@@ -2,7 +2,11 @@
 #define XFS_DISCARD_H 1
 
 struct fstrim_range;
+struct xfs_busy_extent;
 
 extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
 
+extern int	xfs_discard_extent(struct xfs_mount *,
+				   struct xfs_busy_extent *);
+
 #endif /* XFS_DISCARD_H */
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-03-31 12:27:27.459588326 +0200
+++ xfs/fs/xfs/xfs_ag.h	2011-03-31 12:27:55.475651908 +0200
@@ -187,6 +187,8 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
+	unsigned int	flags;
+#define XFS_ALLOC_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
 };
 
 /*
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-31 12:27:27.471588799 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-31 12:28:19.514090846 +0200
@@ -2594,6 +2594,15 @@ xfs_alloc_busy_update_extent(
 	xfs_agblock_t		bend = bbno + busyp->length;
 
 	/*
+	 * This extent is currently beeing discard.  Flush the discard
+	 * completion queue and retry the search.
+	 */
+	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED) {
+		spin_unlock(&pag->pagb_lock);
+		return false;
+	}
+
+	/*
 	 * If there is a busy extent verlapping a user allocation, we have
 	 * no chance but to force the log and retry the search.
 	 *
@@ -2798,7 +2807,8 @@ restart:
 		 * If this is a metadata allocation, try to reuse the busy
 		 * extent instead of trimming the allocation.
 		 */
-		if (!args->userdata) {
+		if (!args->userdata &&
+		    !(busyp->flags & XFS_ALLOC_BUSY_DISCARDED)) {
 			if (!xfs_alloc_busy_update_extent(args->mp, args->pag,
 							  busyp, fbno, flen,
 							  false))
@@ -2952,6 +2962,29 @@ fail:
 	*rlen = 0;
 }
 
+/*
+ * Mark the busy extent as undergoing a discard operations, or return false
+ * in case it should not be discarded.
+ */
+bool
+xfs_alloc_busy_prepare_discard(
+	struct xfs_mount	*mp,
+	struct xfs_busy_extent	*busyp)
+{
+	struct xfs_perag	*pag;
+	bool			ret = true;
+
+	pag = xfs_perag_get(mp, busyp->agno);
+	spin_lock(&pag->pagb_lock);
+	if (!busyp->length)
+		ret = false;
+	busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+
+	return ret;
+}
+
 void
 xfs_alloc_busy_clear(
 	struct xfs_mount	*mp,
Index: xfs/Documentation/filesystems/xfs.txt
===================================================================
--- xfs.orig/Documentation/filesystems/xfs.txt	2011-03-31 12:27:27.487588704 +0200
+++ xfs/Documentation/filesystems/xfs.txt	2011-03-31 12:27:55.483617993 +0200
@@ -39,6 +39,12 @@ When mounting an XFS filesystem, the fol
 	drive level write caching to be enabled, for devices that
 	support write barriers.
 
+  discard
+	Issue command to let the block device reclaim space freed by the
+	filesystem.  This is useful for SSD devices, thinly provisioned
+	LUNs and virtual machine images, but may have a performance
+	impact.
+
   dmapi
 	Enable the DMAPI (Data Management API) event callouts.
 	Use with the "mtpt" option.
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-03-31 12:27:27.479588871 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2011-03-31 12:27:55.483617993 +0200
@@ -149,6 +149,10 @@ xfs_alloc_busy_search(struct xfs_mount *
 void
 xfs_alloc_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
+
+bool
+xfs_alloc_busy_prepare_discard(struct xfs_mount *mp,
+	struct xfs_busy_extent *busyp);
 #endif	/* __KERNEL__ */
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
