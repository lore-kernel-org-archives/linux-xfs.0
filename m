Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2F8C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347524AbiFKB1k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349078AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 250C23A480B
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A5CB010E721C
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APq-5u
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNX-4x
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 37/50] xfs: factor out filestreams from xfs_bmap_btalloc_nullfb
Date:   Sat, 11 Jun 2022 11:26:46 +1000
Message-Id: <20220611012659.3418072-38-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=LBoysBfGenFEb5M6mgUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's many if (filestreams) {} else {} branches in this function.
Split it out into a filestreams specific function so that we can
then work directly on cleaning up the filestreams code without
impacting the rest of the allocation algorithms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 151 ++++++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a6d3157ae896..c8045cca2ec6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3585,6 +3585,78 @@ xfs_btalloc_at_eof(
 	return 0;
 }
 
+/*
+ * We have failed multiple allocation attempts so now are in a low space
+ * allocation situation. Try a locality first full filesystem minimum length
+ * allocation whilst still maintaining necessary total block reservation
+ * requirements.
+ *
+ * If that fails, we are now critically low on space, so perform a last resort
+ * allocation attempt: no reserve, no locality, blocking, minimum length, full
+ * filesystem free space scan. We also indicate to future allocations in this
+ * transaction that we are critically low on space so they don't waste time on
+ * allocation modes that are unlikely to succeed.
+ */
+static int
+xfs_btalloc_low_space(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	int			error;
+
+	if (args->minlen > ap->minlen) {
+		args->minlen = ap->minlen;
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+		if (error || args->fsbno != NULLFSBLOCK)
+			return error;
+	}
+
+	args->total = ap->minlen;
+	error = xfs_alloc_vextent_first_ag(args, 0);
+	if (error)
+		return error;
+	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
+	return 0;
+}
+
+static int
+xfs_btalloc_filestreams(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	xfs_agnumber_t		agno = xfs_filestream_lookup_ag(ap->ip);
+	xfs_extlen_t		blen = 0;
+	int			error;
+
+	/* Determine the initial block number we will target for allocation. */
+	if (agno == NULLAGNUMBER)
+		agno = 0;
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	/*
+	 * Search for an allocation group with a single extent large enough for
+	 * the request.  If one isn't found, then adjust the minimum allocation
+	 * size to the largest space found.
+	 */
+	error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
+	if (error)
+		return error;
+
+	if (ap->aeof) {
+		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align, true);
+		if (error || args->fsbno != NULLFSBLOCK)
+			return error;
+	}
+
+	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+	if (error || args->fsbno != NULLFSBLOCK)
+		return error;
+
+	return xfs_btalloc_low_space(ap, args);
+}
+
 static int
 xfs_btalloc_nullfb_bestlen(
 	struct xfs_bmalloca	*ap,
@@ -3625,26 +3697,10 @@ xfs_btalloc_nullfb(
 	struct xfs_alloc_arg	*args,
 	int			stripe_align)
 {
-	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		blen = 0;
-	bool			is_filestream = false;
 	int			error;
 
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
-		is_filestream = true;
-
-	/*
-	 * Determine the initial block number we will target for allocation.
-	 */
-	if (is_filestream) {
-		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
-		if (agno == NULLAGNUMBER)
-			agno = 0;
-		ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-	} else {
-		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
-	}
+	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
 	xfs_bmap_adjacent(ap);
 
 	/*
@@ -3652,58 +3708,21 @@ xfs_btalloc_nullfb(
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	if (is_filestream)
-		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
-	else
-		error = xfs_btalloc_nullfb_bestlen(ap, args, &blen);
+	error = xfs_btalloc_nullfb_bestlen(ap, args, &blen);
 	if (error)
 		return error;
 
 	if (ap->aeof) {
-		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align,
-				is_filestream);
-		if (error)
+		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align, false);
+		if (error || args->fsbno != NULLFSBLOCK)
 			return error;
-		if (args->fsbno != NULLFSBLOCK)
-			return 0;
 	}
 
-	if (is_filestream)
-		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	else
-		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-	if (error)
+	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
 
-	/*
-	 * Try a locality first full filesystem minimum length allocation whilst
-	 * still maintaining necessary total block reservation requirements.
-	 */
-	if (args->minlen > ap->minlen) {
-		args->minlen = ap->minlen;
-		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-		if (error)
-			return error;
-	}
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
-
-	/*
-	 * We are now critically low on space, so this is a last resort
-	 * allocation attempt: no reserve, no locality, blocking, minimum
-	 * length, full filesystem free space scan. We also indicate to future
-	 * allocations in this transaction that we are critically low on space
-	 * so they don't waste time on allocation modes that are unlikely to
-	 * succeed.
-	 */
-	args->total = ap->minlen;
-	error = xfs_alloc_vextent_first_ag(args, 0);
-	if (error)
-		return error;
-	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
-	return 0;
+	return xfs_btalloc_low_space(ap, args);
 }
 
 /*
@@ -3745,10 +3764,8 @@ xfs_btalloc_near(
 	if (ap->aeof) {
 		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align,
 				true);
-		if (error)
+		if (error || args->fsbno != NULLFSBLOCK)
 			return error;
-		if (args->fsbno != NULLFSBLOCK)
-			return 0;
 	}
 	return xfs_alloc_vextent_near_bno(args, ap->blkno);
 }
@@ -3785,7 +3802,13 @@ xfs_bmap_btalloc(
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
 	if (ap->tp->t_firstblock == NULLFSBLOCK) {
-		error = xfs_btalloc_nullfb(ap, &args, stripe_align);
+		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+		    xfs_inode_is_filestream(ap->ip)) {
+			error = xfs_btalloc_filestreams(ap, &args,
+					stripe_align);
+		} else {
+			error = xfs_btalloc_nullfb(ap, &args, stripe_align);
+		}
 	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		error = xfs_btalloc_low_mode(ap, &args);
 	} else {
-- 
2.35.1

