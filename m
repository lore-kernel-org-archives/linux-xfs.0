Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35791 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbeJLCv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 22:51:57 -0400
Received: by mail-wm1-f42.google.com with SMTP id e187-v6so10661543wmf.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 12:23:20 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 2/2] xfs_metadump: Zap more stale data
Date: Thu, 11 Oct 2018 21:23:07 +0200
Message-Id: <20181011192307.18553-3-stefanrin@gmail.com>
In-Reply-To: <20181011192307.18553-1-stefanrin@gmail.com>
References: <20181011192307.18553-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Stefan Ring <str@visotech.com>

From: Stefan Ring <str@visotech.com>

I have empirically found and tried to fix some places where stale data was not
properly zeroed out.

In the order of the code changes:

- The "freeindex" blocks in inode directories, from last entry to end of block.
- XFS_DIR{2,3}_LEAFN_MAGIC, from last entry to end of block.
- In btree format inodes before as well as after the btree pointers.
- In dev inodes, everything after the header.
---
 db/metadump.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 98 insertions(+), 8 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index ff96860d..c8213d41 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1421,12 +1421,49 @@ process_sf_attr(
 		memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
 }
 
+static void
+process_dir_free_block(
+	char				*block)
+{
+	struct xfs_dir2_free		*free;
+	struct xfs_dir3_icfree_hdr	freehdr;
+
+	if (!zero_stale_data)
+		return;
+
+	free = (struct xfs_dir2_free *)block;
+	M_DIROPS(mp)->free_hdr_from_disk(&freehdr, free);
+
+	switch (freehdr.magic) {
+	case XFS_DIR2_FREE_MAGIC:
+	case XFS_DIR3_FREE_MAGIC: {
+		__be16			*bests;
+		char			*high;
+		int			used;
+
+		/* Zero out space from end of bests[] to end of block */
+		bests = M_DIROPS(mp)->free_bests_p(free);
+		high = (char *)&bests[freehdr.nvalid];
+		used = high - (char*)free;
+		memset(high, 0, mp->m_dir_geo->blksize - used);
+		iocur_top->need_crc = 1;
+		break;
+	}
+	default:
+		if (show_warnings)
+			print_warning("invalid magic in dir inode %llu "
+				      "free block",
+				      (unsigned long long)cur_ino);
+		break;
+	}
+}
+
 static void
 process_dir_leaf_block(
 	char				*block)
 {
 	struct xfs_dir2_leaf		*leaf;
-	struct xfs_dir3_icleaf_hdr 	leafhdr;
+	struct xfs_dir3_icleaf_hdr	leafhdr;
 
 	if (!zero_stale_data)
 		return;
@@ -1435,20 +1472,39 @@ process_dir_leaf_block(
 	leaf = (struct xfs_dir2_leaf *)block;
 	M_DIROPS(mp)->leaf_hdr_from_disk(&leafhdr, leaf);
 
-	/* Zero out space from end of ents[] to bests */
-	if (leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
-	    leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
+	switch (leafhdr.magic) {
+	case XFS_DIR2_LEAF1_MAGIC:
+	case XFS_DIR3_LEAF1_MAGIC: {
 		struct xfs_dir2_leaf_tail	*ltp;
 		__be16				*lbp;
 		struct xfs_dir2_leaf_entry	*ents;
 		char				*free; /* end of ents */
 
+		/* Zero out space from end of ents[] to bests */
 		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
 		free = (char *)&ents[leafhdr.count];
 		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
 		lbp = xfs_dir2_leaf_bests_p(ltp);
 		memset(free, 0, (char *)lbp - free);
 		iocur_top->need_crc = 1;
+		break;
+	}
+	case XFS_DIR2_LEAFN_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC: {
+		struct xfs_dir2_leaf_entry	*ents;
+		char				*free;
+		int				used;
+
+		/* Zero out space from end of ents[] to end of block */
+		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
+		free = (char *)&ents[leafhdr.count];
+		used = free - (char*)leaf;
+		memset(free, 0, mp->m_dir_geo->blksize - used);
+		iocur_top->need_crc = 1;
+		break;
+	}
+	default:
+		break;
 	}
 }
 
@@ -1499,7 +1555,7 @@ process_dir_data_block(
 		if (show_warnings)
 			print_warning(
 		"invalid magic in dir inode %llu block %ld",
-					(long long)cur_ino, (long)offset);
+					(unsigned long long)cur_ino, (long)offset);
 		return;
 	}
 
@@ -1813,8 +1869,7 @@ process_single_fsb_objects(
 		switch (btype) {
 		case TYP_DIR2:
 			if (o >= mp->m_dir_geo->freeblk) {
-				/* TODO, zap any stale data */
-				break;
+				process_dir_free_block(dp);
 			} else if (o >= mp->m_dir_geo->leafblk) {
 				process_dir_leaf_block(dp);
 			} else {
@@ -2118,6 +2173,21 @@ process_btinode(
 	}
 
 	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
+
+	if (zero_stale_data) {
+		char	*top;
+		int	used;
+
+		/* Space before btree pointers */
+		top = (char*)XFS_BMDR_PTR_ADDR(dib, 1, nrecs);
+		memset(top, 0, (char*)pp - top);
+
+		/* Space after btree pointers */
+		top = (char*)&pp[nrecs];
+		used = top - (char*)dip;
+		memset(top, 0, mp->m_sb.sb_inodesize - used);
+	}
+
 	for (i = 0; i < nrecs; i++) {
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
@@ -2201,6 +2271,24 @@ process_inode_data(
 	return 1;
 }
 
+static int
+process_dev_inode(
+	xfs_dinode_t		*dip)
+{
+	if (XFS_DFORK_NEXTENTS(dip, XFS_ATTR_FORK) ||
+	    XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+		if (show_warnings)
+			print_warning("inode %llu has unexpected extents",
+				      (unsigned long long)cur_ino);
+		return 0;
+	} else {
+		int used = XFS_DFORK_DPTR(dip) - (char*)dip;
+
+		memset(XFS_DFORK_DPTR(dip), 0, mp->m_sb.sb_inodesize - used);
+		return 1;
+	}
+}
+
 /*
  * when we process the inode, we may change the data in the data and/or
  * attribute fork if they are in short form and we are obfuscating names.
@@ -2253,7 +2341,9 @@ process_inode(
 		case S_IFREG:
 			success = process_inode_data(dip, TYP_DATA);
 			break;
-		default: ;
+		default:
+			success = process_dev_inode(dip);
+			break;
 	}
 	nametable_clear();
 
-- 
2.14.4
