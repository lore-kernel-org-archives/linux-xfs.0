Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbeFJFKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57xxD095387
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:11 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2jg7hwstcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:11 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AAKY004755
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:10 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5AAQg001472
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:10 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 10/27] xfsprogs: get directory offset when removing directory name
Date: Sat,  9 Jun 2018 22:07:35 -0700
Message-Id: <1528607272-11122-11-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
       Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_dir2.c       | 16 ++++++++++------
 libxfs/xfs_dir2.h       |  4 +++-
 libxfs/xfs_dir2_block.c |  4 ++--
 libxfs/xfs_dir2_leaf.c  |  5 +++--
 libxfs/xfs_dir2_node.c  |  5 +++--
 libxfs/xfs_dir2_sf.c    |  2 ++
 6 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index cd67e1b..ef9fba6 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -431,13 +431,14 @@ out_free:
  */
 int
 xfs_dir_removename(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	struct xfs_name	*name,
-	xfs_ino_t	ino,
-	xfs_fsblock_t	*first,		/* bmap's firstblock */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
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
@@ -484,6 +485,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 378c654..e2cd70b 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -139,7 +139,9 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops,
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 4815d26..e7ce6a9 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -788,9 +788,9 @@ xfs_dir2_block_removename(
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
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 949e798..8cca19e 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1407,9 +1407,10 @@ xfs_dir2_leaf_removename(
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
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 697e37e..e4ca481 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1248,9 +1248,10 @@ xfs_dir2_leafn_remove(
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
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index e601208..8013ddd 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -915,6 +915,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
-- 
2.7.4

