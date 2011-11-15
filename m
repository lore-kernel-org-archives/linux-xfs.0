Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFKET2b067894 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 14:14:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AAB424FCAE
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:14:27 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	v62iOBojiU33oFw9 for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 12:14:27 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RQPOk-0007Rq-Nh
	for xfs@oss.sgi.com; Tue, 15 Nov 2011 20:14:26 +0000
Message-Id: <20111115201426.686729205@bombadil.infradead.org>
Date: Tue, 15 Nov 2011 15:14:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
References: <20111115201407.038216766@bombadil.infradead.org>
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

commit 77d7a0c "xfs: Non-blocking inode locking in IO completion" introduced
a trylocked and defer scheme in xfs_setfilesize to avoid deadlocks when on
XFS filesystem is used ontop of another using the loop device, and we
fsync in the loop filesystem.

Now that we have the cheap enough concurrency managed workqueues, we can
create per-filesystem instead of global workqueues and remove this scheme
again, given that it has the potential of delaying size updates and is not
helpful once we start to log the inode size.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_aops.c  |   39 ++++++++++-----------------------------
 fs/xfs/xfs_aops.h  |    2 --
 fs/xfs/xfs_buf.c   |   17 -----------------
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_super.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 55 insertions(+), 49 deletions(-)

Index: linux-2.6/fs/xfs/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_aops.c	2011-11-12 15:37:28.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_aops.c	2011-11-15 09:14:16.856650210 +0100
@@ -131,21 +131,15 @@ static inline bool xfs_ioend_is_append(s
  * will be the intended file size until i_size is updated.  If this write does
  * not extend all the way to the valid file size then restrict this update to
  * the end of the write.
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
@@ -154,7 +148,6 @@ xfs_setfilesize(
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
 /*
@@ -168,10 +161,12 @@ xfs_finish_ioend(
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
@@ -212,23 +207,9 @@ xfs_end_io(
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
Index: linux-2.6/fs/xfs/xfs_aops.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_aops.h	2011-11-10 16:50:40.751797337 +0100
+++ linux-2.6/fs/xfs/xfs_aops.h	2011-11-15 09:14:16.856650210 +0100
@@ -18,8 +18,6 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
-extern struct workqueue_struct *xfsdatad_workqueue;
-extern struct workqueue_struct *xfsconvertd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
Index: linux-2.6/fs/xfs/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_buf.c	2011-11-10 16:50:40.763795564 +0100
+++ linux-2.6/fs/xfs/xfs_buf.c	2011-11-15 09:14:16.859983547 +0100
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
Index: linux-2.6/fs/xfs/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_super.c	2011-11-10 16:50:40.771795378 +0100
+++ linux-2.6/fs/xfs/xfs_super.c	2011-11-15 09:17:13.763315819 +0100
@@ -769,6 +769,42 @@ xfs_setup_devices(
 	return 0;
 }
 
+STATIC int
+xfs_init_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+	snprintf(mp->m_data_workqueue_name, XFS_WQ_NAME_LEN,
+		 "xfs-data/%s", mp->m_fsname);
+	mp->m_data_workqueue =
+		alloc_workqueue(mp->m_data_workqueue_name, WQ_MEM_RECLAIM, 1);
+	if (!mp->m_data_workqueue)
+		goto out;
+
+	snprintf(mp->m_unwritten_workqueue_name, XFS_WQ_NAME_LEN,
+		 "xfs-conv/%s", mp->m_fsname);
+	mp->m_unwritten_workqueue =
+		alloc_workqueue(mp->m_unwritten_workqueue_name,
+				WQ_MEM_RECLAIM, 1);
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
@@ -1020,6 +1056,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
+	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
 	xfs_free_fsname(mp);
 	kfree(mp);
@@ -1353,10 +1390,14 @@ xfs_fs_fill_super(
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
@@ -1419,6 +1460,8 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
+out_destroy_workqueues:
+	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
Index: linux-2.6/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.h	2011-11-10 16:50:40.787796774 +0100
+++ linux-2.6/fs/xfs/xfs_mount.h	2011-11-15 09:15:25.053316473 +0100
@@ -211,6 +211,12 @@ typedef struct xfs_mount {
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+
+	struct workqueue_struct	*m_data_workqueue;
+	struct workqueue_struct	*m_unwritten_workqueue;
+#define XFS_WQ_NAME_LEN		512
+	char			m_data_workqueue_name[XFS_WQ_NAME_LEN];
+	char			m_unwritten_workqueue_name[XFS_WQ_NAME_LEN];
 } xfs_mount_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
