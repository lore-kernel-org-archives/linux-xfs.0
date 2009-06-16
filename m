Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GLmLvK180532 for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 16:48:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EEAB2FF34A
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 14:48:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9cNLJkuqGFU3wUNP for
	<xfs@oss.sgi.com>; Tue, 16 Jun 2009 14:48:45 -0700 (PDT)
Date: Tue, 16 Jun 2009 17:48:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs: event tracing support
Message-ID: <20090616214844.GA12310@infradead.org>
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
Cc: Steven Rostedt <rostedt@goodmis.org>


Convert the old xfs tracing support that could only be used with the out
of tree kdb and xfsidbg patches to use the generic event tracer.

To use it make sure CONFIG_EVENT_TRACING is enabled and then enable all
xfs trace channels by:

   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

Alternatively you can also enable invivididual trace events in XFS or
even filter on them.  Take a look at Documentation/trace/events.txt
for details.  To reads the events do a

   cat /sys/kernel/debug/tracing/trace

which will give output like this:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-23195 [000] 1884167.739031: xfs_alloc_extent: dev 253:21 first agno 0 agbno 5448 minlen 1 maxlen 1 mod 0 prod 1 minleft 2 total 0 alignment 1 len 1 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 isfl 0 userdata 1 by trace_xfs_alloc_extent
           <...>-23195 [000] 1884167.739031: xfs_agf: dev 253:21 agno 0 flags FREEBLKS length 579819 roots b 1 c 2 levels b 1 c 1 flfirst 62 fllast 65 flcount 4 freeblks 574368 longest 531488 by xfs_alloc_ag_vextent
           <...>-23195 [000] 1884167.739031: xfs_buf_item: dev 253:21 BLOG bip 0xd6cb54a0 bp 0xf5a90bd8 flags |DIRTY|LOGGED recur 0 refcount 15 blkno 0x1 blen 0x200 bpflags |MAPPED|ASYNC|DONE|DELWRI|TRYLOCK|PAGE_CACHE|DELWRI_Q pincount 14 lockval 0 lidesc 0xeba5cb58 liflags IN_AIL
           <...>-23195 [000] 1884167.739032: xfs_alloc_busy: dev 253:21 notfound agno 0 agbno 5448 len 1 slot 0 by xfs_alloc_search_busy
           <...>-23195 [000] 1884167.739033: xfs_bmap: dev 253:21 ino 0x4349 pre xfs_bmap_add_extent_hole_real:LC df idx 15 offset1 67 block1 1675 count1 3773 flag1 0 offset2 0 block2 1675 count2 0 flag2 0
           <...>-23195 [000] 1884167.739033: xfs_bmap: dev 253:21 ino 0x4349 post xfs_bmap_add_extent_hole_real:LC df idx 15 offset1 67 block1 1675 count1 3774 flag1 0 offset2 0 block2 1675 count2 0 flag2 0
           <...>-23195 [000] 1884167.739035: xfs_buf: dev 253:21 got_lock hold 3 lock 0 val 0x0 offset 0x5f9000 size 0x1000 flags MAPPED|ASYNC|DONE|DELWRI|PAGE_CACHE|DELWRI_Q by xfs_buf_get_flags
           <...>-23195 [000] 1884167.739035: xfs_buf: dev 253:21 get hold 3 lock 0 val 0x14005 offset 0x5f9000 size 0x1000 flags MAPPED|ASYNC|DONE|DELWRI|PAGE_CACHE|DELWRI_Q by xfs_buf_read_flags

This patch converts most existing trace points in XFS
more or less fully to the event tracer.  Note that the infrastructure
already provides pid value (and theoretically the task name, although that's
buggy currently) so we don't have to record
them ourselves.  There also are a couple of places where we provide
information more usefull for general tracing instead of pointers for
gdb, e.g. the inode number instead of the inode pointer address.

A couple of tracers are not converted currently:

 - the log grant tracing is gone.  There was just one callsite left
   with most state changes missing, indicating severe bitrot.  I don't
   plan to re-introduce it for now.
 - the filestreams tracing is left as-is for now.  It has some very
   funky tracers covering all kinds of special cases.  If anyone cares
   enough about filestreams they should take a look.
 - the btree tracer.  Due to the different record/key types we can't
   handle it with the current tracing infrastructure.  I'm working
   with Steve to get some infrastructure to get this back.

All this gives a quite massive patch of:

     67 files changed, 1563 insertions(+), 2237 deletions(-)

So while adding actual tracing support without xfsidbg we actually
remove lots of lines of code.

I'd love to get this out and into 2.6.31 still if possible so that we
can have a tracing option out there in the field ASAP.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/Makefile
===================================================================
--- linux-2.6.orig/fs/xfs/Makefile	2009-06-16 22:37:56.088814606 +0200
+++ linux-2.6/fs/xfs/Makefile	2009-06-16 22:45:13.894814533 +0200
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-06-16 22:37:56.092814347 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-06-16 22:37:58.194969357 +0200
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
@@ -1232,7 +1191,7 @@ xfs_vm_writepage(
 	int			delalloc, unmapped, unwritten;
 	struct inode		*inode = page->mapping->host;
 
-	xfs_page_trace(XFS_WRITEPAGE_ENTER, inode, page, 0);
+	trace_xfs_page(inode, page, 0, "writepage");
 
 	/*
 	 * We need a transaction if:
@@ -1329,7 +1288,7 @@ xfs_vm_releasepage(
 		.nr_to_write = 1,
 	};
 
-	xfs_page_trace(XFS_RELEASEPAGE_ENTER, inode, page, 0);
+	trace_xfs_page(inode, page, 0, "releasepage");
 
 	if (!page_has_buffers(page))
 		return 0;
@@ -1609,8 +1568,7 @@ xfs_vm_invalidatepage(
 	struct page		*page,
 	unsigned long		offset)
 {
-	xfs_page_trace(XFS_INVALIDPAGE_ENTER,
-			page->mapping->host, page, offset);
+	trace_xfs_page(page->mapping->host, page, offset, "invalidatepage");
 	block_invalidatepage(page, offset);
 }
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-06-16 22:37:56.097814635 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2009-06-16 22:37:58.195968716 +0200
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-06-16 22:37:56.102814993 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.h	2009-06-16 22:37:58.196969053 +0200
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
+ 	{ XBF_ORDERED,		"ORDERED" }, \
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-06-16 22:37:56.106814804 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2009-06-16 22:37:58.197990761 +0200
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
+	trace_xfs_rw(ip, size, *offset, ioflags, "read");
 
 	iocb->ki_pos = *offset;
 	ret = generic_file_aio_read(iocb, iovp, segs, *offset);
@@ -294,8 +232,9 @@ xfs_splice_read(
 			return -error;
 		}
 	}
-	xfs_rw_enter_trace(XFS_SPLICE_READ_ENTER, ip,
-			   pipe, count, *ppos, ioflags);
+
+	trace_xfs_rw(ip, count, *ppos, ioflags, "splice_read");
+
 	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
@@ -344,8 +283,8 @@ xfs_splice_write(
 		ip->i_new_size = new_size;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	xfs_rw_enter_trace(XFS_SPLICE_WRITE_ENTER, ip,
-			   pipe, count, *ppos, ioflags);
+	trace_xfs_rw(ip, count, *ppos, ioflags, "splice_write");
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
+ 		trace_xfs_rw(xip, count, *offset, ioflags, "write");
 		ret = generic_file_direct_write(iocb, iovp,
 				&segs, pos, offset, count, ocount);
 
@@ -754,8 +690,7 @@ start:
 		ssize_t ret2 = 0;
 
 write_retry:
-		xfs_rw_enter_trace(XFS_WRITE_ENTER, xip, (void *)iovp, segs,
-				*offset, ioflags);
+		trace_xfs_rw(xip, count, *offset, ioflags, "write");
 		ret2 = generic_file_buffered_write(iocb, iovp, segs,
 				pos, offset, count, ret);
 		/*
@@ -860,7 +795,7 @@ int
 xfs_bdstrat_cb(struct xfs_buf *bp)
 {
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		xfs_buftrace("XFS__BDSTRAT IOERROR", bp);
+		xfs_buftrace(bp, "bdstrat_cb_shut");
 		/*
 		 * Metadata write that didn't get logged but
 		 * written delayed anyway. These aren't associated
@@ -893,7 +828,7 @@ xfsbdstrat(
 		return;
 	}
 
-	xfs_buftrace("XFSBDSTRAT IOERROR", bp);
+	xfs_buftrace(bp, "bdstrat_shut");
 	xfs_bioerror_relse(bp);
 }
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2009-06-16 22:37:56.111814253 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2009-06-16 22:37:58.198969727 +0200
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
@@ -1554,94 +1558,6 @@ static struct file_system_type xfs_fs_ty
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
 
@@ -1782,7 +1698,6 @@ init_xfs_fs(void)
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
-	ktrace_init(64);
 	xfs_ioend_init();
 	xfs_dir_startup();
 
@@ -1790,13 +1705,9 @@ init_xfs_fs(void)
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
@@ -1831,8 +1742,6 @@ init_xfs_fs(void)
 	xfs_filestream_uninit();
  out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
- out_free_trace_buffers:
-	xfs_free_trace_bufs();
  out_destroy_zones:
 	xfs_destroy_zones();
  out:
@@ -1849,9 +1758,7 @@ exit_xfs_fs(void)
 	xfs_buf_terminate();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
-	xfs_free_trace_bufs();
 	xfs_destroy_zones();
-	ktrace_uninit();
 }
 
 module_init(init_xfs_fs);
Index: linux-2.6/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_dquot.c	2009-06-16 22:37:56.168814460 +0200
+++ linux-2.6/fs/xfs/quota/xfs_dquot.c	2009-06-16 22:37:58.199972089 +0200
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
Index: linux-2.6/fs/xfs/quota/xfs_dquot.h
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_dquot.h	2009-06-16 22:37:56.172814690 +0200
+++ linux-2.6/fs/xfs/quota/xfs_dquot.h	2009-06-16 22:37:58.200967188 +0200
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
Index: linux-2.6/fs/xfs/support/ktrace.c
===================================================================
--- linux-2.6.orig/fs/xfs/support/ktrace.c	2009-06-16 22:37:56.186814867 +0200
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
Index: linux-2.6/fs/xfs/support/ktrace.h
===================================================================
--- linux-2.6.orig/fs/xfs/support/ktrace.h	2009-06-16 22:37:56.192814584 +0200
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
Index: linux-2.6/fs/xfs/xfs_alloc.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.h	2009-06-16 22:37:56.196814395 +0200
+++ linux-2.6/fs/xfs/xfs_alloc.h	2009-06-16 22:37:58.201968503 +0200
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
Index: linux-2.6/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_attr.c	2009-06-16 22:37:56.201814123 +0200
+++ linux-2.6/fs/xfs/xfs_attr.c	2009-06-16 22:37:58.202968630 +0200
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
@@ -2265,17 +2262,13 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 	return(0);
 }
 
-#if defined(XFS_ATTR_TRACE)
 /*
  * Add a trace buffer entry for an attr_list context structure.
  */
 void
 xfs_attr_trace_l_c(char *where, struct xfs_attr_list_context *context)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_C, where, context,
-		(__psunsigned_t)NULL,
-		(__psunsigned_t)NULL,
-		(__psunsigned_t)NULL);
+	trace_xfs_attr_list(XFS_ATTR_KTRACE_L_C, where, context, 0, 0, 0);
 }
 
 /*
@@ -2285,11 +2278,11 @@ void
 xfs_attr_trace_l_cn(char *where, struct xfs_attr_list_context *context,
 			 struct xfs_da_intnode *node)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CN, where, context,
-		(__psunsigned_t)be16_to_cpu(node->hdr.count),
-		(__psunsigned_t)be32_to_cpu(node->btree[0].hashval),
-		(__psunsigned_t)be32_to_cpu(node->btree[
-				    be16_to_cpu(node->hdr.count)-1].hashval));
+	trace_xfs_attr_list(XFS_ATTR_KTRACE_L_CN, where, context,
+		be16_to_cpu(node->hdr.count),
+		be32_to_cpu(node->btree[0].hashval),
+		be32_to_cpu(node->btree[
+			    be16_to_cpu(node->hdr.count)-1].hashval));
 }
 
 /*
@@ -2299,10 +2292,10 @@ void
 xfs_attr_trace_l_cb(char *where, struct xfs_attr_list_context *context,
 			  struct xfs_da_node_entry *btree)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CB, where, context,
-		(__psunsigned_t)be32_to_cpu(btree->hashval),
-		(__psunsigned_t)be32_to_cpu(btree->before),
-		(__psunsigned_t)NULL);
+	trace_xfs_attr_list(XFS_ATTR_KTRACE_L_CB, where, context,
+		be32_to_cpu(btree->hashval),
+		be32_to_cpu(btree->before),
+		0);
 }
 
 /*
@@ -2312,37 +2305,9 @@ void
 xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
 			      struct xfs_attr_leafblock *leaf)
 {
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
+	trace_xfs_attr_list(XFS_ATTR_KTRACE_L_CL, where, context,
+		be16_to_cpu(leaf->hdr.count),
+		be32_to_cpu(leaf->entries[0].hashval),
+		be32_to_cpu(leaf->entries[
+			    be16_to_cpu(leaf->hdr.count)-1].hashval));
 }
-#endif	/* XFS_ATTR_TRACE */
Index: linux-2.6/fs/xfs/xfs_attr_sf.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_attr_sf.h	2009-06-16 22:37:56.206814342 +0200
+++ linux-2.6/fs/xfs/xfs_attr_sf.h	2009-06-16 22:37:58.203991526 +0200
@@ -25,6 +25,10 @@
  * to fit into the literal area of the inode.
  */
 
