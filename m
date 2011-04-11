Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3B36iRG063910 for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 22:06:44 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 269023C164A
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 20:10:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uUmfMqlNeajoAdAZ for <xfs@oss.sgi.com>;
	Sun, 10 Apr 2011 20:10:02 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q97Vn-0005dG-13
	for xfs@oss.sgi.com; Mon, 11 Apr 2011 13:09:59 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q97Vt-0000bT-Ja
	for xfs@oss.sgi.com; Mon, 11 Apr 2011 13:10:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: reset buffer pointers before freeing them
Date: Mon, 11 Apr 2011 13:10:05 +1000
Message-Id: <1302491405-2290-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we free a vmapped buffer, we need to ensure the vmap address
and length we free is the same as when it was allocated. In various
places in the log code we change the memory the buffer is pointing
to before issuing IO, but we never reset the buffer to point back to
it's original memory (or no memory, if that is the case for the
buffer).

As a result, when we free the buffer it points to memory that is
owned by something else and attempts to unmap and free it. Because
the range does not match any known mapped range, it can trigger
BUG_ON() traps in the vmap code, and potentially corrupt the vmap
area tracking.

Fix this by always resetting these buffers to their original state
before freeing them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   21 +++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_buf.h |    1 +
 fs/xfs/xfs_log.c           |    8 +++++++-
 fs/xfs/xfs_log_recover.c   |   31 ++++++++++++++++++++-----------
 4 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index d917146..2e8b759 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -711,6 +711,27 @@ xfs_buf_get_empty(
 	return bp;
 }
 
+/*
+ * Return a buffer allocated as an empty buffer and associated to external
+ * memory via xfs_buf_associate_memory() back to it's empty state.
+ */
+void
+xfs_buf_set_empty(
+	struct xfs_buf		*bp,
+	size_t			len)
+{
+	if (bp->b_pages)
+		_xfs_buf_free_pages(bp);
+
+	bp->b_pages = NULL;
+	bp->b_page_count = 0;
+	bp->b_addr = NULL;
+	bp->b_file_offset = 0;
+	bp->b_buffer_length = bp->b_count_desired = len;
+	bp->b_bn = XFS_BUF_DADDR_NULL;
+	bp->b_flags &= ~XBF_MAPPED;
+}
+
 static inline struct page *
 mem_to_page(
 	void			*addr)
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index a9a1c45..50a7d5f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -178,6 +178,7 @@ extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
 
 extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
+extern void xfs_buf_set_empty(struct xfs_buf *bp, size_t len);
 extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
 extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
 extern void xfs_buf_hold(xfs_buf_t *);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b612ce4..3850a91 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1449,6 +1449,13 @@ xlog_dealloc_log(xlog_t *log)
 
 	xlog_cil_destroy(log);
 
+	/*
+	 * always need to ensure that the extra buffer does not point to memory
+	 * owned by another log buffer before we free it.
+	 */
+	xfs_buf_set_empty(log->l_xbuf, log->l_iclog_size);
+	xfs_buf_free(log->l_xbuf);
+
 	iclog = log->l_iclog;
 	for (i=0; i<log->l_iclog_bufs; i++) {
 		xfs_buf_free(iclog->ic_bp);
@@ -1458,7 +1465,6 @@ xlog_dealloc_log(xlog_t *log)
 	}
 	spinlock_destroy(&log->l_icloglock);
 
-	xfs_buf_free(log->l_xbuf);
 	log->l_mp->m_log = NULL;
 	kmem_free(log);
 }	/* xlog_dealloc_log */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0c4a561..c467e38 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1229,6 +1229,8 @@ xlog_write_log_records(
 		 */
 		ealign = round_down(end_block, sectbb);
 		if (j == 0 && (start_block + endcount > ealign)) {
+			int error2;
+
 			offset = XFS_BUF_PTR(bp);
 			balign = BBTOB(ealign - start_block);
 			error = XFS_BUF_SET_PTR(bp, offset + balign,
@@ -1237,12 +1239,14 @@ xlog_write_log_records(
 				break;
 
 			error = xlog_bread_noalign(log, ealign, sectbb, bp);
-			if (error)
-				break;
 
-			error = XFS_BUF_SET_PTR(bp, offset, bufblks);
+			/* must reset buffer pointer even on error */
+			error2 = XFS_BUF_SET_PTR(bp, offset, bufblks);
+			if (error2 && !error)
+				error = error2;
 			if (error)
 				break;
+
 		}
 
 		offset = xlog_align(log, start_block, endcount, bp);
@@ -3422,6 +3426,8 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
 			} else {
+				int error2;
+
 				/* This LR is split across physical log end */
 				if (blk_no != log->l_logBBsize) {
 					/* some data before physical log end */
@@ -3456,11 +3462,12 @@ xlog_do_recovery_pass(
 
 				error = xlog_bread_noalign(log, 0,
 							   wrapped_hblks, hbp);
-				if (error)
-					goto bread_err2;
 
-				error = XFS_BUF_SET_PTR(hbp, offset,
+				/* must reset buffer pointer even on error */
+				error2 = XFS_BUF_SET_PTR(hbp, offset,
 							BBTOB(hblks));
+				if (error2 && !error)
+					error = error2;
 				if (error)
 					goto bread_err2;
 			}
@@ -3480,6 +3487,8 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
 			} else {
+				int error2;
+
 				/* This log record is split across the
 				 * physical end of log */
 				offset = XFS_BUF_PTR(dbp);
@@ -3518,12 +3527,12 @@ xlog_do_recovery_pass(
 					goto bread_err2;
 
 				error = xlog_bread_noalign(log, wrapped_hblks,
-						bblks - split_bblks,
-						dbp);
-				if (error)
-					goto bread_err2;
+						bblks - split_bblks, dbp);
 
-				error = XFS_BUF_SET_PTR(dbp, offset, h_size);
+				/* must reset buffer pointer even on error */
+				error2 = XFS_BUF_SET_PTR(dbp, offset, h_size);
+				if (error2 && !error)
+					error = error2;
 				if (error)
 					goto bread_err2;
 			}
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
