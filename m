Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3dNl145337 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C6121CC6FB0
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pYZaVbIV9RER6i9a for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHl-0002wL-Kn
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:37 +0000
Message-Id: <20111028100337.591556948@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/45] xfs: use per-filesystem I/O completion workqueues
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-split-workqueues
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

The new concurrency managed workqueues are cheap enough that we can create
per-filesystem instead of global workqueues.  This allows us to remove the
trylock or defer scheme on the ilock, which is not helpful once we have
outstanding log reservations until finishing a size update.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_aops.c  |   39 ++++++++++-----------------------------
 fs/xfs/xfs_aops.h  |    2 --
 fs/xfs/xfs_buf.c   |   17 -----------------
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_super.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 55 insertions(+), 49 deletions(-)

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-10-27 22:39:56.902173367 +0200
+++ xfs/fs/xfs/xfs_aops.c	2011-10-27 22:39:57.490177027 +0200
@@ -126,21 +126,15 @@ static inline bool xfs_ioend_is_append(s
 
 /*
  * Update on-disk file size now that data has been written to disk.
- *
- * This function does not block as blocking on the inode lock in IO completion
- * can lead to IO completion order dependency deadlocks.. If it can't get the
- * inode ilock it will return EAGAIN. Callers must handle this.
  */
-STATIC int
+STATIC void
 xfs_setfilesize(
-	xfs_ioend_t		*ioend)
+	struct xfs_ioend	*ioend)
 {
-	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-		return EAGAIN;
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
 		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
@@ -149,7 +143,6 @@ xfs_setfilesize(
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
 /*
@@ -163,10 +156,12 @@ xfs_finish_ioend(
 	struct xfs_ioend	*ioend)
 {
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
+		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
+
 		if (ioend->io_type == IO_UNWRITTEN)
-			queue_work(xfsconvertd_workqueue, &ioend->io_work);
+			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (xfs_ioend_is_append(ioend))
-			queue_work(xfsdatad_workqueue, &ioend->io_work);
+			queue_work(mp->m_data_workqueue, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
 	}
@@ -207,23 +202,9 @@ xfs_end_io(
 	 * We might have to update the on-disk file size after extending
 	 * writes.
 	 */
-	error = xfs_setfilesize(ioend);
-	ASSERT(!error || error == EAGAIN);
-
+	xfs_setfilesize(ioend);
 done:
-	/*
-	 * If we didn't complete processing of the ioend, requeue it to the
-	 * tail of the workqueue for another attempt later. Otherwise destroy
-	 * it.
-	 */
-	if (error == EAGAIN) {
-		atomic_inc(&ioend->io_remaining);
-		xfs_finish_ioend(ioend);
-		/* ensure we don't spin on blocked ioends */
-		delay(1);
-	} else {
-		xfs_destroy_ioend(ioend);
-	}
+	xfs_destroy_ioend(ioend);
 }
 
 /*
Index: xfs/fs/xfs/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.h	2011-10-27 22:39:35.702172559 +0200
+++ xfs/fs/xfs/xfs_aops.h	2011-10-27 22:39:57.490177027 +0200
@@ -18,8 +18,6 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
-extern struct workqueue_struct *xfsdatad_workqueue;
-extern struct workqueue_struct *xfsconvertd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-27 22:39:35.714171799 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-27 22:39:57.490177027 +0200
@@ -45,8 +45,6 @@ static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
 
 static struct workqueue_struct *xfslogd_workqueue;
-struct workqueue_struct *xfsdatad_workqueue;
-struct workqueue_struct *xfsconvertd_workqueue;
 
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
@@ -1797,21 +1795,8 @@ xfs_buf_init(void)
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = alloc_workqueue("xfsdatad", WQ_MEM_RECLAIM, 1);
-	if (!xfsdatad_workqueue)
-		goto out_destroy_xfslogd_workqueue;
-
-	xfsconvertd_workqueue = alloc_workqueue("xfsconvertd",
-						WQ_MEM_RECLAIM, 1);
-	if (!xfsconvertd_workqueue)
-		goto out_destroy_xfsdatad_workqueue;
-
 	return 0;
 
- out_destroy_xfsdatad_workqueue:
-	destroy_workqueue(xfsdatad_workqueue);
- out_destroy_xfslogd_workqueue:
-	destroy_workqueue(xfslogd_workqueue);
  out_free_buf_zone:
 	kmem_zone_destroy(xfs_buf_zone);
  out:
@@ -1821,8 +1806,6 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	destroy_workqueue(xfsconvertd_workqueue);
-	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
 }
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-10-27 22:39:53.702172231 +0200
+++ xfs/fs/xfs/xfs_super.c	2011-10-27 22:39:57.498171619 +0200
@@ -769,6 +769,40 @@ xfs_setup_devices(
 	return 0;
 }
 
+STATIC int
+xfs_init_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+#define XFS_WQ_NAME_LEN		512
+	char			name[XFS_WQ_NAME_LEN];
+
+	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
+	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+	if (!mp->m_data_workqueue)
+		goto out;
+
+	snprintf(name, XFS_WQ_NAME_LEN, "xfs-conv/%s", mp->m_fsname);
+	mp->m_unwritten_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+	if (!mp->m_unwritten_workqueue)
+		goto out_destroy_data_iodone_queue;
+
+	return 0;
+
+out_destroy_data_iodone_queue:
+	destroy_workqueue(mp->m_data_workqueue);
+out:
+	return -ENOMEM;
+#undef XFS_WQ_NAME_LEN
+}
+
+STATIC void
+xfs_destroy_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+	destroy_workqueue(mp->m_data_workqueue);
+	destroy_workqueue(mp->m_unwritten_workqueue);
+}
+
 /* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
 xfs_fs_alloc_inode(
@@ -1012,6 +1046,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
+	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
 	xfs_free_fsname(mp);
 	kfree(mp);
@@ -1345,10 +1380,14 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_fsname;
 
-	error = xfs_icsb_init_counters(mp);
+	error = xfs_init_mount_workqueues(mp);
 	if (error)
 		goto out_close_devices;
 
+	error = xfs_icsb_init_counters(mp);
+	if (error)
+		goto out_destroy_workqueues;
+
 	error = xfs_readsb(mp, flags);
 	if (error)
 		goto out_destroy_counters;
@@ -1411,6 +1450,8 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
+out_destroy_workqueues:
+	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-10-27 22:39:35.738171837 +0200
+++ xfs/fs/xfs/xfs_mount.h	2011-10-27 22:39:57.502188861 +0200
@@ -211,6 +211,9 @@ typedef struct xfs_mount {
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+
+	struct workqueue_struct	*m_data_workqueue;
+	struct workqueue_struct	*m_unwritten_workqueue;
 } xfs_mount_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
