Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EMPMCK008613 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 17:25:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E25291E785AD
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 15:25:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Zxwy2kLgpq4MUcoG for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 15:25:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qsj7O-00077n-DH
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 22:25:18 +0000
Message-Id: <20110814222518.371157499@bombadil.infradead.org>
Date: Sun, 14 Aug 2011 18:24:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: remove i_iocount
References: <20110814222412.359079843@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-iocount
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

We now have an i_dio_count filed and surrounding infrastructure to wait
for direct I/O completion instead of i_icount, and we have never needed
to iocount waits for buffered I/O given that we only set the page uptodate
after finishing all required work.  Thus remove i_iocount, and replace
the actually needed waits with calls to inode_dio_wait.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-08-13 10:57:57.979364052 -0700
+++ xfs/fs/xfs/xfs_aops.c	2011-08-13 10:58:03.769332684 -0700
@@ -38,40 +38,6 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
-
-/*
- * Prime number of hash buckets since address is used as the key.
- */
-#define NVSYNC		37
-#define to_ioend_wq(v)	(&xfs_ioend_wq[((unsigned long)v) % NVSYNC])
-static wait_queue_head_t xfs_ioend_wq[NVSYNC];
-
-void __init
-xfs_ioend_init(void)
-{
-	int i;
-
-	for (i = 0; i < NVSYNC; i++)
-		init_waitqueue_head(&xfs_ioend_wq[i]);
-}
-
-void
-xfs_ioend_wait(
-	xfs_inode_t	*ip)
-{
-	wait_queue_head_t *wq = to_ioend_wq(ip);
-
-	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
-}
-
-STATIC void
-xfs_ioend_wake(
-	xfs_inode_t	*ip)
-{
-	if (atomic_dec_and_test(&ip->i_iocount))
-		wake_up(to_ioend_wq(ip));
-}
-
 void
 xfs_count_page_state(
 	struct page		*page,
@@ -115,7 +81,6 @@ xfs_destroy_ioend(
 	xfs_ioend_t		*ioend)
 {
 	struct buffer_head	*bh, *next;
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 
 	for (bh = ioend->io_buffer_head; bh; bh = next) {
 		next = bh->b_private;
@@ -127,7 +92,7 @@ xfs_destroy_ioend(
 			aio_complete(ioend->io_iocb, ioend->io_result, 0);
 		inode_dio_done(ioend->io_inode);
 	}
-	xfs_ioend_wake(ip);
+
 	mempool_free(ioend, xfs_ioend_pool);
 }
 
@@ -297,7 +262,6 @@ xfs_alloc_ioend(
 	ioend->io_inode = inode;
 	ioend->io_buffer_head = NULL;
 	ioend->io_buffer_tail = NULL;
-	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
 	ioend->io_iocb = NULL;
@@ -557,7 +521,6 @@ xfs_cancel_ioend(
 			unlock_buffer(bh);
 		} while ((bh = next_bh) != NULL);
 
-		xfs_ioend_wake(XFS_I(ioend->io_inode));
 		mempool_free(ioend, xfs_ioend_pool);
 	} while ((ioend = next) != NULL);
 }
Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-08-13 10:45:14.693499125 -0700
+++ xfs/fs/xfs/xfs_file.c	2011-08-13 10:58:03.769332684 -0700
@@ -149,10 +149,6 @@ xfs_file_fsync(
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	xfs_ioend_wait(ip);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
 	if (mp->m_flags & XFS_MOUNT_BARRIER) {
 		/*
 		 * If we have an RT and/or log subvolume we need to make sure
@@ -721,7 +717,7 @@ xfs_file_aio_write_checks(
  * the dio layer.  To avoid the problem with aio, we also need to wait for
  * outstanding IOs to complete so that unwritten extent conversion is completed
  * before we try to map the overlapping block. This is currently implemented by
- * hitting it with a big hammer (i.e. xfs_ioend_wait()).
+ * hitting it with a big hammer (i.e. inode_dio_wait()).
  *
  * Returns with locks held indicated by @iolock and errors indicated by
  * negative return values.
@@ -776,7 +772,7 @@ xfs_file_dio_aio_write(
 	 * otherwise demote the lock if we had to flush cached pages
 	 */
 	if (unaligned_io)
-		xfs_ioend_wait(ip);
+		inode_dio_wait(inode);
 	else if (*iolock == XFS_IOLOCK_EXCL) {
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		*iolock = XFS_IOLOCK_SHARED;
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-08-13 10:45:14.703499072 -0700
+++ xfs/fs/xfs/xfs_super.c	2011-08-13 10:58:03.772665999 -0700
@@ -794,8 +794,6 @@ xfs_fs_destroy_inode(
 	if (is_bad_inode(inode))
 		goto out_reclaim;
 
-	xfs_ioend_wait(ip);
-
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*
@@ -835,7 +833,6 @@ xfs_fs_inode_init_once(
 	inode_init_once(VFS_I(ip));
 
 	/* xfs inode */
-	atomic_set(&ip->i_iocount, 0);
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
 	init_waitqueue_head(&ip->i_ipin_wait);
@@ -928,7 +925,6 @@ xfs_fs_write_inode(
 		 * ->sync_fs call do that for thus, which reduces the number
 		 * of synchronous log foces dramatically.
 		 */
-		xfs_ioend_wait(ip);
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		if (ip->i_update_core) {
 			error = xfs_log_inode(ip);
@@ -1695,7 +1691,6 @@ init_xfs_fs(void)
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
-	xfs_ioend_init();
 	xfs_dir_startup();
 
 	error = xfs_init_zones();
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-08-13 10:45:14.710165702 -0700
+++ xfs/fs/xfs/xfs_sync.c	2011-08-13 10:58:03.775999314 -0700
@@ -227,21 +227,17 @@ xfs_sync_inode_data(
 	int			error = 0;
 
 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
-		goto out_wait;
+		return 0;
 
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
 		if (flags & SYNC_TRYLOCK)
-			goto out_wait;
+			return 0;
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
 
 	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
 				0 : XBF_ASYNC, FI_NONE);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
- out_wait:
-	if (flags & SYNC_WAIT)
-		xfs_ioend_wait(ip);
 	return error;
 }
 
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-08-13 10:45:14.720165647 -0700
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-08-13 10:58:03.775999314 -0700
@@ -647,8 +647,6 @@ xfs_inactive(
 	if (truncate) {
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-		xfs_ioend_wait(ip);
-
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_ITRUNCATE_LOG_RES(mp),
 					  0, XFS_TRANS_PERM_LOG_RES,
@@ -2076,7 +2074,7 @@ xfs_free_file_space(
 	if (need_iolock) {
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		/* wait for the completion of any pending DIOs */
-		xfs_ioend_wait(ip);
+		inode_dio_wait(VFS_I(ip));
 	}
 
 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
Index: xfs/fs/xfs/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.h	2011-08-13 10:57:51.966063295 -0700
+++ xfs/fs/xfs/xfs_aops.h	2011-08-13 10:58:03.779332629 -0700
@@ -60,9 +60,6 @@ typedef struct xfs_ioend {
 extern const struct address_space_operations xfs_address_space_operations;
 extern int xfs_get_blocks(struct inode *, sector_t, struct buffer_head *, int);
 
-extern void xfs_ioend_init(void);
-extern void xfs_ioend_wait(struct xfs_inode *);
-
 extern void xfs_count_page_state(struct page *, int *, int *);
 
 #endif /* __XFS_AOPS_H__ */
Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2011-08-13 10:58:00.786015513 -0700
+++ xfs/fs/xfs/xfs_iops.c	2011-08-13 10:58:03.782665944 -0700
@@ -832,9 +832,9 @@ xfs_setattr_size(
 	}
 
 	/*
-	 * Wait for all I/O to complete.
+	 * Wait for all direct I/O to complete.
 	 */
-	xfs_ioend_wait(ip);
+	inode_dio_wait(inode);
 
 	error = -block_truncate_page(inode->i_mapping, iattr->ia_size,
 				     xfs_get_blocks);
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2011-08-13 10:45:14.760165430 -0700
+++ xfs/fs/xfs/xfs_iget.c	2011-08-13 10:58:03.782665944 -0700
@@ -75,7 +75,6 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
-	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
@@ -150,7 +149,6 @@ xfs_inode_free(
 	}
 
 	/* asserts to verify all state is correct here */
-	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-08-13 10:45:14.776832008 -0700
+++ xfs/fs/xfs/xfs_inode.h	2011-08-13 10:58:03.785999260 -0700
@@ -257,7 +257,6 @@ typedef struct xfs_inode {
 
 	xfs_fsize_t		i_size;		/* in-memory size */
 	xfs_fsize_t		i_new_size;	/* size when write completes */
-	atomic_t		i_iocount;	/* outstanding I/O count */
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
