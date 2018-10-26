Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:37758 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbeJ0E6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:58:35 -0400
Received: by mail-wm1-f51.google.com with SMTP id p2-v6so2530187wmc.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 13:20:09 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id 193-v6sm7669219wmj.21.2018.10.26.13.20.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 13:20:07 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 1/5] xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
Date: Fri, 26 Oct 2018 22:19:39 +0200
Message-Id: <20181026201943.24131-2-stefanrin@gmail.com>
In-Reply-To: <20181026201943.24131-1-stefanrin@gmail.com>
References: <20181026201943.24131-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

---
 db/metadump.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index cc2ae9af..97d2a490 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1426,7 +1426,7 @@ process_dir_leaf_block(
 	char				*block)
 {
 	struct xfs_dir2_leaf		*leaf;
-	struct xfs_dir3_icleaf_hdr 	leafhdr;
+	struct xfs_dir3_icleaf_hdr	leafhdr;
 
 	if (!zero_stale_data)
 		return;
@@ -1435,20 +1435,39 @@ process_dir_leaf_block(
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
 
-- 
2.14.5
