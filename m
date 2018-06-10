Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753713AbeFJFKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A59DqB096056
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:13 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2jg7hwstd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AC7p004530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:12 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5ACoE013967
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:12 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 11/27] xfsprogs: get directory offset when replacing a directory name
Date: Sat,  9 Jun 2018 22:07:36 -0700
Message-Id: <1528607272-11122-12-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
       Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_dir2.c       | 18 +++++++++++-------
 libxfs/xfs_dir2.h       |  3 ++-
 libxfs/xfs_dir2_block.c |  4 ++--
 libxfs/xfs_dir2_leaf.c  |  1 +
 libxfs/xfs_dir2_node.c  |  1 +
 libxfs/xfs_dir2_sf.c    |  2 ++
 repair/phase6.c         |  2 +-
 7 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index ef9fba6..db7c697 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -485,7 +485,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -497,13 +497,14 @@ out_free:
  */
 int
 xfs_dir_replace(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	struct xfs_name	*name,		/* name of entry to replace */
-	xfs_ino_t	inum,		/* new inode number */
-	xfs_fsblock_t	*first,		/* bmap's firstblock */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
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
@@ -553,6 +554,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index e2cd70b..cb6fda0 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -145,7 +145,8 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index e7ce6a9..34d6a0d 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -862,9 +862,9 @@ xfs_dir2_block_replace(
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
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 8cca19e..ee16fc4 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1542,6 +1542,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index e4ca481..e604b1c 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2247,6 +2247,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(lep->address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 8013ddd..11561a9 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -1041,6 +1041,8 @@ xfs_dir2_sf_replace(
 				ASSERT(args->inumber != ino);
 				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 				dp->d_ops->sf_put_ftype(sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index b41cc2b..4fedb35 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1233,7 +1233,7 @@ mv_orphanage(
 			if (entry_ino_num != orphanage_ino)  {
 				err = -libxfs_dir_replace(tp, ino_p,
 						&xfs_name_dotdot, orphanage_ino,
-						&first, &dfops, nres);
+						&first, &dfops, nres, NULL);
 				if (err)
 					do_error(
 	_("name replace op failed (%d), filesystem may be out of space\n"),
-- 
2.7.4

