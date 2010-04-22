Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MH8Yov218199 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:08:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C52388A5DAE
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 10:10:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rV5bWUArEDmpxzGI for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 10:10:35 -0700 (PDT)
Date: Thu, 22 Apr 2010 13:10:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Improve scalability of busy extent tracking
Message-ID: <20100422171035.GA29007@infradead.org>
References: <1271828835-2094-1-git-send-email-david@fromorbit.com>
	<20100422110758.GA22295@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422110758.GA22295@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 22, 2010 at 07:07:58AM -0400, Christoph Hellwig wrote:
> Oh, and while I'm at it:
> 
> I'd move the list_del_init(&busyp->list); from xfs_trans_free_busy into
> xfs_alloc_clear_busy, we also do the list insertation inside
> xfs_alloc_busy_insert, so that makes it symmetic.

Or just merge the loop calling xfs_alloc_clear_busy directly in
xfs_trans_free, ala:


Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-04-22 18:59:11.031004018 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-04-22 18:59:38.639005695 +0200
@@ -2667,6 +2667,8 @@ xfs_alloc_clear_busy(
 	ASSERT(xfs_alloc_busy_search(mp, busyp->agno, busyp->bno,
 						busyp->length) == 1);
 
+	list_del_init(&busyp->list);
+
 	pag = xfs_perag_get(mp, busyp->agno);
 	spin_lock(&pag->pagb_lock);
 	rb_erase(&busyp->rb_node, &pag->pagb_tree);
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-04-22 18:59:11.047273888 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-04-22 19:03:53.613255663 +0200
@@ -620,8 +620,13 @@ _xfs_trans_alloc(
  */
 STATIC void
 xfs_trans_free(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
+	struct xfs_busy_extent	*busyp, *n;
+
+	list_for_each_entry_safe(busyp, n, &tp->t_busy, list)
+		xfs_alloc_clear_busy(tp->t_mountp, busyp);
+
 	atomic_dec(&tp->t_mountp->m_active_trans);
 	xfs_trans_free_dqinfo(tp);
 	kmem_zone_free(xfs_trans_zone, tp);
@@ -795,23 +800,6 @@ undo_blocks:
 }
 
 /*
- * xfs_trans_free_busy
- * Free all of the busy extents from a transaction
- */
-void
-xfs_trans_free_busy(
-	struct xfs_mount	*mp,
-	struct list_head	*busy_list)
-{
-	struct xfs_busy_extent	*busyp, *n;
-
-	list_for_each_entry_safe(busyp, n, busy_list, list) {
-		list_del_init(&busyp->list);
-		xfs_alloc_clear_busy(mp, busyp);
-	}
-}
-
-/*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
  * For now, just store the change in the transaction structure.
@@ -1351,7 +1339,6 @@ xfs_trans_committed(
 		kmem_free(licp);
 	}
 
-	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
 	xfs_trans_free(tp);
 }
 
@@ -1380,7 +1367,6 @@ xfs_trans_uncommit(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	xfs_trans_free_items(tp, flags);
-	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
 	xfs_trans_free(tp);
 }
 
@@ -1629,7 +1615,6 @@ out_unreserve:
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free_items(tp, error ? XFS_TRANS_ABORT : 0);
-	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
 	xfs_trans_free(tp);
 
 	XFS_STATS_INC(xs_trans_empty);
@@ -1708,7 +1693,6 @@ xfs_trans_cancel(
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 
 	xfs_trans_free_items(tp, flags);
-	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
 	xfs_trans_free(tp);
 }
 
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2010-04-22 18:59:59.745004088 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2010-04-22 19:00:03.734255103 +0200
@@ -39,8 +39,6 @@ void				xfs_trans_free_items(struct xfs_
 void				xfs_trans_unlock_items(struct xfs_trans *,
 							xfs_lsn_t);
 
-void	xfs_trans_free_busy(struct xfs_mount *mp, struct list_head *busy_list);
-
 /*
  * AIL traversal cursor.
  *

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