+struct xfs_attr_list_context;
+struct xfs_da_intnode;
+struct xfs_da_node_entry;
+struct xfs_attr_leafblock;
 struct xfs_inode;
 
 /*
@@ -69,17 +73,9 @@ typedef struct xfs_attr_sf_sort {
 	(be16_to_cpu(((xfs_attr_shortform_t *)	\
 		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
 
-#if defined(XFS_ATTR_TRACE)
 /*
  * Kernel tracing support for attribute lists
  */
-struct xfs_attr_list_context;
-struct xfs_da_intnode;
-struct xfs_da_node_entry;
-struct xfs_attr_leafblock;
-
-#define	XFS_ATTR_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_attr_trace_buf;
 
 /*
  * Trace record types.
@@ -96,15 +92,5 @@ void xfs_attr_trace_l_cb(char *where, st
 			      struct xfs_da_node_entry *btree);
 void xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
 			      struct xfs_attr_leafblock *leaf);
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
 
 #endif	/* __XFS_ATTR_SF_H__ */
Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c	2009-06-16 22:37:56.211814350 +0200
+++ linux-2.6/fs/xfs/xfs_bmap.c	2009-06-16 22:37:58.206964670 +0200
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
@@ -398,6 +322,54 @@ xfs_bmap_disk_count_leaves(
 	int			numrecs,
 	int			*count);
 
+
+STATIC void
+xfs_bmap_trace_insert(
+	const char	*fname,		/* function name */
+	char		*desc,		/* operation description */
+	xfs_inode_t	*ip,		/* incore inode pointer */
+	xfs_extnum_t	idx,		/* index of entry(entries) inserted */
+	xfs_extnum_t	cnt,		/* count of entries inserted, 1 or 2 */
+	xfs_bmbt_irec_t	*r1,		/* inserted record 1 */
+	xfs_bmbt_irec_t	*r2,		/* inserted record 2 or null */
+	int		whichfork)	/* data or attr fork */
+{
+	trace_xfs_bmap(XFS_BMAP_KTRACE_INSERT, fname, desc, ip, idx,
+		       r1, r2, whichfork);
+}
+
+STATIC void
+xfs_bmap_trace(
+	int		op,
+	const char	*fname,		/* function name */
+	char		*desc,		/* operation description */
+	xfs_inode_t	*ip,		/* incore inode pointer */
+	xfs_extnum_t	idx,		/* index of entry(entries) deleted */
+	xfs_extnum_t	cnt,		/* count of entries deleted, 1 or 2 */
+	int		whichfork)	/* data or attr fork */
+{
+	xfs_ifork_t	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_bmbt_irec_t	r1;
+	xfs_bmbt_irec_t r2;
+
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r1);
+	if (cnt == 2)
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &r2);
+
+	trace_xfs_bmap(op, fname, desc, ip, idx, &r1,
+		       cnt == 2 ? &r2 : NULL, whichfork);
+}
+
+#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)	\
+	xfs_bmap_trace_insert(__func__,d,ip,i,c,r1,r2,w)
+#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)	\
+	xfs_bmap_trace(XFS_BMAP_KTRACE_DELETE, __func__,d,ip,i,c,w)
+#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)	\
+	xfs_bmap_trace(XFS_BMAP_KTRACE_POST_UP, __func__,d,ip,i,1,w)
+#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)	\
+	xfs_bmap_trace(XFS_BMAP_KTRACE_PRE_UP, __func__,d,ip,i,1,w)
+
+
 /*
  * Bmap internal routines.
  */
@@ -3800,158 +3772,6 @@ xfs_bmap_search_extents(
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
@@ -3983,37 +3803,6 @@ xfs_bmap_worst_indlen(
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
@@ -4702,7 +4491,7 @@ error0:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
-#ifdef XFS_BMAP_TRACE
+#ifdef DEBUG
 /*
  * Add bmap trace insert entries for all the contents of the extent records.
  */
@@ -4727,9 +4516,7 @@ xfs_bmap_trace_exlist(
 			whichfork);
 	}
 }
-#endif
 
-#ifdef DEBUG
 /*
  * Validate that the bmbt_irecs being returned from bmapi are valid
  * given the callers original parameters.  Specifically check the
@@ -5478,7 +5265,8 @@ xfs_bunmapi(
 	int			rsvd;		/* OK to allocate reserved blocks */
 	xfs_fsblock_t		sum;
 
-	xfs_bunmap_trace(ip, bno, len, flags, (inst_t *)__return_address);
+	xfs_bunmap_trace(ip, bno, len, flags);
+
 	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 		XFS_ATTR_FORK : XFS_DATA_FORK;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
