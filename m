Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B868C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E72026124B
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243749AbhIXB24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240863AbhIXB2z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:28:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BF01610CB;
        Fri, 24 Sep 2021 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446843;
        bh=TLLlxrpojZvLUnEdH+rnlsyhBb//w4sN/dGy1sXkwRQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g4SOQP++xEBqfzZRi3YF4zLZfXSGGswL7ULA3GMLjZ/guWMvIyDcCkeAi1rUodwCu
         +eoO8TBvNPA1507yjFhP7KWQ23ReLGbK1j7HwAmTNdcEEr1E2K7NSRSP/GTn7Tg9pD
         bapK6CLf7W4IOe3ia6prMaOb6pHmqHnXrB9lcvYv28nlR0DzwT4kFvY2UxK2qdJXaC
         ZXTbpQw46K4kf2LgijW+hWtbjRkakXtlk9PY75Lcb1zMXVFoqvXYMbA6uyGsxnQjxY
         m3B7QXh9B4YrvsvMZvEvypFek5nvtLjZHuKVyBCpJq4yDC3LzVZQZQ5Iyg35TocfYY
         9CucRBya6u+3Q==
Subject: [PATCH 13/15] xfs: compute actual maximum btree height for critical
 reservation calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:23 -0700
Message-ID: <163244684334.2701302.11778485452918077200.stgit@magnolia>
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

Compute the actual maximum btree height when deciding if per-AG block
reservation is critically low.  This only affects the sanity check
condition, since we /generally/ will trigger on the 10% threshold.
This is a long-winded way of saying that we're removing one more
usage of XFS_BTREE_MAXLEVELS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c |    4 +++-
 fs/xfs/libxfs/xfs_btree.c   |   19 +++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h   |    1 +
 3 files changed, 19 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2aa2b3484c28..931481fbdd72 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -72,6 +72,7 @@ xfs_ag_resv_critical(
 {
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
+	xfs_extlen_t			btree_maxlevels;
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
@@ -91,7 +92,8 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+	btree_maxlevels = xfs_btree_maxlevels(pag->pag_mount, XFS_BTNUM_MAX);
+	return XFS_TEST_ERROR(avail < orig / 10 || avail < btree_maxlevels,
 			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 361063804af7..a222f5de2a09 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4934,12 +4934,17 @@ xfs_btree_has_more_records(
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
 
-/* Compute the maximum allowed height for a given btree type. */
-static unsigned int
+/*
+ * Compute the maximum allowed height for a given btree type.  If XFS_BTNUM_MAX
+ * is passed in, the maximum allowed height for all btree types is returned.
+ */
+unsigned int
 xfs_btree_maxlevels(
 	struct xfs_mount	*mp,
 	xfs_btnum_t		btnum)
 {
+	unsigned int		ret;
+
 	switch (btnum) {
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
@@ -4955,9 +4960,15 @@ xfs_btree_maxlevels(
 	case XFS_BTNUM_REFC:
 		return mp->m_refc_maxlevels;
 	default:
-		ASSERT(0);
-		return XFS_BTREE_MAXLEVELS;
+		break;
 	}
+
+	ret = mp->m_ag_maxlevels;
+	ret = max(ret, mp->m_bm_maxlevels[XFS_DATA_FORK]);
+	ret = max(ret, mp->m_bm_maxlevels[XFS_ATTR_FORK]);
+	ret = max(ret, M_IGEO(mp)->inobt_maxlevels);
+	ret = max(ret, mp->m_rmap_maxlevels);
+	return max(ret, mp->m_refc_maxlevels);
 }
 
 /* Allocate a new btree cursor of the appropriate size. */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index c9e60c1e1212..1f269bc49714 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -582,5 +582,6 @@ void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		const union xfs_btree_key *src_key, int numkeys);
 struct xfs_btree_cur *xfs_btree_alloc_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, xfs_btnum_t btnum);
+unsigned int xfs_btree_maxlevels(struct xfs_mount *mp, xfs_btnum_t btnum);
 
 #endif	/* __XFS_BTREE_H__ */

