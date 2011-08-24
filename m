Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O61pkA014160 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:01:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6D961F03702
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:01:50 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Yxq49azgjfIYW9QV for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:01:50 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6X8-0003r9-1s
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:01:50 +0000
Message-Id: <20110824060150.001321834@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 01:59:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: use per-filesystem I/O completion workqueues
References: <20110824055924.139283426@bombadil.infradead.org>
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

The new concurrency managed workqueues are cheap enough that we can
create them per-filesystem instead of global.  This allows us to only
flush items for the current filesystem during sync, and to remove the
trylock or defer scheme on the ilock, which is not compatible with
using the workqueue flush for integrity purposes in the sync code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-08-23 04:35:20.822345321 +0200
+++ xfs/fs/xfs/xfs_aops.c	2011-08-23 04:37:02.425128226 +0200
@@ -131,30 +131,22 @@ static inline bool xfs_ioend_is_append(s
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
 	xfs_ioend_t		*ioend)
 {
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-		return EAGAIN;
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
 		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 		ip->i_d.di_size = isize;
 		xfs_mark_inode_dirty(ip);
 	}
-
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
 /*
@@ -168,10 +160,12 @@ xfs_finish_ioend(
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
@@ -212,23 +206,9 @@ xfs_end_io(
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
--- xfs.orig/fs/xfs/xfs_aops.h	2011-08-23 04:35:07.872415478 +0200
+++ xfs/fs/xfs/xfs_aops.h	2011-08-23 04:36:11.305405165 +0200
@@ -18,8 +18,6 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
-extern struct workqueue_struct *xfsdatad_workqueue;
-extern struct workqueue_struct *xfsconvertd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-08-23 04:35:07.885748741 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-08-23 04:36:11.308738481 +0200
@@ -41,13 +41,9 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 
-static kmem_zone_t *xfs_buf_zone;
+kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
 
-static struct workqueue_struct *xfslogd_workqueue;
-struct workqueue_struct *xfsdatad_workqueue;
-struct workqueue_struct *xfsconvertd_workqueue;
-
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
 # define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
@@ -992,8 +988,10 @@ xfs_buf_ioend(
 
 	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
 		if (schedule) {
+			struct xfs_mount	*mp = bp->b_target->bt_mount;
+
 			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
-			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
+			queue_work(mp->m_buf_workqueue, &bp->b_iodone_work);
 		} else {
 			xfs_buf_iodone_work(&bp->b_iodone_work);
 		}
@@ -1618,13 +1616,6 @@ xfs_buf_delwri_promote(
 	spin_unlock(&btp->bt_delwri_lock);
 }
 
-STATIC void
-xfs_buf_runall_queues(
-	struct workqueue_struct	*queue)
-{
-	flush_workqueue(queue);
-}
-
 /*
  * Move as many buffers as specified to the supplied list
  * idicating if we skipped any buffers to prevent deadlocks.
@@ -1741,15 +1732,16 @@ xfs_flush_buftarg(
 	xfs_buftarg_t	*target,
 	int		wait)
 {
+	xfs_mount_t	*mp = target->bt_mount;
 	xfs_buf_t	*bp;
 	int		pincount = 0;
 	LIST_HEAD(tmp_list);
 	LIST_HEAD(wait_list);
 	struct blk_plug plug;
 
-	xfs_buf_runall_queues(xfsconvertd_workqueue);
-	xfs_buf_runall_queues(xfsdatad_workqueue);
-	xfs_buf_runall_queues(xfslogd_workqueue);
+	flush_workqueue(mp->m_buf_workqueue);
+	flush_workqueue(mp->m_data_workqueue);
+	flush_workqueue(mp->m_unwritten_workqueue);
 
 	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
@@ -1788,49 +1780,6 @@ xfs_flush_buftarg(
 	return pincount;
 }
 
-int __init
-xfs_buf_init(void)
-{
-	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
-						KM_ZONE_HWALIGN, NULL);
-	if (!xfs_buf_zone)
-		goto out;
-
-	xfslogd_workqueue = alloc_workqueue("xfslogd",
-					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
-	if (!xfslogd_workqueue)
-		goto out_free_buf_zone;
-
-	xfsdatad_workqueue = alloc_workqueue("xfsdatad", WQ_MEM_RECLAIM, 1);
-	if (!xfsdatad_workqueue)
-		goto out_destroy_xfslogd_workqueue;
-
-	xfsconvertd_workqueue = alloc_workqueue("xfsconvertd",
-						WQ_MEM_RECLAIM, 1);
-	if (!xfsconvertd_workqueue)
-		goto out_destroy_xfsdatad_workqueue;
-
-	return 0;
-
- out_destroy_xfsdatad_workqueue:
-	destroy_workqueue(xfsdatad_workqueue);
- out_destroy_xfslogd_workqueue:
-	destroy_workqueue(xfslogd_workqueue);
- out_free_buf_zone:
-	kmem_zone_destroy(xfs_buf_zone);
- out:
-	return -ENOMEM;
-}
-
-void
-xfs_buf_terminate(void)
-{
-	destroy_workqueue(xfsconvertd_workqueue);
-	destroy_workqueue(xfsdatad_workqueue);
-	destroy_workqueue(xfslogd_workqueue);
-	kmem_zone_destroy(xfs_buf_zone);
-}
-
 #ifdef CONFIG_KDB_MODULES
 struct list_head *
 xfs_get_buftarg_list(void)
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-08-23 04:35:07.895748686 +0200
+++ xfs/fs/xfs/xfs_super.c	2011-08-23 04:36:11.312071797 +0200
@@ -767,6 +767,49 @@ xfs_setup_devices(
 	return 0;
 }
 
+STATIC int
+xfs_init_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+#define XFS_WQ_NAME_LEN		512
+	char			name[XFS_WQ_NAME_LEN];
+
+	snprintf(name, XFS_WQ_NAME_LEN, "xfs-buf/%s", mp->m_fsname);
+	mp->m_buf_workqueue =
+			alloc_workqueue(name, WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+	if (!mp->m_buf_workqueue)
+		goto out;
+
+	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
+	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+	if (!mp->m_data_workqueue)
+		goto out_destroy_buf_iodone_queue;
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
+out_destroy_buf_iodone_queue:
+	destroy_workqueue(mp->m_buf_workqueue);
+out:
+	return -ENOMEM;
+#undef XFS_WQ_NAME_LEN
+}
+
+STATIC void
+xfs_destroy_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+	destroy_workqueue(mp->m_buf_workqueue);
+	destroy_workqueue(mp->m_data_workqueue);
+	destroy_workqueue(mp->m_unwritten_workqueue);
+}
+
 /* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
 xfs_fs_alloc_inode(
@@ -1034,6 +1077,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
+	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
 	xfs_free_fsname(mp);
 	kfree(mp);
@@ -1367,10 +1411,14 @@ xfs_fs_fill_super(
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
@@ -1433,6 +1481,8 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
+out_destroy_workqueues:
+	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
@@ -1596,8 +1646,15 @@ xfs_init_zones(void)
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 
+	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
+						KM_ZONE_HWALIGN, NULL);
+	if (!xfs_buf_zone)
+		goto out_destroy_xfs_ili_zone;
+
 	return 0;
 
+ out_destroy_xfs_ili_zone:
+	kmem_zone_destroy(xfs_ili_zone);
  out_destroy_inode_zone:
 	kmem_zone_destroy(xfs_inode_zone);
  out_destroy_efi_zone:
@@ -1633,6 +1690,7 @@ xfs_init_zones(void)
 STATIC void
 xfs_destroy_zones(void)
 {
+	kmem_zone_destroy(xfs_buf_zone);
 	kmem_zone_destroy(xfs_ili_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_efi_zone);
@@ -1709,13 +1767,9 @@ init_xfs_fs(void)
 	if (error)
 		goto out_mru_cache_uninit;
 
-	error = xfs_buf_init();
-	if (error)
-		goto out_filestream_uninit;
-
 	error = xfs_init_procfs();
 	if (error)
-		goto out_buf_terminate;
+		goto out_filestream_uninit;
 
 	error = xfs_sysctl_register();
 	if (error)
@@ -1732,8 +1786,6 @@ init_xfs_fs(void)
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
 	xfs_cleanup_procfs();
- out_buf_terminate:
-	xfs_buf_terminate();
  out_filestream_uninit:
 	xfs_filestream_uninit();
  out_mru_cache_uninit:
@@ -1753,7 +1805,6 @@ exit_xfs_fs(void)
 	unregister_filesystem(&xfs_fs_type);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
-	xfs_buf_terminate();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-08-23 04:35:07.909081946 +0200
+++ xfs/fs/xfs/xfs_mount.h	2011-08-23 04:36:11.312071797 +0200
@@ -211,6 +211,10 @@ typedef struct xfs_mount {
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+
+	struct workqueue_struct	*m_buf_workqueue;
+	struct workqueue_struct	*m_data_workqueue;
+	struct workqueue_struct	*m_unwritten_workqueue;
 } xfs_mount_t;
 
 /*
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-08-23 04:35:07.922415209 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-08-23 04:36:11.315405112 +0200
@@ -224,10 +224,6 @@ extern void xfs_buf_delwri_queue(struct
 extern void xfs_buf_delwri_dequeue(struct xfs_buf *);
 extern void xfs_buf_delwri_promote(struct xfs_buf *);
 
-/* Buffer Daemon Setup Routines */
-extern int xfs_buf_init(void);
-extern void xfs_buf_terminate(void);
-
 static inline const char *
 xfs_buf_target_name(struct xfs_buftarg *target)
 {
@@ -315,6 +311,8 @@ extern int xfs_flush_buftarg(xfs_buftarg
 extern struct list_head *xfs_get_buftarg_list(void);
 #endif
 
+extern struct kmem_zone *xfs_buf_zone;
+
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
