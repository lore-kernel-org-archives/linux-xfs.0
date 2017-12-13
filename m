Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39292 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX6x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:58:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNl94a024431
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:53 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eudq605jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwqOl002497
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:52 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwqV3011977
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:52 GMT
Subject: [PATCH 06/13] xfs: move inode fork verifiers to xfs_dinode_verify
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:58:49 -0800
Message-ID: <151320952955.30654.5858027812526222455.stgit@magnolia>
In-Reply-To: <151320949282.30654.14805160700975182459.stgit@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Consolidate the fork size and format verifiers to xfs_dinode_verify so
that we can reject bad inodes earlier and in a single place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |   72 ++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_inode_fork.c |   86 ----------------------------------------
 2 files changed, 69 insertions(+), 89 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0e4c720..1392fe9 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -390,6 +390,7 @@ xfs_dinode_verify(
 	uint16_t		mode;
 	uint16_t		flags;
 	uint64_t		flags2;
+	uint64_t		di_size;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -408,7 +409,8 @@ xfs_dinode_verify(
 	}
 
 	/* don't allow invalid i_size */
-	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+	di_size = be64_to_cpu(dip->di_size);
+	if (di_size & (1ULL << 63))
 		return __this_address;
 
 	mode = be16_to_cpu(dip->di_mode);
@@ -416,14 +418,74 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	/* Fork checks carried over from xfs_iformat_fork */
+	if (mode &&
+	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
+	    be64_to_cpu(dip->di_nblocks))
+		return __this_address;
+
+	if (mode && dip->di_forkoff > mp->m_sb.sb_inodesize)
+		return __this_address;
+
+	flags = be16_to_cpu(dip->di_flags);
+
+	if (mode && (flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
+		return __this_address;
+
+	/* Do we have appropriate data fork formats for the mode? */
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		if (dip->di_format != XFS_DINODE_FMT_DEV)
+			return __this_address;
+		break;
+	case S_IFREG:
+	case S_IFLNK:
+	case S_IFDIR:
+		switch (dip->di_format) {
+		case XFS_DINODE_FMT_LOCAL:
+			/*
+			 * no local regular files yet
+			 */
+			if (S_ISREG(mode))
+				return __this_address;
+			if (di_size > XFS_DFORK_DSIZE(dip, mp))
+				return __this_address;
+			/* fall through */
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			break;
+		default:
+			return __this_address;
+		}
+		break;
+	case 0:
+		/* Uninitialized inode ok. */
+		break;
+	default:
+		return __this_address;
+	}
+
+	if (XFS_DFORK_Q(dip)) {
+		switch (dip->di_aformat) {
+		case XFS_DINODE_FMT_LOCAL:
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			break;
+		default:
+			return __this_address;
+		}
+	}
+
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
 		return NULL;
 
-	flags = be16_to_cpu(dip->di_flags);
 	flags2 = be64_to_cpu(dip->di_flags2);
 
 	/* don't allow reflink/cowextsize if we don't have reflink */
@@ -431,6 +493,10 @@ xfs_dinode_verify(
             !xfs_sb_version_hasreflink(&mp->m_sb))
 		return __this_address;
 
+	/* only regular files get reflink */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (mode & S_IFMT) != S_IFREG)
+		return __this_address;
+
 	/* don't let reflink and realtime mix */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c79a161..fd88cbe 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -62,69 +62,11 @@ xfs_iformat_fork(
 	int			error = 0;
 	xfs_fsize_t             di_size;
 
-	if (unlikely(be32_to_cpu(dip->di_nextents) +
-		     be16_to_cpu(dip->di_anextents) >
-		     be64_to_cpu(dip->di_nblocks))) {
-		xfs_warn(ip->i_mount,
-			"corrupt dinode %Lu, extent total = %d, nblocks = %Lu.",
-			(unsigned long long)ip->i_ino,
-			(int)(be32_to_cpu(dip->di_nextents) +
-			      be16_to_cpu(dip->di_anextents)),
-			(unsigned long long)
-				be64_to_cpu(dip->di_nblocks));
-		XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
-				     ip->i_mount, dip);
-		return -EFSCORRUPTED;
-	}
-
-	if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
-		xfs_warn(ip->i_mount, "corrupt dinode %Lu, forkoff = 0x%x.",
-			(unsigned long long)ip->i_ino,
-			dip->di_forkoff);
-		XFS_CORRUPTION_ERROR("xfs_iformat(2)", XFS_ERRLEVEL_LOW,
-				     ip->i_mount, dip);
-		return -EFSCORRUPTED;
-	}
-
-	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
-		     !ip->i_mount->m_rtdev_targp)) {
-		xfs_warn(ip->i_mount,
-			"corrupt dinode %Lu, has realtime flag set.",
-			ip->i_ino);
-		XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
-				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
-		return -EFSCORRUPTED;
-	}
-
-	if (unlikely(xfs_is_reflink_inode(ip) && !S_ISREG(inode->i_mode))) {
-		xfs_warn(ip->i_mount,
-			"corrupt dinode %llu, wrong file type for reflink.",
-			ip->i_ino);
-		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
-				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
-		return -EFSCORRUPTED;
-	}
-
-	if (unlikely(xfs_is_reflink_inode(ip) &&
-	    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME))) {
-		xfs_warn(ip->i_mount,
-			"corrupt dinode %llu, has reflink+realtime flag set.",
-			ip->i_ino);
-		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
-				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
-		return -EFSCORRUPTED;
-	}
-
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		if (unlikely(dip->di_format != XFS_DINODE_FMT_DEV)) {
-			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
-					      ip->i_mount, dip);
-			return -EFSCORRUPTED;
-		}
 		ip->i_d.di_size = 0;
 		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
 		break;
@@ -134,32 +76,7 @@ xfs_iformat_fork(
 	case S_IFDIR:
 		switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			/*
-			 * no local regular files yet
-			 */
-			if (unlikely(S_ISREG(be16_to_cpu(dip->di_mode)))) {
-				xfs_warn(ip->i_mount,
-			"corrupt inode %Lu (local format for regular file).",
-					(unsigned long long) ip->i_ino);
-				XFS_CORRUPTION_ERROR("xfs_iformat(4)",
-						     XFS_ERRLEVEL_LOW,
-						     ip->i_mount, dip);
-				return -EFSCORRUPTED;
-			}
-
 			di_size = be64_to_cpu(dip->di_size);
-			if (unlikely(di_size < 0 ||
-				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
-				xfs_warn(ip->i_mount,
-			"corrupt inode %Lu (bad size %Ld for local inode).",
-					(unsigned long long) ip->i_ino,
-					(long long) di_size);
-				XFS_CORRUPTION_ERROR("xfs_iformat(5)",
-						     XFS_ERRLEVEL_LOW,
-						     ip->i_mount, dip);
-				return -EFSCORRUPTED;
-			}
-
 			size = (int)di_size;
 			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK, size);
 			break;
@@ -170,14 +87,11 @@ xfs_iformat_fork(
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
 		default:
-			XFS_ERROR_REPORT("xfs_iformat(6)", XFS_ERRLEVEL_LOW,
-					 ip->i_mount);
 			return -EFSCORRUPTED;
 		}
 		break;
 
 	default:
-		XFS_ERROR_REPORT("xfs_iformat(7)", XFS_ERRLEVEL_LOW, ip->i_mount);
 		return -EFSCORRUPTED;
 	}
 	if (error)

