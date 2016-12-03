Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22166 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbcLCBf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:35:27 -0500
Subject: [PATCH 01/55] xfs: forbid AG btrees with level == 0
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:35:21 -0800
Message-ID: <148072892114.12995.3258531215811110809.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

There is no such thing as a zero-level AG btree since even a single-node
zero-records btree has one level.  Btree cursor constructors read
cur_nlevels straight from disk and then access things like
cur_bufs[cur_nlevels - 1] which is /really/ bad if cur_nlevels is zero!
Therefore, strengthen the verifiers to prevent this possibility.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |   10 +++++++---
 fs/xfs/libxfs/xfs_ialloc.c |    9 ++++++++-
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
index c507c1b..30967c8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2513,8 +2513,15 @@ xfs_agi_verify(
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

