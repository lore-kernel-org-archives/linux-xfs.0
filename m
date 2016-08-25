Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C03280E8
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:47:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 32D698F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Nlxyg7giCc2vewj5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:39 -0700 (PDT)
Subject: [PATCH 10/71] xfs: account for the refcount btree in the alloc/free
	log reservation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:47:34 -0700
Message-ID: <147216885471.4420.4863290735646572937.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Every time we allocate or free an extent, we might need to split the
refcount btree.  Reserve some blocks in the transaction to handle
this possibility.

(Reproduced by generic/167 over NFS atop XFS)

Signed-off-by: Christoph Hellwig <hch@lst.de>
[darrick.wong@oracle.com: add commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_trans_resv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 10234bb..5b6bbcd 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -66,7 +66,8 @@ xfs_calc_buf_res(
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating an extent.  In classic XFS there were two trees that will be
  * modified (bnobt + cntbt).  With rmap enabled, there are three trees
- * (rmapbt).  The number of blocks reserved is based on the formula:
+ * (rmapbt).  With reflink, there are four trees (refcountbt).  The number of
+ * blocks reserved is based on the formula:
  *
  * num trees * ((2 blocks/level * max depth) - 1)
  *
@@ -82,6 +83,8 @@ xfs_allocfree_log_count(
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
