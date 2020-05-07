Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2856C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4ACC21473
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hsXjF2Vx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEGMVE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:21:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E4AC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vwW4coQ8/N8+OcksfBAS5yEgoYg/WSZ6T4jNq6xFqo0=; b=hsXjF2VxrEO2wHGHOb1b0sWoc8
        O8Gu70hTvFJQNHBgbN4ptGR4ombpmqYIJrT6ciWPgu3e6V1/T09znrnnxEeGnv80cZK1IMG8/5E6J
        SHqxnHQrziU+8O+7lEpE4htR7ufMgeMWpTF4ELiTEi89H3Xm2DW0260eZtHXu1r5vrFfjZETSlW4a
        6YCZMn1cOUrszXaCBtOfGQWdPPQ1nB/7ZQl/agg0qVAG/LUAmTjUcQrz0vG4o9GzDwrNX6PruYPwW
        /R6ryoYs41aMx9JEX/zpMsqQIhfk70nu/fdbLUczoRiqxL0yrJO7OfRHaFo7cBIV66UwZ5zRLO29Z
        MmllT5/A==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWR-00083H-F2; Thu, 07 May 2020 12:21:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 53/58] xfs: add support for refcount btree staging cursors
Date:   Thu,  7 May 2020 14:18:46 +0200
Message-Id: <20200507121851.304002-54-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 56e98164ffea2a9ee577e5e4f368c6d5182ed8eb

Add support for btree staging cursors for the refcount btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount_btree.c | 70 +++++++++++++++++++++++++++++++------
 libxfs/xfs_refcount_btree.h |  6 ++++
 2 files changed, 66 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 256229e9..1eef6826 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -12,6 +12,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
@@ -310,41 +311,90 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 };
 
 /*
- * Allocate a new refcount btree cursor.
+ * Initialize a new refcount btree cursor.
  */
-struct xfs_btree_cur *
-xfs_refcountbt_init_cursor(
+static struct xfs_btree_cur *
+xfs_refcountbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agno < mp->m_sb.sb_agcount);
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = XFS_BTNUM_REFC;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_refcountbt_ops;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
-
-	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
+	cur->bc_ops = &xfs_refcountbt_ops;
+	return cur;
+}
+
+/* Create a btree cursor. */
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_refcountbt_init_common(mp, tp, agno);
+	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+	cur->bc_ag.agbp = agbp;
+	return cur;
+}
+
+/* Create a btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_refcountbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_cur	*cur;
 
+	cur = xfs_refcountbt_init_common(mp, NULL, agno);
+	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
 
+/*
+ * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
+ * is in place and we have to kill off all the old btree blocks.
+ */
+void
+xfs_refcountbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_refcount_root = cpu_to_be32(afake->af_root);
+	agf->agf_refcount_level = cpu_to_be32(afake->af_levels);
+	agf->agf_refcount_blocks = cpu_to_be32(afake->af_blocks);
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
+				    XFS_AGF_REFCOUNT_ROOT |
+				    XFS_AGF_REFCOUNT_LEVEL);
+	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_refcountbt_ops);
+}
+
 /*
  * Calculate the number of records in a refcount btree block.
  */
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index ba416f71..69dc515d 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /*
  * Btree block header size
@@ -46,6 +47,8 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		xfs_agnumber_t agno);
+struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
@@ -58,4 +61,7 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
 		xfs_extlen_t *used);
 
+void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
-- 
2.26.2

