Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeH1XSD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJKGL097513
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:58 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2m2xhtnxrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOvxY011623
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:57 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7SJOvQW003045
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:57 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 16/28] xfs: get directory offset when replacing a directory name
Date: Tue, 28 Aug 2018 12:22:29 -0700
Message-Id: <1535484161-11059-17-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Mark Tinguely <tinguely@sgi.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
	   Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 14 +++++++-------
 7 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f5475e7..7d8c63b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -468,7 +468,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -484,7 +484,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -532,6 +533,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 2cf1d87..63de5b9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -127,7 +127,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index aa84c45..a327d81 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -860,9 +860,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 5e68c39..1ef74572 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1538,6 +1538,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 3c1698f..9cbe012 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(lep->address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index e65615c..ea5b63b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1031,6 +1031,8 @@ xfs_dir2_sf_replace(
 				ASSERT(args->inumber != ino);
 				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 				dp->d_ops->sf_put_ftype(sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 67a5437..d7e06c2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2737,12 +2737,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2756,7 +2756,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2782,7 +2782,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3023,7 +3023,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3057,7 +3057,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3096,7 +3096,7 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.7.4
