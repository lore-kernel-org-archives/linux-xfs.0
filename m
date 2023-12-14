Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DyS3A2yS"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4B2A7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:38 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEH1TZT009178
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=lIdR4U0naPkbuVC5cb0SLe2e9nCwtGXK5HjeZSzMY0A=;
 b=DyS3A2ySY8wa338SomVJI0rZgsG3exHY2YR2vgKGOU3KM/h7UFKacEej3h12c3rXbvVe
 8NGlCtu++LI9+2HXghyjiDZVO/yfkL3zEyNkZ9OzqaeuLwGYjg2kByo6fmlnnKJ212MN
 nR8kTUTVu4LkDhS/+utTTFG4zsI+WhXPUb4ZScJW/+Nzji8sN4KNYqwPN7EWyAo1oJwO
 Gye8GYHvrjiloHeIc83eUDQWH4jWmPjckEIfJ4SX/HVjpm4n2fAT00SZco3WX4qxnslU
 xzjux9FLxxdeOy6/Fsi2g3QsdYMopybhUtS1F5l3KQcMaYL2DnCEskrZLOtZNsJNlBgt 5w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3sh53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGvV5D012781
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnv036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-10;
	Thu, 14 Dec 2023 17:05:36 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 9/9] xfs: defrag: map new blocks
Date: Thu, 14 Dec 2023 09:05:30 -0800
Message-Id: <20231214170530.8664-10-wen.gang.wang@oracle.com>
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
X-Proofpoint-ORIG-GUID: fon9KLM77MpDlenxv3mVTFT24LsRce23
X-Proofpoint-GUID: fon9KLM77MpDlenxv3mVTFT24LsRce23

