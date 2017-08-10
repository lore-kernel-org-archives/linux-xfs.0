Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22923 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdHJBnt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:49 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1hmh0010065
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hm1n028967
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:48 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hmbo017085
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:48 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 03/13] xfs: get directory offset when replacing a directory name
Date: Wed,  9 Aug 2017 18:41:23 -0700
Message-Id: <1502329293-4091-4-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Mark Tinguely <tinguely@sgi.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 a34956e... f5d0d3d... M	fs/xfs/libxfs/xfs_dir2.c
:100644 100644 ee98b2a... 67ce660... M	fs/xfs/libxfs/xfs_dir2.h
:100644 100644 4dbe2fc... 69dfe64... M	fs/xfs/libxfs/xfs_dir2_block.c
:100644 100644 197e627... 770b93f... M	fs/xfs/libxfs/xfs_dir2_leaf.c
:100644 100644 13d5244... 860a612... M	fs/xfs/libxfs/xfs_dir2_node.c
:100644 100644 9e90c22... 295458f... M	fs/xfs/libxfs/xfs_dir2_sf.c
:100644 100644 f58f62a... 52c331e... M	fs/xfs/xfs_inode.c
 fs/xfs/libxfs/xfs_dir2.c       | 16 ++++++++++------
 fs/xfs/libxfs/xfs_dir2.h       |  3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 28 +++++++++++++---------------
 7 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index a34956e..f5d0d3d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -508,13 +508,14 @@ xfs_dir_removename(
  */
 int
 xfs_dir_replace(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	struct xfs_name	*name,		/* name of entry to replace */
-	xfs_ino_t	inum,		/* new inode number */
-	xfs_fsblock_t	*first,		/* bmap's firstblock */
+	xfs_trans_t		*tp,
+	xfs_inode_t		*dp,
+	struct xfs_name		*name,		/* name of entry to replace */
+	xfs_ino_t		inum,		/* new inode number */
+	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
-	xfs_extlen_t	total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args *args;
 	int		rval;
@@ -563,6 +564,9 @@ xfs_dir_replace(
 		rval = xfs_dir2_leaf_replace(args);
 	else
 		rval = xfs_dir2_node_replace(args);
+
+	if (offset)
+		*offset = args->offset;
 out_free:
 	kmem_free(args);
 	return rval;
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ee98b2a..67ce660 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -144,7 +144,8 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4dbe2fc..69dfe64 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -865,9 +865,9 @@ xfs_dir2_block_replace(
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
index 197e627..770b93f 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1518,6 +1518,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 13d5244..860a612 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2237,6 +2237,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(lep->address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 9e90c22..295458f 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1045,6 +1045,8 @@ xfs_dir2_sf_replace(
 				ASSERT(args->inumber != ino);
 				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 				dp->d_ops->sf_put_ftype(sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f58f62a..52c331e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2756,16 +2756,14 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1,
-				ip2->i_ino,
-				first_block, dfops, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, first_block, dfops,
+				spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2,
-				ip1->i_ino,
-				first_block, dfops, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, first_block, dfops,
+				spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2779,8 +2777,8 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, first_block,
-						dfops, spaceres);
+						dp1->i_ino, first_block, dfops,
+						spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2806,8 +2804,8 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, first_block,
-						dfops, spaceres);
+						dp2->i_ino, first_block, dfops,
+						spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3054,8 +3052,8 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino,
-					&first_block, &dfops, spaceres);
+					src_ip->i_ino, &first_block, &dfops,
+					spaceres, NULL);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3089,8 +3087,8 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino,
-					&first_block, &dfops, spaceres);
+					target_dp->i_ino, &first_block, &dfops,
+					spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_bmap_cancel;
@@ -3129,7 +3127,7 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					&first_block, &dfops, spaceres);
+					&first_block, &dfops, spaceres, NULL);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   &first_block, &dfops, spaceres,
-- 
2.7.4

