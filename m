Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA23LOUm075949 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 22:21:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5vAG6UfIVhShT4D2 for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 20:23:15 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TU7qi-0004nt-QE
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 14:23:12 +1100
Date: Fri, 2 Nov 2012 14:23:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6 V2] xfs: fix buffer shudown reference count mismatch
Message-ID: <20121102032312.GW29378@dastard>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102024351.GU29378@dastard>
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

xfs: fix buffer shudown reference count mismatch

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
the buffer prematurely and use it after it is freed. For buffers
marked with XBF_ASYNC, this leads to assert failures in
xfs_buf_rele() on debug kernels because the b_hold count is zero.

Fix this by making sure we take the necessary IO reference before
starting IO completion processing on the stale buffer, and set the
XBF_ASYNC flag to ensure that IO completion processing removes all
the active references from the buffer to ensure it is fully torn
down.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2 - add XBF_ASYNC to buffers so last reference is always removed.
     Fixes shutdown assert failures due to references from buffers
     remaining the perag structures at unmount.

 fs/xfs/xfs_buf_item.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a8d0ed9..becf4a9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -526,7 +526,25 @@ xfs_buf_item_unpin(
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
+		 * the ioend processing will drop the IO reference if the buffer
+		 * is marked XBF_ASYNC.
+		 *
+		 * Hence we need to take an additional reference here so that IO
+		 * completion processing doesn't free the buffer prematurely.
+		 */
 		xfs_buf_lock(bp);
+		xfs_buf_hold(bp);
+		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_UNDONE(bp);
 		xfs_buf_stale(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
