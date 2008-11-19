Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4nsRH029981 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:49:54 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0510C159E769
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:49:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 0cOjmCEnYReX6Dvm for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:49:23 -0800 (PST)
Message-Id: <20081119044909.789177139@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:08 -0600
From: sandeen@sandeen.net
Subject: [patch 07/11] Fix compat XFS_IOC_FSBULKSTAT_SINGLE ioctl
Content-Disposition: inline; filename=compat_ioctl_bulkstat_single_fix
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: hch@infradead.org

The XFS_IOC_FSBULKSTAT_SINGLE ioctl passes in the
desired inode number, while XFS_IOC_FSBULKSTAT passes
in the previous/last-stat'd inode number.  The
compat handler wasn't differentiating these, so
when a XFS_IOC_FSBULKSTAT_SINGLE request for inode
128 was sent in, stat information for 131 was sent out.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -279,7 +279,7 @@ xfs_ioc_bulkstat_compat(
 	int			count;	/* # of records returned */
 	xfs_ino_t		inlast;	/* last inode number */
 	int			done;
-	int			error;
+	int			error = EINVAL;
 
 	/* done = 1 if there are more stats to get and if bulkstat */
 	/* should be called again (unused here, but used in dmapi) */
@@ -310,17 +310,23 @@ xfs_ioc_bulkstat_compat(
 	if (bulkreq.ubuffer == NULL)
 		return -XFS_ERROR(EINVAL);
 
-	if (cmd == XFS_IOC_FSINUMBERS_32)
+	if (cmd == XFS_IOC_FSINUMBERS_32) {
 		error = xfs_inumbers(mp, &inlast, &count,
 				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
-	else {
+	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
+		int res;
+
+		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
+				sizeof(compat_xfs_bstat_t),
+				NULL, 0, NULL, NULL, &res);
+	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
 			xfs_bulkstat_one_compat, NULL,
 			sizeof(compat_xfs_bstat_t), bulkreq.ubuffer,
 			BULKSTAT_FG_QUICK, &done);
 	}
 	if (error)
-		return -error;
+		return -XFS_ERROR(error);
 
 	if (bulkreq.ocount != NULL) {
 		if (copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)) ||

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
