Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbeCOA3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 20:29:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2F0RSjl083838
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:51 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2gqdf5048x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:51 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0Tn8e027812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:50 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0TnWr013066
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:29:49 GMT
Subject: [PATCH 3/9] xfs: refactor inode verifier error logging
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Mar 2018 17:29:48 -0700
Message-ID: <152107378868.19571.6256278246118880952.stgit@magnolia>
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
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
 

