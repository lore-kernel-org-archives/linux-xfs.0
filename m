Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22921 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdHJBns (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:48 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1hlwg010041
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hl2o017671
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:47 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hl08017047
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:47 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 02/13] xfs: get directory offset when removing directory name
Date: Wed,  9 Aug 2017 18:41:22 -0700
Message-Id: <1502329293-4091-3-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Mark Tinguely <tinguely@sgi.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 a1ca460... a34956e... M	fs/xfs/libxfs/xfs_dir2.c
:100644 100644 e349900... ee98b2a... M	fs/xfs/libxfs/xfs_dir2.h
:100644 100644 79684d5... 4dbe2fc... M	fs/xfs/libxfs/xfs_dir2_block.c
:100644 100644 2ac7a7e... 197e627... M	fs/xfs/libxfs/xfs_dir2_leaf.c
:100644 100644 8bc91f8... 13d5244... M	fs/xfs/libxfs/xfs_dir2_node.c
:100644 100644 489bdef... 9e90c22... M	fs/xfs/libxfs/xfs_dir2_sf.c
:100644 100644 cea1c56... f58f62a... M	fs/xfs/xfs_inode.c
 fs/xfs/libxfs/xfs_dir2.c       | 15 +++++++++------
 fs/xfs/libxfs/xfs_dir2.h       |  3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  |  5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             |  7 ++++---
 7 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index a1ca460..a34956e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -443,13 +443,14 @@ xfs_dir_lookup(
  */
 int
 xfs_dir_removename(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	struct xfs_name	*name,
-	xfs_ino_t	ino,
-	xfs_fsblock_t	*first,		/* bmap's firstblock */
+	xfs_trans_t		*tp,
+	xfs_inode_t		*dp,
+	struct xfs_name		*name,
+	xfs_ino_t		ino,
+	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
-	xfs_extlen_t	total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args *args;
 	int		rval;
@@ -495,6 +496,8 @@ xfs_dir_removename(
 		rval = xfs_dir2_leaf_removename(args);
 	else
 		rval = xfs_dir2_node_removename(args);
+	if (offset)
+		*offset = args->offset;
 out_free:
 	kmem_free(args);
 	return rval;
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e349900..ee98b2a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -139,7 +139,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 79684d5..4dbe2fc 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -791,9 +791,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 2ac7a7e..197e627 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1383,9 +1383,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &ents[index];
-	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 8bc91f8..13d5244 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1238,9 +1238,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 489bdef..9e90c22 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -919,6 +919,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cea1c56..f58f62a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2621,8 +2621,8 @@ xfs_remove(
 		goto out_trans_cancel;
 
 	xfs_defer_init(&dfops, &first_block);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &dfops, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
+				   &dfops, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
@@ -3132,7 +3132,8 @@ xfs_rename(
 					&first_block, &dfops, spaceres);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   &first_block, &dfops, spaceres);
+					   &first_block, &dfops, spaceres,
+					   NULL);
 	if (error)
 		goto out_bmap_cancel;
 
-- 
2.7.4

