Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42275 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1SR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:17:28 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIHR5L011095
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIHR1g017297
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:27 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7SIHRLp008363
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:27 GMT
Subject: [PATCH 09/12] xfs: refactor short form directory structure verifier
 function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:17:26 -0700
Message-ID: <150394424657.24826.12376055044684964616.stgit@magnolia>
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the short form directory structure verifier function to return
the instruction pointer of a failing check or NULL if everything's ok.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_priv.h  |    2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   26 +++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.c |    5 ++---
 3 files changed, 16 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index d1a441f..0f19489 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -133,7 +133,7 @@ extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
-extern int xfs_dir2_sf_verify(struct xfs_inode *ip);
+extern void *xfs_dir2_sf_verify(struct xfs_inode *ip);
 
 /* xfs_dir2_readdir.c */
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index be8b975..b4d31cb 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -630,7 +630,7 @@ xfs_dir2_sf_check(
 #endif	/* DEBUG */
 
 /* Verify the consistency of an inline directory. */
-int
+void *
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
index bba45f1..43213d5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -99,10 +99,9 @@ xfs_iformat_fork(
 	/* Check inline dir contents. */
 	if (S_ISDIR(VFS_I(ip)->i_mode) &&
 	    dip->di_format == XFS_DINODE_FMT_LOCAL) {
-		error = xfs_dir2_sf_verify(ip);
-		if (error) {
+		if (xfs_dir2_sf_verify(ip)) {
 			xfs_idestroy_fork(ip, XFS_DATA_FORK);
-			return error;
+			return -EFSCORRUPTED;
 		}
 	}
 

