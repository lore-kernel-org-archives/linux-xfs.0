Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D77D7F54
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:18:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1CCDAC003
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:18:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 98zPSSfiqoDSFJId (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:18:08 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s539I7xY027649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:07 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s539I6cb012623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:06 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539I5B7013759 for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:05 GMT
Message-ID: <538D92CA.9090604@oracle.com>
Date: Tue, 03 Jun 2014 17:18:02 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 02/10] xfs: remove xfs_bulkstat_single
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

From: Christoph Hellwig <hch@lst.de>

xfs_bukstat_one doesn't have any failure case that would go away when
called through xfs_bulkstat, so remove the fallback and the now unessecary
xfs_bulkstat_single function.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ioctl.c  |  4 ++--
 fs/xfs/xfs_itable.c | 48 ------------------------------------------------
 fs/xfs/xfs_itable.h |  7 -------
 3 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55724c8..eb5a366 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -799,8 +799,8 @@ xfs_ioc_bulkstat(
 		error = xfs_inumbers(mp, &inlast, &count,
 					bulkreq.ubuffer, xfs_inumbers_fmt);
 	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
-		error = xfs_bulkstat_single(mp, &inlast,
-						bulkreq.ubuffer, &done);
+		error = xfs_bulkstat_one(mp, inlast, bulkreq.ubuffer,
+					sizeof(xfs_bstat_t), NULL, &done);
 	else	/* XFS_IOC_FSBULKSTAT */
 		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
 				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2e7b397..4d62e63 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -509,54 +509,6 @@ xfs_bulkstat(
 	return rval;
 }
 
-/*
- * Return stat information in bulk (by-inode) for the filesystem.
- * Special case for non-sequential one inode bulkstat.
- */
-int					/* error status */
-xfs_bulkstat_single(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_ino_t		*lastinop, /* inode to return */
-	char			__user *buffer, /* buffer with inode stats */
-	int			*done)	/* 1 if there are more stats to get */
-{
-	int			count;	/* count value for bulkstat call */
-	int			error;	/* return value */
-	xfs_ino_t		ino;	/* filesystem inode number */
-	int			res;	/* result from bs1 */
-
-	/*
-	 * note that requesting valid inode numbers which are not allocated
-	 * to inodes will most likely cause xfs_imap_to_bp to generate warning
-	 * messages about bad magic numbers. This is ok. The fact that
-	 * the inode isn't actually an inode is handled by the
-	 * error check below. Done this way to make the usual case faster
-	 * at the expense of the error case.
-	 */
-
-	ino = *lastinop;
-	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
-				 NULL, &res);
-	if (error) {
-		/*
-		 * Special case way failed, do it the "long" way
-		 * to see if that works.
-		 */
-		(*lastinop)--;
-		count = 1;
-		if (xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
-				sizeof(xfs_bstat_t), buffer, done))
-			return error;
-		if (count == 0 || (xfs_ino_t)*lastinop != ino)
-			return error == EFSCORRUPTED ?
-				XFS_ERROR(EINVAL) : error;
-		else
-			return 0;
-	}
-	*done = 0;
-	return 0;
-}
-
 int
 xfs_inumbers_fmt(
 	void			__user *ubuffer, /* buffer to write to */
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 97295d9..6ea8b39 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -50,13 +50,6 @@ xfs_bulkstat(
 	char		__user *ubuffer,/* buffer with inode stats */
 	int		*done);		/* 1 if there are more stats to get */
 
-int
-xfs_bulkstat_single(
-	xfs_mount_t		*mp,
-	xfs_ino_t		*lastinop,
-	char			__user *buffer,
-	int			*done);
-
 typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
 	void			__user *ubuffer, /* buffer to write to */
 	int			ubsize,		 /* remaining user buffer sz */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
