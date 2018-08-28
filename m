Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727412AbeH1QZG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Aug 2018 12:25:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F03B1805A6D8
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 12:33:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBE83FA969
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 12:33:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: remove last of unnecessary xfs_defer_cancel() callers
Date: Tue, 28 Aug 2018 08:33:38 -0400
Message-Id: <20180828123338.51189-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that deferred operations are completely managed via
transactions, it's no longer necessary to cancel the dfops in error
paths that already cancel the associated transaction. There are a
few such calls lingering throughout the codebase.

Remove all remaining unnecessary calls to xfs_defer_cancel(). This
leaves xfs_defer_cancel() calls in two places. The first is the call
in the transaction cancel path itself, which facilitates this patch.
The second is made via the xfs_defer_finish() error path to provide
consistent error semantics with transaction commit. For example,
xfs_trans_commit() expects an xfs_defer_finish() failure to clean up
the dfops structure before it returns.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I think I promised Darrick I'd audit these and clean the rest out some
time ago, during review of the core dfops cleanups...

Brian

 fs/xfs/libxfs/xfs_attr.c        | 28 ++++++++--------------------
 fs/xfs/libxfs/xfs_attr_remote.c | 10 ++--------
 fs/xfs/xfs_bmap_util.c          | 12 +++++-------
 fs/xfs/xfs_inode.c              | 10 +---------
 4 files changed, 16 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1e671d4eb6fa..c6299f82a6e4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -587,7 +587,7 @@ xfs_attr_leaf_addname(
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
-			goto out_defer_cancel;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			return error;
@@ -675,7 +675,7 @@ xfs_attr_leaf_addname(
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
-				goto out_defer_cancel;
+				return error;
 			error = xfs_defer_finish(&args->trans);
 			if (error)
 				return error;
@@ -693,9 +693,6 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 	}
 	return error;
-out_defer_cancel:
-	xfs_defer_cancel(args->trans);
-	return error;
 }
 
 /*
@@ -738,15 +735,12 @@ xfs_attr_leaf_removename(
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
-			goto out_defer_cancel;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			return error;
 	}
 	return 0;
-out_defer_cancel:
-	xfs_defer_cancel(args->trans);
-	return error;
 }
 
 /*
@@ -864,7 +858,7 @@ xfs_attr_node_addname(
 			state = NULL;
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
-				goto out_defer_cancel;
+				goto out;
 			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out;
@@ -888,7 +882,7 @@ xfs_attr_node_addname(
 		 */
 		error = xfs_da3_split(state);
 		if (error)
-			goto out_defer_cancel;
+			goto out;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out;
@@ -984,7 +978,7 @@ xfs_attr_node_addname(
 		if (retval && (state->path.active > 1)) {
 			error = xfs_da3_join(state);
 			if (error)
-				goto out_defer_cancel;
+				goto out;
 			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out;
@@ -1013,9 +1007,6 @@ xfs_attr_node_addname(
 	if (error)
 		return error;
 	return retval;
-out_defer_cancel:
-	xfs_defer_cancel(args->trans);
-	goto out;
 }
 
 /*
@@ -1107,7 +1098,7 @@ xfs_attr_node_removename(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-			goto out_defer_cancel;
+			goto out;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out;
@@ -1138,7 +1129,7 @@ xfs_attr_node_removename(
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
-				goto out_defer_cancel;
+				goto out;
 			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out;
@@ -1150,9 +1141,6 @@ xfs_attr_node_removename(
 out:
 	xfs_da_state_free(state);
 	return error;
-out_defer_cancel:
-	xfs_defer_cancel(args->trans);
-	goto out;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index af094063e402..d89363c6b523 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -485,7 +485,7 @@ xfs_attr_rmtval_set(
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
 				  &nmap);
 		if (error)
-			goto out_defer_cancel;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			return error;
@@ -553,9 +553,6 @@ xfs_attr_rmtval_set(
 	}
 	ASSERT(valuelen == 0);
 	return 0;
-out_defer_cancel:
-	xfs_defer_cancel(args->trans);
-	return error;
 }
 
 /*
@@ -625,7 +622,7 @@ xfs_attr_rmtval_remove(
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, &done);
 		if (error)
-			goto out_defer_cancel;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			return error;
@@ -638,7 +635,4 @@ xfs_attr_rmtval_remove(
 			return error;
 	}
 	return 0;
-out_defer_cancel:
-	xfs_defer_cancel(args->trans);
-	return error;
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index addbd74ecd8e..ae3cc393724f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1584,7 +1584,7 @@ xfs_swap_extent_rmap(
 					tirec.br_blockcount, &irec,
 					&nimaps, 0);
 			if (error)
-				goto out_defer;
+				goto out;
 			ASSERT(nimaps == 1);
 			ASSERT(tirec.br_startoff == irec.br_startoff);
 			trace_xfs_swap_extent_rmap_remap_piece(ip, &irec);
@@ -1599,22 +1599,22 @@ xfs_swap_extent_rmap(
 			/* Remove the mapping from the donor file. */
 			error = xfs_bmap_unmap_extent(tp, tip, &uirec);
 			if (error)
-				goto out_defer;
+				goto out;
 
 			/* Remove the mapping from the source file. */
 			error = xfs_bmap_unmap_extent(tp, ip, &irec);
 			if (error)
-				goto out_defer;
+				goto out;
 
 			/* Map the donor file's blocks into the source file. */
 			error = xfs_bmap_map_extent(tp, ip, &uirec);
 			if (error)
-				goto out_defer;
+				goto out;
 
 			/* Map the source file's blocks into the donor file. */
 			error = xfs_bmap_map_extent(tp, tip, &irec);
 			if (error)
-				goto out_defer;
+				goto out;
 
 			error = xfs_defer_finish(tpp);
 			tp = *tpp;
@@ -1636,8 +1636,6 @@ xfs_swap_extent_rmap(
 	tip->i_d.di_flags2 = tip_flags2;
 	return 0;
 
-out_defer:
-	xfs_defer_cancel(tp);
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
 	tip->i_d.di_flags2 = tip_flags2;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d957a46dc1cb..05db9540e459 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1563,7 +1563,7 @@ xfs_itruncate_extents_flags(
 		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
 				    XFS_ITRUNC_MAX_EXTENTS, &done);
 		if (error)
-			goto out_bmap_cancel;
+			goto out;
 
 		/*
 		 * Duplicate the transaction that has the permanent
@@ -1599,14 +1599,6 @@ xfs_itruncate_extents_flags(
 out:
 	*tpp = tp;
 	return error;
-out_bmap_cancel:
-	/*
-	 * If the bunmapi call encounters an error, return to the caller where
-	 * the transaction can be properly aborted.  We just need to make sure
-	 * we're not holding any resources that we were not when we came in.
-	 */
-	xfs_defer_cancel(tp);
-	goto out;
 }
 
 int
-- 
2.17.1
