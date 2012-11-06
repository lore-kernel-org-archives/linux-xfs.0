Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA65Broi029689 for <xfs@oss.sgi.com>; Mon, 5 Nov 2012 23:11:53 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oYp3Rrwq1jZhbU81 for <xfs@oss.sgi.com>;
	Mon, 05 Nov 2012 21:13:48 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TVbTu-0006RE-O8
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:46 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TVbTk-0004WO-Kf
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/22] xfs: verify AGI blocks as they are read from disk
Date: Tue,  6 Nov 2012 16:13:16 +1100
Message-Id: <1352178813-17216-6-git-send-email-david@fromorbit.com>
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

Add an AGI block verify callback function and pass it into the
buffer read functions. Remove the now redundant verification code
that is currently in use.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ialloc.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 12e3dea..dd53858 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1472,6 +1472,30 @@ xfs_check_agi_unlinked(
 #define xfs_check_agi_unlinked(agi)
 #endif
 
+static void
+xfs_agi_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
+	int		agi_ok;
+
+	/*
+	 * Validate the magic number of the agi block.
+	 */
+	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
+		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
+		be32_to_cpu(agi->agi_seqno) == bp->b_pag->pag_agno;
+	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
+			XFS_RANDOM_IALLOC_READ_AGI))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agi);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+	xfs_check_agi_unlinked(agi);
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 /*
  * Read in the allocation group header (inode allocation section)
  */
@@ -1482,38 +1506,18 @@ xfs_read_agi(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
-	struct xfs_agi		*agi;	/* allocation group header */
-	int			agi_ok;	/* agi is consistent */
 	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, bpp, NULL);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp, xfs_agi_read_verify);
 	if (error)
 		return error;
 
 	ASSERT(!xfs_buf_geterror(*bpp));
-	agi = XFS_BUF_TO_AGI(*bpp);
-
-	/*
-	 * Validate the magic number of the agi block.
-	 */
-	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
-		be32_to_cpu(agi->agi_seqno) == agno;
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
-			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
-				     mp, agi);
-		xfs_trans_brelse(tp, *bpp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-
 	xfs_buf_set_ref(*bpp, XFS_AGI_REF);
-
-	xfs_check_agi_unlinked(agi);
 	return 0;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
