Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D05C7F60
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:28:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51B52304039
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:28:25 -0800 (PST)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id Ws9rA6nmuNBdOdFy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 06:28:13 -0800 (PST)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Fri, 13 Dec 2013 07:28:10 -0700
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com
	[9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C23FA38C804A
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:28:04 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	rBDES65w9961862 for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:28:06 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	rBDES5Ut005221 for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:28:06 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH 1/5] xfs: factor prid related codes into xfs_get_initial_prid()
Date: Fri, 13 Dec 2013 22:27:49 +0800
Message-Id: <1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

It will be reused by the O_TMPFILE creation function.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 001aa89..e8b9a68 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1139,6 +1139,14 @@ xfs_bumplink(
 	return 0;
 }
 
+static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		return xfs_get_projid(dp);
+	else
+		return XFS_PROJID_DEFAULT;
+}
+
 int
 xfs_create(
 	xfs_inode_t		*dp,
@@ -1169,10 +1177,7 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
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
