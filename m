Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fDY0205176 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D8F71DC53B
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IW2obc0CbT3nKfQN for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZC-0006PI-Fw
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:02 +0000
Message-Id: <20101210084302.454258243@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/10] xfs: kill xfs_iomap
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_iomap
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

Opencode the xfs_iomap code in it's two callers.  The overlap of passed
flags already was minimal and will be further reduced in the next patch.

As a side effect the BMAPI_* flags for xfs_bmapi and the IO_* flags
for I/O end processing are merged into a single set of flags, which
should be a bit more descriptive of the operation we perform.

Also improve the tracing by giving each caller it's own type set of
tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-12-02 12:38:03.719005800 +0100
+++ xfs/fs/xfs/xfs_iomap.h	2010-12-09 15:48:23.779003915 +0100
@@ -18,30 +18,15 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
-/* base extent manipulation calls */
-#define BMAPI_READ	(1 << 0)	/* read extents */
-#define BMAPI_WRITE	(1 << 1)	/* create extents */
-#define BMAPI_ALLOCATE	(1 << 2)	/* delayed allocate to real extents */
-
-/* modifiers */
-#define BMAPI_IGNSTATE	(1 << 4)	/* ignore unwritten state on read */
-#define BMAPI_DIRECT	(1 << 5)	/* direct instead of buffered write */
-#define BMAPI_MMA	(1 << 6)	/* allocate for mmap write */
-#define BMAPI_TRYLOCK	(1 << 7)	/* non-blocking request */
-
-#define BMAPI_FLAGS \
-	{ BMAPI_READ,		"READ" }, \
-	{ BMAPI_WRITE,		"WRITE" }, \
-	{ BMAPI_ALLOCATE,	"ALLOCATE" }, \
-	{ BMAPI_IGNSTATE,	"IGNSTATE" }, \
-	{ BMAPI_DIRECT,		"DIRECT" }, \
-	{ BMAPI_TRYLOCK,	"TRYLOCK" }
-
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
-extern int xfs_iomap(struct xfs_inode *, xfs_off_t, ssize_t, int,
-		     struct xfs_bmbt_irec *, int *, int *);
+extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
+			struct xfs_bmbt_irec *, int);
+extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
+			struct xfs_bmbt_irec *);
+extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
+			struct xfs_bmbt_irec *);
 extern int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, size_t);
 
 #endif /* __XFS_IOMAP_H__*/
Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:47:44.805272667 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:49:29.815255698 +0100
@@ -38,15 +38,6 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
-/*
- * Types of I/O for bmap clustering and I/O completion tracking.
- */
-enum {
-	IO_READ,	/* mapping for a read */
-	IO_DELAY,	/* mapping covers delalloc region */
-	IO_UNWRITTEN,	/* mapping covers allocated but uninitialized data */
-	IO_NEW		/* just allocated */
-};
 
 /*
  * Prime number of hash buckets since address is used as the key.
@@ -182,9 +173,6 @@ xfs_setfilesize(
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
-	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
-	ASSERT(ioend->io_type != IO_READ);
-
 	if (unlikely(ioend->io_error))
 		return 0;
 
@@ -244,10 +232,8 @@ xfs_end_io(
 	 * We might have to update the on-disk file size after extending
 	 * writes.
 	 */
