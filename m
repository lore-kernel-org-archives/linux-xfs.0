Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vfdznz0m"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB63114
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9wtfr021847
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=rwSyiA5IoYWxhi84dU5zVjoXWfZ1EZP74jPSc/4PVTU=;
 b=Vfdznz0mfA8SNW2CijBVV8t7n008u43siOicwABM8v4JJtR72xrTFpz2Bm32VPisPqay
 YYSuVk+9Mu3Ng+5wiaXjLVZf4gwnOQwueRHEihGO3Zj7+IpPT9jVfHOvXAZgwABdSgEk
 uiycu0MsI0jkl3qQ2bv2uwaRwoS8HPjivC+ph06uzFWaQTzubduk66MkC/B37m5rO9cx
 zO2ouZgASmW7KNvqhf2osw5p/r3Ek+rQN0pVr1nW+qxiUw+4mfOjNL/RXySmZlY+vap1
 iFUEVkGsXf9VMGAlvjErbjOhTO8EoSXcss4mNkCqBUp7vFuwZ1TYrE6aLRA/2iRDwX8K jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrsqu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGYQKP012869
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnl036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-5;
	Thu, 14 Dec 2023 17:05:33 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 4/9] xfs: defrag: allocate/cleanup defragmentation
Date: Thu, 14 Dec 2023 09:05:25 -0800
Message-Id: <20231214170530.8664-5-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: lgCMLncs9TNe5_-H4ud6l1aVQoTCJZOu
X-Proofpoint-ORIG-GUID: lgCMLncs9TNe5_-H4ud6l1aVQoTCJZOu

1. allocate new defragmentation
2. clean up defragentations

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 123 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index 4a10528912ca..fec617ac5945 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -154,9 +154,74 @@ struct xfs_defrag_info *__xfs_find_defrag(unsigned long ino,
 	return NULL;
 }
 
+static void xfs_change_defrag_param(struct xfs_defrag *to, struct xfs_defrag *from)
+{
+	to->df_piece_size = from->df_piece_size;
+	to->df_tgt_extsize = from->df_tgt_extsize;
+	to->df_idle_time = from->df_idle_time;
+	to->df_ino = from->df_ino;
+}
+
+/* caller holds m_defrag_lock */
+static struct xfs_defrag_info *__alloc_new_defrag_info(struct xfs_mount *mp)
+{
+	struct xfs_defrag_info *di;
+
+	di = kmem_alloc(sizeof(struct xfs_defrag_info), KM_ZERO);
+	mp->m_nr_defrag++;
+	return di;
+}
+
+/* sleep some jiffies */
+static inline void xfs_defrag_idle(unsigned int idle_jiffies)
+{
+	if (idle_jiffies > 0) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(idle_jiffies);
+	}
+}
+
+/* caller holds mp->m_defrag_lock */
+static void __xfs_drop_defrag(struct xfs_defrag_info *di, struct xfs_mount *mp)
+{
+	list_del(&di->di_list);
+	mp->m_nr_defrag--;
+	iput(VFS_I(di->di_ip));
+	kfree(di);
+}
+
+/* clean up all defragmentation jobs in this XFS */
+void clean_up_defrags(struct xfs_mount *mp)
+{
+	struct xfs_defrag_info *di, *tmp;
+
+	down(&mp->m_defrag_lock);
+	list_for_each_entry_safe(di, tmp, &mp->m_defrag_list, di_list) {
+		__xfs_drop_defrag(di, mp);
+	}
+	ASSERT(mp->m_nr_defrag == 0);
+	up(&mp->m_defrag_lock);
+}
+
+/* run as a separated process.
+ * defragment files in mp->m_defrag_list
+ */
+int xfs_defrag_process(void *data)
+{
+	struct xfs_mount	*mp = data;
+
+	while (!kthread_should_stop())
+		xfs_defrag_idle(1000);
+
+	clean_up_defrags(mp);
+	return 0;
+}
+
 /* start a new defragmetation or change the parameters on the existing one */
 static int xfs_file_defrag_start(struct inode *inode, struct xfs_defrag *defrag)
 {
+	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	struct xfs_defrag_info	*di = NULL;
 	int			ret = 0;
 
 	if ((inode->i_mode & S_IFMT) != S_IFREG) {
@@ -174,9 +239,63 @@ static int xfs_file_defrag_start(struct inode *inode, struct xfs_defrag *defrag)
 		goto out;
 	}
 
+	/* racing with unmount and freeze */
+	if (down_read_trylock(&inode->i_sb->s_umount) == 0) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	down(&mp->m_defrag_lock);
+	if (!__xfs_new_defrag_allowed(mp)) {
+		ret = -EAGAIN;
+		goto up_return;
+	}
+
+	di = __xfs_find_defrag(inode->i_ino, mp);
+	if (di) {
+		/*
+		 * the file is already under defragmentation,
+		 * a subsequential "start" is used to adjust parameters
+		 * on the existing defragmentation
+		 */
+		xfs_change_defrag_param(&di->di_defrag, defrag);
+		ret = 0;
+		goto up_return;
+	}
+
+	inode = igrab(inode);
+	if (!inode) {
+		ret = -EAGAIN;
+		goto up_return;
+	}
+
+	/* a new defragmentation */
+	di = __alloc_new_defrag_info(mp);
+	xfs_change_defrag_param(&di->di_defrag, defrag);
+	di->di_ip = XFS_I(inode);
+	list_add_tail(&di->di_list, &mp->m_defrag_list);
+
+	/*
+	 * defrag process per FS is creatd on demand and keep alive until
+	 * FS is unmounted.
+	 */
+	if (mp->m_defrag_task == NULL) {
+		mp->m_defrag_task = kthread_run(xfs_defrag_process, mp,
+					"xdf_%s", mp->m_super->s_id);
+		if (IS_ERR(mp->m_defrag_task)) {
+			ret = PTR_ERR(mp->m_defrag_task);
+			mp->m_defrag_task = NULL;
+		}
+	} else {
+		wake_up_process(mp->m_defrag_task);
+	}
+
+up_return:
+	up(&mp->m_defrag_lock);
+	up_read(&inode->i_sb->s_umount);
 out:
-	return -EOPNOTSUPP;
- }
+	return ret;
+}
 
 static void xfs_file_defrag_status(struct inode *inode, struct xfs_defrag *defrag)
 {
-- 
2.39.3 (Apple Git-145)

