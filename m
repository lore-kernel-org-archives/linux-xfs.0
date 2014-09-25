Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61CF07F9F
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00F95AC00A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	t1DptmG3u0PjhAun for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nD-TZ
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007ge-SW
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/11] xfs: rework xfs_buf_bio_endio error handling
Date: Thu, 25 Sep 2014 22:34:15 +1000
Message-Id: <1411648461-29003-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1411648461-29003-1-git-send-email-david@fromorbit.com>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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

Currently the report of a bio error from completion
immediately marks the buffer with an error. The issue is that this
is racy w.r.t. synchronous IO - the submitter can see b_error being
set before the IO is complete, and hence we cannot differentiate
between submission failures and completion failures.

Add an internal b_io_error field protected by the b_lock to catch IO
completion errors, and only propagate that to the buffer during
final IO completion handling. Hence we can tell in xfs_buf_iorequest
if we've had a submission failure bey checking bp->b_error before
dropping our b_io_remaining reference - that reference will prevent
b_io_error values from being propagated to b_error in the event that
completion races with submission.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 18 ++++++++++++++++--
 fs/xfs/xfs_buf.h |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 08f9fca..a8f4a39 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1008,6 +1008,13 @@ xfs_buf_ioend(
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 
+	/*
+	 * Pull in IO completion errors now. We are guaranteed to be running
+	 * single threaded, so we don't need the lock to read b_io_error.
+	 */
+	if (!bp->b_error && bp->b_io_error)
+		xfs_buf_ioerror(bp, bp->b_io_error);
+
 	/* Only validate buffers that were read without errors */
 	if (read && !bp->b_error && bp->b_ops) {
 		ASSERT(!bp->b_iodone);
@@ -1192,8 +1199,12 @@ xfs_buf_bio_end_io(
 	 * don't overwrite existing errors - otherwise we can lose errors on
 	 * buffers that require multiple bios to complete.
 	 */
-	if (!bp->b_error)
-		xfs_buf_ioerror(bp, error);
+	if (error) {
+		spin_lock(&bp->b_lock);
+		if (!bp->b_io_error)
+			bp->b_io_error = error;
+		spin_unlock(&bp->b_lock);
+	}
 
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
@@ -1379,6 +1390,9 @@ xfs_buf_iorequest(
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
 
+	/* clear the internal error state to avoid spurious errors */
+	bp->b_io_error = 0;
+
 	/*
 	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
 	 * reference for as long as submission takes is all that is necessary
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4585c15..44db8cd 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -158,6 +158,7 @@ typedef struct xfs_buf {
 	struct list_head	b_lru;		/* lru list */
 	spinlock_t		b_lock;		/* internal state lock */
 	unsigned int		b_state;	/* internal state flags */
+	int			b_io_error;	/* internal IO error state */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
