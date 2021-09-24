Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76770C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC2A610CB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbhIXB2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243749AbhIXB2u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 289D961108;
        Fri, 24 Sep 2021 01:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446838;
        bh=dRBHUFZDpzyTFB2IwTtQYWRn2EiW/5pz8gxqesgFqGg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EbqHYyGL3kv5eeBYZLUf0KThVohNxfcNYWgzu6dlK3AzPzXu5FeRbrRB2xyKfA/an
         SdgqQ4rF0+dgkzx04sFEYvlsnDYlpEwoVwMao8qOSoxINjeR5xkWcdn1+2rRXEB+s+
         DTqy/+vVDuIBKYkmmN6l/Q0We8pHI+dBXgZGBl9YYoPJei9h3AIW+gzUWGVRXaeJcr
         7x26a50cMWRIldL7zdQLJ1M1yu0QxfM4zZfZYkD6L76abpEPw/wEKEK4OXK//UfMxV
         dp66xFh5AIYx3JQoK8LCdiyF7NamqybnVu45OoK7XVzdSut1IaCDKXfwI7EOSl7vPT
         9uiRApLhRbHQg==
Subject: [PATCH 12/15] xfs: dynamically allocate cursors based on maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:17 -0700
Message-ID: <163244683787.2701302.15753914986754968329.stgit@magnolia>
In-Reply-To: <163244677169.2701302.12882919857957905332.stgit@magnolia>
References: <163244677169.2701302.12882919857957905332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

To support future btree code, we need to be able to size btree cursors
dynamically for very large btrees.  Switch the maxlevels computation to
use the precomputed values in the superblock, and create cursors that
can handle a certain height.  For now, we retain the btree cursor zone
that can handle up to 9-level btrees, and create larger cursors (which
shouldn't happen currently) from the heap as a failsafe.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   40 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h |    6 ++++++
 fs/xfs/xfs_super.c        |    4 ++--
 3 files changed, 45 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0c86209a54df..361063804af7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -379,7 +379,10 @@ xfs_btree_del_cursor(
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
-	kmem_cache_free(xfs_btree_cur_zone, cur);
+	if (cur->bc_maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
+		kmem_free(cur);
+	else
+		kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
 /*
@@ -4931,6 +4934,32 @@ xfs_btree_has_more_records(
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
 
+/* Compute the maximum allowed height for a given btree type. */
+static unsigned int
+xfs_btree_maxlevels(
+	struct xfs_mount	*mp,
+	xfs_btnum_t		btnum)
+{
+	switch (btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		return mp->m_ag_maxlevels;
+	case XFS_BTNUM_BMAP:
+		return max(mp->m_bm_maxlevels[XFS_DATA_FORK],
+			   mp->m_bm_maxlevels[XFS_ATTR_FORK]);
+	case XFS_BTNUM_INO:
+	case XFS_BTNUM_FINO:
+		return M_IGEO(mp)->inobt_maxlevels;
+	case XFS_BTNUM_RMAP:
+		return mp->m_rmap_maxlevels;
+	case XFS_BTNUM_REFC:
+		return mp->m_refc_maxlevels;
+	default:
+		ASSERT(0);
+		return XFS_BTREE_MAXLEVELS;
+	}
+}
+
 /* Allocate a new btree cursor of the appropriate size. */
 struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
@@ -4939,13 +4968,18 @@ xfs_btree_alloc_cursor(
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
+	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
+	if (maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
+		cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
+	else
+		cur = kmem_cache_zalloc(xfs_btree_cur_zone,
+				GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
+	cur->bc_maxlevels = maxlevels;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3b396edd1a4f..c9e60c1e1212 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -94,6 +94,12 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 
 #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
 
+/*
+ * The btree cursor zone hands out cursors that can handle up to this many
+ * levels.  This is the known maximum for all btree types.
+ */
+#define XFS_BTREE_CUR_ZONE_MAXLEVELS	(9)
+
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 30bae0657343..90c92a6a49e0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1966,8 +1966,8 @@ xfs_init_zones(void)
 		goto out_destroy_log_ticket_zone;
 
 	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
-					       0, 0, NULL);
+			xfs_btree_cur_sizeof(XFS_BTREE_CUR_ZONE_MAXLEVELS),
+			0, 0, NULL);
 	if (!xfs_btree_cur_zone)
 		goto out_destroy_bmap_free_item_zone;
 

