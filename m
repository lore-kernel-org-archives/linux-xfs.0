Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MK5bQ7120668 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 15:05:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A623611E6E14
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:05:31 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NfEn8SNgRvZAFLF9 for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 13:05:31 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QZTg2-0007qz-Kd
	for xfs@oss.sgi.com; Wed, 22 Jun 2011 20:05:30 +0000
Message-Id: <20110622200530.594374357@bombadil.infradead.org>
Date: Wed, 22 Jun 2011 16:01:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: user per-filesystem I/O completion workqueues
References: <20110622200129.218994186@bombadil.infradead.org>
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

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-06-21 16:47:04.934443809 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2011-06-21 17:15:16.131024850 +0200
@@ -161,32 +161,21 @@ xfs_ioend_new_eof(
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
 
-	if (unlikely(ioend->io_error))
-		return 0;
-
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-		return EAGAIN;
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
 		ip->i_d.di_size = isize;
 		xfs_mark_inode_dirty(ip);
 	}
-
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
 /*
@@ -197,10 +186,15 @@ xfs_finish_ioend(
 	struct xfs_ioend	*ioend)
 {
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
+		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
+		struct workqueue_struct	*wq;
+
 		if (ioend->io_type == IO_UNWRITTEN)
-			queue_work(xfsconvertd_workqueue, &ioend->io_work);
+			wq = mp->m_unwritten_iodone_queue;
 		else
-			queue_work(xfsdatad_workqueue, &ioend->io_work);
+			wq = mp->m_data_iodone_queue;
+
+		queue_work(wq, &ioend->io_work);
 	}
 }
 
@@ -232,24 +226,11 @@ xfs_end_io(
 	 * We might have to update the on-disk file size after extending
 	 * writes.
 	 */
-	error = xfs_setfilesize(ioend);
-	ASSERT(!error || error == EAGAIN);
+	xfs_setfilesize(ioend);
 
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
-		if (ioend->io_iocb)
-			aio_complete(ioend->io_iocb, ioend->io_result, 0);
-		xfs_destroy_ioend(ioend);
-	}
+	if (ioend->io_iocb)
+		aio_complete(ioend->io_iocb, ioend->io_result, 0);
+	xfs_destroy_ioend(ioend);
 }
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.h	2011-06-21 16:47:04.954443807 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.h	2011-06-21 16:49:34.667769562 +0200
@@ -18,8 +18,6 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
-extern struct workqueue_struct *xfsdatad_workqueue;
-extern struct workqueue_struct *xfsconvertd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-06-21 16:44:19.097785538 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-06-21 17:08:27.151045557 +0200
@@ -41,14 +41,10 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 
-static kmem_zone_t *xfs_buf_zone;
+struct kmem_zone *xfs_buf_zone;
 STATIC int xfsbufd(void *);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 
-static struct workqueue_struct *xfslogd_workqueue;
-struct workqueue_struct *xfsdatad_workqueue;
-struct workqueue_struct *xfsconvertd_workqueue;
-
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
 # define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
@@ -1014,8 +1010,10 @@ xfs_buf_ioend(
 
 	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
 		if (schedule) {
+			struct xfs_mount	*mp = bp->b_target->bt_mount;
+
 			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
-			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
+			queue_work(mp->m_buf_iodone_queue, &bp->b_iodone_work);
 		} else {
 			xfs_buf_iodone_work(&bp->b_iodone_work);
 		}
@@ -1665,13 +1663,6 @@ xfs_buf_delwri_promote(
 	spin_unlock(&btp->bt_delwrite_lock);
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
@@ -1800,15 +1791,16 @@ xfs_flush_buftarg(
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
+	flush_workqueue(mp->m_buf_iodone_queue);
+	flush_workqueue(mp->m_data_iodone_queue);
+	flush_workqueue(mp->m_unwritten_iodone_queue);
 
 	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
@@ -1847,49 +1839,6 @@ xfs_flush_buftarg(
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
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-06-21 16:53:36.721090640 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-06-21 17:27:02.880989070 +0200
@@ -768,6 +768,49 @@ xfs_setup_devices(
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
+	mp->m_buf_iodone_queue =
+			alloc_workqueue(name, WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+	if (!mp->m_buf_iodone_queue)
+		goto out;
+
+	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
+	mp->m_data_iodone_queue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+	if (!mp->m_data_iodone_queue)
+		goto out_destroy_buf_iodone_queue;
+
+	snprintf(name, XFS_WQ_NAME_LEN, "xfs-conv/%s", mp->m_fsname);
+	mp->m_unwritten_iodone_queue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
+	if (!mp->m_unwritten_iodone_queue)
+		goto out_destroy_data_iodone_queue;
+
+	return 0;
+
+out_destroy_data_iodone_queue:
+	destroy_workqueue(mp->m_data_iodone_queue);
+out_destroy_buf_iodone_queue:
+	destroy_workqueue(mp->m_buf_iodone_queue);
+out:
+	return -ENOMEM;
+#undef XFS_WQ_NAME_LEN
+}
+
+STATIC void
+xfs_destroy_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+	destroy_workqueue(mp->m_buf_iodone_queue);
+	destroy_workqueue(mp->m_data_iodone_queue);
+	destroy_workqueue(mp->m_unwritten_iodone_queue);
+}
+
 /* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
 xfs_fs_alloc_inode(
@@ -1044,6 +1087,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
+	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
 	xfs_free_fsname(mp);
 	kfree(mp);
@@ -1377,10 +1421,14 @@ xfs_fs_fill_super(
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
@@ -1448,6 +1496,8 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
+out_destroy_workqueues:
+	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
@@ -1601,8 +1651,15 @@ xfs_init_zones(void)
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
@@ -1638,6 +1695,7 @@ xfs_init_zones(void)
 STATIC void
 xfs_destroy_zones(void)
 {
+	kmem_zone_destroy(xfs_buf_zone);
 	kmem_zone_destroy(xfs_ili_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_efi_zone);
@@ -1715,13 +1773,9 @@ init_xfs_fs(void)
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
@@ -1738,8 +1792,6 @@ init_xfs_fs(void)
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
 	xfs_cleanup_procfs();
- out_buf_terminate:
-	xfs_buf_terminate();
  out_filestream_uninit:
 	xfs_filestream_uninit();
  out_mru_cache_uninit:
@@ -1759,7 +1811,6 @@ exit_xfs_fs(void)
 	unregister_filesystem(&xfs_fs_type);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
-	xfs_buf_terminate();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-06-21 16:45:47.311114406 +0200
+++ xfs/fs/xfs/xfs_mount.h	2011-06-21 17:01:38.347732921 +0200
@@ -211,6 +211,10 @@ typedef struct xfs_mount {
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+
+	struct workqueue_struct	*m_buf_iodone_queue;
+	struct workqueue_struct	*m_data_iodone_queue;
+	struct workqueue_struct	*m_unwritten_iodone_queue;
 } xfs_mount_t;
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-06-21 17:05:57.191053150 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-06-21 17:08:39.014378290 +0200
@@ -225,10 +225,6 @@ extern xfs_caddr_t xfs_buf_offset(xfs_bu
 extern void xfs_buf_delwri_dequeue(xfs_buf_t *);
 extern void xfs_buf_delwri_promote(xfs_buf_t *);
 
-/* Buffer Daemon Setup Routines */
-extern int xfs_buf_init(void);
-extern void xfs_buf_terminate(void);
-
 #define xfs_buf_target_name(target)	\
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
@@ -343,6 +339,8 @@ extern int xfs_flush_buftarg(xfs_buftarg
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
