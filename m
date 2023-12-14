Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZexZcHXL"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD660B9
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:35 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9wsU8021815
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=1ChRpIsxd7Sp6qiT5qd93JYQ0MGBdkLNqXynVube3IA=;
 b=ZexZcHXLzu3QHKJEKwd3B3VjYnA1YWRlnMnex2y2kwwciM69b2KiwOxiRTH+a/x7j9Ox
 NHPqPCnJTAFqEK35dUiZst6Zk6WdBslOu3pyvB9wn6BebAovYwVQN5DQYNDI7Qt16rPO
 W/KoF+c6j5Rhu8daDWoxkFNjjtxk4LFXw7xbYfshBqjhbjyFmrV6qj527SHsqA5WVlcO
 jyn9AB8KN4GGq5j/oW7sJ2pYHYs1UwNEcM03LvEmMYlOvk6D+p+815Y2E1Uaarl4Ta2l
 eMGkKJeOWKr8IE1UXAAas4y2/qetvz2wVjZTkxhNs3DpQCEpOA0x2MVLv0yne21mcnJW Fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrsqu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGaPPx012850
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnj036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-4;
	Thu, 14 Dec 2023 17:05:33 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 3/9] xfs: defrag implement stop/suspend/resume/status
Date: Thu, 14 Dec 2023 09:05:24 -0800
Message-Id: <20231214170530.8664-4-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: LKIJCdgIlOefO7KlfAh3AcQtoxsvp5Ba
X-Proofpoint-ORIG-GUID: LKIJCdgIlOefO7KlfAh3AcQtoxsvp5Ba

1. we support at most 128 running file defragmentation at a time.
2. the max piece size is 4096
3. the max piece size must no less than twice of target extent size
4. defrag jobs are stored in mp->m_defrag_list.
5. for 'status' command, set the inode number to -1UL for return
6. a separated process m_defrag_task processes all defragmentation jobs

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 200 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 199 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index 8bdc6290a69d..4a10528912ca 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -54,6 +54,47 @@
  */
 #define XFS_DEFRAG_MAX_PIECE_BLOCKS	4096U
 
+/*
+ * A piece is a contigurous (by file block number) range in a file. It contains one
+ * or more extents. When it contains two or more extents, it's subject to be
+ * defragmented.  During the defragmenting, the original extents are
+ * deallocated and replaced by a single new-allocated extent covering this
+ * whole piece.
+ */
+struct xfs_defrag_piece {
+	/* the start file block in this piece */
+	xfs_fileoff_t		dp_start_off;
+	/* number of blocks contained in this piece */
+	xfs_filblks_t		dp_len;
+	/*
+	 * the extents in this piece. they are contigourous by file block
+	 * number after the piece is picked. they are sorted by filesystem
+	 * lock number (low -> high) before unmapping.
+	 */
+	struct xfs_bmbt_irec	dp_extents[XFS_DEFRAG_PIECE_MAX_EXT];
+	/* number of xfs_bmbt_irecs in dp_extents */
+	int			dp_nr_ext;
+};
+
+struct xfs_defrag_info {
+	/* links to xfs_mount.m_defrag_list */
+	struct list_head	di_list;		/* links to xfs_mount.m_defrag_list */
+	/* defrag configuration and status */
+	struct xfs_defrag	di_defrag;
+	/* the xfs_inode to defragment on */
+	struct xfs_inode	*di_ip;
+	/* next file block to start with */
+	xfs_fileoff_t		di_next_blk;
+	/* number of pieces which are defragmented */
+	unsigned long		di_round_nr;
+	/* current piece to defragment */
+	struct xfs_defrag_piece	di_dp;
+	/* timestamp of last defragmenting in jiffies */
+	unsigned long		di_last_process;
+	/* flag indicating if defragmentation is stopped by user */
+	bool			di_user_stopped;
+};
+
 /* initialization called for new mount */
 void xfs_initialize_defrag(struct xfs_mount *mp)
 {
@@ -77,7 +118,164 @@ void xfs_stop_wait_defrags(struct xfs_mount *mp)
 	mp->m_defrag_task = NULL;
 }
 
