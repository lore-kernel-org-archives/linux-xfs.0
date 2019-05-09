Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbfEIRFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 13:05:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B4B330842A9
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:42 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 164E410018FB
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:42 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/6] xfs: replace small allocation logic with agfl only logic
Date: Thu,  9 May 2019 12:58:39 -0400
Message-Id: <20190509165839.44329-7-bfoster@redhat.com>
In-Reply-To: <20190509165839.44329-1-bfoster@redhat.com>
References: <20190509165839.44329-1-bfoster@redhat.com>
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
---
 fs/xfs/libxfs/xfs_alloc.c | 141 ++++++++++++++------------------------
 fs/xfs/xfs_trace.h        |   7 +-
 2 files changed, 56 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0b121cb5ef3f..4f2fa44a1460 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -39,8 +39,7 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_CNT_OK	2
 
 STATIC int xfs_alloc_ag_vextent_type(struct xfs_alloc_arg *);
-STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
-		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
+STATIC int xfs_alloc_ag_vextent_agfl(struct xfs_alloc_arg *, xfs_agblock_t *);
 
 /*
  * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
@@ -1318,7 +1317,6 @@ xfs_alloc_ag_vextent_type(
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
 	xfs_agblock_t		bno;	      /* start bno of left side entry */
-	xfs_extlen_t		len;		/* length of left side entry */
 
 	/* handle unitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
@@ -1365,14 +1363,16 @@ xfs_alloc_ag_vextent_type(
 		 * empty. We don't pass a cursor so this returns an AGFL block
 		 * (i == 0) or nothing.
 		 */
-		error = xfs_alloc_ag_vextent_small(args, NULL, &bno, &len, &i);
+		error = xfs_alloc_ag_vextent_agfl(args, &bno);
 		if (error)
 			goto out;
-		ASSERT(i == 0 || (i && len == 0));
 		trace_xfs_alloc_near_noentry(args);
 
 		args->agbno = bno;
-		args->len = len;
+		if (bno != NULLAGBLOCK) {
+			args->wasfromfl = 1;
+			args->len = 1;
+		}
 	}
 
 out:
@@ -1383,108 +1383,73 @@ xfs_alloc_ag_vextent_type(
 }
 
 /*
- * Deal with the case where only small freespaces remain.
- * Either return the contents of the last freespace record,
- * or allocate space from the freelist if there is nothing in the tree.
+ * Attempt to allocate from the AGFL. This is a last resort when no other free
+ * space is available.
  */
-STATIC int			/* error */
-xfs_alloc_ag_vextent_small(
+STATIC int
+xfs_alloc_ag_vextent_agfl(
 	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
-	xfs_agblock_t		*fbnop,	/* result block number */
-	xfs_extlen_t		*flenp,	/* result length */
-	int			*stat)	/* status: 0-freelist, 1-normal/none */
+	xfs_agblock_t		*fbnop)	/* result block number */
 {
 	int			error = 0;
 	xfs_agblock_t		fbno;
-	xfs_extlen_t		flen;
-	int			i = 0;
+
+	*fbnop = NULLAGBLOCK;
 
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
+	if (args->minlen != 1 || args->alignment != 1 ||
+	    args->resv == XFS_AG_RESV_AGFL ||
+	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
+	     args->minleft)) {
+		trace_xfs_alloc_agfl_notenough(args);
+		goto out;
+	}
+
+	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
 	if (error)
-		goto error0;
-	if (i) {
-		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
-		if (error)
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-	} else if (args->minlen == 1 && args->alignment == 1 &&
-		   args->resv != XFS_AG_RESV_AGFL &&
-		   (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) >
-		    args->minleft)) {
-		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
-		if (error)
-			goto error0;
-		if (fbno != NULLAGBLOCK) {
-			xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
-			      xfs_alloc_allow_busy_reuse(args->datatype));
+		goto out;
 
-			if (xfs_alloc_is_userdata(args->datatype)) {
-				xfs_buf_t	*bp;
+	if (fbno == NULLAGBLOCK)
+		goto out;
 
-				bp = xfs_btree_get_bufs(args->mp, args->tp,
-					args->agno, fbno, 0);
-				if (!bp) {
-					error = -EFSCORRUPTED;
-					goto error0;
-				}
-				xfs_trans_binval(args->tp, bp);
-			}
-			XFS_WANT_CORRUPTED_GOTO(args->mp,
-				args->agbno + args->len <=
-				be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
-				error0);
-			args->wasfromfl = 1;
-			trace_xfs_alloc_small_freelist(args);
+	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
+			      xfs_alloc_allow_busy_reuse(args->datatype));
 
-			/*
-			 * If we're feeding an AGFL block to something that
-			 * doesn't live in the free space, we need to clear
-			 * out the OWN_AG rmap.
-			 */
-			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
-					fbno, 1, &XFS_RMAP_OINFO_AG);
-			if (error)
-				goto error0;
+	if (xfs_alloc_is_userdata(args->datatype)) {
+		struct xfs_buf	*bp;
 
-			*fbnop = args->agbno = fbno;
-			*flenp = args->len = 1;
-			*stat = 0;
-			return 0;
+		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno,
+					0);
+		if (!bp) {
+			error = -EFSCORRUPTED;
+			goto out;
 		}
-		/*
-		 * Nothing in the freelist.
-		 */
-		else
-			flen = 0;
-	} else {
-		fbno = NULLAGBLOCK;
-		flen = 0;
+		xfs_trans_binval(args->tp, bp);
 	}
+	XFS_WANT_CORRUPTED_GOTO(args->mp,
+		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
+		out);
 
 	/*
-	 * Can't do the allocation, give up.
+	 * If we're feeding an AGFL block to something that doesn't live in the
+	 * free space, we need to clear out the OWN_AG rmap.
 	 */
-	if (flen < args->minlen) {
-		args->agbno = NULLAGBLOCK;
-		trace_xfs_alloc_small_notenough(args);
-		flen = 0;
-	}
+	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
+			      &XFS_RMAP_OINFO_AG);
+	if (error)
+		goto out;
+
 	*fbnop = fbno;
-	*flenp = flen;
-	*stat = 1;
-	trace_xfs_alloc_small_done(args);
-	return 0;
 
-error0:
-	trace_xfs_alloc_small_error(args);
+out:
+	if (error)
+		trace_xfs_alloc_agfl_error(args);
+	else
+		trace_xfs_alloc_agfl_done(args);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 54be8e30ab11..e0df6e8bc87a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1640,10 +1640,9 @@ DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
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
