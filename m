Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751773AbdHBCf2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 22:35:28 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_metadump: zap stale date in DIR2_LEAF1 dirs
Message-ID: <37cd41d1-335f-a3af-d92c-c0b4b6d1356a@redhat.com>
Date: Tue, 1 Aug 2017 21:35:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Stefan Ring <stefanrin@gmail.com>

xfs_metadump attempts to zero out unused regions of metadata
blocks to prevent data leaks when sharing metadata images.

However, Stefan Ring reported a significant number of leaked
strings when dumping his 1T filesystem.  Based on a reduced
metadata set, I was able to identify "leaf" directories
(with XFS_DIR2_LEAF1_MAGIC magic) as the primary culprit;
the region between the end of the entries array and the start
of the bests array was not getting zeroed out.  This patch
seems to remedy that problem.

Reported-by: Stefan Ring <stefanrin@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I may have missed some handy macro to work out some of the
math below, if so I'd be perfectly happy to hear about it ;)

diff --git a/db/metadump.c b/db/metadump.c
index 96641e0..6d77d61 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1459,6 +1459,37 @@ process_dir_data_block(
 	int		wantmagic;
 	struct xfs_dir2_data_hdr *datahdr;
 
+	if (offset >= mp->m_dir_geo->freeblk) {
+		/* TODO */
+		return;
+	} else if (offset >= mp->m_dir_geo->leafblk) {
+		struct xfs_dir2_leaf		*leaf;
+		struct xfs_dir2_leaf_tail	*ltp;
+		struct xfs_dir3_icleaf_hdr 	leafhdr;
+
+		if (!zero_stale_data)
+			return;
+
+		leaf = (struct xfs_dir2_leaf *)block;
+		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
+		M_DIROPS(mp)->leaf_hdr_from_disk(&leafhdr, leaf);
+
+		/* Zero out space from end of ents[] to bests */
+		if (leafhdr.magic == XFS_DIR2_LEAF1_MAGIC) {
+			struct xfs_dir2_leaf_entry	*ents;
+			__be16				*lbp;
+			char				*start; /* end of ents */
+
+			ents = M_DIROPS(mp)->leaf_ents_p(leaf);
+			start = (char *)&ents[leafhdr.count + leafhdr.stale];
+			lbp = xfs_dir2_leaf_bests_p(ltp);
+			memset(start, 0, (char *)lbp - start);
+			iocur_top->need_crc = 1;
+		}
+		return;
+	}
+
+	/* It's a data block. */
 	datahdr = (struct xfs_dir2_data_hdr *)block;
 
 	if (is_block_format) {
@@ -1800,9 +1831,6 @@ process_single_fsb_objects(
 		dp = iocur_top->data;
 		switch (btype) {
 		case TYP_DIR2:
-			if (o >= mp->m_dir_geo->leafblk)
-				break;
-
 			process_dir_data_block(dp, o,
 					 last == mp->m_dir_geo->fsbcount);
 			iocur_top->need_crc = 1;

