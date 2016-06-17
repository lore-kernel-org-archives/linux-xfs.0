Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 171647E64
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:26:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC7BD304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:05 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id r9HBTDyRdw3bwoTh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:04 -0700 (PDT)
Subject: [PATCH 076/119] xfs: don't allow reflinked dir/dev/fifo/socket/pipe
	files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:25:59 -0700
Message-ID: <146612675894.12839.15938070770878804836.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
