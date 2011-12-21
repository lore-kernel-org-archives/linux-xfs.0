Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBL08HMe199503 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 18:08:17 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1ssktBuao3m6hw4f for <xfs@oss.sgi.com>;
	Tue, 20 Dec 2011 16:08:15 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Rd9it-0000QP-RQ
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 11:07:55 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Rd9ij-0005bY-NQ
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 11:07:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: clean up minor sparse warnings
Date: Wed, 21 Dec 2011 11:07:41 +1100
Message-Id: <1324426062-21505-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1324426062-21505-1-git-send-email-david@fromorbit.com>
References: <1324426062-21505-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_block.c |    1 +
 fs/xfs/xfs_ioctl.c      |   10 ++++------
 fs/xfs/xfs_ioctl32.c    |    2 +-
 fs/xfs/xfs_iops.c       |   13 ++++++++-----
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 9245e02..d3b63ae 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -29,6 +29,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d99a905..2f3f56a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -230,24 +230,22 @@ xfs_open_by_handle(
 
 	/* Put open permission in namei format. */
 	permflag = hreq->oflags;
-	if ((permflag+1) & O_ACCMODE)
-		permflag++;
 	if (permflag & O_TRUNC)
-		permflag |= 2;
+		permflag |= O_RDWR;
 
 	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
-	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
+	    (OPEN_FMODE(permflag) & FMODE_WRITE) && IS_APPEND(inode)) {
 		error = -XFS_ERROR(EPERM);
 		goto out_dput;
 	}
 
-	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
+	if ((OPEN_FMODE(permflag) & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
 		error = -XFS_ERROR(EACCES);
 		goto out_dput;
 	}
 
 	/* Can't write directories. */
-	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
+	if (S_ISDIR(inode->i_mode) && (OPEN_FMODE(permflag) & FMODE_WRITE)) {
 		error = -XFS_ERROR(EISDIR);
 		goto out_dput;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 54e623b..ce332af 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -293,7 +293,7 @@ xfs_compat_ioc_bulkstat(
 		int res;
 
 		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), 0, &res);
+				sizeof(compat_xfs_bstat_t), NULL, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
 			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 23ce927..a5a9772 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -103,12 +103,15 @@ xfs_mark_inode_dirty(
 }
 
 
-int xfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		   void *fs_info)
+static int
+xfs_initxattrs(
+	struct inode		*inode,
+	const struct xattr	*xattr_array,
+	void			*fs_info)
 {
-	const struct xattr *xattr;
-	struct xfs_inode *ip = XFS_I(inode);
-	int error = 0;
+	const struct xattr	*xattr;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		error = xfs_attr_set(ip, xattr->name, xattr->value,
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
