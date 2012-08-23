Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54X2h135812 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:33 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fc4lvSzluptddHDs for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbV-0003Jf-5c
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbV-0003iY-1g
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 086/102] xfs: Properly exclude IO type flags from buffer flags
Date: Thu, 23 Aug 2012 15:02:44 +1000
Message-Id: <1345698180-13612-87-git-send-email-david@fromorbit.com>
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

Upstream commit: 12bcb3f7d4371f74bd25372e98e0d2da978e82b2

Recent event tracing during a debugging session showed that flags
that define the IO type for a buffer are leaking into the flags on
the buffer incorrectly. Fix the flag exclusion mask in
xfs_buf_alloc() to avoid problems that may be caused by such
leakage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 522ab83..a87b93a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -175,9 +175,11 @@ xfs_buf_alloc(
 		return NULL;
 
 	/*
-	 * We don't want certain flags to appear in b_flags.
+	 * We don't want certain flags to appear in b_flags unless they are
+	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
+	flags &= ~(XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK |
+		   XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
