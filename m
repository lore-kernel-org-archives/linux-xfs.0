Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KDjXRR094185 for <xfs@oss.sgi.com>; Fri, 20 May 2011 08:45:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8070CED2BB
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 06:45:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id I5BwinG9Hx2Q4j1h for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 06:45:32 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QNQ1E-00005L-0c
	for xfs@oss.sgi.com; Fri, 20 May 2011 13:45:32 +0000
Date: Fri, 20 May 2011 09:45:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4 v2] xfs: add online discard support
Message-ID: <20110520134531.GA30013@infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.156999943@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110504190011.156999943@bombadil.infradead.org>
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
blkdev_issue_discard once a transaction commits.

The actual discard is a two stage operation as we first have to mark
the busy extent as not available for reuse before we can start the
actual discard.  Note that we don't bother supporting discard for
the non-delaylog mode.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-05-20 15:25:42.005803658 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-05-20 15:30:10.748304489 +0200
@@ -110,8 +110,10 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
 #define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
 #define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
-#define MNTOPT_DELAYLOG   "delaylog"	/* Delayed loging enabled */
-#define MNTOPT_NODELAYLOG "nodelaylog"	/* Delayed loging disabled */
+#define MNTOPT_DELAYLOG    "delaylog"	/* Delayed loging enabled */
+#define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed loging disabled */
+#define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
+#define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
 
 /*
  * Table driven mount option parser.
@@ -355,6 +357,10 @@ xfs_parseargs(
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
@@ -388,6 +394,13 @@ xfs_parseargs(
 		return EINVAL;
 	}
 
+	if ((mp->m_flags & XFS_MOUNT_DISCARD) &&
+	    !(mp->m_flags & XFS_MOUNT_DELAYLOG)) {
+		xfs_warn(mp,
+	"the discard option is incompatible with the nodelaylog option");
+		return EINVAL;
+	}
+
 #ifndef CONFIG_XFS_QUOTA
 	if (XFS_IS_QUOTA_RUNNING(mp)) {
 		xfs_warn(mp, "quota support not available in this kernel.");
@@ -488,6 +501,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DELAYLOG,		"," MNTOPT_DELAYLOG },
+		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-05-20 15:25:42.025805406 +0200
+++ xfs/fs/xfs/xfs_mount.h	2011-05-20 15:25:59.189804374 +0200
@@ -224,6 +224,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
+#define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
 #define XFS_MOUNT_RETERR	(1ULL << 6)     /* return alignment errors to
 						   user */
 #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-05-20 15:25:42.033804966 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2011-05-20 15:25:59.197804089 +0200
@@ -29,6 +29,7 @@
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
+#include "xfs_discard.h"
 
 /*
  * Perform initial CIL structure initialisation. If the CIL is not
@@ -361,18 +362,28 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_alloc_busy_sort(&ctx->busy_extents);
-	xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, &ctx->busy_extents);
+	xfs_alloc_busy_clear(mp, &ctx->busy_extents,
+			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
 
 	spin_lock(&ctx->cil->xc_cil_lock);
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_cil_lock);
 
 	xlog_cil_free_logvec(ctx->lv_chain);
+
+	if (!list_empty(&ctx->busy_extents)) {
+		ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
+
+		xfs_discard_extents(mp, &ctx->busy_extents);
+		xfs_alloc_busy_clear(mp, &ctx->busy_extents, false);
+	}
+
 	kmem_free(ctx);
 }
 
Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-05-20 15:25:42.009803019 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-05-20 15:25:59.209804819 +0200
@@ -191,3 +191,32 @@ xfs_ioc_trim(
 		return -XFS_ERROR(EFAULT);
 	return 0;
 }
+
+int
+xfs_discard_extents(
+	struct xfs_mount	*mp,
+	struct list_head	*list)
+{
+	struct xfs_busy_extent	*busyp;
+	int			error = 0;
+
+	list_for_each_entry(busyp, list, list) {
+		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
+					 busyp->length);
+
+		error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, 0);
+		if (error && error != EOPNOTSUPP) {
+			xfs_info(mp,
+	 "discard failed for extent [0x%llu,%u], error %d",
+				 (unsigned long long)busyp->bno,
+				 busyp->length,
+				 error);
+			return error;
+		}
+	}
+
+	return 0;
+}
Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.h	2011-05-20 15:25:42.017803624 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-05-20 15:25:59.213864508 +0200
@@ -2,7 +2,9 @@
 #define XFS_DISCARD_H 1
 
 struct fstrim_range;
+struct list_head;
 
 extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
+extern int	xfs_discard_extents(struct xfs_mount *, struct list_head *);
 
 #endif /* XFS_DISCARD_H */
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-05-20 15:25:42.045804125 +0200
+++ xfs/fs/xfs/xfs_ag.h	2011-05-20 15:25:59.217804311 +0200
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
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-05-20 15:25:52.409233306 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-05-20 15:27:46.436367797 +0200
@@ -2609,6 +2609,18 @@ xfs_alloc_busy_update_extent(
 	xfs_agblock_t		bend = bbno + busyp->length;
 
 	/*
+	 * This extent is currently being discarded.  Give the thread
+	 * performing the discard a chance to mark the extent unbusy
+	 * and retry.
+	 */
+	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED) {
+		spin_unlock(&pag->pagb_lock);
+		delay(1);
+		spin_lock(&pag->pagb_lock);
+		return false;
+	}
+
+	/*
 	 * If there is a busy extent overlapping a user allocation, we have
 	 * no choice but to force the log and retry the search.
 	 *
@@ -2813,7 +2825,8 @@ restart:
 		 * If this is a metadata allocation, try to reuse the busy
 		 * extent instead of trimming the allocation.
 		 */
