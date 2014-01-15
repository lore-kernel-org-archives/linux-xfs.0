Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45FA429E38
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:55 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEE1FAC006
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:51 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0Ur8s003600
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.190452695@sgi.com>
Date: Wed, 15 Jan 2014 16:00:13 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 01/17] xfs: (parent ptr) get offset when adding directory name
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline;
	filename=01-pptr-retrieve-info-from-directory.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

---
 fs/xfs/xfs_da_btree.h   |    1 +
 fs/xfs/xfs_dir2.c       |    6 +++++-
 fs/xfs/xfs_dir2.h       |    3 ++-
 fs/xfs/xfs_dir2_block.c |    1 +
 fs/xfs/xfs_dir2_leaf.c  |    2 ++
 fs/xfs/xfs_dir2_node.c  |    2 ++
 fs/xfs/xfs_dir2_sf.c    |    2 ++
 fs/xfs/xfs_inode.c      |    7 ++++---
 fs/xfs/xfs_symlink.c    |    2 +-
 9 files changed, 20 insertions(+), 6 deletions(-)

Index: b/fs/xfs/xfs_da_btree.h
===================================================================
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -66,6 +66,7 @@ typedef struct xfs_da_args {
 	int		rmtblkcnt2;	/* remote attr value block count */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	__uint32_t	offset;		/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
Index: b/fs/xfs/xfs_dir2.c
===================================================================
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -203,7 +203,8 @@ xfs_dir_createname(
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	__uint32_t		*offset)	/* OUT entry's dir offset */
 {
 	xfs_da_args_t		args;
 	int			rval;
@@ -240,6 +241,9 @@ xfs_dir_createname(
 		rval = xfs_dir2_leaf_addname(&args);
 	else
 		rval = xfs_dir2_node_addname(&args);
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args.offset;
 	return rval;
 }
 
Index: b/fs/xfs/xfs_dir2.h
===================================================================
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -119,7 +119,8 @@ extern int xfs_dir_init(struct xfs_trans
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_bmap_free *flist, xfs_extlen_t tot);
+				struct xfs_bmap_free *flist, xfs_extlen_t tot,
+				 __uint32_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
Index: b/fs/xfs/xfs_dir2_block.c
===================================================================
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -554,6 +554,7 @@ xfs_dir2_block_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr(mp, (char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
Index: b/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -860,6 +860,8 @@ xfs_dir2_leaf_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(mp, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
Index: b/fs/xfs/xfs_dir2_node.c
===================================================================
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1973,6 +1973,8 @@ xfs_dir2_node_addname_int(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(mp, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
Index: b/fs/xfs/xfs_dir2_sf.c
===================================================================
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -425,6 +425,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(dp->i_mount, offset);
 
 	/*
 	 * Update the header and inode.
@@ -520,6 +521,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(dp->i_mount, offset);
 	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1264,7 +1264,8 @@ xfs_create(
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks ?
-					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
+					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
+					NULL);
 	if (error) {
 		ASSERT(error != ENOSPC);
 		goto out_trans_abort;
@@ -1402,7 +1403,7 @@ xfs_link(
 	xfs_bmap_init(&free_list, &first_block);
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-					&first_block, &free_list, resblks);
+				   &first_block, &free_list, resblks, NULL);
 	if (error)
 		goto abort_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2736,7 +2737,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
 						src_ip->i_ino, &first_block,
-						&free_list, spaceres);
+						&free_list, spaceres, NULL);
 		if (error == ENOSPC)
 			goto error_return;
 		if (error)
Index: b/fs/xfs/xfs_symlink.c
===================================================================
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -375,7 +375,7 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-					&first_block, &free_list, resblks);
+				   &first_block, &free_list, resblks, NULL);
 	if (error)
 		goto error2;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
