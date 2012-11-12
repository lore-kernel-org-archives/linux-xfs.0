Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBs2Qd217918 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:54:02 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BHXXkRSCSgfdkJlj for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:56:03 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsbm-00054x-Sc
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:18 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsbm-000142-PU
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/32] xfs: add buffer pre-write callback
Date: Mon, 12 Nov 2012 22:54:19 +1100
Message-Id: <1352721264-3700-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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

Add a callback to the buffer write path to enable verification of
the buffer and CRC calculation prior to issuing the write to the
underlying storage.

If the callback function detects some kind of failure or error
condition, it must mark the buffer with an error so that the caller
can take appropriate action. In the case of xfs_buf_ioapply(), a
corrupt metadta buffer willt rigger a shutdown of the filesystem,
because something is clearly wrong and we can't allow corrupt
metadata to be written to disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Phil White <pwhite@sgi.com>
---
 fs/xfs/xfs_buf.c |   16 ++++++++++++++++
 fs/xfs/xfs_buf.h |    3 +++
 2 files changed, 19 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fbc965f..bd1a948 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -569,7 +569,9 @@ found:
 	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
+		ASSERT(bp->b_iodone == NULL);
 		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_pre_io = NULL;
 	}
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
@@ -1324,6 +1326,20 @@ _xfs_buf_ioapply(
 	rw |= REQ_META;
 
 	/*
+	 * run the pre-io callback function if it exists. If this function
+	 * fails it will mark the buffer with an error and the IO should
+	 * not be dispatched.
+	 */
+	if (bp->b_pre_io) {
+		bp->b_pre_io(bp);
+		if (bp->b_error) {
+			xfs_force_shutdown(bp->b_target->bt_mount,
+					   SHUTDOWN_CORRUPT_INCORE);
+			return;
+		}
+	}
+
+	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
 	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 677b1dc..51bc16a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -155,6 +155,9 @@ typedef struct xfs_buf {
 	unsigned int		b_offset;	/* page offset in first page */
 	unsigned short		b_error;	/* error code on I/O */
 
+	void			(*b_pre_io)(struct xfs_buf *);
+						/* pre-io callback function */
+
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
