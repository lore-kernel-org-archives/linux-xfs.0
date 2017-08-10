Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36272 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdHJVaM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 17:30:12 -0400
Subject: [PATCH V2] xfs_metadump: zap stale date in DIR2_LEAF1 dirs
References: <37cd41d1-335f-a3af-d92c-c0b4b6d1356a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5f60ef75-8481-872e-91ac-76ea62588773@sandeen.net>
Date: Thu, 10 Aug 2017 14:30:10 -0700
MIME-Version: 1.0
In-Reply-To: <37cd41d1-335f-a3af-d92c-c0b4b6d1356a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>
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

V2:

- factor into new function, process_dir_leaf_block
- add DIR3_LEAF1_MAGIC
- don't add count+stale; count includes stale entries
- move ltp into code block

diff --git a/db/metadump.c b/db/metadump.c
index 3967df6..a8756d6 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1442,6 +1442,37 @@ process_sf_attr(
 }
 
 static void
+process_dir_leaf_block(
+	char				*block)
+{
+	struct xfs_dir2_leaf		*leaf;
+	struct xfs_dir3_icleaf_hdr 	leafhdr;
+
+	if (!zero_stale_data)
+		return;
+
+	/* Yes, this works for dir2 & dir3.  Difference is padding. */
+	leaf = (struct xfs_dir2_leaf *)block;
+	M_DIROPS(mp)->leaf_hdr_from_disk(&leafhdr, leaf);
+
+	/* Zero out space from end of ents[] to bests */
+	if (leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
+	    leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
+		struct xfs_dir2_leaf_tail	*ltp;
+		__be16				*lbp;
+		struct xfs_dir2_leaf_entry	*ents;
+		char				*free; /* end of ents */
+
+		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
+		free = (char *)&ents[leafhdr.count];
+		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
+		lbp = xfs_dir2_leaf_bests_p(ltp);
+		memset(free, 0, (char *)lbp - free);
+		iocur_top->need_crc = 1;
+	}
+}
+
+static void
 process_dir_data_block(
 	char		*block,
 	xfs_fileoff_t	offset,
@@ -1801,11 +1832,15 @@ process_single_fsb_objects(
 		dp = iocur_top->data;
 		switch (btype) {
 		case TYP_DIR2:
-			if (o >= mp->m_dir_geo->leafblk)
+			if (o >= mp->m_dir_geo->freeblk) {
+				/* TODO, zap any stale data */
 				break;
-
-			process_dir_data_block(dp, o,
+			} else if (o >= mp->m_dir_geo->leafblk) {
+				process_dir_leaf_block(dp);
+			} else {
+				process_dir_data_block(dp, o,
 					 last == mp->m_dir_geo->fsbcount);
+			}
 			iocur_top->need_crc = 1;
 			break;
 		case TYP_SYMLINK:

