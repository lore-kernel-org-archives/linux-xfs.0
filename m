Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55G7G136154 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	p1zXuuAwbpW7oLKe for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:06:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pc9-0003Kp-Ko
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbz-0003jn-Gp
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 101/102] xfs: prevent recursion in xfs_buf_iorequest
Date: Thu, 23 Aug 2012 15:02:59 +1000
Message-Id: <1345698180-13612-102-git-send-email-david@fromorbit.com>
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

Upstream commit: 40a9b7963df32e743c45d79a5f41445fe2476f15

If the b_iodone handler is run in calling context in xfs_buf_iorequest we
can run into a recursion where xfs_buf_iodone_callbacks keeps calling back
into xfs_buf_iorequest because an I/O error happened, which keeps calling
back into xfs_buf_iorequest.  This chain will usually not take long
because the filesystem gets shut down because of log I/O errors, but even
over a short time it can cause stack overflows if run on the same context.

As a short term workaround make sure we always call the iodone handler in
workqueue context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index a87b93a..c74d027 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1309,7 +1309,7 @@ xfs_buf_iorequest(
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
 	_xfs_buf_ioapply(bp);
-	_xfs_buf_ioend(bp, 0);
+	_xfs_buf_ioend(bp, 1);
 
 	xfs_buf_rele(bp);
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
