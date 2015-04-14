Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B43097F3F
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 02:27:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31B07AC003
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 00:27:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wgEWKLoZst7azkEz for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 00:27:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YhvFE-0000qd-Ub
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:53 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YhvFE-0000Vo-Tk
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: DIO writes within EOF don't need an ioend
Date: Tue, 14 Apr 2015 17:26:48 +1000
Message-Id: <1428996411-1507-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1428996411-1507-1-git-send-email-david@fromorbit.com>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

DIO writes that lie entirely within EOF have nothing to do in IO
completion. In this case, we don't need no steekin' ioend, and so we
can avoid allocating an ioend until we have a mapping that spans
EOF.

This means that IO completion has two contexts - deferred completion
to the dio workqueue that uses an ioend, and interrupt completion
that does nothing because there is nothing that can be done in this
context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c  | 62 ++++++++++++++++++++++++++++++------------------------
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e3968a3..55356f6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1234,15 +1234,19 @@ xfs_vm_releasepage(
 }
 
 /*
- * When we map a DIO buffer, we need to attach an ioend that describes the type
+ * When we map a DIO buffer, we may need to attach an ioend that describes the type
  * of write IO we are doing. This passes to the completion function the
- * operations it needs to perform.
+ * operations it needs to perform. If the mapping is for an overwrite wholly
+ * within the EOF then we don't need an ioend and so we don't allocate one. This
+ * avoids the unnecessary overhead of allocating and freeing ioends for
+ * workloads that don't require transactions on IO completion.
  *
  * If we get multiple mappings to in a single IO, we might be mapping dfferent
  * types. But because the direct IO can only have a single private pointer, we
  * need to ensure that:
  *
- * a) the ioend spans the entire region of the IO; and
+ * a) i) the ioend spans the entire region of unwritten mappings; or
+ *    ii) the ioend spans all the mappings that cross or are beyond EOF; and
  * b) if it contains unwritten extents, it is *permanently* marked as such
  *
  * We could do this by chaining ioends like buffered IO does, but we only
@@ -1283,7 +1287,8 @@ xfs_map_direct(
 		trace_xfs_gbmap_direct_update(XFS_I(inode), ioend->io_offset,
 					      ioend->io_size, ioend->io_type,
 					      imap);
-	} else {
+	} else if (type == XFS_IO_UNWRITTEN ||
+		   offset + size > i_size_read(inode)) {
 		ioend = xfs_alloc_ioend(inode, type);
 		ioend->io_offset = offset;
 		ioend->io_size = size;
@@ -1291,10 +1296,13 @@ xfs_map_direct(
 
 		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
 					   imap);
+	} else {
+		trace_xfs_gbmap_direct_none(XFS_I(inode), offset, size, type,
+					    imap);
+		return;
 	}
 
-	if (ioend->io_type == XFS_IO_UNWRITTEN || xfs_ioend_is_append(ioend))
-		set_buffer_defer_completion(bh_result);
+	set_buffer_defer_completion(bh_result);
 }
 
 
@@ -1515,9 +1523,11 @@ xfs_get_blocks_direct(
 /*
  * Complete a direct I/O write request.
  *
- * If the private argument is non-NULL __xfs_get_blocks signals us that we
- * need to issue a transaction to convert the range from unwritten to written
- * extents.
+ * The ioend structure is passed from __xfs_get_blocks() to tell us what to do.
+ * If no ioend exists (i.e. @private == NULL) then the write IO is an overwrite
+ * wholly within the EOF and so there is nothing for us to do. Note that in this
+ * case the completion can be called in interrupt context, whereas if we have an
+ * ioend we will always be called in task context (i.e. from a workqueue).
  */
 STATIC void
 xfs_end_io_direct_write(
@@ -1531,7 +1541,10 @@ xfs_end_io_direct_write(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ioend	*ioend = private;
 
-	trace_xfs_gbmap_direct_endio(ip, offset, size, ioend->io_type, NULL);
+	trace_xfs_gbmap_direct_endio(ip, offset, size,
+				     ioend ? ioend->io_type : 0, NULL);
+	if (!ioend)
+		return;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		goto out_end_io;
@@ -1544,12 +1557,12 @@ xfs_end_io_direct_write(
 
 	/*
 	 * The ioend only maps whole blocks, while the IO may be sector aligned.
-	 * Hence the ioend offset/size may not match the IO offset/size exactly,
-	 * but should span it completely. Write the IO sizes into the ioend so
-	 * that completion processing does the right thing.
+	 * Hence the ioend offset/size may not match the IO offset/size exactly.
+	 * Because we don't map overwrites within EOF into the ioend, the offset
+	 * may not match, but only if the endio spans EOF.  Either way, write
+	 * the IO sizes into the ioend so that completion processing does the
+	 * right thing.
 	 */
-	ASSERT(size <= ioend->io_size);
-	ASSERT(offset >= ioend->io_offset);
 	ASSERT(offset + size <= ioend->io_offset + ioend->io_size);
 	ioend->io_size = size;
 	ioend->io_offset = offset;
@@ -1558,20 +1571,15 @@ xfs_end_io_direct_write(
 	 * The ioend tells us whether we are doing unwritten extent conversion
 	 * or an append transaction that updates the on-disk file size. These
 	 * cases are the only cases where we should *potentially* be needing
-	 * to update the VFS inode size. When the ioend indicates this, we
-	 * are *guaranteed* to be running in non-interrupt context.
+	 * to update the VFS inode size.
 	 *
 	 * We need to update the in-core inode size here so that we don't end up
-	 * with the on-disk inode size being outside the in-core inode size.
-	 * While we can do this in the process context after the IO has
-	 * completed, this does not work for AIO and hence we always update
-	 * the in-core inode size here if necessary.
+	 * with the on-disk inode size being outside the in-core inode size. We
+	 * have no other method of updating EOF for AIO, so always do it here
+	 * if necessary.
 	 */
-	if (ioend->io_type == XFS_IO_UNWRITTEN || xfs_ioend_is_append(ioend)) {
-		if (offset + size > i_size_read(inode))
-			i_size_write(inode, offset + size);
-	} else
-		ASSERT(offset + size <= i_size_read(inode));
+	if (offset + size > i_size_read(inode))
+		i_size_write(inode, offset + size);
 
 	/*
 	 * If we are doing an append IO that needs to update the EOF on disk,
@@ -1580,7 +1588,7 @@ xfs_end_io_direct_write(
 	 * result in the ioend processing passing on the error if it is
 	 * possible as we can't return it from here.
 	 */
-	if (ioend->io_type == XFS_IO_OVERWRITE && xfs_ioend_is_append(ioend))
+	if (ioend->io_type == XFS_IO_OVERWRITE)
 		ioend->io_error = xfs_setfilesize_trans_alloc(ioend);
 
 out_end_io:
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 967993b..615781b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1224,6 +1224,7 @@ DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
 DEFINE_IOMAP_EVENT(xfs_gbmap_direct);
 DEFINE_IOMAP_EVENT(xfs_gbmap_direct_new);
 DEFINE_IOMAP_EVENT(xfs_gbmap_direct_update);
+DEFINE_IOMAP_EVENT(xfs_gbmap_direct_none);
 DEFINE_IOMAP_EVENT(xfs_gbmap_direct_endio);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
