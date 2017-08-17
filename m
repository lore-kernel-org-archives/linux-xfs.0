Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27221 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbdHQXcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:32:10 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7HNW9bL028465
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNW9Ji008060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:09 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNW9qY016666
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:09 GMT
Subject: [PATCH 06/12] xfs: move inode fork verifiers to xfs_dinode_verify
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 17 Aug 2017 16:32:07 -0700
Message-ID: <150301272762.5851.8006461646236958104.stgit@magnolia>
In-Reply-To: <150301268960.5851.2513223883233763065.stgit@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Consolidate the fork size and format verifiers to xfs_dinode_verify so
that we can reject bad inodes earlier and in a single place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |   68 ++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_inode_fork.c |   99 ----------------------------------------
 2 files changed, 65 insertions(+), 102 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b2423a3..35d8605 100644
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0e80f34..bba45f1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -61,70 +61,11 @@ xfs_iformat_fork(
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
-	if (unlikely(xfs_is_reflink_inode(ip) &&
-	    (VFS_I(ip)->i_mode & S_IFMT) != S_IFREG)) {
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
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
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
 		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
 		break;
@@ -134,32 +75,7 @@ xfs_iformat_fork(
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
@@ -170,14 +86,11 @@ xfs_iformat_fork(
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
@@ -209,18 +122,6 @@ xfs_iformat_fork(
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
 
-		if (unlikely(size < sizeof(struct xfs_attr_sf_hdr))) {
-			xfs_warn(ip->i_mount,
-				"corrupt inode %Lu (bad attr fork size %Ld).",
-				(unsigned long long) ip->i_ino,
-				(long long) size);
-			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
-					     XFS_ERRLEVEL_LOW,
-					     ip->i_mount, dip);
-			error = -EFSCORRUPTED;
-			break;
-		}
-
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:

