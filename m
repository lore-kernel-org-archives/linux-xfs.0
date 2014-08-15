Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7CBA7F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B94928F8084
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bC7dqnQFtzshcOdF for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZU-C0
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001Ue-BC
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: kill xfs_bioerror_relse
Date: Fri, 15 Aug 2014 16:39:04 +1000
Message-Id: <1408084747-4540-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1408084747-4540-1-git-send-email-david@fromorbit.com>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
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

There is only one caller now - xfs_trans_read_buf_map() - and it has
very well defined call semantics - read, synchronous, and b_iodone
is NULL. Hence it's pretty clear what error handling is necessary
for this case. The bigger problem of untangling
xfs_trans_read_buf_map error handling is left to a future patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c       | 39 ---------------------------------------
 fs/xfs/xfs_buf.h       |  2 --
 fs/xfs/xfs_trans_buf.c |  8 +++++---
 3 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f444285..352e9219 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1071,45 +1071,6 @@ xfs_buf_ioerror_alert(
 		(__uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
 }
 
-/*
- * Same as xfs_bioerror, except that we are releasing the buffer
- * here ourselves, and avoiding the xfs_buf_ioend call.
- * This is meant for userdata errors; metadata bufs come with
- * iodone functions attached, so that we can track down errors.
- */
-int
-xfs_bioerror_relse(
-	struct xfs_buf	*bp)
-{
-	int64_t		fl = bp->b_flags;
-	/*
-	 * No need to wait until the buffer is unpinned.
-	 * We aren't flushing it.
-	 *
-	 * chunkhold expects B_DONE to be set, whether
-	 * we actually finish the I/O or not. We don't want to
-	 * change that interface.
-	 */
-	XFS_BUF_UNREAD(bp);
-	XFS_BUF_DONE(bp);
-	xfs_buf_stale(bp);
-	bp->b_iodone = NULL;
-	if (!(fl & XBF_ASYNC)) {
-		/*
-		 * Mark b_error and B_ERROR _both_.
-		 * Lot's of chunkcache code assumes that.
-		 * There's no reason to mark error for
-		 * ASYNC buffers.
-		 */
-		xfs_buf_ioerror(bp, -EIO);
-		complete(&bp->b_iowait);
-	} else {
-		xfs_buf_relse(bp);
-	}
-
-	return -EIO;
-}
-
 int
 xfs_bwrite(
 	struct xfs_buf		*bp)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 44db8cd..d8f57f6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -297,8 +297,6 @@ extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 #define xfs_buf_zero(bp, off, len) \
 	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
 
-extern int xfs_bioerror_relse(struct xfs_buf *);
-
 /* Buffer Utility Routines */
 extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 96c898e..758c07d 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -324,11 +324,13 @@ xfs_trans_read_buf_map(
 			 */
 			if (XFS_FORCED_SHUTDOWN(mp)) {
 				trace_xfs_bdstrat_shut(bp, _RET_IP_);
-				xfs_bioerror_relse(bp);
-			} else {
-				xfs_buf_iorequest(bp);
+				bp->b_flags &= ~(XBF_READ | XBF_DONE);
+				xfs_buf_ioerror(bp, -EIO);
+				xfs_buf_stale(bp);
+				return -EIO;
 			}
 
+			xfs_buf_iorequest(bp);
 			error = xfs_buf_iowait(bp);
 			if (error) {
 				xfs_buf_ioerror_alert(bp, __func__);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
