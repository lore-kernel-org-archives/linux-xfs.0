Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 862CC7F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 04:12:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AB548F804B
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 02:12:41 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iId9H0yrQby56gv3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 02:12:36 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't use ioends for direct write completions
Date: Thu, 14 Jan 2016 11:10:37 +0100
Message-Id: <1452766237-2314-2-git-send-email-hch@lst.de>
In-Reply-To: <1452766237-2314-1-git-send-email-hch@lst.de>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: darrick.wong@oracle.com

We only need to communicate two bits of information to the direct I/O
completion handler:

 (1) do we need to convert any unwritten extents in the range
 (2) do we need to check if we need to update the inode size based
     on the range passed to the completion handler

We can use the private data passed to the get_block handler and the
completion handler as a simple bitmask to communicate this information
instead of the current complicated infrastructure reusing the ioends
from the buffer I/O path, and thus avoiding a memory allocation and
a context switch for any non-trivial direct write.  As a nice side
effect we also decouple the direct I/O path implementation from that
of the buffered I/O path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 210 +++++++++++++++++++----------------------------------
 fs/xfs/xfs_trace.h |   9 +--
 2 files changed, 77 insertions(+), 142 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 379c089..ff2c571 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -36,6 +36,10 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+/* flags for direct write completions */
+#define XFS_DIO_FLAG_UNWRITTEN	(1 << 0)
+#define XFS_DIO_FLAG_APPEND	(1 << 1)
+
 void
 xfs_count_page_state(
 	struct page		*page,
@@ -1238,27 +1242,8 @@ xfs_vm_releasepage(
 }
 
 /*
- * When we map a DIO buffer, we may need to attach an ioend that describes the
- * type of write IO we are doing. This passes to the completion function the
- * operations it needs to perform. If the mapping is for an overwrite wholly
- * within the EOF then we don't need an ioend and so we don't allocate one.
- * This avoids the unnecessary overhead of allocating and freeing ioends for
- * workloads that don't require transactions on IO completion.
- *
- * If we get multiple mappings in a single IO, we might be mapping different
- * types. But because the direct IO can only have a single private pointer, we
- * need to ensure that:
- *
- * a) i) the ioend spans the entire region of unwritten mappings; or
- *    ii) the ioend spans all the mappings that cross or are beyond EOF; and
- * b) if it contains unwritten extents, it is *permanently* marked as such
- *
- * We could do this by chaining ioends like buffered IO does, but we only
- * actually get one IO completion callback from the direct IO, and that spans
- * the entire IO regardless of how many mappings and IOs are needed to complete
- * the DIO. There is only going to be one reference to the ioend and its life
- * cycle is constrained by the DIO completion code. hence we don't need
- * reference counting here.
+ * When we map a DIO buffer, we may need to pass flags to
+ * xfs_end_io_direct_write to tell it what kind of write IO we are doing.
  *
  * Note that for DIO, an IO to the highest supported file block offset (i.e.
  * 2^63 - 1FSB bytes) will result in the offset + count overflowing a signed 64
@@ -1266,68 +1251,26 @@ xfs_vm_releasepage(
  * extending the file size. We won't know for sure until IO completion is run
  * and the actual max write offset is communicated to the IO completion
  * routine.
- *
- * For DAX page faults, we are preparing to never see unwritten extents here,
- * nor should we ever extend the inode size. Hence we will soon have nothing to
- * do here for this case, ensuring we don't have to provide an IO completion
- * callback to free an ioend that we don't actually need for a fault into the
- * page at offset (2^63 - 1FSB) bytes.
  */
-
 static void
 xfs_map_direct(
 	struct inode		*inode,
 	struct buffer_head	*bh_result,
 	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset,
-	bool			dax_fault)
+	xfs_off_t		offset)
 {
-	struct xfs_ioend	*ioend;
+	uintptr_t		*flags = (uintptr_t *)&bh_result->b_private;
 	xfs_off_t		size = bh_result->b_size;
-	int			type;
 
-	if (ISUNWRITTEN(imap))
-		type = XFS_IO_UNWRITTEN;
-	else
-		type = XFS_IO_OVERWRITE;
+	trace_xfs_get_blocks_map_direct(XFS_I(inode), offset, size,
+		ISUNWRITTEN(imap) ? XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, imap);
 
-	trace_xfs_gbmap_direct(XFS_I(inode), offset, size, type, imap);
-
-	if (dax_fault) {
-		ASSERT(type == XFS_IO_OVERWRITE);
-		trace_xfs_gbmap_direct_none(XFS_I(inode), offset, size, type,
-					    imap);
-		return;
-	}
-
-	if (bh_result->b_private) {
-		ioend = bh_result->b_private;
-		ASSERT(ioend->io_size > 0);
-		ASSERT(offset >= ioend->io_offset);
-		if (offset + size > ioend->io_offset + ioend->io_size)
-			ioend->io_size = offset - ioend->io_offset + size;
-
-		if (type == XFS_IO_UNWRITTEN && type != ioend->io_type)
-			ioend->io_type = XFS_IO_UNWRITTEN;
-
-		trace_xfs_gbmap_direct_update(XFS_I(inode), ioend->io_offset,
-					      ioend->io_size, ioend->io_type,
-					      imap);
-	} else if (type == XFS_IO_UNWRITTEN ||
-		   offset + size > i_size_read(inode) ||
-		   offset + size < 0) {
-		ioend = xfs_alloc_ioend(inode, type);
-		ioend->io_offset = offset;
-		ioend->io_size = size;
-
-		bh_result->b_private = ioend;
+	if (ISUNWRITTEN(imap)) {
+		*flags |= XFS_DIO_FLAG_UNWRITTEN;
+		set_buffer_defer_completion(bh_result);
+	} else if (offset + size > i_size_read(inode) || offset + size < 0) {
+		*flags |= XFS_DIO_FLAG_APPEND;
 		set_buffer_defer_completion(bh_result);
-
-		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
-					   imap);
-	} else {
-		trace_xfs_gbmap_direct_none(XFS_I(inode), offset, size, type,
-					    imap);
 	}
 }
 
