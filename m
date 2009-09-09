Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89HL447172741 for <xfs@oss.sgi.com>; Wed, 9 Sep 2009 12:21:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 485BE1B8F421
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2009 10:22:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id b71TpMhCC4NR61pW for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2009 10:22:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MlQrs-0005pS-Cx
	for xfs@oss.sgi.com; Wed, 09 Sep 2009 17:22:04 +0000
Date: Wed, 9 Sep 2009 13:22:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: event tracing support
Message-ID: <20090909172204.GA22353@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Convert the old xfs tracing support that could only be used with the out
of tree kdb and xfsidbg patches to use the generic event tracer.

To use it make sure CONFIG_EVENT_TRACING is enabled and then enable all
xfs trace channels by:

   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

or alternatively enable single events by just doing the same in one
event subdirectory, e.g.

   echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_ihold/enable

or set more complex filters, etc. In Documentation/trace/events.txt all
this is desctribed in more detail.  To reads the events do a

   cat /sys/kernel/debug/tracing/trace

Compared to the last posting this patch converts the tracing mostly to
the one tracepoint per callsite model that other users of the new
tracing facility also employ.  This allows a very fine-grained control
of the tracing, a cleaner output of the traces and also enables the perf
tool to use each tracepoint as a virtual performance counter, allowing
us to e.g. count how often certain workloads git various spots in XFS.
Take a look at

    http://lwn.net/Articles/346470/

for some examples.  A few areas are not converted to this model yet,
most significantly the buffer and but item tracing, quota and parts
of the allocator.  I will continue to work on this but really want
to get this out for review and testing ASAP so it can go into 2.6.32.

Also the btree tracing isn't included at all yet, as it will require
additional core tracing features not in mainline yet, I plan to deliver
it later in the 2.6.32 cycle.

And the really nice thing about this patch is that it actually removes
many lines of code while adding this nice functionality:

    69 files changed, 1893 insertions(+), 2451 deletions(-)

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2009-09-09 12:33:56.320279238 -0300
+++ xfs/fs/xfs/Makefile	2009-09-09 12:49:11.157253953 -0300
@@ -90,8 +90,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_rw.o \
 				   xfs_dmops.o
 
-xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
-				   xfs_dir2_trace.o
+xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o
 
 # Objects in linux/
 xfs-y				+= $(addprefix $(XFS_LINUX)/, \
@@ -113,6 +112,3 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 xfs-y				+= $(addprefix support/, \
 				   debug.o \
 				   uuid.o)
-
-xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
-
Index: xfs/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_acl.c	2009-09-09 12:33:56.329253984 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_acl.c	2009-09-09 12:49:11.158254638 -0300
@@ -21,6 +21,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 #include <linux/xattr.h>
 #include <linux/posix_acl_xattr.h>
 
Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-09-09 12:33:56.334254062 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2009-09-09 12:49:11.162254031 -0300
@@ -38,6 +38,7 @@
 #include "xfs_rw.h"
 #include "xfs_iomap.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
@@ -76,7 +77,7 @@ xfs_ioend_wake(
 		wake_up(to_ioend_wq(ip));
 }
 
-STATIC void
+void
 xfs_count_page_state(
 	struct page		*page,
 	int			*delalloc,
@@ -98,48 +99,6 @@ xfs_count_page_state(
 	} while ((bh = bh->b_this_page) != head);
 }
 
-#if defined(XFS_RW_TRACE)
-void
-xfs_page_trace(
-	int		tag,
-	struct inode	*inode,
-	struct page	*page,
-	unsigned long	pgoff)
-{
-	xfs_inode_t	*ip;
-	loff_t		isize = i_size_read(inode);
-	loff_t		offset = page_offset(page);
-	int		delalloc = -1, unmapped = -1, unwritten = -1;
-
-	if (page_has_buffers(page))
-		xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
-
-	ip = XFS_I(inode);
-	if (!ip->i_rwtrace)
-		return;
-
-	ktrace_enter(ip->i_rwtrace,
-		(void *)((unsigned long)tag),
-		(void *)ip,
-		(void *)inode,
-		(void *)page,
-		(void *)pgoff,
-		(void *)((unsigned long)((ip->i_d.di_size >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(ip->i_d.di_size & 0xffffffff)),
-		(void *)((unsigned long)((isize >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(isize & 0xffffffff)),
-		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(offset & 0xffffffff)),
-		(void *)((unsigned long)delalloc),
-		(void *)((unsigned long)unmapped),
-		(void *)((unsigned long)unwritten),
-		(void *)((unsigned long)current_pid()),
-		(void *)NULL);
-}
-#else
-#define xfs_page_trace(tag, inode, page, pgoff)
-#endif
-
 STATIC struct block_device *
 xfs_find_bdev_for_inode(
 	struct xfs_inode	*ip)
@@ -1231,7 +1190,7 @@ xfs_vm_writepage(
 	int			delalloc, unmapped, unwritten;
 	struct inode		*inode = page->mapping->host;
 
-	xfs_page_trace(XFS_WRITEPAGE_ENTER, inode, page, 0);
+	trace_xfs_writepage(inode, page, 0);
 
 	/*
 	 * We need a transaction if:
@@ -1336,7 +1295,7 @@ xfs_vm_releasepage(
 		.nr_to_write = 1,
 	};
 
-	xfs_page_trace(XFS_RELEASEPAGE_ENTER, inode, page, 0);
+	trace_xfs_releasepage(inode, page, 0);
 
 	if (!page_has_buffers(page))
 		return 0;
@@ -1616,8 +1575,7 @@ xfs_vm_invalidatepage(
 	struct page		*page,
 	unsigned long		offset)
 {
-	xfs_page_trace(XFS_INVALIDPAGE_ENTER,
-			page->mapping->host, page, offset);
+	trace_xfs_invalidatepage(page->mapping->host, page, offset);
 	block_invalidatepage(page, offset);
 }
 
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-09-09 12:33:56.375253837 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-09-09 12:49:11.166254191 -0300
@@ -39,6 +39,7 @@
 #include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_trace.h"
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
@@ -53,34 +54,6 @@ static struct workqueue_struct *xfslogd_
 struct workqueue_struct *xfsdatad_workqueue;
 struct workqueue_struct *xfsconvertd_workqueue;
 
-#ifdef XFS_BUF_TRACE
-void
-xfs_buf_trace(
-	xfs_buf_t	*bp,
-	char		*id,
-	void		*data,
-	void		*ra)
-{
-	ktrace_enter(xfs_buf_trace_buf,
-		bp, id,
-		(void *)(unsigned long)bp->b_flags,
-		(void *)(unsigned long)bp->b_hold.counter,
-		(void *)(unsigned long)bp->b_sema.count,
-		(void *)current,
-		data, ra,
-		(void *)(unsigned long)((bp->b_file_offset>>32) & 0xffffffff),
-		(void *)(unsigned long)(bp->b_file_offset & 0xffffffff),
-		(void *)(unsigned long)bp->b_buffer_length,
-		NULL, NULL, NULL, NULL, NULL);
-}
-ktrace_t *xfs_buf_trace_buf;
-#define XFS_BUF_TRACE_SIZE	4096
-#define XB_TRACE(bp, id, data)	\
-	xfs_buf_trace(bp, id, (void *)data, (void *)__builtin_return_address(0))
-#else
-#define XB_TRACE(bp, id, data)	do { } while (0)
-#endif
-
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
 # define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
@@ -279,7 +252,7 @@ _xfs_buf_initialize(
 	init_waitqueue_head(&bp->b_waiters);
 
 	XFS_STATS_INC(xb_create);
-	XB_TRACE(bp, "initialize", target);
+	xfs_buftrace(bp, "initialize");
 }
 
 /*
@@ -332,7 +305,7 @@ void
 xfs_buf_free(
 	xfs_buf_t		*bp)
 {
-	XB_TRACE(bp, "free", 0);
+	xfs_buftrace(bp, "free");
 
 	ASSERT(list_empty(&bp->b_hash_list));
 
@@ -445,7 +418,7 @@ _xfs_buf_lookup_pages(
 	if (page_count == bp->b_page_count)
 		bp->b_flags |= XBF_DONE;
 
-	XB_TRACE(bp, "lookup_pages", (long)page_count);
+	xfs_buftrace_val(bp, "lookup_pages", page_count);
 	return error;
 }
 
@@ -548,7 +521,7 @@ found:
 	if (down_trylock(&bp->b_sema)) {
 		if (!(flags & XBF_TRYLOCK)) {
 			/* wait for buffer ownership */
-			XB_TRACE(bp, "get_lock", 0);
+			xfs_buftrace(bp, "get_lock");
 			xfs_buf_lock(bp);
 			XFS_STATS_INC(xb_get_locked_waited);
 		} else {
@@ -571,7 +544,7 @@ found:
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
 		bp->b_flags &= XBF_MAPPED;
 	}
-	XB_TRACE(bp, "got_lock", 0);
+	xfs_buftrace(bp, "got_lock");
 	XFS_STATS_INC(xb_get_locked);
 	return bp;
 }
@@ -627,7 +600,7 @@ xfs_buf_get_flags(
 	bp->b_bn = ioff;
 	bp->b_count_desired = bp->b_buffer_length;
 
-	XB_TRACE(bp, "get", (unsigned long)flags);
+	xfs_buftrace_val(bp, "get", flags);
 	return bp;
 
  no_buffer:
@@ -644,7 +617,7 @@ _xfs_buf_read(
 {
 	int			status;
 
-	XB_TRACE(bp, "_xfs_buf_read", (unsigned long)flags);
+	xfs_buftrace_val(bp, "_xfs_buf_read", flags);
 
 	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
 	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
@@ -674,18 +647,18 @@ xfs_buf_read_flags(
 	bp = xfs_buf_get_flags(target, ioff, isize, flags);
 	if (bp) {
 		if (!XFS_BUF_ISDONE(bp)) {
-			XB_TRACE(bp, "read", (unsigned long)flags);
+			xfs_buftrace_val(bp, "read", flags);
 			XFS_STATS_INC(xb_get_read);
 			_xfs_buf_read(bp, flags);
 		} else if (flags & XBF_ASYNC) {
-			XB_TRACE(bp, "read_async", (unsigned long)flags);
+			xfs_buftrace_val(bp, "read_async", flags);
 			/*
 			 * Read ahead call which is already satisfied,
 			 * drop the buffer
 			 */
 			goto no_buffer;
 		} else {
-			XB_TRACE(bp, "read_done", (unsigned long)flags);
+			xfs_buftrace_val(bp, "read_done", flags);
 			/* We do not want read in the flags */
 			bp->b_flags &= ~XBF_READ;
 		}
@@ -823,7 +796,7 @@ xfs_buf_get_noaddr(
 
 	xfs_buf_unlock(bp);
 
-	XB_TRACE(bp, "no_daddr", len);
+	xfs_buftrace_val(bp, "no_daddr", len);
 	return bp;
 
  fail_free_mem:
@@ -846,7 +819,7 @@ xfs_buf_hold(
 	xfs_buf_t		*bp)
 {
 	atomic_inc(&bp->b_hold);
-	XB_TRACE(bp, "hold", 0);
+	xfs_buftrace_val(bp, "hold", 0);
 }
 
 /*
@@ -859,7 +832,7 @@ xfs_buf_rele(
 {
 	xfs_bufhash_t		*hash = bp->b_hash;
 
-	XB_TRACE(bp, "rele", bp->b_relse);
+	xfs_buftrace(bp, "rele");
 
 	if (unlikely(!hash)) {
 		ASSERT(!bp->b_relse);
@@ -911,19 +884,20 @@ xfs_buf_cond_lock(
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked) {
 		XB_SET_OWNER(bp);
+		xfs_buftrace(bp, "cond_lock");
+		return 0;
 	}
-	XB_TRACE(bp, "cond_lock", (long)locked);
-	return locked ? 0 : -EBUSY;
+
+	xfs_buftrace(bp, "cond_lock_fail");
+	return -EBUSY;
 }
 
-#if defined(DEBUG) || defined(XFS_BLI_TRACE)
 int
 xfs_buf_lock_value(
 	xfs_buf_t		*bp)
 {
 	return bp->b_sema.count;
 }
-#endif
 
 /*
  *	Locks a buffer object.
@@ -935,12 +909,12 @@ void
 xfs_buf_lock(
 	xfs_buf_t		*bp)
 {
-	XB_TRACE(bp, "lock", 0);
+	xfs_buftrace(bp, "lock");
 	if (atomic_read(&bp->b_io_remaining))
 		blk_run_address_space(bp->b_target->bt_mapping);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
-	XB_TRACE(bp, "locked", 0);
+	xfs_buftrace(bp, "locked");
 }
 
 /*
@@ -962,7 +936,7 @@ xfs_buf_unlock(
 
 	XB_CLEAR_OWNER(bp);
 	up(&bp->b_sema);
-	XB_TRACE(bp, "unlock", 0);
+	xfs_buftrace(bp, "unlock");
 }
 
 
@@ -975,7 +949,7 @@ xfs_buf_pin(
 	xfs_buf_t		*bp)
 {
 	atomic_inc(&bp->b_pin_count);
-	XB_TRACE(bp, "pin", (long)bp->b_pin_count.counter);
+	xfs_buftrace_val(bp, "pin", bp->b_pin_count.counter);
 }
 
 void
@@ -984,7 +958,7 @@ xfs_buf_unpin(
 {
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
-	XB_TRACE(bp, "unpin", (long)bp->b_pin_count.counter);
+	xfs_buftrace_val(bp, "unpin", bp->b_pin_count.counter);
 }
 
 int
@@ -1035,7 +1009,7 @@ xfs_buf_iodone_work(
 	 */
 	if ((bp->b_error == EOPNOTSUPP) &&
 	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
-		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
+		xfs_buftrace(bp, "ordered_retry");
 		bp->b_flags &= ~XBF_ORDERED;
 		bp->b_flags |= _XFS_BARRIER_FAILED;
 		xfs_buf_iorequest(bp);
@@ -1054,7 +1028,7 @@ xfs_buf_ioend(
 	if (bp->b_error == 0)
 		bp->b_flags |= XBF_DONE;
 
-	XB_TRACE(bp, "iodone", bp->b_iodone);
+	xfs_buftrace(bp, "iodone");
 
 	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
 		if (schedule) {
@@ -1075,7 +1049,7 @@ xfs_buf_ioerror(
 {
 	ASSERT(error >= 0 && error <= 0xffff);
 	bp->b_error = (unsigned short)error;
-	XB_TRACE(bp, "ioerror", (unsigned long)error);
+	xfs_buftrace_val(bp, "ioerror", error);
 }
 
 int
@@ -1083,7 +1057,7 @@ xfs_bawrite(
 	void			*mp,
 	struct xfs_buf		*bp)
 {
-	XB_TRACE(bp, "bawrite", 0);
+	xfs_buftrace(bp, "bawrite");
 
 	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
 
@@ -1102,7 +1076,7 @@ xfs_bdwrite(
 	void			*mp,
 	struct xfs_buf		*bp)
 {
-	XB_TRACE(bp, "bdwrite", 0);
+	xfs_buftrace(bp, "bdwrite");
 
 	bp->b_strat = xfs_bdstrat_cb;
 	bp->b_mount = mp;
@@ -1253,7 +1227,7 @@ int
 xfs_buf_iorequest(
 	xfs_buf_t		*bp)
 {
-	XB_TRACE(bp, "iorequest", 0);
+	xfs_buftrace(bp, "iorequest");
 
 	if (bp->b_flags & XBF_DELWRI) {
 		xfs_buf_delwri_queue(bp, 1);
@@ -1287,11 +1261,11 @@ int
 xfs_buf_iowait(
 	xfs_buf_t		*bp)
 {
-	XB_TRACE(bp, "iowait", 0);
+	xfs_buftrace(bp, "iowait");
 	if (atomic_read(&bp->b_io_remaining))
 		blk_run_address_space(bp->b_target->bt_mapping);
 	wait_for_completion(&bp->b_iowait);
-	XB_TRACE(bp, "iowaited", (long)bp->b_error);
+	xfs_buftrace_val(bp, "iowaited", bp->b_error);
 	return bp->b_error;
 }
 
@@ -1604,7 +1578,8 @@ xfs_buf_delwri_queue(
 	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
 	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
 
-	XB_TRACE(bp, "delwri_q", (long)unlock);
+	xfs_buftrace_val(bp, "delwri_q", unlock);
+
 	ASSERT((bp->b_flags&(XBF_DELWRI|XBF_ASYNC)) == (XBF_DELWRI|XBF_ASYNC));
 
 	spin_lock(dwlk);
@@ -1644,7 +1619,7 @@ xfs_buf_delwri_dequeue(
 	if (dequeued)
 		xfs_buf_rele(bp);
 
-	XB_TRACE(bp, "delwri_dq", (long)dequeued);
+	xfs_buftrace_val(bp, "delwri_dq", dequeued);
 }
 
 STATIC void
@@ -1692,7 +1667,7 @@ xfs_buf_delwri_split(
 	INIT_LIST_HEAD(list);
 	spin_lock(dwlk);
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
-		XB_TRACE(bp, "walkq1", (long)xfs_buf_ispin(bp));
+		xfs_buftrace_val(bp, "walkq1", xfs_buf_ispin(bp));
 		ASSERT(bp->b_flags & XBF_DELWRI);
 
 		if (!xfs_buf_ispin(bp) && !xfs_buf_cond_lock(bp)) {
@@ -1816,14 +1791,10 @@ xfs_flush_buftarg(
 int __init
 xfs_buf_init(void)
 {
-#ifdef XFS_BUF_TRACE
-	xfs_buf_trace_buf = ktrace_alloc(XFS_BUF_TRACE_SIZE, KM_NOFS);
-#endif
-
 	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
 						KM_ZONE_HWALIGN, NULL);
 	if (!xfs_buf_zone)
-		goto out_free_trace_buf;
+		goto out;
 
 	xfslogd_workqueue = create_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
@@ -1846,10 +1817,7 @@ xfs_buf_init(void)
 	destroy_workqueue(xfslogd_workqueue);
  out_free_buf_zone:
 	kmem_zone_destroy(xfs_buf_zone);
- out_free_trace_buf:
-#ifdef XFS_BUF_TRACE
-	ktrace_free(xfs_buf_trace_buf);
-#endif
+ out:
 	return -ENOMEM;
 }
 
@@ -1861,9 +1829,6 @@ xfs_buf_terminate(void)
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
-#ifdef XFS_BUF_TRACE
-	ktrace_free(xfs_buf_trace_buf);
-#endif
 }
 
 #ifdef CONFIG_KDB_MODULES
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-09-09 12:33:56.380253776 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-09-09 12:49:11.169294313 -0300
@@ -95,6 +95,28 @@ typedef enum {
 	_XFS_BARRIER_FAILED = (1 << 23),
 } xfs_buf_flags_t;
 
+#define XFS_BUF_FLAGS \
+	{ XBF_READ,		"READ" }, \
+	{ XBF_WRITE,		"WRITE" }, \
+	{ XBF_MAPPED,		"MAPPED" }, \
+	{ XBF_ASYNC,		"ASYNC" }, \
+	{ XBF_DONE,		"DONE" }, \
+	{ XBF_DELWRI,		"DELWRI" }, \
+	{ XBF_STALE,		"STALE" }, \
+	{ XBF_FS_MANAGED,	"FS_MANAGED" }, \
+	{ XBF_ORDERED,		"ORDERED" }, \
+	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
+	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
+	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
+	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
+	{ _XBF_PAGE_CACHE,	"PAGE_CACHE" }, \
+	{ _XBF_PAGES,		"PAGES" }, \
+	{ _XBF_RUN_QUEUES,	"RUN_QUEUES" }, \
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
+	{ _XBF_PAGE_LOCKED,	"PAGE_LOCKED" }, \
+	{ _XFS_BARRIER_FAILED,	"BARRIER_FAILED" }
+
+
 typedef enum {
 	XBT_FORCE_SLEEP = 0,
 	XBT_FORCE_FLUSH = 1,
@@ -248,13 +270,6 @@ extern void xfs_buf_delwri_dequeue(xfs_b
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
-#ifdef XFS_BUF_TRACE
-extern ktrace_t *xfs_buf_trace_buf;
-extern void xfs_buf_trace(xfs_buf_t *, char *, void *, void *);
-#else
-#define xfs_buf_trace(bp,id,ptr,ra)	do { } while (0)
-#endif
-
 #define xfs_buf_target_name(target)	\
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
@@ -370,10 +385,6 @@ static inline void xfs_buf_relse(xfs_buf
 
 #define xfs_bpin(bp)		xfs_buf_pin(bp)
 #define xfs_bunpin(bp)		xfs_buf_unpin(bp)
-
-#define xfs_buftrace(id, bp)	\
-	    xfs_buf_trace(bp, id, NULL, (void *)__builtin_return_address(0))
-
 #define xfs_biodone(bp)		xfs_buf_ioend(bp, 0)
 
 #define xfs_biomove(bp, off, len, data, rw) \
Index: xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2009-09-09 12:33:56.387254458 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2009-09-09 12:49:11.172298536 -0300
@@ -19,6 +19,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_trace.h"
 
 int  fs_noerr(void) { return 0; }
 int  fs_nosys(void) { return ENOSYS; }
@@ -51,6 +52,8 @@ xfs_flushinval_pages(
 	struct address_space *mapping = VFS_I(ip)->i_mapping;
 	int		ret = 0;
 
+	trace_xfs_pagecache_inval(ip, first, last);
+
 	if (mapping->nrpages) {
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
 		ret = filemap_write_and_wait(mapping);
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-09-09 12:33:56.391254478 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2009-09-09 12:49:11.173254594 -0300
@@ -51,6 +51,7 @@
 #include "xfs_quota.h"
 #include "xfs_inode_item.h"
 #include "xfs_export.h"
+#include "xfs_trace.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-09-09 12:33:56.396253928 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-09-09 12:49:11.177254615 -0300
@@ -46,6 +46,7 @@
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
+#include "xfs_trace.h"
 
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-09-09 12:33:56.400253879 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2009-09-09 12:49:11.182256509 -0300
@@ -47,6 +47,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2009-09-09 12:33:56.405254446 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2009-09-09 12:49:11.185256263 -0300
@@ -40,7 +40,6 @@
 #include <sv.h>
 #include <time.h>
 
-#include <support/ktrace.h>
 #include <support/debug.h>
 #include <support/uuid.h>
 
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 12:33:56.410254105 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 12:49:11.187255959 -0300
@@ -48,73 +48,12 @@
 #include "xfs_utils.h"
 #include "xfs_iomap.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 #include <linux/capability.h>
 #include <linux/writeback.h>
 
 
-#if defined(XFS_RW_TRACE)
-void
-xfs_rw_enter_trace(
-	int			tag,
-	xfs_inode_t		*ip,
-	void			*data,
-	size_t			segs,
-	loff_t			offset,
-	int			ioflags)
-{
-	if (ip->i_rwtrace == NULL)
-		return;
-	ktrace_enter(ip->i_rwtrace,
-		(void *)(unsigned long)tag,
-		(void *)ip,
-		(void *)((unsigned long)((ip->i_d.di_size >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(ip->i_d.di_size & 0xffffffff)),
-		(void *)data,
-		(void *)((unsigned long)segs),
-		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(offset & 0xffffffff)),
-		(void *)((unsigned long)ioflags),
-		(void *)((unsigned long)((ip->i_new_size >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(ip->i_new_size & 0xffffffff)),
-		(void *)((unsigned long)current_pid()),
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL);
-}
-
-void
-xfs_inval_cached_trace(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	xfs_off_t	len,
-	xfs_off_t	first,
-	xfs_off_t	last)
-{
-
-	if (ip->i_rwtrace == NULL)
-		return;
-	ktrace_enter(ip->i_rwtrace,
-		(void *)(__psint_t)XFS_INVAL_CACHED,
-		(void *)ip,
-		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(offset & 0xffffffff)),
-		(void *)((unsigned long)((len >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(len & 0xffffffff)),
-		(void *)((unsigned long)((first >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(first & 0xffffffff)),
-		(void *)((unsigned long)((last >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(last & 0xffffffff)),
-		(void *)((unsigned long)current_pid()),
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL);
-}
-#endif
-
 /*
  *	xfs_iozero
  *
@@ -250,8 +189,7 @@ xfs_read(
 		}
 	}
 
-	xfs_rw_enter_trace(XFS_READ_ENTER, ip,
-				(void *)iovp, segs, *offset, ioflags);
+	trace_xfs_file_read(ip, size, *offset, ioflags);
 
 	iocb->ki_pos = *offset;
 	ret = generic_file_aio_read(iocb, iovp, segs, *offset);
@@ -294,8 +232,9 @@ xfs_splice_read(
 			return -error;
 		}
 	}
-	xfs_rw_enter_trace(XFS_SPLICE_READ_ENTER, ip,
-			   pipe, count, *ppos, ioflags);
+
+	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
+
 	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
@@ -344,8 +283,8 @@ xfs_splice_write(
 		ip->i_new_size = new_size;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	xfs_rw_enter_trace(XFS_SPLICE_WRITE_ENTER, ip,
-			   pipe, count, *ppos, ioflags);
+	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
+
 	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_write_bytes, ret);
@@ -712,8 +651,6 @@ start:
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {
 			WARN_ON(need_i_mutex == 0);
-			xfs_inval_cached_trace(xip, pos, -1,
-					(pos & PAGE_CACHE_MASK), -1);
 			error = xfs_flushinval_pages(xip,
 					(pos & PAGE_CACHE_MASK),
 					-1, FI_REMAPF_LOCKED);
@@ -730,8 +667,7 @@ start:
 			need_i_mutex = 0;
 		}
 
- 		xfs_rw_enter_trace(XFS_DIOWR_ENTER, xip, (void *)iovp, segs,
-				*offset, ioflags);
+		trace_xfs_file_direct_write(xip, count, *offset, ioflags);
 		ret = generic_file_direct_write(iocb, iovp,
 				&segs, pos, offset, count, ocount);
 
@@ -754,8 +690,7 @@ start:
 		ssize_t ret2 = 0;
 
 write_retry:
-		xfs_rw_enter_trace(XFS_WRITE_ENTER, xip, (void *)iovp, segs,
-				*offset, ioflags);
+		trace_xfs_file_buffered_write(xip, count, *offset, ioflags);
 		ret2 = generic_file_buffered_write(iocb, iovp, segs,
 				pos, offset, count, ret);
 		/*
@@ -863,7 +798,7 @@ int
 xfs_bdstrat_cb(struct xfs_buf *bp)
 {
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		xfs_buftrace("XFS__BDSTRAT IOERROR", bp);
+		xfs_buftrace(bp, "bdstrat_cb_shut");
 		/*
 		 * Metadata write that didn't get logged but
 		 * written delayed anyway. These aren't associated
@@ -896,7 +831,7 @@ xfsbdstrat(
 		return;
 	}
 
-	xfs_buftrace("XFSBDSTRAT IOERROR", bp);
+	xfs_buftrace(bp, "bdstrat_shut");
 	xfs_bioerror_relse(bp);
 }
 
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2009-09-09 12:33:56.414253916 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.h	2009-09-09 12:49:11.190255992 -0300
@@ -20,52 +20,7 @@
 
 struct xfs_mount;
 struct xfs_inode;
-struct xfs_bmbt_irec;
 struct xfs_buf;
-struct xfs_iomap;
-
-#if defined(XFS_RW_TRACE)
-/*
- * Defines for the trace mechanisms in xfs_lrw.c.
- */
-#define	XFS_RW_KTRACE_SIZE	128
-
-#define	XFS_READ_ENTER		1
-#define	XFS_WRITE_ENTER		2
-#define XFS_IOMAP_READ_ENTER	3
-#define	XFS_IOMAP_WRITE_ENTER	4
-#define	XFS_IOMAP_READ_MAP	5
-#define	XFS_IOMAP_WRITE_MAP	6
-#define	XFS_IOMAP_WRITE_NOSPACE	7
-#define	XFS_ITRUNC_START	8
-#define	XFS_ITRUNC_FINISH1	9
-#define	XFS_ITRUNC_FINISH2	10
-#define	XFS_CTRUNC1		11
-#define	XFS_CTRUNC2		12
-#define	XFS_CTRUNC3		13
-#define	XFS_CTRUNC4		14
-#define	XFS_CTRUNC5		15
-#define	XFS_CTRUNC6		16
-#define	XFS_BUNMAP		17
-#define	XFS_INVAL_CACHED	18
-#define	XFS_DIORD_ENTER		19
-#define	XFS_DIOWR_ENTER		20
-#define	XFS_WRITEPAGE_ENTER	22
-#define	XFS_RELEASEPAGE_ENTER	23
-#define	XFS_INVALIDPAGE_ENTER	24
-#define	XFS_IOMAP_ALLOC_ENTER	25
-#define	XFS_IOMAP_ALLOC_MAP	26
-#define	XFS_IOMAP_UNWRITTEN	27
-#define XFS_SPLICE_READ_ENTER	28
-#define XFS_SPLICE_WRITE_ENTER	29
-extern void xfs_rw_enter_trace(int, struct xfs_inode *,
-		void *, size_t, loff_t, int);
-extern void xfs_inval_cached_trace(struct xfs_inode *,
-		xfs_off_t, xfs_off_t, xfs_off_t, xfs_off_t);
-#else
-#define xfs_rw_enter_trace(tag, ip, data, size, offset, ioflags)
-#define xfs_inval_cached_trace(ip, offset, len, first, last)
-#endif
 
 /* errors from xfsbdstrat() must be extracted from the buffer */
 extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-09-09 12:33:56.419254483 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-09-09 12:49:11.194307066 -0300
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+
 #include "xfs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
@@ -52,11 +53,12 @@
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
 #include "xfs_da_btree.h"
-#include "xfs_dir2_trace.h"
 #include "xfs_extfree_item.h"
 #include "xfs_mru_cache.h"
 #include "xfs_inode_item.h"
 #include "xfs_sync.h"
+#define CREATE_TRACE_POINTS
+#include "xfs_trace.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -67,6 +69,8 @@
 #include <linux/freezer.h>
 #include <linux/parser.h>
 
+
+
 static struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
@@ -1478,8 +1482,6 @@ xfs_fs_fill_super(
 		goto fail_vnrele;
 
 	kfree(mtpt);
-
-	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 	return 0;
 
  out_filestream_unmount:
@@ -1554,94 +1556,6 @@ static struct file_system_type xfs_fs_ty
 };
 
 STATIC int __init
-xfs_alloc_trace_bufs(void)
-{
-#ifdef XFS_ALLOC_TRACE
-	xfs_alloc_trace_buf = ktrace_alloc(XFS_ALLOC_TRACE_SIZE, KM_MAYFAIL);
-	if (!xfs_alloc_trace_buf)
-		goto out;
-#endif
-#ifdef XFS_BMAP_TRACE
-	xfs_bmap_trace_buf = ktrace_alloc(XFS_BMAP_TRACE_SIZE, KM_MAYFAIL);
-	if (!xfs_bmap_trace_buf)
-		goto out_free_alloc_trace;
-#endif
-#ifdef XFS_BTREE_TRACE
-	xfs_allocbt_trace_buf = ktrace_alloc(XFS_ALLOCBT_TRACE_SIZE,
-					     KM_MAYFAIL);
-	if (!xfs_allocbt_trace_buf)
-		goto out_free_bmap_trace;
-
-	xfs_inobt_trace_buf = ktrace_alloc(XFS_INOBT_TRACE_SIZE, KM_MAYFAIL);
-	if (!xfs_inobt_trace_buf)
-		goto out_free_allocbt_trace;
-
-	xfs_bmbt_trace_buf = ktrace_alloc(XFS_BMBT_TRACE_SIZE, KM_MAYFAIL);
-	if (!xfs_bmbt_trace_buf)
-		goto out_free_inobt_trace;
-#endif
-#ifdef XFS_ATTR_TRACE
-	xfs_attr_trace_buf = ktrace_alloc(XFS_ATTR_TRACE_SIZE, KM_MAYFAIL);
-	if (!xfs_attr_trace_buf)
-		goto out_free_bmbt_trace;
-#endif
-#ifdef XFS_DIR2_TRACE
-	xfs_dir2_trace_buf = ktrace_alloc(XFS_DIR2_GTRACE_SIZE, KM_MAYFAIL);
-	if (!xfs_dir2_trace_buf)
-		goto out_free_attr_trace;
-#endif
-
-	return 0;
-
-#ifdef XFS_DIR2_TRACE
- out_free_attr_trace:
-#endif
-#ifdef XFS_ATTR_TRACE
-	ktrace_free(xfs_attr_trace_buf);
- out_free_bmbt_trace:
-#endif
-#ifdef XFS_BTREE_TRACE
-	ktrace_free(xfs_bmbt_trace_buf);
- out_free_inobt_trace:
-	ktrace_free(xfs_inobt_trace_buf);
- out_free_allocbt_trace:
-	ktrace_free(xfs_allocbt_trace_buf);
- out_free_bmap_trace:
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(xfs_bmap_trace_buf);
- out_free_alloc_trace:
-#endif
-#ifdef XFS_ALLOC_TRACE
-	ktrace_free(xfs_alloc_trace_buf);
- out:
-#endif
-	return -ENOMEM;
-}
-
-STATIC void
-xfs_free_trace_bufs(void)
-{
-#ifdef XFS_DIR2_TRACE
-	ktrace_free(xfs_dir2_trace_buf);
-#endif
-#ifdef XFS_ATTR_TRACE
-	ktrace_free(xfs_attr_trace_buf);
-#endif
-#ifdef XFS_BTREE_TRACE
-	ktrace_free(xfs_bmbt_trace_buf);
-	ktrace_free(xfs_inobt_trace_buf);
-	ktrace_free(xfs_allocbt_trace_buf);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(xfs_bmap_trace_buf);
-#endif
-#ifdef XFS_ALLOC_TRACE
-	ktrace_free(xfs_alloc_trace_buf);
-#endif
-}
-
-STATIC int __init
 xfs_init_zones(void)
 {
 
@@ -1782,7 +1696,6 @@ init_xfs_fs(void)
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
-	ktrace_init(64);
 	xfs_ioend_init();
 	xfs_dir_startup();
 
@@ -1790,13 +1703,9 @@ init_xfs_fs(void)
 	if (error)
 		goto out;
 
-	error = xfs_alloc_trace_bufs();
-	if (error)
-		goto out_destroy_zones;
-
 	error = xfs_mru_cache_init();
 	if (error)
-		goto out_free_trace_buffers;
+		goto out_destroy_zones;
 
 	error = xfs_filestream_init();
 	if (error)
@@ -1831,8 +1740,6 @@ init_xfs_fs(void)
 	xfs_filestream_uninit();
  out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
- out_free_trace_buffers:
-	xfs_free_trace_bufs();
  out_destroy_zones:
 	xfs_destroy_zones();
  out:
@@ -1849,9 +1756,7 @@ exit_xfs_fs(void)
 	xfs_buf_terminate();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
-	xfs_free_trace_bufs();
 	xfs_destroy_zones();
-	ktrace_uninit();
 }
 
 module_init(init_xfs_fs);
Index: xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2009-09-09 12:33:56.423254364 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_super.h	2009-09-09 12:49:11.198028071 -0300
@@ -56,12 +56,6 @@ extern void xfs_qm_exit(void);
 # define XFS_BIGFS_STRING
 #endif
 
-#ifdef CONFIG_XFS_TRACE
-# define XFS_TRACE_STRING	"tracing, "
-#else
-# define XFS_TRACE_STRING
-#endif
-
 #ifdef CONFIG_XFS_DMAPI
 # define XFS_DMAPI_STRING	"dmapi support, "
 #else
@@ -78,7 +72,6 @@ extern void xfs_qm_exit(void);
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
 				XFS_BIGFS_STRING \
-				XFS_TRACE_STRING \
 				XFS_DMAPI_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-09-09 12:33:56.429254011 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-09-09 12:49:11.199256440 -0300
@@ -44,6 +44,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_rw.h"
 #include "xfs_quota.h"
+#include "xfs_trace.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2009-09-09 13:25:13.612256052 -0300
@@ -0,0 +1,1255 @@
+/*
+ * Copyright (c) 2009, Christoph Hellwig
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM xfs
+
+#if !defined(_TRACE_XFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_XFS_H
+
+#include <linux/tracepoint.h>
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_ialloc.h"
+#include "xfs_itable.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_attr.h"
+#include "xfs_attr_sf.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_log_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_quota.h"
+#include "xfs_iomap.h"
+#include "quota/xfs_dquot_item.h"
+#include "quota/xfs_dquot.h"
+
+char *xfs_fmtfsblock(xfs_fsblock_t bno);
+void xfs_count_page_state(struct page *page, int *delalloc,
+		int *unmapped, int *unwritten);
+
+#define DEFINE_ATTR_LIST_TRACE(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_attr_list_context *ctx), \
+	TP_ARGS(ctx), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(u32, hashval) \
+		__field(u32, blkno) \
+		__field(u32, offset) \
+		__field(void *, alist) \
+		__field(int, bufsize) \
+		__field(int, count) \
+		__field(int, firstu) \
+		__field(int, dupcnt) \
+		__field(int, flags) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev; \
+		__entry->ino = ctx->dp->i_ino; \
+		__entry->hashval = ctx->cursor->hashval; \
+		__entry->blkno = ctx->cursor->blkno; \
+		__entry->offset = ctx->cursor->offset; \
+		__entry->alist = ctx->alist; \
+		__entry->bufsize = ctx->bufsize; \
+		__entry->count = ctx->count; \
+		__entry->firstu = ctx->firstu; \
+		__entry->flags = ctx->flags; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u " \
+		  "alist 0x%p size %u count %u firstu %u flags %d %s", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		   __entry->ino, \
+		   __entry->hashval, \
+		   __entry->blkno, \
+		   __entry->offset, \
+		   __entry->dupcnt, \
+		   __entry->alist, \
+		   __entry->bufsize, \
+		   __entry->count, \
+		   __entry->firstu, \
+		   __entry->flags, \
+		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS) \
+	) \
+)
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_sf);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_sf_all);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_leaf);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_leaf_end);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_full);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_add);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_wrong_blk);
+DEFINE_ATTR_LIST_TRACE(xfs_attr_list_notfound);
+
+TRACE_EVENT(xfs_attr_list_node_descend,
+	TP_PROTO(struct xfs_attr_list_context *ctx,
+		 struct xfs_da_node_entry *btree),
+	TP_ARGS(ctx, btree),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(u32, hashval)
+		__field(u32, blkno)
+		__field(u32, offset)
+		__field(void *, alist)
+		__field(int, bufsize)
+		__field(int, count)
+		__field(int, firstu)
+		__field(int, dupcnt)
+		__field(int, flags)
+		__field(u32, bt_hashval)
+		__field(u32, bt_before)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
+		__entry->ino = ctx->dp->i_ino;
+		__entry->hashval = ctx->cursor->hashval;
+		__entry->blkno = ctx->cursor->blkno;
+		__entry->offset = ctx->cursor->offset;
+		__entry->alist = ctx->alist;
+		__entry->bufsize = ctx->bufsize;
+		__entry->count = ctx->count;
+		__entry->firstu = ctx->firstu;
+		__entry->flags = ctx->flags;
+		__entry->bt_hashval = be32_to_cpu(btree->hashval);
+		__entry->bt_before = be32_to_cpu(btree->before);
+	),
+	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
+		  "alist 0x%p size %u count %u firstu %u flags %d %s "
+		  "node hashval %u, node before %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->ino,
+		   __entry->hashval,
+		   __entry->blkno,
+		   __entry->offset,
+		   __entry->dupcnt,
+		   __entry->alist,
+		   __entry->bufsize,
+		   __entry->count,
+		   __entry->firstu,
+		   __entry->flags,
+		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
+		   __entry->bt_hashval,
+		   __entry->bt_before)
+);
+
+TRACE_EVENT(xfs_bmap_insert,
+	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx,
+		 struct xfs_bmbt_irec *r, int whichfork, const char *desc),
+	TP_ARGS(ip, idx, r, whichfork, desc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_extnum_t, idx)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+		__field(xfs_exntst_t, state)
+		__field(int, whichfork)
+		__field(unsigned long, caller_ip)
+		__field(const char *, desc)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->idx = idx;
+		__entry->startoff = r->br_startoff;
+		__entry->startblock = r->br_startblock;
+		__entry->blockcount = r->br_blockcount;
+		__entry->state = r->br_state;
+		__entry->whichfork = whichfork;
+		__entry->caller_ip = _RET_IP_;
+		__entry->desc = desc;
+	),
+	TP_printk("dev %d:%d ino 0x%llx func %pf state %s %cf idx %ld "
+		  "offset %lld block %s count %lld flag %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  (char *)__entry->caller_ip,
+		  __entry->desc,
+		  "da"[!!__entry->whichfork],
+		  (long)__entry->idx,
+		  __entry->startoff,
+		  xfs_fmtfsblock(__entry->startblock),
+		  __entry->blockcount,
+		  __entry->state)
+);
+
+#define DEFINE_BMAP_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int whichfork, \
+		 const char *desc), \
+	TP_ARGS(ip, idx, whichfork, desc), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(xfs_extnum_t, idx) \
+		__field(xfs_fileoff_t, startoff) \
+		__field(xfs_fsblock_t, startblock) \
+		__field(xfs_filblks_t, blockcount) \
+		__field(xfs_exntst_t, state) \
+		__field(int, whichfork) \
+		__field(unsigned long, caller_ip) \
+		__field(const char *, desc) \
+	), \
+	TP_fast_assign( \
+		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork); \
+		struct xfs_bmbt_irec	r; \
+	\
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r); \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->idx = idx; \
+		__entry->startoff = r.br_startoff; \
+		__entry->startblock = r.br_startblock; \
+		__entry->blockcount = r.br_blockcount; \
+		__entry->state = r.br_state; \
+		__entry->whichfork = whichfork; \
+		__entry->caller_ip = _RET_IP_; \
+		__entry->desc = desc; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx func %pf state %s %cf idx %ld " \
+		  "offset %lld block %s count %lld flag %d", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  (char *)__entry->caller_ip, \
+		  __entry->desc, \
+		  "da"[!!__entry->whichfork], \
+		  (long)__entry->idx, \
+		  __entry->startoff, \
+		  xfs_fmtfsblock(__entry->startblock), \
+		  __entry->blockcount, \
+		  __entry->state) \
+)
+
+DEFINE_BMAP_EVENT(xfs_bmap_delete);
+DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
+DEFINE_BMAP_EVENT(xfs_bmap_post_update);
+
+TRACE_EVENT(xfs_buf,
+	TP_PROTO(struct xfs_buf *bp, char *id, unsigned long val,
+		 unsigned long caller_ip),
+	TP_ARGS(bp, id, val, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(char *, id)
+		__field(unsigned, flags)
+		__field(int, hold)
+		__field(unsigned, lockval)
+		__field(unsigned long, val)
+		__field(xfs_off_t, file_offset)
+		__field(size_t, buffer_length)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = bp->b_target->bt_dev;
+		__entry->id = id;
+		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->lockval = xfs_buf_lock_value(bp);
+		__entry->val = val;
+		__entry->file_offset = bp->b_file_offset;
+		__entry->buffer_length = bp->b_buffer_length;
+		__entry->flags = bp->b_flags;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d %s hold %d lock %d val 0x%lx "
+		  "offset 0x%llx size 0x%zx flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->id,
+		  __entry->hold,
+		  __entry->lockval,
+		  __entry->val,
+		  (unsigned long long)__entry->file_offset,
+		  __entry->buffer_length,
+		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  (void *)__entry->caller_ip)
+);
+
+#define xfs_buftrace_val(bp, id, val)	\
+	trace_xfs_buf((bp), (id), (val), _RET_IP_)
+#define xfs_buftrace(bp, id) \
+	trace_xfs_buf((bp), (id), 0, _RET_IP_)
+
+
+TRACE_EVENT(xfs_buf_item,
+	TP_PROTO(char *id, struct xfs_buf_log_item *bip),
+	TP_ARGS(id, bip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(char *, id)
+		__field(void *, bip)
+		__field(void *, bp)
+		__field(unsigned, flags)
+		__field(unsigned, recur)
+		__field(int, refcount)
+		__field(xfs_daddr_t, buf_blkno)
+		__field(size_t, buf_len)
+		__field(unsigned, buf_flags)
+		__field(int, buf_pincount)
+		__field(int, buf_lockval)
+		__field(void *, li_desc)
+		__field(unsigned, li_flags)
+	),
+	TP_fast_assign(
+		__entry->dev = bip->bli_buf->b_target->bt_dev;
+		__entry->id = id;
+		__entry->bip = bip;
+		__entry->bp = bip->bli_buf;
+		__entry->flags = bip->bli_flags;
+		__entry->recur = bip->bli_recur;
+		__entry->refcount = atomic_read(&bip->bli_refcount);
+		__entry->buf_blkno = XFS_BUF_ADDR(bip->bli_buf);
+		__entry->buf_len = XFS_BUF_COUNT(bip->bli_buf);
+		__entry->buf_flags = bip->bli_buf->b_flags;
+		__entry->buf_pincount = XFS_BUF_ISPINNED(bip->bli_buf);
+		__entry->buf_lockval = XFS_BUF_VALUSEMA(bip->bli_buf);
+		__entry->li_desc = bip->bli_item.li_desc;
+		__entry->li_flags = bip->bli_item.li_flags;
+	),
+	TP_printk("dev %d:%d %s bip 0x%p bp 0x%p flags %s recur %d refcount %d "
+		  "blkno 0x%llx blen %zd bpflags %s pincount %d "
+		  "lockval %d lidesc 0x%p liflags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->id,
+		  __entry->bip,
+		  __entry->bp,
+		  __print_flags(__entry->flags, "|", XFS_BLI_FLAGS),
+		  __entry->recur,
+		  __entry->refcount,
+		  (unsigned long long)__entry->buf_blkno,
+		  __entry->buf_len,
+		  __print_flags(__entry->buf_flags, "|", XFS_BUF_FLAGS),
+		  __entry->buf_pincount,
+		  __entry->buf_lockval,
+		  __entry->li_desc,
+		  __print_flags(__entry->li_flags, "|", XFS_LI_FLAGS))
+);
+
+#define xfs_buf_item_trace(id, bip) \
+	trace_xfs_buf_item((id), (bip));
+
+TRACE_EVENT(xfs_dquot,
+	TP_PROTO(struct xfs_dquot *dqp, char *func, struct xfs_inode *ip),
+	TP_ARGS(dqp, func, ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino);
+		__field(__be32, id)
+		__field(char *, func)
+		__field(unsigned, flags)
+		__field(unsigned, nrefs)
+		__field(__u64, res_bcount)
+		__field(__be64, bcount)
+		__field(__be64, icount)
+		__field(__be64, blk_hardlimit)
+		__field(__be64, blk_softlimit)
+		__field(__be64, ino_hardlimit)
+		__field(__be64, ino_softlimit)
+	),
+	TP_fast_assign(
+		__entry->dev = dqp->q_mount->m_super->s_dev;
+		__entry->ino = ip ? ip->i_ino : 0;
+		__entry->id = dqp->q_core.d_id;
+		__entry->func = func;
+		__entry->flags = dqp->dq_flags;
+		__entry->nrefs = dqp->q_nrefs;
+		__entry->res_bcount = dqp->q_res_bcount;
+		__entry->bcount = dqp->q_core.d_bcount;
+		__entry->icount = dqp->q_core.d_icount;
+		__entry->blk_hardlimit = dqp->q_core.d_blk_hardlimit;
+		__entry->blk_softlimit = dqp->q_core.d_blk_softlimit;
+		__entry->ino_hardlimit = dqp->q_core.d_ino_hardlimit;
+		__entry->ino_softlimit = dqp->q_core.d_ino_softlimit;
+	),
+	TP_printk("dev %d:%d ino 0x%llx id 0x%x %s flags %s "
+		  "nrefs %u res_bc 0x%llx "
+		  "bcnt 0x%llx [hard 0x%llx | soft 0x%llx] "
+		  "icnt 0x%llx [hard 0x%llx | soft 0x%llx]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  be32_to_cpu(__entry->id),
+		  __entry->func,
+		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
+		  __entry->nrefs,
+		  (unsigned long long)__entry->res_bcount,
+		  (unsigned long long)be64_to_cpu(__entry->bcount),
+		  (unsigned long long)be64_to_cpu(__entry->blk_hardlimit),
+		  (unsigned long long)be64_to_cpu(__entry->blk_softlimit),
+		  (unsigned long long)be64_to_cpu(__entry->icount),
+		  (unsigned long long)be64_to_cpu(__entry->ino_hardlimit),
+		  (unsigned long long)be64_to_cpu(__entry->ino_softlimit))
+
+);
+
+#define xfs_dqtrace_entry_ino(dqp, func, ip) \
+	trace_xfs_dquot((dqp), (func), (ip));
+#define xfs_dqtrace_entry(dqp, func) \
+	trace_xfs_dquot((dqp), (func), NULL)
+
+#define DEFINE_LOCK_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
+		 unsigned long caller_ip), \
+	TP_ARGS(ip,  lock_flags, caller_ip), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(int, lock_flags) \
+		__field(unsigned long, caller_ip) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->lock_flags = lock_flags; \
+		__entry->caller_ip = caller_ip; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS), \
+		  (void *)__entry->caller_ip) \
+)
+
+DEFINE_LOCK_EVENT(xfs_ilock);
+DEFINE_LOCK_EVENT(xfs_ilock_nowait);
+DEFINE_LOCK_EVENT(xfs_ilock_demote);
+DEFINE_LOCK_EVENT(xfs_iunlock);
+
+#define DEFINE_IGET_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip), \
+	TP_ARGS(ip), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino) \
+)
+DEFINE_IGET_EVENT(xfs_iget_skip);
+DEFINE_IGET_EVENT(xfs_iget_reclaim);
+DEFINE_IGET_EVENT(xfs_iget_found);
+DEFINE_IGET_EVENT(xfs_iget_alloc);
+
+#define DEFINE_INODE_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
+	TP_ARGS(ip, caller_ip), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(int, count) \
+		__field(unsigned long, caller_ip) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->count = atomic_read(&VFS_I(ip)->i_count); \
+		__entry->caller_ip = caller_ip; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx count %d caller %pf", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->count, \
+		  (char *)__entry->caller_ip) \
+)
+DEFINE_INODE_EVENT(xfs_ihold);
+DEFINE_INODE_EVENT(xfs_irele);
+
+/* the old xfs_itrace_entry tracer - to be replaced by s.th. in the VFS */
+DEFINE_INODE_EVENT(xfs_inode);
+#define xfs_itrace_entry(ip)    \
+	trace_xfs_inode(ip, _THIS_IP_)
+
+#define DEFINE_LOGGRANT_EVENT(tname) \
+TRACE_EVENT(tname, \
+	TP_PROTO(struct log *log, struct xlog_ticket *tic), \
+	TP_ARGS(log, tic), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(unsigned, trans_type) \
+		__field(char, ocnt) \
+		__field(char, cnt) \
+		__field(int, curr_res) \
+		__field(int, unit_res) \
+		__field(unsigned int, flags) \
+		__field(void *, reserve_headq) \
+		__field(void *, write_headq) \
+		__field(int, grant_reserve_cycle) \
+		__field(int, grant_reserve_bytes) \
+		__field(int, grant_write_cycle) \
+		__field(int, grant_write_bytes) \
+		__field(int, curr_cycle) \
+		__field(int, curr_block) \
+		__field(xfs_lsn_t, tail_lsn) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = log->l_mp->m_super->s_dev; \
+		__entry->trans_type = tic->t_trans_type; \
+		__entry->ocnt = tic->t_ocnt; \
+		__entry->cnt = tic->t_cnt; \
+		__entry->curr_res = tic->t_curr_res; \
+		__entry->unit_res = tic->t_unit_res; \
+		__entry->flags = tic->t_flags; \
+		__entry->reserve_headq = log->l_reserve_headq; \
+		__entry->write_headq = log->l_write_headq; \
+		__entry->grant_reserve_cycle = log->l_grant_reserve_cycle; \
+		__entry->grant_reserve_bytes = log->l_grant_reserve_bytes; \
+		__entry->grant_write_cycle = log->l_grant_write_cycle; \
+		__entry->grant_write_bytes = log->l_grant_write_bytes; \
+		__entry->curr_cycle = log->l_curr_cycle; \
+		__entry->curr_block = log->l_curr_block; \
+		__entry->tail_lsn = log->l_tail_lsn; \
+	), \
+	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u " \
+		  "t_unit_res %u t_flags %s reserve_headq 0x%p " \
+		  "write_headq 0x%p grant_reserve_cycle %d " \
+		  "grant_reserve_bytes %d grant_write_cycle %d " \
+		  "grant_write_bytes %d curr_cycle %d curr_block %d " \
+		  "tail_cycle %d tail_block %d", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __print_symbolic(__entry->trans_type, XFS_TRANS_TYPES), \
+		  __entry->ocnt, \
+		  __entry->cnt, \
+		  __entry->curr_res, \
+		  __entry->unit_res, \
+		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS), \
+		  __entry->reserve_headq, \
+		  __entry->write_headq, \
+		  __entry->grant_reserve_cycle, \
+		  __entry->grant_reserve_bytes, \
+		  __entry->grant_write_cycle, \
+		  __entry->grant_write_bytes, \
+		  __entry->curr_cycle, \
+		  __entry->curr_block, \
+		  CYCLE_LSN(__entry->tail_lsn), \
+		  BLOCK_LSN(__entry->tail_lsn) \
+	) \
+)
+DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
+DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
+DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
+DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+
+#define DEFINE_RW_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags), \
+	TP_ARGS(ip, count, offset, flags), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(xfs_fsize_t, size) \
+		__field(xfs_fsize_t, new_size) \
+		__field(loff_t, offset) \
+		__field(size_t, count) \
+		__field(int, flags) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->size = ip->i_d.di_size; \
+		__entry->new_size = ip->i_new_size; \
+		__entry->offset = offset; \
+		__entry->count = count; \
+		__entry->flags = flags; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
+		  "offset 0x%llx count 0x%zx ioflags %s", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->size, \
+		  __entry->new_size, \
+		  __entry->offset, \
+		  __entry->count, \
+		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS)) \
+)
+DEFINE_RW_EVENT(xfs_file_read);
+DEFINE_RW_EVENT(xfs_file_buffered_write);
+DEFINE_RW_EVENT(xfs_file_direct_write);
+DEFINE_RW_EVENT(xfs_file_splice_read);
+DEFINE_RW_EVENT(xfs_file_splice_write);
+
+
+#define DEFINE_PAGE_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off), \
+	TP_ARGS(inode, page, off), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(pgoff_t, pgoff) \
+		__field(loff_t, size) \
+		__field(unsigned long, offset) \
+		__field(int, delalloc) \
+		__field(int, unmapped) \
+		__field(int, unwritten) \
+	), \
+	TP_fast_assign( \
+		int delalloc = -1, unmapped = -1, unwritten = -1; \
+	\
+		if (page_has_buffers(page)) \
+			xfs_count_page_state(page, &delalloc, \
+					     &unmapped, &unwritten); \
+		__entry->dev = inode->i_sb->s_dev; \
+		__entry->ino = XFS_I(inode)->i_ino; \
+		__entry->pgoff = page_offset(page); \
+		__entry->size = i_size_read(inode); \
+		__entry->offset = off; \
+		__entry->delalloc = delalloc; \
+		__entry->unmapped = unmapped; \
+		__entry->unwritten = unwritten; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx " \
+		  "delalloc %d unmapped %d unwritten %d", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->pgoff, \
+		  __entry->size, \
+		  __entry->offset, \
+		  __entry->delalloc, \
+		  __entry->unmapped, \
+		  __entry->unwritten) \
+)
+DEFINE_PAGE_EVENT(xfs_writepage);
+DEFINE_PAGE_EVENT(xfs_releasepage);
+DEFINE_PAGE_EVENT(xfs_invalidatepage);
+
+#define DEFINE_IOMAP_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count, \
+		 int flags, struct xfs_bmbt_irec *irec), \
+	TP_ARGS(ip, offset, count, flags, irec), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(loff_t, size) \
+		__field(loff_t, new_size) \
+		__field(loff_t, offset) \
+		__field(size_t, count) \
+		__field(int, flags) \
+		__field(xfs_fileoff_t, startoff) \
+		__field(xfs_fsblock_t, startblock) \
+		__field(xfs_filblks_t, blockcount) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->size = ip->i_d.di_size; \
+		__entry->new_size = ip->i_new_size; \
+		__entry->offset = offset; \
+		__entry->count = count; \
+		__entry->flags = flags; \
+		__entry->startoff = irec ? irec->br_startoff : 0; \
+		__entry->startblock = irec ? irec->br_startblock : 0; \
+		__entry->blockcount = irec ? irec->br_blockcount : 0; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
+		  "offset 0x%llx count %zd flags %s " \
+		  "startoff 0x%llx startblock 0x%llx blockcount 0x%llx", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->size, \
+		  __entry->new_size, \
+		  __entry->offset, \
+		  __entry->count, \
+		  __print_flags(__entry->flags, "|", BMAPI_FLAGS), \
+		  __entry->startoff, \
+		  __entry->startblock, \
+		  __entry->blockcount) \
+)
+DEFINE_IOMAP_EVENT(xfs_iomap_enter);
+DEFINE_IOMAP_EVENT(xfs_iomap_found);
+DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
+
+#define DEFINE_SIMPLE_IO_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count), \
+	TP_ARGS(ip, offset, count), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(loff_t, size) \
+		__field(loff_t, new_size) \
+		__field(loff_t, offset) \
+		__field(size_t, count) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->size = ip->i_d.di_size; \
+		__entry->new_size = ip->i_new_size; \
+		__entry->offset = offset; \
+		__entry->count = count; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
+		  "offset 0x%llx count %zd", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->size, \
+		  __entry->new_size, \
+		  __entry->offset, \
+		  __entry->count) \
+);
+DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
+DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
+
+
+TRACE_EVENT(xfs_itruncate_start,
+	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size, int flag,
+		 xfs_off_t toss_start, xfs_off_t toss_finish),
+	TP_ARGS(ip, new_size, flag, toss_start, toss_finish),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fsize_t, new_size)
+		__field(xfs_off_t, toss_start)
+		__field(xfs_off_t, toss_finish)
+		__field(int, flag)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = new_size;
+		__entry->toss_start = toss_start;
+		__entry->toss_finish = toss_finish;
+		__entry->flag = flag;
+	),
+	TP_printk("dev %d:%d ino 0x%llx %s size 0x%llx new_size 0x%llx "
+		  "toss start 0x%llx toss finish 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->flag, "|", XFS_ITRUNC_FLAGS),
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->toss_start,
+		  __entry->toss_finish)
+);
+
+#define DEFINE_ITRUNC_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
+	TP_ARGS(ip, new_size), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(xfs_fsize_t, size) \
+		__field(xfs_fsize_t, new_size) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
+		__entry->ino = ip->i_ino; \
+		__entry->size = ip->i_d.di_size; \
+		__entry->new_size = new_size; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->size, \
+		  __entry->new_size) \
+)
+DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_start);
+DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_end);
+
+TRACE_EVENT(xfs_pagecache_inval,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
+	TP_ARGS(ip, start, finish),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_off_t, start)
+		__field(xfs_off_t, finish)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->start = start;
+		__entry->finish = finish;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx start 0x%llx finish 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->start,
+		  __entry->finish)
+);
+
+TRACE_EVENT(xfs_bunmap,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
+		 int flags, unsigned long caller_ip),
+	TP_ARGS(ip, bno, len, flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fileoff_t, bno)
+		__field(xfs_filblks_t, len)
+		__field(unsigned long, caller_ip)
+		__field(int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->caller_ip = caller_ip;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
+		  "flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->bno,
+		  __entry->len,
+		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
+		  (void *)__entry->caller_ip)
+
+);
+
+#define xfs_bunmap_trace(ip, bno, len, flags) \
+	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_)
+
+TRACE_EVENT(xfs_alloc_busy,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, int slot),
+	TP_ARGS(mp, agno, agbno, len, slot),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int, slot)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->slot = slot;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u slot %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->slot)
+
+);
+
+/* XXX: make generic? */
+#define XFS_BUSY_STATES \
+	{ 0,	"found" }, \
+	{ 1,	"missing" }
+
+
+TRACE_EVENT(xfs_alloc_unbusy,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int slot, int found),
+	TP_ARGS(mp, agno, slot, found),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, slot)
+		__field(int, found)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->slot = slot;
+		__entry->found = found;
+	),
+	TP_printk("dev %d:%d agno %u slot %d %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->slot,
+		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
+);
+
+TRACE_EVENT(xfs_alloc_busysearch,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, int found),
+	TP_ARGS(mp, agno, agbno, len, found),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(const char *, op)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int, found)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->found = found;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
+);
+
+TRACE_EVENT(xfs_agf,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agf, flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, flags)
+		__field(__u32, length)
+		__field(__u32, bno_root)
+		__field(__u32, cnt_root)
+		__field(__u32, bno_level)
+		__field(__u32, cnt_level)
+		__field(__u32, flfirst)
+		__field(__u32, fllast)
+		__field(__u32, flcount)
+		__field(__u32, freeblks)
+		__field(__u32, longest)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = be32_to_cpu(agf->agf_seqno),
+		__entry->flags = flags;
+		__entry->length = be32_to_cpu(agf->agf_length),
+		__entry->bno_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
+		__entry->cnt_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
+		__entry->bno_level =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+		__entry->cnt_level =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		__entry->flfirst = be32_to_cpu(agf->agf_flfirst),
+		__entry->fllast = be32_to_cpu(agf->agf_fllast),
+		__entry->flcount = be32_to_cpu(agf->agf_flcount),
+		__entry->freeblks = be32_to_cpu(agf->agf_freeblks),
+		__entry->longest = be32_to_cpu(agf->agf_longest);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
+		  "levels b %u c %u flfirst %u fllast %u flcount %u "
+		  "freeblks %u longest %u caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __print_flags(__entry->flags, "|", XFS_AGF_FLAGS),
+		  __entry->length,
+		  __entry->bno_root,
+		  __entry->cnt_root,
+		  __entry->bno_level,
+		  __entry->cnt_level,
+		  __entry->flfirst,
+		  __entry->fllast,
+		  __entry->flcount,
+		  __entry->freeblks,
+		  __entry->longest,
+		  (void *)__entry->caller_ip)
+);
+
+#define xfs_trace_agf(mp, agf, flags) \
+	trace_xfs_agf(mp, agf, flags, _THIS_IP_)
+
+TRACE_EVENT(xfs_free_extent,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, bool isfl, int haveleft, int haveright),
+	TP_ARGS(mp, agno, agbno, len, isfl, haveleft, haveright),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int, isfl)
+		__field(int, haveleft)
+		__field(int, haveright)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->isfl = isfl;
+		__entry->haveleft = haveleft;
+		__entry->haveright = haveright;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u isfl %d %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->isfl,
+		  __entry->haveleft ?
+			(__entry->haveright ? "both" : "left") :
+			(__entry->haveright ? "right" : "none"))
+
+);
+
+TRACE_EVENT(xfs_alloc_extent,
+	TP_PROTO(struct xfs_alloc_arg *args, char *op,
+		 unsigned long caller_ip),
+	TP_ARGS(args, op, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, minlen)
+		__field(xfs_extlen_t, maxlen)
+		__field(xfs_extlen_t, mod)
+		__field(xfs_extlen_t, prod)
+		__field(xfs_extlen_t, minleft)
+		__field(xfs_extlen_t, total)
+		__field(xfs_extlen_t, alignment)
+		__field(xfs_extlen_t, minalignslop)
+		__field(xfs_extlen_t, len)
+		__field(short, type)
+		__field(short, otype)
+		__field(char, wasdel)
+		__field(char, wasfromfl)
+		__field(char, isfl)
+		__field(char, userdata)
+		__field(xfs_fsblock_t, firstblock)
+		__field(const char *, op)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = args->mp->m_super->s_dev;
+		__entry->agno = args->agno;
+		__entry->agbno = args->agbno;
+		__entry->minlen = args->minlen;
+		__entry->maxlen = args->maxlen;
+		__entry->mod = args->mod;
+		__entry->prod = args->prod;
+		__entry->minleft = args->minleft;
+		__entry->total = args->total;
+		__entry->alignment = args->alignment;
+		__entry->minalignslop = args->minalignslop;
+		__entry->len = args->len;
+		__entry->type = args->type;
+		__entry->otype = args->otype;
+		__entry->wasdel = args->wasdel;
+		__entry->wasfromfl = args->wasfromfl;
+		__entry->isfl = args->isfl;
+		__entry->userdata = args->userdata;
+		__entry->firstblock = args->firstblock;
+		__entry->op = op;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d %s agno %u agbno %u minlen %u maxlen %u mod %u "
+		  "prod %u minleft %u total %u alignment %u minalignslop %u "
+		  "len %u type %s otype %s wasdel %d wasfromfl %d isfl %d "
+		  "userdata %d firstblock 0x%llx caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->minlen,
+		  __entry->maxlen,
+		  __entry->mod,
+		  __entry->prod,
+		  __entry->minleft,
+		  __entry->total,
+		  __entry->alignment,
+		  __entry->minalignslop,
+		  __entry->len,
+		  __print_symbolic(__entry->type, XFS_ALLOC_TYPES),
+		  __print_symbolic(__entry->otype, XFS_ALLOC_TYPES),
+		  __entry->wasdel,
+		  __entry->wasfromfl,
+		  __entry->isfl,
+		  __entry->userdata,
+		  __entry->firstblock,
+		  (char *)__entry->caller_ip)
+);
+
+#define xfs_trace_alloc_extent(args, str) \
+	trace_xfs_alloc_extent(args, str, _THIS_IP_)
+
+#define DEFINE_DIR2_TRACE(tname) \
+TRACE_EVENT(tname, \
+	TP_PROTO(struct xfs_da_args *args), \
+	TP_ARGS(args), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__dynamic_array(char, name, args->namelen) \
+		__field(int, namelen) \
+		__field(xfs_dahash_t, hashval) \
+		__field(xfs_ino_t, inumber) \
+		__field(int, op_flags) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev; \
+		__entry->ino = args->dp->i_ino; \
+		if (args->namelen) \
+			memcpy(__get_str(name), args->name, args->namelen); \
+		__entry->namelen = args->namelen; \
+		__entry->hashval = args->hashval; \
+		__entry->inumber = args->inumber; \
+		__entry->op_flags = args->op_flags; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d hashval 0x%x " \
+		  "inumber 0x%llx op_flags %s", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __entry->namelen, \
+		  __entry->namelen ? __get_str(name) : NULL, \
+		  __entry->namelen, \
+		  __entry->hashval, \
+		  __entry->inumber, \
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS)) \
+)
+DEFINE_DIR2_TRACE(xfs_dir2_sf_addname);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_create);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_lookup);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_replace);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_removename);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_toino4);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_toino8);
+DEFINE_DIR2_TRACE(xfs_dir2_sf_to_block);
+DEFINE_DIR2_TRACE(xfs_dir2_block_addname);
+DEFINE_DIR2_TRACE(xfs_dir2_block_lookup);
+DEFINE_DIR2_TRACE(xfs_dir2_block_replace);
+DEFINE_DIR2_TRACE(xfs_dir2_block_removename);
+DEFINE_DIR2_TRACE(xfs_dir2_block_to_sf);
+DEFINE_DIR2_TRACE(xfs_dir2_block_to_leaf);
+DEFINE_DIR2_TRACE(xfs_dir2_leaf_addname);
+DEFINE_DIR2_TRACE(xfs_dir2_leaf_lookup);
+DEFINE_DIR2_TRACE(xfs_dir2_leaf_replace);
+DEFINE_DIR2_TRACE(xfs_dir2_leaf_removename);
+DEFINE_DIR2_TRACE(xfs_dir2_leaf_to_block);
+DEFINE_DIR2_TRACE(xfs_dir2_leaf_to_node);
+DEFINE_DIR2_TRACE(xfs_dir2_node_addname);
+DEFINE_DIR2_TRACE(xfs_dir2_node_lookup);
+DEFINE_DIR2_TRACE(xfs_dir2_node_replace);
+DEFINE_DIR2_TRACE(xfs_dir2_node_removename);
+DEFINE_DIR2_TRACE(xfs_dir2_node_to_leaf);
+
+#define DEFINE_DIR2_SPACE_TRACE(tname) \
+TRACE_EVENT(tname, \
+	TP_PROTO(struct xfs_da_args *args, int idx), \
+	TP_ARGS(args, idx), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_ino_t, ino) \
+		__field(int, op_flags) \
+		__field(int, idx) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev; \
+		__entry->ino = args->dp->i_ino; \
+		__entry->op_flags = args->op_flags; \
+		__entry->idx = idx; \
+	), \
+	TP_printk("dev %d:%d ino 0x%llx op_flags %s index %d", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->ino, \
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS), \
+		  __entry->idx) \
+)
+DEFINE_DIR2_SPACE_TRACE(xfs_dir2_leafn_add);
+DEFINE_DIR2_SPACE_TRACE(xfs_dir2_leafn_remove);
+DEFINE_DIR2_SPACE_TRACE(xfs_dir2_grow_inode);
+DEFINE_DIR2_SPACE_TRACE(xfs_dir2_shrink_inode);
+
+TRACE_EVENT(xfs_dir2_leafn_moveents,
+	TP_PROTO(struct xfs_da_args *args, int src_idx, int dst_idx, int count),
+	TP_ARGS(args, src_idx, dst_idx, count),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, op_flags)
+		__field(int, src_idx)
+		__field(int, dst_idx)
+		__field(int, count)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
+		__entry->ino = args->dp->i_ino;
+		__entry->op_flags = args->op_flags;
+		__entry->src_idx = src_idx;
+		__entry->dst_idx = dst_idx;
+		__entry->count = count;
+	),
+	TP_printk("dev %d:%d ino 0x%llx op_flags %s "
+		  "src_idx %d dst_idx %d count %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->src_idx,
+		  __entry->dst_idx,
+		  __entry->count)
+);
+
+#endif /* _TRACE_XFS_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE xfs_trace
+#include <trace/define_trace.h>
Index: xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-09-09 12:33:56.437253912 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_vnode.h	2009-09-09 12:49:11.209028215 -0300
@@ -40,6 +40,11 @@ struct attrlist_cursor_kern;
 #define IO_ISDIRECT	0x00004		/* bypass page cache */
 #define IO_INVIS	0x00020		/* don't update inode timestamps */
 
