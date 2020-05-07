Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679FCC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E501208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lzTzeuww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEGMVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:21:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EACC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MUdGVi/B/5AED50/kSsyyzQkZWFbbroH6iQCObmwjpU=; b=lzTzeuwwuZMA7Vw1OEp//Cbqty
        qjNGb4RGEtWHjVJeyMNx53qMlJBewiQysDPOiviDERFh9owo7lFewVHGyAC8sCbIx+z1yu5sm9SWn
        TBVI39HJQGLCKdpjf/jHe17a9I0XHYnRQkqTWeGnyZ3C115XtHJpa/rJeliCUz9/3GkjrkiuJWwz3
        XO/4liUsyKxwBbn6g4dKRZ9yh9fo+vT6oVj9UTyf4/ZExxLmorVkVvpf2jDMPUzVqL1N85tgYFpT3
        wWcZGITTbpcT/+wXfNNCh/P/9DM10KnMOhxDqK5jS9E1RbMy5xN8SeN4TtV/EH9nkMbE2Mnz6uJ+O
        bxENvfWw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWP-0007z2-1o; Thu, 07 May 2020 12:21:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 52/58] xfs: add support for inode btree staging cursors
Date:   Thu,  7 May 2020 14:18:45 +0200
Message-Id: <20200507121851.304002-53-hch@lst.de>
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

Source kernel commit: c29ce8f48e219d10644f402ec5d738cadf20666e

Add support for btree staging cursors for the inode btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc_btree.c | 82 +++++++++++++++++++++++++++++++++------
 libxfs/xfs_ialloc_btree.h |  6 +++
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 55414e17..0c5c55f0 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -12,6 +12,7 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
@@ -19,7 +20,6 @@
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
 
-
 STATIC int
 xfs_inobt_get_minrecs(
 	struct xfs_btree_cur	*cur,
@@ -399,32 +399,27 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 };
 
 /*
- * Allocate a new inode btree cursor.
+ * Initialize a new inode btree cursor.
  */
-struct xfs_btree_cur *				/* new inode btree cursor */
-xfs_inobt_init_cursor(
+static struct xfs_btree_cur *
+xfs_inobt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agi structure */
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
-	struct xfs_agi		*agi = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
-
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	if (btnum == XFS_BTNUM_INO) {
-		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-		cur->bc_ops = &xfs_inobt_ops;
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
+		cur->bc_ops = &xfs_inobt_ops;
 	} else {
-		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
-		cur->bc_ops = &xfs_finobt_ops;
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
+		cur->bc_ops = &xfs_finobt_ops;
 	}
 
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
@@ -432,12 +427,75 @@ xfs_inobt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
+	return cur;
+}
+
+/* Create an inode btree cursor. */
+struct xfs_btree_cur *
+xfs_inobt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_agi		*agi = agbp->b_addr;
+
+	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_INO)
+		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	else
+		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
+	cur->bc_ag.agbp = agbp;
+	return cur;
+}
 
+/* Create an inode btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_inobt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_inobt_init_common(mp, NULL, agno, btnum);
+	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
 
+/*
+ * Install a new inobt btree root.  Caller is responsible for invalidating
+ * and freeing the old btree blocks.
+ */
+void
+xfs_inobt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agi		*agi = agbp->b_addr;
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		agi->agi_root = cpu_to_be32(afake->af_root);
+		agi->agi_level = cpu_to_be32(afake->af_levels);
+		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
+	} else {
+		agi->agi_free_root = cpu_to_be32(afake->af_root);
+		agi->agi_free_level = cpu_to_be32(afake->af_levels);
+		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
+					     XFS_AGI_FREE_LEVEL);
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
+	}
+}
+
 /*
  * Calculate number of records in an inobt btree block.
  */
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 951305ec..35bbd978 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -48,6 +48,9 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
 		xfs_btnum_t);
+struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
+		xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
@@ -68,4 +71,7 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, xfs_btnum_t btnum,
 		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
 
+void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
-- 
2.26.2

