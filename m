Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BlnEsQyC"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4ECB2
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:35 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9wtfq021847
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=YgrcgW3z92Uy8iOYrWtyxhSklgpDltbkupoXwQhNA2E=;
 b=BlnEsQyCsGI8OEq5U5kN4sxMHuYts8TilDKWNg4VuP4JQMZDqedRxJ7A4dP0/b34oU6I
 SoVkCVm2HmjDLkXN7T70CZp3Pr9AhZvPwQSSn+tb5WqPCnMc1WtIwU673PoEPt4oMQkS
 7mlI4GwPeuUC4w425BZsuOjMMB5/M0/D2WDE4D5guTvFNdbqoG4gxH8nVX23VRuI91y/
 8htwH66qVnkq3T+uihbW/TON4OA4UZCOrN2Zu7fVjbpPdfSQ4ur9efIay459Lw4tPQRf
 SuPvXfAtb9s4rZddqsjk2VlQQAxw8ouXKpdUJXxP9JEHGvcKv9c3MZp2LXr+jWkEN3AB aQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrsqty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGr9Qp012810
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:32 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnf036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:32 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-2;
	Thu, 14 Dec 2023 17:05:32 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 1/9] xfs: defrag: introduce strucutures and numbers.
Date: Thu, 14 Dec 2023 09:05:22 -0800
Message-Id: <20231214170530.8664-2-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: Sz0hOMo0WXkBAsOuby1yw40XjozpjzwN
X-Proofpoint-ORIG-GUID: Sz0hOMo0WXkBAsOuby1yw40XjozpjzwN

introduce strucutures and numbers only.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/Makefile        |  1 +
 fs/xfs/libxfs/xfs_fs.h |  1 +
 fs/xfs/xfs_defrag.c    | 60 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_defrag.h    | 11 ++++++++
 fs/xfs/xfs_ioctl.c     | 17 ++++++++++++
 fs/xfs/xfs_mount.h     | 37 ++++++++++++++++++++++++++
 6 files changed, 127 insertions(+)
 create mode 100644 fs/xfs/xfs_defrag.c
 create mode 100644 fs/xfs/xfs_defrag.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7762c01a85cf..ba7f7bc4abf9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -93,6 +93,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_sysfs.o \
 				   xfs_trans.o \
 				   xfs_xattr.o \
+				   xfs_defrag.o \
 				   kmem.o
 
 # low-level transaction/log code
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6360073865db..4b0fdb900df5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -837,6 +837,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+#define XFS_IOC_DEFRAG		     _IOWR('X', 129, struct xfs_defrag)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
new file mode 100644
index 000000000000..954d05376809
--- /dev/null
+++ b/fs/xfs/xfs_defrag.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Wengang Wang <wen.gang.wang@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap.h"
+#include "xfs_inode_fork.h"
+#include "xfs_inode.h"
+#include "xfs_reflink.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_buf.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_ag.h"
+#include "xfs_alloc.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_defer.h"
+#include "xfs_log_priv.h"
+#include "xfs_extfree_item.h"
+#include "xfs_bmap_item.h"
+#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
+
+#include <linux/sort.h>
+
+/*
+ * The max number of extents in a piece.
+ * can't be too big, it will have log space presure
+ */
+#define XFS_DEFRAG_PIECE_MAX_EXT	512
+
+/*
+ * Milliseconds we leave the info unremoved when a defrag failed.
+ * This aims to give user space a way to get the error code.
+ */
+#define XFS_DERFAG_GRACE_PERIOD	30000
+
+/* limitation of pending online defrag */
+#define XFS_DEFRAG_MAX_PARALLEL		128
+
+/*
+ * The max size, in blocks, of a piece.
+ * can't be too big, it may hard to get such a free extent
+ */
+#define XFS_DEFRAG_MAX_PIECE_BLOCKS	4096U
+
+int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)
+{
+	return -EOPNOTSUPP;
+}
diff --git a/fs/xfs/xfs_defrag.h b/fs/xfs/xfs_defrag.h
new file mode 100644
index 000000000000..21113d8c1567
--- /dev/null
+++ b/fs/xfs/xfs_defrag.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Wengang Wang <wen.gang.wang@oracle.com>
+ */
+#ifndef __XFS_DEFRAG_H__
+#define __XFS_DEFRAG_H__
+void xfs_initialize_defrag(struct xfs_mount *mp);
+int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag);
+void xfs_stop_wait_defrags(struct xfs_mount *mp);
+#endif /* __XFS_DEFRAG_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6c3919687ea6..7f7a7094ace9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -39,6 +39,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_defrag.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -2160,6 +2161,22 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case XFS_IOC_DEFRAG: {
+		struct xfs_defrag	defrag;
+		int			ret;
+
+		if (xfs_is_readonly(mp))
+			return -EROFS;
+
+		if (copy_from_user(&defrag, arg, sizeof(defrag)))
+			return -EFAULT;
+
+		ret =  xfs_file_defrag(filp, &defrag);
+		if (ret == 0)
+			ret = copy_to_user(arg, &defrag, sizeof(defrag));
+		return ret;
+	}
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 503fe3c7edbf..05b372cde389 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -71,6 +71,34 @@ struct xfs_inodegc {
 	unsigned int		cpu;
 };
 
+/* Online Defrag */
+enum xfs_defrag_cmd {
+	XFS_DEFRAG_CMD_START	= 1,	/* start defrag, or change configuration */
+	XFS_DEFRAG_CMD_STOP,		/* stop defrag */
+	XFS_DEFRAG_CMD_SUSPEND,		/* suspend on going defrag */
+	XFS_DEFRAG_CMD_RESUME,		/* resume suspended defrag */
+	XFS_DEFRAG_CMD_STATUS,		/* get status */
+};
+
+struct xfs_defrag {
+	/* [IN] XFS_DEFRAG_CMD_* */
+	enum xfs_defrag_cmd	df_cmd;
+	/* [IN] the size of piece in blocks */
+	unsigned int		df_piece_size;
+	/* [IN] the target extent size */
+	unsigned int		df_tgt_extsize;
+	/* [IN] idle time in ms between adjacent pieces */
+	unsigned int		df_idle_time;
+	/* [OUT] current running status */
+	int			df_status;
+	/* [OUT] the number of the processed blocks */
+	unsigned long long	df_blocks_done;
+	/* [OUT] inode number of the file under defragmentation */
+	unsigned long		df_ino;
+	/* [OUT] defragmenting on this file is suspended */
+	bool			df_suspended;
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -252,6 +280,15 @@ typedef struct xfs_mount {
 
 	/* cpus that have inodes queued for inactivation */
 	struct cpumask		m_inodegc_cpumask;
+
+	/* lock to serialize the access of defrags fields */
+	struct semaphore	m_defrag_lock;
+	/* number of pending defragmentation in this FS */
+	unsigned int		m_nr_defrag;
+	/* list that links up all pending defragmentation */
+	struct list_head	m_defrag_list;
+	/* the task which does defragmentation job */
+	struct task_struct	*m_defrag_task;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
-- 
2.39.3 (Apple Git-145)