-int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)
+
+static bool xfs_is_defrag_param_valid(struct xfs_defrag *defrag)
+{
+	if (defrag->df_piece_size > XFS_DEFRAG_MAX_PIECE_BLOCKS)
+		return false;
+	if (defrag->df_piece_size < 2 * defrag->df_tgt_extsize)
+		return false;
+	return true;
+}
+
+static inline bool __xfs_new_defrag_allowed(struct xfs_mount *mp)
+ {
+	if (mp->m_nr_defrag >= XFS_DEFRAG_MAX_PARALLEL)
+		return false;
+
+	return true;
+}
+
+/*
+ * lookup this mount for the xfs_defrag_info structure specified by @ino
+ * m_defrag_lock is held by caller.
+ * returns:
+ *	The pointer to that structure on found or NULL if not found.
+ */
+struct xfs_defrag_info *__xfs_find_defrag(unsigned long ino,
+					   struct xfs_mount *mp)
+{
+	struct xfs_defrag_info *di;
+
+	list_for_each_entry(di, &mp->m_defrag_list, di_list) {
+		if (di->di_defrag.df_ino == ino)
+			return di;
+	}
+	return NULL;
+}
+
+/* start a new defragmetation or change the parameters on the existing one */
+static int xfs_file_defrag_start(struct inode *inode, struct xfs_defrag *defrag)
 {
+	int			ret = 0;
+
+	if ((inode->i_mode & S_IFMT) != S_IFREG) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (IS_DAX(inode)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!xfs_is_defrag_param_valid(defrag)) {
+		ret = EINVAL;
+		goto out;
+	}
+
+out:
 	return -EOPNOTSUPP;
+ }
+
+static void xfs_file_defrag_status(struct inode *inode, struct xfs_defrag *defrag)
+{
+	struct xfs_mount        *mp = XFS_I(inode)->i_mount;
+	struct xfs_defrag_info  *di;
+
+	down(&mp->m_defrag_lock);
+	di = __xfs_find_defrag(inode->i_ino, mp);
+	if (di == NULL) {
+		up(&mp->m_defrag_lock);
+		defrag->df_ino = -1UL;
+		return;
+	}
+	di->di_defrag.df_cmd = defrag->df_cmd;
+	*defrag = di->di_defrag;
+	up(&mp->m_defrag_lock);
+}
+
+static int xfs_file_defrag_stop(struct inode *inode, struct xfs_defrag *defrag)
+{
+	struct xfs_mount        *mp = XFS_I(inode)->i_mount;
+	struct xfs_defrag_info  *di;
+
+	down(&mp->m_defrag_lock);
+	di = __xfs_find_defrag(inode->i_ino, mp);
+	if (di == NULL) {
+		up(&mp->m_defrag_lock);
+		defrag->df_ino = -1UL;
+		return -EINVAL;
+	}
+
+	di->di_user_stopped = true;
+	di->di_defrag.df_cmd = defrag->df_cmd;
+	*defrag = di->di_defrag;
+	up(&mp->m_defrag_lock);
+	/* wait up the process to process the dropping */
+	wake_up_process(mp->m_defrag_task);
+	return 0;
+}
+
+static int xfs_file_defrag_suspend(struct inode *inode, struct xfs_defrag *defrag)
+{
+	struct xfs_mount        *mp = XFS_I(inode)->i_mount;
+	struct xfs_defrag_info  *di;
+
+	down(&mp->m_defrag_lock);
+	di = __xfs_find_defrag(inode->i_ino, mp);
+	if (di == NULL) {
+		up(&mp->m_defrag_lock);
+		defrag->df_ino = -1UL;
+		return -EINVAL;
+	}
+	di->di_defrag.df_suspended = true;
+	di->di_defrag.df_cmd = defrag->df_cmd;
+	*defrag = di->di_defrag;
+	up(&mp->m_defrag_lock);
+	return 0;
+}
+
+static int xfs_file_defrag_resume(struct inode *inode, struct xfs_defrag *defrag)
+{
+	struct xfs_mount        *mp = XFS_I(inode)->i_mount;
+	struct xfs_defrag_info  *di;
+
+	down(&mp->m_defrag_lock);
+	di = __xfs_find_defrag(inode->i_ino, mp);
+	if (di == NULL) {
+		up(&mp->m_defrag_lock);
+		defrag->df_ino = -1UL;
+		return -EINVAL;
+	}
+	di->di_defrag.df_suspended = false;
+
+	di->di_defrag.df_cmd = defrag->df_cmd;
+	*defrag = di->di_defrag;
+	up(&mp->m_defrag_lock);
+	wake_up_process(mp->m_defrag_task);
+	return 0;
+}
+
+int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)
+{
+	struct inode		*inode = filp->f_inode;
+
+	defrag->df_ino = inode->i_ino;
+
+	switch (defrag->df_cmd) {
+	case XFS_DEFRAG_CMD_START:
+		return xfs_file_defrag_start(inode, defrag);
+	case XFS_DEFRAG_CMD_STOP:
+		return xfs_file_defrag_stop(inode, defrag);
+	case XFS_DEFRAG_CMD_STATUS:
+		xfs_file_defrag_status(inode, defrag);
+		return 0;
+	case XFS_DEFRAG_CMD_SUSPEND:
+		return xfs_file_defrag_suspend(inode, defrag);
+	case XFS_DEFRAG_CMD_RESUME:
+		return xfs_file_defrag_resume(inode, defrag);
+	default:
+		return -EOPNOTSUPP;
+	}
 }
-- 
2.39.3 (Apple Git-145)

