Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegVe067667 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:42 -0600
Message-Id: <20121203144311.118348966@sgi.com>
Date: Mon, 03 Dec 2012 17:42:33 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 25/36] xfs: Properly exclude IO type flags from
	buffer flags
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=086
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

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

Index: b/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -177,9 +177,11 @@ xfs_buf_alloc(
 		return NULL;
 
 	/*
-	 * We don't want certain flags to appear in b_flags.
+	 * We don't want certain flags to appear in b_flags unless they are
+	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
+	flags &= ~(XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK |
+		   XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
