Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6E1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 06:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiF0GIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 02:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiF0GIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 02:08:47 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 332801148
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 23:08:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 803D15ECD08
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 16:08:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-00BZVw-2n
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 16:08:44 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-0011gK-1C
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 16:08:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: rework xfs_buf_incore() API
Date:   Mon, 27 Jun 2022 16:08:36 +1000
Message-Id: <20220627060841.244226-2-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627060841.244226-1-david@fromorbit.com>
References: <20220627060841.244226-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b9496d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=aRZGPQXhNnvv0aCuIvEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Make it consistent with the other buffer APIs to return a error and
the buffer is placed in a parameter.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 15 ++++++++++-----
 fs/xfs/scrub/repair.c           | 15 +++++++++------
 fs/xfs/xfs_buf.c                | 19 ++-----------------
 fs/xfs/xfs_buf.h                | 20 ++++++++++++++++----
 fs/xfs/xfs_qm.c                 |  9 ++++-----
 5 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 7298c148f848..d440393b40eb 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -543,6 +543,7 @@ xfs_attr_rmtval_stale(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buf		*bp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
@@ -550,14 +551,18 @@ xfs_attr_rmtval_stale(
 	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
 		return -EFSCORRUPTED;
 
-	bp = xfs_buf_incore(mp->m_ddev_targp,
+	error = xfs_buf_incore(mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, map->br_startblock),
-			XFS_FSB_TO_BB(mp, map->br_blockcount), incore_flags);
-	if (bp) {
-		xfs_buf_stale(bp);
-		xfs_buf_relse(bp);
+			XFS_FSB_TO_BB(mp, map->br_blockcount),
+			incore_flags, &bp);
+	if (error) {
+		if (error == -ENOENT)
+			return 0;
+		return error;
 	}
 
+	xfs_buf_stale(bp);
+	xfs_buf_relse(bp);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1e7b6b209ee8..5e7428782571 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -457,16 +457,19 @@ xrep_invalidate_blocks(
 	 * assume it's owned by someone else.
 	 */
 	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
+		int		error;
+
 		/* Skip AG headers and post-EOFS blocks */
 		if (!xfs_verify_fsbno(sc->mp, fsbno))
 			continue;
-		bp = xfs_buf_incore(sc->mp->m_ddev_targp,
+		error = xfs_buf_incore(sc->mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(sc->mp, fsbno),
-				XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
-		if (bp) {
-			xfs_trans_bjoin(sc->tp, bp);
-			xfs_trans_binval(sc->tp, bp);
-		}
+				XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
+		if (error)
+			continue;
+
+		xfs_trans_bjoin(sc->tp, bp);
+		xfs_trans_binval(sc->tp, bp);
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index bf4e60871068..143e1c70df5d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -616,23 +616,6 @@ xfs_buf_find(
 	return 0;
 }
 
-struct xfs_buf *
-xfs_buf_incore(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
-	xfs_buf_flags_t		flags)
-{
-	struct xfs_buf		*bp;
-	int			error;
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-
-	error = xfs_buf_find(target, &map, 1, flags, NULL, &bp);
-	if (error)
-		return NULL;
-	return bp;
-}
-
 /*
  * Assembles a buffer covering the specified range. The code is optimised for
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
@@ -656,6 +639,8 @@ xfs_buf_get_map(
 		goto found;
 	if (error != -ENOENT)
 		return error;
+	if (flags & XBF_INCORE)
+		return -ENOENT;
 
 	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
 	if (error)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1ee3056ff9cf..58e9034d51bd 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -42,9 +42,11 @@ struct xfs_buf;
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
 /* flags used only as arguments to access routines */
+#define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
 #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
+
 typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_FLAGS \
@@ -63,6 +65,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
+	{ XBF_INCORE,		"INCORE" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" }, \
 	{ XBF_UNMAPPED,		"UNMAPPED" }
 
@@ -196,10 +199,6 @@ struct xfs_buf {
 };
 
 /* Finding and Reading Buffers */
-struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
-			   xfs_daddr_t blkno, size_t numblks,
-			   xfs_buf_flags_t flags);
-
 int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
@@ -209,6 +208,19 @@ void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       const struct xfs_buf_ops *ops);
 
+static inline int
+xfs_buf_incore(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+
+	return xfs_buf_get_map(target, &map, 1, XBF_INCORE | flags, bpp);
+}
+
 static inline int
 xfs_buf_get(
 	struct xfs_buftarg	*target,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index abf08bbf34a9..3517a6be8dad 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1229,12 +1229,11 @@ xfs_qm_flush_one(
 	 */
 	if (!xfs_dqflock_nowait(dqp)) {
 		/* buf is pinned in-core by delwri list */
-		bp = xfs_buf_incore(mp->m_ddev_targp, dqp->q_blkno,
-				mp->m_quotainfo->qi_dqchunklen, 0);
-		if (!bp) {
-			error = -EINVAL;
+		error = xfs_buf_incore(mp->m_ddev_targp, dqp->q_blkno,
+				mp->m_quotainfo->qi_dqchunklen, 0, &bp);
+		if (error)
 			goto out_unlock;
-		}
+
 		xfs_buf_unlock(bp);
 
 		xfs_buf_delwri_pushbuf(bp, buffer_list);
-- 
2.36.1