Index: linux-2.6/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.h	2009-06-16 22:37:56.215815348 +0200
+++ linux-2.6/fs/xfs/xfs_bmap.h	2009-06-16 22:37:58.207971502 +0200
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
Index: linux-2.6/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap_btree.c	2009-06-16 22:37:56.220814658 +0200
+++ linux-2.6/fs/xfs/xfs_bmap_btree.c	2009-06-16 22:37:58.208964436 +0200
@@ -779,12 +779,6 @@ xfs_bmbt_trace_enter(
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
Index: linux-2.6/fs/xfs/xfs_buf_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_buf_item.c	2009-06-16 22:37:56.225814666 +0200
+++ linux-2.6/fs/xfs/xfs_buf_item.c	2009-06-16 22:37:58.209976995 +0200
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
Index: linux-2.6/fs/xfs/xfs_buf_item.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_buf_item.h	2009-06-16 22:37:56.230814535 +0200
+++ linux-2.6/fs/xfs/xfs_buf_item.h	2009-06-16 22:37:58.209976995 +0200
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
Index: linux-2.6/fs/xfs/xfs_dir2_trace.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_trace.c	2009-06-16 22:37:56.234814346 +0200
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
Index: linux-2.6/fs/xfs/xfs_dir2_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_trace.h	2009-06-16 22:37:56.238814786 +0200
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
Index: linux-2.6/fs/xfs/xfs_filestream.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_filestream.c	2009-06-16 22:37:56.243815283 +0200
+++ linux-2.6/fs/xfs/xfs_filestream.c	2009-06-16 22:37:58.211964957 +0200
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
 
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-06-16 22:37:56.247814256 +0200
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-06-16 22:37:58.211964957 +0200
@@ -43,7 +43,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_btree_trace.h"
-#include "xfs_dir2_trace.h"
+#include "xfs_trace.h"
 
 
 /*
@@ -86,27 +86,6 @@ xfs_inode_alloc(
 	xfs_inode_init_acls(ip);
 
 	/*
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
-	/*
 	* Now initialise the VFS inode. We do this after the xfs_inode
 	* initialisation as internal failures will result in ->destroy_inode
 	* being called and that will pass down through the reclaim path and
@@ -160,7 +139,7 @@ xfs_iget_cache_hit(
 			goto out_error;
 		}
 
-		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
+		xfs_itrace_tag(ip, "xfs_iget.alloc");
 
 		/*
 		 * We need to re-initialise the VFS inode as it has been
@@ -212,8 +191,8 @@ xfs_iget_cache_hit(
 		xfs_ilock(ip, lock_flags);
 
 	xfs_iflags_clear(ip, XFS_ISTALE);
-	xfs_itrace_exit_tag(ip, "xfs_iget.found");
 	XFS_STATS_INC(xs_ig_found);
+	xfs_itrace_tag(ip, "xfs_iget.found");
 	return 0;
 
 out_error:
@@ -246,7 +225,7 @@ xfs_iget_cache_miss(
 	if (error)
 		goto out_destroy;
 
-	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
+	xfs_itrace_entry(ip);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		error = ENOENT;
@@ -516,24 +495,6 @@ xfs_ireclaim(
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
 	if (ip->i_itemp) {
 		/*
 		 * Only if we are shutting down the fs will we see an
@@ -658,7 +619,7 @@ xfs_ilock(
 	else if (lock_flags & XFS_ILOCK_SHARED)
 		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 
-	xfs_ilock_trace(ip, 1, lock_flags, (inst_t *)__return_address);
+	trace_xfs_ilock(ip, "lock", lock_flags, _RET_IP_);
 }
 
 /*
@@ -703,7 +664,7 @@ xfs_ilock_nowait(
 		if (!mrtryaccess(&ip->i_lock))
 			goto out_undo_iolock;
 	}
-	xfs_ilock_trace(ip, 2, lock_flags, (inst_t *)__return_address);
+	trace_xfs_ilock(ip, "lock_nowait", lock_flags, _RET_IP_);
 	return 1;
 
  out_undo_iolock:
@@ -765,7 +726,7 @@ xfs_iunlock(
 		xfs_trans_unlocked_item(ip->i_itemp->ili_item.li_ailp,
 					(xfs_log_item_t*)(ip->i_itemp));
 	}
-	xfs_ilock_trace(ip, 3, lock_flags, (inst_t *)__return_address);
+	trace_xfs_ilock(ip, "unlock", lock_flags, _RET_IP_);
 }
 
 /*
@@ -784,6 +745,8 @@ xfs_ilock_demote(
 		mrdemote(&ip->i_lock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrdemote(&ip->i_iolock);
+
+	trace_xfs_ilock(ip, "demote", lock_flags, _RET_IP_);
 }
 
 #ifdef DEBUG
@@ -814,52 +777,3 @@ xfs_isilocked(
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
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2009-06-16 22:37:56.252814823 +0200
+++ linux-2.6/fs/xfs/xfs_inode.c	2009-06-16 22:37:58.213965422 +0200
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
@@ -1281,42 +1281,6 @@ xfs_file_last_byte(
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
@@ -1399,8 +1363,7 @@ xfs_itruncate_start(
 		return 0;
 	}
 	last_byte = xfs_file_last_byte(ip);
-	xfs_itrunc_trace(XFS_ITRUNC_START, ip, flags, new_size, toss_start,
-			 last_byte);
+	trace_xfs_itrunc(ip, flags, new_size, toss_start, last_byte, "start");
 	if (last_byte > toss_start) {
 		if (flags & XFS_ITRUNC_DEFINITE) {
 			xfs_tosspages(ip, toss_start,
@@ -1504,7 +1467,8 @@ xfs_itruncate_finish(
 		new_size = 0LL;
 	}
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	xfs_itrunc_trace(XFS_ITRUNC_FINISH1, ip, 0, new_size, 0, 0);
+	trace_xfs_itrunc(ip, 0, new_size, 0, 0, "finish1");
+
 	/*
 	 * The first thing we do is set the size to new_size permanently
 	 * on disk.  This way we don't have to worry about anyone ever
@@ -1721,7 +1685,7 @@ xfs_itruncate_finish(
 	ASSERT((new_size != 0) ||
 	       (fork == XFS_ATTR_FORK) ||
 	       (ip->i_d.di_nextents == 0));
-	xfs_itrunc_trace(XFS_ITRUNC_FINISH2, ip, 0, new_size, 0, 0);
+	trace_xfs_itrunc(ip, 0, new_size, 0, 0, "finish2");
 	return 0;
 }
 
@@ -3242,23 +3206,6 @@ corrupt_out:
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
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-06-16 22:37:56.256814425 +0200
+++ linux-2.6/fs/xfs/xfs_inode.h	2009-06-16 22:37:58.215964070 +0200
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
@@ -277,26 +269,6 @@ typedef struct xfs_inode {
 	struct posix_acl	*i_acl;
 	struct posix_acl	*i_default_acl;
 #endif
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
@@ -429,6 +401,14 @@ static inline void xfs_ifunlock(xfs_inod
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
@@ -478,6 +458,10 @@ static inline void xfs_ifunlock(xfs_inod
 #define	XFS_ITRUNC_DEFINITE	0x1
 #define	XFS_ITRUNC_MAYBE	0x2
 
+#define XFS_ITRUNC_FLAGS \
+	{ XFS_ITRUNC_DEFINITE,	"DEFINITE" }, \
+	{ XFS_ITRUNC_MAYBE,	"MAYBE" }
+
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
@@ -533,48 +517,31 @@ void		xfs_lock_two_inodes(xfs_inode_t *,
 void		xfs_synchronize_atime(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
-#if defined(XFS_INODE_TRACE)
-
-#define	INODE_TRACE_SIZE	16		/* number of trace entries */
 #define	INODE_KTRACE_ENTRY	1
 #define	INODE_KTRACE_EXIT	2
 #define	INODE_KTRACE_HOLD	3
 #define	INODE_KTRACE_REF	4
 #define	INODE_KTRACE_RELE	5
 
-extern void _xfs_itrace_entry(struct xfs_inode *, const char *, inst_t *);
-extern void _xfs_itrace_exit(struct xfs_inode *, const char *, inst_t *);
-extern void xfs_itrace_hold(struct xfs_inode *, char *, int, inst_t *);
-extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
-extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
 #define xfs_itrace_entry(ip)	\
-	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
+	trace_xfs_inode(ip, "entry", _THIS_IP_)
 #define xfs_itrace_exit(ip)	\
-	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
-#define xfs_itrace_exit_tag(ip, tag)	\
-	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
+	trace_xfs_inode(ip, "exit", _THIS_IP_)
+#define xfs_itrace_tag(ip, tag)	\
+	trace_xfs_inode((ip), (tag), _THIS_IP_);
 #define xfs_itrace_ref(ip)	\
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
+	trace_xfs_inode((ip), "ref", _THIS_IP_);
 
 #define IHOLD(ip) \
 do { \
 	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
 	atomic_inc(&(VFS_I(ip)->i_count)); \
-	xfs_itrace_hold((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	trace_xfs_inode((ip), "hold", _THIS_IP_); \
 } while (0)
 
 #define IRELE(ip) \
 do { \
-	xfs_itrace_rele((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	trace_xfs_inode((ip), "rele", _THIS_IP_); \
 	iput(VFS_I(ip)); \
 } while (0)
 
Index: linux-2.6/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iomap.c	2009-06-16 22:37:56.262814072 +0200
+++ linux-2.6/fs/xfs/xfs_iomap.c	2009-06-16 22:37:58.216972299 +0200
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
 
+	trace_xfs_iomap(ip, offset, count, flags, NULL, "enter");
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
 
@@ -237,8 +172,8 @@ xfs_iomap(
 		if (nimaps &&
 		    (imap.br_startblock != HOLESTARTBLOCK) &&
 		    (imap.br_startblock != DELAYSTARTBLOCK)) {
-			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
-					offset, count, iomapp, &imap, flags);
+			trace_xfs_iomap(ip, offset, count, flags,
+					&imap, "map_found");
 			break;
 		}
 
@@ -250,8 +185,8 @@ xfs_iomap(
 						      &imap, &nimaps);
 		}
 		if (!error) {
-			xfs_iomap_map_trace(XFS_IOMAP_ALLOC_MAP, ip,
-					offset, count, iomapp, &imap, flags);
+			trace_xfs_iomap(ip, offset, count, flags, &imap,
+					"map_allocate");
 		}
 		iomap_flags = IOMAP_NEW;
 		break;
@@ -261,8 +196,8 @@ xfs_iomap(
 		lockmode = 0;
 
 		if (nimaps && !isnullstartblock(imap.br_startblock)) {
-			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
-					offset, count, iomapp, &imap, flags);
+			trace_xfs_iomap(ip, offset, count, flags,
+					&imap, "map_found");
 			break;
 		}
 
@@ -623,8 +558,7 @@ retry:
 	 * delalloc blocks and retry without EOF preallocation.
 	 */
 	if (nimaps == 0) {
-		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_NOSPACE,
-					ip, offset, count);
+		trace_xfs_iomap(ip, offset, count, 0, NULL, "enospc");
 		if (flushed)
 			return XFS_ERROR(ENOSPC);
 
@@ -837,7 +771,7 @@ xfs_iomap_write_unwritten(
 	int		committed;
 	int		error;
 
-	xfs_iomap_enter_trace(XFS_IOMAP_UNWRITTEN, ip, offset, count);
+	trace_xfs_iomap(ip, offset, count, 0, NULL, "unwritten");
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
Index: linux-2.6/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log.c	2009-06-16 22:37:56.266814721 +0200
+++ linux-2.6/fs/xfs/xfs_log.c	2009-06-16 22:37:58.218940008 +0200
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
@@ -1030,7 +952,7 @@ xlog_iodone(xfs_buf_t *bp)
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"
 				" by device. Disabling barriers\n");
-		xfs_buftrace("XLOG_IODONE BARRIERS OFF", bp);
+		xfs_buftrace(bp, "barriers_off");
 	}
 
 	/*
@@ -1085,7 +1007,7 @@ xlog_bdstrat_cb(struct xfs_buf *bp)
 		return 0;
 	}
 
-	xfs_buftrace("XLOG__BDSTRAT IOERROR", bp);
+	xfs_buftrace(bp, "xlog_ioerror");
 	XFS_BUF_ERROR(bp, EIO);
 	XFS_BUF_STALE(bp);
 	xfs_biodone(bp);
@@ -1246,7 +1168,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	spin_lock_init(&log->l_grant_lock);
 	sv_init(&log->l_flush_wait, 0, "flush_wait");
 
-	xlog_trace_loggrant_alloc(log);
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
 
@@ -1305,8 +1226,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		sv_init(&iclog->ic_force_wait, SV_DEFAULT, "iclog-force");
 		sv_init(&iclog->ic_write_wait, SV_DEFAULT, "iclog-write");
 
-		xlog_trace_iclog_alloc(iclog);
-
 		iclogp = &iclog->ic_next;
 	}
 	*iclogp = log->l_iclog;			/* complete ring */
@@ -1321,13 +1240,11 @@ out_free_iclog:
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
@@ -1607,7 +1524,6 @@ xlog_dealloc_log(xlog_t *log)
 		sv_destroy(&iclog->ic_force_wait);
 		sv_destroy(&iclog->ic_write_wait);
 		xfs_buf_free(iclog->ic_bp);
-		xlog_trace_iclog_dealloc(iclog);
 		next_iclog = iclog->ic_next;
 		kmem_free(iclog);
 		iclog = next_iclog;
@@ -1616,7 +1532,6 @@ xlog_dealloc_log(xlog_t *log)
 	spinlock_destroy(&log->l_grant_lock);
 
 	xfs_buf_free(log->l_xbuf);
-	xlog_trace_loggrant_dealloc(log);
 	log->l_mp->m_log = NULL;
 	kmem_free(log);
 }	/* xlog_dealloc_log */
@@ -2414,7 +2329,6 @@ restart:
 
 	iclog = log->l_iclog;
 	if (iclog->ic_state != XLOG_STATE_ACTIVE) {
-		xlog_trace_iclog(iclog, XLOG_TRACE_SLEEP_FLUSH);
 		XFS_STATS_INC(xs_log_noiclogs);
 
 		/* Wait for log writes to have flushed */
Index: linux-2.6/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log_priv.h	2009-06-16 22:37:56.271814240 +0200
+++ linux-2.6/fs/xfs/xfs_log_priv.h	2009-06-16 22:37:58.219964999 +0200
@@ -19,7 +19,6 @@
 #define __XFS_LOG_PRIV_H__
 
 struct xfs_buf;
-struct ktrace;
 struct log;
 struct xlog_ticket;
 struct xfs_buf_cancel;
@@ -361,9 +360,6 @@ typedef struct xlog_in_core {
 	int			ic_bwritecnt;
 	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*ic_trace;
-#endif
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
@@ -429,10 +425,6 @@ typedef struct log {
 	int			l_grant_write_cycle;
 	int			l_grant_write_bytes;
 
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*l_grant_trace;
-#endif
-
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
@@ -458,12 +450,6 @@ extern void	 xlog_put_bp(struct xfs_buf 
 
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2009-06-16 22:37:58.220964568 +0200
@@ -0,0 +1,1035 @@
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
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM xfs
+
+char *xfs_fmtfsblock(xfs_fsblock_t bno);
+void xfs_count_page_state(struct page *page, int *delalloc,
+		int *unmapped, int *unwritten);
+
+
+/*
+ * Trace attr_list operations.
+ *
+ * XXX: Not updated to actually do anything with the different subtypes yet.
+ */
+TRACE_EVENT(xfs_attr_list,
+	TP_PROTO(int type, char *where, struct xfs_attr_list_context *ctx,
+		 unsigned long a13, unsigned long a14, unsigned long a15),
+	TP_ARGS(type, where, ctx, a13, a14, a15),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, type)
+		__field(char *, where)
+		__field(u32, hashval)
+		__field(u32, blkno)
+		__field(u32, offset)
+		__field(void *, alist)
+		__field(int, bufsize)
+		__field(int, count)
+		__field(int, firstu)
+		__field(int, dupcnt)
+		__field(int, flags)
+		__field(unsigned long, a13)
+		__field(unsigned long, a14)
+		__field(unsigned long, a15)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
+		__entry->ino = ctx->dp->i_ino;
+		__entry->type = type;
+		__entry->where = where;
+		__entry->hashval = ctx->cursor->hashval;
+		__entry->blkno = ctx->cursor->blkno;
+		__entry->offset = ctx->cursor->offset;
+		__entry->alist = ctx->alist;
+		__entry->bufsize = ctx->bufsize;
+		__entry->count = ctx->count;
+		__entry->firstu = ctx->firstu;
+		__entry->flags = ctx->flags;
+		__entry->a13 = a13;
+		__entry->a14 = a14;
+		__entry->a15 = a15;
+	),
+
+	TP_printk("dev %d:%d ino %llx %s cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
+		  "alist 0x%p size %u count %u firstu %u flags %d %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->ino,
+		   __entry->where,
+		   __entry->hashval,
+		   __entry->blkno,
+		   __entry->offset,
+		   __entry->dupcnt,
+		   __entry->alist,
+		   __entry->bufsize,
+		   __entry->count,
+		   __entry->firstu,
+		   __entry->flags,
+	 	   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
+		   /* we currently miss out on the per-type a13/14/15 here */
+	)
+);
+
+/*
+ * Trace block mappings.
+ *
+ * r2 may be NULL if there is just one extent to trace.
+ */
+TRACE_EVENT(xfs_bmap,
+	TP_PROTO(int opcode, const char *fname, const char *desc,
+		 struct xfs_inode *ip, xfs_extnum_t idx,
+		 struct xfs_bmbt_irec *r1, struct xfs_bmbt_irec *r2,
+		 int whichfork),
+	TP_ARGS(opcode, fname, desc, ip, idx, r1, r2, whichfork),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(short, opcode)
+		__field(short, whichfork)
+		__field(const char *, fname)
+		__field(const char *, desc)
+		__field(xfs_extnum_t, idx)
+		__field(xfs_fileoff_t, r1_startoff)
+		__field(xfs_fsblock_t, r1_startblock)
+		__field(xfs_filblks_t, r1_blockcount)
+		__field(xfs_exntst_t, r1_state)
+		__field(xfs_fileoff_t, r2_startoff)
+		__field(xfs_fsblock_t, r2_startblock)
+		__field(xfs_filblks_t, r2_blockcount)
+		__field(xfs_exntst_t, r2_state)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->opcode = opcode;
+		__entry->whichfork = whichfork;
+		__entry->fname = fname;
+		__entry->desc = desc;
+		__entry->idx = idx;
+		__entry->r1_startoff = r1->br_startoff;
+		__entry->r1_startblock = r1->br_startblock;
+		__entry->r1_blockcount = r1->br_blockcount;
+		__entry->r1_state = r1->br_state;
+		__entry->r2_startoff = r2 ? r2->br_startoff : 0;
+		__entry->r2_startblock = r2 ? r2->br_startblock : 0;
+		__entry->r2_blockcount = r2 ? r2->br_blockcount : 0;
+		__entry->r2_state = r2 ? r2->br_state : 0;
+	),
+
+	TP_printk("dev %d:%d ino 0x%lld %s %s:%s %cf idx %ld "
+		  "offset1 %lld block1 %s count1 %lld flag1 %d "
+		  "offset2 %lld block2 %s count2 %lld flag2 %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->opcode, XFS_BMAP_KTRACE_TYPES),
+		  __entry->fname,
+		  __entry->desc,
+		  "da"[!!__entry->whichfork],
+		  (long)__entry->idx,
+		  __entry->r1_startoff,
+		  xfs_fmtfsblock(__entry->r1_startblock),
+		  __entry->r1_blockcount,
+		  __entry->r1_state,
+		  __entry->r2_startoff,
+		  xfs_fmtfsblock(__entry->r2_startblock),
+		  __entry->r2_blockcount,
+		  __entry->r2_state)
+);
+
+/*
+ * Trace lots of strategic buffer points.
+ */
+TRACE_EVENT(xfs_buf,
+	TP_PROTO(struct xfs_buf *bp, char *id, unsigned long val,
+		 unsigned long caller_ip),
+	TP_ARGS(bp, id, val, caller_ip),
+
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
+
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
+
+	TP_printk("dev %d:%d %s hold %d lock %d val 0x%lx "
+		  "offset 0x%llx size 0x%zx flags %s by %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->id,
+		  __entry->hold,
+		  __entry->lockval,
+		  __entry->val,
+                  (unsigned long long)__entry->file_offset,
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
+
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
+
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
+
+	TP_printk("dev %d:%d %s bip 0x%p bp 0x%p flags %s recur %d refcount %d "
+		  "blkno 0x%llx blen 0x%x bpflags %s pincount %d "
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
+/*
+ * dquot tracer.
+ *
+ * Dump relevant information from the dquot structure in strategic places.
+ *
+ * XXX: figure out why id is 0 so often.
+ */
+TRACE_EVENT(xfs_dquot,
+	TP_PROTO(struct xfs_dquot *dqp, char *func, struct xfs_inode *ip),
+	TP_ARGS(dqp, func, ip),
+
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
+
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
+
+	TP_printk("dev %d:%d ino 0x%llx id 0x%x %s flags %s nrefs %u res_bc 0x%llx "
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
+/*
+ * ilock/iolock tracer
+ *
+ * Reports the inode, operation, flags and caller for each operation
+ * on the inode locks.
+ */
+TRACE_EVENT(xfs_ilock,
+	TP_PROTO(struct xfs_inode *ip, const char *op, unsigned lockflags,
+		 unsigned long caller_ip),
+	TP_ARGS(ip, op, lockflags, caller_ip),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(const char *, op)
+		__field(int, lockflags)
+		__field(unsigned long, caller_ip)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->op = op;
+		__entry->lockflags = lockflags;
+		__entry->caller_ip = caller_ip;
+	),
+
+	TP_printk("dev %d:%d ino 0x%lld %s %s by %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->op,
+		  __print_flags(__entry->lockflags, "|", XFS_LOCK_FLAGS),
+		  (void *)__entry->caller_ip)
+);
+
+/*
+ * Trace relevant inode operations.
+ *
+ * XXX: merge with the ilock tracer??
+ */
+TRACE_EVENT(xfs_inode,
+	TP_PROTO(struct xfs_inode *ip, const char *op, unsigned long caller_ip),
+	TP_ARGS(ip, op, caller_ip),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(const char *, op)
+		__field(unsigned long, caller_ip)
+		__field(int, icount)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->op = op;
+		__entry->caller_ip = caller_ip;
+		__entry->icount = atomic_read(&VFS_I(ip)->i_count);
+	),
+
+	TP_printk("dev %d:%d ino 0x%llx %s count %d by %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->op,
+		  __entry->icount,
+		  (char *)__entry->caller_ip)
+);
+
+/*
+ * Trace log grants.
+ *
+ * XXX: string argument is rather unstructured
+ */
+TRACE_EVENT(xfs_loggrant,
+	TP_PROTO(struct log *log, struct xlog_ticket *tic, char *string),
+	TP_ARGS(log, tic, string),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(char *, string)
+		__field(unsigned, trans_type)
+		__field(char, ocnt)
+		__field(char, cnt)
+		__field(int, curr_res)
+		__field(int, unit_res)
+		__field(void *, reserve_headq)
+		__field(void *, write_headq)
+		__field(int, grant_reserve_cycle)
+		__field(int, grant_reserve_bytes)
+		__field(int, grant_write_cycle)
+		__field(int, grant_write_bytes)
+		__field(int, curr_cycle)
+		__field(int, curr_block)
+		__field(xfs_lsn_t, tail_lsn)
+	),
+
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->string = string;
+		__entry->trans_type = tic->t_trans_type;
+		__entry->ocnt = tic->t_ocnt;
+		__entry->cnt = tic->t_cnt;
+		__entry->curr_res = tic->t_curr_res;
+		__entry->unit_res = tic->t_unit_res;
+		__entry->reserve_headq = log->l_reserve_headq;
+		__entry->write_headq = log->l_write_headq;
+		__entry->grant_reserve_cycle = log->l_grant_reserve_cycle;
+		__entry->grant_reserve_bytes = log->l_grant_reserve_bytes;
+		__entry->grant_write_cycle = log->l_grant_write_cycle;
+		__entry->grant_write_bytes = log->l_grant_write_bytes;
+		__entry->curr_cycle = log->l_curr_cycle;
+		__entry->curr_block = log->l_curr_block;
+		__entry->tail_lsn = log->l_tail_lsn;
+	),
+
+	TP_printk("dev %d:%d %s %s t_ocnt %u t_cnt %u t_curr_res %u t_unit_res %u "
+		  "reserve_headq 0x%p write_headq 0x%p grant_reserve_cycle %d "
+		  "grant_reserve_bytes %d grant_write_cycle %d "
+		  "grant_write_bytes %d curr_cycle %d curr_block %d "
+		  "tail_cycle %d tail_block %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->string,
+		  __print_symbolic(__entry->trans_type, XFS_TRANS_TYPES),
+		  __entry->ocnt,
+		  __entry->cnt,
+		  __entry->curr_res,
+		  __entry->unit_res,
+		  __entry->reserve_headq,
+		  __entry->write_headq,
+		  __entry->grant_reserve_cycle,
+		  __entry->grant_reserve_bytes,
+		  __entry->grant_write_cycle,
+		  __entry->grant_write_bytes,
+		  __entry->curr_cycle,
+		  __entry->curr_block,
+		  CYCLE_LSN(__entry->tail_lsn),
+		  BLOCK_LSN(__entry->tail_lsn)
+	)
+);
+
+#define xlog_trace_loggrant(log, tic, str) \
+	trace_xfs_loggrant((log), (tic), (str))
+
+/*
+ * Trace read/write/splice.
+ */
+TRACE_EVENT(xfs_rw,
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset,
+		 int ioflags, const char *op),
+	TP_ARGS(ip, count, offset, ioflags, op),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fsize_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+		__field(int, ioflags)
+		__field(const char *, op)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->op = op;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+		__entry->ioflags = ioflags;
+	),
+
+	TP_printk("dev %d:%d ino 0x%llx %s size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count 0x%zx ioflags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->op,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count,
+		  __print_flags(__entry->ioflags, "|", XFS_IO_FLAGS))
+);
+
+/*
+ * Trace addres space operations
+ */
+TRACE_EVENT(xfs_page,
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long offset,
+		 const char *op),
+	TP_ARGS(inode, page, offset, op),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(pgoff_t, pgoff)
+		__field(loff_t, size)
+		__field(unsigned long, offset)
+		__field(int, delalloc)
+		__field(int, unmapped)
+		__field(int, unwritten)
+		__field(const char *, op)
+	),
+
+	TP_fast_assign(
+		int delalloc = -1, unmapped = -1, unwritten = -1;
+
+		if (page_has_buffers(page))
+			xfs_count_page_state(page, &delalloc,
+					     &unmapped, &unwritten);
+
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = XFS_I(inode)->i_ino;
+		__entry->op = op;
+		__entry->pgoff = page_offset(page);
+		__entry->size = i_size_read(inode);
+		__entry->offset = offset;
+		__entry->delalloc = delalloc;
+		__entry->unmapped = unmapped;
+		__entry->unwritten = unwritten;
+	),
+
+	TP_printk("dev %d:%d ino 0x%llx %s pgoff 0x%lx size 0x%llx offset %lx "
+		  "delalloc %d unmapped %d unwritten %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->op,
+		  __entry->pgoff,
+		  __entry->size,
+		  __entry->offset,
+		  __entry->delalloc,
+		  __entry->unmapped,
+		  __entry->unwritten)
+);
+
+TRACE_EVENT(xfs_iomap,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
+		 int flags, struct xfs_bmbt_irec *irec, const char *op),
+	TP_ARGS(ip, offset, count, flags, irec, op),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(const char *, op)
+		__field(loff_t, size)
+		__field(loff_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+		__field(int, flags)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->op = op;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+		__entry->flags = flags;
+		__entry->startoff = irec ? irec->br_startoff : 0;
+		__entry->startblock = irec ? irec->br_startblock : 0;
+		__entry->blockcount = irec ? irec->br_blockcount : 0;
+
+	),
+
+	TP_printk("dev %d:%d ino 0x%llx %s size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count 0x%x flags %s "
+		  "startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->op,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count,
+		  __print_flags(__entry->flags, "|", BMAPI_FLAGS),
+		  __entry->startoff,
+		  __entry->startblock,
+		  __entry->blockcount)
+);
+
+TRACE_EVENT(xfs_itrunc,
+	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size, int flag,
+		 xfs_off_t toss_start, xfs_off_t toss_finish, const char *op),
+	TP_ARGS(ip, new_size, flag, toss_start, toss_finish, op),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fsize_t, new_size)
+		__field(xfs_off_t, toss_start)
+		__field(xfs_off_t, toss_finish)
+		__field(const char *, op)
+		__field(int, flag)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = new_size;
+		__entry->toss_start = toss_start;
+		__entry->toss_finish = toss_finish;
+		__entry->op = op;
+		__entry->flag = flag;
+	),
+
+	TP_printk("dev %d:%d ino 0x%llx %s %s size 0x%llx new_size 0x%llx "
+		  "toss start 0x%llx toss finish 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->op,
+		  __print_flags(__entry->flag, "|", XFS_ITRUNC_FLAGS),
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->toss_start,
+		  __entry->toss_finish)
+);
+
+TRACE_EVENT(xfs_pagecache_inval,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
+	TP_ARGS(ip, start, finish),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_off_t, start)
+		__field(xfs_off_t, finish)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->start = start;
+		__entry->finish = finish;
+	),
+
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
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fileoff_t, bno)
+		__field(xfs_filblks_t, len)
+		__field(unsigned long, caller_ip)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->caller_ip = caller_ip;
+		__entry->flags = flags;
+	),
+
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
+		  "flags %s by %pf",
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
+/* XXX: better even description instead of caller_ip + op?? */
+TRACE_EVENT(xfs_alloc_busy,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, int slot, const char *op),
+	TP_ARGS(mp, agno, agbno, len, slot, op),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(const char *, op)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int, slot)
+		__field(unsigned long, caller_ip)
+	),
+
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->op = op;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->slot = slot;
+		__entry->caller_ip = _RET_IP_;
+	),
+
+	TP_printk("dev %d:%d %s agno %u agbno %u len %u slot %d by %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->slot,
+		  (void *)__entry->caller_ip)
+
+);
+#define	xfs_trace_alloc_busy(mp, ag, agb, l, sl, op)	\
+	trace_xfs_alloc_busy(mp, ag, agb, l, sl, op)
+#define	xfs_trace_alloc_unbusy(mp, ag, sl, op)	\
+	trace_xfs_alloc_busy(mp, ag, -1, -1, sl, op)
+#define	xfs_trace_alloc_busysearch(mp, ag, agb, l, op)	\
+	trace_xfs_alloc_busy(mp, ag, agb, l, 0, op)
+
+/*
+ * Trace modifications to the AG freelist headers.
+ *
+ * XXX: maybe move to a single caller in xfs_alloc_log_agf?
+ */
+TRACE_EVENT(xfs_agf,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags),
+	TP_ARGS(mp, agf, flags),
+
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
+
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = be32_to_cpu(agf->agf_seqno),
+		__entry->flags = flags;
+		__entry->length = be32_to_cpu(agf->agf_length),
+		__entry->bno_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
+		__entry->cnt_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
+		__entry->bno_level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+		__entry->cnt_level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		__entry->flfirst = be32_to_cpu(agf->agf_flfirst),
+		__entry->fllast = be32_to_cpu(agf->agf_fllast),
+		__entry->flcount = be32_to_cpu(agf->agf_flcount),
+		__entry->freeblks = be32_to_cpu(agf->agf_freeblks),
+		__entry->longest = be32_to_cpu(agf->agf_longest);
+		__entry->caller_ip = _RET_IP_;
+	),
+
+	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
+		  "levels b %u c %u flfirst %u fllast %u flcount %u "
+		  "freeblks %u longest %u by %pf",
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
+	trace_xfs_agf(mp, agf, flags)
+
+TRACE_EVENT(xfs_free_extent,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, bool isfl, int haveleft, int haveright),
+	TP_ARGS(mp, agno, agbno, len, isfl, haveleft, haveright),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int, isfl)
+		__field(int, haveleft)
+		__field(int, haveright)
+	),
+
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->isfl = isfl;
+		__entry->haveleft = haveleft;
+		__entry->haveright = haveright;
+	),
+
+	TP_printk("dev %d:%d agno %u agbno %u len %u isfl %d %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->isfl,
+		  __entry->haveleft ?
+		  	(__entry->haveright ? "both" : "left") :
+			 (__entry->haveright ? "right" : "none"))
+
+);
+
+TRACE_EVENT(xfs_alloc_extent,
+	TP_PROTO(struct xfs_alloc_arg *args, char *op),
+	TP_ARGS(args, op),
+
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
+		__field(xfs_extlen_t, len)
+		__field(short, type)
+		__field(short, otype)
+		__field(char, wasdel)
+		__field(char, wasfromfl)
+		__field(char, isfl)
+		__field(char, userdata)
+		__field(const char *, op)
+		__field(unsigned long, caller_ip)
+	),
+
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
+		// minalignslop?
+		__entry->len = args->len;
+		__entry->type = args->type;
+		__entry->otype = args->otype;
+		__entry->wasdel = args->wasdel;
+		__entry->wasfromfl = args->wasfromfl;
+		__entry->isfl = args->isfl;
+		__entry->userdata = args->userdata;
+		// firstblock?
+		__entry->op = op;
+		__entry->caller_ip = _RET_IP_;
+	),
+
+	TP_printk("dev %d:%d %s agno %u agbno %u minlen %u maxlen %u mod %u prod %u "
+		  "minleft %u total %u alignment %u len %u type %s otype %s "
+		  "wasdel %d wasfromfl %d isfl %d userdata %d by %pf",
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
+		  __entry->len,
+		  __print_symbolic(__entry->type, XFS_ALLOC_TYPES),
+		  __print_symbolic(__entry->otype, XFS_ALLOC_TYPES),
+		  __entry->wasdel,
+		  __entry->wasfromfl,
+		  __entry->isfl,
+		  __entry->userdata,
+		  (char *)__entry->caller_ip)
+);
+
+#define xfs_trace_alloc_extent(args, str) \
+	trace_xfs_alloc_extent(args, str)
+
+TRACE_EVENT(xfs_dir2,
+	TP_PROTO(struct xfs_da_args *args, int i, int j, int count),
+	TP_ARGS(args, i, j, count),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__dynamic_array(char, name, args->namelen)
+		__field(int, namelen)
+		__field(xfs_dahash_t, hashval)
+		__field(xfs_ino_t, inumber)
+		__field(int, op_flags)
+		__field(int, i)
+		__field(int, j)
+		__field(int, count)
+		__field(unsigned long, caller_ip)
+	),
+
+	TP_fast_assign(
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
+		__entry->ino = args->dp->i_ino;
+		if (args->namelen)
+			memcpy(__get_str(name), args->name, args->namelen);
+		__entry->namelen = args->namelen;
+		__entry->hashval = args->hashval;
+		__entry->inumber = args->inumber;
+		__entry->op_flags = args->op_flags;
+		__entry->i = i;
+		__entry->j = j;
+		__entry->count = count;
+		__entry->caller_ip = _RET_IP_;
+	),
+
+	TP_printk("dev %d:%d ino 0x%lld %pf name %.*s namelen %d hashval 0x%x "
+		  "inumber 0x%llx op_flags %s i %d j %d count %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  (void *)__entry->caller_ip,
+		  __entry->namelen,
+		  __entry->namelen ? __get_str(name) : NULL,
+		  __entry->namelen,
+		  __entry->hashval,
+		  __entry->inumber,
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->i,
+		  __entry->j,
+		  __entry->count)
+);
+
+#define __xfs_trace_dir2(args, i, j, count) \
+	trace_xfs_dir2((args), (i), (j), (count))
+#define xfs_trace_dir2(args) \
+	trace_xfs_dir2((args), 0, 0, 0)
+
+#endif /* _TRACE_XFS_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE xfs_trace
+#include <trace/define_trace.h>
Index: linux-2.6/fs/xfs/xfs.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs.h	2009-06-16 22:37:56.275814820 +0200
+++ linux-2.6/fs/xfs/xfs.h	2009-06-16 22:37:58.221955126 +0200
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
Index: linux-2.6/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm.c	2009-06-16 22:37:56.177814628 +0200
+++ linux-2.6/fs/xfs/quota/xfs_qm.c	2009-06-16 22:37:58.222964962 +0200
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
Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-06-16 22:37:56.182815196 +0200
+++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c	2009-06-16 22:37:58.223966276 +0200
@@ -49,6 +49,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_qm.h"
+#include "xfs_trace.h"
 
 #ifdef DEBUG
 # define qdprintk(s, args...)	cmn_err(CE_DEBUG, s, ## args)
