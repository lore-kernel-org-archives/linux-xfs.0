Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA65BsAV029703 for <xfs@oss.sgi.com>; Mon, 5 Nov 2012 23:11:54 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JuB7bAjrzgQvbzdY for <xfs@oss.sgi.com>;
	Mon, 05 Nov 2012 21:13:49 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TVbTu-0006RZ-OK
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:46 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TVbTk-0004WI-Il
	for xfs@oss.sgi.com; Tue, 06 Nov 2012 16:13:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/22] xfs: verify AGF blocks as they are read from disk
Date: Tue,  6 Nov 2012 16:13:15 +1100
Message-Id: <1352178813-17216-5-git-send-email-david@fromorbit.com>
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

Add an AGF block verify callback function and pass it into the
buffer read functions. This replaces the existing verification that
is done after the read completes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_alloc.c |   59 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 34dcb7c..dbb32cc6 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2091,6 +2091,38 @@ xfs_alloc_put_freelist(
 	return 0;
 }
 
+static void
+xfs_agf_read_verify(
+	struct xfs_buf	*bp)
+ {
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_agf	*agf;
+	int		agf_ok;
+
+	agf = XFS_BUF_TO_AGF(bp);
+
+	agf_ok = agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
+		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
+		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
+		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
+		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
+		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
+		be32_to_cpu(agf->agf_seqno) == bp->b_pag->pag_agno;
+
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
+						be32_to_cpu(agf->agf_length);
+
+	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
+			XFS_RANDOM_ALLOC_READ_AGF))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agf);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 /*
  * Read in the allocation group header (free/alloc section).
  */
@@ -2102,44 +2134,19 @@ xfs_read_agf(
 	int			flags,	/* XFS_BUF_ */
 	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
 {
-	struct xfs_agf	*agf;		/* ag freelist header */
-	int		agf_ok;		/* set if agf is consistent */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), flags, bpp, NULL);
+			XFS_FSS_TO_BB(mp, 1), flags, bpp, xfs_agf_read_verify);
 	if (error)
 		return error;
 	if (!*bpp)
 		return 0;
 
 	ASSERT(!(*bpp)->b_error);
-	agf = XFS_BUF_TO_AGF(*bpp);
-
-	/*
-	 * Validate the magic number of the agf block.
-	 */
-	agf_ok =
-		agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
-		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_seqno) == agno;
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
-						be32_to_cpu(agf->agf_length);
-	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
-			XFS_RANDOM_ALLOC_READ_AGF))) {
-		XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
-				     XFS_ERRLEVEL_LOW, mp, agf);
-		xfs_trans_brelse(tp, *bpp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
 	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
 	return 0;
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
