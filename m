Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWCAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:00:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N1umL1146550
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:42 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2ga9bpg1yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:42 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N20fc7018571
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:41 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N20fO6010366
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:41 GMT
Subject: [PATCH 2/8] xfs: refactor inode verifier error logging
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:00:40 -0800
Message-ID: <151935124037.21842.10647303189739031227.stgit@magnolia>
In-Reply-To: <151935122813.21842.14996049216693190946.stgit@magnolia>
References: <151935122813.21842.14996049216693190946.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor some of the inode verifier failure logging call sites to use
the new xfs_inode_verifier_error method which dumps the offending buffer
as well as the code location of the failed check.  This trims the
output, makes it clearer to the admin that repair must be run, and gives
the developers more details to work from.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |    5 +++--
 fs/xfs/libxfs/xfs_inode_fork.c |   15 +++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5850e76..fe7534e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1244,8 +1244,9 @@ xfs_iread_extents(
 			xfs_warn(ip->i_mount,
 				"corrupt dinode %Lu, (btree extents).",
 				(unsigned long long) ip->i_ino);
-			XFS_CORRUPTION_ERROR(__func__,
-				XFS_ERRLEVEL_LOW, ip->i_mount, block);
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+					__func__, block, sizeof(*block),
+					__this_address);
 			error = -EFSCORRUPTED;
 			goto out_brelse;
 		}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 613fba2..701c42a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -195,8 +195,9 @@ xfs_iformat_local(
 	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
-		XFS_CORRUPTION_ERROR("xfs_iformat_local", XFS_ERRLEVEL_LOW,
-				     ip->i_mount, dip);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+				"xfs_iformat_local", dip, sizeof(*dip),
+				__this_address);
 		return -EFSCORRUPTED;
 	}
 
@@ -231,8 +232,9 @@ xfs_iformat_extents(
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
 		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
 			(unsigned long long) ip->i_ino, nex);
-		XFS_CORRUPTION_ERROR("xfs_iformat_extents(1)", XFS_ERRLEVEL_LOW,
-				     mp, dip);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+				"xfs_iformat_extents(1)", dip, sizeof(*dip),
+				__this_address);
 		return -EFSCORRUPTED;
 	}
 
@@ -309,8 +311,9 @@ xfs_iformat_btree(
 		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
 		xfs_warn(mp, "corrupt inode %Lu (btree).",
 					(unsigned long long) ip->i_ino);
-		XFS_CORRUPTION_ERROR("xfs_iformat_btree", XFS_ERRLEVEL_LOW,
-					 mp, dip);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+				"xfs_iformat_btree", dfp, size,
+				__this_address);
 		return -EFSCORRUPTED;
 	}
 

