Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6D7mTi4076882 for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 02:48:29 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B967615B9692
	for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 00:51:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	i57v71YsQhjeTKeB for <xfs@oss.sgi.com>;
	Tue, 13 Jul 2010 00:51:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: don't block on buffer read errors
Date: Tue, 13 Jul 2010 17:50:49 +1000
Message-Id: <1279007450-10457-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1279007450-10457-1-git-send-email-david@fromorbit.com>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_buf_read() fails to detect dispatch errors before attempting to
wait on sychronous IO. If there was an error, it will get stuck
forever, waiting for an I/O that was never started. Make sure the
error is detected correctly.

Further, such a failure can leave locked pages in the page cache
which will cause a later operation to hang on the page. Ensure that
we correctly process pages in the buffers when we get a dispatch
error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 76bb13c..ec79634 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -578,7 +578,7 @@ _xfs_buf_read(
 			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
 
 	status = xfs_buf_iorequest(bp);
-	if (!status && !(flags & XBF_ASYNC))
+	if (!(status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC)))
 		status = xfs_buf_iowait(bp);
 	return status;
 }
@@ -1280,8 +1280,19 @@ submit_io:
 		if (size)
 			goto next_chunk;
 	} else {
-		bio_put(bio);
+		/*
+		 * if we get here, no pages were added to the bio. However,
+		 * we can't just error out here - if the pages are locked then
+		 * we have to unlock them otherwise we can hang on a later
+		 * access to the page.
+		 */
 		xfs_buf_ioerror(bp, EIO);
+		if (bp->b_flags & _XBF_PAGE_LOCKED) {
+			int i;
+			for (i = 0; i < bp->b_page_count; i++)
+				unlock_page(bp->b_pages[i]);
+		}
+		bio_put(bio);
 	}
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
