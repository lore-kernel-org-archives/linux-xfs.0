Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B89FC29DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:51 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5FC7304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:51 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UrCZ003604
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.294714180@sgi.com>
Date: Wed, 15 Jan 2014 16:00:14 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 02/17] xfs: (parent ptr) get offset when removing directory name
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=02-pptr-add-to_xfs_dir_removename.patch
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

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

---
 fs/xfs/xfs_dir2.c       |    5 ++++-
 fs/xfs/xfs_dir2.h       |    3 ++-
 fs/xfs/xfs_dir2_block.c |    1 +
 fs/xfs/xfs_dir2_leaf.c  |    1 +
 fs/xfs/xfs_dir2_node.c  |    1 +
 fs/xfs/xfs_dir2_sf.c    |    2 ++
 fs/xfs/xfs_inode.c      |    4 ++--
 7 files changed, 13 insertions(+), 4 deletions(-)

Index: b/fs/xfs/xfs_dir2.c
===================================================================
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -340,7 +340,8 @@ xfs_dir_removename(
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
-	xfs_extlen_t	total)		/* bmap's total block count */
+	xfs_extlen_t	total,		/* bmap's total block count */
+	__uint32_t	*offset)	/* out: return entry's dir offset */
 {
 	xfs_da_args_t	args;
 	int		rval;
@@ -374,6 +375,8 @@ xfs_dir_removename(
 		rval = xfs_dir2_leaf_removename(&args);
 	else
 		rval = xfs_dir2_node_removename(&args);
+	if (offset)
+		*offset = args.offset;
 	return rval;
 }
 
Index: b/fs/xfs/xfs_dir2.h
===================================================================
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -127,7 +127,8 @@ extern int xfs_dir_lookup(struct xfs_tra
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
-				struct xfs_bmap_free *flist, xfs_extlen_t tot);
+				struct xfs_bmap_free *flist, xfs_extlen_t tot,
+				__uint32_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
Index: b/fs/xfs/xfs_dir2_block.c
===================================================================
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -796,6 +796,7 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
Index: b/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1381,6 +1381,7 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &ents[index];
+	args->offset = be32_to_cpu(lep->address);
 	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
Index: b/fs/xfs/xfs_dir2_node.c
===================================================================
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1192,6 +1192,7 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 	ASSERT(dblk->blkno == db);
 	off = xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address));
Index: b/fs/xfs/xfs_dir2_sf.c
===================================================================
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -847,6 +847,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(dp->i_mount,
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2542,7 +2542,7 @@ xfs_remove(
 
 	xfs_bmap_init(&free_list, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &free_list, resblks);
+				     &first_block, &free_list, resblks, NULL);
 	if (error) {
 		ASSERT(error != ENOENT);
 		goto out_bmap_cancel;
@@ -2847,7 +2847,7 @@ xfs_rename(
 	}
 
 	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					&first_block, &free_list, spaceres);
+				     &first_block, &free_list, spaceres, NULL);
 	if (error)
 		goto abort_return;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
