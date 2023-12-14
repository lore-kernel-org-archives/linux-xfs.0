Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="datMsnMF"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562F511A
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:37 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEH1TZS009178
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=4sPQx9ngIN1CIYnj7z2Z1AGQHbvsBMDYRbjTwh0U9vw=;
 b=datMsnMFuMBQz/PdeYXMNXmCEt197m7hUWr2WhsgyiprHkgtTY8U2gZFZ8Av0QORuvKx
 rFCK+M0AtCzJbqhagSRCyJ55rm8e60hqdsn1+XYth7A+8FJMjx3/fcuNyUQwD6wAB1H7
 0VqDzYuHr6ftTwG9Zu5cygJ50aeTPC4VqIuWjQopPxP1WlqUqiBbWFcJ9QeCUHrJgU48
 5ldALKTquJF30UQ7WVyTLo+mjNjfLHvCSuTAsDBYXU3qmrFmBJVkhMiZHGgJ1J2M8IuC
 iA+lIB02WFKDmtxHLlVX+28jLGk31FfNgFDY7gNQfZOz8SaFSn4BLw/dUqS8o/MnWsWh Fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3sh50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGhVK0012828
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnp036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-7;
	Thu, 14 Dec 2023 17:05:34 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 6/9] xfs: defrag: piece picking up
Date: Thu, 14 Dec 2023 09:05:27 -0800
Message-Id: <20231214170530.8664-7-wen.gang.wang@oracle.com>
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
X-Proofpoint-ORIG-GUID: lV4brouCHm87ctQ8-KpS2pIKVC42yf_7
X-Proofpoint-GUID: lV4brouCHm87ctQ8-KpS2pIKVC42yf_7

A extent in a piece must:
1. be real extent
2. not 'unwritten' extent
3. size no bigger than target extent size

Extents in a piece must be contigurous by file block, there can't
be holes in pieces.
There can be up to XFS_DEFRAG_PIECE_MAX_EXT (512) extents in a piece.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 187 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h  |   1 +
 include/linux/fs.h  |   5 ++
 3 files changed, 190 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index aee4cfd3f86e..3b90ba07c73a 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -252,10 +252,191 @@ static inline bool xfs_defrag_failed(struct xfs_defrag_info *di)
 	return di->di_defrag.df_status != 0;
 }
 
