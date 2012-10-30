Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UIbB58065263 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 13:37:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lfZONm4OLY9mDUlP for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 11:39:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TSzZe-0004Sg-Jo
	for xfs@oss.sgi.com; Tue, 30 Oct 2012 11:20:54 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TSzZe-0007jx-9X
	for xfs@oss.sgi.com; Tue, 30 Oct 2012 11:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix buffer shudown reference count mismatch
Date: Tue, 30 Oct 2012 11:20:54 +1100
Message-Id: <1351556454-29723-1-git-send-email-david@fromorbit.com>
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

When we shut down the filesystem, we have to unpin and free all the
buffers currently active in the CIL. To do this we unpin and remove
them in one operation as a result of a failed iclogbuf write. For
buffers, we do this removal via a simultated IO completion of after
marking the buffer stale.

At the time we do this, we have two references to the buffer - the
active LRU reference and the buf log item.  The LRU reference is
removed by marking the buffer stale, and the active CIL reference is
by the xfs_buf_iodone() callback that is run by
xfs_buf_do_callbacks() during ioend processing (via the bp->b_iodone
callback).

However, ioend processing requires one more reference - that of the
IO that it is completing. We don't have this reference, so we free
the buffer prematurely and use it after it is freed. This leads to
assert failures in xfs_buf_rele() on debug kernels because the
b_hold count is zero.

Fix this by making sure we take the necessary IO reference before
starting IO completion processing on the stale buffer.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a8d0ed9..b72fe88 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -526,7 +526,23 @@ xfs_buf_item_unpin(
 		}
 		xfs_buf_relse(bp);
 	} else if (freed && remove) {
+		/*
+		 * There are currently two references to the buffer - the active
+		 * LRU reference and the buf log item. What we are about to do
+		 * here - simulate a failed IO completion - requires 3
+		 * references.
+		 *
+		 * The LRU reference is removed by the xfs_buf_stale() call. The
+		 * buf item reference is removed by the xfs_buf_iodone()
+		 * callback that is run by xfs_buf_do_callbacks() during ioend
+		 * processing (via the bp->b_iodone callback), and then finally
+		 * the ioend processing drops the IO reference.
+		 *
+		 * Hence we need to take an additional reference here so that IO
+		 * completion processing doesn't free the buffer prematurely.
+		 */
 		xfs_buf_lock(bp);
+		xfs_buf_hold(bp);
 		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_UNDONE(bp);
 		xfs_buf_stale(bp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
