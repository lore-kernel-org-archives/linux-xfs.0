Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 57FEA7F66
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49B6D8F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:14 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Ku5TaAQnXiF20zOH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:12 -0800 (PST)
Subject: [PATCH 52/76] xfs: don't allow reflinked dir/dev/fifo/socket/pipe
	files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:02:09 -0800
Message-ID: <20151219090209.12713.95178.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Only non-rt files can be reflinked, so check that when we load an
inode.  Also, don't leak the attr fork if there's a failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 46ea657..bbdee05 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -121,6 +121,26 @@ xfs_iformat_fork(
 		return -EFSCORRUPTED;
 	}
 
+	if (unlikely(xfs_is_reflink_inode(ip) &&
+	    (ip->i_d.di_mode & S_IFMT) != S_IFREG)) {
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
 	switch (ip->i_d.di_mode & S_IFMT) {
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