+#define XFS_IO_FLAGS \
+	{ IO_ISAIO,	"AIO" }, \
+	{ IO_ISDIRECT,	"DIRECT" }, \
+	{ IO_INVIS,	"INVIS"}
+
 /*
  * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
  */
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-09-09 12:33:56.442254479 -0300
+++ xfs/fs/xfs/quota/xfs_dquot.c	2009-09-09 12:49:11.214255906 -0300
@@ -47,6 +47,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
+#include "xfs_trace.h"
 
 
 /*
@@ -112,10 +113,7 @@ xfs_qm_dqinit(
 		init_completion(&dqp->q_flush);
 		complete(&dqp->q_flush);
 
-#ifdef XFS_DQUOT_TRACE
-		dqp->q_trace = ktrace_alloc(DQUOT_TRACE_SIZE, KM_NOFS);
 		xfs_dqtrace_entry(dqp, "DQINIT");
-#endif
 	} else {
 		/*
 		 * Only the q_core portion was zeroed in dqreclaim_one().
@@ -136,10 +134,7 @@ xfs_qm_dqinit(
 		 dqp->q_hash = NULL;
 		 ASSERT(dqp->dq_flnext == dqp->dq_flprev);
 
-#ifdef XFS_DQUOT_TRACE
-		 ASSERT(dqp->q_trace);
 		 xfs_dqtrace_entry(dqp, "DQRECLAIMED_INIT");
-#endif
 	}
 
 	/*
@@ -167,13 +162,8 @@ xfs_qm_dqdestroy(
 
 	mutex_destroy(&dqp->q_qlock);
 	sv_destroy(&dqp->q_pinwait);
-
-#ifdef XFS_DQUOT_TRACE
-	if (dqp->q_trace)
-	     ktrace_free(dqp->q_trace);
-	dqp->q_trace = NULL;
-#endif
 	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
+
 	atomic_dec(&xfs_Gqm->qm_totaldquots);
 }
 
@@ -195,49 +185,6 @@ xfs_qm_dqinit_core(
 	d->dd_diskdq.d_flags = type;
 }
 
-
-#ifdef XFS_DQUOT_TRACE
-/*
- * Dquot tracing for debugging.
- */
-/* ARGSUSED */
-void
-__xfs_dqtrace_entry(
-	xfs_dquot_t	*dqp,
-	char		*func,
-	void		*retaddr,
-	xfs_inode_t	*ip)
-{
-	xfs_dquot_t	*udqp = NULL;
-	xfs_ino_t	ino = 0;
-
-	ASSERT(dqp->q_trace);
-	if (ip) {
-		ino = ip->i_ino;
-		udqp = ip->i_udquot;
-	}
-	ktrace_enter(dqp->q_trace,
-		     (void *)(__psint_t)DQUOT_KTRACE_ENTRY,
-		     (void *)func,
-		     (void *)(__psint_t)dqp->q_nrefs,
-		     (void *)(__psint_t)dqp->dq_flags,
-		     (void *)(__psint_t)dqp->q_res_bcount,
-		     (void *)(__psint_t)be64_to_cpu(dqp->q_core.d_bcount),
-		     (void *)(__psint_t)be64_to_cpu(dqp->q_core.d_icount),
-		     (void *)(__psint_t)be64_to_cpu(dqp->q_core.d_blk_hardlimit),
-		     (void *)(__psint_t)be64_to_cpu(dqp->q_core.d_blk_softlimit),
-		     (void *)(__psint_t)be64_to_cpu(dqp->q_core.d_ino_hardlimit),
-		     (void *)(__psint_t)be64_to_cpu(dqp->q_core.d_ino_softlimit),
-		     (void *)(__psint_t)be32_to_cpu(dqp->q_core.d_id),
-		     (void *)(__psint_t)current_pid(),
-		     (void *)(__psint_t)ino,
-		     (void *)(__psint_t)retaddr,
-		     (void *)(__psint_t)udqp);
-	return;
-}
-#endif
-
-
 /*
  * If default limits are in force, push them into the dquot now.
  * We overwrite the dquot limits only if they are zero and this
Index: xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.h	2009-09-09 12:33:56.446254919 -0300
+++ xfs/fs/xfs/quota/xfs_dquot.h	2009-09-09 12:49:11.217255311 -0300
@@ -85,9 +85,6 @@ typedef struct xfs_dquot {
 	struct completion q_flush;	/* flush completion queue */
 	atomic_t          q_pincount;	/* dquot pin count */
 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
-#ifdef XFS_DQUOT_TRACE
-	struct ktrace	*q_trace;	/* trace header structure */
-#endif
 } xfs_dquot_t;
 
 
@@ -144,24 +141,6 @@ static inline void xfs_dqfunlock(xfs_dqu
 				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
 				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
 
-#ifdef XFS_DQUOT_TRACE
-/*
- * Dquot Tracing stuff.
- */
-#define DQUOT_TRACE_SIZE	64
-#define DQUOT_KTRACE_ENTRY	1
-
-extern void		__xfs_dqtrace_entry(xfs_dquot_t *dqp, char *func,
-					    void *, xfs_inode_t *);
-#define xfs_dqtrace_entry_ino(a,b,ip) \
-		__xfs_dqtrace_entry((a), (b), (void*)__return_address, (ip))
-#define xfs_dqtrace_entry(a,b) \
-		__xfs_dqtrace_entry((a), (b), (void*)__return_address, NULL)
-#else
-#define xfs_dqtrace_entry(a,b)
-#define xfs_dqtrace_entry_ino(a,b,ip)
-#endif
-
 #ifdef QUOTADEBUG
 extern void		xfs_qm_dqprint(xfs_dquot_t *);
 #else
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-09-09 12:33:56.452254146 -0300
+++ xfs/fs/xfs/quota/xfs_qm.c	2009-09-09 12:49:11.220256182 -0300
@@ -47,6 +47,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
 #include "xfs_qm.h"
+#include "xfs_trace.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1350,7 +1351,8 @@ xfs_qm_reset_dqcounts(
 	xfs_disk_dquot_t	*ddq;
 	int			j;
 
-	xfs_buftrace("RESET DQUOTS", bp);
+	xfs_buftrace(bp, "reset_dquots");
+
 	/*
 	 * Reset all counters and timers. They'll be
 	 * started afresh by xfs_qm_quotacheck.
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-09-09 12:33:56.457253876 -0300
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-09-09 12:49:11.224256622 -0300
@@ -49,6 +49,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_qm.h"
+#include "xfs_trace.h"
 
 #ifdef DEBUG
 # define qdprintk(s, args...)	cmn_err(CE_DEBUG, s, ## args)
Index: xfs/fs/xfs/support/ktrace.c
===================================================================
--- xfs.orig/fs/xfs/support/ktrace.c	2009-09-09 12:33:56.461253617 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,323 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include <xfs.h>
-
-static kmem_zone_t *ktrace_hdr_zone;
-static kmem_zone_t *ktrace_ent_zone;
-static int          ktrace_zentries;
-
-void __init
-ktrace_init(int zentries)
-{
-	ktrace_zentries = roundup_pow_of_two(zentries);
-
-	ktrace_hdr_zone = kmem_zone_init(sizeof(ktrace_t),
-					"ktrace_hdr");
-	ASSERT(ktrace_hdr_zone);
-
-	ktrace_ent_zone = kmem_zone_init(ktrace_zentries
-					* sizeof(ktrace_entry_t),
-					"ktrace_ent");
-	ASSERT(ktrace_ent_zone);
-}
-
-void __exit
-ktrace_uninit(void)
-{
-	kmem_zone_destroy(ktrace_hdr_zone);
-	kmem_zone_destroy(ktrace_ent_zone);
-}
-
-/*
- * ktrace_alloc()
- *
- * Allocate a ktrace header and enough buffering for the given
- * number of entries. Round the number of entries up to a
- * power of 2 so we can do fast masking to get the index from
- * the atomic index counter.
- */
-ktrace_t *
-ktrace_alloc(int nentries, unsigned int __nocast sleep)
-{
-	ktrace_t        *ktp;
-	ktrace_entry_t  *ktep;
-	int		entries;
-
-	ktp = (ktrace_t*)kmem_zone_alloc(ktrace_hdr_zone, sleep);
-
-	if (ktp == (ktrace_t*)NULL) {
-		/*
-		 * KM_SLEEP callers don't expect failure.
-		 */
-		if (sleep & KM_SLEEP)
-			panic("ktrace_alloc: NULL memory on KM_SLEEP request!");
-
-		return NULL;
-	}
-
-	/*
-	 * Special treatment for buffers with the ktrace_zentries entries
-	 */
-	entries = roundup_pow_of_two(nentries);
-	if (entries == ktrace_zentries) {
-		ktep = (ktrace_entry_t*)kmem_zone_zalloc(ktrace_ent_zone,
-							    sleep);
-	} else {
-		ktep = (ktrace_entry_t*)kmem_zalloc((entries * sizeof(*ktep)),
-							    sleep | KM_LARGE);
-	}
-
-	if (ktep == NULL) {
-		/*
-		 * KM_SLEEP callers don't expect failure.
-		 */
-		if (sleep & KM_SLEEP)
-			panic("ktrace_alloc: NULL memory on KM_SLEEP request!");
-
-		kmem_free(ktp);
-
-		return NULL;
-	}
-
-	ktp->kt_entries  = ktep;
-	ktp->kt_nentries = entries;
-	ASSERT(is_power_of_2(entries));
-	ktp->kt_index_mask = entries - 1;
-	atomic_set(&ktp->kt_index, 0);
-	ktp->kt_rollover = 0;
-	return ktp;
-}
-
-
-/*
- * ktrace_free()
- *
- * Free up the ktrace header and buffer.  It is up to the caller
- * to ensure that no-one is referencing it.
- */
-void
-ktrace_free(ktrace_t *ktp)
-{
-	if (ktp == (ktrace_t *)NULL)
-		return;
-
-	/*
-	 * Special treatment for the Vnode trace buffer.
-	 */
-	if (ktp->kt_nentries == ktrace_zentries)
-		kmem_zone_free(ktrace_ent_zone, ktp->kt_entries);
-	else
-		kmem_free(ktp->kt_entries);
-
-	kmem_zone_free(ktrace_hdr_zone, ktp);
-}
-
-
-/*
- * Enter the given values into the "next" entry in the trace buffer.
- * kt_index is always the index of the next entry to be filled.
- */
-void
-ktrace_enter(
-	ktrace_t        *ktp,
-	void            *val0,
-	void            *val1,
-	void            *val2,
-	void            *val3,
-	void            *val4,
-	void            *val5,
-	void            *val6,
-	void            *val7,
-	void            *val8,
-	void            *val9,
-	void            *val10,
-	void            *val11,
-	void            *val12,
-	void            *val13,
-	void            *val14,
-	void            *val15)
-{
-	int             index;
-	ktrace_entry_t  *ktep;
-
-	ASSERT(ktp != NULL);
-
-	/*
-	 * Grab an entry by pushing the index up to the next one.
-	 */
-	index = atomic_add_return(1, &ktp->kt_index);
-	index = (index - 1) & ktp->kt_index_mask;
-	if (!ktp->kt_rollover && index == ktp->kt_nentries - 1)
-		ktp->kt_rollover = 1;
-
-	ASSERT((index >= 0) && (index < ktp->kt_nentries));
-
-	ktep = &(ktp->kt_entries[index]);
-
-	ktep->val[0]  = val0;
-	ktep->val[1]  = val1;
-	ktep->val[2]  = val2;
-	ktep->val[3]  = val3;
-	ktep->val[4]  = val4;
-	ktep->val[5]  = val5;
-	ktep->val[6]  = val6;
-	ktep->val[7]  = val7;
-	ktep->val[8]  = val8;
-	ktep->val[9]  = val9;
-	ktep->val[10] = val10;
-	ktep->val[11] = val11;
-	ktep->val[12] = val12;
-	ktep->val[13] = val13;
-	ktep->val[14] = val14;
-	ktep->val[15] = val15;
-}
-
-/*
- * Return the number of entries in the trace buffer.
- */
-int
-ktrace_nentries(
-	ktrace_t        *ktp)
-{
-	int	index;
-	if (ktp == NULL)
-		return 0;
-
-	index = atomic_read(&ktp->kt_index) & ktp->kt_index_mask;
-	return (ktp->kt_rollover ? ktp->kt_nentries : index);
-}
-
-/*
- * ktrace_first()
- *
- * This is used to find the start of the trace buffer.
- * In conjunction with ktrace_next() it can be used to
- * iterate through the entire trace buffer.  This code does
- * not do any locking because it is assumed that it is called
- * from the debugger.
- *
- * The caller must pass in a pointer to a ktrace_snap
- * structure in which we will keep some state used to
- * iterate through the buffer.  This state must not touched
- * by any code outside of this module.
- */
-ktrace_entry_t *
-ktrace_first(ktrace_t   *ktp, ktrace_snap_t     *ktsp)
-{
-	ktrace_entry_t  *ktep;
-	int             index;
-	int             nentries;
-
-	if (ktp->kt_rollover)
-		index = atomic_read(&ktp->kt_index) & ktp->kt_index_mask;
-	else
-		index = 0;
-
-	ktsp->ks_start = index;
-	ktep = &(ktp->kt_entries[index]);
-
-	nentries = ktrace_nentries(ktp);
-	index++;
-	if (index < nentries) {
-		ktsp->ks_index = index;
-	} else {
-		ktsp->ks_index = 0;
-		if (index > nentries)
-			ktep = NULL;
-	}
-	return ktep;
-}
-
-/*
- * ktrace_next()
- *
- * This is used to iterate through the entries of the given
- * trace buffer.  The caller must pass in the ktrace_snap_t
- * structure initialized by ktrace_first().  The return value
- * will be either a pointer to the next ktrace_entry or NULL
- * if all of the entries have been traversed.
- */
-ktrace_entry_t *
-ktrace_next(
-	ktrace_t        *ktp,
-	ktrace_snap_t   *ktsp)
-{
-	int             index;
-	ktrace_entry_t  *ktep;
-
-	index = ktsp->ks_index;
-	if (index == ktsp->ks_start) {
-		ktep = NULL;
-	} else {
-		ktep = &ktp->kt_entries[index];
-	}
-
-	index++;
-	if (index == ktrace_nentries(ktp)) {
-		ktsp->ks_index = 0;
-	} else {
-		ktsp->ks_index = index;
-	}
-
-	return ktep;
-}
-
-/*
- * ktrace_skip()
- *
- * Skip the next "count" entries and return the entry after that.
- * Return NULL if this causes us to iterate past the beginning again.
- */
-ktrace_entry_t *
-ktrace_skip(
-	ktrace_t        *ktp,
-	int             count,
-	ktrace_snap_t   *ktsp)
-{
-	int             index;
-	int             new_index;
-	ktrace_entry_t  *ktep;
-	int             nentries = ktrace_nentries(ktp);
-
-	index = ktsp->ks_index;
-	new_index = index + count;
-	while (new_index >= nentries) {
-		new_index -= nentries;
-	}
-	if (index == ktsp->ks_start) {
-		/*
-		 * We've iterated around to the start, so we're done.
-		 */
-		ktep = NULL;
-	} else if ((new_index < index) && (index < ktsp->ks_index)) {
-		/*
-		 * We've skipped past the start again, so we're done.
-		 */
-		ktep = NULL;
-		ktsp->ks_index = ktsp->ks_start;
-	} else {
-		ktep = &(ktp->kt_entries[new_index]);
-		new_index++;
-		if (new_index == nentries) {
-			ktsp->ks_index = 0;
-		} else {
-			ktsp->ks_index = new_index;
-		}
-	}
-	return ktep;
-}
Index: xfs/fs/xfs/support/ktrace.h
===================================================================
--- xfs.orig/fs/xfs/support/ktrace.h	2009-09-09 12:33:56.465253707 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,85 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_KTRACE_H__
-#define __XFS_SUPPORT_KTRACE_H__
-
-/*
- * Trace buffer entry structure.
- */
-typedef struct ktrace_entry {
-	void	*val[16];
-} ktrace_entry_t;
-
-/*
- * Trace buffer header structure.
- */
-typedef struct ktrace {
-	int		kt_nentries;	/* number of entries in trace buf */
-	atomic_t	kt_index;	/* current index in entries */
-	unsigned int	kt_index_mask;
-	int		kt_rollover;
-	ktrace_entry_t	*kt_entries;	/* buffer of entries */
-} ktrace_t;
-
-/*
- * Trace buffer snapshot structure.
- */
-typedef struct ktrace_snap {
-	int		ks_start;	/* kt_index at time of snap */
-	int		ks_index;	/* current index */
-} ktrace_snap_t;
-
-
-#ifdef CONFIG_XFS_TRACE
-
-extern void ktrace_init(int zentries);
-extern void ktrace_uninit(void);
-
-extern ktrace_t *ktrace_alloc(int, unsigned int __nocast);
-extern void ktrace_free(ktrace_t *);
-
-extern void ktrace_enter(
-	ktrace_t	*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*,
-	void		*);
-
-extern ktrace_entry_t   *ktrace_first(ktrace_t *, ktrace_snap_t *);
-extern int              ktrace_nentries(ktrace_t *);
-extern ktrace_entry_t   *ktrace_next(ktrace_t *, ktrace_snap_t *);
-extern ktrace_entry_t   *ktrace_skip(ktrace_t *, int, ktrace_snap_t *);
-
-#else
-#define ktrace_init(x)	do { } while (0)
-#define ktrace_uninit()	do { } while (0)
-#endif	/* CONFIG_XFS_TRACE */
-
-#endif	/* __XFS_SUPPORT_KTRACE_H__ */
Index: xfs/fs/xfs/xfs.h
===================================================================
--- xfs.orig/fs/xfs/xfs.h	2009-09-09 12:33:56.469254356 -0300
+++ xfs/fs/xfs/xfs.h	2009-09-09 12:49:11.233256371 -0300
@@ -25,21 +25,5 @@
 /* #define QUOTADEBUG 1 */
 #endif
 
-#ifdef CONFIG_XFS_TRACE
-#define XFS_ALLOC_TRACE 1
-#define XFS_ATTR_TRACE 1
-#define XFS_BLI_TRACE 1
-#define XFS_BMAP_TRACE 1
-#define XFS_BTREE_TRACE 1
-#define XFS_DIR2_TRACE 1
-#define XFS_DQUOT_TRACE 1
-#define XFS_ILOCK_TRACE 1
-#define XFS_LOG_TRACE 1
-#define XFS_RW_TRACE 1
-#define XFS_BUF_TRACE 1
-#define XFS_INODE_TRACE 1
-#define XFS_FILESTREAMS_TRACE 1
-#endif
-
 #include <linux-2.6/xfs_linux.h>
 #endif	/* __XFS_H__ */
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2009-09-09 12:33:56.475254422 -0300
+++ xfs/fs/xfs/xfs_ag.h	2009-09-09 12:49:11.235256347 -0300
@@ -86,6 +86,20 @@ typedef struct xfs_agf {
 #define	XFS_AGF_NUM_BITS	12
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
+#define XFS_AGF_FLAGS \
+	{ XFS_AGF_MAGICNUM,	"MAGICNUM" }, \
+	{ XFS_AGF_VERSIONNUM,	"VERSIONNUM" }, \
+	{ XFS_AGF_SEQNO,	"SEQNO" }, \
+	{ XFS_AGF_LENGTH,	"LENGTH" }, \
+	{ XFS_AGF_ROOTS,	"ROOTS" }, \
+	{ XFS_AGF_LEVELS,	"LEVELS" }, \
+	{ XFS_AGF_FLFIRST,	"FLFIRST" }, \
+	{ XFS_AGF_FLLAST,	"FLLAST" }, \
+	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
+	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
+	{ XFS_AGF_LONGEST,	"LONGEST" }, \
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }
+
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2009-09-09 12:33:56.479253814 -0300
+++ xfs/fs/xfs/xfs_alloc.c	2009-09-09 12:49:11.241256482 -0300
@@ -38,6 +38,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 
 #define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
@@ -51,30 +52,6 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 		    xfs_agblock_t bno,
 		    xfs_extlen_t len);
 
