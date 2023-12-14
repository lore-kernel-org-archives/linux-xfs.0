Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SYd4HMpu"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34E9B7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:35 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGVCYK021767
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=1i/uv+lZ0GaOP+g87fHxC17P0e6+gabfE/anZfvV2hg=;
 b=SYd4HMpu8JKTsU6DsnbiFtAuSMKPk/u8zOG1vMuK+mhPgO5aYQ18gIsXP3lIFTTtVl8J
 YAfubg0OYJbrARQS+eqL+EUnwJqR8jSMAh4zFMmVaD/nYzo9orfZLCM5D9SmErqfSDRy
 kD82EvAmq2MRgAYArTYYsay7HIgocwI+Mo4Rsw0SU8LEt4D5tSGFSXCrEdYrkCI57kwT
 HGQGBvmLoN5MMHw4XONkGqkc1Q/jJR+pDcIFfOqZfpeuAGUv2uHqZiox5Fw6c1yTA6gd
 V55fXhAi7BEllTHbd7X3rQofiZOCQDuc0n3s/AplxSonZqNOfU6fSWi07jd+zGoNgR34 hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrsqu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGZTc5013007
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnh036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:32 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-3;
	Thu, 14 Dec 2023 17:05:32 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 2/9] xfs: defrag: initialization and cleanup
Date: Thu, 14 Dec 2023 09:05:23 -0800
Message-Id: <20231214170530.8664-3-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: 5-cc4uFtr0uvziQeBk8Bp3j1L_1fgZF-
X-Proofpoint-ORIG-GUID: 5-cc4uFtr0uvziQeBk8Bp3j1L_1fgZF-

initialization online defrag on a new mount.
cleanup when unmounting.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 23 +++++++++++++++++++++++
 fs/xfs/xfs_mount.c  |  3 +++
 fs/xfs/xfs_super.c  |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index 954d05376809..8bdc6290a69d 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -54,6 +54,29 @@
  */
 #define XFS_DEFRAG_MAX_PIECE_BLOCKS	4096U
 
+/* initialization called for new mount */
+void xfs_initialize_defrag(struct xfs_mount *mp)
+{
+	sema_init(&mp->m_defrag_lock, 1);
+	mp->m_nr_defrag = 0;
+	mp->m_defrag_task = NULL;
+	INIT_LIST_HEAD(&mp->m_defrag_list);
+}
+
+/* stop all the defragmentations on this mount and wait until they really stopped */
+void xfs_stop_wait_defrags(struct xfs_mount *mp)
+{
+	down(&mp->m_defrag_lock);
+	if (list_empty(&mp->m_defrag_list)) {
+		up(&mp->m_defrag_lock);
+		return;
+	}
+	ASSERT(mp->m_defrag_task);
+	up(&mp->m_defrag_lock);
+	kthread_stop(mp->m_defrag_task);
+	mp->m_defrag_task = NULL;
+}
+
 int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)
 {
 	return -EOPNOTSUPP;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index aed5be5508fe..ed7e1f150b59 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "scrub/stats.h"
+#include "xfs_defrag.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -1056,6 +1057,8 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
+	xfs_stop_wait_defrags(mp);
+
 	/*
 	 * Perform all on-disk metadata updates required to inactivate inodes
 	 * that the VFS evicted earlier in the unmount process.  Freeing inodes
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 764304595e8b..f74706130e35 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,6 +44,7 @@
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
 #include "scrub/stats.h"
+#include "xfs_defrag.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -2023,6 +2024,8 @@ static int xfs_init_fs_context(
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 
+	xfs_initialize_defrag(mp);
+
 	return 0;
 }
 
-- 
2.39.3 (Apple Git-145)