-		if (!args->userdata) {
+		if (!args->userdata &&
+		    !(busyp->flags & XFS_ALLOC_BUSY_DISCARDED)) {
 			if (!xfs_alloc_busy_update_extent(args->mp, args->pag,
 							  busyp, fbno, flen,
 							  false))
@@ -2979,10 +2992,16 @@ xfs_alloc_busy_clear_one(
 	kmem_free(busyp);
 }
 
+/*
+ * Remove all extents on the passed in list from the busy extents tree.
+ * If do_discard is set skip extents that need to be discarded, and mark
+ * these as undergoing a discard operation instead.
+ */
 void
 xfs_alloc_busy_clear(
 	struct xfs_mount	*mp,
-	struct list_head	*list)
+	struct list_head	*list,
+	bool			do_discard)
 {
 	struct xfs_busy_extent	*busyp, *n;
 	struct xfs_perag	*pag = NULL;
@@ -2999,7 +3018,10 @@ xfs_alloc_busy_clear(
 			agno = busyp->agno;
 		}
 
-		xfs_alloc_busy_clear_one(mp, pag, busyp);
+		if (do_discard && busyp->length)
+			busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
+		else
+			xfs_alloc_busy_clear_one(mp, pag, busyp);
 	}
 
 	if (pag) {
Index: xfs/Documentation/filesystems/xfs.txt
===================================================================
--- xfs.orig/Documentation/filesystems/xfs.txt	2011-05-20 15:25:42.096307936 +0200
+++ xfs/Documentation/filesystems/xfs.txt	2011-05-20 15:30:29.096409728 +0200
@@ -39,6 +39,12 @@ When mounting an XFS filesystem, the fol
 	drive level write caching to be enabled, for devices that
 	support write barriers.
 
+  discard
+	Issue command to let the block device reclaim space freed by the
+	filesystem.  This is useful for SSD devices, thinly provisioned
+	LUNs and virtual machine images, but may have a performance
+	impact.  This option is incompatible with the nodelaylog option.
+
   dmapi
 	Enable the DMAPI (Data Management API) event callouts.
 	Use with the "mtpt" option.
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-05-20 15:25:42.065803648 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2011-05-20 15:25:59.225803393 +0200
@@ -140,7 +140,8 @@ xfs_alloc_busy_insert(struct xfs_trans *
 	xfs_agblock_t bno, xfs_extlen_t len);
 
 void
-xfs_alloc_busy_clear(struct xfs_mount *mp, struct list_head *list);
+xfs_alloc_busy_clear(struct xfs_mount *mp, struct list_head *list,
+	bool do_discard);
 
 int
 xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-05-20 15:25:42.077804275 +0200
+++ xfs/fs/xfs/xfs_trans.c	2011-05-20 15:25:59.229804062 +0200
@@ -609,7 +609,7 @@ xfs_trans_free(
 	struct xfs_trans	*tp)
 {
 	xfs_alloc_busy_sort(&tp->t_busy);
-	xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy);
+	xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	atomic_dec(&tp->t_mountp->m_active_trans);
 	xfs_trans_free_dqinfo(tp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
