Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBqobt217620 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:52:50 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	45aNprg6e7O6cQsd for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:54:51 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsb8-00053Y-6B
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:38 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsb8-000126-2o
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/32] xfs: growfs: use uncached buffers for new headers
Date: Mon, 12 Nov 2012 22:53:59 +1100
Message-Id: <1352721264-3700-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_fsops.c |   63 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a5034af..2196830 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -114,6 +114,26 @@ xfs_fs_geometry(
 	return 0;
 }
 
+static struct xfs_buf *
+xfs_growfs_get_hdr_buf(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	int			flags)
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
+
+	return bp;
+}
+
 static int
 xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
@@ -189,15 +209,15 @@ xfs_growfs_data_private(
 		/*
 		 * AG freelist header block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
+
 		agf = XFS_BUF_TO_AGF(bp);
-		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 		agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 		agf->agf_seqno = cpu_to_be32(agno);
@@ -226,15 +246,15 @@ xfs_growfs_data_private(
 		/*
 		 * AG inode header block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
+
 		agi = XFS_BUF_TO_AGI(bp);
-		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
 		agi->agi_seqno = cpu_to_be32(agno);
@@ -255,16 +275,16 @@ xfs_growfs_data_private(
 		/*
 		 * BNO btree root block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0);
+
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
@@ -278,16 +298,15 @@ xfs_growfs_data_private(
 		/*
 		 * CNT btree root block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0);
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
@@ -302,14 +321,14 @@ xfs_growfs_data_private(
 		/*
 		 * INO btree root block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
 		}
-		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+
 		xfs_btree_init_block(mp, bp, XFS_IBT_MAGIC, 0, 0, 0);
 
 		error = xfs_bwrite(bp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