Unmap original extents.
Drop refcounter for shared blocks; free not shared ones.
Fre Cow orphon record.
map new blocks to data fork and remove them from cow fork.
copy data from old blocks to new blocks synchronously

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   2 +-
 fs/xfs/xfs_defrag.c    | 140 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iomap.c     |   2 +-
 fs/xfs/xfs_reflink.c   |   7 ++-
 fs/xfs/xfs_reflink.h   |   3 +-
 5 files changed, 147 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 731260a5af6d..09053c0abe28 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -301,7 +301,7 @@ xfs_getbmap_report_one(
 	bool			shared = false;
 	int			error;
 
-	error = xfs_reflink_trim_around_shared(ip, got, &shared);
+	error = xfs_reflink_trim_around_shared(ip, got, &shared, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index 0375b542024e..6867f81783a0 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -553,13 +553,102 @@ static int xfs_defrag_copy_piece_sync(struct xfs_defrag_info *di,
 	return error;
 }
 
+/* caller makes sure both irec1 and irec2 are real ones. */
+static int compare_bmbt_by_fsb(const void *a, const void *b)
+{
+	const struct xfs_bmbt_irec *irec1 = a, *irec2 = b;
+
+	return irec1->br_startblock > irec2->br_startblock ? 1 : -1;
+}
+
+/* sort the extents in dp_extents to be in fsb order, low to high */
+static void xfs_sort_piece_exts_by_fsb(struct xfs_defrag_piece *dp)
+{
+	sort(dp->dp_extents, dp->dp_nr_ext, sizeof(struct xfs_bmbt_irec),
+	     compare_bmbt_by_fsb, NULL);
+}
+
+/*
+ * unmap the given extent from inode
+ * free non-shared blocks and decrease shared counter for shared ones.
+ */
+static int xfs_defrag_unmap_ext(struct xfs_inode *ip,
+				struct xfs_bmbt_irec *irec,
+				struct xfs_trans *tp)
+{
+	struct xfs_bmbt_irec unmap = *irec; /* don't update original extent */
+	xfs_fsblock_t irec_end = irec->br_startblock + irec->br_blockcount;
+	int error = 0;
+
+	while (unmap.br_startblock < irec_end) {
+		bool shared;
+
+		error = xfs_reflink_trim_around_shared(ip, &unmap, &shared, tp);
+		if (error)
+			goto out;
+
+		/* unmap blocks from data fork */
+		xfs_bmap_unmap_extent(tp, ip, &unmap);
+		/*
+		 * decrease refcount counter for shared blocks, or free the
+		 * non-shared blocks
+		 */
+		if (shared) {
+			xfs_refcount_decrease_extent(tp, &unmap);
+		} else {
+			ASSERT(unmap.br_state != XFS_EXT_UNWRITTEN);
+			__xfs_free_extent_later(tp, unmap.br_startblock,
+					unmap.br_blockcount, NULL, 0, false);
+		}
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+			-unmap.br_blockcount);
+
+		/* for next */
+		unmap.br_startoff += unmap.br_blockcount;
+		unmap.br_startblock += unmap.br_blockcount;
+		unmap.br_blockcount = irec_end - unmap.br_startblock;
+	}
+out:
+	return error;
+}
+
+/*
+ * unmap original extents in this piece
+ * for those non-shared ones, also free them; for shared, decrease refcount
+ * counter.
+ * XFS_ILOCK_EXCL is locked by caller.
+ */
+static int xfs_defrag_unmap_piece(struct xfs_defrag_info *di, struct xfs_trans *tp)
+{
+	struct xfs_defrag_piece	*dp = &di->di_dp;
+	xfs_fsblock_t		last_fsb = 0;
+	int			i, error;
+
+	for (i = 0; i < dp->dp_nr_ext; i++) {
+		struct xfs_bmbt_irec *irec = &dp->dp_extents[i];
+
+		/* debug only, remove the following two lines for production use */
+		ASSERT(last_fsb == 0 || irec->br_startblock > last_fsb);
+		last_fsb = irec->br_startblock;
+
+		error = xfs_defrag_unmap_ext(di->di_ip, irec, tp);
+		if (error)
+			break;
+	}
+	return error;
+}
+
 /* defrag on the given piece
  * XFS_ILOCK_EXCL is held by caller
  */
 static int xfs_defrag_file_piece(struct xfs_defrag_info *di)
 {
 	struct xfs_inode	*ip = di->di_ip;
-	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct	xfs_trans	*tp = NULL;
+	struct xfs_bmbt_irec	imap, del;
+	unsigned int		resblks;
+
 	int			error;
 	struct xfs_iext_cursor	icur;
 
@@ -579,6 +668,55 @@ static int xfs_defrag_file_piece(struct xfs_defrag_info *di)
 	error = xfs_defrag_copy_piece_sync(di, &imap);
 	if (error)
 		goto out;
+
+	/* sort the extents by FSB, low -> high, for later unmapping*/
+	xfs_sort_piece_exts_by_fsb(&di->di_dp);
+
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+			XFS_TRANS_RESERVE, &tp);
+	if (error)
+		goto out;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/* unmap original extents in data fork */
+	error = xfs_defrag_unmap_piece(di, tp);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out;
+	}
+
+	/* adjust new blocks to proper range */
+	del = imap;
+	if (del.br_blockcount > di->di_dp.dp_len) {
+		xfs_filblks_t	diff = di->di_dp.dp_start_off - del.br_startoff;
+
+		del.br_startoff += diff;
+		del.br_startblock += diff;
+		del.br_blockcount = di->di_dp.dp_len;
+	}
+
+	/* Free the CoW orphan record. */
+	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
+
+	/* map the adjusted new blocks to data fork */
+	xfs_bmap_map_extent(tp, ip, &del);
+
+	/* Charge this new data fork mapping to the on-disk quota. */
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
+			(long)del.br_blockcount);
+
+	/* remove the extent from Cow fork */
+	xfs_bmap_del_extent_cow(ip, &icur, &imap, &del);
+
+	/* modify inode change time */
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
 out:
 	return error;
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b153..f6fdff3bdca4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1256,7 +1256,7 @@ xfs_read_iomap_begin(
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, 0);
 	if (!error && ((flags & IOMAP_REPORT) || IS_DAX(inode)))
-		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
+		error = xfs_reflink_trim_around_shared(ip, &imap, &shared, NULL);
 	seq = xfs_iomap_inode_sequence(ip, shared ? IOMAP_F_SHARED : 0);
 	xfs_iunlock(ip, lockmode);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc28466..7d7d67087fcc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -168,7 +168,8 @@ int
 xfs_reflink_trim_around_shared(
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*irec,
-	bool			*shared)
+	bool			*shared,
+	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
@@ -190,7 +191,7 @@ xfs_reflink_trim_around_shared(
 	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 	aglen = irec->br_blockcount;
 
-	error = xfs_reflink_find_shared(pag, NULL, agbno, aglen, &fbno, &flen,
+	error = xfs_reflink_find_shared(pag, tp, agbno, aglen, &fbno, &flen,
 			true);
 	xfs_perag_put(pag);
 	if (error)
@@ -238,7 +239,7 @@ xfs_bmap_trim_cow(
 	}
 
 	/* Trim the mapping to the nearest shared extent boundary. */
-	return xfs_reflink_trim_around_shared(ip, imap, shared);
+	return xfs_reflink_trim_around_shared(ip, imap, shared, NULL);
 }
 
 static int
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 65c5dfe17ecf..d751420650f2 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -17,7 +17,8 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
 }
 
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *irec, bool *shared);
+		struct xfs_bmbt_irec *irec, bool *shared,
+		struct xfs_trans *tp);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
 		bool *shared);
 
-- 
2.39.3 (Apple Git-145)

