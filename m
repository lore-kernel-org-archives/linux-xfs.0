Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26834 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbcJAGsJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Oct 2016 02:48:09 -0400
Subject: [PATCH 1/2] xfs_repair: fix bogosity when rmapping new AGFL blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 30 Sep 2016 23:48:04 -0700
Message-ID: <147530448401.24875.346384552420962839.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

When repair rebuilds the AGFL, the blocks can come either from the
in-core free space tree or they can come as a result of overestimating
the number of blocks needed to rebuild the on-disk free space btree.
The code in here was trying to only create rmap records for AGFL blocks
that did /not/ come from free space btree rebuild overestimation, but
was totally broken.  The initial and check conditions were totally wrong
if there was any overflow.  Remove a stray debug printf too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 0baf4eb..645af31 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -505,10 +505,18 @@ rmap_store_ag_btree_rec(
 	if (error)
 		goto err;
 
+	/*
+	 * Sometimes, the blocks at the beginning of the AGFL are there
+	 * because we overestimated how many blocks we needed to rebuild
+	 * the freespace btrees.  ar_flcount records the number of
+	 * blocks in this situation.  Since those blocks already have an
+	 * rmap, we only need to add rmap records for AGFL blocks past
+	 * that point in the AGFL because those blocks are a result of a
+	 * no-rmap no-shrink freelist fixup that we did earlier.
+	 */
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
-	agfl_bno += ag_rmaps[agno].ar_flcount;
-	b = agfl_bno;
-	while (*b != NULLAGBLOCK && b - agfl_bno <= XFS_AGFL_SIZE(mp)) {
+	b = agfl_bno + ag_rmaps[agno].ar_flcount;
+	while (*b != NULLAGBLOCK && b - agfl_bno < XFS_AGFL_SIZE(mp)) {
 		error = rmap_add_ag_rec(mp, agno, be32_to_cpu(*b), 1,
 				XFS_RMAP_OWN_AG);
 		if (error)
@@ -566,7 +574,6 @@ rmap_store_ag_btree_rec(
 err:
 	if (agflbp)
 		libxfs_putbuf(agflbp);
-	printf("FAIL err %d\n", error);
 	return error;
 }
 

