Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N535s8134910 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:05 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	D0nTPxbLBCdC8t8W for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003FY-5k
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZl-0003cY-1P
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 018/102] xfs: do not flush data workqueues in xfs_flush_buftarg
Date: Thu, 23 Aug 2012 15:01:36 +1000
Message-Id: <1345698180-13612-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 5a93a064d27b42e4af1772b0599b53e3241191ac

When we call xfs_flush_buftarg (generally from sync or umount) it already
is too late to flush the data workqueues, as I/O completion is signalled
for them and we are thus already done with the data we would flush here.

There are places where flushing them might be useful, but the current
sync interface doesn't give us that opportunity.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 82fe480..4508ec2 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1670,13 +1670,6 @@ xfs_buf_delwri_promote(
 	spin_unlock(&btp->bt_delwrite_lock);
 }
 
-STATIC void
-xfs_buf_runall_queues(
-	struct workqueue_struct	*queue)
-{
-	flush_workqueue(queue);
-}
-
 /*
  * Move as many buffers as specified to the supplied list
  * idicating if we skipped any buffers to prevent deadlocks.
@@ -1811,9 +1804,7 @@ xfs_flush_buftarg(
 	LIST_HEAD(wait_list);
 	struct blk_plug plug;
 
-	xfs_buf_runall_queues(xfsconvertd_workqueue);
-	xfs_buf_runall_queues(xfsdatad_workqueue);
-	xfs_buf_runall_queues(xfslogd_workqueue);
+	flush_workqueue(xfslogd_workqueue);
 
 	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
