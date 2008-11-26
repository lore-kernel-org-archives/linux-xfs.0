Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3KU1l000815 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:20:30 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9791D15FCD6A
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id X1GXGwT25hcsDsU3 for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:29 -0800 (PST)
Message-Id: <20081126032028.730961152@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:13 -0600
From: sandeen@sandeen.net
Subject: [patch 08/12] Fix compat XFS_IOC_FSBULKSTAT_SINGLE ioctl
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:30.486001225 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:26.662001447 -0600
@@ -292,15 +292,22 @@ xfs_compat_ioc_bulkstat(
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
-	}
+	} else
+		error = XFS_ERROR(EINVAL);
 	if (error)
 		return -error;
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