@@ -1498,9 +1441,12 @@ __xfs_get_blocks(
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
 		/* direct IO needs special help */
-		if (create && direct)
-			xfs_map_direct(inode, bh_result, &imap, offset,
-				       dax_fault);
+		if (create && direct) {
+			if (dax_fault)
+				ASSERT(!ISUNWRITTEN(&imap));
+			else
+				xfs_map_direct(inode, bh_result, &imap, offset);
+		}
 	}
 
 	/*
@@ -1570,17 +1516,34 @@ xfs_get_blocks_dax_fault(
 	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
 }
 
-static void
-__xfs_end_io_direct_write(
-	struct inode		*inode,
-	struct xfs_ioend	*ioend,
+/*
+ * Complete a direct I/O write request.
+ *
+ * xfs_map_direct passes us some flags in the private data to tell us what to
+ * do.  If not flags are set, then the write IO is an overwrite wholly within
+ * the existing allocated file size and so there is nothing for us to do.
+ *
+ * Note that in this case the completion can be called in interrupt context,
+ * whereas if we have flags set we will always be called in task context
+ * (i.e. from a workqueue).
+ */
+STATIC void
+xfs_end_io_direct_write(
+	struct kiocb		*iocb,
 	loff_t			offset,
-	ssize_t			size)
+	ssize_t			size,
+	void			*private)
 {
-	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	uintptr_t		flags = (uintptr_t)private;
+	int			error = 0;
+
+	trace_xfs_end_io_direct_write(ip, offset, size);
 
-	if (XFS_FORCED_SHUTDOWN(mp) || ioend->io_error)
-		goto out_end_io;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return;
 
 	/*
 	 * dio completion end_io functions are only called on writes if more
@@ -1589,23 +1552,17 @@ __xfs_end_io_direct_write(
 	ASSERT(size > 0);
 
 	/*
-	 * The ioend only maps whole blocks, while the IO may be sector aligned.
-	 * Hence the ioend offset/size may not match the IO offset/size exactly.
-	 * Because we don't map overwrites within EOF into the ioend, the offset
-	 * may not match, but only if the endio spans EOF.  Either way, write
-	 * the IO sizes into the ioend so that completion processing does the
-	 * right thing.
-	 */
-	ASSERT(offset + size <= ioend->io_offset + ioend->io_size);
-	ioend->io_size = size;
-	ioend->io_offset = offset;
-
-	/*
-	 * The ioend tells us whether we are doing unwritten extent conversion
+	 * The flags tell us whether we are doing unwritten extent conversion
 	 * or an append transaction that updates the on-disk file size. These
 	 * cases are the only cases where we should *potentially* be needing
 	 * to update the VFS inode size.
-	 *
+	 */
+	if (flags == 0) {
+		ASSERT(offset + size <= i_size_read(inode));
+		return;
+	}
+
+	/*
 	 * We need to update the in-core inode size here so that we don't end up
 	 * with the on-disk inode size being outside the in-core inode size. We
 	 * have no other method of updating EOF for AIO, so always do it here
@@ -1616,54 +1573,33 @@ __xfs_end_io_direct_write(
 	 * here can result in EOF moving backwards and Bad Things Happen when
 	 * that occurs.
 	 */
-	spin_lock(&XFS_I(inode)->i_flags_lock);
+	spin_lock(&ip->i_flags_lock);
 	if (offset + size > i_size_read(inode))
 		i_size_write(inode, offset + size);
-	spin_unlock(&XFS_I(inode)->i_flags_lock);
+	spin_unlock(&ip->i_flags_lock);
 
-	/*
-	 * If we are doing an append IO that needs to update the EOF on disk,
-	 * do the transaction reserve now so we can use common end io
-	 * processing. Stashing the error (if there is one) in the ioend will
-	 * result in the ioend processing passing on the error if it is
-	 * possible as we can't return it from here.
-	 */
-	if (ioend->io_type == XFS_IO_OVERWRITE)
-		ioend->io_error = xfs_setfilesize_trans_alloc(ioend);
+	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
+		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
 
-out_end_io:
-	xfs_end_io(&ioend->io_work);
-	return;
-}
+		error = xfs_iomap_write_unwritten(ip, offset, size);
 
