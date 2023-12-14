Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ifVmUpYx"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243E2A0
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:38 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9x0b3009307
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=7Q7obAmblXDFCBWG9ld4J/Oeo9gUKUvHENl0+9SIbqo=;
 b=ifVmUpYxyk1rvfnHAZTMtMj1VZF02up1+GPpvV9cVYxi0MX1xxblVy9hrGnd7Y+KAC92
 K+6WbQpjalqgV+4eV8y0SnSCDiXpbnNpOaDkUxfHuXkw9N21S2Pvw5CGFRU7bDtqxRC0
 gOFmZLnjrrBue05fct4xQFAikbt/ZFZzklnbiAMfEtkBgsPJbHWCbXFqZb6hVc3Ptd8/
 RvNkDCdxlfhFDsgV6/s4oxb1Bai4CU4cvGfjDB91CMQCcGMH9Z+7bt8esY0IUHl589+K
 ciD6ohuUAEWo2YNo2zL4Gy+qwuC9QIHFg0PWQkJKB56BnFjI3k1C7EXJu05S8iyizoXQ EQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3sh51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEFokjI012849
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnr036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-8;
	Thu, 14 Dec 2023 17:05:35 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 7/9] xfs: defrag: guarantee contigurous blocks in cow fork
Date: Thu, 14 Dec 2023 09:05:28 -0800
Message-Id: <20231214170530.8664-8-wen.gang.wang@oracle.com>
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
X-Proofpoint-ORIG-GUID: 2t_bCqNIL0rgUitGVWPs4z0_JF5tnonf
X-Proofpoint-GUID: 2t_bCqNIL0rgUitGVWPs4z0_JF5tnonf

Make sure there are contigurous blocks in cow fork covers the piece.

1. if the piece is covered, we are done
2. if the piece is partially overlap with existing extents in cow fork,
   reclaim the overlap parts.
3. allocate exact piece size contigurous blocks skipping cow hint, fail out
   if the allocation failed.
4. new blocks are stored in cow fork

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 157 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c  |   4 ++
 2 files changed, 161 insertions(+)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index 3b90ba07c73a..3c86dd1f5cd4 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -379,6 +379,154 @@ static bool xfs_pick_next_piece(struct xfs_defrag_info *di)
 	return !!dp->dp_len;
 }
 
