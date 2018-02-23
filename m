Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWCAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:00:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N1um6L066561
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:03 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2ga9bpg201-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N201xk009856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:02 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N201tX009917
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:01 GMT
Subject: [PATCH 3/5] xfs: check for cow blocks before trying to clear them
 during inode reclaim
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:00:00 -0800
Message-ID: <151935120057.21654.6400354165591541565.stgit@magnolia>
In-Reply-To: <151935118240.21654.10146641674018880885.stgit@magnolia>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's no point in allocating a transaction and locking the inode in
preparation to clear cow blocks if there actually are any cow fork
extents.  Therefore, move the xfs_reflink_cancel_cow_range hunk to
xfs_inactive and check the cow ifp first.  This makes inode reclamation
run faster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    5 +++++
 fs/xfs/xfs_super.c |    9 ---------
 2 files changed, 5 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 604ee38..50fbbf5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1872,6 +1872,7 @@ xfs_inactive(
 	xfs_inode_t	*ip)
 {
 	struct xfs_mount	*mp;
+	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	int			error;
 	int			truncate = 0;
 
@@ -1892,6 +1893,10 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
+	/* Try to clean out the cow blocks if there are any. */
+	if (xfs_is_reflink_inode(ip) && cow_ifp->if_bytes > 0)
+		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
 		 * force is true because we are evicting an inode from the
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7aba628..624a802 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -970,7 +970,6 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			error;
 
 	trace_xfs_destroy_inode(ip);
 
@@ -978,14 +977,6 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
-	if (xfs_is_reflink_inode(ip)) {
-		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
-		if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
-			xfs_warn(ip->i_mount,
-"Error %d while evicting CoW blocks for inode %llu.",
-					error, ip->i_ino);
-	}
-
 	xfs_inactive(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);

