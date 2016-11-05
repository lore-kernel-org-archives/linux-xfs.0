Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39547 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbcKEAZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:25:59 -0400
Subject: [PATCH 12/39] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:25:49 -0700
Message-ID: <147830554967.4165.10503974130120125644.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Add a forgotten check to the AGI verifier, then wire up the scrub
infrastructure to check the AGI contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h     |    3 ++-
 libxfs/xfs_ialloc.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f2ab770..4869803 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -602,7 +602,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_SB	1	/* superblock */
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
-#define XFS_SCRUB_TYPE_MAX	3
+#define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
+#define XFS_SCRUB_TYPE_MAX	4
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index efb37d3..8f7fe60 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2509,6 +2509,11 @@ xfs_agi_verify(
 
 	if (be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
 		return false;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't

