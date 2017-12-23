Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757143AbdLWBNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:13:24 -0500
Subject: [PATCH 12/20] xfs: refactor short form directory structure verifier
 function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:19 -0800
Message-ID: <151399129951.23543.14261903729702921948.stgit@magnolia>
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

Change the short form directory structure verifier function to return
the instruction pointer of a failing check or NULL if everything's ok.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_priv.h  |    2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   26 +++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.c |    5 ++---
 3 files changed, 16 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index a15ad7c..753aeee 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -129,7 +129,7 @@ extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
-extern int xfs_dir2_sf_verify(struct xfs_inode *ip);
+extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
 
 /* xfs_dir2_readdir.c */
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index be8b975..8500fa2 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -630,7 +630,7 @@ xfs_dir2_sf_check(
 #endif	/* DEBUG */
 
 /* Verify the consistency of an inline directory. */
-int
+xfs_failaddr_t
 xfs_dir2_sf_verify(
 	struct xfs_inode		*ip)
 {
@@ -665,7 +665,7 @@ xfs_dir2_sf_verify(
 	 */
 	if (size <= offsetof(struct xfs_dir2_sf_hdr, parent) ||
 	    size < xfs_dir2_sf_hdr_size(sfp->i8count))
-		return -EFSCORRUPTED;
+		return __this_address;
 
 	endp = (char *)sfp + size;
 
@@ -674,7 +674,7 @@ xfs_dir2_sf_verify(
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 	error = xfs_dir_ino_validate(mp, ino);
 	if (error)
-		return error;
+		return __this_address;
 	offset = dops->data_first_offset;
 
 	/* Check all reported entries */
@@ -686,11 +686,11 @@ xfs_dir2_sf_verify(
 		 * within the data buffer.
 		 */
 		if (((char *)sfep + sizeof(*sfep)) >= endp)
-			return -EFSCORRUPTED;
+			return __this_address;
 
 		/* Don't allow names with known bad length. */
 		if (sfep->namelen == 0)
-			return -EFSCORRUPTED;
+			return __this_address;
 
 		/*
 		 * Check that the variable-length part of the structure is
@@ -699,23 +699,23 @@ xfs_dir2_sf_verify(
 		 */
 		next_sfep = dops->sf_nextentry(sfp, sfep);
 		if (endp < (char *)next_sfep)
-			return -EFSCORRUPTED;
+			return __this_address;
 
 		/* Check that the offsets always increase. */
 		if (xfs_dir2_sf_get_offset(sfep) < offset)
-			return -EFSCORRUPTED;
+			return __this_address;
 
 		/* Check the inode number. */
 		ino = dops->sf_get_ino(sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		error = xfs_dir_ino_validate(mp, ino);
 		if (error)
-			return error;
+			return __this_address;
 
 		/* Check the file type. */
 		filetype = dops->sf_get_ftype(sfep);
 		if (filetype >= XFS_DIR3_FT_MAX)
-			return -EFSCORRUPTED;
+			return __this_address;
 
 		offset = xfs_dir2_sf_get_offset(sfep) +
 				dops->data_entsize(sfep->namelen);
@@ -723,16 +723,16 @@ xfs_dir2_sf_verify(
 		sfep = next_sfep;
 	}
 	if (i8count != sfp->i8count)
-		return -EFSCORRUPTED;
+		return __this_address;
 	if ((void *)sfep != (void *)endp)
-		return -EFSCORRUPTED;
+		return __this_address;
 
 	/* Make sure this whole thing ought to be in local format. */
 	if (offset + (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
 	    (uint)sizeof(xfs_dir2_block_tail_t) > mp->m_dir_geo->blksize)
-		return -EFSCORRUPTED;
+		return __this_address;
 
-	return 0;
+	return NULL;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index fd88cbe..a92395a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -99,10 +99,9 @@ xfs_iformat_fork(
 
 	/* Check inline dir contents. */
 	if (S_ISDIR(inode->i_mode) && dip->di_format == XFS_DINODE_FMT_LOCAL) {
-		error = xfs_dir2_sf_verify(ip);
-		if (error) {
+		if (xfs_dir2_sf_verify(ip)) {
 			xfs_idestroy_fork(ip, XFS_DATA_FORK);
-			return error;
+			return -EFSCORRUPTED;
 		}
 	}
 

