Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E222129DF9
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:51 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3170304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:51 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UrIi003608
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.379767989@sgi.com>
Date: Wed, 15 Jan 2014 16:00:15 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 03/17] xfs: (parent ptr) get offset when replacing a directory
	name
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=03-pptr-add-to_xfs_dir_replace.patch
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

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

---
 fs/xfs/xfs_dir2.c       |    5 ++++-
 fs/xfs/xfs_dir2.h       |    3 ++-
 fs/xfs/xfs_dir2_block.c |    1 +
 fs/xfs/xfs_dir2_leaf.c  |    1 +
 fs/xfs/xfs_dir2_node.c  |    1 +
 fs/xfs/xfs_dir2_sf.c    |    3 +++
 fs/xfs/xfs_inode.c      |    8 ++++----
 7 files changed, 16 insertions(+), 6 deletions(-)

Index: b/fs/xfs/xfs_dir2.c
===================================================================
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -391,7 +391,8 @@ xfs_dir_replace(
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
-	xfs_extlen_t	total)		/* bmap's total block count */
+	xfs_extlen_t	total,		/* bmap's total block count */
+	__uint32_t	*offset)	/* out: return entry's dir offset */
 {
 	xfs_da_args_t	args;
 	int		rval;
@@ -427,6 +428,8 @@ xfs_dir_replace(
 		rval = xfs_dir2_leaf_replace(&args);
 	else
 		rval = xfs_dir2_node_replace(&args);
+	if (offset)
+		*offset = args.offset;
 	return rval;
 }
 
Index: b/fs/xfs/xfs_dir2.h
===================================================================
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -132,7 +132,8 @@ extern int xfs_dir_removename(struct xfs
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_bmap_free *flist, xfs_extlen_t tot);
+				struct xfs_bmap_free *flist, xfs_extlen_t tot,
+				__uint32_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, uint resblks);
 
Index: b/fs/xfs/xfs_dir2_block.c
===================================================================
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -872,6 +872,7 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
Index: b/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1515,6 +1515,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
Index: b/fs/xfs/xfs_dir2_node.c
===================================================================
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -2186,6 +2186,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(lep->address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(state->mp, be32_to_cpu(lep->address)));
Index: b/fs/xfs/xfs_dir2_sf.c
===================================================================
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -987,6 +987,9 @@ xfs_dir2_sf_replace(
 #endif
 				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 				dp->d_ops->sf_put_ftype(sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  dp->i_mount,
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2778,8 +2778,8 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino,
-					&first_block, &free_list, spaceres);
+					src_ip->i_ino, &first_block,
+					&free_list, spaceres, NULL);
 		if (error)
 			goto abort_return;
 
@@ -2813,8 +2813,8 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino,
-					&first_block, &free_list, spaceres);
+					target_dp->i_ino, &first_block,
+					&free_list, spaceres, NULL);
 		ASSERT(error != EEXIST);
 		if (error)
 			goto abort_return;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