-/* so far do nothing */
+static inline void xfs_set_defrag_error(struct xfs_defrag *df, int error)
+{
+	if (df->df_status == 0)
+		df->df_status = error;
+}
+
+static void xfs_piece_reset(struct xfs_defrag_piece *dp)
+{
+	dp->dp_start_off = 0;
+	dp->dp_len = 0;
+	dp->dp_nr_ext = 0;
+}
+
+/*
+ * check if the given extent should be skipped from defragmenting
+ * The following extents are skipped
+ *	1. non "real"
+ *	2. unwritten
+ *	3. size bigger than target
+ * returns:
+ * true		-- skip this extent
+ * false	-- don't skip
+ */
+static bool xfs_extent_skip_defrag(struct xfs_bmbt_irec *check,
+			    struct xfs_defrag *defrag)
+{
+	if (!xfs_bmap_is_real_extent(check))
+		return true;
+	if (check->br_state == XFS_EXT_UNWRITTEN)
+		return true;
+	if (check->br_blockcount > defrag->df_tgt_extsize)
+		return true;
+	return false;
+}
+
+/*
+ * add extent to piece
+ * the extent is expected to be behind all the existing extents.
+ * returns:
+ *	true	-- the piece is full with extents
+ *	false	-- not full yet
+ */
+static bool xfs_add_extent_to_piece(struct xfs_defrag_piece *dp,
+			     struct xfs_bmbt_irec *add,
+			     struct xfs_defrag *defrag,
+			     int pos_in_piece)
+{
+	ASSERT(dp->dp_nr_ext < XFS_DEFRAG_PIECE_MAX_EXT);
+	ASSERT(pos_in_piece < XFS_DEFRAG_PIECE_MAX_EXT);
+	dp->dp_extents[pos_in_piece] = *add;
+	dp->dp_len += add->br_blockcount;
+
+	/* set up starting file offset */
+	if (dp->dp_nr_ext == 0)
+		dp->dp_start_off = add->br_startoff;
+	dp->dp_nr_ext++;
+	if (dp->dp_nr_ext == XFS_DEFRAG_PIECE_MAX_EXT)
+		return true;
+	if (dp->dp_len >= defrag->df_piece_size)
+		return true;
+	return false;
+}
+
+/*
+ * check if the given extent is contiguous, by file block number,  with the
+ * previous one in the piece
+ */
+static bool xfs_is_contig_ext(struct xfs_bmbt_irec *check,
+			      struct xfs_defrag_piece *dp)
+{
+	/* it's contig if the piece is empty */
+	if (dp->dp_len == 0)
+		return true;
+	return dp->dp_start_off + dp->dp_len == check->br_startoff;
+}
+
+/*
+ * pick next piece to defragment starting from the @di->di_next_blk
+ * takes and drops XFS_ILOCK_SHARED lock
+ * returns:
+ *	true:	piece is selected.
+ *	false:	no more pieces in this file.
+ */
+static bool xfs_pick_next_piece(struct xfs_defrag_info *di)
+{
+	struct xfs_defrag	*defrag = &di->di_defrag;
+	int			pos_in_piece = 0;
+	struct xfs_defrag_piece	*dp = &di->di_dp;
+	struct xfs_inode	*ip = di->di_ip;
+	bool			found;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+
+	xfs_piece_reset(dp);
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	found = xfs_iext_lookup_extent(ip, &ip->i_df, di->di_next_blk, &icur, &got);
+
+	/* fill the piece until it get full or the it reaches block limit */
+	while (found) {
+		if (xfs_extent_skip_defrag(&got, defrag)) {
+			if (dp->dp_len) {
+				/* this piece already has some extents, return */
+				break;
+			}
+			goto next_ext;
+		}
+
+		if (!xfs_is_contig_ext(&got, dp)) {
+			/* this extent is not contigurous with previous one, finish this piece */
+			break;
+		}
+
+		if (xfs_add_extent_to_piece(dp, &got, defrag, pos_in_piece++)) {
+			/* this piece is full */
+			break;
+		}
+
+next_ext:
+		found = xfs_iext_next_extent(&ip->i_df, &icur, &got);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	/* set the starting file block for next piece */
+	di->di_next_blk = dp->dp_start_off + dp->dp_len;
+	return !!dp->dp_len;
+}
+
+/*
+ * defrag a piece of a file
+ * error code is stored in di->di_defrag.df_status.
+ * returns:
+ *	true	-- whole file defrag done successfully.
+ *	false	-- not all done or error happened.
+ */
+
 static bool xfs_defrag_file(struct xfs_defrag_info *di)
 {
-	return true;
+	struct xfs_defrag	*df = &(di->di_defrag);
+	struct xfs_inode	*ip = di->di_ip;
+	bool			ret = false;
+	int			error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error) {
+		xfs_set_defrag_error(df, error);
+		goto out;
+	}
+
+	/* prevent further read/write/map/unmap/reflink/GC requests to this file */
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
+		goto out;
+
+	if (!filemap_invalidate_trylock(VFS_I(ip)->i_mapping)) {
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		goto out;
+	}
+
+	inode_dio_wait(VFS_I(ip));
+	/*
+	 * flush the whole file to get stable data/cow extents
+	 */
+	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
+	if (error) {
+		xfs_set_defrag_error(df, error);
+		goto unlock_out;
+	}
+
+	xfs_iflags_set(ip, XFS_IDEFRAG); //set after dirty pages get flushed
+	/* pick up next piece */
+	if (!xfs_pick_next_piece(di)) {
+		/* no more pieces to defrag, we are done */
+		ret = true;
+		goto clear_out;
+	}
+	df->df_blocks_done = di->di_next_blk;
+clear_out:
+	xfs_iflags_clear(ip, XFS_IDEFRAG);
+unlock_out:
+	filemap_invalidate_unlock(VFS_I(ip)->i_mapping);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+out:
+	di->di_last_process = jiffies;
+	return ret;
 }
 
 static inline bool xfs_defrag_suspended(struct xfs_defrag_info *di)
@@ -266,7 +447,7 @@ static inline bool xfs_defrag_suspended(struct xfs_defrag_info *di)
 /* run as a separated process.
  * defragment files in mp->m_defrag_list
  */
-int xfs_defrag_process(void *data)
+static int xfs_defrag_process(void *data)
 {
 	unsigned long		smallest_wait = ULONG_MAX;
 	struct xfs_mount	*mp = data;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3beb470f1892..4f4e27cb9bbe 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -346,6 +346,7 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
+#define XFS_IDEFRAG             (1 << 15) /* defrag in progress */
 
 /*
  * Remap in progress. Callers that wish to update file data while
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 98b7a7a8c42e..87497c4ca552 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -847,6 +847,11 @@ static inline void filemap_invalidate_lock(struct address_space *mapping)
 	down_write(&mapping->invalidate_lock);
 }
 
+static inline int filemap_invalidate_trylock(struct address_space *mapping)
+{
+	return down_write_trylock(&mapping->invalidate_lock);
+}
+
 static inline void filemap_invalidate_unlock(struct address_space *mapping)
 {
 	up_write(&mapping->invalidate_lock);
-- 
2.39.3 (Apple Git-145)

