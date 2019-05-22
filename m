Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbfEVSFw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:52 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8D4B307EA8F
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:51 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67AC15C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:51 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 11/11] xfs: condense high level AG allocation functions
Date: Wed, 22 May 2019 14:05:46 -0400
Message-Id: <20190522180546.17063-12-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The higher level allocation code is unnecessarily split across
xfs_alloc_ag_vextent() and xfs_alloc_ag_vextent_type(). Fold the
latter into the former to avoid the unnecessary level of indirection
and reduce the overall amount of code. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 158 ++++++++++++++++----------------------
 1 file changed, 66 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3b0cdb8346c9..434e5e874436 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1299,76 +1299,6 @@ xfs_alloc_ag_vextent_agfl(
 	return error;
 }
 
-/*
- * Allocate a variable extent near bno in the allocation group agno.
- * Extent's length (returned in len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
- */
-STATIC int				/* error */
-xfs_alloc_ag_vextent_type(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
-{
-	struct xfs_alloc_cur	acur = {0,};
-	int			error;		/* error code */
-	int			i;		/* result code, temporary */
-
-	/* handle unitialized agbno range so caller doesn't have to */
-	if (!args->min_agbno && !args->max_agbno)
-		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
-	ASSERT(args->min_agbno <= args->max_agbno);
-
-	/* clamp agbno to the range if it's outside */
-	if (args->agbno < args->min_agbno)
-		args->agbno = args->min_agbno;
-	if (args->agbno > args->max_agbno)
-		args->agbno = args->max_agbno;
-
-restart:
-	/* set up cursors and allocation tracking structure based on args */
-	error = xfs_alloc_cur_setup(args, &acur);
-	if (error)
-		goto out;
-
-	if (args->type == XFS_ALLOCTYPE_THIS_AG)
-		error = xfs_alloc_ag_vextent_size(args, &acur, &i);
-	else
-		error = xfs_alloc_ag_vextent_cur(args, &acur, &i);
-	if (error)
-		goto out;
-
-	/*
-	 * If we got an extent, finish the allocation. Otherwise check for busy
-	 * extents and retry or attempt a small allocation.
-	 */
-	if (i) {
-		error = xfs_alloc_cur_finish(args, &acur);
-		if (error)
-			goto out;
-	} else  {
-		if (acur.busy) {
-			trace_xfs_alloc_ag_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag,
-					      acur.busy_gen);
-			goto restart;
-		}
-
-		/*
-		 * We get here if we can't satisfy minlen or the trees are
-		 * empty.
-		 */
-		error = xfs_alloc_ag_vextent_agfl(args);
-		if (error)
-			goto out;
-	}
-
-out:
-	xfs_alloc_cur_close(&acur, error);
-	if (error)
-		trace_xfs_alloc_ag_error(args);
-	return error;
-}
-
 /*
  * Various AG accounting updates for a successful allocation. This includes
  * updating the rmapbt, AG free block accounting and AG reservation accounting.
@@ -1412,44 +1342,88 @@ xfs_alloc_ag_vextent_accounting(
 }
 
 /*
- * Allocate a variable extent in the allocation group agno.
- * Type and bno are used to determine where in the allocation group the
- * extent will start.
- * Extent's length (returned in *len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
+ * Allocate a variable extent in the allocation group agno. Type and bno are
+ * used to determine where in the allocation group the extent will start.
+ * Extent's length (returned in *len) will be between minlen and maxlen, and of
+ * the form k * prod + mod unless there's nothing that large. Return the
+ * starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int			/* error */
+STATIC int
 xfs_alloc_ag_vextent(
-	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
+	struct xfs_alloc_arg	*args)	/* argument structure for allocation */
 {
-	int		error=0;
+	struct xfs_alloc_cur	acur = {0,};
+	int			error;
+	int			i;
 
 	ASSERT(args->minlen > 0);
 	ASSERT(args->maxlen > 0);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->mod < args->prod);
 	ASSERT(args->alignment > 0);
+	ASSERT(args->type == XFS_ALLOCTYPE_THIS_AG ||
+	       args->type == XFS_ALLOCTYPE_NEAR_BNO ||
+	       args->type == XFS_ALLOCTYPE_THIS_BNO);
+	ASSERT(args->min_agbno <= args->max_agbno);
+
+	args->wasfromfl = 0;
+
+	/* handle unitialized agbno range so caller doesn't have to */
+	if (!args->min_agbno && !args->max_agbno)
+		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
+
+	/* clamp agbno to the range if it's outside */
+	if (args->agbno < args->min_agbno)
+		args->agbno = args->min_agbno;
+	if (args->agbno > args->max_agbno)
+		args->agbno = args->max_agbno;
+
+restart:
+	/* set up cursors and allocation tracking structure based on args */
+	error = xfs_alloc_cur_setup(args, &acur);
+	if (error)
+		goto out;
+
+	if (args->type == XFS_ALLOCTYPE_THIS_AG)
+		error = xfs_alloc_ag_vextent_size(args, &acur, &i);
+	else
+		error = xfs_alloc_ag_vextent_cur(args, &acur, &i);
+	if (error)
+		goto out;
 
 	/*
-	 * Branch to correct routine based on the type.
+	 * If we got an extent, finish the allocation. Otherwise check for busy
+	 * extents and retry or attempt a small allocation.
 	 */
-	args->wasfromfl = 0;
-	switch (args->type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		error = xfs_alloc_ag_vextent_type(args);
-		break;
-	default:
-		ASSERT(0);
-		/* NOTREACHED */
+	if (i) {
+		error = xfs_alloc_cur_finish(args, &acur);
+		if (error)
+			goto out;
+	} else  {
+		if (acur.busy) {
+			trace_xfs_alloc_ag_busy(args);
+			xfs_extent_busy_flush(args->mp, args->pag,
+					      acur.busy_gen);
+			goto restart;
+		}
+
+		/*
+		 * We get here if we can't satisfy minlen or the trees are
+		 * empty. We don't pass a cursor so this returns an AGFL block
+		 * (i == 0) or nothing.
+		 */
+		error = xfs_alloc_ag_vextent_agfl(args);
+		if (error)
+			goto out;
 	}
-	if (error)
-		return error;
 
 	if (args->agbno != NULLAGBLOCK)
 		error = xfs_alloc_ag_vextent_accounting(args);
+
+out:
+	xfs_alloc_cur_close(&acur, error);
+	if (error)
+		trace_xfs_alloc_ag_error(args);
 	return error;
 }
 
-- 
2.17.2
