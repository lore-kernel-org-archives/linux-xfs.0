Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3CEE7F9A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E18658F804C
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	G5gHe9zGISclVZGy for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nA-Rz
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gP-Qd
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/11] xfs: Don't use xfs_buf_iowait in the delwri buffer code
Date: Thu, 25 Sep 2014 22:34:12 +1000
Message-Id: <1411648461-29003-3-git-send-email-david@fromorbit.com>
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

For the special case of delwri buffer submission and waiting, we
don't need to issue IO synchronously at all. The second pass to call
xfs_buf_iowait() can be replaced with  blocking on xfs_buf_lock() -
the buffer will be unlocked when the async IO is complete.

This formalises a sane the method of waiting for async IO - take an
extra reference, submit the IO, call xfs_buf_lock() when you want to
wait for IO completion. i.e.:

	bp = xfs_buf_find();
	xfs_buf_hold(bp);
	bp->b_flags |= XBF_ASYNC;
	xfs_buf_iosubmit(bp);
	xfs_buf_lock(bp)
	error = bp->b_error;
	....
	xfs_buf_relse(bp);

While this is somewhat racy for gathering IO errors, none of the
code that calls xfs_buf_delwri_submit() will race against other
users of the buffers being submitted. Even if they do, we don't
really care if the error is detected by the delwri code or the user
we raced against. Either way, the error will be detected and
handled.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ec65050..f1bd238 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1813,12 +1813,17 @@ __xfs_buf_delwri_submit(
 	blk_start_plug(&plug);
 	list_for_each_entry_safe(bp, n, io_list, b_list) {
 		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
-		bp->b_flags |= XBF_WRITE;
+		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
 
-		if (!wait) {
-			bp->b_flags |= XBF_ASYNC;
+		/*
+		 * we do all Io submission async. This means if we need to wait
+		 * for IO completion we need to take an extra reference so the
+		 * buffer is still valid on the other side.
+		 */
+		if (wait)
+			xfs_buf_hold(bp);
+		else
 			list_del_init(&bp->b_list);
-		}
 		xfs_bdstrat_cb(bp);
 	}
 	blk_finish_plug(&plug);
@@ -1866,7 +1871,10 @@ xfs_buf_delwri_submit(
 		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
 
 		list_del_init(&bp->b_list);
-		error2 = xfs_buf_iowait(bp);
+
+		/* locking the buffer will wait for async IO completion. */
+		xfs_buf_lock(bp);
+		error2 = bp->b_error;
 		xfs_buf_relse(bp);
 		if (!error)
 			error = error2;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
