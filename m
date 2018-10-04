Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:37049 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbeJEDxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 23:53:03 -0400
Received: by mail-wr1-f49.google.com with SMTP id y11-v6so629300wrd.4
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 13:58:00 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x2-v6sm2003171wrs.47.2018.10.04.13.57.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 13:57:58 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 1/1] xfs_metadump: Zap more stale data
Date: Thu,  4 Oct 2018 22:57:49 +0200
Message-Id: <20181004205749.2042-2-stefanrin@gmail.com>
In-Reply-To: <20181004205749.2042-1-stefanrin@gmail.com>
References: <20181004205749.2042-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I have empirically found and tried to fix some places where stale data was not properly zeroed out.

In the order of the code changes:

The "freeindex" blocks in inode directories, from last entry to end of block.

XFS_DIR2_LEAF1_MAGIC, from last entry to end of block.

In btree format inodes before as well as after the btree pointers.

In dev inodes, everything after the header.
---
 db/metadump.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index cc2ae9af..e7159cd1 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1421,12 +1421,42 @@ process_sf_attr(
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
+	/* Zero out space from end of bests[] to end of block */
+	if (freehdr.magic == XFS_DIR2_FREE_MAGIC) {
+		__be16			*bests;
+		char			*high;
+		int			used;
+
+		bests = M_DIROPS(mp)->free_bests_p(free);
+		high = (char *)&bests[freehdr.nvalid];
+		used = high - (char*)free;
+		memset(high, 0, mp->m_sb.sb_blocksize - used);
+		iocur_top->need_crc = 1;
+	}
+	else if (show_warnings)
+		print_warning("invalid magic in dir inode %llu free block",
+				(unsigned long long)cur_ino);
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
@@ -1449,6 +1479,18 @@ process_dir_leaf_block(
 		lbp = xfs_dir2_leaf_bests_p(ltp);
 		memset(free, 0, (char *)lbp - free);
 		iocur_top->need_crc = 1;
+	} else
+	if (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+	    leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
+		struct xfs_dir2_leaf_entry	*ents;
+		char				*free;
+		int				used;
+
+		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
+		free = (char *)&ents[leafhdr.count];
+		used = free - (char*)leaf;
+		memset(free, 0, mp->m_sb.sb_blocksize - used);
+		iocur_top->need_crc = 1;
 	}
 }
 
@@ -1499,7 +1541,7 @@ process_dir_data_block(
 		if (show_warnings)
 			print_warning(
 		"invalid magic in dir inode %llu block %ld",
-					(long long)cur_ino, (long)offset);
+					(unsigned long long)cur_ino, (long)offset);
 		return;
 	}
 
@@ -1813,8 +1855,7 @@ process_single_fsb_objects(
 		switch (btype) {
 		case TYP_DIR2:
 			if (o >= mp->m_dir_geo->freeblk) {
-				/* TODO, zap any stale data */
-				break;
+				process_dir_free_block(dp);
 			} else if (o >= mp->m_dir_geo->leafblk) {
 				process_dir_leaf_block(dp);
 			} else {
@@ -2115,6 +2156,20 @@ process_btinode(
 	}
 
 	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
+
+	if (zero_stale_data) {
+		/* Space before btree pointers */
+		char	*top;
+		int	used;
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
@@ -2250,7 +2305,16 @@ process_inode(
 		case S_IFREG:
 			success = process_inode_data(dip, TYP_DATA);
 			break;
-		default: ;
+		default:
+			if (XFS_DFORK_NEXTENTS(dip, XFS_ATTR_FORK) ||
+					XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+				if (show_warnings)
+					print_warning("inode %llu has unexpected extents",
+							(unsigned long long)cur_ino);
+				success = 0;
+			}
+			else
+				memset(XFS_DFORK_DPTR(dip), 0, mp->m_sb.sb_inodesize - (XFS_DFORK_DPTR(dip) - (char*)dip));
 	}
 	nametable_clear();
 
-- 
2.14.4
