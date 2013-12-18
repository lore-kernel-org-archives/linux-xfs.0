Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A040429DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 18:16:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6472F8F8040
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:16:03 -0800 (PST)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id Sb7h0cc7bwjWZhDx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 16:16:02 -0800 (PST)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Tue, 17 Dec 2013 19:16:01 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com
	[9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 1F57CC90046
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 19:15:57 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	rBI0Fwbs6160688 for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 00:15:58 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	rBI0Fw9h008972 for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 19:15:58 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH v2 1/3] xfs: factor prid related codes into
	xfs_get_initial_prid()
Date: Wed, 18 Dec 2013 08:15:43 +0800
Message-Id: <1387325745-22003-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1387325745-22003-1-git-send-email-zwu.kernel@gmail.com>
References: <1387325745-22003-1-git-send-email-zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

It will be reused by the O_TMPFILE creation function.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c   |    6 +-----
 fs/xfs/xfs_inode.h   |   10 ++++++++++
 fs/xfs/xfs_symlink.c |    5 +----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 001aa89..c79b875 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,7 +42,6 @@
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
-#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
@@ -1169,10 +1168,7 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = xfs_get_projid(dp);
-	else
-		prid = XFS_PROJID_DEFAULT;
+	prid = xfs_get_initial_prid(dp);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9e6efccb..6c58349 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -20,6 +20,7 @@
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_dinode.h"
 
 /*
  * Kernel only inode definitions
@@ -192,6 +193,15 @@ xfs_set_projid(struct xfs_inode *ip,
 	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
 }
 
+static inline prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		return xfs_get_projid(dp);
+
+	return XFS_PROJID_DEFAULT;
+}
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 14e58f2..13140c7 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -208,10 +208,7 @@ xfs_symlink(
 		return XFS_ERROR(ENAMETOOLONG);
 
 	udqp = gdqp = NULL;
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = xfs_get_projid(dp);
-	else
-		prid = XFS_PROJID_DEFAULT;
+	prid = xfs_get_initial_prid(dp);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
