Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58768 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938588AbdAIPkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/32] xfs: forbid AG btrees with level == 0
Date: Mon,  9 Jan 2017 16:38:51 +0100
Message-Id: <1483976343-661-21-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d2a047f31e86941fa896e0e3271536d50aba415e upstream.

There is no such thing as a zero-level AG btree since even a single-node
zero-records btree has one level.  Btree cursor constructors read
cur_nlevels straight from disk and then access things like
cur_bufs[cur_nlevels - 1] which is /really/ bad if cur_nlevels is zero!
Therefore, strengthen the verifiers to prevent this possibility.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 10 +++++++---
 fs/xfs/libxfs/xfs_ialloc.c |  9 ++++++++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index effb64c..5050056 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2455,12 +2455,15 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
 		return false;
 
-	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
+	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
 		return false;
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS)
+	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
+	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
 		return false;
 
 	/*
@@ -2477,7 +2480,8 @@ xfs_agf_verify(
 		return false;
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
-	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
+	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
+	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
 		return false;
 
 	return true;;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c482b97..d45c037 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2510,8 +2510,15 @@ xfs_agi_verify(
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
 		return false;
 
-	if (be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
+	if (be32_to_cpu(agi->agi_level) < 1 ||
+	    be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
 		return false;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    (be32_to_cpu(agi->agi_free_level) < 1 ||
+	     be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS))
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
-- 
2.1.4

