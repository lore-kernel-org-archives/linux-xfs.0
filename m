Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 13:52:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBLLq8qw013814
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 13:52:09 -0800
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kBLLpG38011266
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:51:16 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kBLLpBGB024736
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:51:11 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kBLLpAXV003221
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:51:10 -0500
Message-ID: <458B01CE.1070304@sandeen.net>
Date: Thu, 21 Dec 2006 15:51:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove unused "firstblock" arg from xfs_bmap_finish()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The firstblock argument to xfs_bmap_finish doesn't seem to have ever been used; 
I figure maybe taking it out clarifies things a tiny bit, and maybe helps the 
stack situation.

 quota/xfs_dquot.c |    2 +-
 xfs_attr.c        |   18 +++++++-----------
 xfs_bmap.c        |    3 +--
 xfs_bmap.h        |    1 -
 xfs_inode.c       |    3 +--
 xfs_iomap.c       |    8 +++-----
 xfs_rename.c      |    2 +-
 xfs_rtalloc.c     |    2 +-
 xfs_vnodeops.c    |   21 ++++++++++-----------
 9 files changed, 25 insertions(+), 35 deletions(-)

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux-allpatches/quota/xfs_dquot.c
===================================================================
--- xfs-linux-allpatches.orig/quota/xfs_dquot.c
+++ xfs-linux-allpatches/quota/xfs_dquot.c
@@ -484,7 +484,7 @@ xfs_qm_dqalloc(
 
 	xfs_trans_bhold(tp, bp);
 
-	if ((error = xfs_bmap_finish(tpp, &flist, firstblock, &committed))) {
+	if ((error = xfs_bmap_finish(tpp, &flist, &committed))) {
 		goto error1;
 	}
 
Index: xfs-linux-allpatches/xfs_attr.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_attr.c
+++ xfs-linux-allpatches/xfs_attr.c
@@ -349,7 +349,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const 
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
 			error = xfs_bmap_finish(&args.trans, args.flist,
-						*args.firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -976,7 +976,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 		error = xfs_attr_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						*args->firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1077,7 +1077,6 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							*args->firstblock,
 							&committed);
 			}
 			if (error) {
@@ -1155,7 +1154,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						*args->firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1310,7 +1309,6 @@ restart:
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							*args->firstblock,
 							&committed);
 			}
 			if (error) {
@@ -1350,7 +1348,7 @@ restart:
 		error = xfs_da_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						*args->firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1462,7 +1460,6 @@ restart:
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							*args->firstblock,
 							&committed);
 			}
 			if (error) {
@@ -1597,7 +1594,7 @@ xfs_attr_node_removename(xfs_da_args_t *
 		error = xfs_da_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						*args->firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1649,7 +1646,6 @@ xfs_attr_node_removename(xfs_da_args_t *
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							*args->firstblock,
 							&committed);
 			}
 			if (error) {
@@ -2093,7 +2089,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 				  args->flist, NULL);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						*args->firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -2249,7 +2245,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 				    NULL, &done);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						*args->firstblock, &committed);
+						&committed);
 		}
 		if (error) {
 			ASSERT(committed);
Index: xfs-linux-allpatches/xfs_bmap.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_bmap.c
+++ xfs-linux-allpatches/xfs_bmap.c
@@ -4080,7 +4080,7 @@ xfs_bmap_add_attrfork(
 		} else
 			XFS_SB_UNLOCK(mp, s);
 	}
