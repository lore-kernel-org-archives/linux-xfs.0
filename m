Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48521 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdC0IkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:40:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/26] xfs: try any AG when allocating the first btree block when reflinking
Date: Mon, 27 Mar 2017 10:38:37 +0200
Message-Id: <20170327083837.11027-27-hch@lst.de>
In-Reply-To: <20170327083837.11027-1-hch@lst.de>
References: <20170327083837.11027-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 2fcc319d2467a5f5b78f35f79fd6e22741a31b1e upstream.

When a reflink operation causes the bmap code to allocate a btree block
we're currently doing single-AG allocations due to having ->firstblock
set and then try any higher AG due a little reflink quirk we've put in
when adding the reflink code.  But given that we do not have a minleft
reservation of any kind in this AG we can still not have any space in
the same or higher AG even if the file system has enough free space.
To fix this use a XFS_ALLOCTYPE_FIRST_AG allocation in this fall back
path instead.

[And yes, we need to redo this properly instead of piling hacks over
 hacks.  I'm working on that, but it's not going to be a small series.
 In the meantime this fixes the customer reported issue]

Also add a warning for failing allocations to make it easier to debug.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 10 +++++++---
 fs/xfs/libxfs/xfs_bmap_btree.c |  6 +++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eb34879d1a0c..3365ecb9074d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -769,8 +769,8 @@ xfs_bmap_extents_to_btree(
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	} else if (dfops->dop_low) {
-try_another_ag:
 		args.type = XFS_ALLOCTYPE_START_BNO;
+try_another_ag:
 		args.fsbno = *firstblock;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -796,13 +796,17 @@ xfs_bmap_extents_to_btree(
 	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
 	    args.fsbno == NULLFSBLOCK &&
 	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
-		dfops->dop_low = true;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		goto try_another_ag;
 	}
+	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
+		xfs_iroot_realloc(ip, -1, whichfork);
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+		return -ENOSPC;
+	}
 	/*
 	 * Allocation can't fail, the space was reserved.
 	 */
-	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
 	       args.agno >= XFS_FSB_TO_AGNO(mp, *firstblock));
 	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d9be241fc86f..999cc5878890 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -453,8 +453,8 @@ xfs_bmbt_alloc_block(
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
-try_another_ag:
 		args.type = XFS_ALLOCTYPE_START_BNO;
+try_another_ag:
 		/*
 		 * Make sure there is sufficient room left in the AG to
 		 * complete a full tree split for an extent insert.  If
@@ -494,8 +494,8 @@ xfs_bmbt_alloc_block(
 	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
 	    args.fsbno == NULLFSBLOCK &&
 	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
-		cur->bc_private.b.dfops->dop_low = true;
 		args.fsbno = cur->bc_private.b.firstblock;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		goto try_another_ag;
 	}
 
@@ -512,7 +512,7 @@ xfs_bmbt_alloc_block(
 			goto error0;
 		cur->bc_private.b.dfops->dop_low = true;
 	}
-	if (args.fsbno == NULLFSBLOCK) {
+	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
 		return 0;
-- 
2.11.0

