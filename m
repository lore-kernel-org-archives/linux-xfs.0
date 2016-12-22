Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49128 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941110AbcLVRr2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:47:28 -0500
Subject: [PATCH 2/3] xfs: make xfs_btree_magic more generic
References: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <af5e3ed3-bc57-deeb-be96-9bbb6f19b0ed@sandeen.net>
Date: Thu, 22 Dec 2016 11:47:26 -0600
MIME-Version: 1.0
In-Reply-To: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Right now the xfs_btree_magic() define takes only a cursor;
change this to take crc and btnum args to make it more generically
useful, and move to a header file.

This will allow xfs_btree_init_block_int callers which don't
have a cursor to make use of the xfs_magics array, which will
happen in the next patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f49fc2f..cdb952a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -50,8 +50,6 @@
 	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
 	  XFS_REFC_CRC_MAGIC }
 };
-#define xfs_btree_magic(cur) \
-	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
 
 STATIC int				/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lblock(
@@ -62,10 +60,13 @@
 {
 	int			lblock_ok = 1; /* block passes checks */
 	struct xfs_mount	*mp;	/* file system mount point */
+	xfs_btnum_t		btnum = cur->bc_btnum;
+	int			crc;
 
 	mp = cur->bc_mp;
+	crc = xfs_sb_version_hascrc(&mp->m_sb);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (crc) {
 		lblock_ok = lblock_ok &&
 			uuid_equal(&block->bb_u.l.bb_uuid,
 				   &mp->m_sb.sb_meta_uuid) &&
@@ -74,7 +75,7 @@
 	}
 
 	lblock_ok = lblock_ok &&
-		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
+		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
@@ -110,13 +111,16 @@
 	struct xfs_agf		*agf;	/* ag. freespace structure */
 	xfs_agblock_t		agflen;	/* native ag. freespace length */
 	int			sblock_ok = 1; /* block passes checks */
+	xfs_btnum_t		btnum = cur->bc_btnum;
+	int			crc;
 
 	mp = cur->bc_mp;
+	crc = xfs_sb_version_hascrc(&mp->m_sb);
 	agbp = cur->bc_private.a.agbp;
 	agf = XFS_BUF_TO_AGF(agbp);
 	agflen = be32_to_cpu(agf->agf_length);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (crc) {
 		sblock_ok = sblock_ok &&
 			uuid_equal(&block->bb_u.s.bb_uuid,
 				   &mp->m_sb.sb_meta_uuid) &&
@@ -125,7 +129,7 @@
 	}
 
 	sblock_ok = sblock_ok &&
-		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
+		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
@@ -1142,7 +1146,9 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
 	int			level,
 	int			numrecs)
 {
-	__u64 owner;
+	__u64			owner;
+	int			crc = xfs_sb_version_hascrc(&cur->bc_mp->m_sb);
+	xfs_btnum_t		btnum = cur->bc_btnum;
 
 	/*
 	 * we can pull the owner from the cursor right now as the different
@@ -1156,7 +1162,7 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
 		owner = cur->bc_private.a.agno;
 
 	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
-				 xfs_btree_magic(cur), level, numrecs,
+				 xfs_btree_magic(crc, btnum), level, numrecs,
 				 owner, cur->bc_flags);
 }
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 8d74870..8ddacf4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -113,6 +113,8 @@
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
+#define xfs_btree_magic(crc, btnum)	xfs_magics[crc][btnum]
+
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;


