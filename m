Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAC29um5187017 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 20:09:56 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	R8Hiro8lNfM21bVy for <xfs@oss.sgi.com>;
	Sun, 11 Nov 2012 18:11:56 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXjVC-00047h-5j
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 13:11:54 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXjV7-0007iM-1L
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 13:11:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: drop buffer io reference when a bad bio is built
Date: Mon, 12 Nov 2012 13:11:48 +1100
Message-Id: <1352686309-29624-1-git-send-email-david@fromorbit.com>
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

Error handling in xfs_buf_ioapply_map() does not handle IO reference
counts correctly. We increment the b_io_remaining count before
building the bio, but then fail to decrement it in the failure case.
This leads to the buffer never running IO completion and releasing
the reference that the IO holds, so at unmount we can leak the
buffer. This leak is captured by this assert failure during unmount:

XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/xfs_mount.c, line: 273

This is not a new bug - the b_io_remaining accounting has had this
problem for a long, long time - it's just very hard to get a
zero length bio being built by this code...

Further, the buffer IO error can be overwritten on a multi-segment
buffer by subsequent bio completions for partial sections of the
buffer. Hence we should only set the buffer error status if the
buffer is not already carrying an error status. This ensures that a
partial IO error on a multi-segment buffer will not be lost. This
part of the problem is a regression, however.

cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aacd017..26673a0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1210,9 +1210,14 @@ xfs_buf_bio_end_io(
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
 
-	xfs_buf_ioerror(bp, -error);
+	/*
+	 * don't overwrite existing errors - otherwise we can lose errors on
+	 * buffers that require multiple bios to complete.
+	 */
+	if (!bp->b_error)
+		xfs_buf_ioerror(bp, -error);
 
-	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
 	_xfs_buf_ioend(bp, 1);
@@ -1292,6 +1297,11 @@ next_chunk:
 		if (size)
 			goto next_chunk;
 	} else {
+		/*
+		 * This is guaranteed not to be the last io reference count
+		 * because the caller (xfs_buf_iorequest) holds a count itself.
+		 */
+		atomic_dec(&bp->b_io_remaining);
 		xfs_buf_ioerror(bp, EIO);
 		bio_put(bio);
 	}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
