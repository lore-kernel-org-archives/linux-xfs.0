Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54W3V135800 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Zf9M9sMNa70gnVxH for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbV-0003JN-1U
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbK-0003iI-Sp
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 084/102] xfs: use kmem_zone_zalloc for buffers
Date: Thu, 23 Aug 2012 15:02:42 +1000
Message-Id: <1345698180-13612-85-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: bf813cdddfb3a5bc88e1612e8f62a12367871213

To replace the alloc/memset pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 3e9946c..522ab83 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -170,7 +170,7 @@ xfs_buf_alloc(
 {
 	struct xfs_buf		*bp;
 
-	bp = kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags));
+	bp = kmem_zone_zalloc(xfs_buf_zone, xb_to_km(flags));
 	if (unlikely(!bp))
 		return NULL;
 
@@ -179,7 +179,6 @@ xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
 
-	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
