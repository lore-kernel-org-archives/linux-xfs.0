Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 18:01:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F11hiq026702
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:01:43 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80641126FE9F
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:13 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id gkDaLbRFNiATwBjk for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:13 -0700 (PDT)
Date: Mon, 15 Sep 2008 03:03:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] add pre-io callback to struct xfs_buf
Message-ID: <20080915010313.GB13062@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-buf-writeback-callout
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

Enable a buffer "pre-io" callback to allow the contents of
a buffer to be checked or modified just before writeback occurs.
This is how we'll calculate CRCS on metadata buffers.


Signed-off-by: Dave Chinner <dgc@sgi.com>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-09-15 02:48:22.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-09-15 02:48:24.000000000 +0200
@@ -1179,6 +1179,14 @@ _xfs_buf_ioapply(
 		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
 	}
 
+	/*
+	 * call out to buffer specific pre-write I/O functions. Used for
+	 * validation of buffers and CRC calculations prior to I/O issue.
+	 */
+	if (bp->b_io_callback && (bp->b_flags & XBF_WRITE))
+		bp->b_io_callback(bp);
+
+
 	/* Special code path for reading a sub page size buffer in --
 	 * we populate up the whole page, and hence the other metadata
 	 * in the same page.  This optimization is only valid when the
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-09-15 02:48:22.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2008-09-15 02:48:24.000000000 +0200
@@ -166,6 +166,8 @@ typedef struct xfs_buf {
 	unsigned int		b_offset;	/* page offset in first page */
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	void			(*b_io_callback)(struct xfs_buf *);
+						/* pre-write I/O callback */
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
@@ -228,6 +230,16 @@ static inline int xfs_buf_geterror(xfs_b
 /* Buffer Utility Routines */
 extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
 
+/*
+ * Set the function that should be called immediately prior
+ * to a write I/O being issued on this buffer.
+ */
+static inline void
+xfs_buf_set_io_callback(xfs_buf_t *bp, void (*func)(xfs_buf_t *))
+{
+	bp->b_io_callback = func;
+}
+
 /* Pinning Buffer Storage in Memory */
 extern void xfs_buf_pin(xfs_buf_t *);
 extern void xfs_buf_unpin(xfs_buf_t *);

-- 
