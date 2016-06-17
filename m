Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C9F87DE8
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:24:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6479B304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:24:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VXh6Y7fMDShHBf8O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:24:15 -0700 (PDT)
Subject: [PATCH 059/119] xfs: account for the refcount btree in the
	alloc/free log reservation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:24:09 -0700
Message-ID: <146612664925.12839.17667207190553223295.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Every time we allocate or free an extent, we might need to split the
refcount btree.  Reserve some blocks in the transaction to handle
this possibility.

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
