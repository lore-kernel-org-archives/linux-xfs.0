Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6iq4J067529 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:44:52 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dH2DIXdDRB35155j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:46:57 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6kugB004333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:57 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6ktlE006709
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:56 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6ktCI010951 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:46:55 -0600
Message-ID: <50A5E15A.90905@oracle.com>
Date: Fri, 16 Nov 2012 14:46:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 13/15] xfs: Introduce a helper to truncate an AG
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

During FS shrinking, if an affected AG is not empty, we need to truncate it accordingly.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_fsops.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 24de23f..04a21d1 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -855,6 +855,100 @@ error0:
 }
 
 /*
+ * Truncate the given AG and update the metadatas accordingly.
+ */
+static int
+xfs_truncate_ag(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno,
+	xfs_rfsblock_t		tsize,
+	xfs_extlen_t		*nfree)
+{
+	xfs_agf_t		*agf;
+	xfs_agi_t		*agi;
+	xfs_buf_t		*bp;
+	xfs_perag_t		*pag;
+	xfs_alloc_rec_t		*arec;
+	__uint32_t		bno_btree_blkno;
+	__uint32_t		cnt_btree_blkno;
+	struct xfs_btree_block	*block;
+	int			error;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = ENOMEM;
+		goto error0;
+	}
+	agf = XFS_BUF_TO_AGF(bp);
+	be32_add_cpu(&agf->agf_length, -tsize);
+	be32_add_cpu(&agf->agf_freeblks, -tsize);
+	agf->agf_longest = agf->agf_freeblks;
+	bno_btree_blkno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]);
+	cnt_btree_blkno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]);
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
+	be32_add_cpu(&agi->agi_length, -tsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, bno_btree_blkno),
+			 BTOBB(mp->m_sb.sb_blocksize), 0);
+	if (!bp) {
+		error = ENOMEM;
+		goto error0;
+	}
+	block = XFS_BUF_TO_BLOCK(bp);
+	arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
+	be32_add_cpu(&arec->ar_blockcount, -tsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, cnt_btree_blkno),
+			 BTOBB(mp->m_sb.sb_blocksize), 0);
+	if (!bp) {
+		error = ENOMEM;
+		goto error0;
+	}
+	block = XFS_BUF_TO_BLOCK(bp);
+	arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
+	be32_add_cpu(&arec->ar_blockcount, -tsize);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		goto error0;
+
+	pag = xfs_perag_get(mp, agno);
+	pag->pagf_freeblks -= tsize;
+	pag->pagf_longest = pag->pagf_freeblks;
+	xfs_perag_put(pag);
+
+	if (nfree)
+		*nfree = tsize;
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
