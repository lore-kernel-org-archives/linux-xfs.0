Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60CDF7CEC
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 23:26:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 314B18F8033
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 21:26:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ggy3KisGBlFimNmz for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2016 21:26:14 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 73E2C14A04
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 23:26:14 -0500 (CDT)
Subject: [PATCH 2/1] xfs: fix xfs_error_get_cfg for negative errnos
References: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c803d93a-ad47-faf1-5288-62da612646a9@sandeen.net>
Date: Fri, 8 Jul 2016 23:26:13 -0500
MIME-Version: 1.0
In-Reply-To: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
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
To: xfs@oss.sgi.com

Fix up a couple places where flag manipulation is unclear.

In the first case we clear XBF_ASYNC and then immediately
reset it.

In the 2nd case we are at a point in the function where the
buffer must already be async, so no need to reset it.

Add consistent spacing around the " | " while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e71cfbd..5d52e44 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1816,7 +1816,7 @@ __xfs_buf_delwri_submit(
 
 	blk_start_plug(&plug);
 	list_for_each_entry_safe(bp, n, io_list, b_list) {
-		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
+		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
 		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
 
 		/*
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3425799..6a2f429 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1080,10 +1080,9 @@ xfs_buf_iodone_callback_error(
 	 * async write failure at least once, but we also need to set the buffer
 	 * up to behave correctly now for repeated failures.
 	 */
-	if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL)) ||
+	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
 	     bp->b_last_error != bp->b_error) {
-		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
-			        XBF_DONE | XBF_WRITE_FAIL);
+		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
 		bp->b_last_error = bp->b_error;
 		bp->b_retries = 0;
 		bp->b_first_retry_time = jiffies;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
