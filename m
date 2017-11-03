Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38429 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752966AbdKCOqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:05 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdES-0001pE-S0
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:05 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/21] xfs: treat idx as a cursor in xfs_bmap_add_extent_unwritten_real
Date: Fri,  3 Nov 2017 17:45:24 +0300
Message-Id: <20171103144539.2187-7-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 117083b1d1ae..3667fb1f3961 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2152,12 +2152,11 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2191,12 +2190,11 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2226,9 +2224,12 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2280,15 +2281,15 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2319,8 +2320,8 @@ xfs_bmap_add_extent_unwritten_real(
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock += new->br_blockcount;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		xfs_iext_insert(ip, *idx, 1, new, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
@@ -2349,13 +2350,13 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2385,8 +2386,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		old = PREV;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, new, state);
 
@@ -2421,7 +2422,6 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		old = PREV;
 		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
-		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
@@ -2430,6 +2430,7 @@ xfs_bmap_add_extent_unwritten_real(
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
 		r[1].br_state = PREV.br_state;
 
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 2, &r[0], state);
 
-- 
2.14.2