+/*
+ * check if the extent _imap_ covers the range specified by 'off_start'
+ * and 'length'.
+ * returns the following codes
+ */
+#define XFS_DEFRAG_IMAP_NOOVERLAP		0	/* no overlap */
+#define	XFS_DEFRAG_IMAP_COVER			1	/* fully cover */
+#define XFS_DEFRAG_IMAP_PARTIAL_COVER		2	/* partially cover */
+static int xfs_extent_cover_range(struct xfs_bmbt_irec *imap,
+			   xfs_fileoff_t off_start,
+			   xfs_fileoff_t length)
+{
+	if (off_start >= imap->br_startoff + imap->br_blockcount)
+		return XFS_DEFRAG_IMAP_NOOVERLAP;
+
+	if (off_start + length <= imap->br_startoff)
+		return XFS_DEFRAG_IMAP_NOOVERLAP;
+
+	if (imap->br_startoff <= off_start &&
+		imap->br_blockcount + imap->br_startoff - off_start >= length)
+		return XFS_DEFRAG_IMAP_COVER;
+
+	return XFS_DEFRAG_IMAP_PARTIAL_COVER;
+}
+
+/*
+ * make sure there is contiguous blocks to cover the given piece in cowfp.
+ * if there is already such an extent covering the piece, we are done.
+ * otherwise, we reclaim the non-contigurous blocks if there are, and allocate
+ * new contigurous blocks.
+ * parameters:
+ * dp	--> [input] the piece
+ * icur	--> [output] cow tree context
+ * imap	--> [outout] the extent that covers the piece.
+ */
+static int xfs_guarantee_cow_extent(struct xfs_defrag_info *di,
+			      struct xfs_iext_cursor *icur,
+			      struct xfs_bmbt_irec *imap)
+{
+#define XFS_DEFRAG_NO_ALLOC		0 /* Cow extent covers, no alloc */
+#define XFS_DEFRAG_ALLOC_NO_CANCEL	1 /* No Cow extents to cancel, alloc */
+#define XFS_DEFRAG_ALLOC_CANCEL		2 /* Cow extents to cancel, alloc */
+	struct xfs_inode	*ip = di->di_ip;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_defrag_piece *dp = &di->di_dp;
+	int			need_alloc;
+	int			nmap = 1;
+	unsigned int		resblks;
+	int			error;
+	struct xfs_trans	*tp;
+
+	xfs_ifork_init_cow(ip);
+	if (!xfs_inode_has_cow_data(ip)) {
+		need_alloc = XFS_DEFRAG_ALLOC_NO_CANCEL;
+	} else if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, dp->dp_start_off,
+					icur, imap)) {
+		need_alloc = XFS_DEFRAG_ALLOC_NO_CANCEL;
+	} else {
+		int ret = xfs_extent_cover_range(imap, dp->dp_start_off, dp->dp_len);
+
+		if (ret == XFS_DEFRAG_IMAP_COVER)
+			need_alloc = XFS_DEFRAG_NO_ALLOC;
+		else if (ret == XFS_DEFRAG_IMAP_PARTIAL_COVER)
+			need_alloc = XFS_DEFRAG_ALLOC_CANCEL;
+		else // XFS_DEFRAG_IMAP_NOOVERLAP
+			need_alloc = XFS_DEFRAG_ALLOC_NO_CANCEL;
+	}
+
+	/* this piece is fully covered by exsting Cow extent, we are done */
+	if (need_alloc == XFS_DEFRAG_NO_ALLOC)
+		goto out;
+
+	/*
+	 * this piece is partially covered by existing Cow extent, reclaim the
+	 * overlapping blocks
+	 */
+	if (need_alloc == XFS_DEFRAG_ALLOC_CANCEL) {
+		/*
+		 * reclaim overlap (but not covers) extents in a separated
+		 * transaction
+		 */
+		error = xfs_reflink_cancel_cow_range(ip,
+				XFS_FSB_TO_B(mp, dp->dp_start_off),
+				XFS_FSB_TO_B(mp, dp->dp_len), true);
+		if (error)
+			return error;
+	}
+
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + dp->dp_len;
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+					resblks, 0, false, &tp);
+	if (error)
+		goto out;
+
+	/* now we have ILOCK_EXCL locked */
+	error = xfs_bmapi_write(tp, ip, dp->dp_start_off, dp->dp_len,
+			XFS_BMAPI_COWFORK | XFS_BMAPI_CONTIG, 0, imap, &nmap);
+	if (error)
+		goto cancel_out;
+
+	if (nmap == 0) {
+		error = -ENOSPC;
+		goto cancel_out;
+	}
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto unlock_out;
+
+	xfs_iext_lookup_extent(ip, ip->i_cowfp, dp->dp_start_off, icur, imap);
+
+	/* new extent can be merged into existing extent(s) though it's rare */
+	ASSERT(imap->br_blockcount >= dp->dp_len);
+	goto unlock_out;
+
+cancel_out:
+	xfs_trans_cancel(tp);
+unlock_out:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	return error;
+}
+
+/* defrag on the given piece
+ * XFS_ILOCK_EXCL is held by caller
+ */
+static int xfs_defrag_file_piece(struct xfs_defrag_info *di)
+{
+	struct xfs_inode	*ip = di->di_ip;
+	struct xfs_bmbt_irec	imap;
+	int			error;
+	struct xfs_iext_cursor	icur;
+
+	if (xfs_is_shutdown(ip->i_mount)) {
+		error = -EIO;
+		goto out;
+	}
+
+	/* allocate contig new blocks to Cow fork */
+	error = xfs_guarantee_cow_extent(di, &icur, &imap);
+	if (error)
+		goto out;
+
+	ASSERT(imap.br_blockcount >= di->di_dp.dp_len);
+out:
+	return error;
+}
+
 /*
  * defrag a piece of a file
  * error code is stored in di->di_defrag.df_status.
@@ -428,6 +576,14 @@ static bool xfs_defrag_file(struct xfs_defrag_info *di)
 		ret = true;
 		goto clear_out;
 	}
+
+	if (di->di_dp.dp_nr_ext > 1) {
+		/* defrag the piece */
+		error = xfs_defrag_file_piece(di);
+		if (error)
+			xfs_set_defrag_error(df, error);
+	}
+
 	df->df_blocks_done = di->di_next_blk;
 clear_out:
 	xfs_iflags_clear(ip, XFS_IDEFRAG);
@@ -536,6 +692,7 @@ static int xfs_defrag_process(void *data)
 
 	}
 
+	/* unmount in progress, clean up the defrags */
 	clean_up_defrags(mp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c0f1c89786c2..e0e319847f7d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -82,6 +82,10 @@ xfs_get_cowextsz_hint(
 {
 	xfs_extlen_t		a, b;
 
+	/* defrag need exact required size and skip the hint */
+	if (xfs_iflags_test(ip, XFS_IDEFRAG))
+		return 0;
+
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-- 
2.39.3 (Apple Git-145)

