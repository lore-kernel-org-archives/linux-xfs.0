Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbdJaOWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:52 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRL-0007bl-Sp
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:52 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/18] xfs: treat idx as a cursor in xfs_bmap_add_extent_unwritten_real
Date: Tue, 31 Oct 2017 16:22:18 +0200
Message-Id: <20171031142230.11755-7-hch@lst.de>
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
 fs/xfs/libxfs/xfs_bmap.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7bd27c08981f..10878c495869 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2151,12 +2151,11 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		--*idx;
-
 		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 
-		xfs_iext_remove(ip, *idx + 1, 2, state);
+		xfs_iext_remove(ip, *idx, 2, state);
+		--*idx;
+		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) - 2);
 		if (cur == NULL)
@@ -2190,12 +2189,11 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		--*idx;
-
 		LEFT.br_blockcount += PREV.br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
+		xfs_iext_remove(ip, *idx, 1, state);
+		--*idx;
+		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL)
@@ -2225,9 +2223,12 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		PREV.br_blockcount += RIGHT.br_blockcount;
 		PREV.br_state = new->br_state;
+
+		++*idx;
+		xfs_iext_remove(ip, *idx, 1, state);
+		--*idx;
 		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL)
@@ -2279,15 +2280,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * The left neighbor is contiguous.
 		 */
 		LEFT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx - 1, &LEFT);
 
 		old = PREV;
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock += new->br_blockcount;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		--*idx;
+		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -2318,8 +2319,8 @@ xfs_bmap_add_extent_unwritten_real(
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock += new->br_blockcount;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		xfs_iext_insert(ip, *idx, 1, new, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
@@ -2348,13 +2349,13 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		old = PREV;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
-
-		++*idx;
 
 		RIGHT.br_startoff = new->br_startoff;
 		RIGHT.br_startblock = new->br_startblock;
 		RIGHT.br_blockcount += new->br_blockcount;
+
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
+		++*idx;
 		xfs_iext_update_extent(ip, state, *idx, &RIGHT);
 
 		if (cur == NULL)
@@ -2384,8 +2385,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		old = PREV;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, new, state);
 
@@ -2420,7 +2421,6 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		old = PREV;
 		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
@@ -2429,6 +2429,7 @@ xfs_bmap_add_extent_unwritten_real(
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
 		r[1].br_state = PREV.br_state;
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 2, &r[0], state);
 
-- 
2.14.2

