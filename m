Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q993o7cO212947 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 22:50:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5kQ2622CK6lkoKI0 for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 20:51:36 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLQqq-0002PW-G5
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:24 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLQqg-0008PC-D2
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/19] xfs: verify AGFL blocks as they are read from disk
Date: Tue,  9 Oct 2012 14:50:58 +1100
Message-Id: <1349754670-32009-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1349754670-32009-1-git-send-email-david@fromorbit.com>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
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
buffer read functions. Add a debug only check for valid block
numbers in the AGFL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index bd565a2..75c5d82 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -430,6 +430,29 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
+void
+xfs_agfl_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
+	int		agfl_ok = 1;
+	int		i;
+
+	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
+		if (agfl->agfl_bno[i] == 0)
+			agfl = 0;
+	}
+
+	if (!agfl_ok) {
+		XFS_CORRUPTION_ERROR("xfs_agfl_read_verify",
+				     XFS_ERRLEVEL_LOW, mp, agfl);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 /*
  * Read in the allocation group free block array.
  */
@@ -447,7 +470,7 @@ xfs_alloc_read_agfl(
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
