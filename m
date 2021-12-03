Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255CEC4167E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349732AbhLCAEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:45 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36169 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377732AbhLCAEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:44 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C5472869D6F
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:17 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1Kx-22
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bkhy-0w
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/36] xfs: introduce xfs_for_each_perag_wrap()
Date:   Fri,  3 Dec 2021 11:00:57 +1100
Message-Id: <20211203000111.2800982-23-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e4e
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=MV_ybV5dVvQxcgh8FT0A:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In several places we iterate every AG from a specific start agno and
wrap back to the first AG when we reach the end of the filesystem to
continue searching. We don't have a primitive for this iteration
yet, so add one for conversion of these algorithms to per-ag based
iteration.

The filestream AG select code is a mess, and this initially makes it
worse. The per-ag selection needs to be driven completely into the
filesystem code to clean this up and it will be done in a future
patch that makes the filestream allocator use active per-ag
references correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h     | 45 +++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.c   | 76 ++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++--------
 3 files changed, 104 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 3b5e9c5f737b..23040a1094b9 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -228,7 +228,6 @@ xfs_perag_next(
 #define for_each_perag_from(mp, agno, pag) \
 	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
-
 #define for_each_perag(mp, agno, pag) \
 	(agno) = 0; \
 	for_each_perag_from((mp), (agno), (pag))
@@ -240,6 +239,50 @@ xfs_perag_next(
 		xfs_perag_rele(pag), \
 		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
 
+static inline struct xfs_perag *
+xfs_perag_next_wrap(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		stop_agno,
+	xfs_agnumber_t		wrap_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*agno = pag->pag_agno + 1;
+	xfs_perag_rele(pag);
+	while (*agno != stop_agno) {
+		if (*agno >= wrap_agno)
+			*agno = 0;
+		if (*agno == stop_agno)
+			break;
+
+		pag = xfs_perag_grab(mp, *agno);
+		if (pag)
+			return pag;
+		(*agno)++;
+	}
+	return NULL;
+}
+
+/*
+ * Iterate all AGs from start_agno through wrap_agno, then 0 through
+ * (start_agno - 1).
+ */
+#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
+	for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
+		(pag) != NULL; \
+		(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
+				(wrap_agno)))
+
+/*
+ * Iterate all AGs from start_agno through to the end of the filesystem, then 0
+ * through (start_agno - 1).
+ */
+#define for_each_perag_wrap(mp, start_agno, agno, pag) \
+	for_each_perag_wrap_at((mp), (start_agno), (mp)->m_sb.sb_agcount, \
+				(agno), (pag))
+
+
 struct aghdr_init_data {
 	/* per ag data */
 	xfs_agblock_t		agno;		/* ag to init */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3369cbfbb9f1..e9e039d8ba62 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3175,17 +3175,14 @@ xfs_bmap_adjacent(
 
 static int
 xfs_bmap_longest_free_extent(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		ag,
 	xfs_extlen_t		*blen,
 	int			*notinit)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
 	xfs_extlen_t		longest;
 	int			error = 0;
 
-	pag = xfs_perag_get(mp, ag);
 	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
@@ -3195,19 +3192,17 @@ xfs_bmap_longest_free_extent(
 				*notinit = 1;
 				error = 0;
 			}
-			goto out;
+			return error;
 		}
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(mp, pag),
+				xfs_alloc_min_freelist(pag->pag_mount, pag),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
 
-out:
-	xfs_perag_put(pag);
-	return error;
+	return 0;
 }
 
 static void
@@ -3245,28 +3240,29 @@ xfs_bmap_btalloc_nullfb(
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-	xfs_agnumber_t		ag, startag;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno, startag;
 	int			notinit = 0;
-	int			error;
+	int			error = 0;
 
 	args->type = XFS_ALLOCTYPE_START_BNO;
 	args->total = ap->total;
 
-	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	if (startag == NULLAGNUMBER)
-		startag = ag = 0;
+		startag = 0;
 
-	while (*blen < args->maxlen) {
-		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
+	*blen = 0;
+	for_each_perag_wrap(mp, startag, agno, pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
 						     &notinit);
 		if (error)
-			return error;
-
-		if (++ag == mp->m_sb.sb_agcount)
-			ag = 0;
-		if (ag == startag)
+			break;
+		if (*blen >= args->maxlen)
 			break;
 	}
+	if (pag)
+		xfs_perag_rele(pag);
 
 	xfs_bmap_select_minlen(ap, args, blen, notinit);
 	return 0;
@@ -3279,40 +3275,58 @@ xfs_bmap_btalloc_filestreams(
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-	xfs_agnumber_t		ag;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		start_agno;
 	int			notinit = 0;
 	int			error;
 
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
-	ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	if (ag == NULLAGNUMBER)
-		ag = 0;
+	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (start_agno == NULLAGNUMBER)
+		start_agno = 0;
 
-	error = xfs_bmap_longest_free_extent(args->tp, ag, blen, &notinit);
-	if (error)
-		return error;
+	pag = xfs_perag_grab(mp, start_agno);
+	if (pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
+				&notinit);
+		xfs_perag_rele(pag);
+		if (error)
+			return error;
+	}
 
 	if (*blen < args->maxlen) {
-		error = xfs_filestream_new_ag(ap, &ag);
+		xfs_agnumber_t	agno = start_agno;
+
+		error = xfs_filestream_new_ag(ap, &agno);
 		if (error)
 			return error;
+		if (agno == NULLAGNUMBER)
+			goto out_select;
 
-		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
-						     &notinit);
+		pag = xfs_perag_grab(mp, agno);
+		if (!pag)
+			goto out_select;
+
+		error = xfs_bmap_longest_free_extent(pag, args->tp,
+				blen, &notinit);
+		xfs_perag_rele(pag);
 		if (error)
 			return error;
 
+		start_agno = agno;
+
 	}
 
+out_select:
 	xfs_bmap_select_minlen(ap, args, blen, notinit);
 
 	/*
 	 * Set the failure fallback case to look in the selected AG as stream
 	 * may have moved.
 	 */
-	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c98fffef891e..a155b3cc1e14 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1724,7 +1724,7 @@ xfs_dialloc(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			ok_alloc = true;
 	int			flags;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 
 	/*
 	 * Directories, symlinks, and regular files frequently allocate at least
@@ -1758,37 +1758,35 @@ xfs_dialloc(
 	 * or in which we can allocate some inodes.  Iterate through the
 	 * allocation groups upward, wrapping at the end.
 	 */
-	agno = start_agno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
-	for (;;) {
-		pag = xfs_perag_grab(mp, agno);
+retry:
+	for_each_perag_wrap_at(mp, start_agno, mp->m_maxagi, agno, pag) {
 		if (xfs_dialloc_good_ag(pag, *tpp, mode, flags, ok_alloc)) {
 			error = xfs_dialloc_try_ag(pag, tpp, parent,
 					&ino, ok_alloc);
 			if (error != -EAGAIN)
 				break;
+			error = 0;
 		}
 
 		if (xfs_is_shutdown(mp)) {
 			error = -EFSCORRUPTED;
 			break;
 		}
-		if (++agno == mp->m_maxagi)
-			agno = 0;
-		if (agno == start_agno) {
-			if (!flags) {
-				error = -ENOSPC;
-				break;
-			}
+	}
+	if (pag)
+		xfs_perag_rele(pag);
+	if (error)
+		return error;
+	if (ino == NULLFSINO) {
+		if (flags) {
 			flags = 0;
+			goto retry;
 		}
-		xfs_perag_rele(pag);
+		return -ENOSPC;
 	}
-
-	if (!error)
-		*new_ino = ino;
-	xfs_perag_rele(pag);
-	return error;
+	*new_ino = ino;
+	return 0;
 }
 
 /*
-- 
2.33.0