-	if (ioend->io_type != IO_READ) {
-		error = xfs_setfilesize(ioend);
-		ASSERT(!error || error == EAGAIN);
-	}
+	error = xfs_setfilesize(ioend);
+	ASSERT(!error || error == EAGAIN);
 
 	/*
 	 * If we didn't complete processing of the ioend, requeue it to the
@@ -320,12 +306,88 @@ xfs_map_blocks(
 	loff_t			offset,
 	ssize_t			count,
 	struct xfs_bmbt_irec	*imap,
-	int			flags)
+	int			type,
+	int			nonblocking)
 {
-	int			nmaps = 1;
-	int			new = 0;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			error = 0;
+	int			lockmode = 0;
+	int			bmapi_flags = XFS_BMAPI_ENTIRE;
+	int			nimaps = 1;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
+	switch (type) {
+	case IO_OVERWRITE:
+		lockmode = xfs_ilock_map_shared(ip);
+		break;
+	case IO_UNWRITTEN:
+		lockmode = XFS_ILOCK_EXCL;
+		bmapi_flags |= XFS_BMAPI_IGSTATE;
+		xfs_ilock(ip, lockmode);
+		break;
+	case IO_DELALLOC:
+		lockmode = XFS_ILOCK_SHARED;
+
+		if (!xfs_ilock_nowait(ip, lockmode)) {
+			if (nonblocking)
+				return -XFS_ERROR(EAGAIN);
+			xfs_ilock(ip, lockmode);
+		}
+		break;
+	}
+
+	ASSERT(offset <= mp->m_maxioffset);
+	if (offset + count > mp->m_maxioffset)
+		count = mp->m_maxioffset - offset;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+
+	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
+			  bmapi_flags,  NULL, 0, imap, &nimaps, NULL);
+	if (error)
+		goto out;
+
+	switch (type) {
+	case IO_UNWRITTEN:
+		/* If we found an extent, return it */
+		if (nimaps &&
+		    (imap->br_startblock != HOLESTARTBLOCK) &&
+		    (imap->br_startblock != DELAYSTARTBLOCK)) {
+			trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+			break;
+		}
+
+		error = xfs_iomap_write_delay(ip, offset, count, imap);
+		if (!error)
+			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
+		break;
+	case IO_DELALLOC:
+		/* If we found an extent, return it */
+		xfs_iunlock(ip, lockmode);
+		lockmode = 0;
+
+		if (nimaps && !isnullstartblock(imap->br_startblock)) {
+			trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+			break;
+		}
+
+		error = xfs_iomap_write_allocate(ip, offset, count, imap);
+		if (!error)
+			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
+		break;
+	default:
+		if (nimaps)
+			trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+	}
 
-	return -xfs_iomap(XFS_I(inode), offset, count, flags, imap, &nmaps, &new);
+out:
+	if (lockmode)
+		xfs_iunlock(ip, lockmode);
+	return -XFS_ERROR(error);
 }
 
 STATIC int
@@ -722,9 +784,9 @@ xfs_is_delayed_page(
 			if (buffer_unwritten(bh))
 				acceptable = (type == IO_UNWRITTEN);
 			else if (buffer_delay(bh))
-				acceptable = (type == IO_DELAY);
+				acceptable = (type == IO_DELALLOC);
 			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable = (type == IO_NEW);
+				acceptable = (type == IO_OVERWRITE);
 			else
 				break;
 		} while ((bh = bh->b_this_page) != head);
