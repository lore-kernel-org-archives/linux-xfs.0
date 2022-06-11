Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77DDCCA47C
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348166AbiFKB1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348049AbiFKB1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1D443A482B
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E909C5EC7F3
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQF-Fu
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELOC-Dz
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 45/50] xfs: track an active perag reference in filestreams
Date:   Sat, 11 Jun 2022 11:26:54 +1000
Message-Id: <20220611012659.3418072-46-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=L_9vr8Kv_QPSUBxpfoEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than just track the agno of the reference, track a referenced
perag pointer instead. This will allow active filestreams to prevent
AGs from going away until the filestreams have been torn down.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 99 ++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index fcc30e8ebb90..99013a9d3361 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -23,7 +23,7 @@
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
-	xfs_agnumber_t			ag; /* AG in use for this directory */
+	struct xfs_perag		*pag; /* AG in use for this directory */
 };
 
 enum xfs_fstrm_alloc {
@@ -50,43 +50,18 @@ xfs_filestream_peek_ag(
 	return ret;
 }
 
-static int
-xfs_filestream_get_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_inc_return(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
-static void
-xfs_filestream_put_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-
-	pag = xfs_perag_get(mp, agno);
-	atomic_dec(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-}
-
 static void
 xfs_fstrm_free_func(
 	void			*data,
 	struct xfs_mru_cache_elem *mru)
 {
-	struct xfs_mount	*mp = data;
 	struct xfs_fstrm_item	*item =
 		container_of(mru, struct xfs_fstrm_item, mru);
+	struct xfs_perag	*pag = item->pag;
 
-	xfs_filestream_put_ag(mp, item->ag);
-	trace_xfs_filestream_free(mp, mru->key, item->ag);
+	trace_xfs_filestream_free(pag->pag_mount, mru->key, pag->pag_agno);
+	atomic_dec(&pag->pagf_fstrms);
+	xfs_perag_rele(pag);
 
 	kmem_free(item);
 }
@@ -105,11 +80,11 @@ xfs_filestream_pick_ag(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_fstrm_item	*item;
 	struct xfs_perag	*pag;
+	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
 	xfs_agnumber_t		startag = *agp;
 	xfs_agnumber_t		ag = startag;
-	xfs_agnumber_t		max_ag = NULLAGNUMBER;
 	int			err, trylock, nscan;
 
 	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
@@ -125,13 +100,16 @@ xfs_filestream_pick_ag(
 	for (nscan = 0; 1; nscan++) {
 		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
-		pag = xfs_perag_get(mp, ag);
+		err = 0;
+		pag = xfs_perag_grab(mp, ag);
+		if (!pag)
+			goto next_ag;
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
-			xfs_perag_put(pag);
+			xfs_perag_rele(pag);
 			if (err != -EAGAIN)
-				return err;
+				break;
 			/* Couldn't lock the AGF, skip this AG. */
 			goto next_ag;
 		}
@@ -139,7 +117,10 @@ xfs_filestream_pick_ag(
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;
-			max_ag = ag;
+			if (max_pag)
+				xfs_perag_rele(max_pag);
+			atomic_inc(&pag->pag_active_ref);
+			max_pag = pag;
 		}
 
 		/*
@@ -148,8 +129,9 @@ xfs_filestream_pick_ag(
 		 * loop, and it guards against two filestreams being established
 		 * in the same AG as each other.
 		 */
-		if (xfs_filestream_get_ag(mp, ag) > 1) {
-			xfs_filestream_put_ag(mp, ag);
+		if (atomic_inc_return(&pag->pagf_fstrms) > 1) {
+			atomic_dec(&pag->pagf_fstrms);
+			xfs_perag_rele(pag);
 			goto next_ag;
 		}
 
@@ -161,15 +143,12 @@ xfs_filestream_pick_ag(
 
 			/* Break out, retaining the reference on the AG. */
 			free = pag->pagf_freeblks;
-			xfs_perag_put(pag);
-			*agp = ag;
 			break;
 		}
 
 		/* Drop the reference on this AG, it's not usable. */
-		xfs_filestream_put_ag(mp, ag);
+		atomic_dec(&pag->pagf_fstrms);
 next_ag:
-		xfs_perag_put(pag);
 		/* Move to the next AG, wrapping to AG 0 if necessary. */
 		if (++ag >= mp->m_sb.sb_agcount)
 			ag = 0;
@@ -194,10 +173,10 @@ xfs_filestream_pick_ag(
 		 * Take the AG with the most free space, regardless of whether
 		 * it's already in use by another filestream.
 		 */
-		if (max_ag != NULLAGNUMBER) {
-			xfs_filestream_get_ag(mp, max_ag);
+		if (max_pag) {
+			pag = max_pag;
+			atomic_inc(&pag->pagf_fstrms);
 			free = maxfree;
-			*agp = max_ag;
 			break;
 		}
 
@@ -207,17 +186,26 @@ xfs_filestream_pick_ag(
 		return 0;
 	}
 
-	trace_xfs_filestream_pick(ip, *agp, free, nscan);
+	trace_xfs_filestream_pick(ip, pag ? pag->pag_agno : NULLAGNUMBER,
+			free, nscan);
+
+	if (max_pag)
+		xfs_perag_rele(max_pag);
 
-	if (*agp == NULLAGNUMBER)
+	if (err)
+		return err;
+
+	if (!pag) {
+		*agp = NULLAGNUMBER;
 		return 0;
+	}
 
 	err = -ENOMEM;
 	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
 	if (!item)
 		goto out_put_ag;
 
-	item->ag = *agp;
+	item->pag = pag;
 
 	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
 	if (err) {
@@ -226,12 +214,14 @@ xfs_filestream_pick_ag(
 		goto out_free_item;
 	}
 
+	*agp = pag->pag_agno;
 	return 0;
 
 out_free_item:
 	kmem_free(item);
 out_put_ag:
-	xfs_filestream_put_ag(mp, *agp);
+	atomic_dec(&pag->pagf_fstrms);
+	xfs_perag_rele(pag);
 	return err;
 }
 
@@ -285,26 +275,23 @@ xfs_filestream_select_ag_mru(
 	if (!mru)
 		goto out_default_agno;
 
-	*agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
 	xfs_mru_cache_done(mp->m_filestream);
 
-	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, *agno);
+	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, pag->pag_agno);
 
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, *agno, 0);
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
 
-	pag = xfs_perag_grab(mp, *agno);
-	if (!pag)
-		goto out_default_agno;
 
 	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	xfs_perag_rele(pag);
 	if (error) {
 		if (error != -EAGAIN)
 			return error;
 		*blen = 0;
 	}
 
+	*agno = pag->pag_agno;
 	if (*blen >= args->maxlen)
 		return 0;
 
@@ -313,7 +300,7 @@ xfs_filestream_select_ag_mru(
 	if (mru) {
 		struct xfs_fstrm_item *item =
 			container_of(mru, struct xfs_fstrm_item, mru);
-		*agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+		*agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
 		xfs_fstrm_free_func(mp, mru);
 		return 0;
 	}
-- 
2.35.1

