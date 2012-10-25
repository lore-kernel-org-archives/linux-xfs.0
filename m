Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6X5uU102596 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:33:05 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4ZovnjYg3TsENFft for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1a-00009s-9i
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:38 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1L-00053n-5V
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/25] xfs: verify AGF blocks as they are read from disk
Date: Thu, 25 Oct 2012 17:33:55 +1100
Message-Id: <1351146854-19343-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1351146854-19343-1-git-send-email-david@fromorbit.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_alloc.c |   60 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 21c3db0..bd565a2 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2091,6 +2091,39 @@ xfs_alloc_put_freelist(
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
+		XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
+				     XFS_ERRLEVEL_LOW, mp, agf);
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
@@ -2102,44 +2135,19 @@ xfs_read_agf(
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
