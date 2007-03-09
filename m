Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 09 Mar 2007 03:55:29 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l29BtJ6p003153
	for <xfs@oss.sgi.com>; Fri, 9 Mar 2007 03:55:22 -0800
Date: Fri, 9 Mar 2007 12:55:11 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
Message-ID: <20070309115511.GA20426@lst.de>
References: <20070307101324.GC30587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307101324.GC30587@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org

Ed Cashin found a bug in the error handling code for the case where
a page allocation fails.  Here's the updated version:

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-03-08 19:08:38.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-03-09 08:59:15.000000000 +0100
@@ -314,7 +314,7 @@
 
 	ASSERT(list_empty(&bp->b_hash_list));
 
-	if (bp->b_flags & _XBF_PAGE_CACHE) {
+	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
@@ -323,18 +323,11 @@
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
 
-			ASSERT(!PagePrivate(page));
+			if (bp->b_flags & _XBF_PAGE_CACHE)
+				ASSERT(!PagePrivate(page));
 			page_cache_release(page);
 		}
 		_xfs_buf_free_pages(bp);
-	} else if (bp->b_flags & _XBF_KMEM_ALLOC) {
-		 /*
-		  * XXX(hch): bp->b_count_desired might be incorrect (see
-		  * xfs_buf_associate_memory for details), but fortunately
-		  * the Linux version of kmem_free ignores the len argument..
-		  */
-		kmem_free(bp->b_addr, bp->b_count_desired);
-		_xfs_buf_free_pages(bp);
 	}
 
 	xfs_buf_deallocate(bp);
@@ -764,41 +757,41 @@
 	size_t			len,
 	xfs_buftarg_t		*target)
 {
-	size_t			malloc_len = len;
+	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	int			error, i;
 	xfs_buf_t		*bp;
-	void			*data;
-	int			error;
 
 	bp = xfs_buf_allocate(0);
 	if (unlikely(bp == NULL))
 		goto fail;
 	_xfs_buf_initialize(bp, target, 0, len, 0);
 
- try_again:
-	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL | KM_LARGE);
-	if (unlikely(data == NULL))
+	error = _xfs_buf_get_pages(bp, page_count, 0);
+	if (error)
 		goto fail_free_buf;
 
-	/* check whether alignment matches.. */
-	if ((__psunsigned_t)data !=
-	    ((__psunsigned_t)data & ~target->bt_smask)) {
-		/* .. else double the size and try again */
-		kmem_free(data, malloc_len);
-		malloc_len <<= 1;
-		goto try_again;
-	}
-
-	error = xfs_buf_associate_memory(bp, data, len);
-	if (error)
+	for (i = 0; i < page_count; i++) {
+		bp->b_pages[i] = alloc_page(GFP_KERNEL);
+		if (!bp->b_pages[i])
+			goto fail_free_mem;
+	}
+	bp->b_flags |= _XBF_PAGES;
+
+	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
+	if (unlikely(error)) {
+		printk(KERN_WARNING "%s: failed to map pages\n",
+				__FUNCTION__);
 		goto fail_free_mem;
-	bp->b_flags |= _XBF_KMEM_ALLOC;
+	}
 
 	xfs_buf_unlock(bp);
 
 	XB_TRACE(bp, "no_daddr", data);
 	return bp;
+
  fail_free_mem:
-	kmem_free(data, malloc_len);
+ 	for ( ; i >= 0; i--)
+		__free_page(bp->b_pages[i]);
  fail_free_buf:
 	xfs_buf_free(bp);
  fail:
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.h	2007-03-08 19:08:38.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.h	2007-03-09 08:58:50.000000000 +0100
@@ -63,7 +63,7 @@
 
 	/* flags used only internally */
 	_XBF_PAGE_CACHE = (1 << 17),/* backed by pagecache		   */
-	_XBF_KMEM_ALLOC = (1 << 18),/* backed by kmem_alloc()		   */
+	_XBF_PAGES = (1 << 18),	    /* backed by refcounted pages	   */
 	_XBF_RUN_QUEUES = (1 << 19),/* run block device task queue	   */
 	_XBF_DELWRI_Q = (1 << 21),   /* buffer on delwri queue		   */
 } xfs_buf_flags_t;
