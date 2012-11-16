Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6ijJc067503 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:44:45 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id etCKOkAWTYMfeUF2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:46:50 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6kncb020824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:49 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6km1x024429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:49 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6kmoP005707 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:46:48 -0600
Message-ID: <50A5E153.2030008@oracle.com>
Date: Fri, 16 Nov 2012 14:46:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 12/15] xfs: Introduce a helper to remove an empty
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If a given AG is empty, we can totally wipe it out of the disk via this
helper by cleaning up the AG metadata blocks.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_fsops.c |  149 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6623d9a..24de23f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -706,6 +706,155 @@ error0:
 }
 
 /*
+ * This function is used to remove an empty AG out of the disk
+ * by cleaning up it's metadata info and free the related perag
+ * object.
+ */
+static int
+xfs_remove_empty_ag(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*nfree)
+{
+	xfs_agf_t		*agf;
+	xfs_agi_t		*agi;
+	xfs_buf_t		*bp;
+	xfs_dsb_t		*sbp;
+	xfs_agfl_t		*agfl;
+	xfs_perag_t		*pag;
+	__uint32_t		agfl_bno;
+	__uint32_t		bno_btree_blkno;
+	__uint32_t		cnt_btree_blkno;
+	__uint32_t		ino_btree_blkno;
+	struct xfs_btree_block	*block;
+	int			error;
+
+	/* Wipe out superblock in sector size */
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+			  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+			  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+	if (error)
+		goto error0;
+	sbp = XFS_BUF_TO_SBP(bp);
+	memset(sbp, 0, mp->m_sb.sb_sectsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = ENOMEM;
+		goto error0;
+	}
+	agf = XFS_BUF_TO_AGF(bp);
+	if (nfree) {
+		/*
+		 * Don't use the mp->m_sb.sb_agcount since the end
+		 * AG might has different size to others.
+		 */
+		*nfree = be32_to_cpu(agf->agf_length);
+	}
+	bno_btree_blkno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]);
+	cnt_btree_blkno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]);
+	memset(agf, 0, mp->m_sb.sb_sectsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = ENOMEM;
+		goto error0;
+	}
+	agi = XFS_BUF_TO_AGI(bp);
+	ino_btree_blkno = be32_to_cpu(agi->agi_root);
+	memset(agi, 0, mp->m_sb.sb_sectsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, XFS_AGFL_BLOCK(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto error0;
+	}
+	agfl = XFS_BUF_TO_AGFL(bp);
+	agfl_bno = be32_to_cpu(agfl->agfl_bno[0]);
+	memset(agfl, 0, mp->m_sb.sb_sectsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	/* BNO btree root block */
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, bno_btree_blkno),
+			 BTOBB(mp->m_sb.sb_blocksize), 0);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto error0;
+	}
+	block = XFS_BUF_TO_BLOCK(bp);
+	memset(block, 0, mp->m_sb.sb_blocksize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	/* CNT btree root block */
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, cnt_btree_blkno),
+			 BTOBB(mp->m_sb.sb_blocksize), 0);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto error0;
+	}
+	block = XFS_BUF_TO_BLOCK(bp);
+	memset(block, 0, mp->m_sb.sb_blocksize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	/* INO btree root block */
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, ino_btree_blkno),
+			 BTOBB(mp->m_sb.sb_blocksize), 0);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto error0;
+	}
+	block = XFS_BUF_TO_BLOCK(bp);
+	memset(block, 0, mp->m_sb.sb_blocksize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	/* Free perag object from the radix tree */
+	spin_lock(&mp->m_perag_lock);
+	pag = radix_tree_delete(&mp->m_perag_tree, agno);
+	spin_unlock(&mp->m_perag_lock);
+	ASSERT(pag);
+	ASSERT(atomic_read(&pag->pag_ref) == 0);
+	kmem_free(pag);
+
+	*nfree += xfs_ag_metadata_blocks(mp, agno);
+
+error0:
+	return error;
+}
+
+/*
  * exported through ioctl XFS_IOC_FSCOUNTS
  */
 
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
