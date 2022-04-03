Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3B1C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 12:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbiDCMDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 08:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiDCMDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 08:03:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC7B2E9D2
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 05:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=O+ieKZmwwLt07ZpQlJtAH3Ooz+9spqv6973QnV5aDtQ=; b=OAb3/tSAjpF3R5xL0BcmR4hOrs
        dRkgH3B/OohbrQ8wzDWgZW5fzHGKPhmeWBY8jLe2HxJTmtLei4NIK++ir6syGnmygAM2P6EFhxiuG
        w8OTI3SRRrQ/mgdQ9Ocz8nVLVEOoD/YIo1RWgdxsys07hOyhH0wZEww0ChQwh77oVcc1ilVHuAvOH
        V3zZIMn2ZTytGc+Gy1ooKGMQw2AY+zlTidz/eanK0A5v/L3H+kexogBGFJ+QoS+TPRgklDwGFnlE5
        yXHU7K0F/j2/90DxN1gE2VADT7uHwqZddWgA9/xKaAq46+TKVulBZfb/d5lFvt7CyfcnSeBx9Hq3n
        vY0j4t/Q==;
Received: from [2001:4bb8:184:7553:31f9:976f:c3b1:7920] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nayvA-00BK2Y-3v; Sun, 03 Apr 2022 12:01:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: replace xfs_buf_incore with an XBF_NOALLOC flag to xfs_buf_get*
Date:   Sun,  3 Apr 2022 14:01:16 +0200
Message-Id: <20220403120119.235457-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220403120119.235457-1-hch@lst.de>
References: <20220403120119.235457-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the special purpose xfs_buf_incore interface with a new
XBF_NOALLOC flag for the xfs_buf_get* routines.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  6 +++---
 fs/xfs/scrub/repair.c           |  6 +++---
 fs/xfs/xfs_buf.c                | 22 +++-------------------
 fs/xfs/xfs_buf.h                |  5 +----
 fs/xfs/xfs_qm.c                 |  6 +++---
 5 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3fc62ff92441d5..9aff2ce203c9b6 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -550,10 +550,10 @@ xfs_attr_rmtval_stale(
 	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
 		return -EFSCORRUPTED;
 
-	bp = xfs_buf_incore(mp->m_ddev_targp,
+	if (!xfs_buf_get(mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, map->br_startblock),
-			XFS_FSB_TO_BB(mp, map->br_blockcount), incore_flags);
-	if (bp) {
+			XFS_FSB_TO_BB(mp, map->br_blockcount),
+			incore_flags | XBF_NOALLOC, &bp)) {
 		xfs_buf_stale(bp);
 		xfs_buf_relse(bp);
 	}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1e7b6b209ee89a..d4e0fcbc1487a1 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -460,10 +460,10 @@ xrep_invalidate_blocks(
 		/* Skip AG headers and post-EOFS blocks */
 		if (!xfs_verify_fsbno(sc->mp, fsbno))
 			continue;
-		bp = xfs_buf_incore(sc->mp->m_ddev_targp,
+		if (!xfs_buf_get(sc->mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(sc->mp, fsbno),
-				XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
-		if (bp) {
+				XFS_FSB_TO_BB(sc->mp, 1),
+				XBF_NOALLOC | XBF_TRYLOCK, &bp)) {
 			xfs_trans_bjoin(sc->tp, bp);
 			xfs_trans_binval(sc->tp, bp);
 		}
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e1afb9e503e167..0951b7cbd79675 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -227,7 +227,8 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_NOALLOC | XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC |
+		   XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -616,23 +617,6 @@ xfs_buf_find(
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
@@ -654,7 +638,7 @@ xfs_buf_get_map(
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
 	if (!error)
 		goto found;
-	if (error != -ENOENT)
+	if (error != -ENOENT || (flags & XBF_NOALLOC))
 		return error;
 
 	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index ed7ee674216037..a28a2c5a496ab5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -42,6 +42,7 @@ struct xfs_buf;
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
 
 /* flags used only as arguments to access routines */
+#define XBF_NOALLOC	 (1 << 29)/* do not allocate buffer if not found */
 #define XBF_TRYLOCK	 (1 << 30)/* lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1 << 31)/* do not map the buffer */
 
@@ -196,10 +197,6 @@ struct xfs_buf {
 };
 
 /* Finding and Reading Buffers */
-struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
-			   xfs_daddr_t blkno, size_t numblks,
-			   xfs_buf_flags_t flags);
-
 int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f165d1a3de1d1d..9325170a3e18b3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1238,9 +1238,9 @@ xfs_qm_flush_one(
 	 */
 	if (!xfs_dqflock_nowait(dqp)) {
 		/* buf is pinned in-core by delwri list */
-		bp = xfs_buf_incore(mp->m_ddev_targp, dqp->q_blkno,
-				mp->m_quotainfo->qi_dqchunklen, 0);
-		if (!bp) {
+		if (xfs_buf_get(mp->m_ddev_targp, dqp->q_blkno,
+				mp->m_quotainfo->qi_dqchunklen,
+				XBF_NOALLOC, &bp)) {
 			error = -EINVAL;
 			goto out_unlock;
 		}
-- 
2.30.2

