Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52kOd134654 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:46 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bKipR2khwz77knHY for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:31 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZq-0003Ek-4d
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZg-0003cU-0Q
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 017/102] xfs: use xfs_ioerror_alert in xfs_buf_iodone_callbacks
Date: Thu, 23 Aug 2012 15:01:35 +1000
Message-Id: <1345698180-13612-18-git-send-email-david@fromorbit.com>
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

Upstream commit: b38505b09b7854d446b2f60b4414e3231277aa1a

Use xfs_ioerror_alert instead of opencoding a very similar error
message.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_buf_item.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7888a75..aedebfb 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -986,9 +986,7 @@ xfs_buf_iodone_callbacks(
 	if (XFS_BUF_TARGET(bp) != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
-		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
-			XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
-		      (__uint64_t)XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 	}
 	lasttarg = XFS_BUF_TARGET(bp);
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
