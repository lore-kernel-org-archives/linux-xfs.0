Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43831 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753984AbdJSOWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:22:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/18] xfs: move two more RT specific functions into CONFIG_XFS_RT
Date: Thu, 19 Oct 2017 16:21:23 +0200
Message-Id: <20171019142123.18109-19-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Arnd Bergmann <arnd@arndb.de>

commit 785545c8982604fe3ba79d16409e83993be77d5e upstream.

The last cleanup introduced two harmless warnings:

fs/xfs/xfs_fsmap.c:480:1: warning: '__xfs_getfsmap_rtdev' defined but not used
fs/xfs/xfs_fsmap.c:372:1: warning: 'xfs_getfsmap_rtdev_rtbitmap_helper' defined but not used

This moves those two functions as well.

Fixes: bb9c2e543325 ("xfs: move more RT specific code under CONFIG_XFS_RT")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 560e0b40ac1b..43cfc07996a4 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -367,29 +367,6 @@ xfs_getfsmap_datadev_helper(
 	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
 }
 
-/* Transform a rtbitmap "record" into a fsmap */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap_helper(
-	struct xfs_trans		*tp,
-	struct xfs_rtalloc_rec		*rec,
-	void				*priv)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_getfsmap_info	*info = priv;
-	struct xfs_rmap_irec		irec;
-	xfs_daddr_t			rec_daddr;
-
-	rec_daddr = XFS_FSB_TO_BB(mp, rec->ar_startblock);
-
-	irec.rm_startblock = rec->ar_startblock;
-	irec.rm_blockcount = rec->ar_blockcount;
-	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
-	irec.rm_offset = 0;
-	irec.rm_flags = 0;
-
-	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
-}
-
 /* Transform a bnobt irec into a fsmap */
 STATIC int
 xfs_getfsmap_datadev_bnobt_helper(
@@ -475,6 +452,30 @@ xfs_getfsmap_logdev(
 	return xfs_getfsmap_helper(tp, info, &rmap, 0);
 }
 
+#ifdef CONFIG_XFS_RT
+/* Transform a rtbitmap "record" into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap_helper(
+	struct xfs_trans		*tp,
+	struct xfs_rtalloc_rec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_getfsmap_info	*info = priv;
+	struct xfs_rmap_irec		irec;
+	xfs_daddr_t			rec_daddr;
+
+	rec_daddr = XFS_FSB_TO_BB(mp, rec->ar_startblock);
+
+	irec.rm_startblock = rec->ar_startblock;
+	irec.rm_blockcount = rec->ar_blockcount;
+	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
+	irec.rm_offset = 0;
+	irec.rm_flags = 0;
+
+	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
+}
+
 /* Execute a getfsmap query against the realtime device. */
 STATIC int
 __xfs_getfsmap_rtdev(
@@ -521,7 +522,6 @@ __xfs_getfsmap_rtdev(
 	return query_fn(tp, info);
 }
 
-#ifdef CONFIG_XFS_RT
 /* Actually query the realtime bitmap. */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_query(
-- 
2.14.2

