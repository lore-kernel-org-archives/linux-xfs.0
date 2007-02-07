Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 21:06:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1755w3c024523
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 21:06:01 -0800
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 5C37018003EF5
	for <xfs@oss.sgi.com>; Tue,  6 Feb 2007 23:05:58 -0600 (CST)
Message-ID: <45C95E36.7020200@sandeen.net>
Date: Tue, 06 Feb 2007 23:05:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove more misc. unused args
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

more misc. unused args

 xfs_bmap.c        |   10 +++-------
 xfs_log_recover.c |    8 +++-----
 xfs_vnodeops.c    |    5 ++---
 3 files changed, 8 insertions(+), 15 deletions(-)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_bmap.c
===================================================================
--- linux/fs/xfs.orig/xfs_bmap.c
+++ linux/fs/xfs/xfs_bmap.c
@@ -130,7 +130,6 @@ STATIC int				/* error */
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp,/* inode logging flags */
 	xfs_extdelta_t		*delta, /* Change made to incore extents */
@@ -399,7 +398,6 @@ xfs_bmap_count_leaves(
 
 STATIC int
 xfs_bmap_disk_count_leaves(
-	xfs_ifork_t		*ifp,
 	xfs_extnum_t		idx,
 	xfs_bmbt_block_t	*block,
 	int			numrecs,
@@ -580,7 +578,7 @@ xfs_bmap_add_extent(
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
-		if ((error = xfs_bmap_add_extent_hole_delay(ip, idx, cur, new,
+		if ((error = xfs_bmap_add_extent_hole_delay(ip, idx, new,
 				&logflags, delta, rsvd)))
 			goto done;
 	}
@@ -1841,7 +1839,6 @@ STATIC int				/* error */
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
 	xfs_extdelta_t		*delta, /* Change made to incore extents */
@@ -6425,8 +6422,8 @@ xfs_bmap_count_tree(
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
-			if (unlikely(xfs_bmap_disk_count_leaves(ifp,
-					0, block, numrecs, count) < 0)) {
+			if (unlikely(xfs_bmap_disk_count_leaves(0,
+					block, numrecs, count) < 0)) {
 				xfs_trans_brelse(tp, bp);
 				XFS_ERROR_REPORT("xfs_bmap_count_tree(2)",
 						 XFS_ERRLEVEL_LOW, mp);
@@ -6472,7 +6469,6 @@ xfs_bmap_count_leaves(
  */
 int
 xfs_bmap_disk_count_leaves(
-	xfs_ifork_t		*ifp,
 	xfs_extnum_t		idx,
 	xfs_bmbt_block_t	*block,
 	int			numrecs,
Index: linux/fs/xfs/xfs_log_recover.c
===================================================================
--- linux/fs/xfs.orig/xfs_log_recover.c
+++ linux/fs/xfs/xfs_log_recover.c
@@ -1509,7 +1509,6 @@ xlog_recover_insert_item_frontq(
 
 STATIC int
 xlog_recover_reorder_trans(
-	xlog_t			*log,
 	xlog_recover_t		*trans)
 {
 	xlog_recover_item_t	*first_item, *itemq, *itemq_next;
@@ -1867,7 +1866,6 @@ xlog_recover_do_inode_buffer(
 /*ARGSUSED*/
 STATIC void
 xlog_recover_do_reg_buffer(
-	xfs_mount_t		*mp,
 	xlog_recover_item_t	*item,
 	xfs_buf_t		*bp,
 	xfs_buf_log_format_t	*buf_f)
@@ -2083,7 +2081,7 @@ xlog_recover_do_dquot_buffer(
 	if (log->l_quotaoffs_flag & type)
 		return;
 
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
+	xlog_recover_do_reg_buffer(item, bp, buf_f);
 }
 
 /*
@@ -2184,7 +2182,7 @@ xlog_recover_do_buffer_trans(
 		  (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
 		xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 	} else {
-		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
+		xlog_recover_do_reg_buffer(item, bp, buf_f);
 	}
 	if (error)
 		return XFS_ERROR(error);
@@ -2765,7 +2763,7 @@ xlog_recover_do_trans(
 	int			error = 0;
 	xlog_recover_item_t	*item, *first_item;
 
-	if ((error = xlog_recover_reorder_trans(log, trans)))
+	if ((error = xlog_recover_reorder_trans(trans)))
 		return error;
 	first_item = item = trans->r_itemq;
 	do {
Index: linux/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux/fs/xfs.orig/xfs_vnodeops.c
+++ linux/fs/xfs/xfs_vnodeops.c
@@ -2120,7 +2120,6 @@ int xfs_rm_attempts;
 STATIC int
 xfs_lock_dir_and_entry(
 	xfs_inode_t	*dp,
-	bhv_vname_t	*dentry,
 	xfs_inode_t	*ip)	/* inode of entry 'name' */
 {
 	int		attempts;
@@ -2439,7 +2438,7 @@ xfs_remove(
 		return error;
 	}
 
-	error = xfs_lock_dir_and_entry(dp, dentry, ip);
+	error = xfs_lock_dir_and_entry(dp, ip);
 	if (error) {
 		REMOVE_DEBUG_TRACE(__LINE__);
 		xfs_trans_cancel(tp, cancel_flags);
@@ -3095,7 +3094,7 @@ xfs_rmdir(
 	 * that the directory entry for the child directory inode has
 	 * not changed while we were obtaining a log reservation.
 	 */
-	error = xfs_lock_dir_and_entry(dp, dentry, cdp);
+	error = xfs_lock_dir_and_entry(dp, cdp);
 	if (error) {
 		xfs_trans_cancel(tp, cancel_flags);
 		IRELE(cdp);
