Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB70AC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348229AbiFKB1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349279AbiFKB1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:22 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34A433A4823
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8A5BC10E7216
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQH-Gs
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELOH-FE
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 46/50] xfs: use for_each_perag_wrap in xfs_filestream_pick_ag
Date:   Sat, 11 Jun 2022 11:26:55 +1000
Message-Id: <20220611012659.3418072-47-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=ujRYxpyJSx5Mmk0jHOIA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_filestream_pick_ag() is now ready to rework to use
for_each_perag_wrap() for iterating the perags during the AG
selection scan.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 101 ++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 99013a9d3361..7b540898062e 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -83,9 +83,9 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
-	xfs_agnumber_t		startag = *agp;
-	xfs_agnumber_t		ag = startag;
-	int			err, trylock, nscan;
+	xfs_agnumber_t		start_agno = *agp;
+	xfs_agnumber_t		agno;
+	int			err, trylock;
 
 	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
 
@@ -97,13 +97,9 @@ xfs_filestream_pick_ag(
 	/* For the first pass, don't sleep trying to init the per-AG. */
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
-	for (nscan = 0; 1; nscan++) {
-		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
-
-		err = 0;
-		pag = xfs_perag_grab(mp, ag);
-		if (!pag)
-			goto next_ag;
+restart:
+	for_each_perag_wrap(mp, start_agno, agno, pag) {
+		trace_xfs_filestream_scan(mp, ip->i_ino, agno);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -111,6 +107,7 @@ xfs_filestream_pick_ag(
 			if (err != -EAGAIN)
 				break;
 			/* Couldn't lock the AGF, skip this AG. */
+			err = 0;
 			goto next_ag;
 		}
 
@@ -129,77 +126,61 @@ xfs_filestream_pick_ag(
 		 * loop, and it guards against two filestreams being established
 		 * in the same AG as each other.
 		 */
-		if (atomic_inc_return(&pag->pagf_fstrms) > 1) {
-			atomic_dec(&pag->pagf_fstrms);
-			xfs_perag_rele(pag);
-			goto next_ag;
-		}
-
-		if (((minlen && *longest >= minlen) ||
-		     (!minlen && pag->pagf_freeblks >= minfree)) &&
-		    (!xfs_perag_prefers_metadata(pag) ||
-		     !(flags & XFS_PICK_USERDATA) ||
-		     (flags & XFS_PICK_LOWSPACE))) {
-
-			/* Break out, retaining the reference on the AG. */
-			free = pag->pagf_freeblks;
-			break;
+		if (atomic_inc_return(&pag->pagf_fstrms) <= 1) {
+			if (((minlen && *longest >= minlen) ||
+			     (!minlen && pag->pagf_freeblks >= minfree)) &&
+			    (!xfs_perag_prefers_metadata(pag) ||
+			     !(flags & XFS_PICK_USERDATA) ||
+			     (flags & XFS_PICK_LOWSPACE))) {
+				/* Break out, retaining the reference on the AG. */
+				free = pag->pagf_freeblks;
+				break;
+			}
 		}
 
 		/* Drop the reference on this AG, it's not usable. */
 		atomic_dec(&pag->pagf_fstrms);
-next_ag:
-		/* Move to the next AG, wrapping to AG 0 if necessary. */
-		if (++ag >= mp->m_sb.sb_agcount)
-			ag = 0;
+	}
 
-		/* If a full pass of the AGs hasn't been done yet, continue. */
-		if (ag != startag)
-			continue;
+	if (err) {
+		xfs_perag_rele(pag);
+		if (max_pag)
+			xfs_perag_rele(max_pag);
+		return err;
+	}
 
+	if (!pag) {
 		/* Allow sleeping in xfs_alloc_read_agf() on the 2nd pass. */
-		if (trylock != 0) {
+		if (trylock) {
 			trylock = 0;
-			continue;
+			goto restart;
 		}
 
 		/* Finally, if lowspace wasn't set, set it for the 3rd pass. */
 		if (!(flags & XFS_PICK_LOWSPACE)) {
 			flags |= XFS_PICK_LOWSPACE;
-			continue;
+			goto restart;
 		}
 
 		/*
-		 * Take the AG with the most free space, regardless of whether
-		 * it's already in use by another filestream.
+		 * No unassociated AGs are available, so select the AG with the
+		 * most free space, regardless of whether it's already in use by
+		 * another filestream. It none suit, return NULLAGNUMBER.
 		 */
-		if (max_pag) {
-			pag = max_pag;
-			atomic_inc(&pag->pagf_fstrms);
-			free = maxfree;
-			break;
+		if (!max_pag) {
+			*agp = NULLAGNUMBER;
+			trace_xfs_filestream_pick(ip, *agp, free, 0);
+			return 0;
 		}
-
-		/* take AG 0 if none matched */
-		trace_xfs_filestream_pick(ip, *agp, free, nscan);
-		*agp = 0;
-		return 0;
-	}
-
-	trace_xfs_filestream_pick(ip, pag ? pag->pag_agno : NULLAGNUMBER,
-			free, nscan);
-
-	if (max_pag)
+		pag = max_pag;
+		free = maxfree;
+		atomic_inc(&pag->pagf_fstrms);
+	} else if (max_pag) {
 		xfs_perag_rele(max_pag);
-
-	if (err)
-		return err;
-
-	if (!pag) {
-		*agp = NULLAGNUMBER;
-		return 0;
 	}
 
+	trace_xfs_filestream_pick(ip, pag->pag_agno, free, 0);
+
 	err = -ENOMEM;
 	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
 	if (!item)
-- 
2.35.1

