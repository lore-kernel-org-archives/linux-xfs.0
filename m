Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39191 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754436AbdKIN1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:06 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] xfs: fix number of records handling in xfs_iext_split_leaf
Date: Thu,  9 Nov 2017 14:26:51 +0100
Message-Id: <20171109132656.1649-2-hch@lst.de>
In-Reply-To: <20171109132656.1649-1-hch@lst.de>
References: <20171109132656.1649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

Fix to check the correct value, and remove a duplicate handling of the
uneven record number split algorith,

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_iext_tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 00d660dcb05e..85d7f708eafc 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -555,16 +555,13 @@ xfs_iext_split_leaf(
 	int			i;
 
 	/* for sequential append operations just spill over into the new node */
-	if (cur->pos == KEYS_PER_NODE) {
+	if (cur->pos == RECS_PER_LEAF) {
 		cur->leaf = new;
 		cur->pos = 0;
 		*nr_entries = 0;
 		goto done;
 	}
 
-	if (nr_keep & 1)
-		nr_keep++;
-
 	for (i = 0; i < nr_move; i++) {
 		new->recs[i] = leaf->recs[nr_keep + i];
 		xfs_iext_rec_clear(&leaf->recs[nr_keep + i]);
-- 
2.14.2

