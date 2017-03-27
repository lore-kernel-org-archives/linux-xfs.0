Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54927 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdC0IkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:40:05 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/26] xfs: tune down agno asserts in the bmap code
Date: Mon, 27 Mar 2017 10:38:32 +0200
Message-Id: <20170327083837.11027-22-hch@lst.de>
In-Reply-To: <20170327083837.11027-1-hch@lst.de>
References: <20170327083837.11027-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 410d17f67e583559be3a922f8b6cc336331893f3 upstream.

In various places we currently assert that xfs_bmap_btalloc allocates
from the same as the firstblock value passed in, unless it's either
NULLAGNO or the dop_low flag is set.  But the reflink code does not
fully follow this convention as it passes in firstblock purely as
a hint for the allocator without actually having previous allocations
in the transaction, and without having a minleft check on the current
AG, leading to the assert firing on a very full and heavily used
file system.  As even the reflink code only allocates from equal or
higher AGs for now we can simply the check to always allow for equal
or higher AGs.

Note that we need to eventually split the two meanings of the firstblock
value.  At that point we can also allow the reflink code to allocate
from any AG instead of limiting it in any way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0eece4c13500..9224dd96231c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -804,9 +804,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
-	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
-	       (dfops->dop_low &&
-		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
+	       args.agno >= XFS_FSB_TO_AGNO(mp, *firstblock));
 	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
@@ -3832,17 +3830,13 @@ xfs_bmap_btalloc(
 		 * the first block that was allocated.
 		 */
 		ASSERT(*ap->firstblock == NULLFSBLOCK ||
-		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
-		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
-		       (ap->dfops->dop_low &&
-			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
-			XFS_FSB_TO_AGNO(mp, args.fsbno)));
+		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) <=
+		       XFS_FSB_TO_AGNO(mp, args.fsbno));
 
 		ap->blkno = args.fsbno;
 		if (*ap->firstblock == NULLFSBLOCK)
 			*ap->firstblock = args.fsbno;
-		ASSERT(nullfb || fb_agno == args.agno ||
-		       (ap->dfops->dop_low && fb_agno < args.agno));
+		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		if (!(ap->flags & XFS_BMAPI_COWFORK))
 			ap->ip->i_d.di_nblocks += args.len;
@@ -4764,13 +4758,9 @@ xfs_bmapi_write(
 	if (bma.cur) {
 		if (!error) {
 			ASSERT(*firstblock == NULLFSBLOCK ||
-			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
+			       XFS_FSB_TO_AGNO(mp, *firstblock) <=
 			       XFS_FSB_TO_AGNO(mp,
-				       bma.cur->bc_private.b.firstblock) ||
-			       (dfops->dop_low &&
-				XFS_FSB_TO_AGNO(mp, *firstblock) <
-				XFS_FSB_TO_AGNO(mp,
-					bma.cur->bc_private.b.firstblock)));
+				       bma.cur->bc_private.b.firstblock));
 			*firstblock = bma.cur->bc_private.b.firstblock;
 		}
 		xfs_btree_del_cursor(bma.cur,
-- 
2.11.0

