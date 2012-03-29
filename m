Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TC7wV7085819 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:07:59 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L4occSpNbq6rLWzL for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:07:55 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDE8u-0003dh-Jt
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:07:52 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDE8U-0003JN-LV
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:07:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix buffer lookup race on allocation failure
Date: Thu, 29 Mar 2012 23:07:26 +1100
Message-Id: <1333022846-12697-1-git-send-email-david@fromorbit.com>
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

When memory allocation fails to add the page array or tht epages to
a buffer during xfs_buf_get(), the buffer is left in the cache in a
partially initialised state. There is enough state left for the next
lookup on that buffer to find the buffer, and for the buffer to then
be used without finishing the initialisation.  As a result, when an
attempt to do IO on the buffer occurs, it fails with EIO because
there are no pages attached to the buffer.

We cannot remove the buffer from the cache immediately and free it,
because there may already be a racing lookup that is blocked on the
buffer lock. hence the moment we unlock the buffer to then free it,
the other user is woken and we have a use-after-free situation.

Hence we have to mark the buffer as "broken" and check that after we
have gained the buffer lock on a cache hit lookup. This enables
racing lookups to avoid the broken buffer and drop their references,
allowing the buffer to be freed.

This however, doesn't solve the problem completely - there may be a
delay in the buffer getting freed (e.g. pre-emption), so when we try
the lookup a second time with a new buffer to insert into the tree,
if we find the broken buffer again, drop the buffer lock, sleep for
a short while, and try the lookup again. When the broken bufer is
finally removed from the cache we will make forwards progress.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   |   33 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf.h   |    2 ++
 fs/xfs/xfs_trace.h |    2 ++
 3 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6819b51..3588460 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -441,6 +441,7 @@ _xfs_buf_find(
 	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
 
 	/* get tree root */
+lookup_again:
 	pag = xfs_perag_get(btp->bt_mount,
 				xfs_daddr_to_agno(btp->bt_mount, ioff));
 
@@ -505,6 +506,24 @@ found:
 	}
 
 	/*
+	 * If the buffer initialisation was not completed correctly after
+	 * insertion into the cache we can't use this buffer and we are pinning
+	 * it preventing it from being removed from the cache. Hence just avoid
+	 * the buffer if it is broken, allowing it to be reclaimed and removed
+	 * from the cache. If we are here with a new buffer to insert into the
+	 * cache, we want to try the lookup again so that the expected "insert
+	 * on lookup failure" semantics are preserved for this case.
+	 */
+	if (bp->b_flags & XBF_BROKEN) {
+		trace_xfs_buf_find_broken(bp, flags, _RET_IP_);
+		xfs_buf_relse(bp);
+		if (!new_bp)
+			return NULL;
+		delay(1);
+		goto lookup_again;
+	}
+
+	/*
 	 * if the buffer is stale, clear all the external state associated with
 	 * it. We need to keep flags such as how we allocated the buffer memory
 	 * intact here.
@@ -552,8 +571,20 @@ xfs_buf_get(
 
 	if (bp == new_bp) {
 		error = xfs_buf_allocate_memory(bp, flags);
-		if (error)
+		if (error) {
+			/*
+			 * The buffer has been inserted into the cache now, so
+			 * will be visible to other callers. Once we unlock the
+			 * buffer, someone else can grab it out of the tree.
+			 * It's a broken buffer, so we have to ensure that it is
+			 * noticed - just freeing the buffer here can result in
+			 * use-after-free if someone is already waiting on the
+			 * buffer lock.
+			 */
+			bp->b_flags |= XBF_BROKEN;
+			trace_xfs_buf_get_broken(bp, flags, _RET_IP_);
 			goto no_buffer;
+		}
 	} else
 		kmem_zone_free(xfs_buf_zone, new_bp);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 5bf3be4..aa8cbd5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -51,6 +51,7 @@ typedef enum {
 #define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
 #define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
 #define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
+#define XBF_BROKEN	(1 << 8) /* buffer is broken, do not find it */
 
 /* I/O hints for the BIO layer */
 #define XBF_SYNCIO	(1 << 10)/* treat this buffer as synchronous I/O */
@@ -78,6 +79,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_DELWRI,		"DELWRI" }, \
 	{ XBF_STALE,		"STALE" }, \
+	{ XBF_BROKEN,		"BROKEN" }, \
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 06838c4..2478cb8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -386,7 +386,9 @@ DEFINE_EVENT(xfs_buf_flags_class, name, \
 	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
 	TP_ARGS(bp, flags, caller_ip))
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_find_broken);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_get_broken);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
 
 TRACE_EVENT(xfs_buf_ioerror,
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
