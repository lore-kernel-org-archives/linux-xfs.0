Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16678 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932433AbdKBAQc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 20:16:32 -0400
Date: Wed, 1 Nov 2017 17:16:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/18] xfs: use a b+tree for the in-core extent list
Message-ID: <20171102001627.GO4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-17-hch@lst.de>
 <20171101184725.GJ4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101184725.GJ4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

FWIW the attached crap patch fixes all the fstests failures I saw.

--D

---
 fs/xfs/libxfs/xfs_iext_tree.c |   21 ++++++++++++---------
 fs/xfs/xfs_trace.h            |    1 +
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index c18d344..2aa5651 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -28,17 +28,17 @@
  * In-core extent record layout:
  *
  * +-------+----------------------------+
- * | 00:51 | all 52 bits of startoff    |
- * | 52:63 | low 12 bits of startblock  |
+ * | 00:53 | all 54 bits of startoff    |
+ * | 54:63 | low 10 bits of startblock  |
  * +-------+----------------------------+
  * | 00:20 | all 21 bits of length      |
  * |    21 | unwritten extent bit       |
  * | 22:63 | high 42 bits of startblock |
  * +-------+----------------------------+
  */
-#define XFS_IEXT_STARTOFF_MASK		xfs_mask64lo(52)
-#define XFS_IEXT_LENGTH_MASK		xfs_mask64lo(21)
-#define XFS_IEXT_STARTBLOCK_MASK	xfs_mask64lo(54)
+#define XFS_IEXT_STARTOFF_MASK		xfs_mask64lo(BMBT_STARTOFF_BITLEN)
+#define XFS_IEXT_LENGTH_MASK		xfs_mask64lo(BMBT_BLOCKCOUNT_BITLEN)
+#define XFS_IEXT_STARTBLOCK_MASK	xfs_mask64lo(BMBT_STARTBLOCK_BITLEN)
 
 struct xfs_iext_rec {
 	uint64_t			lo;
@@ -72,8 +74,8 @@ xfs_iext_set(
 	rec->lo = irec->br_startoff & XFS_IEXT_STARTOFF_MASK;
 	rec->hi = irec->br_blockcount & XFS_IEXT_LENGTH_MASK;
 
-	rec->lo |= (irec->br_startblock << 52);
-	rec->hi |= ((irec->br_startblock & ~xfs_mask64lo(12)) << (22 - 12));
+	rec->lo |= (irec->br_startblock << 54);
+	rec->hi |= ((irec->br_startblock & ~xfs_mask64lo(10)) << (22 - 10));
 
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rec->hi |= (1 << 21);
@@ -87,8 +89,8 @@ xfs_iext_get(
 	irec->br_startoff = rec->lo & XFS_IEXT_STARTOFF_MASK;
 	irec->br_blockcount = rec->hi & XFS_IEXT_LENGTH_MASK;
 
-	irec->br_startblock = rec->lo >> 52;
-	irec->br_startblock |= (rec->hi & xfs_mask64hi(42)) >> (22 - 12);
+	irec->br_startblock = rec->lo >> 54;
+	irec->br_startblock |= (rec->hi & xfs_mask64hi(42)) >> (22 - 10);
 
 	if (rec->hi & (1 << 21))
 		irec->br_state = XFS_EXT_UNWRITTEN;
