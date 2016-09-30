Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48794 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932928AbcI3DIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:47 -0400
Subject: [PATCH 28/63] xfs: don't allow reflinked dir/dev/fifo/socket/pipe
 files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:08:42 -0700
Message-ID: <147520492235.29434.5736614103531299436.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Only non-rt files can be reflinked, so check that when we load an
inode.  Also, don't leak the attr fork if there's a failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bbcc8c7..7699a03 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -121,6 +121,26 @@ xfs_iformat_fork(
 		return -EFSCORRUPTED;
 	}
 
+	if (unlikely(xfs_is_reflink_inode(ip) &&
+	    (VFS_I(ip)->i_mode & S_IFMT) != S_IFREG)) {
+		xfs_warn(ip->i_mount,
+			"corrupt dinode %llu, wrong file type for reflink.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return -EFSCORRUPTED;
+	}
+
+	if (unlikely(xfs_is_reflink_inode(ip) &&
+	    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME))) {
+		xfs_warn(ip->i_mount,
+			"corrupt dinode %llu, has reflink+realtime flag set.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return -EFSCORRUPTED;
+	}
+
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
@@ -208,7 +228,8 @@ xfs_iformat_fork(
 			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
 					     XFS_ERRLEVEL_LOW,
 					     ip->i_mount, dip);
-			return -EFSCORRUPTED;
+			error = -EFSCORRUPTED;
+			break;
 		}
 
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);

