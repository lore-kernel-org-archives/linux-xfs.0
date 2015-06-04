Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 589527FFC
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 01:23:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3792AC002
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 23:23:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UNNbRY2pG4l7wW9n for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 23:23:40 -0700 (PDT)
Date: Thu, 4 Jun 2015 16:23:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150604062337.GK9143@dastard>
References: <CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard> <20150604012530.GG9143@dastard>
	<20150604020339.GI9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150604020339.GI9143@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 04, 2015 at 12:03:39PM +1000, Dave Chinner wrote:
> Fixing this requires a tweak to the algorithm in
> __xfs_buf_delwri_submit() so that we don't lock an entire list of
> thousands of IOs before starting submission. In the mean time,
> reducing the number of AGs will reduce the impact of this because
> the delayed write submission code will skip buffers that are already
> locked or pinned in memory, and hence an AG under modification at
> the time submission occurs will be skipped by the delwri code.

You might like to try the patch below on a test machine to see if
it helps with the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: reduce lock hold times in buffer writeback

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 80 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index bbe4e9e..8d2cc36 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1768,15 +1768,63 @@ xfs_buf_cmp(
 	return 0;
 }
 
+static void
+xfs_buf_delwri_submit_buffers(
+	struct list_head	*buffer_list,
+	struct list_head	*io_list,
+	bool			wait)
+{
+	struct xfs_buf		*bp, *n;
+	struct blk_plug		plug;
+
+	blk_start_plug(&plug);
+	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
+		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC |
+				  XBF_WRITE_FAIL);
+		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
+
+		/*
+		 * We do all IO submission async. This means if we need
+		 * to wait for IO completion we need to take an extra
+		 * reference so the buffer is still valid on the other
+		 * side. We need to move the buffer onto the io_list
+		 * at this point so the caller can still access it.
+		 */
+		if (wait) {
+			xfs_buf_hold(bp);
+			list_move_tail(&bp->b_list, io_list);
+		} else
+			list_del_init(&bp->b_list);
+
+		xfs_buf_submit(bp);
+	}
+	blk_finish_plug(&plug);
+}
+
+/*
+ * submit buffers for write.
+ *
+ * When we have a large buffer list, we do not want to hold all the buffers
+ * locked while we block on the request queue waiting for IO dispatch. To avoid
+ * this problem, we lock and submit buffers in groups of 50, thereby minimising
+ * the lock hold times for lists which may contain thousands of objects.
+ *
+ * To do this, we sort the buffer list before we walk the list to lock and
+ * submit buffers, and we plug and unplug around each group of buffers we
+ * submit.
+ */
 static int
 __xfs_buf_delwri_submit(
 	struct list_head	*buffer_list,
 	struct list_head	*io_list,
 	bool			wait)
 {
-	struct blk_plug		plug;
 	struct xfs_buf		*bp, *n;
+	LIST_HEAD		(submit_list);
 	int			pinned = 0;
+	int			count = 0;
+
+	list_sort(NULL, buffer_list, xfs_buf_cmp);
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		if (!wait) {
@@ -1802,30 +1850,24 @@ __xfs_buf_delwri_submit(
 			continue;
 		}
 
-		list_move_tail(&bp->b_list, io_list);
+		list_move_tail(&bp->b_list, &submit_list);
 		trace_xfs_buf_delwri_split(bp, _RET_IP_);
-	}
-
-	list_sort(NULL, io_list, xfs_buf_cmp);
-
-	blk_start_plug(&plug);
-	list_for_each_entry_safe(bp, n, io_list, b_list) {
-		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
-		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
 
 		/*
-		 * we do all Io submission async. This means if we need to wait
-		 * for IO completion we need to take an extra reference so the
-		 * buffer is still valid on the other side.
+		 * We do small batches of  IO submission to minimise lock hold
+		 * time and unnecessary writeback of buffers that are hot and
+		 * would otherwise be relogged and hence not require immediate
+		 * writeback.
 		 */
-		if (wait)
-			xfs_buf_hold(bp);
-		else
-			list_del_init(&bp->b_list);
+		if (count++ < 50)
+			continue;
 
-		xfs_buf_submit(bp);
+		xfs_buf_delwri_submit_buffers(&submit_list, io_list, wait);
+		count = 0;
 	}
-	blk_finish_plug(&plug);
+
+	if (!list_empty(&submit_list))
+		xfs_buf_delwri_submit_buffers(&submit_list, io_list, wait);
 
 	return pinned;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
