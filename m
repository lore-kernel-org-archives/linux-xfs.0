Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA85bpAa219493 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 23:37:51 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BGzio1StPDYJmnYz for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 21:39:47 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWKq5-0003NB-5D
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 16:39:41 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWKq0-0004v9-0H
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 16:39:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: growfs: use uncached buffers for new headers
Date: Thu,  8 Nov 2012 16:39:32 +1100
Message-Id: <1352353173-18820-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352353173-18820-1-git-send-email-david@fromorbit.com>
References: <1352353173-18820-1-git-send-email-david@fromorbit.com>
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

When writing the new AG headers to disk, we can't attach write
verifiers because they have a dependency on the struct xfs-perag
being attached to the buffer to be fully initialised and growfs
can't fully initialise them until later in the process.

The simplest way to avoid this problem is to use uncached buffers
for writing the new headers. These buffers don't have the xfs-perag
attached to them, so it's simple to detect in the write verifier and
be able to skip the checks that need the xfs-perag.

This enables us to attach the appropriate buffer ops to the buffer
and hence calculate CRCs on the way to disk. IT also means that the
buffer is torn down immediately, and so the first access to the AG
headers will re-read the header from disk and perform full
verification of the buffer. This way we also can catch corruptions
due to problems that went undetected in growfs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c       |   14 ++++++--
 fs/xfs/xfs_alloc_btree.c |   18 ++++++++--
 fs/xfs/xfs_fsops.c       |   86 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_ialloc.c      |   15 ++++++--
 4 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index ca3f2c0..8517e69 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2160,8 +2160,18 @@ xfs_agf_verify(
 		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_seqno) == bp->b_pag->pag_agno;
+		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
+
+	/*
+	 * during growfs operations, the perag is not fully initialised,
+	 * so we can't use it for any useful checking. growfs ensures we can't
+	 * use it by using uncached buffers that don't have the perag attached
+	 * so we can detect and avoid this problem.
+	 */
+	if (bp->b_pag) {
+		agf_ok = agf_ok &&
+			be32_to_cpu(agf->agf_seqno) == bp->b_pag->pag_agno;
+	}
 
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index b14ff21..b1ddef6 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -282,14 +282,26 @@ xfs_allocbt_verify(
 	unsigned int		level;
 	int			sblock_ok; /* block passes checks */
 
-	/* magic number and level verification */
+	/*
+	 * magic number and level verification
+	 *
+	 * During growfs operations, we can't verify the exact level as the
+	 * perag is not fully initialised and hence not attached to the buffer.
+	 * In this case, check against the maximum tree depth.
+	 */
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_MAGIC):
-		sblock_ok = level < pag->pagf_levels[XFS_BTNUM_BNOi];
+		if (pag)
+			sblock_ok = level < pag->pagf_levels[XFS_BTNUM_BNOi];
+		else
+			sblock_ok = level < mp->m_ag_maxlevels;
 		break;
 	case cpu_to_be32(XFS_ABTC_MAGIC):
-		sblock_ok = level < pag->pagf_levels[XFS_BTNUM_CNTi];
+		if (pag)
+			sblock_ok = level < pag->pagf_levels[XFS_BTNUM_CNTi];
+		else
+			sblock_ok = level < mp->m_ag_maxlevels;
 		break;
 	default:
 		sblock_ok = 0;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 03a8036..717b803 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -112,6 +112,28 @@ xfs_fs_geometry(
 	return 0;
 }
 
+static struct xfs_buf *
+xfs_growfs_get_hdr_buf(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	int			flags,
+	const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf		*bp;
+
+	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, flags);
+	if (!bp)
+		return NULL;
+
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+	bp->b_bn = blkno;
+	bp->b_maps[0].bm_bn = blkno;
+	bp->b_ops = ops;
+
+	return bp;
+}
+
 static int
 xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
@@ -192,16 +214,15 @@ xfs_growfs_data_private(
 		/*
 		 * AG freelist header block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
-		bp->b_ops = &xfs_agf_buf_ops;
+
 		agf = XFS_BUF_TO_AGF(bp);
-		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 		agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 		agf->agf_seqno = cpu_to_be32(agno);
@@ -230,16 +251,15 @@ xfs_growfs_data_private(
 		/*
 		 * AG inode header block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
-		bp->b_ops = &xfs_agi_buf_ops;
+
 		agi = XFS_BUF_TO_AGI(bp);
-		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
 		agi->agi_seqno = cpu_to_be32(agno);
@@ -259,51 +279,40 @@ xfs_growfs_data_private(
 
 		/*
 		 * BNO btree root block
-		 *
-		 * XXX: we attach the buf ops after writing the buffer becaus
-		 * the perag is not yet initialised fully and hence the buffer
-		 * will fail write verification. Attach it after writing. This
-		 * needs fixing before CRC protection will work.
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_allocbt_buf_ops);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
-		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-		xfs_btree_init_block(mp, bp, XFS_ABTB_MAGIC, 0, 1, 0);
 
+		xfs_btree_init_block(mp, bp, XFS_ABTB_MAGIC, 0, 1, 0);
 		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 
 		error = xfs_bwrite(bp);
-		bp->b_ops = &xfs_allocbt_buf_ops;
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
 
 		/*
 		 * CNT btree root block
-		 *
-		 * XXX: we attach the buf ops after writing the buffer becaus
-		 * the perag is not yet initialised fully and hence the buffer
-		 * will fail write verification. Attach it after writing. This
-		 * needs fixing before CRC protection will work.
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_allocbt_buf_ops);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
-		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-		xfs_btree_init_block(mp, bp, XFS_ABTC_MAGIC, 0, 1, 0);
 
+		xfs_btree_init_block(mp, bp, XFS_ABTC_MAGIC, 0, 1, 0);
 		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
@@ -311,31 +320,24 @@ xfs_growfs_data_private(
 		nfree += be32_to_cpu(arec->ar_blockcount);
 
 		error = xfs_bwrite(bp);
-		bp->b_ops = &xfs_allocbt_buf_ops;
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
 
 		/*
 		 * INO btree root block
-		 *
-		 * XXX: we attach the buf ops after writing the buffer becaus
-		 * the perag is not yet initialised fully and hence the buffer
-		 * will fail write verification. Attach it after writing. This
-		 * needs fixing before CRC protection will work.
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_inobt_buf_ops);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
-		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 		xfs_btree_init_block(mp, bp, XFS_IBT_MAGIC, 0, 0, 0);
 
 		error = xfs_bwrite(bp);
-		bp->b_ops = &xfs_inobt_buf_ops;
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 6925b7a..c9f02e5 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1485,8 +1485,19 @@ xfs_agi_verify(
 	 * Validate the magic number of the agi block.
 	 */
 	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
-		be32_to_cpu(agi->agi_seqno) == bp->b_pag->pag_agno;
+		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+
+	/*
+	 * during growfs operations, the perag is not fully initialised,
+	 * so we can't use it for any useful checking. growfs ensures we can't
+	 * use it by using uncached buffers that don't have the perag attached
+	 * so we can detect and avoid this problem.
+	 */
+	if (bp->b_pag) {
+		agi_ok = agi_ok &&
+			be32_to_cpu(agi->agi_seqno) == bp->b_pag->pag_agno;
+	}
+
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
 			XFS_RANDOM_IALLOC_READ_AGI))) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agi);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
