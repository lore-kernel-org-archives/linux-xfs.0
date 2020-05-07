Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AE2C4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31F7208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YYy3GPg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgEGMU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F66AC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bp9yfOKgRiup+EN0eKK2zBFPUWrZ2766GJmjy6MXIn8=; b=YYy3GPg+FlJDzNJAPPwbxvg4qX
        i4caoNd6k+2s8SlsSU7fXaYVXF9BUmT1e86HTE/qJOyYyLz/JV+ypiLXo0vQUyjW5I/4ZP3e/dcu1
        inNvW4R1FbrT0HE74TA7Xsx15DTCXLc80OMEzGKnn2ixUB65KTCZ8HKAgpijnyIeFNu5kgUBC16LS
        qxdc5fbmKi4M6JVuBGQhJA3AH9ujNpjHuapKVUNdCCPH0mepgxsAqSoOQMnDWA2xPE2k4SEl027ok
        uiR4/lt2O0jUUqrsjtSxfvyAZ1R31lNlHY590tA6xK7gutgq+OkRRWxVzStdeHYGjfE9hCpgmwHGG
        AJ1Q2GSg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWM-0007yR-KU; Thu, 07 May 2020 12:20:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 51/58] xfs: add support for free space btree staging cursors
Date:   Thu,  7 May 2020 14:18:44 +0200
Message-Id: <20200507121851.304002-52-hch@lst.de>
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

Source kernel commit: e6eb33d905c287eb07ee1c69d38871276db154dd

Add support for btree staging cursors for the free space btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c | 93 +++++++++++++++++++++++++++++++++-------
 libxfs/xfs_alloc_btree.h |  7 +++
 2 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 72983927..deb2210b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -12,6 +12,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
@@ -469,18 +470,14 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 };
 
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *			/* new alloc btree cursor */
-xfs_allocbt_init_cursor(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agf structure */
-	xfs_agnumber_t		agno,		/* allocation group number */
-	xfs_btnum_t		btnum)		/* btree identifier */
+/* Allocate most of a new allocation btree cursor. */
+STATIC struct xfs_btree_cur *
+xfs_allocbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
 {
-	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
@@ -493,17 +490,14 @@ xfs_allocbt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	if (btnum == XFS_BTNUM_CNT) {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
 		cur->bc_ops = &xfs_cntbt_ops;
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 		cur->bc_ops = &xfs_bnobt_ops;
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
 
-	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
 	cur->bc_ag.abt.active = false;
 
@@ -513,6 +507,73 @@ xfs_allocbt_init_cursor(
 	return cur;
 }
 
+/*
+ * Allocate a new allocation btree cursor.
+ */
+struct xfs_btree_cur *			/* new alloc btree cursor */
+xfs_allocbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_btnum_t		btnum)		/* btree identifier */
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_CNT)
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	else
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+
+	cur->bc_ag.agbp = agbp;
+
+	return cur;
+}
+
+/* Create a free space btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_allocbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_allocbt_init_common(mp, NULL, agno, btnum);
+	xfs_btree_stage_afakeroot(cur, afake);
+	return cur;
+}
+
+/*
+ * Install a new free space btree root.  Caller is responsible for invalidating
+ * and freeing the old btree blocks.
+ */
+void
+xfs_allocbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
+	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_bnobt_ops);
+	} else {
+		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_cntbt_ops);
+	}
+}
+
 /*
  * Calculate number of records in an alloc btree block.
  */
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index c9305ebb..047f09f0 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -48,8 +49,14 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
+struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
+		xfs_btnum_t btnum);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
-- 
2.26.2

