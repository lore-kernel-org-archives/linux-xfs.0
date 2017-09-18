Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54207 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbdIRPY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:24:27 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxuM-0005Dp-KE
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:24:26 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/19] xfs: use correct state defines in xfs_bmap_del_extent_{cow,delay}
Date: Mon, 18 Sep 2017 08:24:10 -0700
Message-Id: <20170918152422.24345-8-hch@lst.de>
In-Reply-To: <20170918152422.24345-1-hch@lst.de>
References: <20170918152422.24345-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use the _FILLING values to match the usage in the xfs_bmap_add_extent_*
helpers.  No change in behavior, just better naming in the code and
tracepoint output.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 06f1bd9e144e..aa4af31750d3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4897,19 +4897,19 @@ xfs_bmap_del_extent_delay(
 		state |= BMAP_COWFORK;
 
 	if (got->br_startoff == del->br_startoff)
-		state |= BMAP_LEFT_CONTIG;
+		state |= BMAP_LEFT_FILLING;
 	if (got_endoff == del_endoff)
-		state |= BMAP_RIGHT_CONTIG;
+		state |= BMAP_RIGHT_FILLING;
 
-	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
-	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	switch (state & (BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING)) {
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
 		xfs_iext_remove(ip, *idx, 1, state);
 		--*idx;
 		break;
-	case BMAP_LEFT_CONTIG:
+	case BMAP_LEFT_FILLING:
 		/*
 		 * Deleting the first part of the extent.
 		 */
@@ -4922,7 +4922,7 @@ xfs_bmap_del_extent_delay(
 		xfs_iext_update_extent(ifp, *idx, got);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
-	case BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING:
 		/*
 		 * Deleting the last part of the extent.
 		 */
@@ -5007,19 +5007,19 @@ xfs_bmap_del_extent_cow(
 	ASSERT(!isnullstartblock(got->br_startblock));
 
 	if (got->br_startoff == del->br_startoff)
-		state |= BMAP_LEFT_CONTIG;
+		state |= BMAP_LEFT_FILLING;
 	if (got_endoff == del_endoff)
-		state |= BMAP_RIGHT_CONTIG;
+		state |= BMAP_RIGHT_FILLING;
 
-	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
-	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	switch (state & (BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING)) {
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
 		xfs_iext_remove(ip, *idx, 1, state);
 		--*idx;
 		break;
-	case BMAP_LEFT_CONTIG:
+	case BMAP_LEFT_FILLING:
 		/*
 		 * Deleting the first part of the extent.
 		 */
@@ -5030,7 +5030,7 @@ xfs_bmap_del_extent_cow(
 		xfs_iext_update_extent(ifp, *idx, got);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
-	case BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING:
 		/*
 		 * Deleting the last part of the extent.
 		 */
-- 
2.14.1