Index: linux-2.6/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.c	2009-06-16 22:37:56.280813920 +0200
+++ linux-2.6/fs/xfs/xfs_btree.c	2009-06-16 22:37:58.225964785 +0200
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
 		XFS_ERROR_REPORT("xfs_btree_check_sblock", XFS_ERRLEVEL_LOW,
 				 cur->bc_mp);
 		return XFS_ERROR(EFSCORRUPTED);
Index: linux-2.6/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_da_btree.c	2009-06-16 22:37:56.285814697 +0200
+++ linux-2.6/fs/xfs/xfs_da_btree.c	2009-06-16 22:37:58.227972862 +0200
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
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c	2009-06-16 22:37:56.290814565 +0200
+++ linux-2.6/fs/xfs/xfs_inode_item.c	2009-06-16 22:37:58.229964596 +0200
@@ -41,6 +41,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_rw.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
@@ -806,7 +807,7 @@ xfs_inode_item_pushbuf(
 				  !completion_done(&ip->i_flush));
 			iip->ili_pushbuf_flag = 0;
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			xfs_buftrace("INODE ITEM PUSH", bp);
+			xfs_buftrace(bp, "inode_item_push");
 			if (XFS_BUF_ISPINNED(bp)) {
 				xfs_log_force(mp, (xfs_lsn_t)0,
 					      XFS_LOG_FORCE);
Index: linux-2.6/fs/xfs/xfs_rw.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rw.c	2009-06-16 22:37:56.294814446 +0200
+++ linux-2.6/fs/xfs/xfs_rw.c	2009-06-16 22:37:58.230970311 +0200
@@ -44,6 +44,7 @@
 #include "xfs_error.h"
 #include "xfs_buf_item.h"
 #include "xfs_rw.h"
+#include "xfs_trace.h"
 
 /*
  * This is a subroutine for xfs_write() and other writers (xfs_ioctl)
@@ -255,7 +256,6 @@ xfs_bioerror(
 	 * No need to wait until the buffer is unpinned.
 	 * We aren't flushing it.
 	 */
-	xfs_buftrace("XFS IOERROR", bp);
 	XFS_BUF_ERROR(bp, EIO);
 	/*
 	 * We're calling biodone, so delete B_DONE flag. Either way
@@ -289,7 +289,6 @@ xfs_bioerror_relse(
 	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xfs_buf_iodone_callbacks);
 	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xlog_iodone);
 
-	xfs_buftrace("XFS IOERRELSE", bp);
 	fl = XFS_BUF_BFLAGS(bp);
 	/*
 	 * No need to wait until the buffer is unpinned.
Index: linux-2.6/fs/xfs/xfs_trans_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_trans_buf.c	2009-06-16 22:37:56.299814524 +0200
+++ linux-2.6/fs/xfs/xfs_trans_buf.c	2009-06-16 22:37:58.231964222 +0200
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
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.h	2009-06-16 22:37:56.120814701 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.h	2009-06-16 22:37:58.231964222 +0200
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
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-06-16 22:37:56.124814373 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2009-06-16 22:37:58.232964210 +0200
@@ -51,6 +51,7 @@
 #include "xfs_quota.h"
 #include "xfs_inode_item.h"
 #include "xfs_export.h"
+#include "xfs_trace.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-06-16 22:37:56.144814546 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2009-06-16 22:37:58.233964687 +0200
@@ -48,6 +48,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
Index: linux-2.6/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dfrag.c	2009-06-16 22:37:56.303814475 +0200
+++ linux-2.6/fs/xfs/xfs_dfrag.c	2009-06-16 22:37:58.233964687 +0200
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
Index: linux-2.6/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2.c	2009-06-16 22:37:56.308814693 +0200
+++ linux-2.6/fs/xfs/xfs_dir2.c	2009-06-16 22:37:58.234964744 +0200
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
+	__xfs_trace_dir2(args, space, 0, 0);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -703,7 +704,8 @@ xfs_dir2_shrink_inode(
 	xfs_mount_t	*mp;
 	xfs_trans_t	*tp;
 
-	xfs_dir2_trace_args_db("shrink_inode", args, db, bp);
+	__xfs_trace_dir2(args, db, 0, 0);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
Index: linux-2.6/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log_recover.c	2009-06-16 22:37:56.313814631 +0200
+++ linux-2.6/fs/xfs/xfs_log_recover.c	2009-06-16 22:37:58.236963323 +0200
@@ -46,6 +46,7 @@
 #include "xfs_quota.h"
 #include "xfs_rw.h"
 #include "xfs_utils.h"
+#include "xfs_trace.h"
 
 STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
 STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2009-06-16 22:37:56.318814709 +0200
+++ linux-2.6/fs/xfs/xfs_mount.c	2009-06-16 22:37:58.238940390 +0200
@@ -44,6 +44,8 @@
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
+#include "xfs_trace.h"
+
 
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
 
Index: linux-2.6/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rename.c	2009-06-16 22:37:56.323814648 +0200
+++ linux-2.6/fs/xfs/xfs_rename.c	2009-06-16 22:37:58.239964822 +0200
@@ -39,6 +39,7 @@
 #include "xfs_utils.h"
 #include "xfs_trans_space.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 
 /*
Index: linux-2.6/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rtalloc.c	2009-06-16 22:37:56.327814668 +0200
+++ linux-2.6/fs/xfs/xfs_rtalloc.c	2009-06-16 22:37:58.241964029 +0200
@@ -45,6 +45,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
+#include "xfs_trace.h"
 
 
 /*
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-06-16 22:37:56.332814607 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-06-16 22:37:58.243968754 +0200
@@ -53,6 +53,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 
 int
 xfs_setattr(
@@ -2877,7 +2878,6 @@ xfs_free_file_space(
 	ioffset = offset & ~(rounding - 1);
 
 	if (VN_CACHED(VFS_I(ip)) != 0) {
-		xfs_inval_cached_trace(ip, ioffset, -1, ioffset, -1);
 		error = xfs_flushinval_pages(ip, ioffset, -1, FI_REMAPF_LOCKED);
 		if (error)
 			goto out_unlock_iolock;
Index: linux-2.6/fs/xfs/xfs_btree_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree_trace.h	2009-06-16 22:37:56.336814139 +0200
+++ linux-2.6/fs/xfs/xfs_btree_trace.h	2009-06-16 22:37:58.244972932 +0200
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.h	2009-06-16 22:37:56.148814566 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.h	2009-06-16 22:37:58.245981510 +0200
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-06-16 22:37:56.153816809 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h	2009-06-16 22:37:58.245981510 +0200
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
Index: linux-2.6/fs/xfs/xfs_attr.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_attr.h	2009-06-16 22:37:56.342814833 +0200
+++ linux-2.6/fs/xfs/xfs_attr.h	2009-06-16 22:37:58.246939105 +0200
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
Index: linux-2.6/fs/xfs/xfs_iomap.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iomap.h	2009-06-16 22:37:56.346814854 +0200
+++ linux-2.6/fs/xfs/xfs_iomap.h	2009-06-16 22:37:58.246939105 +0200
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
Index: linux-2.6/fs/xfs/xfs_quota.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_quota.h	2009-06-16 22:37:56.351814443 +0200
+++ linux-2.6/fs/xfs/xfs_quota.h	2009-06-16 22:37:58.247965422 +0200
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
Index: linux-2.6/fs/xfs/xfs_trans.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_trans.h	2009-06-16 22:37:56.356814591 +0200
+++ linux-2.6/fs/xfs/xfs_trans.h	2009-06-16 22:37:58.248969810 +0200
@@ -100,6 +100,50 @@ typedef struct xfs_trans_header {
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
+	{ XFS_TRANS_WRITE_SYNC,		"WRITE_SYNC" }, \
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
+  	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+ 	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+ 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+ 	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+
 /*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
@@ -782,6 +826,10 @@ typedef struct xfs_log_item {
 #define	XFS_LI_IN_AIL	0x1
 #define XFS_LI_ABORTED	0x2
 
+#define XFS_LI_FLAGS \
+	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
+	{ XFS_LI_ABORTED,	"ABORTED" }
+
 typedef struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
Index: linux-2.6/fs/xfs/xfs_error.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_error.c	2009-06-16 22:37:56.360814332 +0200
+++ linux-2.6/fs/xfs/xfs_error.c	2009-06-16 22:37:58.248969810 +0200
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
+		sprintf(rval, "NULLSTARTBLOCK(%Ld)", startblockval(bno));
+	else
+		sprintf(rval, "%Ld", (xfs_dfsbno_t)bno);
+	return rval;
+}
Index: linux-2.6/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2009-06-16 22:37:56.158815561 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_fs_subr.c	2009-06-16 22:37:58.249963302 +0200
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
Index: linux-2.6/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_ag.h	2009-06-16 22:37:56.365814061 +0200
+++ linux-2.6/fs/xfs/xfs_ag.h	2009-06-16 22:37:58.249963302 +0200
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
Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c	2009-06-16 22:37:56.370814628 +0200
+++ linux-2.6/fs/xfs/xfs_alloc.c	2009-06-16 22:37:58.251964256 +0200
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
+//	trace_xfs_free_extent(agno, bno, len, isfl, "error");
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
@@ -2645,13 +2506,13 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 	if (n < XFS_PAGB_NUM_SLOTS) {
 		bsy = &mp->m_perag[agno].pagb_list[n];
 		mp->m_perag[agno].pagb_count++;
-		TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, n, tp);
+		xfs_trace_alloc_busy(mp, agno, bno, len, n, "got");
 		bsy->busy_start = bno;
 		bsy->busy_length = len;
 		bsy->busy_tp = tp;
 		xfs_trans_add_busy(tp, agno, n);
 	} else {
-		TRACE_BUSY("xfs_alloc_mark_busy", "FULL", agno, bno, len, -1, tp);
+		xfs_trace_alloc_busy(mp, agno, bno, len, -1, "full");
 		/*
 		 * The busy list is full!  Since it is now not possible to
 		 * track the free block, make this a synchronous transaction
@@ -2679,11 +2540,11 @@ xfs_alloc_clear_busy(xfs_trans_t *tp,
 
 	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
 	if (list[idx].busy_tp == tp) {
-		TRACE_UNBUSY("xfs_alloc_clear_busy", "found", agno, idx, tp);
+		xfs_trace_alloc_unbusy(mp, agno, idx, "found");
 		list[idx].busy_tp = NULL;
 		mp->m_perag[agno].pagb_count--;
 	} else {
-		TRACE_UNBUSY("xfs_alloc_clear_busy", "missing", agno, idx, tp);
+		xfs_trace_alloc_unbusy(mp, agno, idx, "missing");
 	}
 
 	spin_unlock(&mp->m_perag[agno].pagb_lock);
@@ -2724,8 +2585,8 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 			if ((bno > bend) || (uend < bsy->busy_start)) {
 				cnt--;
 			} else {
-				TRACE_BUSYSEARCH("xfs_alloc_search_busy",
-					 "found1", agno, bno, len, tp);
+				xfs_trace_alloc_busysearch(mp, agno, bno, len,
+							   "found1");
 				break;
 			}
 		}
@@ -2736,12 +2597,12 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	 * transaction that freed the block
 	 */
 	if (cnt) {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
+		xfs_trace_alloc_busysearch(mp, agno, bno, len, "found");
 		lsn = bsy->busy_tp->t_commit_lsn;
 		spin_unlock(&mp->m_perag[agno].pagb_lock);
 		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
 	} else {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
+		xfs_trace_alloc_busysearch(mp, agno, bno, len, "notfound");
 		spin_unlock(&mp->m_perag[agno].pagb_lock);
 	}
 }