@@ -809,7 +871,7 @@ xfs_convert_page(
 			if (buffer_unwritten(bh))
 				type = IO_UNWRITTEN;
 			else
-				type = IO_DELAY;
+				type = IO_DELALLOC;
 
 			if (!xfs_imap_valid(inode, imap, offset)) {
 				done = 1;
@@ -826,7 +888,7 @@ xfs_convert_page(
 			page_dirty--;
 			count++;
 		} else {
-			type = IO_NEW;
+			type = IO_OVERWRITE;
 			if (buffer_mapped(bh) && all_bh) {
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset,
@@ -926,7 +988,7 @@ xfs_aops_discard_page(
 	struct buffer_head	*bh, *head;
 	loff_t			offset = page_offset(page);
 
-	if (!xfs_is_delayed_page(page, IO_DELAY))
+	if (!xfs_is_delayed_page(page, IO_DELALLOC))
 		goto out_invalidate;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
@@ -994,9 +1056,10 @@ xfs_vm_writepage(
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
 	ssize_t			size, len;
-	int			flags, err, imap_valid = 0, uptodate = 1;
+	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
 	int			all_bh = 0;
+	int			nonblocking = 0;
 
 	trace_xfs_writepage(inode, page, 0);
 
@@ -1047,8 +1110,10 @@ xfs_vm_writepage(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	flags = BMAPI_READ;
-	type = IO_NEW;
+	type = IO_OVERWRITE;
+
+	if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
+		nonblocking = 1;
 
 	do {
 		int new_ioend = 0;
@@ -1078,16 +1143,11 @@ xfs_vm_writepage(
 					type = IO_UNWRITTEN;
 					imap_valid = 0;
 				}
-				flags = BMAPI_WRITE | BMAPI_IGNSTATE;
 			} else if (buffer_delay(bh)) {
-				if (type != IO_DELAY) {
-					type = IO_DELAY;
+				if (type != IO_DELALLOC) {
+					type = IO_DELALLOC;
 					imap_valid = 0;
 				}
-				flags = BMAPI_ALLOCATE;
-
-				if (wbc->sync_mode == WB_SYNC_NONE)
-					flags |= BMAPI_TRYLOCK;
 			}
 
 			if (!imap_valid) {
@@ -1100,8 +1160,8 @@ xfs_vm_writepage(
 				 * for unwritten extent conversion.
 				 */
 				new_ioend = 1;
-				err = xfs_map_blocks(inode, offset, len,
-						&imap, flags);
+				err = xfs_map_blocks(inode, offset, len, &imap,
+						     type, nonblocking);
 				if (err)
 					goto error;
 				imap_valid = xfs_imap_valid(inode, &imap,
@@ -1119,30 +1179,21 @@ xfs_vm_writepage(
 			 * That means it must already have extents allocated
 			 * underneath it. Map the extent by reading it.
 			 */
-			if (flags != BMAPI_READ) {
-				flags = BMAPI_READ;
+			if (type != IO_OVERWRITE) {
+				type = IO_OVERWRITE;
 				imap_valid = 0;
 			}
 			if (!imap_valid) {
 				new_ioend = 1;
 				size = xfs_probe_cluster(inode, page, bh, head);
 				err = xfs_map_blocks(inode, offset, size,
-						&imap, flags);
+						&imap, type, nonblocking);
 				if (err)
 					goto error;
 				imap_valid = xfs_imap_valid(inode, &imap,
 							    offset);
 			}
 
-			/*
-			 * We set the type to IO_NEW in case we are doing a
-			 * small write at EOF that is extending the file but
-			 * without needing an allocation. We need to update the
-			 * file size on I/O completion in this case so it is
-			 * the same case as having just allocated a new extent
-			 * that we are writing into for the first time.
-			 */
-			type = IO_NEW;
 			if (imap_valid) {
 				all_bh = 1;
 				lock_buffer(bh);
@@ -1250,13 +1301,19 @@ __xfs_get_blocks(
 	int			create,
 	int			direct)
 {
-	int			flags = create ? BMAPI_WRITE : BMAPI_READ;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			error = 0;
+	int			lockmode = 0;
 	struct xfs_bmbt_irec	imap;
+	int			nimaps = 1;
 	xfs_off_t		offset;
 	ssize_t			size;
-	int			nimap = 1;
 	int			new = 0;
-	int			error;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
 
 	offset = (xfs_off_t)iblock << inode->i_blkbits;
 	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
@@ -1265,15 +1322,45 @@ __xfs_get_blocks(
 	if (!create && direct && offset >= i_size_read(inode))
 		return 0;
 
-	if (direct && create)
-		flags |= BMAPI_DIRECT;
+	if (create) {
+		lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, lockmode);
+	} else {
+		lockmode = xfs_ilock_map_shared(ip);
+	}
+
+	ASSERT(offset <= mp->m_maxioffset);
+	if (offset + size > mp->m_maxioffset)
+		size = mp->m_maxioffset - offset;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	error = xfs_iomap(XFS_I(inode), offset, size, flags, &imap, &nimap,
-			  &new);
+	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
+			  XFS_BMAPI_ENTIRE,  NULL, 0, &imap, &nimaps, NULL);
 	if (error)
-		return -error;
-	if (nimap == 0)
-		return 0;
+		goto out_unlock;
+
+	if (create &&
+	    (!nimaps ||
+	     (imap.br_startblock == HOLESTARTBLOCK ||
+	      imap.br_startblock == DELAYSTARTBLOCK))) {
+		if (direct) {
+			error = xfs_iomap_write_direct(ip, offset, size,
+						       &imap, nimaps);
+		} else {
+			error = xfs_iomap_write_delay(ip, offset, size, &imap);
+		}
+		if (error)
+			goto out_unlock;
+
+		trace_xfs_get_blocks_alloc(ip, offset, size, 0, &imap);
+	} else if (nimaps) {
+		trace_xfs_get_blocks_found(ip, offset, size, 0, &imap);
+	} else {
+		trace_xfs_get_blocks_notfound(ip, offset, size);
+		goto out_unlock;
+	}
+	xfs_iunlock(ip, lockmode);
 
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK) {
@@ -1340,6 +1427,10 @@ __xfs_get_blocks(
 	}
 
 	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+	return -error;
 }
 
 int
@@ -1427,7 +1518,7 @@ xfs_vm_direct_IO(
 	ssize_t			ret;
 
 	if (rw & WRITE) {
-		iocb->private = xfs_alloc_ioend(inode, IO_NEW);
+		iocb->private = xfs_alloc_ioend(inode, IO_DIRECT);
 
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-12-09 15:45:46.367254159 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2010-12-09 15:48:23.784010410 +0100
@@ -935,10 +935,10 @@ DEFINE_PAGE_EVENT(xfs_writepage);
 DEFINE_PAGE_EVENT(xfs_releasepage);
 DEFINE_PAGE_EVENT(xfs_invalidatepage);
 
-DECLARE_EVENT_CLASS(xfs_iomap_class,
+DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
-		 int flags, struct xfs_bmbt_irec *irec),
-	TP_ARGS(ip, offset, count, flags, irec),
+		 int type, struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, offset, count, type, irec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -946,7 +946,7 @@ DECLARE_EVENT_CLASS(xfs_iomap_class,
 		__field(loff_t, new_size)
 		__field(loff_t, offset)
 		__field(size_t, count)
-		__field(int, flags)
+		__field(int, type)
 		__field(xfs_fileoff_t, startoff)
 		__field(xfs_fsblock_t, startblock)
 		__field(xfs_filblks_t, blockcount)
@@ -958,13 +958,13 @@ DECLARE_EVENT_CLASS(xfs_iomap_class,
 		__entry->new_size = ip->i_new_size;
 		__entry->offset = offset;
 		__entry->count = count;
-		__entry->flags = flags;
+		__entry->type = type;
 		__entry->startoff = irec ? irec->br_startoff : 0;
 		__entry->startblock = irec ? irec->br_startblock : 0;
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
-		  "offset 0x%llx count %zd flags %s "
+		  "offset 0x%llx count %zd type %s "
 		  "startoff 0x%llx startblock %lld blockcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -972,20 +972,21 @@ DECLARE_EVENT_CLASS(xfs_iomap_class,
 		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count,
-		  __print_flags(__entry->flags, "|", BMAPI_FLAGS),
+		  __print_symbolic(__entry->type, XFS_IO_TYPES),
 		  __entry->startoff,
 		  (__int64_t)__entry->startblock,
 		  __entry->blockcount)
 )
 
 #define DEFINE_IOMAP_EVENT(name)	\
-DEFINE_EVENT(xfs_iomap_class, name,	\
+DEFINE_EVENT(xfs_imap_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
-		 int flags, struct xfs_bmbt_irec *irec),		\
-	TP_ARGS(ip, offset, count, flags, irec))
-DEFINE_IOMAP_EVENT(xfs_iomap_enter);
-DEFINE_IOMAP_EVENT(xfs_iomap_found);
-DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
+		 int type, struct xfs_bmbt_irec *irec),		\
+	TP_ARGS(ip, offset, count, type, irec))
+DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
+DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
+DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
+DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
@@ -1022,6 +1023,7 @@ DEFINE_EVENT(xfs_simple_io_class, name,
 	TP_ARGS(ip, offset, count))
 DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
+DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
 
 
 TRACE_EVENT(xfs_itruncate_start,
Index: xfs/fs/xfs/linux-2.6/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.h	2010-12-02 12:38:03.745004124 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.h	2010-12-09 15:49:31.585257930 +0100
@@ -23,6 +23,22 @@ extern struct workqueue_struct *xfsconve
 extern mempool_t *xfs_ioend_pool;
 
 /*
+ * Types of I/O for bmap clustering and I/O completion tracking.
+ */
+enum {
+	IO_DIRECT = 0,	/* special case for direct I/O ioends */
+	IO_DELALLOC,	/* mapping covers delalloc region */
+	IO_UNWRITTEN,	/* mapping covers allocated but uninitialized data */
+	IO_OVERWRITE,	/* mapping covers already allocated extent */
+};
+
+#define XFS_IO_TYPES \
+	{ 0,			"" }, \
+	{ IO_DELALLOC,		"delalloc" }, \
+	{ IO_UNWRITTEN,		"unwritten" }, \
+	{ IO_OVERWRITE,		"overwrite" }
+
+/*
  * xfs_ioend struct manages large extent writes for XFS.
  * It can manage several multi-page bio's at once.
  */
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-12-09 15:48:00.407254089 +0100
+++ xfs/fs/xfs/xfs_iomap.c	2010-12-09 15:48:23.789003845 +0100
@@ -47,124 +47,8 @@
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
 						<< mp->m_writeio_log)
-#define XFS_STRAT_WRITE_IMAPS	2
 #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
-STATIC int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
-				  struct xfs_bmbt_irec *, int);
-STATIC int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
-				 struct xfs_bmbt_irec *);
-STATIC int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
-				struct xfs_bmbt_irec *);
-
-int
-xfs_iomap(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	ssize_t			count,
-	int			flags,
-	struct xfs_bmbt_irec	*imap,
-	int			*nimaps,
-	int			*new)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb, end_fsb;
-	int			error = 0;
-	int			lockmode = 0;
-	int			bmapi_flags = 0;
-
-	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
-
-	*new = 0;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	trace_xfs_iomap_enter(ip, offset, count, flags, NULL);
-
-	switch (flags & (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE)) {
-	case BMAPI_READ:
-		lockmode = xfs_ilock_map_shared(ip);
-		bmapi_flags = XFS_BMAPI_ENTIRE;
-		break;
-	case BMAPI_WRITE:
-		lockmode = XFS_ILOCK_EXCL;
-		if (flags & BMAPI_IGNSTATE)
-			bmapi_flags |= XFS_BMAPI_IGSTATE|XFS_BMAPI_ENTIRE;
-		xfs_ilock(ip, lockmode);
-		break;
-	case BMAPI_ALLOCATE:
-		lockmode = XFS_ILOCK_SHARED;
-		bmapi_flags = XFS_BMAPI_ENTIRE;
-
-		/* Attempt non-blocking lock */
-		if (flags & BMAPI_TRYLOCK) {
-			if (!xfs_ilock_nowait(ip, lockmode))
-				return XFS_ERROR(EAGAIN);
-		} else {
-			xfs_ilock(ip, lockmode);
-		}
-		break;
-	default:
-		BUG();
-	}
-
-	ASSERT(offset <= mp->m_maxioffset);
-	if ((xfs_fsize_t)offset + count > mp->m_maxioffset)
-		count = mp->m_maxioffset - offset;
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-
-	error = xfs_bmapi(NULL, ip, offset_fsb,
-			(xfs_filblks_t)(end_fsb - offset_fsb),
-			bmapi_flags,  NULL, 0, imap,
-			nimaps, NULL);
-
-	if (error)
-		goto out;
-
-	switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)) {
-	case BMAPI_WRITE:
-		/* If we found an extent, return it */
-		if (*nimaps &&
-		    (imap->br_startblock != HOLESTARTBLOCK) &&
-		    (imap->br_startblock != DELAYSTARTBLOCK)) {
-			trace_xfs_iomap_found(ip, offset, count, flags, imap);
-			break;
-		}
-
-		if (flags & BMAPI_DIRECT) {
-			error = xfs_iomap_write_direct(ip, offset, count, imap,
-						       *nimaps);
-		} else {
-			error = xfs_iomap_write_delay(ip, offset, count, imap);
-		}
-
-		if (!error) {
-			trace_xfs_iomap_alloc(ip, offset, count, flags, imap);
-		}
-		*new = 1;
-		break;
-	case BMAPI_ALLOCATE:
-		/* If we found an extent, return it */
-		xfs_iunlock(ip, lockmode);
-		lockmode = 0;
-
-		if (*nimaps && !isnullstartblock(imap->br_startblock)) {
-			trace_xfs_iomap_found(ip, offset, count, flags, imap);
-			break;
-		}
-
-		error = xfs_iomap_write_allocate(ip, offset, count, imap);
-		break;
-	}
-
-out:
-	if (lockmode)
-		xfs_iunlock(ip, lockmode);
-	return XFS_ERROR(error);
-}
-
 STATIC int
 xfs_iomap_eof_align_last_fsb(
 	xfs_mount_t	*mp,
@@ -233,7 +117,7 @@ xfs_cmn_err_fsblock_zero(
 	return EFSCORRUPTED;
 }
 
-STATIC int
+int
 xfs_iomap_write_direct(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
@@ -428,7 +312,7 @@ xfs_iomap_eof_want_preallocate(
 	return 0;
 }
 
-STATIC int
+int
 xfs_iomap_write_delay(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
@@ -527,7 +411,7 @@ retry:
  * We no longer bother to look at the incoming map - all we have to
  * guarantee is that whatever we allocate fills the required range.
  */
-STATIC int
+int
 xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
