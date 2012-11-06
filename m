Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA65BtL6029712 for <xfs@oss.sgi.com>; Mon, 5 Nov 2012 23:11:55 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8MAoTFW6or438isz for <xfs@oss.sgi.com>;
	Mon, 05 Nov 2012 21:13:50 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TVbTk-0006RF-Ph
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:36 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TVbTk-0004WR-La
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/22] xfs: verify AGFL blocks as they are read from disk
Date: Tue,  6 Nov 2012 16:13:17 +1100
Message-Id: <1352178813-17216-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1352178813-17216-1-git-send-email-david@fromorbit.com>
References: <1352178813-17216-1-git-send-email-david@fromorbit.com>
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

Add an AGFL block verify callback function and pass it into the
buffer read functions.

While this commit adds verification code to the AGFL, it cannot be
used reliably until the CRC format change comes along as mkfs does
not initialise the full AGFL. Hence it can be full of garbage at the
first mount and will fail verification right now. CRC enabled
filesystems won't have this problem, so leave the code that has
already been written ifdef'd out until the proper time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Phil White <pwhite@sgi.com>
---
 fs/xfs/xfs_alloc.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index dbb32cc6..accb5b7 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -430,6 +430,43 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
+void
+xfs_agfl_read_verify(
+	struct xfs_buf	*bp)
+{
+#ifdef WHEN_CRCS_COME_ALONG
+	/*
+	 * we cannot actually do any verification of the AGFL because mkfs does
+	 * not initialise the AGFL to zero or NULL. Hence the only valid part of
+	 * the AGFL is what the AGF says is active. We can't get to the AGF, so
+	 * we can't verify just those entries are valid.
+	 *
+	 * This problem goes away when the CRC format change comes along as that
+	 * requires the AGFL to be initialised by mkfs. At that point, we can
+	 * verify the blocks in the agfl -active or not- lie within the bounds
+	 * of the AG. Until then, just leave this check ifdef'd out.
+	 */
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
+	int		agfl_ok = 1;
+
+	int		i;
+
+	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
+		if (be32_to_cpu(agfl->agfl_bno[i]) == NULLAGBLOCK ||
+		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
+			agfl_ok = 0;
+	}
+
+	if (!agfl_ok) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agfl);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+#endif
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 /*
  * Read in the allocation group free block array.
  */
@@ -447,7 +484,7 @@ xfs_alloc_read_agfl(
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, xfs_agfl_read_verify);
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
