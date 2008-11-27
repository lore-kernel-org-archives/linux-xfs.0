Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mARJv5lO028567 for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 13:57:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0380216131E9
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 11:57:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hHZHrDlOneXVCc1v for
	<xfs@oss.sgi.com>; Thu, 27 Nov 2008 11:57:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L5mz2-0007cg-Lu
	for xfs@oss.sgi.com; Thu, 27 Nov 2008 19:57:04 +0000
Date: Thu, 27 Nov 2008 14:57:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] move vn_iowait / vn_iowake into xfs_aops.c
Message-ID: <20081127195704.GB15027@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

The whole machinery to wait on I/O completion is related to the I/O path
and should be there instead of in xfs_vnode.c.  Also give the functions
more descriptive names.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-11-16 21:16:21.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2008-11-16 21:16:23.000000000 +0100
@@ -42,6 +42,40 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+
+/*
+ * Prime number of hash buckets since address is used as the key.
+ */
+#define NVSYNC		37
+#define to_ioend_wq(v)	(&xfs_ioend_wq[((unsigned long)v) % NVSYNC])
+static wait_queue_head_t xfs_ioend_wq[NVSYNC];
+
+void __init
+xfs_ioend_init(void)
+{
+	int i;
+
+	for (i = 0; i < NVSYNC; i++)
+		init_waitqueue_head(&xfs_ioend_wq[i]);
+}
+
+void
+xfs_ioend_wait(
+	xfs_inode_t	*ip)
+{
+	wait_queue_head_t *wq = to_ioend_wq(ip);
+
+	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
+}
+
+STATIC void
+xfs_ioend_wake(
+	xfs_inode_t	*ip)
+{
+	if (atomic_dec_and_test(&ip->i_iocount))
+		wake_up(to_ioend_wq(ip));
+}
+
 STATIC void
 xfs_count_page_state(
 	struct page		*page,
@@ -164,7 +198,7 @@ xfs_destroy_ioend(
 				      __FILE__, __LINE__);
 	}
 
-	vn_iowake(ip);
+	xfs_ioend_wake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
 }
 
@@ -516,7 +550,7 @@ xfs_cancel_ioend(
 			unlock_buffer(bh);
 		} while ((bh = next_bh) != NULL);
 
-		vn_iowake(XFS_I(ioend->io_inode));
+		xfs_ioend_wake(XFS_I(ioend->io_inode));
 		mempool_free(ioend, xfs_ioend_pool);
 	} while ((ioend = next) != NULL);
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.h	2008-11-16 21:15:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.h	2008-11-16 21:16:23.000000000 +0100
@@ -43,4 +43,7 @@ typedef struct xfs_ioend {
 extern const struct address_space_operations xfs_address_space_operations;
 extern int xfs_get_blocks(struct inode *, sector_t, struct buffer_head *, int);
 
+extern void xfs_ioend_init(void);
+extern void xfs_ioend_wait(struct xfs_inode *);
+
 #endif /* __XFS_AOPS_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-11-16 21:16:20.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-11-16 21:16:23.000000000 +0100
@@ -1827,7 +1827,7 @@ init_xfs_fs(void)
 			 XFS_BUILD_OPTIONS " enabled\n");
 
 	ktrace_init(64);
-	vn_init();
+	xfs_ioend_init();
 	xfs_dir_startup();
 
 	error = xfs_init_zones();
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2008-11-16 21:15:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sync.c	2008-11-16 21:16:23.000000000 +0100
@@ -132,7 +132,7 @@ xfs_sync_inodes_ag(
 			lock_flags |= XFS_IOLOCK_SHARED;
 			error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
 			if (flags & SYNC_IOWAIT)
-				vn_iowait(ip);
+				xfs_ioend_wait(ip);
 		}
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-11-16 21:16:21.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-11-16 21:16:23.000000000 +0100
@@ -32,40 +32,6 @@
 #include "xfs_mount.h"
 
 
-/*
- * Dedicated vnode inactive/reclaim sync wait queues.
- * Prime number of hash buckets since address is used as the key.
- */
-#define NVSYNC                  37
-#define vptosync(v)             (&vsync[((unsigned long)v) % NVSYNC])
-static wait_queue_head_t vsync[NVSYNC];
-
-void __init
-vn_init(void)
-{
-	int i;
-
-	for (i = 0; i < NVSYNC; i++)
-		init_waitqueue_head(&vsync[i]);
-}
-
-void
-vn_iowait(
-	xfs_inode_t	*ip)
-{
-	wait_queue_head_t *wq = vptosync(ip);
-
-	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
-}
-
-void
-vn_iowake(
-	xfs_inode_t	*ip)
-{
-	if (atomic_dec_and_test(&ip->i_iocount))
-		wake_up(vptosync(ip));
-}
-
 #ifdef	XFS_INODE_TRACE
 
 #define KTRACE_ENTER(ip, vk, s, line, ra)			\
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-11-16 21:16:21.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-11-16 21:16:46.000000000 +0100
@@ -54,16 +54,6 @@ struct attrlist_cursor_kern;
 					   Prevent VM access to the pages until
 					   the operation completes. */
 
-
-extern void	vn_init(void);
-
-/*
- * Yeah, these don't take vnode anymore at all, all this should be
- * cleaned up at some point.
- */
-extern void	vn_iowait(struct xfs_inode *ip);
-extern void	vn_iowake(struct xfs_inode *ip);
-
 #define IHOLD(ip) \
 do { \
 	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-11-16 21:15:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-11-16 21:16:23.000000000 +0100
@@ -1322,8 +1322,8 @@ xfs_itrunc_trace(
  * direct I/O with the truncate operation.  Also, because we hold
  * the IOLOCK in exclusive mode, we prevent new direct I/Os from being
  * started until the truncate completes and drops the lock. Essentially,
- * the vn_iowait() call forms an I/O barrier that provides strict ordering
- * between direct I/Os and the truncate operation.
+ * the xfs_ioend_wait() call forms an I/O barrier that provides strict
+ * ordering between direct I/Os and the truncate operation.
  *
  * The flags parameter can have either the value XFS_ITRUNC_DEFINITE
  * or XFS_ITRUNC_MAYBE.  The XFS_ITRUNC_MAYBE value should be used
@@ -1354,7 +1354,7 @@ xfs_itruncate_start(
 
 	/* wait for the completion of any pending DIOs */
 	if (new_size == 0 || new_size < ip->i_size)
-		vn_iowait(ip);
+		xfs_ioend_wait(ip);
 
 	/*
 	 * Call toss_pages or flushinval_pages to get rid of pages
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-11-16 21:15:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-11-16 21:16:23.000000000 +0100
@@ -262,7 +262,7 @@ xfs_setattr(
 		}
 
 		/* wait for all I/O to complete */
-		vn_iowait(ip);
+		xfs_ioend_wait(ip);
 
 		if (!code)
 			code = xfs_itruncate_data(ip, iattr->ia_size);
@@ -2705,7 +2705,7 @@ xfs_reclaim(
 		return 0;
 	}
 
-	vn_iowait(ip);
+	xfs_ioend_wait(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
@@ -3096,7 +3096,8 @@ xfs_free_file_space(
 		need_iolock = 0;
 	if (need_iolock) {
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		vn_iowait(ip);	/* wait for the completion of any pending DIOs */
+		/* wait for the completion of any pending DIOs */
+		xfs_ioend_wait(ip);
 	}
 
 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
