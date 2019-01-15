Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46056 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbfAORIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 12:08:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0FH4QTe004309
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:51 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pybjnn530-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:51 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0FH8otX025587
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:50 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0FH8obL016855
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:50 GMT
Date: Tue, 15 Jan 2019 09:08:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: use generic fillattr to reduce redundant code
Message-ID: <20190115170849.GC12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_vn_getattr to use generic_fillattr to fill out parts of the
kstat structure instead of open-coding the same pieces.  This eliminates
redundant code and fixes a bug where we fail to set the AUTOMOUNT
attribute.  Obviously, we retain all the xfs-specific parts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..169bd7824479 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -501,16 +501,9 @@ xfs_vn_getattr(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	generic_fillattr(inode, stat);
 	stat->size = XFS_ISIZE(ip);
-	stat->dev = inode->i_sb->s_dev;
-	stat->mode = inode->i_mode;
-	stat->nlink = inode->i_nlink;
-	stat->uid = inode->i_uid;
-	stat->gid = inode->i_gid;
 	stat->ino = ip->i_ino;
-	stat->atime = inode->i_atime;
-	stat->mtime = inode->i_mtime;
-	stat->ctime = inode->i_ctime;
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
@@ -533,7 +526,6 @@ xfs_vn_getattr(
 	case S_IFBLK:
 	case S_IFCHR:
 		stat->blksize = BLKDEV_IOSIZE;
-		stat->rdev = inode->i_rdev;
 		break;
 	default:
 		if (XFS_IS_REALTIME_INODE(ip)) {
