Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N600Za127795 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 01:00:00 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XxzumYRi9jW5kEau for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:59 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCJP-0001bb-9O
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:47 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCJP-0004ZA-6B
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 35/37] xfs: Properly exclude IO type flags from buffer flags
Date: Mon, 23 Apr 2012 15:59:05 +1000
Message-Id: <1335160747-17254-36-git-send-email-david@fromorbit.com>
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

Recent event tracing during a debugging session showed that flags
that define the IO type for a buffer are leaking into the flags on
the buffer incorrectly. Fix the flag exclusion mask in
xfs_buf_alloc() to avoid problems that may be caused by such
leakage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index af8480d..b2795ba 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -178,9 +178,10 @@ xfs_buf_alloc(
 		return NULL;
 
 	/*
-	 * We don't want certain flags to appear in b_flags.
+	 * We don't want certain flags to appear in b_flags unless they are
+	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_MAPPED|XBF_READ_AHEAD);
+	flags &= ~(XBF_MAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
