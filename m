Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32C367F37
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 08:28:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 13446304064
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 06:28:35 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TYFFEdRDq2rpNbDm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 06:28:35 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rALESXkT019218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 14:28:34 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rALESXSG014054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 14:28:33 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rALESXC8003470 for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 14:28:33 GMT
Message-ID: <528E188C.6070208@oracle.com>
Date: Thu, 21 Nov 2013 22:28:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: integrate xfs_quota_priv header file to xfs_qm
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

The xfs_quota_priv header file is only included by xfs_qm header and
there is no much users for its contents, hence we can move those stuff
to xfs_qm header file and kill it.

This patch also remove an unused macro DQFLAGTO_TYPESTR.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm.h         | 36 +++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_quota_priv.h | 42 ------------------------------------------
 2 files changed, 35 insertions(+), 43 deletions(-)
 delete mode 100644 fs/xfs/xfs_quota_priv.h

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index a788b66..ae02b84 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -20,13 +20,47 @@
 
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
-#include "xfs_quota_priv.h"
 
 struct xfs_inode;
 
 extern struct kmem_zone	*xfs_qm_dqtrxzone;
 
 /*
+ * Number of bmaps that we ask from bmapi when doing a quotacheck.
+ * We make this restriction to keep the memory usage to a minimum.
+ */
+#define XFS_DQITER_MAP_SIZE	10
+
+#define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
+	!dqp->q_core.d_blk_hardlimit && \
+	!dqp->q_core.d_blk_softlimit && \
+	!dqp->q_core.d_rtb_hardlimit && \
+	!dqp->q_core.d_rtb_softlimit && \
+	!dqp->q_core.d_ino_hardlimit && \
+	!dqp->q_core.d_ino_softlimit && \
+	!dqp->q_core.d_bcount && \
+	!dqp->q_core.d_rtbcount && \
+	!dqp->q_core.d_icount)
+
+/*
+ * Number of bmaps that we ask from bmapi when doing a quotacheck.
+ * We make this restriction to keep the memory usage to a minimum.
+ */
+#define XFS_DQITER_MAP_SIZE	10
+
+#define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
+	!dqp->q_core.d_blk_hardlimit && \
+	!dqp->q_core.d_blk_softlimit && \
+	!dqp->q_core.d_rtb_hardlimit && \
+	!dqp->q_core.d_rtb_softlimit && \
+	!dqp->q_core.d_ino_hardlimit && \
+	!dqp->q_core.d_ino_softlimit && \
+	!dqp->q_core.d_bcount && \
+	!dqp->q_core.d_rtbcount && \
+	!dqp->q_core.d_icount)
+
+
+/*
  * This defines the unit of allocation of dquots.
  * Currently, it is just one file system block, and a 4K blk contains 30
  * (136 * 30 = 4080) dquots. It's probably not worth trying to make
diff --git a/fs/xfs/xfs_quota_priv.h b/fs/xfs/xfs_quota_priv.h
deleted file mode 100644
index 6d86219..0000000
--- a/fs/xfs/xfs_quota_priv.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (c) 2000-2003 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_QUOTA_PRIV_H__
-#define __XFS_QUOTA_PRIV_H__
-
-/*
- * Number of bmaps that we ask from bmapi when doing a quotacheck.
- * We make this restriction to keep the memory usage to a minimum.
- */
-#define XFS_DQITER_MAP_SIZE	10
-
-#define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
-	!dqp->q_core.d_blk_hardlimit && \
-	!dqp->q_core.d_blk_softlimit && \
-	!dqp->q_core.d_rtb_hardlimit && \
-	!dqp->q_core.d_rtb_softlimit && \
-	!dqp->q_core.d_ino_hardlimit && \
-	!dqp->q_core.d_ino_softlimit && \
-	!dqp->q_core.d_bcount && \
-	!dqp->q_core.d_rtbcount && \
-	!dqp->q_core.d_icount)
-
-#define DQFLAGTO_TYPESTR(d)	(((d)->dq_flags & XFS_DQ_USER) ? "USR" : \
-				 (((d)->dq_flags & XFS_DQ_GROUP) ? "GRP" : \
-				 (((d)->dq_flags & XFS_DQ_PROJ) ? "PRJ":"???")))
-
-#endif	/* __XFS_QUOTA_PRIV_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
