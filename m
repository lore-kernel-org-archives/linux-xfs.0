Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8865C7CF6
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 23:33:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BD3E304032
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 21:33:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZTObXBzRQNH1kRwS for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2016 21:33:24 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 36D7314A04
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 23:33:24 -0500 (CDT)
Subject: [PATCH 3/1] xfs: don't reset b_retries to 0 on every failure
References: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <19d91779-cfb2-182d-e298-b4d5d1575182@sandeen.net>
Date: Fri, 8 Jul 2016 23:33:23 -0500
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

With the code as it stands today, b_retries never increments
because it gets reset to 0 in the error callback.

Remove that, and fix a similar problem where the first retry
time was constantly being overwritten, which defeated the
timeout tunable as well.

We now only set first retry time if a non-zero timeout is
set, to match the behavior of only incrementing retries if
a retry value is set.

This way max retries & timeouts consistently take effect after
a tunable is set, rather than acting retroactively on a buffer
which has failed at some point in the past and has accumulated
state from those prior failures.

Thanks to dchinner for talking through this with me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 6a2f429..3b19e52 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1073,6 +1073,8 @@ xfs_buf_iodone_callback_error(
 	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
 	ASSERT(bp->b_iodone != NULL);
 
+	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+
 	/*
 	 * If the write was asynchronous then no one will be looking for the
 	 * error.  If this is the first failure of this type, clear the error
@@ -1084,8 +1086,8 @@ xfs_buf_iodone_callback_error(
 	     bp->b_last_error != bp->b_error) {
 		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
 		bp->b_last_error = bp->b_error;
-		bp->b_retries = 0;
-		bp->b_first_retry_time = jiffies;
+		if (cfg->retry_timeout && !bp->b_first_retry_time)
+			bp->b_first_retry_time = jiffies;
 
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_submit(bp);
@@ -1096,7 +1098,6 @@ xfs_buf_iodone_callback_error(
 	 * Repeated failure on an async write. Take action according to the
 	 * error configuration we have been set up to use.
 	 */
-	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
 
 	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
 	    ++bp->b_retries > cfg->max_retries)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
