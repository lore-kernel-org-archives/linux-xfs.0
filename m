Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbfEVSFv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D63B9309267B
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:50 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95B515C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:50 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 09/11] xfs: replace small allocation logic with agfl only logic
Date: Wed, 22 May 2019 14:05:44 -0400
Message-Id: <20190522180546.17063-10-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that the various extent allocation modes have been reworked,
there are no more users of a large portion of
xfs_alloc_ag_vextent_small(). Remove the unnecessary record handling
logic, refactor and rename this function to a simple AGFL allocation
helper and simplify the interface.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 80 ++++++++++-----------------------------
 fs/xfs/xfs_trace.h        |  8 ++--
 2 files changed, 24 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6b8bd8f316cb..24485687e2ae 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1228,46 +1228,28 @@ xfs_alloc_ag_vextent_cur(
 }
 
 /*
- * Deal with the case where only small freespaces remain. Either return the
- * contents of the last freespace record, or allocate space from the freelist if
- * there is nothing in the tree.
+ * Attempt to allocate from the AGFL. This is a last resort when no other free
+ * space is available.
  */
-STATIC int			/* error */
-xfs_alloc_ag_vextent_small(
-	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
-	xfs_agblock_t		*fbnop,	/* result block number */
-	xfs_extlen_t		*flenp,	/* result length */
-	int			*stat)	/* status: 0-freelist, 1-normal/none */
+STATIC int
+xfs_alloc_ag_vextent_agfl(
+	struct xfs_alloc_arg	*args)	/* allocation argument structure */
 {
-	int			error = 0;
+	int			error;
 	xfs_agblock_t		fbno = NULLAGBLOCK;
-	xfs_extlen_t		flen = 0;
-	int			i = 0;
 
 	/*
-	 * If a cntbt cursor is provided, try to allocate the largest record in
-	 * the tree. Try the AGFL if the cntbt is empty, otherwise fail the
-	 * allocation. Make sure to respect minleft even when pulling from the
-	 * freelist.
+	 * The AGFL can only perform unaligned, single block allocations. Also
+	 * make sure this isn't an allocation for the AGFL itself and to respect
+	 * minleft before we take a block.
 	 */
-	if (ccur)
-		error = xfs_btree_decrement(ccur, 0, &i);
-	if (error)
-		goto error;
-	if (i) {
-		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
-		if (error)
-			goto error;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
-		goto out;
-	}
-
 	if (args->minlen != 1 || args->alignment != 1 ||
 	    args->resv == XFS_AG_RESV_AGFL ||
 	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
-	     args->minleft))
+	     args->minleft)) {
+		trace_xfs_alloc_agfl_notenough(args);
 		goto out;
+	}
 
 	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
 	if (error)
@@ -1289,13 +1271,9 @@ xfs_alloc_ag_vextent_small(
 		}
 		xfs_trans_binval(args->tp, bp);
 	}
-	*fbnop = args->agbno = fbno;
-	*flenp = args->len = 1;
 	XFS_WANT_CORRUPTED_GOTO(args->mp,
 		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 		error);
-	args->wasfromfl = 1;
-	trace_xfs_alloc_small_freelist(args);
 
 	/*
 	 * If we're feeding an AGFL block to something that doesn't live in the
@@ -1306,26 +1284,18 @@ xfs_alloc_ag_vextent_small(
 	if (error)
 		goto error;
 
-	*stat = 0;
-	return 0;
-
 out:
-	/*
-	 * Can't do the allocation, give up.
-	 */
-	if (flen < args->minlen) {
-		args->agbno = NULLAGBLOCK;
-		trace_xfs_alloc_small_notenough(args);
-		flen = 0;
+	args->agbno = fbno;
+	if (fbno != NULLAGBLOCK) {
+		args->wasfromfl = 1;
+		args->len = 1;
 	}
-	*fbnop = fbno;
-	*flenp = flen;
-	*stat = 1;
-	trace_xfs_alloc_small_done(args);
+
+	trace_xfs_alloc_agfl_done(args);
 	return 0;
 
 error:
-	trace_xfs_alloc_small_error(args);
+	trace_xfs_alloc_agfl_error(args);
 	return error;
 }
 
@@ -1342,8 +1312,6 @@ xfs_alloc_ag_vextent_type(
 	struct xfs_alloc_cur	acur = {0,};
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
-	xfs_agblock_t		bno;	      /* start bno of left side entry */
-	xfs_extlen_t		len;		/* length of left side entry */
 
 	/* handle unitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
@@ -1387,17 +1355,11 @@ xfs_alloc_ag_vextent_type(
 
 		/*
 		 * We get here if we can't satisfy minlen or the trees are
-		 * empty. We don't pass a cursor so this returns an AGFL block
-		 * (i == 0) or nothing.
+		 * empty.
 		 */
-		error = xfs_alloc_ag_vextent_small(args, NULL, &bno, &len, &i);
+		error = xfs_alloc_ag_vextent_agfl(args);
 		if (error)
 			goto out;
-		ASSERT(i == 0 || (i && len == 0));
-		trace_xfs_alloc_ag_noentry(args);
-
-		args->agbno = bno;
-		args->len = len;
 	}
 
 out:
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 519bf7d104ba..b3ff29325b61 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1635,14 +1635,12 @@ DEFINE_EVENT(xfs_alloc_class, name, \
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_ag_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_agfl_notenough);
+DEFINE_ALLOC_EVENT(xfs_alloc_agfl_done);
+DEFINE_ALLOC_EVENT(xfs_alloc_agfl_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
-- 
2.17.2
