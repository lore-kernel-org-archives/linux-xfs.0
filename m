Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40277 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfAGUOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 15:14:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id f188so2127570wmf.5
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jan 2019 12:14:54 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id j124sm3194818wmb.48.2019.01.07.12.14.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 12:14:53 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 3/5] xfs_metadump: Zap freeindex blocks in directory inodes
Date: Mon,  7 Jan 2019 21:13:53 +0100
Message-Id: <20190107201355.18996-4-stefanrin@gmail.com>
In-Reply-To: <20190107201355.18996-1-stefanrin@gmail.com>
References: <20190107201355.18996-1-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 45705685..edc288ce 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1421,6 +1421,43 @@ process_sf_attr(
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
@@ -1518,7 +1555,7 @@ process_dir_data_block(
 		if (show_warnings)
 			print_warning(
 		"invalid magic in dir inode %llu block %ld",
-					(long long)cur_ino, (long)offset);
+					(unsigned long long)cur_ino, (long)offset);
 		return;
 	}
 
@@ -1832,8 +1869,7 @@ process_single_fsb_objects(
 		switch (btype) {
 		case TYP_DIR2:
 			if (o >= mp->m_dir_geo->freeblk) {
-				/* TODO, zap any stale data */
-				break;
+				process_dir_free_block(dp);
 			} else if (o >= mp->m_dir_geo->leafblk) {
 				process_dir_leaf_block(dp);
 			} else {
@@ -1927,8 +1963,7 @@ process_multi_fsb_objects(
 
 			dp = iocur_top->data;
 			if (o >= mp->m_dir_geo->freeblk) {
-				/* TODO, zap any stale data */
-				goto write;
+				process_dir_free_block(dp);
 			} else if (o >= mp->m_dir_geo->leafblk) {
 				process_dir_leaf_block(dp);
 			} else {
-- 
2.19.2
