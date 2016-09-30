Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41927 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935036AbcI3DGi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:06:38 -0400
Subject: [PATCH 09/63] xfs: account for the refcount btree in the alloc/free
 log reservation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:06:32 -0700
Message-ID: <147520479281.29434.9893645386740502.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Every time we allocate or free a data extent, we might need to split
the refcount btree.  Reserve some blocks in the transaction to handle
this possibility.  Even though the deferred refcount code can roll a
transaction to avoid overloading the transaction, we can still exceed
the reservation.

Certain pathological workloads (1k blocks, no cowextsize hint, random
directio writes), cause a perfect storm wherein a refcount adjustment
of a large range of blocks causes full tree splits in two separate
extents in two separate refcount tree blocks; allocating new refcount
tree blocks causes rmap btree splits; and all the allocation activity
causes the freespace btrees to split, blowing the reservation.

(Reproduced by generic/167 over NFS atop XFS)

Signed-off-by: Christoph Hellwig <hch@lst.de>
[darrick.wong@oracle.com: add commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 7c840e1..a59838f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -67,7 +67,8 @@ xfs_calc_buf_res(
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating an extent.  In classic XFS there were two trees that will be
  * modified (bnobt + cntbt).  With rmap enabled, there are three trees
- * (rmapbt).  The number of blocks reserved is based on the formula:
+ * (rmapbt).  With reflink, there are four trees (refcountbt).  The number of
+ * blocks reserved is based on the formula:
  *
  * num trees * ((2 blocks/level * max depth) - 1)
  *
@@ -83,6 +84,8 @@ xfs_allocfree_log_count(
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
 }