-#if defined(XFS_ALLOC_TRACE)
-ktrace_t *xfs_alloc_trace_buf;
-
-#define	TRACE_ALLOC(s,a)	\
-	xfs_alloc_trace_alloc(__func__, s, a, __LINE__)
-#define	TRACE_FREE(s,a,b,x,f)	\
-	xfs_alloc_trace_free(__func__, s, mp, a, b, x, f, __LINE__)
-#define	TRACE_MODAGF(s,a,f)	\
-	xfs_alloc_trace_modagf(__func__, s, mp, a, f, __LINE__)
-#define	TRACE_BUSY(__func__,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
-#define	TRACE_UNBUSY(__func__,s,ag,sl,tp)	\
-	xfs_alloc_trace_busy(__func__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
-#define	TRACE_BUSYSEARCH(__func__,s,ag,agb,l,tp)	\
-	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, 0, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
-#else
-#define	TRACE_ALLOC(s,a)
-#define	TRACE_FREE(s,a,b,x,f)
-#define	TRACE_MODAGF(s,a,f)
-#define	TRACE_BUSY(s,a,ag,agb,l,sl,tp)
-#define	TRACE_UNBUSY(fname,s,ag,sl,tp)
-#define	TRACE_BUSYSEARCH(fname,s,ag,agb,l,tp)
-#endif	/* XFS_ALLOC_TRACE */
-
 /*
  * Prototypes for per-ag allocation routines
  */
@@ -498,124 +475,6 @@ xfs_alloc_read_agfl(
 	return 0;
 }
 
-#if defined(XFS_ALLOC_TRACE)
-/*
- * Add an allocation trace entry for an alloc call.
- */
-STATIC void
-xfs_alloc_trace_alloc(
-	const char	*name,		/* function tag string */
-	char		*str,		/* additional string */
-	xfs_alloc_arg_t	*args,		/* allocation argument structure */
-	int		line)		/* source line number */
-{
-	ktrace_enter(xfs_alloc_trace_buf,
-		(void *)(__psint_t)(XFS_ALLOC_KTRACE_ALLOC | (line << 16)),
-		(void *)name,
-		(void *)str,
-		(void *)args->mp,
-		(void *)(__psunsigned_t)args->agno,
-		(void *)(__psunsigned_t)args->agbno,
-		(void *)(__psunsigned_t)args->minlen,
-		(void *)(__psunsigned_t)args->maxlen,
-		(void *)(__psunsigned_t)args->mod,
-		(void *)(__psunsigned_t)args->prod,
-		(void *)(__psunsigned_t)args->minleft,
-		(void *)(__psunsigned_t)args->total,
-		(void *)(__psunsigned_t)args->alignment,
-		(void *)(__psunsigned_t)args->len,
-		(void *)((((__psint_t)args->type) << 16) |
-			 (__psint_t)args->otype),
-		(void *)(__psint_t)((args->wasdel << 3) |
-				    (args->wasfromfl << 2) |
-				    (args->isfl << 1) |
-				    (args->userdata << 0)));
-}
-
-/*
- * Add an allocation trace entry for a free call.
- */
-STATIC void
-xfs_alloc_trace_free(
-	const char	*name,		/* function tag string */
-	char		*str,		/* additional string */
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_agblock_t	agbno,		/* a.g. relative block number */
-	xfs_extlen_t	len,		/* length of extent */
-	int		isfl,		/* set if is freelist allocation/free */
-	int		line)		/* source line number */
-{
-	ktrace_enter(xfs_alloc_trace_buf,
-		(void *)(__psint_t)(XFS_ALLOC_KTRACE_FREE | (line << 16)),
-		(void *)name,
-		(void *)str,
-		(void *)mp,
-		(void *)(__psunsigned_t)agno,
-		(void *)(__psunsigned_t)agbno,
-		(void *)(__psunsigned_t)len,
-		(void *)(__psint_t)isfl,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-}
-
-/*
- * Add an allocation trace entry for modifying an agf.
- */
-STATIC void
-xfs_alloc_trace_modagf(
-	const char	*name,		/* function tag string */
-	char		*str,		/* additional string */
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_agf_t	*agf,		/* new agf value */
-	int		flags,		/* logging flags for agf */
-	int		line)		/* source line number */
-{
-	ktrace_enter(xfs_alloc_trace_buf,
-		(void *)(__psint_t)(XFS_ALLOC_KTRACE_MODAGF | (line << 16)),
-		(void *)name,
-		(void *)str,
-		(void *)mp,
-		(void *)(__psint_t)flags,
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_seqno),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_length),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_flfirst),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_fllast),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_flcount),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_freeblks),
-		(void *)(__psunsigned_t)be32_to_cpu(agf->agf_longest));
-}
-
-STATIC void
-xfs_alloc_trace_busy(
-	const char	*name,		/* function tag string */
-	char		*str,		/* additional string */
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_agblock_t	agbno,		/* a.g. relative block number */
-	xfs_extlen_t	len,		/* length of extent */
-	int		slot,		/* perag Busy slot */
-	xfs_trans_t	*tp,
-	int		trtype,		/* type: add, delete, search */
-	int		line)		/* source line number */
-{
-	ktrace_enter(xfs_alloc_trace_buf,
-		(void *)(__psint_t)(trtype | (line << 16)),
-		(void *)name,
-		(void *)str,
-		(void *)mp,
-		(void *)(__psunsigned_t)agno,
-		(void *)(__psunsigned_t)agbno,
-		(void *)(__psunsigned_t)len,
-		(void *)(__psint_t)slot,
-		(void *)tp,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-}
-#endif	/* XFS_ALLOC_TRACE */
-
 /*
  * Allocation group level functions.
  */
@@ -665,9 +524,7 @@ xfs_alloc_ag_vextent(
 	 */
 	if (args->agbno != NULLAGBLOCK) {
 		xfs_agf_t	*agf;	/* allocation group freelist header */
-#ifdef XFS_ALLOC_TRACE
 		xfs_mount_t	*mp = args->mp;
-#endif
 		long		slen = (long)args->len;
 
 		ASSERT(args->len >= args->minlen && args->len <= args->maxlen);
@@ -682,7 +539,7 @@ xfs_alloc_ag_vextent(
 			args->pag->pagf_freeblks -= args->len;
 			ASSERT(be32_to_cpu(agf->agf_freeblks) <=
 				be32_to_cpu(agf->agf_length));
-			TRACE_MODAGF(NULL, agf, XFS_AGF_FREEBLKS);
+			xfs_trace_agf(mp, agf, XFS_AGF_FREEBLKS);
 			xfs_alloc_log_agf(args->tp, args->agbp,
 						XFS_AGF_FREEBLKS);
 			/* search the busylist for these blocks */
@@ -792,13 +649,14 @@ xfs_alloc_ag_vextent_exact(
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	TRACE_ALLOC("normal", args);
+
+	xfs_trace_alloc_extent(args, "normal");
 	args->wasfromfl = 0;
 	return 0;
 
 error0:
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
-	TRACE_ALLOC("error", args);
+	xfs_trace_alloc_extent(args, "error");
 	return error;
 }
 
@@ -958,7 +816,7 @@ xfs_alloc_ag_vextent_near(
 		args->len = blen;
 		if (!xfs_alloc_fix_minleft(args)) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			TRACE_ALLOC("nominleft", args);
+			xfs_trace_alloc_extent(args, "nominleft");
 			return 0;
 		}
 		blen = args->len;
@@ -981,7 +839,8 @@ xfs_alloc_ag_vextent_near(
 			goto error0;
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
-		TRACE_ALLOC("first", args);
+
+		xfs_trace_alloc_extent(args, "first");
 		return 0;
 	}
 	/*
@@ -1272,7 +1131,7 @@ xfs_alloc_ag_vextent_near(
 	 * If we couldn't get anything, give up.
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
-		TRACE_ALLOC("neither", args);
+		xfs_trace_alloc_extent(args, "neither");
 		args->agbno = NULLAGBLOCK;
 		return 0;
 	}
@@ -1299,7 +1158,7 @@ xfs_alloc_ag_vextent_near(
 	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args)) {
-		TRACE_ALLOC("nominleft", args);
+		xfs_trace_alloc_extent(args, "nominleft");
 		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		return 0;
@@ -1314,13 +1173,14 @@ xfs_alloc_ag_vextent_near(
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
 			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
 		goto error0;
-	TRACE_ALLOC(j ? "gt" : "lt", args);
+
+	xfs_trace_alloc_extent(args, j ? "gt" : "lt");
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
 	return 0;
 
  error0:
-	TRACE_ALLOC("error", args);
+	xfs_trace_alloc_extent(args, "error");
 	if (cnt_cur != NULL)
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 	if (bno_cur_lt != NULL)
@@ -1371,7 +1231,7 @@ xfs_alloc_ag_vextent_size(
 			goto error0;
 		if (i == 0 || flen == 0) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			TRACE_ALLOC("noentry", args);
+			xfs_trace_alloc_extent(args, "noentry");
 			return 0;
 		}
 		ASSERT(i == 1);
@@ -1448,7 +1308,7 @@ xfs_alloc_ag_vextent_size(
 	xfs_alloc_fix_len(args);
 	if (rlen < args->minlen || !xfs_alloc_fix_minleft(args)) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		TRACE_ALLOC("nominleft", args);
+		xfs_trace_alloc_extent(args, "nominleft");
 		args->agbno = NULLAGBLOCK;
 		return 0;
 	}
@@ -1471,11 +1331,11 @@ xfs_alloc_ag_vextent_size(
 		args->agbno + args->len <=
 			be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 		error0);
-	TRACE_ALLOC("normal", args);
+	xfs_trace_alloc_extent(args, "normal");
 	return 0;
 
 error0:
-	TRACE_ALLOC("error", args);
+	xfs_trace_alloc_extent(args, "error");
 	if (cnt_cur)
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 	if (bno_cur)
@@ -1534,7 +1394,7 @@ xfs_alloc_ag_vextent_small(
 				be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 				error0);
 			args->wasfromfl = 1;
-			TRACE_ALLOC("freelist", args);
+			xfs_trace_alloc_extent(args, "freelist");
 			*stat = 0;
 			return 0;
 		}
@@ -1556,17 +1416,17 @@ xfs_alloc_ag_vextent_small(
 	 */
 	if (flen < args->minlen) {
 		args->agbno = NULLAGBLOCK;
-		TRACE_ALLOC("notenough", args);
+		xfs_trace_alloc_extent(args, "notenough");
 		flen = 0;
 	}
 	*fbnop = fbno;
 	*flenp = flen;
 	*stat = 1;
-	TRACE_ALLOC("normal", args);
+	xfs_trace_alloc_extent(args, "normal");
 	return 0;
 
 error0:
-	TRACE_ALLOC("error", args);
+	xfs_trace_alloc_extent(args, "error");
 	return error;
 }
 
@@ -1809,17 +1669,15 @@ xfs_free_ag_extent(
 			be32_to_cpu(agf->agf_freeblks) <=
 			be32_to_cpu(agf->agf_length),
 			error0);
-		TRACE_MODAGF(NULL, agf, XFS_AGF_FREEBLKS);
+		xfs_trace_agf(mp, agf, XFS_AGF_FREEBLKS);
 		xfs_alloc_log_agf(tp, agbp, XFS_AGF_FREEBLKS);
 		if (!isfl)
 			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (long)len);
 		XFS_STATS_INC(xs_freex);
 		XFS_STATS_ADD(xs_freeb, len);
 	}
-	TRACE_FREE(haveleft ?
-			(haveright ? "both" : "left") :
-			(haveright ? "right" : "none"),
-		agno, bno, len, isfl);
+
+	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
 
 	/*
 	 * Since blocks move to the free list without the coordination
@@ -1836,7 +1694,7 @@ xfs_free_ag_extent(
 	return 0;
 
  error0:
-	TRACE_FREE("error", agno, bno, len, isfl);
+	trace_xfs_free_extent(mp, agno, bno, len, isfl, -1, -1);
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	if (cnt_cur)
@@ -2122,7 +1980,7 @@ xfs_alloc_get_freelist(
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
-	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_trace_agf(mp, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
@@ -2230,13 +2088,13 @@ xfs_alloc_put_freelist(
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
-	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_trace_agf(mp, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
 	blockp = &agfl->agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
-	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_trace_agf(mp, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	xfs_trans_log_buf(tp, agflbp,
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
@@ -2399,7 +2257,7 @@ xfs_alloc_vextent(
 	    args->minlen > args->maxlen || args->minlen > agsize ||
 	    args->mod >= args->prod) {
 		args->fsbno = NULLFSBLOCK;
-		TRACE_ALLOC("badargs", args);
+		xfs_trace_alloc_extent(args, "badargs");
 		return 0;
 	}
 	minleft = args->minleft;
@@ -2418,12 +2276,12 @@ xfs_alloc_vextent(
 		error = xfs_alloc_fix_freelist(args, 0);
 		args->minleft = minleft;
 		if (error) {
-			TRACE_ALLOC("nofix", args);
+			xfs_trace_alloc_extent(args, "nofix");
 			goto error0;
 		}
 		if (!args->agbp) {
 			up_read(&mp->m_peraglock);
-			TRACE_ALLOC("noagbp", args);
+			xfs_trace_alloc_extent(args, "noagbp");
 			break;
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
@@ -2488,7 +2346,7 @@ xfs_alloc_vextent(
 			error = xfs_alloc_fix_freelist(args, flags);
 			args->minleft = minleft;
 			if (error) {
-				TRACE_ALLOC("nofix", args);
+				xfs_trace_alloc_extent(args, "nofix");
 				goto error0;
 			}
 			/*
@@ -2499,7 +2357,9 @@ xfs_alloc_vextent(
 					goto error0;
 				break;
 			}
-			TRACE_ALLOC("loopfailed", args);
+
+			xfs_trace_alloc_extent(args, "loopfailed");
+
 			/*
 			 * Didn't work, figure out the next iteration.
 			 */
@@ -2526,7 +2386,8 @@ xfs_alloc_vextent(
 			if (args->agno == sagno) {
 				if (no_min == 1) {
 					args->agbno = NULLAGBLOCK;
-					TRACE_ALLOC("allfailed", args);
+					xfs_trace_alloc_extent(args,
+							       "allfailed");
 					break;
 				}
 				if (flags == 0) {
@@ -2642,16 +2503,16 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 		}
 	}
 
+	trace_xfs_alloc_busy(mp, agno, bno, len, n);
+
 	if (n < XFS_PAGB_NUM_SLOTS) {
 		bsy = &mp->m_perag[agno].pagb_list[n];
 		mp->m_perag[agno].pagb_count++;
-		TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, n, tp);
 		bsy->busy_start = bno;
 		bsy->busy_length = len;
 		bsy->busy_tp = tp;
 		xfs_trans_add_busy(tp, agno, n);
 	} else {
-		TRACE_BUSY("xfs_alloc_mark_busy", "FULL", agno, bno, len, -1, tp);
 		/*
 		 * The busy list is full!  Since it is now not possible to
 		 * track the free block, make this a synchronous transaction
@@ -2678,12 +2539,12 @@ xfs_alloc_clear_busy(xfs_trans_t *tp,
 	list = mp->m_perag[agno].pagb_list;
 
 	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
+
+	trace_xfs_alloc_unbusy(mp, agno, idx, list[idx].busy_tp == tp);
+
 	if (list[idx].busy_tp == tp) {
-		TRACE_UNBUSY("xfs_alloc_clear_busy", "found", agno, idx, tp);
 		list[idx].busy_tp = NULL;
 		mp->m_perag[agno].pagb_count--;
-	} else {
-		TRACE_UNBUSY("xfs_alloc_clear_busy", "missing", agno, idx, tp);
 	}
 
 	spin_unlock(&mp->m_perag[agno].pagb_lock);
@@ -2724,24 +2585,22 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 			if ((bno > bend) || (uend < bsy->busy_start)) {
 				cnt--;
 			} else {
-				TRACE_BUSYSEARCH("xfs_alloc_search_busy",
-					 "found1", agno, bno, len, tp);
 				break;
 			}
 		}
 	}
 
+	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!cnt);
+
 	/*
 	 * If a block was found, force the log through the LSN of the
 	 * transaction that freed the block
 	 */
 	if (cnt) {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
 		lsn = bsy->busy_tp->t_commit_lsn;
 		spin_unlock(&mp->m_perag[agno].pagb_lock);
 		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
 	} else {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
 		spin_unlock(&mp->m_perag[agno].pagb_lock);
 	}
 }
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2009-09-09 12:33:56.484253822 -0300
+++ xfs/fs/xfs/xfs_alloc.h	2009-09-09 12:49:11.244256306 -0300
@@ -37,6 +37,15 @@ typedef enum xfs_alloctype
 	XFS_ALLOCTYPE_THIS_BNO		/* at exactly this block */
 } xfs_alloctype_t;
 
+#define XFS_ALLOC_TYPES \
+	{ XFS_ALLOCTYPE_ANY_AG,		"ANY_AG" }, \
+	{ XFS_ALLOCTYPE_FIRST_AG,	"FIRST_AG" }, \
+	{ XFS_ALLOCTYPE_START_AG,	"START_AG" }, \
+	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
+	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
+	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
+	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
+
 /*
  * Flags for xfs_alloc_fix_freelist.
  */
@@ -109,13 +118,6 @@ xfs_alloc_longest_free_extent(struct xfs
 
 #ifdef __KERNEL__
 
-#if defined(XFS_ALLOC_TRACE)
-/*
- * Allocation tracing buffer size.
- */
-#define	XFS_ALLOC_TRACE_SIZE	4096
-extern ktrace_t *xfs_alloc_trace_buf;
-
 /*
  * Types for alloc tracing.
  */
@@ -125,7 +127,7 @@ extern ktrace_t *xfs_alloc_trace_buf;
 #define	XFS_ALLOC_KTRACE_BUSY	4
 #define	XFS_ALLOC_KTRACE_UNBUSY	5
 #define	XFS_ALLOC_KTRACE_BUSYSEARCH	6
-#endif
+
 
 void
 xfs_alloc_mark_busy(xfs_trans_t *tp,
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2009-09-09 12:33:56.488253773 -0300
+++ xfs/fs/xfs/xfs_alloc_btree.c	2009-09-09 12:49:11.246256910 -0300
@@ -39,6 +39,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 
 STATIC struct xfs_btree_cur *
@@ -67,6 +68,7 @@ xfs_allocbt_set_root(
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
 	cur->bc_mp->m_perag[seqno].pagf_levels[btnum] += inc;
 
+	xfs_trace_agf(cur->bc_mp, agf, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
 
@@ -193,6 +195,7 @@ xfs_allocbt_update_lastrec(
 
 	agf->agf_longest = len;
 	cur->bc_mp->m_perag[seqno].pagf_longest = be32_to_cpu(len);
+	xfs_trace_agf(cur->bc_mp, agf, XFS_AGF_LONGEST);
 	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 }
 
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2009-09-09 12:33:56.494253909 -0300
+++ xfs/fs/xfs/xfs_attr.c	2009-09-09 12:49:11.251256010 -0300
@@ -47,6 +47,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_rw.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 /*
  * xfs_attr.c
@@ -89,10 +90,6 @@ STATIC int xfs_attr_rmtval_remove(xfs_da
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
-#if defined(XFS_ATTR_TRACE)
-ktrace_t *xfs_attr_trace_buf;
-#endif
-
 STATIC int
 xfs_attr_name_to_xname(
 	struct xfs_name	*xname,
@@ -636,7 +633,6 @@ xfs_attr_list_int(xfs_attr_list_context_
 		return EIO;
 
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	xfs_attr_trace_l_c("syscall start", context);
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -652,7 +648,6 @@ xfs_attr_list_int(xfs_attr_list_context_
 	}
 
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
-	xfs_attr_trace_l_c("syscall end", context);
 
 	return error;
 }
@@ -698,7 +693,7 @@ xfs_attr_put_listent(xfs_attr_list_conte
 			context->count * sizeof(alist->al_offset[0]);
 	context->firstu -= ATTR_ENTSIZE(namelen);
 	if (context->firstu < arraytop) {
-		xfs_attr_trace_l_c("buffer full", context);
+		trace_xfs_attr_list_full(context);
 		alist->al_more = 1;
 		context->seen_enough = 1;
 		return 1;
@@ -710,7 +705,7 @@ xfs_attr_put_listent(xfs_attr_list_conte
 	aep->a_name[namelen] = 0;
 	alist->al_offset[context->count++] = context->firstu;
 	alist->al_count = context->count;
-	xfs_attr_trace_l_c("add", context);
+	trace_xfs_attr_list_add(context);
 	return 0;
 }
 
@@ -1849,7 +1844,7 @@ xfs_attr_node_list(xfs_attr_list_context
 			node = bp->data;
 			switch (be16_to_cpu(node->hdr.info.magic)) {
 			case XFS_DA_NODE_MAGIC:
-				xfs_attr_trace_l_cn("wrong blk", context, node);
+				trace_xfs_attr_list_wrong_blk(context);
 				xfs_da_brelse(NULL, bp);
 				bp = NULL;
 				break;
@@ -1857,20 +1852,18 @@ xfs_attr_node_list(xfs_attr_list_context
 				leaf = bp->data;
 				if (cursor->hashval > be32_to_cpu(leaf->entries[
 				    be16_to_cpu(leaf->hdr.count)-1].hashval)) {
-					xfs_attr_trace_l_cl("wrong blk",
-							   context, leaf);
+					trace_xfs_attr_list_wrong_blk(context);
 					xfs_da_brelse(NULL, bp);
 					bp = NULL;
 				} else if (cursor->hashval <=
 					     be32_to_cpu(leaf->entries[0].hashval)) {
-					xfs_attr_trace_l_cl("maybe wrong blk",
-							   context, leaf);
+					trace_xfs_attr_list_wrong_blk(context);
 					xfs_da_brelse(NULL, bp);
 					bp = NULL;
 				}
 				break;
 			default:
-				xfs_attr_trace_l_c("wrong blk - ??", context);
+				trace_xfs_attr_list_wrong_blk(context);
 				xfs_da_brelse(NULL, bp);
 				bp = NULL;
 			}
@@ -1915,8 +1908,8 @@ xfs_attr_node_list(xfs_attr_list_context
 				if (cursor->hashval
 						<= be32_to_cpu(btree->hashval)) {
 					cursor->blkno = be32_to_cpu(btree->before);
-					xfs_attr_trace_l_cb("descending",
-							    context, btree);
+					trace_xfs_attr_list_node_descend(context,
+									 btree);
 					break;
 				}
 			}
@@ -2266,85 +2259,3 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 	}
 	return(0);
 }
-
-#if defined(XFS_ATTR_TRACE)
-/*
- * Add a trace buffer entry for an attr_list context structure.
- */
-void
-xfs_attr_trace_l_c(char *where, struct xfs_attr_list_context *context)
-{
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_C, where, context,
-		(__psunsigned_t)NULL,
-		(__psunsigned_t)NULL,
-		(__psunsigned_t)NULL);
-}
-
-/*
- * Add a trace buffer entry for a context structure and a Btree node.
- */
-void
-xfs_attr_trace_l_cn(char *where, struct xfs_attr_list_context *context,
-			 struct xfs_da_intnode *node)
-{
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CN, where, context,
-		(__psunsigned_t)be16_to_cpu(node->hdr.count),
-		(__psunsigned_t)be32_to_cpu(node->btree[0].hashval),
-		(__psunsigned_t)be32_to_cpu(node->btree[
-				    be16_to_cpu(node->hdr.count)-1].hashval));
-}
-
-/*
- * Add a trace buffer entry for a context structure and a Btree element.
- */
-void
-xfs_attr_trace_l_cb(char *where, struct xfs_attr_list_context *context,
-			  struct xfs_da_node_entry *btree)
-{
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CB, where, context,
-		(__psunsigned_t)be32_to_cpu(btree->hashval),
-		(__psunsigned_t)be32_to_cpu(btree->before),
-		(__psunsigned_t)NULL);
-}
-
-/*
- * Add a trace buffer entry for a context structure and a leaf block.
- */
-void
-xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_attr_leafblock *leaf)
-{
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CL, where, context,
-		(__psunsigned_t)be16_to_cpu(leaf->hdr.count),
-		(__psunsigned_t)be32_to_cpu(leaf->entries[0].hashval),
-		(__psunsigned_t)be32_to_cpu(leaf->entries[
-				be16_to_cpu(leaf->hdr.count)-1].hashval));
-}
-
-/*
- * Add a trace buffer entry for the arguments given to the routine,
- * generic form.
- */
-void
-xfs_attr_trace_enter(int type, char *where,
-			 struct xfs_attr_list_context *context,
-			 __psunsigned_t a13, __psunsigned_t a14,
-			 __psunsigned_t a15)
-{
-	ASSERT(xfs_attr_trace_buf);
-	ktrace_enter(xfs_attr_trace_buf, (void *)((__psunsigned_t)type),
-		(void *)((__psunsigned_t)where),
-		(void *)((__psunsigned_t)context->dp),
-		(void *)((__psunsigned_t)context->cursor->hashval),
-		(void *)((__psunsigned_t)context->cursor->blkno),
-		(void *)((__psunsigned_t)context->cursor->offset),
-		(void *)((__psunsigned_t)context->alist),
-		(void *)((__psunsigned_t)context->bufsize),
-		(void *)((__psunsigned_t)context->count),
-		(void *)((__psunsigned_t)context->firstu),
-		NULL,
-		(void *)((__psunsigned_t)context->dupcnt),
-		(void *)((__psunsigned_t)context->flags),
-		(void *)a13, (void *)a14, (void *)a15);
-}
-#endif	/* XFS_ATTR_TRACE */
Index: xfs/fs/xfs/xfs_attr.h
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.h	2009-09-09 12:33:56.498254139 -0300
+++ xfs/fs/xfs/xfs_attr.h	2009-09-09 12:49:11.254255485 -0300
@@ -48,6 +48,16 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
+#define XFS_ATTR_FLAGS \
+	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
+	{ ATTR_ROOT,		"ROOT" }, \
+	{ ATTR_TRUST,		"TRUST" }, \
+	{ ATTR_SECURE,		"SECURE" }, \
+	{ ATTR_CREATE,		"CREATE" }, \
+	{ ATTR_REPLACE,		"REPLACE" }, \
+	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
+	{ ATTR_KERNOVAL,	"KERNOVAL" }
+
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
  * attribute value or the buffer used for an attr_list() call.  Larger
Index: xfs/fs/xfs/xfs_attr_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_sf.h	2009-09-09 12:33:56.503254497 -0300
+++ xfs/fs/xfs/xfs_attr_sf.h	2009-09-09 12:49:11.258027963 -0300
@@ -25,8 +25,6 @@
  * to fit into the literal area of the inode.
  */
 
-struct xfs_inode;
-
 /*
  * Entries are packed toward the top as tight as possible.
  */
