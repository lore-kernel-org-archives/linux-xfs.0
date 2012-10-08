Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98Bu0wl063470 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 06:56:00 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	C22pCK1F08YeT91H for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 04:57:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLBxe-0000di-LM
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 22:57:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLBxU-0003he-Gw
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 22:57:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: growfs: don't read garbage for new secondary superblocks
Date: Mon,  8 Oct 2012 22:57:16 +1100
Message-Id: <1349697436-14203-1-git-send-email-david@fromorbit.com>
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

When updating new secondary superblocks in a growfs operation, the
sueprblock buffer is read from the newly grown region of the
underlying device. This is not guaranteed to be zero, so violates
the underlying assumption that the unused parts of superblocks are
zero filled. Get a new buffer for these secondary superblocks to
ensure that the unused regions are zero filled correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c25b094..4beaede 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -399,9 +399,26 @@ xfs_growfs_data_private(
 
 	/* update secondary superblocks. */
 	for (agno = 1; agno < nagcount; agno++) {
-		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+		error = 0;
+		/*
+		 * new secondary superblocks need to be zeroed, not read from
+		 * disk as the contents of the new area we are growing into is
+		 * completely unknown.
+		 */
+		if (agno < oagcount) {
+			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+		} else {
+			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
+				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				  XFS_FSS_TO_BB(mp, 1), 0);
+			if (bp)
+				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+			else
+				error = ENOMEM;
+		}
+
 		if (error) {
 			xfs_warn(mp,
 		"error %d reading secondary superblock for ag %d",
@@ -423,7 +440,7 @@ xfs_growfs_data_private(
 			break; /* no point in continuing */
 		}
 	}
-	return 0;
+	return error;
 
  error0:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