-	if ((error = xfs_bmap_finish(&tp, &flist, firstblock, &committed)))
+	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
 		goto error2;
 	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES, NULL);
 	ASSERT(ip->i_df.if_ext_max ==
@@ -4213,7 +4213,6 @@ int						/* error */
 xfs_bmap_finish(
 	xfs_trans_t		**tp,		/* transaction pointer addr */
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_fsblock_t		firstblock,	/* controlled ag for allocs */
 	int			*committed)	/* xact committed or not */
 {
 	xfs_efd_log_item_t	*efd;		/* extent free data */
Index: xfs-linux-allpatches/xfs_bmap.h
===================================================================
--- xfs-linux-allpatches.orig/xfs_bmap.h
+++ xfs-linux-allpatches/xfs_bmap.h
@@ -202,7 +202,6 @@ int						/* error */
 xfs_bmap_finish(
 	struct xfs_trans	**tp,		/* transaction pointer addr */
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_fsblock_t		firstblock,	/* controlled a.g. for allocs */
 	int			*committed);	/* xact committed or not */
 
 /*
Index: xfs-linux-allpatches/xfs_inode.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_inode.c
+++ xfs-linux-allpatches/xfs_inode.c
@@ -1699,8 +1699,7 @@ xfs_itruncate_finish(
 		 * Duplicate the transaction that has the permanent
 		 * reservation and commit the old transaction.
 		 */
-		error = xfs_bmap_finish(tp, &free_list, first_block,
-					&committed);
+		error = xfs_bmap_finish(tp, &free_list, &committed);
 		ntp = *tp;
 		if (error) {
 			/*
Index: xfs-linux-allpatches/xfs_iomap.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_iomap.c
+++ xfs-linux-allpatches/xfs_iomap.c
@@ -542,7 +542,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Complete the transaction
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, firstfsb, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
 		goto error0;
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
@@ -838,8 +838,7 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto trans_cancel;
 
-			error = xfs_bmap_finish(&tp, &free_list,
-					first_block, &committed);
+			error = xfs_bmap_finish(&tp, &free_list, &committed);
 			if (error)
 				goto trans_cancel;
 
@@ -947,8 +946,7 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
-		error = xfs_bmap_finish(&(tp), &(free_list),
-				firstfsb, &committed);
+		error = xfs_bmap_finish(&(tp), &(free_list), &committed);
 		if (error)
 			goto error_on_bmapi_transaction;
 
Index: xfs-linux-allpatches/xfs_rename.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_rename.c
+++ xfs-linux-allpatches/xfs_rename.c
@@ -565,7 +565,7 @@ xfs_rename(
 		IHOLD(target_ip);
 	IHOLD(src_ip);
 
-	error = xfs_bmap_finish(&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
Index: xfs-linux-allpatches/xfs_rtalloc.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_rtalloc.c
+++ xfs-linux-allpatches/xfs_rtalloc.c
@@ -147,7 +147,7 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
-		error = xfs_bmap_finish(&tp, &flist, firstblock, &committed);
+		error = xfs_bmap_finish(&tp, &flist, &committed);
 		if (error)
 			goto error_exit;
 		xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
Index: xfs-linux-allpatches/xfs_vnodeops.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_vnodeops.c
+++ xfs-linux-allpatches/xfs_vnodeops.c
@@ -1381,7 +1381,7 @@ xfs_inactive_symlink_rmt(
 	/*
 	 * Commit the first transaction.  This logs the EFI and the inode.
 	 */
-	if ((error = xfs_bmap_finish(&tp, &free_list, first_block, &committed)))
+	if ((error = xfs_bmap_finish(&tp, &free_list, &committed)))
 		goto error1;
 	/*
 	 * The transaction must have been committed, since there were
@@ -1790,8 +1790,7 @@ xfs_inactive(
 		 * Just ignore errors at this point.  There is
 		 * nothing we can do except to try to keep going.
 		 */
-		(void) xfs_bmap_finish(&tp,  &free_list, first_block,
-				       &committed);
+		(void) xfs_bmap_finish(&tp,  &free_list, &committed);
 		(void) xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
 	}
 	/*
@@ -2022,7 +2021,7 @@ xfs_create(
 	IHOLD(ip);
 	vp = XFS_ITOV(ip);
 
-	error = xfs_bmap_finish(&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		goto abort_rele;
@@ -2507,7 +2506,7 @@ xfs_remove(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		REMOVE_DEBUG_TRACE(__LINE__);
 		goto error_rele;
@@ -2715,7 +2714,7 @@ xfs_link(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish (&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish (&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		goto abort_return;
@@ -2932,7 +2931,7 @@ xfs_mkdir(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		IRELE(cdp);
 		goto error2;
@@ -3183,7 +3182,7 @@ xfs_rmdir(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish (&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish (&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
@@ -3533,7 +3532,7 @@ xfs_symlink(
 	 */
 	IHOLD(ip);
 
-	error = xfs_bmap_finish(&tp, &free_list, first_block, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		goto error2;
 	}
@@ -4145,7 +4144,7 @@ retry:
 		/*
 		 * Complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, firstfsb, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
 		if (error) {
 			goto error0;
 		}
@@ -4452,7 +4451,7 @@ xfs_free_file_space(
 		/*
 		 * complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, firstfsb, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
 		if (error) {
 			goto error0;
 		}