@@ -69,42 +67,4 @@ typedef struct xfs_attr_sf_sort {
 	(be16_to_cpu(((xfs_attr_shortform_t *)	\
 		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
 
-#if defined(XFS_ATTR_TRACE)
-/*
- * Kernel tracing support for attribute lists
- */
-struct xfs_attr_list_context;
-struct xfs_da_intnode;
-struct xfs_da_node_entry;
-struct xfs_attr_leafblock;
-
-#define	XFS_ATTR_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_attr_trace_buf;
-
-/*
- * Trace record types.
- */
-#define	XFS_ATTR_KTRACE_L_C	1	/* context */
-#define	XFS_ATTR_KTRACE_L_CN	2	/* context, node */
-#define	XFS_ATTR_KTRACE_L_CB	3	/* context, btree */
-#define	XFS_ATTR_KTRACE_L_CL	4	/* context, leaf */
-
-void xfs_attr_trace_l_c(char *where, struct xfs_attr_list_context *context);
-void xfs_attr_trace_l_cn(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_da_intnode *node);
-void xfs_attr_trace_l_cb(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_da_node_entry *btree);
-void xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_attr_leafblock *leaf);
-void xfs_attr_trace_enter(int type, char *where,
-			     struct xfs_attr_list_context *context,
-			     __psunsigned_t a13, __psunsigned_t a14,
-			     __psunsigned_t a15);
-#else
-#define	xfs_attr_trace_l_c(w,c)
-#define	xfs_attr_trace_l_cn(w,c,n)
-#define	xfs_attr_trace_l_cb(w,c,b)
-#define	xfs_attr_trace_l_cl(w,c,l)
-#endif /* XFS_ATTR_TRACE */
-
 #endif	/* __XFS_ATTR_SF_H__ */
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2009-09-09 12:33:56.507254656 -0300
+++ xfs/fs/xfs/xfs_bmap.c	2009-09-09 12:49:11.270256405 -0300
@@ -54,6 +54,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 
 #ifdef DEBUG
@@ -272,71 +273,6 @@ xfs_bmap_isaeof(
 	int             whichfork,	/* data or attribute fork */
 	char		*aeof);		/* return value */
 
-#ifdef XFS_BMAP_TRACE
-/*
- * Add bmap trace entry prior to a call to xfs_iext_remove.
- */
-STATIC void
-xfs_bmap_trace_delete(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(entries) deleted */
-	xfs_extnum_t	cnt,		/* count of entries deleted, 1 or 2 */
-	int		whichfork);	/* data or attr fork */
-
-/*
- * Add bmap trace entry prior to a call to xfs_iext_insert, or
- * reading in the extents list from the disk (in the btree).
- */
-STATIC void
-xfs_bmap_trace_insert(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(entries) inserted */
-	xfs_extnum_t	cnt,		/* count of entries inserted, 1 or 2 */
-	xfs_bmbt_irec_t	*r1,		/* inserted record 1 */
-	xfs_bmbt_irec_t	*r2,		/* inserted record 2 or null */
-	int		whichfork);	/* data or attr fork */
-
-/*
- * Add bmap trace entry after updating an extent record in place.
- */
-STATIC void
-xfs_bmap_trace_post_update(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry updated */
-	int		whichfork);	/* data or attr fork */
-
-/*
- * Add bmap trace entry prior to updating an extent record in place.
- */
-STATIC void
-xfs_bmap_trace_pre_update(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry to be updated */
-	int		whichfork);	/* data or attr fork */
-
-#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)	\
-	xfs_bmap_trace_delete(__func__,d,ip,i,c,w)
-#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)	\
-	xfs_bmap_trace_insert(__func__,d,ip,i,c,r1,r2,w)
-#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_post_update(__func__,d,ip,i,w)
-#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_pre_update(__func__,d,ip,i,w)
-#else
-#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)
-#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)
-#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)
-#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)
-#endif	/* XFS_BMAP_TRACE */
-
 /*
  * Compute the worst-case number of indirect blocks that will be used
  * for ip's delayed extent of length "len".
@@ -363,18 +299,6 @@ xfs_bmap_validate_ret(
 #define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
 #endif /* DEBUG */
 
-#if defined(XFS_RW_TRACE)
-STATIC void
-xfs_bunmap_trace(
-	xfs_inode_t		*ip,
-	xfs_fileoff_t		bno,
-	xfs_filblks_t		len,
-	int			flags,
-	inst_t			*ra);
-#else
-#define	xfs_bunmap_trace(ip, bno, len, flags, ra)
-#endif	/* XFS_RW_TRACE */
-
 STATIC int
 xfs_bmap_count_tree(
 	xfs_mount_t     *mp,
@@ -398,6 +322,11 @@ xfs_bmap_disk_count_leaves(
 	int			numrecs,
 	int			*count);
 
+#define	xfs_trace_bmap_post_update(d, ip, i, w)	\
+	trace_xfs_bmap_post_update(ip, i, w, d)
+#define	xfs_trace_bmap_pre_update(d, ip, i, w)	\
+	trace_xfs_bmap_pre_update(ip, i, w, d)
+
 /*
  * Bmap internal routines.
  */
@@ -590,8 +519,7 @@ xfs_bmap_add_extent(
 	 * already extents in the list.
 	 */
 	if (nextents == 0) {
-		XFS_BMAP_TRACE_INSERT("insert empty", ip, 0, 1, new, NULL,
-			whichfork);
+		trace_xfs_bmap_insert(ip, 0, new, whichfork, "E");
 		xfs_iext_insert(ifp, 0, 1, new);
 		ASSERT(cur == NULL);
 		ifp->if_lastex = 0;
@@ -844,14 +772,16 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, XFS_DATA_FORK,
+					  "LF|RF|LC|RC");
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, XFS_DATA_FORK,
+					  "LF|RF|LC|RC");
+
+		trace_xfs_bmap_delete(ip, idx, XFS_DATA_FORK, "LF|RF|LC|RC");
+		trace_xfs_bmap_delete(ip, idx + 1, XFS_DATA_FORK, "LF|RF|LC|RC");
 		xfs_iext_remove(ifp, idx, 2);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents--;
@@ -890,14 +820,15 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, XFS_DATA_FORK,
+					  "LF|RF|LC");
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, XFS_DATA_FORK,
+					  "LF|RF|LC");
+
 		ip->i_df.if_lastex = idx - 1;
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
+		trace_xfs_bmap_delete(ip, idx, XFS_DATA_FORK, "LF|RF|LC");
 		xfs_iext_remove(ifp, idx, 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -926,13 +857,14 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, XFS_DATA_FORK, "LF|RF|RC");
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, XFS_DATA_FORK, "LF|RF|RC");
+
 		ip->i_df.if_lastex = idx;
-		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
+		trace_xfs_bmap_delete(ip, idx + 1, XFS_DATA_FORK, "LF|RF|RC");
 		xfs_iext_remove(ifp, idx + 1, 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -962,9 +894,10 @@ xfs_bmap_add_extent_delay_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, XFS_DATA_FORK, "LF|RF");
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, XFS_DATA_FORK, "LF|RF");
+
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -992,15 +925,19 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx - 1, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, XFS_DATA_FORK, "LF|LC");
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx - 1, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, XFS_DATA_FORK, "LF|LC");
+
 		temp = PREV.br_blockcount - new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
+
+		trace_xfs_bmap_pre_update(ip, idx, XFS_DATA_FORK, "LF|LC");
 		xfs_bmbt_set_blockcount(ep, temp);
+		trace_xfs_bmap_post_update(ip, idx, XFS_DATA_FORK, "LF|LC");
+
 		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1021,7 +958,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("LF|LC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
 		temp = LEFT.br_startoff;
@@ -1034,12 +971,11 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, XFS_DATA_FORK, "LF");
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx, new, XFS_DATA_FORK, "LF");
 		xfs_iext_insert(ifp, idx, 1, new);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
@@ -1071,7 +1007,7 @@ xfs_bmap_add_extent_delay_real(
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx + 1);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx + 1, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("LF", ip, idx + 1, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
 		temp = PREV.br_startoff;
@@ -1084,14 +1020,14 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx + 1, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, XFS_DATA_FORK, "RF|RC");
+		trace_xfs_bmap_pre_update(ip, idx + 1, XFS_DATA_FORK, "RF|RC");
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount,
 			RIGHT.br_state);
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx + 1, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx + 1, XFS_DATA_FORK, "RF|RC");
 		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1112,7 +1048,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("RF|RC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
 		temp = PREV.br_startoff;
@@ -1126,10 +1062,9 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is not contiguous.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("RF", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep, temp);
-		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx + 1, new, XFS_DATA_FORK, "RF");
 		xfs_iext_insert(ifp, idx + 1, 1, new);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
