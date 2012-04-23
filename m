Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xSN6127479 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:28 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rXKDTwuKaQhsAHeh for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:26 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIy-0001ab-VC
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:21 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIy-0004YI-RS
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/37] xfs: use kmem_zone_zalloc for buffers
Date: Mon, 23 Apr 2012 15:58:48 +1000
Message-Id: <1335160747-17254-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

To replace the alloc/memset pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ddfc58f..f463dce 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -178,7 +178,7 @@ xfs_buf_alloc(
 {
 	struct xfs_buf		*bp;
 
-	bp = kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags));
+	bp = kmem_zone_zalloc(xfs_buf_zone, xb_to_km(flags));
 	if (unlikely(!bp))
 		return NULL;
 
@@ -187,7 +187,6 @@ xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
 
-	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
