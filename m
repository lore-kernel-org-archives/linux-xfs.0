Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbdIRPY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:24:28 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxuO-0005EB-3i
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:24:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/19] xfs: refactor xfs_bmap_add_extent_hole_delay
Date: Mon, 18 Sep 2017 08:24:13 -0700
Message-Id: <20170918152422.24345-11-hch@lst.de>
In-Reply-To: <20170918152422.24345-1-hch@lst.de>
References: <20170918152422.24345-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
entries in the in-core extent list.  This isolates the function from
the detailed layout of the extent list, and generally makes the code
a lot more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bd00f4d135af..833c76084f38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2701,7 +2701,7 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_filblks_t		oldlen=0;	/* old indirect size */
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			state;  /* state bits, accessed thru macros */
-	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
+	xfs_filblks_t		temp;	 /* temp for indirect calculations */
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	state = 0;
@@ -2764,14 +2764,14 @@ xfs_bmap_add_extent_hole_delay(
 			right.br_blockcount;
 
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx), temp);
 		oldlen = startblockval(left.br_startblock) +
 			startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
 		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 					 oldlen);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx),
-			nullstartblock((int)newlen));
+		left.br_startblock = nullstartblock(newlen);
+		left.br_blockcount = temp;
+		xfs_iext_update_extent(ifp, *idx, &left);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
@@ -2787,13 +2787,13 @@ xfs_bmap_add_extent_hole_delay(
 		temp = left.br_blockcount + new->br_blockcount;
 
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx), temp);
 		oldlen = startblockval(left.br_startblock) +
 			startblockval(new->br_startblock);
 		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 					 oldlen);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx),
-			nullstartblock((int)newlen));
+		left.br_blockcount = temp;
+		left.br_startblock = nullstartblock(newlen);
+		xfs_iext_update_extent(ifp, *idx, &left);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
 
@@ -2809,9 +2809,10 @@ xfs_bmap_add_extent_hole_delay(
 			startblockval(right.br_startblock);
 		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 					 oldlen);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
-			new->br_startoff,
-			nullstartblock((int)newlen), temp, right.br_state);
+		right.br_startoff = new->br_startoff;
+		right.br_startblock = nullstartblock(newlen);
+		right.br_blockcount = temp;
+		xfs_iext_update_extent(ifp, *idx, &right);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
 
-- 
2.14.1

