Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36196 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbdLWBIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:08:06 -0500
Subject: [PATCH 09/20] xfs: move inode fork verifiers to xfs_dinode_verify
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:01 -0800
Message-ID: <151399128100.23543.15576803737498651380.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Consolidate the fork size and format verifiers to xfs_dinode_verify so
that we can reject bad inodes earlier and in a single place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |   72 ++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_inode_fork.c |   86 ----------------------------------------
 2 files changed, 69 insertions(+), 89 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a1ba112..4035b5d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -389,6 +389,7 @@ xfs_dinode_verify(
 	uint16_t		mode;
 	uint16_t		flags;
 	uint64_t		flags2;
+	uint64_t		di_size;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -407,7 +408,8 @@ xfs_dinode_verify(
 	}
 
 	/* don't allow invalid i_size */
-	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+	di_size = be64_to_cpu(dip->di_size);
+	if (di_size & (1ULL << 63))
 		return __this_address;
 
 	mode = be16_to_cpu(dip->di_mode);
@@ -415,14 +417,74 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	/* Fork checks carried over from xfs_iformat_fork */
+	if (mode &&
+	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
+			be64_to_cpu(dip->di_nblocks))
+		return __this_address;
+
+	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
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
@@ -430,6 +492,10 @@ xfs_dinode_verify(
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

