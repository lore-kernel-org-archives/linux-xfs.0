Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MJwcqu046887 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 14:58:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE3D1159C014
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 13:01:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ByCEbjGT7At98hzI for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2011 13:01:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q27lq-0000sO-21
	for xfs@oss.sgi.com; Tue, 22 Mar 2011 20:01:38 +0000
Message-Id: <20110322200138.024991786@bombadil.infradead.org>
Date: Tue, 22 Mar 2011 15:55:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/6] xfs: add online discard support
References: <20110322195550.260682574@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-03-21 14:51:40.806473979 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-03-21 14:51:41.437974814 +0100
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
--- xfs.orig/fs/xfs/xfs_mount.h	2011-03-21 14:47:03.630474095 +0100
+++ xfs/fs/xfs/xfs_mount.h	2011-03-21 14:51:41.437974814 +0100
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
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-03-21 14:47:03.638475274 +0100
+++ xfs/fs/xfs/xfs_log_cil.c	2011-03-21 14:51:41.441975564 +0100
@@ -29,6 +29,7 @@
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
+#include "xfs_discard.h"
 
 /*
  * Perform initial CIL structure initialisation. If the CIL is not
@@ -361,13 +362,17 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
+	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 	struct xfs_busy_extent	*busyp, *n;
 
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
-	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
-		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
+	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list) {
+		if (!abort)
+			xfs_discard_extent(mp, busyp);
+		xfs_alloc_busy_clear(mp, busyp);
+	}
 
 	spin_lock(&ctx->cil->xc_cil_lock);
 	list_del(&ctx->committing);
Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-03-21 14:47:03.614474345 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-03-21 14:51:41.449976366 +0100
@@ -191,3 +191,38 @@ xfs_ioc_trim(
 		return -XFS_ERROR(EFAULT);
 	return 0;
 }
+
+int
+xfs_discard_extent(
+	struct xfs_mount	*mp,
+	struct xfs_busy_extent	*busyp)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	xfs_daddr_t		bno;
+	int64_t			len;
+	bool			done  = false;
+
+	if ((mp->m_flags & XFS_MOUNT_DISCARD) == 0)
+		return 0;
+
+	bno = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
+	len = XFS_FSB_TO_BB(mp, busyp->length);
+
+	pag = xfs_perag_get(mp, busyp->agno);
+	spin_lock(&pag->pagb_lock);
+	if (!busyp->length)
+		done = true;
+	busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+
+	if (done)
+		return 0;
+
+	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, bno, len,
+				      GFP_NOFS, 0);
+	if (error && error != EOPNOTSUPP)
+		xfs_info(mp, "discard failed, error %d", error);
+	return error;
+}
Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_discard.h	2011-03-21 14:47:03.622475346 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-03-21 14:51:41.453973708 +0100
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
--- xfs.orig/fs/xfs/xfs_ag.h	2011-03-21 14:49:21.941981228 +0100
+++ xfs/fs/xfs/xfs_ag.h	2011-03-21 14:51:41.457976522 +0100
@@ -189,6 +189,7 @@ struct xfs_busy_extent {
 	xfs_extlen_t	length;
 	unsigned int	flags;
 #define XFS_ALLOC_BUSY_USERDATA		0x01	/* freed data extents */
+#define XFS_ALLOC_BUSY_DISCARDED	0x02	/* can't be reused */
 };
 
 /*
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-21 14:51:31.746155282 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-21 14:51:41.457976522 +0100
@@ -2586,6 +2586,9 @@ xfs_alloc_busy_try_reuse(
 	xfs_agblock_t	bbno = busyp->bno;
 	xfs_agblock_t	bend = bbno + busyp->length;
 
+	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED)
+		return -1;
+
 	if (bbno < fbno && bend > fend) {
 		/*
 		 * Case 1:
@@ -2778,8 +2781,9 @@ restart:
 			continue;
 		}
 
-		if (!args->userdata ||
-		    (busyp->flags & XFS_ALLOC_BUSY_USERDATA)) {
+		if (!(busyp->flags & XFS_ALLOC_BUSY_DISCARDED) &&
+		    (!args->userdata ||
+		     (busyp->flags & XFS_ALLOC_BUSY_USERDATA))) {
 			int overlap;
 
 			overlap = xfs_alloc_busy_try_reuse(args->pag, busyp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