-/*
- * Complete a direct I/O write request.
- *
- * The ioend structure is passed from __xfs_get_blocks() to tell us what to do.
- * If no ioend exists (i.e. @private == NULL) then the write IO is an overwrite
- * wholly within the EOF and so there is nothing for us to do. Note that in this
- * case the completion can be called in interrupt context, whereas if we have an
- * ioend we will always be called in task context (i.e. from a workqueue).
- */
-STATIC void
-xfs_end_io_direct_write(
-	struct kiocb		*iocb,
-	loff_t			offset,
-	ssize_t			size,
-	void			*private)
-{
-	struct inode		*inode = file_inode(iocb->ki_filp);
-	struct xfs_ioend	*ioend = private;
+		WARN_ON_ONCE(error);
+	} else if (flags & XFS_DIO_FLAG_APPEND) {
+		struct xfs_trans *tp;
 
-	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
-				     ioend ? ioend->io_type : 0, NULL);
+		trace_xfs_end_io_direct_write_append(ip, offset, size);
 
-	if (!ioend) {
-		ASSERT(offset + size <= i_size_read(inode));
-		return;
-	}
+		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 
-	__xfs_end_io_direct_write(inode, ioend, offset, size);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
+		if (error) {
+			xfs_trans_cancel(tp);
+			WARN_ON_ONCE(error);
+			return;
+		}
+		error = xfs_setfilesize(ip, tp, offset, size);
+		WARN_ON_ONCE(error);
+	}
 }
 
 static inline ssize_t
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 391d797..c8d5842 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1296,11 +1296,7 @@ DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
 DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
 DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
 DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
-DEFINE_IOMAP_EVENT(xfs_gbmap_direct);
-DEFINE_IOMAP_EVENT(xfs_gbmap_direct_new);
-DEFINE_IOMAP_EVENT(xfs_gbmap_direct_update);
-DEFINE_IOMAP_EVENT(xfs_gbmap_direct_none);
-DEFINE_IOMAP_EVENT(xfs_gbmap_direct_endio);
+DEFINE_IOMAP_EVENT(xfs_get_blocks_map_direct);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
@@ -1340,6 +1336,9 @@ DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
 DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
 DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
 DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
+DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
+DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
+DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
