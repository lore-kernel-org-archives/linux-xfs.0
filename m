Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 935D97F5F
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:58:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DD30AC005
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:58:29 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Nuq5IlunfTDSCF4o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:58:27 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3I0wPme015792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:26 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wPrJ015738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:25 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wOMx024635 for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:24 GMT
Message-ID: <535078AD.5050209@oracle.com>
Date: Fri, 18 Apr 2014 08:58:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 02/10] xfs: consolidate xfs_bulkstat_single
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

In xfs_bulkstat_single(), call xfs_bulkstat_one() and xfs_bulkstat()
would return different error if either failed, we'd better return the
proper error in this case.  Moreover, the function argument done is
useless in terms of xfs_ioc_bulkstat(), hence we can get rid of it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ioctl.c  |  3 +--
 fs/xfs/xfs_itable.c | 60 ++++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_itable.h |  5 ++---
 3 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0b18776..f9c4512 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -798,8 +798,7 @@ xfs_ioc_bulkstat(
 		error = xfs_inumbers(mp, &inlast, &count,
 					bulkreq.ubuffer, xfs_inumbers_fmt);
 	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
-		error = xfs_bulkstat_single(mp, &inlast,
-						bulkreq.ubuffer, &done);
+		error = xfs_bulkstat_single(mp, &inlast, bulkreq.ubuffer);
 	else	/* XFS_IOC_FSBULKSTAT */
 		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
 				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index b5bb7b6..f34e95a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -509,51 +509,51 @@ xfs_bulkstat(
 }
 
 /*
- * Return stat information in bulk (by-inode) for the filesystem.
- * Special case for non-sequential one inode bulkstat.
+ * Return stat information in bulk (by-inode) for the filesystem.  Special case
+ * for non-sequential one inode bulkstat.
  */
-int					/* error status */
+int
 xfs_bulkstat_single(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
+	struct xfs_mount	*mp,	/* mount point for filesystem */
 	xfs_ino_t		*lastinop, /* inode to return */
-	char			__user *buffer, /* buffer with inode stats */
-	int			*done)	/* 1 if there are more stats to get */
+	char			__user *buffer) /* buffer with inode stats */
 {
-	int			count;	/* count value for bulkstat call */
-	int			error;	/* return value */
-	xfs_ino_t		ino;	/* filesystem inode number */
+	xfs_ino_t		ino = *lastinop;
 	int			res;	/* result from bs1 */
+	int			error;
 
 	/*
-	 * note that requesting valid inode numbers which are not allocated
+	 * Note that requesting valid inode numbers which are not allocated
 	 * to inodes will most likely cause xfs_imap_to_bp to generate warning
-	 * messages about bad magic numbers. This is ok. The fact that
-	 * the inode isn't actually an inode is handled by the
-	 * error check below. Done this way to make the usual case faster
-	 * at the expense of the error case.
+	 * messages about bad magic numbers. This is ok. The fact that the
+	 * inode isn't actually an inode is handled by the error check below.
+	 * Done this way to make the usual case faster at the expense of the
+	 * error case.
 	 */
-
-	ino = *lastinop;
-	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
+	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(struct xfs_bstat),
 				 NULL, &res);
 	if (error) {
+		int		count = 1;
+		int		done, error2;
+
 		/*
-		 * Special case way failed, do it the "long" way
-		 * to see if that works.
+		 * Special case way failed, do it the "long" way to see if
+		 * that works.
 		 */
 		(*lastinop)--;
-		count = 1;
-		if (xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
-				sizeof(xfs_bstat_t), buffer, done))
-			return error;
-		if (count == 0 || (xfs_ino_t)*lastinop != ino)
-			return error == EFSCORRUPTED ?
-				XFS_ERROR(EINVAL) : error;
-		else
-			return 0;
+		error2 = xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
+				      sizeof(struct xfs_bstat), buffer, &done);
+		if (error2)
+			return error2;
+
+		if (count == 0 || *lastinop != ino) {
+			if (error == EFSCORRUPTED)
+				error = XFS_ERROR(EINVAL);
+		} else
+			error = 0;
 	}
-	*done = 0;
-	return 0;
+
+	return error;
 }
 
 int
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 97295d9..21dbbd7 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -52,10 +52,9 @@ xfs_bulkstat(
 
 int
 xfs_bulkstat_single(
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	xfs_ino_t		*lastinop,
-	char			__user *buffer,
-	int			*done);
+	char			__user *buffer);
 
 typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
 	void			__user *ubuffer, /* buffer to write to */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