@@ -1161,7 +1096,7 @@ xfs_bmap_add_extent_delay_real(
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("RF", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
 		temp = PREV.br_startoff;
@@ -1175,7 +1110,7 @@ xfs_bmap_add_extent_delay_real(
 		 * This case is avoided almost all the time.
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("0", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep, temp);
 		r[0] = *new;
 		r[1].br_state = PREV.br_state;
@@ -1183,8 +1118,8 @@ xfs_bmap_add_extent_delay_real(
 		r[1].br_startoff = new_endoff;
 		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_blockcount = temp2;
-		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
-			XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx + 1, &r[0], XFS_DATA_FORK, "0");
+		trace_xfs_bmap_insert(ip, idx + 1, &r[1], XFS_DATA_FORK, "0");
 		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
@@ -1242,11 +1177,11 @@ xfs_bmap_add_extent_delay_real(
 		}
 		ep = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("0", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("0", ip, idx + 2, XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
 			nullstartblock((int)temp2));
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("0", ip, idx + 2, XFS_DATA_FORK);
 		*dnew = temp + temp2;
 		/* DELTA: One in-core extent is split in three. */
 		temp = PREV.br_startoff;
@@ -1405,14 +1340,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC|RC", ip, idx - 1,
+		xfs_trace_bmap_pre_update("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
+		xfs_trace_bmap_post_update("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
+		trace_xfs_bmap_delete(ip, idx, XFS_DATA_FORK, "LF|RF|LC|RC");
+		trace_xfs_bmap_delete(ip, idx + 1, XFS_DATA_FORK, "LF|RF|LC|RC");
 		xfs_iext_remove(ifp, idx, 2);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents -= 2;
@@ -1455,14 +1391,14 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC", ip, idx - 1,
+		xfs_trace_bmap_pre_update("LF|RF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC", ip, idx - 1,
+		xfs_trace_bmap_post_update("LF|RF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
+		trace_xfs_bmap_delete(ip, idx, XFS_DATA_FORK, "LF|RF|LC");
 		xfs_iext_remove(ifp, idx, 1);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
@@ -1497,15 +1433,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|RC", ip, idx,
+		xfs_trace_bmap_pre_update("LF|RF|RC", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
 		xfs_bmbt_set_state(ep, newext);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx,
+		xfs_trace_bmap_post_update("LF|RF|RC", ip, idx,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
-		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
+		trace_xfs_bmap_delete(ip, idx + 1, XFS_DATA_FORK, "LF|RF|RC");
 		xfs_iext_remove(ifp, idx + 1, 1);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
@@ -1541,10 +1477,10 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF", ip, idx,
+		xfs_trace_bmap_pre_update("LF|RF", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_state(ep, newext);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF", ip, idx,
+		xfs_trace_bmap_post_update("LF|RF", ip, idx,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		if (cur == NULL)
@@ -1571,21 +1507,21 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx - 1,
+		xfs_trace_bmap_pre_update("LF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx - 1,
+		xfs_trace_bmap_post_update("LF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx,
+		xfs_trace_bmap_pre_update("LF|LC", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx,
+		xfs_trace_bmap_post_update("LF|LC", ip, idx,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
@@ -1622,16 +1558,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is not contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("LF", ip, idx, XFS_DATA_FORK);
 		ASSERT(ep && xfs_bmbt_get_state(ep) == oldext);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
-			XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("LF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx, new, XFS_DATA_FORK, "LF");
 		xfs_iext_insert(ifp, idx, 1, new);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
@@ -1665,18 +1600,18 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx,
+		xfs_trace_bmap_pre_update("RF|RC", ip, idx,
 			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx + 1,
+		xfs_trace_bmap_pre_update("RF|RC", ip, idx + 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx,
+		xfs_trace_bmap_post_update("RF|RC", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount, newext);
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx + 1,
+		xfs_trace_bmap_post_update("RF|RC", ip, idx + 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
@@ -1712,12 +1647,11 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is not contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("RF", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
-			XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx + 1, new, XFS_DATA_FORK, "RF");
 		xfs_iext_insert(ifp, idx + 1, 1, new);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
@@ -1756,18 +1690,18 @@ xfs_bmap_add_extent_unwritten_real(
 		 * newext.  Contiguity is impossible here.
 		 * One extent becomes three extents.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("0", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			new->br_startoff - PREV.br_startoff);
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("0", ip, idx, XFS_DATA_FORK);
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
 		r[1].br_blockcount =
 			PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
 		r[1].br_state = oldext;
-		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
-			XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx + 1, &r[0], XFS_DATA_FORK, "0");
+		trace_xfs_bmap_insert(ip, idx + 1, &r[1], XFS_DATA_FORK, "0");
 		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents += 2;
@@ -1935,7 +1869,7 @@ xfs_bmap_add_extent_hole_delay(
 		 */
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
+		xfs_trace_bmap_pre_update("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
 		oldlen = startblockval(left.br_startblock) +
@@ -1944,9 +1878,9 @@ xfs_bmap_add_extent_hole_delay(
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
 			nullstartblock((int)newlen));
-		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
+		xfs_trace_bmap_post_update("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, XFS_DATA_FORK);
+		trace_xfs_bmap_delete(ip, idx, XFS_DATA_FORK, "LC|RC");
 		xfs_iext_remove(ifp, idx, 1);
 		ip->i_df.if_lastex = idx - 1;
 		/* DELTA: Two in-core extents were replaced by one. */
@@ -1961,7 +1895,7 @@ xfs_bmap_add_extent_hole_delay(
 		 * Merge the new allocation with the left neighbor.
 		 */
 		temp = left.br_blockcount + new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1,
+		xfs_trace_bmap_pre_update("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
 		oldlen = startblockval(left.br_startblock) +
@@ -1969,7 +1903,7 @@ xfs_bmap_add_extent_hole_delay(
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
 			nullstartblock((int)newlen));
-		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1,
+		xfs_trace_bmap_post_update("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
 		/* DELTA: One in-core extent grew into a hole. */
@@ -1983,14 +1917,14 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_pre_update("RC", ip, idx, XFS_DATA_FORK);
 		temp = new->br_blockcount + right.br_blockcount;
 		oldlen = startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_allf(ep, new->br_startoff,
 			nullstartblock((int)newlen), temp, right.br_state);
-		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, XFS_DATA_FORK);
+		xfs_trace_bmap_post_update("RC", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		/* DELTA: One in-core extent grew into a hole. */
 		temp2 = temp;
@@ -2004,8 +1938,7 @@ xfs_bmap_add_extent_hole_delay(
 		 * Insert a new entry.
 		 */
 		oldlen = newlen = 0;
-		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_insert(ip, idx, new, XFS_DATA_FORK, "0");
 		xfs_iext_insert(ifp, idx, 1, new);
 		ip->i_df.if_lastex = idx;
 		/* DELTA: A new in-core extent was added in a hole. */
@@ -2130,14 +2063,14 @@ xfs_bmap_add_extent_hole_real(
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
+		xfs_trace_bmap_pre_update("LC|RC", ip, idx - 1,
 			whichfork);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			left.br_blockcount + new->br_blockcount +
 			right.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
+		xfs_trace_bmap_post_update("LC|RC", ip, idx - 1,
 			whichfork);
-		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, whichfork);
+		trace_xfs_bmap_delete(ip, idx, whichfork, "LC|RC");
 		xfs_iext_remove(ifp, idx, 1);
 		ifp->if_lastex = idx - 1;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2179,10 +2112,10 @@ xfs_bmap_add_extent_hole_real(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1, whichfork);
+		xfs_trace_bmap_pre_update("LC", ip, idx - 1, whichfork);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			left.br_blockcount + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1, whichfork);
+		xfs_trace_bmap_post_update("LC", ip, idx - 1, whichfork);
 		ifp->if_lastex = idx - 1;
 		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
@@ -2213,11 +2146,11 @@ xfs_bmap_add_extent_hole_real(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, whichfork);
+		xfs_trace_bmap_pre_update("RC", ip, idx, whichfork);
 		xfs_bmbt_set_allf(ep, new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
-		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, whichfork);
+		xfs_trace_bmap_post_update("RC", ip, idx, whichfork);
 		ifp->if_lastex = idx;
 		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
@@ -2248,7 +2181,7 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL, whichfork);
+		trace_xfs_bmap_insert(ip, idx, new, whichfork, "0");
 		xfs_iext_insert(ifp, idx, 1, new);
 		ifp->if_lastex = idx;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -3196,7 +3129,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
+		trace_xfs_bmap_delete(ip, idx, whichfork, "3");
 		xfs_iext_remove(ifp, idx, 1);
 		ifp->if_lastex = idx;
 		if (delay)
@@ -3217,7 +3150,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("2", ip, idx, whichfork);
+		xfs_trace_bmap_pre_update("2", ip, idx, whichfork);
 		xfs_bmbt_set_startoff(ep, del_endoff);
 		temp = got.br_blockcount - del->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
@@ -3226,13 +3159,13 @@ xfs_bmap_del_extent(
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx,
+			xfs_trace_bmap_post_update("2", ip, idx,
 				whichfork);
 			da_new = temp;
 			break;
 		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
-		XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx, whichfork);
+		xfs_trace_bmap_post_update("2", ip, idx, whichfork);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -3248,19 +3181,19 @@ xfs_bmap_del_extent(
 		 * Deleting the last part of the extent.
 		 */
 		temp = got.br_blockcount - del->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("1", ip, idx, whichfork);
+		xfs_trace_bmap_pre_update("1", ip, idx, whichfork);
 		xfs_bmbt_set_blockcount(ep, temp);
 		ifp->if_lastex = idx;
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx,
+			xfs_trace_bmap_post_update("1", ip, idx,
 				whichfork);
 			da_new = temp;
 			break;
 		}
-		XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx, whichfork);
+		xfs_trace_bmap_post_update("1", ip, idx, whichfork);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -3277,7 +3210,7 @@ xfs_bmap_del_extent(
 		 * Deleting the middle of the extent.
 		 */
 		temp = del->br_startoff - got.br_startoff;
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, whichfork);
+		xfs_trace_bmap_pre_update("0", ip, idx, whichfork);
 		xfs_bmbt_set_blockcount(ep, temp);
 		new.br_startoff = del_endoff;
 		temp2 = got_endoff - del_endoff;
@@ -3364,9 +3297,8 @@ xfs_bmap_del_extent(
 				}
 			}
 		}
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, whichfork);
-		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 1, &new, NULL,
-			whichfork);
+		xfs_trace_bmap_post_update("0", ip, idx, whichfork);
+		trace_xfs_bmap_insert(ip, idx + 1, &new, whichfork, "0");
 		xfs_iext_insert(ifp, idx + 1, 1, &new);
 		ifp->if_lastex = idx + 1;
 		break;
@@ -3687,7 +3619,7 @@ xfs_bmap_local_to_extents(
 		xfs_iext_add(ifp, 0, 1);
 		ep = xfs_iext_get_ext(ifp, 0);
 		xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
-		XFS_BMAP_TRACE_POST_UPDATE("new", ip, 0, whichfork);
+		xfs_trace_bmap_post_update("new", ip, 0, whichfork);
 		XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 		ip->i_d.di_nblocks = 1;
 		xfs_trans_mod_dquot_byino(tp, ip,
@@ -3800,158 +3732,6 @@ xfs_bmap_search_extents(
 	return ep;
 }
 
-
-#ifdef XFS_BMAP_TRACE
-ktrace_t	*xfs_bmap_trace_buf;
-
-/*
- * Add a bmap trace buffer entry.  Base routine for the others.
- */
-STATIC void
-xfs_bmap_trace_addentry(
-	int		opcode,		/* operation */
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(ies) */
-	xfs_extnum_t	cnt,		/* count of entries, 1 or 2 */
-	xfs_bmbt_rec_host_t *r1,	/* first record */
-	xfs_bmbt_rec_host_t *r2,	/* second record or null */
-	int		whichfork)	/* data or attr fork */
-{
-	xfs_bmbt_rec_host_t tr2;
-
-	ASSERT(cnt == 1 || cnt == 2);
-	ASSERT(r1 != NULL);
-	if (cnt == 1) {
-		ASSERT(r2 == NULL);
-		r2 = &tr2;
-		memset(&tr2, 0, sizeof(tr2));
-	} else
-		ASSERT(r2 != NULL);
-	ktrace_enter(xfs_bmap_trace_buf,
-		(void *)(__psint_t)(opcode | (whichfork << 16)),
-		(void *)fname, (void *)desc, (void *)ip,
-		(void *)(__psint_t)idx,
-		(void *)(__psint_t)cnt,
-		(void *)(__psunsigned_t)(ip->i_ino >> 32),
-		(void *)(__psunsigned_t)(unsigned)ip->i_ino,
-		(void *)(__psunsigned_t)(r1->l0 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r1->l0),
-		(void *)(__psunsigned_t)(r1->l1 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r1->l1),
-		(void *)(__psunsigned_t)(r2->l0 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r2->l0),
-		(void *)(__psunsigned_t)(r2->l1 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r2->l1)
-		);
-	ASSERT(ip->i_xtrace);
-	ktrace_enter(ip->i_xtrace,
-		(void *)(__psint_t)(opcode | (whichfork << 16)),
-		(void *)fname, (void *)desc, (void *)ip,
-		(void *)(__psint_t)idx,
-		(void *)(__psint_t)cnt,
-		(void *)(__psunsigned_t)(ip->i_ino >> 32),
-		(void *)(__psunsigned_t)(unsigned)ip->i_ino,
-		(void *)(__psunsigned_t)(r1->l0 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r1->l0),
-		(void *)(__psunsigned_t)(r1->l1 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r1->l1),
-		(void *)(__psunsigned_t)(r2->l0 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r2->l0),
-		(void *)(__psunsigned_t)(r2->l1 >> 32),
-		(void *)(__psunsigned_t)(unsigned)(r2->l1)
-		);
-}
-
-/*
- * Add bmap trace entry prior to a call to xfs_iext_remove.
- */
-STATIC void
-xfs_bmap_trace_delete(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(entries) deleted */
-	xfs_extnum_t	cnt,		/* count of entries deleted, 1 or 2 */
-	int		whichfork)	/* data or attr fork */
-{
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_bmap_trace_addentry(XFS_BMAP_KTRACE_DELETE, fname, desc, ip, idx,
-		cnt, xfs_iext_get_ext(ifp, idx),
-		cnt == 2 ? xfs_iext_get_ext(ifp, idx + 1) : NULL,
-		whichfork);
-}
-
-/*
- * Add bmap trace entry prior to a call to xfs_iext_insert, or
- * reading in the extents list from the disk (in the btree).
- */
-STATIC void
-xfs_bmap_trace_insert(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(entries) inserted */
-	xfs_extnum_t	cnt,		/* count of entries inserted, 1 or 2 */
-	xfs_bmbt_irec_t	*r1,		/* inserted record 1 */
-	xfs_bmbt_irec_t	*r2,		/* inserted record 2 or null */
-	int		whichfork)	/* data or attr fork */
-{
-	xfs_bmbt_rec_host_t tr1;	/* compressed record 1 */
-	xfs_bmbt_rec_host_t tr2;	/* compressed record 2 if needed */
-
-	xfs_bmbt_set_all(&tr1, r1);
-	if (cnt == 2) {
-		ASSERT(r2 != NULL);
-		xfs_bmbt_set_all(&tr2, r2);
-	} else {
-		ASSERT(cnt == 1);
-		ASSERT(r2 == NULL);
-	}
-	xfs_bmap_trace_addentry(XFS_BMAP_KTRACE_INSERT, fname, desc, ip, idx,
-		cnt, &tr1, cnt == 2 ? &tr2 : NULL, whichfork);
-}
-
-/*
- * Add bmap trace entry after updating an extent record in place.
- */
-STATIC void
-xfs_bmap_trace_post_update(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry updated */
-	int		whichfork)	/* data or attr fork */
-{
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_bmap_trace_addentry(XFS_BMAP_KTRACE_POST_UP, fname, desc, ip, idx,
-		1, xfs_iext_get_ext(ifp, idx), NULL, whichfork);
-}
-
-/*
- * Add bmap trace entry prior to updating an extent record in place.
- */
-STATIC void
-xfs_bmap_trace_pre_update(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry to be updated */
-	int		whichfork)	/* data or attr fork */
-{
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_bmap_trace_addentry(XFS_BMAP_KTRACE_PRE_UP, fname, desc, ip, idx, 1,
-		xfs_iext_get_ext(ifp, idx), NULL, whichfork);
-}
-#endif	/* XFS_BMAP_TRACE */
-
 /*
  * Compute the worst-case number of indirect blocks that will be used
  * for ip's delayed extent of length "len".
@@ -3983,37 +3763,6 @@ xfs_bmap_worst_indlen(
 	return rval;
 }
 
-#if defined(XFS_RW_TRACE)
-STATIC void
-xfs_bunmap_trace(
-	xfs_inode_t		*ip,
-	xfs_fileoff_t		bno,
-	xfs_filblks_t		len,
-	int			flags,
-	inst_t			*ra)
-{
-	if (ip->i_rwtrace == NULL)
-		return;
-	ktrace_enter(ip->i_rwtrace,
-		(void *)(__psint_t)XFS_BUNMAP,
-		(void *)ip,
-		(void *)(__psint_t)((ip->i_d.di_size >> 32) & 0xffffffff),
-		(void *)(__psint_t)(ip->i_d.di_size & 0xffffffff),
-		(void *)(__psint_t)(((xfs_dfiloff_t)bno >> 32) & 0xffffffff),
-		(void *)(__psint_t)((xfs_dfiloff_t)bno & 0xffffffff),
-		(void *)(__psint_t)len,
-		(void *)(__psint_t)flags,
-		(void *)(unsigned long)current_cpu(),
-		(void *)ra,
-		(void *)0,
-		(void *)0,
-		(void *)0,
-		(void *)0,
-		(void *)0,
-		(void *)0);
-}
-#endif
-
 /*
  * Convert inode from non-attributed to attributed.
  * Must not be in a transaction, ip must not be locked.
@@ -4702,7 +4451,7 @@ error0:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
-#ifdef XFS_BMAP_TRACE
+#ifdef DEBUG
 /*
  * Add bmap trace insert entries for all the contents of the extent records.
  */
@@ -4723,13 +4472,10 @@ xfs_bmap_trace_exlist(
 	for (idx = 0; idx < cnt; idx++) {
 		ep = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_get_all(ep, &s);
-		XFS_BMAP_TRACE_INSERT("exlist", ip, idx, 1, &s, NULL,
-			whichfork);
+		trace_xfs_bmap_insert(ip, idx, &s, whichfork, "extlist");
 	}
 }
-#endif
 
-#ifdef DEBUG
 /*
  * Validate that the bmbt_irecs being returned from bmapi are valid
  * given the callers original parameters.  Specifically check the
@@ -5478,7 +5224,8 @@ xfs_bunmapi(
 	int			rsvd;		/* OK to allocate reserved blocks */
 	xfs_fsblock_t		sum;
 
-	xfs_bunmap_trace(ip, bno, len, flags, (inst_t *)__return_address);
+	xfs_bunmap_trace(ip, bno, len, flags);
+
 	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 		XFS_ATTR_FORK : XFS_DATA_FORK;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2009-09-09 12:33:56.511254188 -0300
+++ xfs/fs/xfs/xfs_bmap.h	2009-09-09 12:49:11.273258673 -0300
@@ -95,6 +95,21 @@ typedef	struct xfs_bmap_free
 					/* need write cache flushing and no */
 					/* additional allocation alignments */
 
+#define XFS_BMAPI_FLAGS \
+	{ XFS_BMAPI_WRITE,	"WRITE" }, \
+	{ XFS_BMAPI_DELAY,	"DELAY" }, \
+	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
+	{ XFS_BMAPI_METADATA,	"METADATA" }, \
+	{ XFS_BMAPI_EXACT,	"EXACT" }, \
+	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
+	{ XFS_BMAPI_ASYNC,	"ASYNC" }, \
+	{ XFS_BMAPI_RSVBLOCKS,	"RSVBLOCKS" }, \
+	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
+	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
+	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+
+
 static inline int xfs_bmapi_aflag(int w)
 {
 	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
@@ -135,7 +150,6 @@ typedef struct xfs_bmalloca {
 	char			conv;	/* overwriting unwritten extents */
 } xfs_bmalloca_t;
 
-#if defined(__KERNEL__) && defined(XFS_BMAP_TRACE)
 /*
  * Trace operations for bmap extent tracing
  */
@@ -144,13 +158,18 @@ typedef struct xfs_bmalloca {
 #define	XFS_BMAP_KTRACE_PRE_UP	3
 #define	XFS_BMAP_KTRACE_POST_UP	4
 
-#define	XFS_BMAP_TRACE_SIZE	4096	/* size of global trace buffer */
-#define	XFS_BMAP_KTRACE_SIZE	32	/* size of per-inode trace buffer */
-extern ktrace_t	*xfs_bmap_trace_buf;
+#define XFS_BMAP_KTRACE_TYPES \
+	{ XFS_BMAP_KTRACE_DELETE,	"delete" }, \
+	{ XFS_BMAP_KTRACE_INSERT,	"insert" }, \
+	{ XFS_BMAP_KTRACE_PRE_UP,	"pre" }, \
+	{ XFS_BMAP_KTRACE_POST_UP,	"post"}
 
 /*
  * Add bmap trace insert entries for all the contents of the extent list.
+ *
+ * Quite excessive tracing.  Only do this for debug builds.
  */
+#if defined(__KERNEL) && defined(DEBUG)
 void
 xfs_bmap_trace_exlist(
 	const char		*fname,		/* function name */
@@ -159,12 +178,9 @@ xfs_bmap_trace_exlist(
 	int			whichfork);	/* data or attr fork */
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
 	xfs_bmap_trace_exlist(__func__,ip,c,w)
-
-#else	/* __KERNEL__ && XFS_BMAP_TRACE */
-
+#else
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
-
-#endif	/* __KERNEL__ && XFS_BMAP_TRACE */
+#endif
 
 /*
  * Convert inode from non-attributed to attributed.
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2009-09-09 12:33:56.517253905 -0300
+++ xfs/fs/xfs/xfs_bmap_btree.c	2009-09-09 12:49:11.276301588 -0300
@@ -769,12 +769,6 @@ xfs_bmbt_trace_enter(
 		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
 		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
 		(void *)a8, (void *)a9, (void *)a10);
-	ktrace_enter(ip->i_btrace,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
 }
 
 STATIC void
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2009-09-09 12:33:56.521253297 -0300
+++ xfs/fs/xfs/xfs_btree.c	2009-09-09 12:49:11.280024619 -0300
@@ -39,6 +39,7 @@
 #include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * Cursor allocation zone.
@@ -81,7 +82,7 @@ xfs_btree_check_lblock(
 			XFS_ERRTAG_BTREE_CHECK_LBLOCK,
 			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
 		if (bp)
-			xfs_buftrace("LBTREE ERROR", bp);
+			xfs_buftrace(bp, "lbtree_error");
 		XFS_ERROR_REPORT("xfs_btree_check_lblock", XFS_ERRLEVEL_LOW,
 				 mp);
 		return XFS_ERROR(EFSCORRUPTED);
@@ -119,7 +120,7 @@ xfs_btree_check_sblock(
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK,
 			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
 		if (bp)
-			xfs_buftrace("SBTREE ERROR", bp);
+			xfs_buftrace(bp, "sbtree_error");
 		XFS_CORRUPTION_ERROR("xfs_btree_check_sblock",
 			XFS_ERRLEVEL_LOW, cur->bc_mp, block);
 		return XFS_ERROR(EFSCORRUPTED);
Index: xfs/fs/xfs/xfs_btree_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_btree_trace.h	2009-09-09 12:33:56.526253655 -0300
+++ xfs/fs/xfs/xfs_btree_trace.h	2009-09-09 12:49:11.282255978 -0300
@@ -58,8 +58,6 @@ void xfs_btree_trace_argbi(const char *,
 		struct xfs_buf *, int, int);
 void xfs_btree_trace_argbii(const char *, struct xfs_btree_cur *,
 		struct xfs_buf *, int, int, int);
-void xfs_btree_trace_argfffi(const char *, struct xfs_btree_cur *,
-		xfs_dfiloff_t, xfs_dfsbno_t, xfs_dfilblks_t, int, int);
 void xfs_btree_trace_argi(const char *, struct xfs_btree_cur *, int, int);
 void xfs_btree_trace_argipk(const char *, struct xfs_btree_cur *, int,
 		union xfs_btree_ptr, union xfs_btree_key *, int);
@@ -71,24 +69,10 @@ void xfs_btree_trace_argr(const char *, 
 		union xfs_btree_rec *, int);
 void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
 
-
-#define XFS_ALLOCBT_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_allocbt_trace_buf;
-
-#define XFS_INOBT_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_inobt_trace_buf;
-
-#define XFS_BMBT_TRACE_SIZE	4096	/* size of global trace buffer */
-#define XFS_BMBT_KTRACE_SIZE	32	/* size of per-inode trace buffer */
-extern ktrace_t	*xfs_bmbt_trace_buf;
-
-
 #define	XFS_BTREE_TRACE_ARGBI(c, b, i)	\
 	xfs_btree_trace_argbi(__func__, c, b, i, __LINE__)
 #define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)	\
 	xfs_btree_trace_argbii(__func__, c, b, i, j, __LINE__)
-#define	XFS_BTREE_TRACE_ARGFFFI(c, o, b, i, j)	\
-	xfs_btree_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
 #define	XFS_BTREE_TRACE_ARGI(c, i)	\
 	xfs_btree_trace_argi(__func__, c, i, __LINE__)
 #define	XFS_BTREE_TRACE_ARGIPK(c, i, p, k)	\
@@ -104,7 +88,6 @@ extern ktrace_t	*xfs_bmbt_trace_buf;
 #else
 #define	XFS_BTREE_TRACE_ARGBI(c, b, i)
 #define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
-#define	XFS_BTREE_TRACE_ARGFFFI(c, o, b, i, j)
 #define	XFS_BTREE_TRACE_ARGI(c, i)
 #define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
 #define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2009-09-09 12:33:56.530253885 -0300
+++ xfs/fs/xfs/xfs_buf_item.c	2009-09-09 12:49:11.286255859 -0300
@@ -29,6 +29,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
@@ -356,7 +357,6 @@ xfs_buf_item_pin(
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_trace("PIN", bip);
-	xfs_buftrace("XFS_PIN", bp);
 	xfs_bpin(bp);
 }
 
@@ -384,7 +384,6 @@ xfs_buf_item_unpin(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *) == bip);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	xfs_buf_item_trace("UNPIN", bip);
-	xfs_buftrace("XFS_UNPIN", bp);
 
 	freed = atomic_dec_and_test(&bip->bli_refcount);
 	ailp = bip->bli_item.li_ailp;
@@ -396,7 +395,7 @@ xfs_buf_item_unpin(
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
 		xfs_buf_item_trace("UNPIN STALE", bip);
-		xfs_buftrace("XFS_UNPIN STALE", bp);
+		xfs_buftrace(bp, "item_unpin_stale");
 		/*
 		 * If we get called here because of an IO error, we may
 		 * or may not have the item on the AIL. xfs_trans_ail_delete()
@@ -441,7 +440,7 @@ xfs_buf_item_unpin_remove(
 	    (bip->bli_flags & XFS_BLI_STALE)) {
 		ASSERT(XFS_BUF_VALUSEMA(bip->bli_buf) <= 0);
 		xfs_buf_item_trace("UNPIN REMOVE", bip);
-		xfs_buftrace("XFS_UNPIN_REMOVE", bp);
+		xfs_buftrace(bp, "item_unpin_remove");
 		/*
 		 * yes -- clear the xaction descriptor in-use flag
 		 * and free the chunk if required.  We can safely
@@ -524,7 +523,7 @@ xfs_buf_item_unlock(
 	uint		hold;
 
 	bp = bip->bli_buf;
-	xfs_buftrace("XFS_UNLOCK", bp);
+	xfs_buftrace(bp, "item_unlock");
 
 	/*
 	 * Clear the buffer's association with this transaction.
@@ -738,9 +737,6 @@ xfs_buf_item_init(
 	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
 	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
 	bip->bli_format.blf_map_size = map_size;
-#ifdef XFS_BLI_TRACE
-	bip->bli_trace = ktrace_alloc(XFS_BLI_TRACE_SIZE, KM_NOFS);
-#endif
 
 #ifdef XFS_TRANS_DEBUG
 	/*
@@ -878,9 +874,6 @@ xfs_buf_item_free(
 	kmem_free(bip->bli_logged);
 #endif /* XFS_TRANS_DEBUG */
 
-#ifdef XFS_BLI_TRACE
-	ktrace_free(bip->bli_trace);
-#endif
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
@@ -897,7 +890,7 @@ xfs_buf_item_relse(
 {
 	xfs_buf_log_item_t	*bip;
 
-	xfs_buftrace("XFS_RELSE", bp);
+	xfs_buftrace(bp, "item_relse");
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
 	XFS_BUF_SET_FSPRIVATE(bp, bip->bli_item.li_bio_list);
 	if ((XFS_BUF_FSPRIVATE(bp, void *) == NULL) &&
@@ -994,7 +987,7 @@ xfs_buf_iodone_callbacks(
 		if (XFS_FORCED_SHUTDOWN(mp)) {
 			ASSERT(XFS_BUF_TARGET(bp) == mp->m_ddev_targp);
 			XFS_BUF_SUPER_STALE(bp);
-			xfs_buftrace("BUF_IODONE_CB", bp);
+			xfs_buftrace(bp, "item_iodone");
 			xfs_buf_do_callbacks(bp, lip);
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
@@ -1030,7 +1023,7 @@ xfs_buf_iodone_callbacks(
 				XFS_BUF_SET_START(bp);
 			}
 			ASSERT(XFS_BUF_IODONE_FUNC(bp));
-			xfs_buftrace("BUF_IODONE ASYNC", bp);
+			xfs_buftrace(bp, "item_iodone_async");
 			xfs_buf_relse(bp);
 		} else {
 			/*
@@ -1054,7 +1047,7 @@ xfs_buf_iodone_callbacks(
 		return;
 	}
 #ifdef XFSERRORDEBUG
-	xfs_buftrace("XFS BUFCB NOERR", bp);
+	xfs_buftrace(bp, "item_iodone_noerror");
 #endif
 	xfs_buf_do_callbacks(bp, lip);
 	XFS_BUF_SET_FSPRIVATE(bp, NULL);
@@ -1081,7 +1074,7 @@ xfs_buf_error_relse(
 	XFS_BUF_DONE(bp);
 	XFS_BUF_UNDELAYWRITE(bp);
 	XFS_BUF_ERROR(bp,0);
-	xfs_buftrace("BUF_ERROR_RELSE", bp);
+	xfs_buftrace(bp, "item_error_relse");
 	if (! XFS_FORCED_SHUTDOWN(mp))
 		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 	/*
@@ -1128,34 +1121,3 @@ xfs_buf_iodone(
 	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
 	xfs_buf_item_free(bip);
 }
-
-#if defined(XFS_BLI_TRACE)
-void
-xfs_buf_item_trace(
-	char			*id,
-	xfs_buf_log_item_t	*bip)
-{
-	xfs_buf_t		*bp;
-	ASSERT(bip->bli_trace != NULL);
-
-	bp = bip->bli_buf;
-	ktrace_enter(bip->bli_trace,
-		     (void *)id,
-		     (void *)bip->bli_buf,
-		     (void *)((unsigned long)bip->bli_flags),
-		     (void *)((unsigned long)bip->bli_recur),
-		     (void *)((unsigned long)atomic_read(&bip->bli_refcount)),
-		     (void *)((unsigned long)
-				(0xFFFFFFFF & XFS_BUF_ADDR(bp) >> 32)),
-		     (void *)((unsigned long)(0xFFFFFFFF & XFS_BUF_ADDR(bp))),
-		     (void *)((unsigned long)XFS_BUF_COUNT(bp)),
-		     (void *)((unsigned long)XFS_BUF_BFLAGS(bp)),
-		     XFS_BUF_FSPRIVATE(bp, void *),
-		     XFS_BUF_FSPRIVATE2(bp, void *),
-		     (void *)(unsigned long)XFS_BUF_ISPINNED(bp),
-		     (void *)XFS_BUF_IODONE_FUNC(bp),
-		     (void *)((unsigned long)(XFS_BUF_VALUSEMA(bp))),
-		     (void *)bip->bli_item.li_desc,
-		     (void *)((unsigned long)bip->bli_item.li_flags));
-}
-#endif /* XFS_BLI_TRACE */
Index: xfs/fs/xfs/xfs_buf_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.h	2009-09-09 12:33:56.536253951 -0300
+++ xfs/fs/xfs/xfs_buf_item.h	2009-09-09 12:49:11.289256382 -0300
@@ -70,22 +70,21 @@ typedef struct xfs_buf_log_format_t {
 #define	XFS_BLI_INODE_ALLOC_BUF	0x10
 #define XFS_BLI_STALE_INODE	0x20
 
+#define XFS_BLI_FLAGS \
+	{ XFS_BLI_HOLD,		"HOLD" }, \
+	{ XFS_BLI_DIRTY,	"DIRTY" }, \
+	{ XFS_BLI_STALE,	"STALE" }, \
+	{ XFS_BLI_LOGGED,	"LOGGED" }, \
+	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
+	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }
+
 
 #ifdef __KERNEL__
 
 struct xfs_buf;
-struct ktrace;
 struct xfs_mount;
 struct xfs_buf_log_item;
 
-#if defined(XFS_BLI_TRACE)
-#define	XFS_BLI_TRACE_SIZE	32
-
-void	xfs_buf_item_trace(char *, struct xfs_buf_log_item *);
-#else
-#define	xfs_buf_item_trace(id, bip)
-#endif
-
 /*
  * This is the in core log item structure used to track information
  * needed to log buffers.  It tracks how many times the lock has been
@@ -97,9 +96,6 @@ typedef struct xfs_buf_log_item {
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
 	atomic_t		bli_refcount;	/* cnt of tp refs */
-#ifdef XFS_BLI_TRACE
-	struct ktrace		*bli_trace;	/* event trace buf */
-#endif
 #ifdef XFS_TRANS_DEBUG
 	char			*bli_orig;	/* original buffer copy */
 	char			*bli_logged;	/* bytes logged (bitmap) */
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2009-09-09 12:33:56.540253762 -0300
+++ xfs/fs/xfs/xfs_da_btree.c	2009-09-09 12:49:11.292256344 -0300
@@ -46,6 +46,7 @@
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_node.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * xfs_da_btree.c
@@ -2107,7 +2108,7 @@ xfs_da_do_buf(
 				   (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC),
 				mp, XFS_ERRTAG_DA_READ_BUF,
 				XFS_RANDOM_DA_READ_BUF))) {
-			xfs_buftrace("DA READ ERROR", rbp->bps[0]);
+			xfs_buftrace(rbp->bps[0], "da_read_error");
 			XFS_CORRUPTION_ERROR("xfs_da_do_buf(2)",
 					     XFS_ERRLEVEL_LOW, mp, info);
 			error = XFS_ERROR(EFSCORRUPTED);
Index: xfs/fs/xfs/xfs_da_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.h	2009-09-09 12:33:56.545254119 -0300
+++ xfs/fs/xfs/xfs_da_btree.h	2009-09-09 12:49:11.295259171 -0300
@@ -125,6 +125,13 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 
+#define XFS_DA_OP_FLAGS \
+	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
+	{ XFS_DA_OP_RENAME,	"RENAME" }, \
+	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
+	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
+	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }
+
 /*
  * Structure to describe buffer(s) for a block.
  * This is needed in the directory version 2 format case, when
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2009-09-09 12:33:56.549254209 -0300
+++ xfs/fs/xfs/xfs_dfrag.c	2009-09-09 12:49:11.299255979 -0300
@@ -43,6 +43,7 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 /*
  * Syssgi interface for swapext
@@ -168,7 +169,6 @@ xfs_swap_extents(
 	}
 
 	if (VN_CACHED(VFS_I(tip)) != 0) {
-		xfs_inval_cached_trace(tip, 0, -1, 0, -1);
 		error = xfs_flushinval_pages(tip, 0, -1,
 				FI_REMAPF_LOCKED);
 		if (error)
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2009-09-09 12:33:56.554254358 -0300
+++ xfs/fs/xfs/xfs_dir2.c	2009-09-09 12:49:11.301256095 -0300
@@ -40,9 +40,9 @@
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_node.h"
-#include "xfs_dir2_trace.h"
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 struct xfs_name xfs_name_dotdot = {"..", 2};
 
@@ -525,7 +525,8 @@ xfs_dir2_grow_inode(
 	xfs_trans_t	*tp;
 	xfs_drfsbno_t	nblks;
 
-	xfs_dir2_trace_args_s("grow_inode", args, space);
+	trace_xfs_dir2_grow_inode(args, space);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -703,7 +704,8 @@ xfs_dir2_shrink_inode(
 	xfs_mount_t	*mp;
 	xfs_trans_t	*tp;
 
-	xfs_dir2_trace_args_db("shrink_inode", args, db, bp);
+	trace_xfs_dir2_shrink_inode(args, db);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2009-09-09 12:33:56.559253457 -0300
+++ xfs/fs/xfs/xfs_dir2_block.c	2009-09-09 12:49:11.305256255 -0300
@@ -36,8 +36,8 @@
 #include "xfs_dir2_data.h"
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
-#include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * Local function prototypes.
@@ -94,7 +94,8 @@ xfs_dir2_block_addname(
 	__be16			*tagp;		/* pointer to tag value */
 	xfs_trans_t		*tp;		/* transaction structure */
 
-	xfs_dir2_trace_args("block_addname", args);
+	trace_xfs_dir2_block_addname(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -590,7 +591,8 @@ xfs_dir2_block_lookup(
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
-	xfs_dir2_trace_args("block_lookup", args);
+	trace_xfs_dir2_block_lookup(args);
+
 	/*
 	 * Get the buffer, look up the entry.
 	 * If not found (ENOENT) then return, have no buffer.
@@ -747,7 +749,8 @@ xfs_dir2_block_removename(
 	int			size;		/* shortform size */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("block_removename", args);
+	trace_xfs_dir2_block_removename(args);
+
 	/*
 	 * Look up the entry in the block.  Gets the buffer and entry index.
 	 * It will always be there, the vnodeops level does a lookup first.
@@ -823,7 +826,8 @@ xfs_dir2_block_replace(
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
-	xfs_dir2_trace_args("block_replace", args);
+	trace_xfs_dir2_block_replace(args);
+
 	/*
 	 * Lookup the entry in the directory.  Get buffer and entry index.
 	 * This will always succeed since the caller has already done a lookup.
@@ -897,7 +901,8 @@ xfs_dir2_leaf_to_block(
 	int			to;		/* block/leaf to index */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_bb("leaf_to_block", args, lbp, dbp);
+	trace_xfs_dir2_leaf_to_block(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1044,7 +1049,8 @@ xfs_dir2_sf_to_block(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_name		name;
 
-	xfs_dir2_trace_args("sf_to_block", args);
+	trace_xfs_dir2_sf_to_block(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2009-09-09 12:33:56.563254456 -0300
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2009-09-09 12:49:11.309266682 -0300
@@ -38,8 +38,8 @@
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_node.h"
-#include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * Local function declarations.
@@ -80,7 +80,8 @@ xfs_dir2_block_to_leaf(
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_b("block_to_leaf", args, dbp);
+	trace_xfs_dir2_block_to_leaf(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -188,7 +189,8 @@ xfs_dir2_leaf_addname(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		use_block;	/* data block number */
 
-	xfs_dir2_trace_args("leaf_addname", args);
+	trace_xfs_dir2_leaf_addname(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1264,7 +1266,8 @@ xfs_dir2_leaf_lookup(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_lookup", args);
+	trace_xfs_dir2_leaf_lookup(args);
+
 	/*
 	 * Look up name in the leaf block, returning both buffers and index.
 	 */
@@ -1452,7 +1455,8 @@ xfs_dir2_leaf_removename(
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_removename", args);
+	trace_xfs_dir2_leaf_removename(args);
+
 	/*
 	 * Lookup the leaf entry, get the leaf and data blocks read in.
 	 */
@@ -1584,7 +1588,8 @@ xfs_dir2_leaf_replace(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_replace", args);
+	trace_xfs_dir2_leaf_replace(args);
+
 	/*
 	 * Look up the entry.
 	 */
@@ -1764,7 +1769,9 @@ xfs_dir2_node_to_leaf(
 	if (state->path.active > 1)
 		return 0;
 	args = state->args;
-	xfs_dir2_trace_args("node_to_leaf", args);
+
+	trace_xfs_dir2_node_to_leaf(args);
+
 	mp = state->mp;
 	dp = args->dp;
 	tp = args->trans;
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2009-09-09 12:33:56.568252927 -0300
+++ xfs/fs/xfs/xfs_dir2_node.c	2009-09-09 12:49:11.312322867 -0300
@@ -37,8 +37,8 @@
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_node.h"
-#include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * Function declarations.
@@ -123,7 +123,8 @@ xfs_dir2_leaf_to_node(
 	__be16			*to;		/* pointer to freespace entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_b("leaf_to_node", args, lbp);
+	trace_xfs_dir2_leaf_to_node(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -196,7 +197,8 @@ xfs_dir2_leafn_add(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_sb("leafn_add", args, index, bp);
+	trace_xfs_dir2_leafn_add(args, index);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -711,8 +713,8 @@ xfs_dir2_leafn_moveents(
 	int		stale;			/* count stale leaves copied */
 	xfs_trans_t	*tp;			/* transaction pointer */
 
-	xfs_dir2_trace_args_bibii("leafn_moveents", args, bp_s, start_s, bp_d,
-		start_d, count);
+	trace_xfs_dir2_leafn_moveents(args, start_s, start_d, count);
+
 	/*
 	 * Silently return if nothing to do.
 	 */
@@ -933,7 +935,8 @@ xfs_dir2_leafn_remove(
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_sb("leafn_remove", args, index, bp);
+	trace_xfs_dir2_leafn_remove(args, index);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1363,7 +1366,8 @@ xfs_dir2_node_addname(
 	int			rval;		/* sub-return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_addname", args);
+	trace_xfs_dir2_node_addname(args);
+
 	/*
 	 * Allocate and initialize the state (btree cursor).
 	 */
@@ -1822,7 +1826,8 @@ xfs_dir2_node_lookup(
 	int		rval;			/* operation return value */
 	xfs_da_state_t	*state;			/* btree cursor */
 
-	xfs_dir2_trace_args("node_lookup", args);
+	trace_xfs_dir2_node_lookup(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
@@ -1875,7 +1880,8 @@ xfs_dir2_node_removename(
 	int			rval;		/* operation return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_removename", args);
+	trace_xfs_dir2_node_removename(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
@@ -1944,7 +1950,8 @@ xfs_dir2_node_replace(
 	int			rval;		/* internal return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_replace", args);
+	trace_xfs_dir2_node_replace(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2009-09-09 12:33:56.572253716 -0300
+++ xfs/fs/xfs/xfs_dir2_sf.c	2009-09-09 12:49:11.317273917 -0300
@@ -37,7 +37,7 @@
 #include "xfs_dir2_data.h"
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
-#include "xfs_dir2_trace.h"
+#include "xfs_trace.h"
 
 /*
  * Prototypes for internal functions.
@@ -169,7 +169,8 @@ xfs_dir2_block_to_sf(
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	xfs_ino_t               temp;
 
-	xfs_dir2_trace_args_sb("block_to_sf", args, size, bp);
+	trace_xfs_dir2_block_to_sf(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 
@@ -281,7 +282,8 @@ xfs_dir2_sf_addname(
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
 
-	xfs_dir2_trace_args("sf_addname", args);
+	trace_xfs_dir2_sf_addname(args);
+
 	ASSERT(xfs_dir2_sf_lookup(args) == ENOENT);
 	dp = args->dp;
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -654,7 +656,8 @@ xfs_dir2_sf_create(
 	xfs_dir2_sf_t	*sfp;		/* shortform structure */
 	int		size;		/* directory size */
 
-	xfs_dir2_trace_args_i("sf_create", args, pino);
+	trace_xfs_dir2_sf_create(args);
+
 	dp = args->dp;
 
 	ASSERT(dp != NULL);
@@ -808,7 +811,8 @@ xfs_dir2_sf_lookup(
 	enum xfs_dacmp		cmp;		/* comparison result */
 	xfs_dir2_sf_entry_t	*ci_sfep;	/* case-insens. entry */
 
-	xfs_dir2_trace_args("sf_lookup", args);
+	trace_xfs_dir2_sf_lookup(args);
+
 	xfs_dir2_sf_check(args);
 	dp = args->dp;
 
@@ -891,7 +895,8 @@ xfs_dir2_sf_removename(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 
-	xfs_dir2_trace_args("sf_removename", args);
+	trace_xfs_dir2_sf_removename(args);
+
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -982,7 +987,8 @@ xfs_dir2_sf_replace(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 
-	xfs_dir2_trace_args("sf_replace", args);
+	trace_xfs_dir2_sf_replace(args);
+
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -1125,7 +1131,8 @@ xfs_dir2_sf_toino4(
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_t		*sfp;		/* new sf directory */
 
-	xfs_dir2_trace_args("sf_toino4", args);
+	trace_xfs_dir2_sf_toino4(args);
+
 	dp = args->dp;
 
 	/*
@@ -1202,7 +1209,8 @@ xfs_dir2_sf_toino8(
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_t		*sfp;		/* new sf directory */
 
-	xfs_dir2_trace_args("sf_toino8", args);
+	trace_xfs_dir2_sf_toino8(args);
+
 	dp = args->dp;
 
 	/*
Index: xfs/fs/xfs/xfs_dir2_trace.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_trace.c	2009-09-09 12:33:56.576255343 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,216 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_inum.h"
-#include "xfs_dir2.h"
-#include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_dir2_trace.h"
-
-#ifdef XFS_DIR2_TRACE
-ktrace_t	*xfs_dir2_trace_buf;
-
-/*
- * Enter something in the trace buffers.
- */
-static void
-xfs_dir2_trace_enter(
-	xfs_inode_t	*dp,
-	int		type,
-	char		*where,
-	char		*name,
-	int		namelen,
-	void		*a0,
-	void		*a1,
-	void		*a2,
-	void		*a3,
-	void		*a4,
-	void		*a5,
-	void		*a6,
-	void		*a7)
-{
-	void		*n[5];
-
-	ASSERT(xfs_dir2_trace_buf);
-	ASSERT(dp->i_dir_trace);
-	if (name)
-		memcpy(n, name, min((int)sizeof(n), namelen));
-	else
-		memset((char *)n, 0, sizeof(n));
-	ktrace_enter(xfs_dir2_trace_buf,
-		(void *)(long)type, (void *)where,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)(long)namelen,
-		(void *)n[0], (void *)n[1], (void *)n[2],
-		(void *)n[3], (void *)n[4]);
-	ktrace_enter(dp->i_dir_trace,
-		(void *)(long)type, (void *)where,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)(long)namelen,
-		(void *)n[0], (void *)n[1], (void *)n[2],
-		(void *)n[3], (void *)n[4]);
-}
-
-void
-xfs_dir2_trace_args(
-	char		*where,
-	xfs_da_args_t	*args)
-{
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		NULL, NULL);
-}
-
-void
-xfs_dir2_trace_args_b(
-	char		*where,
-	xfs_da_args_t	*args,
-	xfs_dabuf_t	*bp)
-{
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_B, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		(void *)(bp ? bp->bps[0] : NULL), NULL);
-}
-
-void
-xfs_dir2_trace_args_bb(
-	char		*where,
-	xfs_da_args_t	*args,
-	xfs_dabuf_t	*lbp,
-	xfs_dabuf_t	*dbp)
-{
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_BB, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		(void *)(lbp ? lbp->bps[0] : NULL),
-		(void *)(dbp ? dbp->bps[0] : NULL));
-}
-
-void
-xfs_dir2_trace_args_bibii(
-	char		*where,
-	xfs_da_args_t	*args,
-	xfs_dabuf_t	*bs,
-	int		ss,
-	xfs_dabuf_t	*bd,
-	int		sd,
-	int		c)
-{
-	xfs_buf_t	*bpbs = bs ? bs->bps[0] : NULL;
-	xfs_buf_t	*bpbd = bd ? bd->bps[0] : NULL;
-
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_BIBII, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)args->dp, (void *)args->trans,
-		(void *)bpbs, (void *)(long)ss, (void *)bpbd, (void *)(long)sd,
-		(void *)(long)c, NULL);
-}
-
-void
-xfs_dir2_trace_args_db(
-	char		*where,
-	xfs_da_args_t	*args,
-	xfs_dir2_db_t	db,
-	xfs_dabuf_t	*bp)
-{
-	xfs_buf_t	*dbp = bp ? bp->bps[0] : NULL;
-
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_DB, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		(void *)(long)db, (void *)dbp);
-}
-
-void
-xfs_dir2_trace_args_i(
-	char		*where,
-	xfs_da_args_t	*args,
-	xfs_ino_t	i)
-{
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_I, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		(void *)((unsigned long)(i >> 32)),
-		(void *)((unsigned long)(i & 0xFFFFFFFF)));
-}
-
-void
-xfs_dir2_trace_args_s(
-	char		*where,
-	xfs_da_args_t	*args,
-	int		s)
-{
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_S, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		(void *)(long)s, NULL);
-}
-
-void
-xfs_dir2_trace_args_sb(
-	char		*where,
-	xfs_da_args_t	*args,
-	int		s,
-	xfs_dabuf_t	*bp)
-{
-	xfs_buf_t	*dbp = bp ? bp->bps[0] : NULL;
-
-	xfs_dir2_trace_enter(args->dp, XFS_DIR2_KTRACE_ARGS_SB, where,
-		(char *)args->name, (int)args->namelen,
-		(void *)(unsigned long)args->hashval,
-		(void *)((unsigned long)(args->inumber >> 32)),
-		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
-		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
-		(void *)(long)s, (void *)dbp);
-}
-#endif	/* XFS_DIR2_TRACE */
Index: xfs/fs/xfs/xfs_dir2_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_trace.h	2009-09-09 12:33:56.581253955 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,72 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DIR2_TRACE_H__
-#define __XFS_DIR2_TRACE_H__
-
-/*
- * Tracing for xfs v2 directories.
- */
-
-#if defined(XFS_DIR2_TRACE)
-
-struct ktrace;
-struct xfs_dabuf;
-struct xfs_da_args;
-
-#define	XFS_DIR2_GTRACE_SIZE		4096	/* global buffer */
-#define	XFS_DIR2_KTRACE_SIZE		32	/* per-inode buffer */
-extern struct ktrace *xfs_dir2_trace_buf;
-
-#define	XFS_DIR2_KTRACE_ARGS		1	/* args only */
-#define	XFS_DIR2_KTRACE_ARGS_B		2	/* args + buffer */
-#define	XFS_DIR2_KTRACE_ARGS_BB		3	/* args + 2 buffers */
-#define	XFS_DIR2_KTRACE_ARGS_DB		4	/* args, db, buffer */
-#define	XFS_DIR2_KTRACE_ARGS_I		5	/* args, inum */
-#define	XFS_DIR2_KTRACE_ARGS_S		6	/* args, int */
-#define	XFS_DIR2_KTRACE_ARGS_SB		7	/* args, int, buffer */
-#define	XFS_DIR2_KTRACE_ARGS_BIBII	8	/* args, buf/int/buf/int/int */
-
-void xfs_dir2_trace_args(char *where, struct xfs_da_args *args);
-void xfs_dir2_trace_args_b(char *where, struct xfs_da_args *args,
-			   struct xfs_dabuf *bp);
-void xfs_dir2_trace_args_bb(char *where, struct xfs_da_args *args,
-			    struct xfs_dabuf *lbp, struct xfs_dabuf *dbp);
-void xfs_dir2_trace_args_bibii(char *where, struct xfs_da_args *args,
-			       struct xfs_dabuf *bs, int ss,
-			       struct xfs_dabuf *bd, int sd, int c);
-void xfs_dir2_trace_args_db(char *where, struct xfs_da_args *args,
-			    xfs_dir2_db_t db, struct xfs_dabuf *bp);
-void xfs_dir2_trace_args_i(char *where, struct xfs_da_args *args, xfs_ino_t i);
-void xfs_dir2_trace_args_s(char *where, struct xfs_da_args *args, int s);
-void xfs_dir2_trace_args_sb(char *where, struct xfs_da_args *args, int s,
-			    struct xfs_dabuf *bp);
-
-#else	/* XFS_DIR2_TRACE */
-
-#define	xfs_dir2_trace_args(where, args)
-#define	xfs_dir2_trace_args_b(where, args, bp)
-#define	xfs_dir2_trace_args_bb(where, args, lbp, dbp)
-#define	xfs_dir2_trace_args_bibii(where, args, bs, ss, bd, sd, c)
-#define	xfs_dir2_trace_args_db(where, args, db, bp)
-#define	xfs_dir2_trace_args_i(where, args, i)
-#define	xfs_dir2_trace_args_s(where, args, s)
-#define	xfs_dir2_trace_args_sb(where, args, s, bp)
-
-#endif	/* XFS_DIR2_TRACE */
-
-#endif	/* __XFS_DIR2_TRACE_H__ */
Index: xfs/fs/xfs/xfs_error.c
===================================================================
--- xfs.orig/fs/xfs/xfs_error.c	2009-09-09 12:33:56.585252928 -0300
+++ xfs/fs/xfs/xfs_error.c	2009-09-09 12:49:11.322256465 -0300
@@ -217,3 +217,19 @@ xfs_corruption_error(
 		xfs_hex_dump(p, 16);
 	xfs_error_report(tag, level, mp, fname, linenum, ra);
 }
+
+/*
+ * Format fsblock number into a static buffer & return it.
+ */
+char *xfs_fmtfsblock(xfs_fsblock_t bno)
+{
+	static char rval[50];
+
+	if (bno == NULLFSBLOCK)
+		sprintf(rval, "NULLFSBLOCK");
+	else if (isnullstartblock(bno))
+		sprintf(rval, "NULLSTARTBLOCK(%lld)", startblockval(bno));
+	else
+		sprintf(rval, "%lld", (xfs_dfsbno_t)bno);
+	return rval;
+}
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2009-09-09 12:33:56.590253355 -0300
+++ xfs/fs/xfs/xfs_filestream.c	2009-09-09 12:49:11.324256161 -0300
@@ -34,6 +34,7 @@
 #include "xfs_utils.h"
 #include "xfs_mru_cache.h"
 #include "xfs_filestream.h"
+#include "xfs_trace.h"
 
 #ifdef XFS_FILESTREAMS_TRACE
 
@@ -394,9 +395,7 @@ xfs_filestream_init(void)
 	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
 	if (!item_zone)
 		return -ENOMEM;
-#ifdef XFS_FILESTREAMS_TRACE
-	xfs_filestreams_trace_buf = ktrace_alloc(XFS_FSTRM_KTRACE_SIZE, KM_NOFS);
-#endif
+
 	return 0;
 }
 
@@ -407,9 +406,6 @@ xfs_filestream_init(void)
 void
 xfs_filestream_uninit(void)
 {
-#ifdef XFS_FILESTREAMS_TRACE
-	ktrace_free(xfs_filestreams_trace_buf);
-#endif
 	kmem_zone_destroy(item_zone);
 }
 
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-09-09 12:33:56.594254004 -0300
+++ xfs/fs/xfs/xfs_fsops.c	2009-09-09 12:49:11.325256568 -0300
@@ -45,6 +45,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rw.h"
 #include "xfs_filestream.h"
+#include "xfs_trace.h"
 
 /*
  * File system operations
@@ -344,6 +345,8 @@ xfs_growfs_data_private(
 		be32_add_cpu(&agf->agf_length, new);
 		ASSERT(be32_to_cpu(agf->agf_length) ==
 		       be32_to_cpu(agi->agi_length));
+
+		xfs_trace_agf(mp, agf, XFS_AGF_LENGTH);
 		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
 		/*
 		 * Free the new space.
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-09-09 12:33:56.600254349 -0300
+++ xfs/fs/xfs/xfs_iget.c	2009-09-09 12:49:11.330256995 -0300
@@ -43,7 +43,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_btree_trace.h"
-#include "xfs_dir2_trace.h"
+#include "xfs_trace.h"
 
 
 /*
@@ -87,28 +87,6 @@ xfs_inode_alloc(
 	ip->i_size = 0;
 	ip->i_new_size = 0;
 
-	/*
-	 * Initialize inode's trace buffers.
-	 */
-#ifdef	XFS_INODE_TRACE
-	ip->i_trace = ktrace_alloc(INODE_TRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_BTREE_TRACE
-	ip->i_btrace = ktrace_alloc(XFS_BMBT_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_RW_TRACE
-	ip->i_rwtrace = ktrace_alloc(XFS_RW_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_ILOCK_TRACE
-	ip->i_lock_trace = ktrace_alloc(XFS_ILOCK_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_DIR2_TRACE
-	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
-#endif
-
 	/* prevent anyone from using this yet */
 	VFS_I(ip)->i_state = I_NEW|I_LOCK;
 
@@ -130,25 +108,6 @@ xfs_inode_free(
 	if (ip->i_afp)
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
-#ifdef XFS_INODE_TRACE
-	ktrace_free(ip->i_trace);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(ip->i_xtrace);
-#endif
-#ifdef XFS_BTREE_TRACE
-	ktrace_free(ip->i_btrace);
-#endif
-#ifdef XFS_RW_TRACE
-	ktrace_free(ip->i_rwtrace);
-#endif
-#ifdef XFS_ILOCK_TRACE
-	ktrace_free(ip->i_lock_trace);
-#endif
-#ifdef XFS_DIR2_TRACE
-	ktrace_free(ip->i_dir_trace);
-#endif
-
 	if (ip->i_itemp) {
 		/*
 		 * Only if we are shutting down the fs will we see an
@@ -207,6 +166,7 @@ xfs_iget_cache_hit(
 	 *	     instead of polling for it.
 	 */
 	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
+		trace_xfs_iget_skip(ip);
 		XFS_STATS_INC(xs_ig_frecycle);
 		error = EAGAIN;
 		goto out_error;
@@ -225,7 +185,7 @@ xfs_iget_cache_hit(
 	 * Need to carefully get it back into useable state.
 	 */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
-		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
+		trace_xfs_iget_reclaim(ip);
 
 		/*
 		 * We need to set XFS_INEW atomically with clearing the
@@ -251,6 +211,7 @@ xfs_iget_cache_hit(
 			ip->i_flags &= ~XFS_INEW;
 			ip->i_flags |= XFS_IRECLAIMABLE;
 			__xfs_inode_set_reclaim_tag(pag, ip);
+			trace_xfs_iget_reclaim(ip);
 			goto out_error;
 		}
 		inode->i_state = I_LOCK|I_NEW;
@@ -270,8 +231,9 @@ xfs_iget_cache_hit(
 		xfs_ilock(ip, lock_flags);
 
 	xfs_iflags_clear(ip, XFS_ISTALE);
-	xfs_itrace_exit_tag(ip, "xfs_iget.found");
 	XFS_STATS_INC(xs_ig_found);
+
+	trace_xfs_iget_found(ip);
 	return 0;
 
 out_error:
@@ -305,7 +267,7 @@ xfs_iget_cache_miss(
 	if (error)
 		goto out_destroy;
 
-	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
+	xfs_itrace_entry(ip);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		error = ENOENT;
@@ -350,6 +312,8 @@ xfs_iget_cache_miss(
 
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
+
+	trace_xfs_iget_alloc(ip);
 	*ipp = ip;
 	return 0;
 
@@ -636,7 +600,7 @@ xfs_ilock(
 	else if (lock_flags & XFS_ILOCK_SHARED)
 		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 
-	xfs_ilock_trace(ip, 1, lock_flags, (inst_t *)__return_address);
+	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
 }
 
 /*
@@ -681,7 +645,7 @@ xfs_ilock_nowait(
 		if (!mrtryaccess(&ip->i_lock))
 			goto out_undo_iolock;
 	}
-	xfs_ilock_trace(ip, 2, lock_flags, (inst_t *)__return_address);
+	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
 	return 1;
 
  out_undo_iolock:
@@ -743,7 +707,7 @@ xfs_iunlock(
 		xfs_trans_unlocked_item(ip->i_itemp->ili_item.li_ailp,
 					(xfs_log_item_t*)(ip->i_itemp));
 	}
-	xfs_ilock_trace(ip, 3, lock_flags, (inst_t *)__return_address);
+	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
 }
 
 /*
@@ -762,6 +726,8 @@ xfs_ilock_demote(
 		mrdemote(&ip->i_lock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrdemote(&ip->i_iolock);
+
+	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
 }
 
 #ifdef DEBUG
@@ -792,52 +758,3 @@ xfs_isilocked(
 	return 1;
 }
 #endif
-
-#ifdef	XFS_INODE_TRACE
-
-#define KTRACE_ENTER(ip, vk, s, line, ra)			\
-	ktrace_enter((ip)->i_trace,				\
-/*  0 */		(void *)(__psint_t)(vk),		\
-/*  1 */		(void *)(s),				\
-/*  2 */		(void *)(__psint_t) line,		\
-/*  3 */		(void *)(__psint_t)atomic_read(&VFS_I(ip)->i_count), \
-/*  4 */		(void *)(ra),				\
-/*  5 */		NULL,					\
-/*  6 */		(void *)(__psint_t)current_cpu(),	\
-/*  7 */		(void *)(__psint_t)current_pid(),	\
-/*  8 */		(void *)__return_address,		\
-/*  9 */		NULL, NULL, NULL, NULL, NULL, NULL, NULL)
-
-/*
- * Vnode tracing code.
- */
-void
-_xfs_itrace_entry(xfs_inode_t *ip, const char *func, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_ENTRY, func, 0, ra);
-}
-
-void
-_xfs_itrace_exit(xfs_inode_t *ip, const char *func, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_EXIT, func, 0, ra);
-}
-
-void
-xfs_itrace_hold(xfs_inode_t *ip, char *file, int line, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_HOLD, file, line, ra);
-}
-
-void
-_xfs_itrace_ref(xfs_inode_t *ip, char *file, int line, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_REF, file, line, ra);
-}
-
-void
-xfs_itrace_rele(xfs_inode_t *ip, char *file, int line, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_RELE, file, line, ra);
-}
-#endif	/* XFS_INODE_TRACE */
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2009-09-09 12:33:56.604254090 -0300
+++ xfs/fs/xfs/xfs_inode.c	2009-09-09 12:49:11.336255734 -0300
@@ -47,10 +47,10 @@
 #include "xfs_rw.h"
 #include "xfs_error.h"
 #include "xfs_utils.h"
-#include "xfs_dir2_trace.h"
 #include "xfs_quota.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
@@ -1291,42 +1291,6 @@ xfs_file_last_byte(
 	return last_byte;
 }
 
-#if defined(XFS_RW_TRACE)
-STATIC void
-xfs_itrunc_trace(
-	int		tag,
-	xfs_inode_t	*ip,
-	int		flag,
-	xfs_fsize_t	new_size,
-	xfs_off_t	toss_start,
-	xfs_off_t	toss_finish)
-{
-	if (ip->i_rwtrace == NULL) {
-		return;
-	}
-
-	ktrace_enter(ip->i_rwtrace,
-		     (void*)((long)tag),
-		     (void*)ip,
-		     (void*)(unsigned long)((ip->i_d.di_size >> 32) & 0xffffffff),
-		     (void*)(unsigned long)(ip->i_d.di_size & 0xffffffff),
-		     (void*)((long)flag),
-		     (void*)(unsigned long)((new_size >> 32) & 0xffffffff),
-		     (void*)(unsigned long)(new_size & 0xffffffff),
-		     (void*)(unsigned long)((toss_start >> 32) & 0xffffffff),
-		     (void*)(unsigned long)(toss_start & 0xffffffff),
-		     (void*)(unsigned long)((toss_finish >> 32) & 0xffffffff),
-		     (void*)(unsigned long)(toss_finish & 0xffffffff),
-		     (void*)(unsigned long)current_cpu(),
-		     (void*)(unsigned long)current_pid(),
-		     (void*)NULL,
-		     (void*)NULL,
-		     (void*)NULL);
-}
-#else
-#define	xfs_itrunc_trace(tag, ip, flag, new_size, toss_start, toss_finish)
-#endif
-
 /*
  * Start the truncation of the file to new_size.  The new size
  * must be smaller than the current size.  This routine will
@@ -1409,8 +1373,7 @@ xfs_itruncate_start(
 		return 0;
 	}
 	last_byte = xfs_file_last_byte(ip);
-	xfs_itrunc_trace(XFS_ITRUNC_START, ip, flags, new_size, toss_start,
-			 last_byte);
+	trace_xfs_itruncate_start(ip, flags, new_size, toss_start, last_byte);
 	if (last_byte > toss_start) {
 		if (flags & XFS_ITRUNC_DEFINITE) {
 			xfs_tosspages(ip, toss_start,
@@ -1514,7 +1477,8 @@ xfs_itruncate_finish(
 		new_size = 0LL;
 	}
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	xfs_itrunc_trace(XFS_ITRUNC_FINISH1, ip, 0, new_size, 0, 0);
+	trace_xfs_itruncate_finish_start(ip, new_size);
+
 	/*
 	 * The first thing we do is set the size to new_size permanently
 	 * on disk.  This way we don't have to worry about anyone ever
@@ -1731,7 +1695,7 @@ xfs_itruncate_finish(
 	ASSERT((new_size != 0) ||
 	       (fork == XFS_ATTR_FORK) ||
 	       (ip->i_d.di_nextents == 0));
-	xfs_itrunc_trace(XFS_ITRUNC_FINISH2, ip, 0, new_size, 0, 0);
+	trace_xfs_itruncate_finish_end(ip, new_size);
 	return 0;
 }
 
@@ -3252,23 +3216,6 @@ corrupt_out:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
-
-
-#ifdef XFS_ILOCK_TRACE
-void
-xfs_ilock_trace(xfs_inode_t *ip, int lock, unsigned int lockflags, inst_t *ra)
-{
-	ktrace_enter(ip->i_lock_trace,
-		     (void *)ip,
-		     (void *)(unsigned long)lock, /* 1 = LOCK, 3=UNLOCK, etc */
-		     (void *)(unsigned long)lockflags, /* XFS_ILOCK_EXCL etc */
-		     (void *)ra,		/* caller of ilock */
-		     (void *)(unsigned long)current_cpu(),
-		     (void *)(unsigned long)current_pid(),
-		     NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
-}
-#endif
-
 /*
  * Return a pointer to the extent record at file index idx.
  */
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2009-09-09 12:33:56.609253750 -0300
+++ xfs/fs/xfs/xfs_inode.h	2009-09-09 12:49:11.339256047 -0300
@@ -213,7 +213,6 @@ typedef struct xfs_icdinode {
 
 struct bhv_desc;
 struct cred;
-struct ktrace;
 struct xfs_buf;
 struct xfs_bmap_free;
 struct xfs_bmbt_irec;
@@ -222,13 +221,6 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot;
 
-#if defined(XFS_ILOCK_TRACE)
-#define XFS_ILOCK_KTRACE_SIZE	32
-extern void xfs_ilock_trace(struct xfs_inode *, int, unsigned int, inst_t *);
-#else
-#define	xfs_ilock_trace(i,n,f,ra)
-#endif
-
 typedef struct dm_attrs_s {
 	__uint32_t	da_dmevmask;	/* DMIG event mask */
 	__uint16_t	da_dmstate;	/* DMIG state info */
@@ -271,26 +263,6 @@ typedef struct xfs_inode {
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
-
-	/* Trace buffers per inode. */
-#ifdef XFS_INODE_TRACE
-	struct ktrace		*i_trace;	/* general inode trace */
-#endif
-#ifdef XFS_BMAP_TRACE
-	struct ktrace		*i_xtrace;	/* inode extent list trace */
-#endif
-#ifdef XFS_BTREE_TRACE
-	struct ktrace		*i_btrace;	/* inode bmap btree trace */
-#endif
-#ifdef XFS_RW_TRACE
-	struct ktrace		*i_rwtrace;	/* inode read/write trace */
-#endif
-#ifdef XFS_ILOCK_TRACE
-	struct ktrace		*i_lock_trace;	/* inode lock/unlock trace */
-#endif
-#ifdef XFS_DIR2_TRACE
-	struct ktrace		*i_dir_trace;	/* inode directory trace */
-#endif
 } xfs_inode_t;
 
 #define XFS_ISIZE(ip)	(((ip)->i_d.di_mode & S_IFMT) == S_IFREG) ? \
@@ -406,6 +378,14 @@ static inline void xfs_ifunlock(xfs_inod
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
 
+#define XFS_LOCK_FLAGS \
+	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
+	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
+	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
+	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }, \
+	{ XFS_IUNLOCK_NONOTIFY,	"IUNLOCK_NONOTIFY" }
+
+
 /*
  * Flags for lockdep annotations.
  *
@@ -455,6 +435,10 @@ static inline void xfs_ifunlock(xfs_inod
 #define	XFS_ITRUNC_DEFINITE	0x1
 #define	XFS_ITRUNC_MAYBE	0x2
 
+#define XFS_ITRUNC_FLAGS \
+	{ XFS_ITRUNC_DEFINITE,	"DEFINITE" }, \
+	{ XFS_ITRUNC_MAYBE,	"MAYBE" }
+
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
@@ -507,48 +491,16 @@ void		xfs_lock_two_inodes(xfs_inode_t *,
 void		xfs_synchronize_atime(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
-#if defined(XFS_INODE_TRACE)
-
-#define	INODE_TRACE_SIZE	16		/* number of trace entries */
-#define	INODE_KTRACE_ENTRY	1
-#define	INODE_KTRACE_EXIT	2
-#define	INODE_KTRACE_HOLD	3
-#define	INODE_KTRACE_REF	4
-#define	INODE_KTRACE_RELE	5
-
-extern void _xfs_itrace_entry(struct xfs_inode *, const char *, inst_t *);
-extern void _xfs_itrace_exit(struct xfs_inode *, const char *, inst_t *);
-extern void xfs_itrace_hold(struct xfs_inode *, char *, int, inst_t *);
-extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
-extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
-#define xfs_itrace_entry(ip)	\
-	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
-#define xfs_itrace_exit(ip)	\
-	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
-#define xfs_itrace_exit_tag(ip, tag)	\
-	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
-#define xfs_itrace_ref(ip)	\
-	_xfs_itrace_ref(ip, __FILE__, __LINE__, (inst_t *)__return_address)
-
-#else
-#define	xfs_itrace_entry(a)
-#define	xfs_itrace_exit(a)
-#define	xfs_itrace_exit_tag(a, b)
-#define	xfs_itrace_hold(a, b, c, d)
-#define	xfs_itrace_ref(a)
-#define	xfs_itrace_rele(a, b, c, d)
-#endif
-
 #define IHOLD(ip) \
 do { \
 	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
 	atomic_inc(&(VFS_I(ip)->i_count)); \
-	xfs_itrace_hold((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
 #define IRELE(ip) \
 do { \
-	xfs_itrace_rele((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	trace_xfs_irele(ip, _THIS_IP_); \
 	iput(VFS_I(ip)); \
 } while (0)
 
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2009-09-09 12:33:56.613255866 -0300
+++ xfs/fs/xfs/xfs_inode_item.c	2009-09-09 12:49:11.343256067 -0300
@@ -41,6 +41,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_rw.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
@@ -796,7 +797,7 @@ xfs_inode_item_pushbuf(
 				  !completion_done(&ip->i_flush));
 			iip->ili_pushbuf_flag = 0;
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			xfs_buftrace("INODE ITEM PUSH", bp);
+			xfs_buftrace(bp, "inode_item_push");
 			if (XFS_BUF_ISPINNED(bp)) {
 				xfs_log_force(mp, (xfs_lsn_t)0,
 					      XFS_LOG_FORCE);
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2009-09-09 12:33:56.618254616 -0300
+++ xfs/fs/xfs/xfs_iomap.c	2009-09-09 12:49:11.345320367 -0300
@@ -47,72 +47,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
 #include "xfs_iomap.h"
+#include "xfs_trace.h"
 
-#if defined(XFS_RW_TRACE)
-void
-xfs_iomap_enter_trace(
-	int		tag,
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	ssize_t		count)
-{
-	if (!ip->i_rwtrace)
-		return;
-
-	ktrace_enter(ip->i_rwtrace,
-		(void *)((unsigned long)tag),
-		(void *)ip,
-		(void *)((unsigned long)((ip->i_d.di_size >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(ip->i_d.di_size & 0xffffffff)),
-		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(offset & 0xffffffff)),
-		(void *)((unsigned long)count),
-		(void *)((unsigned long)((ip->i_new_size >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(ip->i_new_size & 0xffffffff)),
-		(void *)((unsigned long)current_pid()),
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL,
-		(void *)NULL);
-}
-
-void
-xfs_iomap_map_trace(
-	int		tag,
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	ssize_t		count,
-	xfs_iomap_t	*iomapp,
-	xfs_bmbt_irec_t	*imapp,
-	int		flags)
-{
-	if (!ip->i_rwtrace)
-		return;
-
-	ktrace_enter(ip->i_rwtrace,
-		(void *)((unsigned long)tag),
-		(void *)ip,
-		(void *)((unsigned long)((ip->i_d.di_size >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(ip->i_d.di_size & 0xffffffff)),
-		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(offset & 0xffffffff)),
-		(void *)((unsigned long)count),
-		(void *)((unsigned long)flags),
-		(void *)((unsigned long)((iomapp->iomap_offset >> 32) & 0xffffffff)),
-		(void *)((unsigned long)(iomapp->iomap_offset & 0xffffffff)),
-		(void *)((unsigned long)(iomapp->iomap_delta)),
-		(void *)((unsigned long)(iomapp->iomap_bsize)),
-		(void *)((unsigned long)(iomapp->iomap_bn)),
-		(void *)(__psint_t)(imapp->br_startoff),
-		(void *)((unsigned long)(imapp->br_blockcount)),
-		(void *)(__psint_t)(imapp->br_startblock));
-}
-#else
-#define xfs_iomap_enter_trace(tag, io, offset, count)
-#define xfs_iomap_map_trace(tag, io, offset, count, iomapp, imapp, flags)
-#endif
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
 						<< mp->m_writeio_log)
@@ -187,21 +123,20 @@ xfs_iomap(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	trace_xfs_iomap_enter(ip, offset, count, flags, NULL);
+
 	switch (flags & (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE)) {
 	case BMAPI_READ:
-		xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, ip, offset, count);
 		lockmode = xfs_ilock_map_shared(ip);
 		bmapi_flags = XFS_BMAPI_ENTIRE;
 		break;
 	case BMAPI_WRITE:
-		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_ENTER, ip, offset, count);
 		lockmode = XFS_ILOCK_EXCL;
 		if (flags & BMAPI_IGNSTATE)
 			bmapi_flags |= XFS_BMAPI_IGSTATE|XFS_BMAPI_ENTIRE;
 		xfs_ilock(ip, lockmode);
 		break;
 	case BMAPI_ALLOCATE:
-		xfs_iomap_enter_trace(XFS_IOMAP_ALLOC_ENTER, ip, offset, count);
 		lockmode = XFS_ILOCK_SHARED;
 		bmapi_flags = XFS_BMAPI_ENTIRE;
 
@@ -237,8 +172,7 @@ xfs_iomap(
 		if (nimaps &&
 		    (imap.br_startblock != HOLESTARTBLOCK) &&
 		    (imap.br_startblock != DELAYSTARTBLOCK)) {
-			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
-					offset, count, iomapp, &imap, flags);
+			trace_xfs_iomap_found(ip, offset, count, flags, &imap);
 			break;
 		}
 
@@ -250,8 +184,7 @@ xfs_iomap(
 						      &imap, &nimaps);
 		}
 		if (!error) {
-			xfs_iomap_map_trace(XFS_IOMAP_ALLOC_MAP, ip,
-					offset, count, iomapp, &imap, flags);
+			trace_xfs_iomap_alloc(ip, offset, count, flags, &imap);
 		}
 		iomap_flags = IOMAP_NEW;
 		break;
@@ -261,8 +194,7 @@ xfs_iomap(
 		lockmode = 0;
 
 		if (nimaps && !isnullstartblock(imap.br_startblock)) {
-			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
-					offset, count, iomapp, &imap, flags);
+			trace_xfs_iomap_found(ip, offset, count, flags, &imap);
 			break;
 		}
 
@@ -623,8 +555,7 @@ retry:
 	 * delalloc blocks and retry without EOF preallocation.
 	 */
 	if (nimaps == 0) {
-		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_NOSPACE,
-					ip, offset, count);
+		trace_xfs_delalloc_enospc(ip, offset, count);
 		if (flushed)
 			return XFS_ERROR(ENOSPC);
 
@@ -837,7 +768,7 @@ xfs_iomap_write_unwritten(
 	int		committed;
 	int		error;
 
-	xfs_iomap_enter_trace(XFS_IOMAP_UNWRITTEN, ip, offset, count);
+	trace_xfs_unwritten_convert(ip, offset, count);
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2009-09-09 12:33:56.623253717 -0300
+++ xfs/fs/xfs/xfs_iomap.h	2009-09-09 12:49:11.349004984 -0300
@@ -43,6 +43,14 @@ typedef enum {
 	BMAPI_TRYLOCK = (1 << 7),	/* non-blocking request */
 } bmapi_flags_t;
 
+#define BMAPI_FLAGS \
+	{ BMAPI_READ,		"READ" }, \
+	{ BMAPI_WRITE,		"WRITE" }, \
+	{ BMAPI_ALLOCATE,	"ALLOCATE" }, \
+	{ BMAPI_IGNSTATE,	"IGNSTATE" }, \
+	{ BMAPI_DIRECT,		"DIRECT" }, \
+	{ BMAPI_MMAP,		"MMAP" }, \
+	{ BMAPI_TRYLOCK,	"TRYLOCK" }
 
 /*
  * xfs_iomap_t:  File system I/O map
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-09-09 12:33:56.627253877 -0300
+++ xfs/fs/xfs/xfs_log.c	2009-09-09 13:17:42.706021271 -0300
@@ -40,6 +40,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_rw.h"
+#include "xfs_trace.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
@@ -122,85 +123,6 @@ STATIC void	xlog_verify_tail_lsn(xlog_t 
 
 STATIC int	xlog_iclogs_empty(xlog_t *log);
 
-#if defined(XFS_LOG_TRACE)
-
-#define XLOG_TRACE_LOGGRANT_SIZE	2048
-#define XLOG_TRACE_ICLOG_SIZE		256
-
-void
-xlog_trace_loggrant_alloc(xlog_t *log)
-{
-	log->l_grant_trace = ktrace_alloc(XLOG_TRACE_LOGGRANT_SIZE, KM_NOFS);
-}
-
-void
-xlog_trace_loggrant_dealloc(xlog_t *log)
-{
-	ktrace_free(log->l_grant_trace);
-}
-
-void
-xlog_trace_loggrant(xlog_t *log, xlog_ticket_t *tic, xfs_caddr_t string)
-{
-	unsigned long cnts;
-
-	/* ticket counts are 1 byte each */
-	cnts = ((unsigned long)tic->t_ocnt) | ((unsigned long)tic->t_cnt) << 8;
-
-	ktrace_enter(log->l_grant_trace,
-		     (void *)tic,
-		     (void *)log->l_reserve_headq,
-		     (void *)log->l_write_headq,
-		     (void *)((unsigned long)log->l_grant_reserve_cycle),
-		     (void *)((unsigned long)log->l_grant_reserve_bytes),
-		     (void *)((unsigned long)log->l_grant_write_cycle),
-		     (void *)((unsigned long)log->l_grant_write_bytes),
-		     (void *)((unsigned long)log->l_curr_cycle),
-		     (void *)((unsigned long)log->l_curr_block),
-		     (void *)((unsigned long)CYCLE_LSN(log->l_tail_lsn)),
-		     (void *)((unsigned long)BLOCK_LSN(log->l_tail_lsn)),
-		     (void *)string,
-		     (void *)((unsigned long)tic->t_trans_type),
-		     (void *)cnts,
-		     (void *)((unsigned long)tic->t_curr_res),
-		     (void *)((unsigned long)tic->t_unit_res));
-}
-
-void
-xlog_trace_iclog_alloc(xlog_in_core_t *iclog)
-{
-	iclog->ic_trace = ktrace_alloc(XLOG_TRACE_ICLOG_SIZE, KM_NOFS);
-}
-
-void
-xlog_trace_iclog_dealloc(xlog_in_core_t *iclog)
-{
-	ktrace_free(iclog->ic_trace);
-}
-
-void
-xlog_trace_iclog(xlog_in_core_t *iclog, uint state)
-{
-	ktrace_enter(iclog->ic_trace,
-		     (void *)((unsigned long)state),
-		     (void *)((unsigned long)current_pid()),
-		     (void *)NULL, (void *)NULL, (void *)NULL, (void *)NULL,
-		     (void *)NULL, (void *)NULL, (void *)NULL, (void *)NULL,
-		     (void *)NULL, (void *)NULL, (void *)NULL, (void *)NULL,
-		     (void *)NULL, (void *)NULL);
-}
-#else
-
-#define	xlog_trace_loggrant_alloc(log)
-#define	xlog_trace_loggrant_dealloc(log)
-#define	xlog_trace_loggrant(log,tic,string)
-
-#define	xlog_trace_iclog_alloc(iclog)
-#define	xlog_trace_iclog_dealloc(iclog)
-#define	xlog_trace_iclog(iclog,state)
-
-#endif /* XFS_LOG_TRACE */
-
 
 static void
 xlog_ins_ticketq(struct xlog_ticket **qp, struct xlog_ticket *tic)
@@ -353,15 +275,17 @@ xfs_log_done(xfs_mount_t	*mp,
 
 	if ((ticket->t_flags & XLOG_TIC_PERM_RESERV) == 0 ||
 	    (flags & XFS_LOG_REL_PERM_RESERV)) {
+		trace_xfs_log_done_nonperm(log, ticket);
+
 		/*
 		 * Release ticket if not permanent reservation or a specific
 		 * request has been made to release a permanent reservation.
 		 */
-		xlog_trace_loggrant(log, ticket, "xfs_log_done: (non-permanent)");
 		xlog_ungrant_log_space(log, ticket);
 		xfs_log_ticket_put(ticket);
 	} else {
-		xlog_trace_loggrant(log, ticket, "xfs_log_done: (permanent)");
+		trace_xfs_log_done_perm(log, ticket);
+
 		xlog_regrant_reserve_log_space(log, ticket);
 		/* If this ticket was a permanent reservation and we aren't
 		 * trying to release it, reset the inited flags; so next time
@@ -505,10 +429,13 @@ xfs_log_reserve(xfs_mount_t	 *mp,
 
 	XFS_STATS_INC(xs_try_logspace);
 
+
 	if (*ticket != NULL) {
 		ASSERT(flags & XFS_LOG_PERM_RESERV);
 		internal_ticket = (xlog_ticket_t *)*ticket;
-		xlog_trace_loggrant(log, internal_ticket, "xfs_log_reserve: existing ticket (permanent trans)");
+
+		trace_xfs_log_reserve(log, internal_ticket);
+
 		xlog_grant_push_ail(mp, internal_ticket->t_unit_res);
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
 	} else {
@@ -519,10 +446,9 @@ xfs_log_reserve(xfs_mount_t	 *mp,
 			return XFS_ERROR(ENOMEM);
 		internal_ticket->t_trans_type = t_type;
 		*ticket = internal_ticket;
-		xlog_trace_loggrant(log, internal_ticket, 
-			(internal_ticket->t_flags & XLOG_TIC_PERM_RESERV) ?
-			"xfs_log_reserve: create new ticket (permanent trans)" :
-			"xfs_log_reserve: create new ticket");
+
+		trace_xfs_log_reserve(log, internal_ticket);
+
 		xlog_grant_push_ail(mp,
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
@@ -734,7 +660,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			spin_unlock(&log->l_icloglock);
 		}
 		if (tic) {
-			xlog_trace_loggrant(log, tic, "unmount rec");
+			trace_xfs_log_umount_write(log, tic);
 			xlog_ungrant_log_space(log, tic);
 			xfs_log_ticket_put(tic);
 		}
@@ -1030,7 +956,7 @@ xlog_iodone(xfs_buf_t *bp)
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"
 				" by device. Disabling barriers\n");
-		xfs_buftrace("XLOG_IODONE BARRIERS OFF", bp);
+		xfs_buftrace(bp, "barriers_off");
 	}
 
 	/*
@@ -1085,7 +1011,7 @@ xlog_bdstrat_cb(struct xfs_buf *bp)
 		return 0;
 	}
 
-	xfs_buftrace("XLOG__BDSTRAT IOERROR", bp);
+	xfs_buftrace(bp, "xlog_ioerror");
 	XFS_BUF_ERROR(bp, EIO);
 	XFS_BUF_STALE(bp);
 	xfs_biodone(bp);
@@ -1246,7 +1172,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	spin_lock_init(&log->l_grant_lock);
 	sv_init(&log->l_flush_wait, 0, "flush_wait");
 
-	xlog_trace_loggrant_alloc(log);
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
 
@@ -1305,8 +1230,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		sv_init(&iclog->ic_force_wait, SV_DEFAULT, "iclog-force");
 		sv_init(&iclog->ic_write_wait, SV_DEFAULT, "iclog-write");
 
-		xlog_trace_iclog_alloc(iclog);
-
 		iclogp = &iclog->ic_next;
 	}
 	*iclogp = log->l_iclog;			/* complete ring */
@@ -1321,13 +1244,11 @@ out_free_iclog:
 			sv_destroy(&iclog->ic_force_wait);
 			sv_destroy(&iclog->ic_write_wait);
 			xfs_buf_free(iclog->ic_bp);
-			xlog_trace_iclog_dealloc(iclog);
 		}
 		kmem_free(iclog);
 	}
 	spinlock_destroy(&log->l_icloglock);
 	spinlock_destroy(&log->l_grant_lock);
-	xlog_trace_loggrant_dealloc(log);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -1607,7 +1528,6 @@ xlog_dealloc_log(xlog_t *log)
 		sv_destroy(&iclog->ic_force_wait);
 		sv_destroy(&iclog->ic_write_wait);
 		xfs_buf_free(iclog->ic_bp);
-		xlog_trace_iclog_dealloc(iclog);
 		next_iclog = iclog->ic_next;
 		kmem_free(iclog);
 		iclog = next_iclog;
@@ -1616,7 +1536,6 @@ xlog_dealloc_log(xlog_t *log)
 	spinlock_destroy(&log->l_grant_lock);
 
 	xfs_buf_free(log->l_xbuf);
-	xlog_trace_loggrant_dealloc(log);
 	log->l_mp->m_log = NULL;
 	kmem_free(log);
 }	/* xlog_dealloc_log */
@@ -2414,7 +2333,6 @@ restart:
 
 	iclog = log->l_iclog;
 	if (iclog->ic_state != XLOG_STATE_ACTIVE) {
-		xlog_trace_iclog(iclog, XLOG_TRACE_SLEEP_FLUSH);
 		XFS_STATS_INC(xs_log_noiclogs);
 
 		/* Wait for log writes to have flushed */
@@ -2520,13 +2438,15 @@ xlog_grant_log_space(xlog_t	   *log,
 
 	/* Is there space or do we need to sleep? */
 	spin_lock(&log->l_grant_lock);
-	xlog_trace_loggrant(log, tic, "xlog_grant_log_space: enter");
+
+	trace_xfs_log_grant_enter(log, tic);
 
 	/* something is already sleeping; insert new transaction at end */
 	if (log->l_reserve_headq) {
 		xlog_ins_ticketq(&log->l_reserve_headq, tic);
-		xlog_trace_loggrant(log, tic,
-				    "xlog_grant_log_space: sleep 1");
+
+		trace_xfs_log_grant_sleep1(log, tic);
+
 		/*
 		 * Gotta check this before going to sleep, while we're
 		 * holding the grant lock.
@@ -2540,8 +2460,7 @@ xlog_grant_log_space(xlog_t	   *log,
 		 * If we got an error, and the filesystem is shutting down,
 		 * we'll catch it down below. So just continue...
 		 */
-		xlog_trace_loggrant(log, tic,
-				    "xlog_grant_log_space: wake 1");
+		trace_xfs_log_grant_wake1(log, tic);
 		spin_lock(&log->l_grant_lock);
 	}
 	if (tic->t_flags & XFS_LOG_PERM_RESERV)
@@ -2558,8 +2477,9 @@ redo:
 	if (free_bytes < need_bytes) {
 		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
 			xlog_ins_ticketq(&log->l_reserve_headq, tic);
-		xlog_trace_loggrant(log, tic,
-				    "xlog_grant_log_space: sleep 2");
+
+		trace_xfs_log_grant_sleep2(log, tic);
+
 		spin_unlock(&log->l_grant_lock);
 		xlog_grant_push_ail(log->l_mp, need_bytes);
 		spin_lock(&log->l_grant_lock);
@@ -2571,8 +2491,8 @@ redo:
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
 
-		xlog_trace_loggrant(log, tic,
-				    "xlog_grant_log_space: wake 2");
+		trace_xfs_log_grant_wake2(log, tic);
+
 		goto redo;
 	} else if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_reserve_headq, tic);
@@ -2592,7 +2512,7 @@ redo:
 		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
 	}
 #endif
-	xlog_trace_loggrant(log, tic, "xlog_grant_log_space: exit");
+	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
 	spin_unlock(&log->l_grant_lock);
 	return 0;
@@ -2600,7 +2520,9 @@ redo:
  error_return:
 	if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_reserve_headq, tic);
-	xlog_trace_loggrant(log, tic, "xlog_grant_log_space: err_ret");
+
+	trace_xfs_log_grant_error(log, tic);
+
 	/*
 	 * If we are failing, make sure the ticket doesn't have any
 	 * current reservations. We don't want to add this back when
@@ -2640,7 +2562,8 @@ xlog_regrant_write_log_space(xlog_t	   *
 #endif
 
 	spin_lock(&log->l_grant_lock);
-	xlog_trace_loggrant(log, tic, "xlog_regrant_write_log_space: enter");
+
+	trace_xfs_log_regrant_write_enter(log, tic);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
@@ -2669,8 +2592,8 @@ xlog_regrant_write_log_space(xlog_t	   *
 			if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
 				xlog_ins_ticketq(&log->l_write_headq, tic);
 
-			xlog_trace_loggrant(log, tic,
-				    "xlog_regrant_write_log_space: sleep 1");
+			trace_xfs_log_regrant_write_sleep1(log, tic);
+
 			spin_unlock(&log->l_grant_lock);
 			xlog_grant_push_ail(log->l_mp, need_bytes);
 			spin_lock(&log->l_grant_lock);
@@ -2685,8 +2608,7 @@ xlog_regrant_write_log_space(xlog_t	   *
 			if (XLOG_FORCED_SHUTDOWN(log))
 				goto error_return;
 
-			xlog_trace_loggrant(log, tic,
-				    "xlog_regrant_write_log_space: wake 1");
+			trace_xfs_log_regrant_write_wake1(log, tic);
 		}
 	}
 
@@ -2704,6 +2626,8 @@ redo:
 		spin_lock(&log->l_grant_lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
+		trace_xfs_log_regrant_write_sleep2(log, tic);
+
 		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
 		/* If we're shutting down, this tic is already off the queue */
@@ -2711,8 +2635,7 @@ redo:
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
 
-		xlog_trace_loggrant(log, tic,
-				    "xlog_regrant_write_log_space: wake 2");
+		trace_xfs_log_regrant_write_wake2(log, tic);
 		goto redo;
 	} else if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_write_headq, tic);
@@ -2727,7 +2650,8 @@ redo:
 	}
 #endif
 
-	xlog_trace_loggrant(log, tic, "xlog_regrant_write_log_space: exit");
+	trace_xfs_log_regrant_write_exit(log, tic);
+
 	xlog_verify_grant_head(log, 1);
 	spin_unlock(&log->l_grant_lock);
 	return 0;
@@ -2736,7 +2660,9 @@ redo:
  error_return:
 	if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_reserve_headq, tic);
-	xlog_trace_loggrant(log, tic, "xlog_regrant_write_log_space: err_ret");
+
+	trace_xfs_log_regrant_write_error(log, tic);
+
 	/*
 	 * If we are failing, make sure the ticket doesn't have any
 	 * current reservations. We don't want to add this back when
@@ -2760,8 +2686,8 @@ STATIC void
 xlog_regrant_reserve_log_space(xlog_t	     *log,
 			       xlog_ticket_t *ticket)
 {
-	xlog_trace_loggrant(log, ticket,
-			    "xlog_regrant_reserve_log_space: enter");
+	trace_xfs_log_regrant_reserve_enter(log, ticket);
+
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
@@ -2769,8 +2695,9 @@ xlog_regrant_reserve_log_space(xlog_t	  
 	xlog_grant_sub_space(log, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
-	xlog_trace_loggrant(log, ticket,
-			    "xlog_regrant_reserve_log_space: sub current res");
+
+	trace_xfs_log_regrant_reserve_sub(log, ticket);
+
 	xlog_verify_grant_head(log, 1);
 
 	/* just return if we still have some of the pre-reserved space */
@@ -2780,8 +2707,9 @@ xlog_regrant_reserve_log_space(xlog_t	  
 	}
 
 	xlog_grant_add_space_reserve(log, ticket->t_unit_res);
-	xlog_trace_loggrant(log, ticket,
-			    "xlog_regrant_reserve_log_space: exit");
+
+	trace_xfs_log_regrant_reserve_exit(log, ticket);
+
 	xlog_verify_grant_head(log, 0);
 	spin_unlock(&log->l_grant_lock);
 	ticket->t_curr_res = ticket->t_unit_res;
@@ -2811,11 +2739,11 @@ xlog_ungrant_log_space(xlog_t	     *log,
 		ticket->t_cnt--;
 
 	spin_lock(&log->l_grant_lock);
-	xlog_trace_loggrant(log, ticket, "xlog_ungrant_log_space: enter");
+	trace_xfs_log_ungrant_enter(log, ticket);
 
 	xlog_grant_sub_space(log, ticket->t_curr_res);
 
-	xlog_trace_loggrant(log, ticket, "xlog_ungrant_log_space: sub current");
+	trace_xfs_log_ungrant_sub(log, ticket);
 
 	/* If this is a permanent reservation ticket, we may be able to free
 	 * up more space based on the remaining count.
@@ -2825,7 +2753,8 @@ xlog_ungrant_log_space(xlog_t	     *log,
 		xlog_grant_sub_space(log, ticket->t_unit_res*ticket->t_cnt);
 	}
 
-	xlog_trace_loggrant(log, ticket, "xlog_ungrant_log_space: exit");
+	trace_xfs_log_ungrant_exit(log, ticket);
+
 	xlog_verify_grant_head(log, 1);
 	spin_unlock(&log->l_grant_lock);
 	xfs_log_move_tail(log->l_mp, 1);
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2009-09-09 12:33:56.632253746 -0300
+++ xfs/fs/xfs/xfs_log_priv.h	2009-09-09 12:56:59.390006528 -0300
@@ -19,7 +19,6 @@
 #define __XFS_LOG_PRIV_H__
 
 struct xfs_buf;
-struct ktrace;
 struct log;
 struct xlog_ticket;
 struct xfs_buf_cancel;
@@ -135,6 +134,12 @@ static inline uint xlog_get_client_id(__
 #define XLOG_TIC_INITED		0x1	/* has been initialized */
 #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
 #define XLOG_TIC_IN_Q		0x4
+
+#define XLOG_TIC_FLAGS \
+	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
+	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }, \
+	{ XLOG_TIC_IN_Q,	"XLOG_TIC_IN_Q" }
+
 #endif	/* __KERNEL__ */
 
 #define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
@@ -361,9 +366,6 @@ typedef struct xlog_in_core {
 	int			ic_bwritecnt;
 	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*ic_trace;
-#endif
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
@@ -429,10 +431,6 @@ typedef struct log {
 	int			l_grant_write_cycle;
 	int			l_grant_write_bytes;
 
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*l_grant_trace;
-#endif
-
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
@@ -456,12 +454,6 @@ extern void	 xlog_put_bp(struct xfs_buf 
 
 extern kmem_zone_t	*xfs_log_ticket_zone;
 
-/* iclog tracing */
-#define XLOG_TRACE_GRAB_FLUSH  1
-#define XLOG_TRACE_REL_FLUSH   2
-#define XLOG_TRACE_SLEEP_FLUSH 3
-#define XLOG_TRACE_WAKE_FLUSH  4
-
 /*
  * Unmount record type is used as a pseudo transaction type for the ticket.
  * It's value must be outside the range of XFS_TRANS_* values.
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-09-09 12:33:56.646253364 -0300
+++ xfs/fs/xfs/xfs_log_recover.c	2009-09-09 12:49:11.362256253 -0300
@@ -46,6 +46,7 @@
 #include "xfs_quota.h"
 #include "xfs_rw.h"
 #include "xfs_utils.h"
+#include "xfs_trace.h"
 
 STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
 STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-09-09 12:33:56.650253734 -0300
+++ xfs/fs/xfs/xfs_mount.c	2009-09-09 12:49:11.368256878 -0300
@@ -44,6 +44,8 @@
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
+#include "xfs_trace.h"
+
 
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
 
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2009-09-09 12:33:56.655253952 -0300
+++ xfs/fs/xfs/xfs_quota.h	2009-09-09 12:49:11.371256073 -0300
@@ -92,6 +92,14 @@ typedef struct xfs_dqblk {
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
+#define XFS_DQ_FLAGS \
+	{ XFS_DQ_USER,		"USER" }, \
+	{ XFS_DQ_PROJ,		"PROJ" }, \
+	{ XFS_DQ_GROUP,		"GROUP" }, \
+	{ XFS_DQ_DIRTY,		"DIRTY" }, \
+	{ XFS_DQ_WANT,		"WANT" }, \
+	{ XFS_DQ_INACTIVE,	"INACTIVE" }
+
 /*
  * In the worst case, when both user and group quotas are on,
  * we can have a max of three dquots changing in a single transaction.
Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2009-09-09 12:33:56.659253972 -0300
+++ xfs/fs/xfs/xfs_rename.c	2009-09-09 12:49:11.373257235 -0300
@@ -39,6 +39,7 @@
 #include "xfs_utils.h"
 #include "xfs_trans_space.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 
 /*
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2009-09-09 12:33:56.665253689 -0300
+++ xfs/fs/xfs/xfs_rtalloc.c	2009-09-09 12:49:11.377307402 -0300
@@ -45,6 +45,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
+#include "xfs_trace.h"
 
 
 /*
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2009-09-09 12:33:56.670252999 -0300
+++ xfs/fs/xfs/xfs_rw.c	2009-09-09 12:49:11.379255905 -0300
@@ -44,6 +44,7 @@
 #include "xfs_error.h"
 #include "xfs_buf_item.h"
 #include "xfs_rw.h"
+#include "xfs_trace.h"
 
 /*
  * This is a subroutine for xfs_write() and other writers (xfs_ioctl)
@@ -171,7 +172,6 @@ xfs_bioerror(
 	 * No need to wait until the buffer is unpinned.
 	 * We aren't flushing it.
 	 */
-	xfs_buftrace("XFS IOERROR", bp);
 	XFS_BUF_ERROR(bp, EIO);
 	/*
 	 * We're calling biodone, so delete B_DONE flag. Either way
@@ -205,7 +205,6 @@ xfs_bioerror_relse(
 	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xfs_buf_iodone_callbacks);
 	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xlog_iodone);
 
-	xfs_buftrace("XFS IOERRELSE", bp);
 	fl = XFS_BUF_BFLAGS(bp);
 	/*
 	 * No need to wait until the buffer is unpinned.
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2009-09-09 12:33:56.674253997 -0300
+++ xfs/fs/xfs/xfs_trans.h	2009-09-09 12:49:11.383255995 -0300
@@ -100,6 +100,49 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_TYPE_MAX		41
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
+#define XFS_TRANS_TYPES \
+	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
+	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
+	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
+	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
+	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
+	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
+	{ XFS_TRANS_LINK,		"LINK" }, \
+	{ XFS_TRANS_RENAME,		"RENAME" }, \
+	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
+	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
+	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
+	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
+	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
+	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
+	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
+	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
+	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
+	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
+	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
+	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
+	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
+	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
+	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
+	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
+	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
+	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
+	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
+	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
+	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
+	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
+	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
+	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
+	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
+	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+
 /*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
@@ -782,6 +825,10 @@ typedef struct xfs_log_item {
 #define	XFS_LI_IN_AIL	0x1
 #define XFS_LI_ABORTED	0x2
 
+#define XFS_LI_FLAGS \
+	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
+	{ XFS_LI_ABORTED,	"ABORTED" }
+
 typedef struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2009-09-09 12:33:56.679253935 -0300
+++ xfs/fs/xfs/xfs_trans_buf.c	2009-09-09 12:49:11.385256040 -0300
@@ -38,6 +38,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
+#include "xfs_trace.h"
 
 
 STATIC xfs_buf_t *xfs_trans_buf_item_match(xfs_trans_t *, xfs_buftarg_t *,
@@ -99,7 +100,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
-			xfs_buftrace("TRANS GET RECUR SHUT", bp);
+			xfs_buftrace(bp, "trans_get_recur_shut");
 			XFS_BUF_SUPER_STALE(bp);
 		}
 		/*
@@ -108,7 +109,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		 * caller isn't allowed to use the data anyway.
 		 */
 		else if (XFS_BUF_ISSTALE(bp)) {
-			xfs_buftrace("TRANS GET RECUR STALE", bp);
+			xfs_buftrace(bp, "trans_get_recur_stale");
 			ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
 		}
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
@@ -116,7 +117,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
-		xfs_buftrace("TRANS GET RECUR", bp);
+		xfs_buftrace(bp, "trans_get_recur");
 		xfs_buf_item_trace("GET RECUR", bip);
 		return (bp);
 	}
@@ -169,7 +170,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	 */
 	XFS_BUF_SET_FSPRIVATE2(bp, tp);
 
-	xfs_buftrace("TRANS GET", bp);
+	xfs_buftrace(bp, "trans_get");
 	xfs_buf_item_trace("GET", bip);
 	return (bp);
 }
@@ -350,7 +351,7 @@ xfs_trans_read_buf(
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 		ASSERT((XFS_BUF_ISERROR(bp)) == 0);
 		if (!(XFS_BUF_ISDONE(bp))) {
-			xfs_buftrace("READ_BUF_INCORE !DONE", bp);
+			xfs_buftrace(bp, "trans_read_buf_io");
 			ASSERT(!XFS_BUF_ISASYNC(bp));
 			XFS_BUF_READ(bp);
 			xfsbdstrat(tp->t_mountp, bp);
@@ -375,7 +376,7 @@ xfs_trans_read_buf(
 		 * brelse it either. Just get out.
 		 */
 		if (XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_buftrace("READ_BUF_INCORE XFSSHUTDN", bp);
+			xfs_buftrace(bp, "trans_read_buf_shut_incore");
 			*bpp = NULL;
 			return XFS_ERROR(EIO);
 		}
@@ -405,7 +406,7 @@ xfs_trans_read_buf(
 	}
 	if (XFS_BUF_GETERROR(bp) != 0) {
 	    XFS_BUF_SUPER_STALE(bp);
-		xfs_buftrace("READ ERROR", bp);
+		xfs_buftrace(bp, "trans_read_buf_error");
 		error = XFS_BUF_GETERROR(bp);
 
 		xfs_ioerror_alert("xfs_trans_read_buf", mp,
@@ -464,7 +465,7 @@ xfs_trans_read_buf(
 	 */
 	XFS_BUF_SET_FSPRIVATE2(bp, tp);
 
-	xfs_buftrace("TRANS READ", bp);
+	xfs_buftrace(bp, "trans_read_buf");
 	xfs_buf_item_trace("READ", bip);
 	*bpp = bp;
 	return 0;
@@ -483,7 +484,7 @@ shutdown_abort:
 	ASSERT((XFS_BUF_BFLAGS(bp) & (XFS_B_STALE|XFS_B_DELWRI)) !=
 						(XFS_B_STALE|XFS_B_DELWRI));
 
-	xfs_buftrace("READ_BUF XFSSHUTDN", bp);
+	xfs_buftrace(bp, "trans_read_buf_shut");
 	xfs_buf_relse(bp);
 	*bpp = NULL;
 	return XFS_ERROR(EIO);
@@ -843,7 +844,7 @@ xfs_trans_binval(
 		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
 		ASSERT(lidp->lid_flags & XFS_LID_DIRTY);
 		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
-		xfs_buftrace("XFS_BINVAL RECUR", bp);
+		xfs_buftrace(bp, "trans_binval_recur");
 		xfs_buf_item_trace("BINVAL RECUR", bip);
 		return;
 	}
@@ -878,7 +879,7 @@ xfs_trans_binval(
 	      (bip->bli_format.blf_map_size * sizeof(uint)));
 	lidp->lid_flags |= XFS_LID_DIRTY|XFS_LID_BUF_STALE;
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	xfs_buftrace("XFS_BINVAL", bp);
+	xfs_buftrace(bp, "trans_binval");
 	xfs_buf_item_trace("BINVAL", bip);
 }
 
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-09-09 12:33:56.685253443 -0300
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-09-09 12:49:11.390256538 -0300
@@ -53,6 +53,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 int
 xfs_setattr(
@@ -1380,7 +1381,6 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
-	xfs_itrace_ref(*ipp);
 	return 0;
 
 out_free_name:
@@ -1526,7 +1526,6 @@ xfs_create(
 	 * At this point, we've gotten a newly allocated inode.
 	 * It is locked (and joined to the transaction).
 	 */
-	xfs_itrace_ref(ip);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
@@ -1986,9 +1985,6 @@ xfs_remove(
 	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
-	xfs_itrace_exit(ip);
-	xfs_itrace_exit(dp);
-
  std_return:
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
 		XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE, dp, DM_RIGHT_NULL,
@@ -2285,7 +2281,6 @@ xfs_symlink(
 			goto error_return;
 		goto error1;
 	}
-	xfs_itrace_ref(ip);
 
 	/*
 	 * An error after we've joined dp to the transaction will result in the
@@ -2874,7 +2869,6 @@ xfs_free_file_space(
 	ioffset = offset & ~(rounding - 1);
 
 	if (VN_CACHED(VFS_I(ip)) != 0) {
-		xfs_inval_cached_trace(ip, ioffset, -1, ioffset, -1);
 		error = xfs_flushinval_pages(ip, ioffset, -1, FI_REMAPF_LOCKED);
 		if (error)
 			goto out_unlock_iolock;
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-09-09 12:33:56.691253788 -0300
+++ xfs/fs/xfs/xfs_attr_leaf.c	2009-09-09 12:49:11.394257187 -0300
@@ -42,6 +42,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * xfs_attr_leaf.c
@@ -594,7 +595,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 	cursor = context->cursor;
 	ASSERT(cursor != NULL);
 
-	xfs_attr_trace_l_c("sf start", context);
+	trace_xfs_attr_list_sf(context);
 
 	/*
 	 * If the buffer is large enough and the cursor is at the start,
@@ -627,7 +628,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 				return error;
 			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
 		}
-		xfs_attr_trace_l_c("sf big-gulp", context);
+		trace_xfs_attr_list_sf_all(context);
 		return(0);
 	}
 
@@ -653,7 +654,6 @@ xfs_attr_shortform_list(xfs_attr_list_co
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe);
-			xfs_attr_trace_l_c("sf corrupted", context);
 			kmem_free(sbuf);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
@@ -693,7 +693,6 @@ xfs_attr_shortform_list(xfs_attr_list_co
 	}
 	if (i == nsbuf) {
 		kmem_free(sbuf);
-		xfs_attr_trace_l_c("blk end", context);
 		return(0);
 	}
 
@@ -719,7 +718,6 @@ xfs_attr_shortform_list(xfs_attr_list_co
 	}
 
 	kmem_free(sbuf);
-	xfs_attr_trace_l_c("sf E-O-F", context);
 	return(0);
 }
 
@@ -2323,7 +2321,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 	cursor = context->cursor;
 	cursor->initted = 1;
 
-	xfs_attr_trace_l_cl("blk start", context, leaf);
+	trace_xfs_attr_list_leaf(context);
 
 	/*
 	 * Re-find our place in the leaf block if this is a new syscall.
@@ -2344,7 +2342,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 			}
 		}
 		if (i == be16_to_cpu(leaf->hdr.count)) {
-			xfs_attr_trace_l_c("not found", context);
+			trace_xfs_attr_list_notfound(context);
 			return(0);
 		}
 	} else {
@@ -2419,7 +2417,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 			break;
 		cursor->offset++;
 	}
-	xfs_attr_trace_l_cl("blk end", context, leaf);
+	trace_xfs_attr_list_leaf_end(context);
 	return(retval);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
