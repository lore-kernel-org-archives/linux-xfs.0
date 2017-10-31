Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45228 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdJaOW6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:58 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRR-0007cK-Oz
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:58 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/18] xfs: treat idx as a cursor in xfs_bmap_collapse_extents
Date: Tue, 31 Oct 2017 16:22:20 +0200
Message-Id: <20171031142230.11755-9-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5ba0c0368629..14428d72cf33 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5516,7 +5516,7 @@ xfs_bmse_merge(
 	struct xfs_inode		*ip,
 	int				whichfork,
 	xfs_fileoff_t			shift,		/* shift fsb */
-	int				current_ext,	/* idx of gotp */
+	int				*current_ext,	/* idx of gotp */
 	struct xfs_bmbt_irec		*got,		/* extent to shift */
 	struct xfs_bmbt_irec		*left,		/* preceding extent */
 	struct xfs_btree_cur		*cur,
@@ -5571,9 +5571,10 @@ xfs_bmse_merge(
 		return error;
 
 done:
+	xfs_iext_remove(ip, *current_ext, 1, 0);
+	--*current_ext;
 	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
-			current_ext - 1, &new);
-	xfs_iext_remove(ip, current_ext, 1, 0);
+			*current_ext, &new);
 
 	/* update reverse mapping. rmap functions merge the rmaps for us */
 	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
@@ -5687,16 +5688,10 @@ xfs_bmap_collapse_extents(
 
 		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
 			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
-					current_ext, &got, &prev, cur,
+					&current_ext, &got, &prev, cur,
 					&logflags, dfops);
 			if (error)
 				goto del_cursor;
-
-			/* update got after merge */
-			if (!xfs_iext_get_extent(ifp, current_ext, &got)) {
-				*done = true;
-				goto del_cursor;
-			}
 			goto done;
 		}
 	} else {
@@ -5711,12 +5706,12 @@ xfs_bmap_collapse_extents(
 	if (error)
 		goto del_cursor;
 
+done:
 	if (!xfs_iext_get_extent(ifp, ++current_ext, &got)) {
 		 *done = true;
 		 goto del_cursor;
 	}
 
-done:
 	*next_fsb = got.br_startoff;
 del_cursor:
 	if (cur)
-- 
2.14.2