Index: linux-2.6/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc_btree.c	2009-06-16 22:37:56.375814776 +0200
+++ linux-2.6/fs/xfs/xfs_alloc_btree.c	2009-06-16 22:37:58.253973171 +0200
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
 
Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c	2009-06-16 22:37:56.379814517 +0200
+++ linux-2.6/fs/xfs/xfs_fsops.c	2009-06-16 22:37:58.254967851 +0200
@@ -45,6 +45,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rw.h"
 #include "xfs_filestream.h"
+#include "xfs_trace.h"
 
 /*
  * File system operations
@@ -336,6 +337,8 @@ xfs_growfs_data_private(
 		be32_add_cpu(&agf->agf_length, new);
 		ASSERT(be32_to_cpu(agf->agf_length) ==
 		       be32_to_cpu(agi->agi_length));
+
+		xfs_trace_agf(mp, agf, XFS_AGF_LENGTH);
 		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
 		/*
 		 * Free the new space.
Index: linux-2.6/fs/xfs/xfs_da_btree.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_da_btree.h	2009-06-16 22:37:56.384814596 +0200
+++ linux-2.6/fs/xfs/xfs_da_btree.h	2009-06-16 22:37:58.255971889 +0200
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
Index: linux-2.6/fs/xfs/xfs_dir2_block.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_block.c	2009-06-16 22:37:56.388814616 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_block.c	2009-06-16 22:37:58.256955394 +0200
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
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -590,7 +591,8 @@ xfs_dir2_block_lookup(
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
-	xfs_dir2_trace_args("block_lookup", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Get the buffer, look up the entry.
 	 * If not found (ENOENT) then return, have no buffer.
@@ -747,7 +749,8 @@ xfs_dir2_block_removename(
 	int			size;		/* shortform size */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("block_removename", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Look up the entry in the block.  Gets the buffer and entry index.
 	 * It will always be there, the vnodeops level does a lookup first.
@@ -823,7 +826,8 @@ xfs_dir2_block_replace(
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
-	xfs_dir2_trace_args("block_replace", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Lookup the entry in the directory.  Get buffer and entry index.
 	 * This will always succeed since the caller has already done a lookup.
@@ -897,7 +901,8 @@ xfs_dir2_leaf_to_block(
 	int			to;		/* block/leaf to index */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_bb("leaf_to_block", args, lbp, dbp);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1044,7 +1049,8 @@ xfs_dir2_sf_to_block(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_name		name;
 
-	xfs_dir2_trace_args("sf_to_block", args);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
Index: linux-2.6/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_leaf.c	2009-06-16 22:37:56.394814473 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_leaf.c	2009-06-16 22:37:58.257939318 +0200
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
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -188,7 +189,8 @@ xfs_dir2_leaf_addname(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		use_block;	/* data block number */
 
-	xfs_dir2_trace_args("leaf_addname", args);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1264,7 +1266,8 @@ xfs_dir2_leaf_lookup(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_lookup", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Look up name in the leaf block, returning both buffers and index.
 	 */
@@ -1452,7 +1455,8 @@ xfs_dir2_leaf_removename(
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_removename", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Lookup the leaf entry, get the leaf and data blocks read in.
 	 */
@@ -1584,7 +1588,8 @@ xfs_dir2_leaf_replace(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_replace", args);
+	xfs_trace_dir2(args);
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
+	xfs_trace_dir2(args);
+
 	mp = state->mp;
 	dp = args->dp;
 	tp = args->trans;
Index: linux-2.6/fs/xfs/xfs_dir2_node.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_node.c	2009-06-16 22:37:56.398814703 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_node.c	2009-06-16 22:37:58.259964576 +0200
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
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -196,7 +197,8 @@ xfs_dir2_leafn_add(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_sb("leafn_add", args, index, bp);
+	__xfs_trace_dir2(args, index, 0, 0);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -711,8 +713,8 @@ xfs_dir2_leafn_moveents(
 	int		stale;			/* count stale leaves copied */
 	xfs_trans_t	*tp;			/* transaction pointer */
 
-	xfs_dir2_trace_args_bibii("leafn_moveents", args, bp_s, start_s, bp_d,
-		start_d, count);
+	__xfs_trace_dir2(args, start_s, start_d, count);
+
 	/*
 	 * Silently return if nothing to do.
 	 */
@@ -933,7 +935,8 @@ xfs_dir2_leafn_remove(
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_sb("leafn_remove", args, index, bp);
+	__xfs_trace_dir2(args, index, 0, 0);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1363,7 +1366,8 @@ xfs_dir2_node_addname(
 	int			rval;		/* sub-return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_addname", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Allocate and initialize the state (btree cursor).
 	 */
@@ -1822,7 +1826,8 @@ xfs_dir2_node_lookup(
 	int		rval;			/* operation return value */
 	xfs_da_state_t	*state;			/* btree cursor */
 
-	xfs_dir2_trace_args("node_lookup", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
@@ -1875,7 +1880,8 @@ xfs_dir2_node_removename(
 	int			rval;		/* operation return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_removename", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
@@ -1944,7 +1950,8 @@ xfs_dir2_node_replace(
 	int			rval;		/* internal return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_replace", args);
+	xfs_trace_dir2(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
Index: linux-2.6/fs/xfs/xfs_dir2_sf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_sf.c	2009-06-16 22:37:56.403815130 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_sf.c	2009-06-16 22:37:58.259964576 +0200
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
+	__xfs_trace_dir2(args, size, 0, 0);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 
@@ -281,7 +282,8 @@ xfs_dir2_sf_addname(
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
 
-	xfs_dir2_trace_args("sf_addname", args);
+	xfs_trace_dir2(args);
+
 	ASSERT(xfs_dir2_sf_lookup(args) == ENOENT);
 	dp = args->dp;
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -654,7 +656,8 @@ xfs_dir2_sf_create(
 	xfs_dir2_sf_t	*sfp;		/* shortform structure */
 	int		size;		/* directory size */
 
-	xfs_dir2_trace_args_i("sf_create", args, pino);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 
 	ASSERT(dp != NULL);
@@ -808,7 +811,8 @@ xfs_dir2_sf_lookup(
 	enum xfs_dacmp		cmp;		/* comparison result */
 	xfs_dir2_sf_entry_t	*ci_sfep;	/* case-insens. entry */
 
-	xfs_dir2_trace_args("sf_lookup", args);
+	xfs_trace_dir2(args);
+
 	xfs_dir2_sf_check(args);
 	dp = args->dp;
 
@@ -891,7 +895,8 @@ xfs_dir2_sf_removename(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 
-	xfs_dir2_trace_args("sf_removename", args);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -982,7 +987,8 @@ xfs_dir2_sf_replace(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 
-	xfs_dir2_trace_args("sf_replace", args);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -1125,7 +1131,8 @@ xfs_dir2_sf_toino4(
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_t		*sfp;		/* new sf directory */
 
-	xfs_dir2_trace_args("sf_toino4", args);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 
 	/*
@@ -1202,7 +1209,8 @@ xfs_dir2_sf_toino8(
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_t		*sfp;		/* new sf directory */
 
-	xfs_dir2_trace_args("sf_toino8", args);
+	xfs_trace_dir2(args);
+
 	dp = args->dp;
 
 	/*
Index: linux-2.6/fs/xfs/xfs_btree_trace.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree_trace.c	2009-06-16 22:37:56.409814916 +0200
+++ linux-2.6/fs/xfs/xfs_btree_trace.c	2009-06-16 22:37:58.260964424 +0200
@@ -76,28 +76,6 @@ xfs_btree_trace_argbii(
 }
 
 /*
- * Add a trace buffer entry for arguments, for 3 block-length args
- * and an integer arg.
- */
-void
-xfs_btree_trace_argfffi(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	xfs_dfiloff_t		o,
-	xfs_dfsbno_t		b,
-	xfs_dfilblks_t		i,
-	int			j,
-	int			line)
-{
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGFFFI,
-				 line,
-				 o >> 32, (int)o,
-				 b >> 32, (int)b,
-				 i >> 32, (int)i,
-				 (int)j, 0, 0, 0, 0);
-}
-
-/*
  * Add a trace buffer entry for arguments, for one integer arg.
  */
 void
Index: linux-2.6/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_acl.c	2009-06-16 22:37:56.163814591 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_acl.c	2009-06-16 22:37:58.261967834 +0200
@@ -21,6 +21,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_vnodeops.h"
+#include "xfs_trace.h"
 #include <linux/xattr.h>
 #include <linux/posix_acl_xattr.h>
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_linux.h	2009-06-16 22:38:10.769939937 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_linux.h	2009-06-16 22:38:20.904816654 +0200
@@ -40,7 +40,6 @@
 #include <sv.h>
 #include <time.h>
 
-#include <support/ktrace.h>
 #include <support/debug.h>
 #include <support/uuid.h>
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
