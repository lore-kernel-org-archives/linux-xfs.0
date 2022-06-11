Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1501FCCA47C
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345060AbiFKB1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348955AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D3B43A481D
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 906D410E7218
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQN-Jd
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELOQ-IK
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 48/50] xfs: return a referenced perag from filestreams allocator
Date:   Sat, 11 Jun 2022 11:26:57 +1000
Message-Id: <20220611012659.3418072-49-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=stoYrwtHbAj4XFLctdUA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the filestreams AG selection tracks active perags, we need
to return an active perag to the core allocator code. This is
because the file allocation the filestreams code will run are AG
specific allocations and so need to pin the AG until the allocations
complete.

We cannot rely on the filestreams item reference to do this - the
filestreams association can be torn down at any time, hence we
need to have a separate reference for the allocation process to pin
the AG after it has been selected.

This means there is some perag juggling in allocation failure
fallback paths as they will do all AG scans in the case the AG
specific allocation fails. Hence we need to track the perag
reference that the filestream allocator returned to make sure we
don't leak it on repeated allocation failure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 33 ++++++++++++++------
 fs/xfs/xfs_filestream.c  | 65 ++++++++++++++++++++++++++--------------
 2 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a87897ac644..1362c3997cbe 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3438,6 +3438,7 @@ xfs_btalloc_at_eof(
 	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
+	struct xfs_perag	*caller_pag = args->pag;
 	int			error;
 
 	/*
@@ -3465,9 +3466,11 @@ xfs_btalloc_at_eof(
 		else
 			args->minalignslop = 0;
 
-		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
+		if (!caller_pag)
+			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
 		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-		xfs_perag_put(args->pag);
+		if (!caller_pag)
+			xfs_perag_put(args->pag);
 		if (error)
 			return error;
 
@@ -3493,10 +3496,13 @@ xfs_btalloc_at_eof(
 		args->minalignslop = 0;
 	}
 
-	if (ag_only)
+	if (ag_only) {
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	else
+	} else {
+		args->pag = NULL;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+		args->pag = caller_pag;
+	}
 	if (error)
 		return error;
 
@@ -3559,16 +3565,25 @@ xfs_btalloc_filestreams(
 	error = xfs_filestream_select_ag(ap, args, &blen);
 	if (error)
 		return error;
+	ASSERT(args->pag);
 
 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
 
-	if (ap->aeof) {
+	if (ap->aeof)
 		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align, true);
-		if (error || args->fsbno != NULLFSBLOCK)
-			return error;
-	}
 
-	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+	if (!error && args->fsbno == NULLFSBLOCK)
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+
+	/*
+	 * We are now done with the perag reference for the filestreams
+	 * association provided by xfs_filestream_select_ag(). Release it now as
+	 * we've either succeeded, had a fatal error or we are out of space and
+	 * need to do a full filesystem scan for free space which will take it's
+	 * own references.
+	 */
+	xfs_perag_rele(args->pag);
+	args->pag = NULL;
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
 
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 6212e8adb7a9..2c02950efc22 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -53,8 +53,9 @@ xfs_fstrm_free_func(
  */
 static int
 xfs_filestream_pick_ag(
+	struct xfs_alloc_arg	*args,
 	struct xfs_inode	*ip,
-	xfs_agnumber_t		*agp,
+	xfs_agnumber_t		start_agno,
 	int			flags,
 	xfs_extlen_t		*longest)
 {
@@ -64,7 +65,6 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
-	xfs_agnumber_t		start_agno = *agp;
 	xfs_agnumber_t		agno;
 	int			err, trylock;
 
@@ -73,8 +73,6 @@ xfs_filestream_pick_ag(
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
-	*agp = NULLAGNUMBER;
-
 	/* For the first pass, don't sleep trying to init the per-AG. */
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
@@ -146,16 +144,19 @@ xfs_filestream_pick_ag(
 		/*
 		 * No unassociated AGs are available, so select the AG with the
 		 * most free space, regardless of whether it's already in use by
-		 * another filestream. It none suit, return NULLAGNUMBER.
+		 * another filestream. It none suit, just use whatever AG we can
+		 * grab.
 		 */
 		if (!max_pag) {
-			*agp = NULLAGNUMBER;
-			trace_xfs_filestream_pick(ip, NULL, free);
-			return 0;
+			for_each_perag_wrap(mp, start_agno, agno, pag)
+				break;
+			atomic_inc(&pag->pagf_fstrms);
+			*longest = 0;
+		} else {
+			pag = max_pag;
+			free = maxfree;
+			atomic_inc(&pag->pagf_fstrms);
 		}
-		pag = max_pag;
-		free = maxfree;
-		atomic_inc(&pag->pagf_fstrms);
 	} else if (max_pag) {
 		xfs_perag_rele(max_pag);
 	}
@@ -167,16 +168,29 @@ xfs_filestream_pick_ag(
 	if (!item)
 		goto out_put_ag;
 
+
+	/*
+	 * We are going to use this perag now, so take another ref to it for the
+	 * allocation context returned to the caller. If we raced to create and
+	 * insert the filestreams item into the MRU (-EEXIST), then we still
+	 * keep this reference but free the item reference we gained above. On
+	 * any other failure, we have to drop both.
+	 */
+	atomic_inc(&pag->pag_active_ref);
 	item->pag = pag;
+	args->pag = pag;
 
 	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
 	if (err) {
-		if (err == -EEXIST)
+		if (err == -EEXIST) {
 			err = 0;
+		} else {
+			xfs_perag_rele(args->pag);
+			args->pag = NULL;
+		}
 		goto out_free_item;
 	}
 
-	*agp = pag->pag_agno;
 	return 0;
 
 out_free_item:
@@ -237,7 +251,14 @@ xfs_filestream_select_ag_mru(
 	if (!mru)
 		goto out_default_agno;
 
+	/*
+	 * Grab the pag and take an extra active reference for the caller whilst
+	 * the mru item cannot go away. This means we'll pin the perag with
+	 * the reference we get here even if the filestreams association is torn
+	 * down immediately after we mark the lookup as done.
+	 */
 	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
+	atomic_inc(&pag->pag_active_ref);
 	xfs_mru_cache_done(mp->m_filestream);
 
 	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
@@ -245,19 +266,22 @@ xfs_filestream_select_ag_mru(
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
 
-
 	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 	if (error) {
+		/* We aren't going to use this perag */
+		xfs_perag_rele(pag);
 		if (error != -EAGAIN)
 			return error;
 		*blen = 0;
 	}
 
-	*agno = pag->pag_agno;
-	if (*blen >= args->maxlen)
+	if (*blen >= args->maxlen) {
+		args->pag = pag;
 		return 0;
+	}
 
 	/* Changing parent AG association now, so remove the existing one. */
+	xfs_perag_rele(pag);
 	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
 	if (mru) {
 		struct xfs_fstrm_item *item =
@@ -318,17 +342,12 @@ xfs_filestream_select_ag(
 		flags |= XFS_PICK_LOWSPACE;
 
 	*blen = ap->length;
-	error = xfs_filestream_pick_ag(pip, &agno, flags, blen);
-	if (agno == NULLAGNUMBER) {
-		agno = 0;
-		*blen = 0;
-	}
-
+	error = xfs_filestream_pick_ag(args, pip, agno, flags, blen);
 out_rele:
 	xfs_irele(pip);
 out_select:
 	if (!error)
-		ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
+		ap->blkno = XFS_AGB_TO_FSB(mp, args->pag->pag_agno, 0);
 	return error;
 
 }
-- 
2.35.1

