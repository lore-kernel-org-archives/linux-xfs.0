Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52VOo134500 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lyf1MqlYIG3J6HTG for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:10 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZQ-0003Dw-Jf
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZQ-0003bI-HP
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 002/102] xfs: remove dead ENODEV handling in xfs_destroy_ioend
Date: Thu, 23 Aug 2012 15:01:20 +1000
Message-Id: <1345698180-13612-3-git-send-email-david@fromorbit.com>
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

Upstream commit: 398d25ef23b10ce75424e0336a8d059dda1dbc8d

No driver returns ENODEV from it bio completion handler, not has this
ever been documented.  Remove the dead code dealing with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 79ce38b..05df3a8 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -122,17 +122,6 @@ xfs_destroy_ioend(
 		bh->b_end_io(bh, !ioend->io_error);
 	}
 
-	/*
-	 * Volume managers supporting multiple paths can send back ENODEV
-	 * when the final path disappears.  In this case continuing to fill
-	 * the page cache with dirty data which cannot be written out is
-	 * evil, so prevent that.
-	 */
-	if (unlikely(ioend->io_error == -ENODEV)) {
-		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ,
-				      __FILE__, __LINE__);
-	}
-
 	xfs_ioend_wake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
