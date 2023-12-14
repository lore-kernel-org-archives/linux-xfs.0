Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cGsgkcyy"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366F811B
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:38 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9x6Ti018702
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=6eFXehK3AiU80VK2aem/OTQ8evVHuw4+zACwCb+wrJg=;
 b=cGsgkcyyWyPV4Lz02wcd20y+SZxc6llWhGKtfOOn4yzh7KYqJdpuLyAzq7jnXgdMUMw2
 NFUrkk7n6E2Hr5QvfIt1htbYmz/tR0SnTNlJNQHPH/T5UGYmfSgvX3yeDqEQ9oclqUxh
 XOiNK64H30or8ptg07oZOlpqV/AKg5XwpF4Jcj5id1tNXdOZeYulFAGg6vdmvEwCqqu/
 O0vOmMRgccPGRWecRvhEmArLQqaT75kvyyoSEgUfg6/emvsVH6eRZLooNZv8pIyg3klF
 HO2k3NheMsb3bJdgNXI786/jIvbm6EkuXrqtpzgwEZdWOmQnYNvovpxLq3+fYX6R05B9 5g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvfuubavb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGheWW012874
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnt036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-9;
	Thu, 14 Dec 2023 17:05:35 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 8/9] xfs: defrag: copy data from old blocks to new blocks
Date: Thu, 14 Dec 2023 09:05:29 -0800
Message-Id: <20231214170530.8664-9-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20231214170530.8664-1-wen.gang.wang@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_11,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312140121
X-Proofpoint-GUID: I9zKDl9QkAw_Tje_k4NK9xSALrVy-ju1
X-Proofpoint-ORIG-GUID: I9zKDl9QkAw_Tje_k4NK9xSALrVy-ju1

copy data from old blocks to new blocks synchronously

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 56 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index 3c86dd1f5cd4..0375b542024e 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -502,6 +502,57 @@ static int xfs_guarantee_cow_extent(struct xfs_defrag_info *di,
 	return error;
 }
 
+static int xfs_do_copy_extent_sync(struct xfs_mount *mp, xfs_fsblock_t src_blk,
+				   xfs_fsblock_t tgt_blk, xfs_filblks_t count)
+{
+	struct xfs_buf  *bp = NULL;
+	xfs_daddr_t	src_daddr, tgt_daddr;
+	size_t		nblocks;
+	int		error;
+
+	src_daddr = XFS_FSB_TO_DADDR(mp, src_blk);
+	tgt_daddr = XFS_FSB_TO_DADDR(mp, tgt_blk);
+	nblocks = XFS_FSB_TO_BB(mp, count);
+
+	error = xfs_buf_read_uncached(mp->m_ddev_targp, src_daddr, nblocks, 0, &bp, NULL);
+	if (error)
+		goto rel_bp;
+
+	/* write to new blocks */
+	bp->b_maps[0].bm_bn = tgt_daddr;
+	error = xfs_bwrite(bp);
+rel_bp:
+	if (bp)
+		xfs_buf_relse(bp);
+	return error;
+}
+
+/* Physically copy data from old extents to new extents synchronously
+ * Note: @new extent is expected either exact same as piece size or it's bigger
+ * than that.
+ */
+static int xfs_defrag_copy_piece_sync(struct xfs_defrag_info *di,
+				      struct xfs_bmbt_irec *new)
+{
+	struct xfs_defrag_piece	*dp = &di->di_dp;
+	xfs_fsblock_t		new_strt_blk;
+	int			error = 0;
+	int			i;
+
+	new_strt_blk = new->br_startblock + dp->dp_start_off - new->br_startoff;
+	for (i = 0; i < dp->dp_nr_ext; i++) {
+		struct xfs_bmbt_irec *irec = &dp->dp_extents[i];
+
+		error = xfs_do_copy_extent_sync(di->di_ip->i_mount,
+			irec->br_startblock, new_strt_blk,
+			irec->br_blockcount);
+		if (error)
+			break;
+		new_strt_blk += irec->br_blockcount;
+	}
+	return error;
+}
+
 /* defrag on the given piece
  * XFS_ILOCK_EXCL is held by caller
  */
@@ -523,6 +574,11 @@ static int xfs_defrag_file_piece(struct xfs_defrag_info *di)
 		goto out;
 
 	ASSERT(imap.br_blockcount >= di->di_dp.dp_len);
+
+	/* copy data to new blocks */
+	error = xfs_defrag_copy_piece_sync(di, &imap);
+	if (error)
+		goto out;
 out:
 	return error;
 }
-- 
2.39.3 (Apple Git-145)

