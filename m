Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26120 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdDHDD7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 23:03:59 -0400
Subject: [PATCH 2/4] xfs_db: use iocursor type to guess btree geometry if
 bad magic
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Apr 2017 20:03:55 -0700
Message-ID: <149162063502.22901.11947139521251833946.stgit@birch.djwong.org>
In-Reply-To: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
References: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The function block_to_bt plays an integral role in determining the btree
geometry of a block that we want to manipulate with the debugger.
Normally we use the block magic to find the geometry profile, but if the
magic is bad we'll never find it and return NULL.  The callers of this
function do not check for NULL and crash.

Therefore, if we can't find a geometry profile matching the magic
number, use the iocursor type to guess the profile and scowl about that
to stdout.  This makes it so that even with a corrupt magic we can try
to print the fields instead of crashing the debugger.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/btblock.c |   51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)


diff --git a/db/btblock.c b/db/btblock.c
index 835a5f0..ba81645 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -25,6 +25,8 @@
 #include "print.h"
 #include "bit.h"
 #include "init.h"
+#include "io.h"
+#include "output.h"
 
 /*
  * Definition of the possible btree block layouts.
@@ -122,13 +124,49 @@ static struct xfs_db_btree *
 block_to_bt(
 	struct xfs_btree_block	*bb)
 {
-	struct xfs_db_btree *btp = &btrees[0];
+	struct xfs_db_btree	*btp;
+	uint32_t		magic;
+
+	magic = be32_to_cpu((bb)->bb_magic);
+	for (btp = &btrees[0]; btp->magic != 0; btp++)
+		if (magic == btp->magic)
+			return btp;
 
-	do {
-		if (be32_to_cpu((bb)->bb_magic) == btp->magic)
+#define M(a,b) (!xfs_sb_version_hascrc(&mp->m_sb) ? (a) : (b))
+	switch (iocur_top->typ->typnm) {
+	case TYP_BMAPBTA:
+	case TYP_BMAPBTD:
+		magic = M(XFS_BMAP_MAGIC, XFS_BMAP_CRC_MAGIC);
+		break;
+	case TYP_BNOBT:
+		magic = M(XFS_ABTB_MAGIC, XFS_ABTB_CRC_MAGIC);
+		break;
+	case TYP_CNTBT:
+		magic = M(XFS_ABTC_MAGIC, XFS_ABTC_CRC_MAGIC);
+		break;
+	case TYP_INOBT:
+		magic = M(XFS_IBT_MAGIC, XFS_IBT_CRC_MAGIC);
+		break;
+	case TYP_FINOBT:
+		magic = M(XFS_FIBT_MAGIC, XFS_FIBT_CRC_MAGIC);
+		break;
+	case TYP_RMAPBT:
+		magic = M(0, XFS_RMAP_CRC_MAGIC);
+		break;
+	case TYP_REFCBT:
+		magic = M(0, XFS_REFC_CRC_MAGIC);
+		break;
+	default:
+		ASSERT(0);
+	}
+#undef M
+	dbprintf(_("Bad btree magic 0x%x; coercing to %s.\n"),
+		be32_to_cpu((bb)->bb_magic),
+		iocur_top->typ->name);
+
+	for (btp = &btrees[0]; btp->magic != 0; btp++)
+		if (magic == btp->magic)
 			return btp;
-		btp++;
-	} while (btp->magic != 0);
 
 	return NULL;
 }
@@ -193,7 +231,6 @@ btblock_key_offset(
 	int			offset;
 
 	ASSERT(startoff == 0);
-	ASSERT(block->bb_level != 0);
 
 	offset = bt->block_len + (idx - 1) * bt->key_len;
 	return bitize(offset);
@@ -214,7 +251,6 @@ btblock_ptr_offset(
 	int			maxrecs;
 
 	ASSERT(startoff == 0);
-	ASSERT(block->bb_level != 0);
 
 	maxrecs = btblock_maxrecs(bt, mp->m_sb.sb_blocksize);
 	offset = bt->block_len +
@@ -238,7 +274,6 @@ btblock_rec_offset(
 	int			offset;
 
 	ASSERT(startoff == 0);
-	ASSERT(block->bb_level == 0);
 
 	offset = bt->block_len + (idx - 1) * bt->rec_len;
 	return bitize(offset);

