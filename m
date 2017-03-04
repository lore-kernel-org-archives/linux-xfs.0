Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30194 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbdCDAGT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 19:06:19 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2405YOM015444
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 4 Mar 2017 00:05:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v2405YJl002031
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 4 Mar 2017 00:05:34 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v2405UJC000607
        for <linux-xfs@vger.kernel.org>; Sat, 4 Mar 2017 00:05:32 GMT
Date: Fri, 3 Mar 2017 16:05:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: allow zero-length symlinks (and directories), sort of
Message-ID: <20170304000529.GB5073@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

In commit ef388e2054 ("don't allow di_size with high bit set") and
commit 3c6f46eacd87 ("sanity check directory inode di_size") we
erroneously fail the inode verification checks for symlinks or
directories with di_size == 0.

This is proven incorrect by generic/388 because the unlink process uses
multiple unconnected transactions to truncate the remote symlink /
directory and to unlink and free the inode.  If the fs goes down after
the truncate commit but before the unlink happens, we are left with a
zero-length inode.  Worse yet, if the unlink /does/ commit, log recovery
will now break after the first transaction because we've zeroed di_size.

In order to prevent the crashes and ASSERTs that the old patches
covered, re-allow the zero-length inodes and change the functions that
interface with the vfs to return the appropriate error codes to
userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    4 ----
 fs/xfs/xfs_dir2_readdir.c     |    6 ++----
 fs/xfs/xfs_iops.c             |    9 ++++++++-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3752bac..6e62999 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -402,10 +402,6 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return false;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
-		return false;
-
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
 		return true;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0b3b636..be1367a 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -74,10 +74,8 @@ xfs_dir2_sf_getdents(
 	/*
 	 * Give up if the directory is way too short.
 	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return -EIO;
-	}
+	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent))
+		return -EFSCORRUPTED;
 
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 22c1615..b7b6807 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -457,6 +457,9 @@ xfs_vn_get_link(
 	char			*link;
 	int			error = -ENOMEM;
 
+	if (i_size_read(inode) == 0)
+		return ERR_PTR(-EFSCORRUPTED);
+
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
@@ -483,8 +486,12 @@ xfs_vn_get_link_inline(
 	struct inode		*inode,
 	struct delayed_call	*done)
 {
+	char			*p;
 	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
-	return XFS_I(inode)->i_df.if_u1.if_data;
+	p = XFS_I(inode)->i_df.if_u1.if_data;
+	if (p)
+		return p;
+	return ERR_PTR(-EFSCORRUPTED);
 }
 
 STATIC int
