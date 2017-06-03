Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdFCNLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:50 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/23] xfs: fix indlen accounting error on partial delalloc conversion
Date: Sat,  3 Jun 2017 15:10:54 +0200
Message-Id: <20170603131103.23712-15-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 0daaecacb83bc6b656a56393ab77a31c28139bc7 upstream.

The delalloc -> real block conversion path uses an incorrect
calculation in the case where the middle part of a delalloc extent
is being converted. This is documented as a rare situation because
XFS generally attempts to maximize contiguity by converting as much
of a delalloc extent as possible.

If this situation does occur, the indlen reservation for the two new
delalloc extents left behind by the conversion of the middle range
is calculated and compared with the original reservation. If more
blocks are required, the delta is allocated from the global block
pool. This delta value can be characterized as the difference
between the new total requirement (temp + temp2) and the currently
available reservation minus those blocks that have already been
allocated (startblockval(PREV.br_startblock) - allocated).

The problem is that the current code does not account for previously
allocated blocks correctly. It subtracts the current allocation
count from the (new - old) delta rather than the old indlen
reservation. This means that more indlen blocks than have been
allocated end up stashed in the remaining extents and free space
accounting is broken as a result.

Fix up the calculation to subtract the allocated block count from
the original extent indlen and thus correctly allocate the
reservation delta based on the difference between the new total
requirement and the unused blocks from the original reservation.
Also remove a bogus assert that contradicts the fact that the new
indlen reservation can be larger than the original indlen
reservation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2a426d127e05..6c68f3b888b0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2106,8 +2106,10 @@ xfs_bmap_add_extent_delay_real(
 		}
 		temp = xfs_bmap_worst_indlen(bma->ip, temp);
 		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
-		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+		diff = (int)(temp + temp2 -
+			     (startblockval(PREV.br_startblock) -
+			      (bma->cur ?
+			       bma->cur->bc_private.b.allocated : 0)));
 		if (diff > 0) {
 			error = xfs_mod_fdblocks(bma->ip->i_mount,
 						 -((int64_t)diff), false);
@@ -2164,7 +2166,6 @@ xfs_bmap_add_extent_delay_real(
 		temp = da_new;
 		if (bma->cur)
 			temp += bma->cur->bc_private.b.allocated;
-		ASSERT(temp <= da_old);
 		if (temp < da_old)
 			xfs_mod_fdblocks(bma->ip->i_mount,
 					(int64_t)(da_old - temp), false);
-- 
2.11.0

