Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfFUT5h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:37 -0400
Subject: [PATCH 5/6] libxfs: make xfs_buf_delwri_submit actually do something
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 12:57:33 -0700
Message-ID: <156114705295.1643538.4760286307932278728.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_buf_delwri_queue doesn't report errors, which means that if the
buffer write fails we have no way of knowing that something bad
happened.  In the kernel we queue and then submit buffers, and the
submit call communicates errors to callers.  Do the same here since
we're going to start using the AG header initialization functions, which
use delwri_{queue,submit} heavily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |    6 +++++-
 libxfs/libxfs_priv.h |    1 -
 libxfs/rdwr.c        |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index c47a435d..d033faad 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -70,6 +70,7 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
+	struct list_head	b_list;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
 	const char		*b_func;
@@ -243,11 +244,14 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
 	return bp;
 }
 
+/* Push a single buffer on a delwri queue. */
 static inline void
 xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 {
 	bp->b_node.cn_count++;
-	libxfs_writebuf(bp, 0);
+	list_add_tail(&bp->b_list, buffer_list);
 }
 
+int xfs_buf_delwri_submit(struct list_head *buffer_list);
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index fd420f4f..0233393d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -381,7 +381,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9c6c93a7..dd582a4e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1472,3 +1472,28 @@ libxfs_irele(
 	libxfs_idestroy(ip);
 	kmem_zone_free(xfs_inode_zone, ip);
 }
+
+/*
+ * Write out a buffer list synchronously.
+ *
+ * This will take the @buffer_list, write all buffers out and wait for I/O
+ * completion on all of the buffers. @buffer_list is consumed by the function,
+ * so callers must have some other way of tracking buffers if they require such
+ * functionality.
+ */
+int
+xfs_buf_delwri_submit(
+	struct list_head	*buffer_list)
+{
+	struct xfs_buf		*bp, *n;
+	int			error = 0, error2;
+
+	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
+		list_del_init(&bp->b_list);
+		error2 = libxfs_writebuf(bp, 0);
+		if (!error)
+			error = error2;
+	}
+
+	return error;
+}
