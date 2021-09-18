Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC65C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEA666112E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhIRBbR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhIRBbQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B236112E;
        Sat, 18 Sep 2021 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928594;
        bh=fkB3r0nwh0o0hQ+wKBbOJfoQHo5ix0vIfTkh7uugFNU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RSJiRSPDsjo7/+i7bRwq2SjAoGuYKJtJleHiU5zxgD5263ipxS+JWKy8kga6tBloB
         fjJGvcsJUsmU2hpNC86rOZXXbbvPRRhSxHFS+YJ57Yf79q3yh+HrxJG4Pg4e4cib2+
         /wPdGvwwaat66X4ycdztBJmk4zkKYrR1InEsLJofQ1Zb05jXoCvt7NF9We8vZ1cObJ
         mV1zZaUaVQ5BwNRFT0997M3RqiMxXTljc0haCatlrUkY/bI4UxbAfLwdagQ+/Ytbs5
         FeFbDQDRXXp7mEtoE02BdBuXoCKyr157vrkQ4V4I9IPO6iYeG1cCW7rnksIw0OMton
         F/mo3lRCMup1Q==
Subject: [PATCH 08/14] xfs: refactor btree cursor allocation function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:53 -0700
Message-ID: <163192859374.416199.6462613685926781959.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor btree allocation to a common helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    7 +------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    7 +------
 fs/xfs/libxfs/xfs_btree.c          |   18 ++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h          |    2 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 +------
 fs/xfs/libxfs/xfs_refcount_btree.c |    6 +-----
 fs/xfs/libxfs/xfs_rmap_btree.c     |    6 +-----
 7 files changed, 25 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6746fd735550..c644b11132f6 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -477,12 +477,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 72444b8b38a6..a06987e36db5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -552,13 +552,8 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-	cur->bc_btnum = XFS_BTNUM_BMAP;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 93fb50516bc2..70785004414e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4926,3 +4926,21 @@ xfs_btree_has_more_records(
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
+
+/* Allocate a new btree cursor of the appropriate size. */
+struct xfs_btree_cur *
+xfs_btree_alloc_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = btnum;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	return cur;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 827c44bf24dc..6540c4957c36 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -573,5 +573,7 @@ void xfs_btree_copy_ptrs(struct xfs_btree_cur *cur,
 void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		union xfs_btree_key *dst_key,
 		const union xfs_btree_key *src_key, int numkeys);
+struct xfs_btree_cur *xfs_btree_alloc_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, xfs_btnum_t btnum);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 27190840c5d8..c8fea6a464d5 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -432,10 +432,7 @@ xfs_inobt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
@@ -444,8 +441,6 @@ xfs_inobt_init_common(
 		cur->bc_ops = &xfs_finobt_ops;
 	}
 
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1ef9b99962ab..48c45e31d897 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -322,11 +322,7 @@ xfs_refcountbt_init_common(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = XFS_BTNUM_REFC;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b7dbbfb3aeed..f3c4d0965cc9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -451,13 +451,9 @@ xfs_rmapbt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
 	/* Overlapping btree; 2 keys per pointer. */
-	cur->bc_btnum = XFS_BTNUM_RMAP;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
 

