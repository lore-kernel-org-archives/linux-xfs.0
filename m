Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18644 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756954AbdELAyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 20:54:24 -0400
Date: Thu, 11 May 2017 17:53:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix warnings about unused stack variables
Message-ID: <20170512005352.GF4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

Reduce stack usage and get rid of compiler warnings by eliminating
unused variables.  The variables were eliminated during one of
Christoph's cleanups for 4.12.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8adb91b..a7048eaf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1280,7 +1280,6 @@ xfs_bmap_read_extents(
 		xfs_bmbt_rec_t	*frp;
 		xfs_fsblock_t	nextbno;
 		xfs_extnum_t	num_recs;
-		xfs_extnum_t	start;
 
 		num_recs = xfs_btree_get_numrecs(block);
 		if (unlikely(i + num_recs > room)) {
@@ -1303,7 +1302,6 @@ xfs_bmap_read_extents(
 		 * Copy records into the extent records.
 		 */
 		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
-		start = i;
 		for (j = 0; j < num_recs; j++, i++, frp++) {
 			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
 			trp->l0 = be64_to_cpu(frp->l0);
