Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753661AbeFJFH3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57TBg141955
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:29 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecx94m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57Swk032681
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:29 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A57SSs000451
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:28 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 09/23] xfs: get directory offset when adding directory name
Date: Sat,  9 Jun 2018 22:04:54 -0700
Message-Id: <1528607108-11059-10-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Mark Tinguely <tinguely@sgi.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

[dchinner: forward ported and cleaned up]
[dchinner: no s-o-b from Mark]
[bfoster: rebased, use args->geo in dir code]
[achender: rebased, chaged __uint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 9 +++++----
 fs/xfs/xfs_symlink.c           | 2 +-
 9 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ae6de17..bce96d6 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -86,6 +86,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92f94e1..409a1e7 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -313,6 +314,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -559,7 +564,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0);
+	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 989e95a..c98a3ca 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -131,7 +131,8 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 875893d..9b7f173 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -559,6 +559,7 @@ xfs_dir2_block_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 50fc9c0..8ae2953 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -894,6 +894,8 @@ xfs_dir2_leaf_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 9df096c..4e544f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2041,6 +2041,8 @@ xfs_dir2_node_addname_int(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 0c75a7f..222ccf5 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -405,6 +405,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -496,6 +497,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2b70c8b..fc07b4f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1226,7 +1226,8 @@ xfs_create(
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &dfops, resblks ?
-					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
+					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
+					NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1462,7 +1463,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-					&first_block, &dfops, resblks);
+				   &first_block, &dfops, resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3040,8 +3041,8 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-						src_ip->i_ino, &first_block,
-						&dfops, spaceres);
+					   src_ip->i_ino, &first_block, &dfops,
+					   spaceres, NULL);
 		if (error)
 			goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5b66ac1..b1d3301 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -350,7 +350,7 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-					&first_block, &dfops, resblks);
+				   &first_block, &dfops, resblks, NULL);
 	if (error)
 		goto out_bmap_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.7.4

