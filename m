Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE72C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BAC60C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbhHLXcY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237906AbhHLXcW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D32E760C3E;
        Thu, 12 Aug 2021 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811116;
        bh=yTux2YMNqCKV+jFByus8x6FViYDqKnoAAwjJmRvaddQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kUfi+105bzC+1puyBEwYp98U8un8Ijj/qwTvc25r/hj1GDz0VqIX41PxP3JdZPfdg
         Xc+AmYmFN6rJaF0g65MDklC6HRo4ulM846gzQBevkiUdS3zztLgUkLtLvkcfN4Zh0D
         GKkWnDwwIq70mCcWUOi3R90XdgBuuiGZsgqV162aW0ebO+AfJD4I8pNUcX4hyivN1Z
         9MjP1m6t+1od0qSfk3f+7X9N74p/XlDqHb8bWAdKltOJL9vm90SSN1FdppoJZf+sQ3
         k5qqSUh2JJjqV+TEw+76uD3XWQwCVsPnho6HKd+1QPl4Kcug4Hoz0EBA7LeCOhPYSa
         rAgxgB3u5ahSQ==
Subject: [PATCH 06/10] xfs: mark the record passed into xchk_btree functions
 as const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:56 -0700
Message-ID: <162881111657.1695493.2646352717736011507.stgit@magnolia>
In-Reply-To: <162881108307.1695493.3416792932772498160.stgit@magnolia>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xchk_btree calls a user-supplied function to validate each btree record
that it finds.  Those functions are not supposed to change the record
data, so mark the parameter const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.h |    3 ++-
 fs/xfs/scrub/alloc.c           |    2 +-
 fs/xfs/scrub/bmap.c            |    2 +-
 fs/xfs/scrub/btree.h           |    4 ++--
 fs/xfs/scrub/ialloc.c          |    2 +-
 fs/xfs/scrub/refcount.c        |    2 +-
 fs/xfs/scrub/rmap.c            |    2 +-
 8 files changed, 10 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cd8fefc9019f..961f0193b058 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -58,7 +58,7 @@ xfs_bmdr_to_bmbt(
 
 void
 xfs_bmbt_disk_get_all(
-	struct xfs_bmbt_rec	*rec,
+	const struct xfs_bmbt_rec *rec,
 	struct xfs_bmbt_irec	*irec)
 {
 	uint64_t		l0 = get_unaligned_be64(&rec->l0);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 209ded1eefd1..16c2b53bbac3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -90,7 +90,8 @@ extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(const struct xfs_bmbt_rec *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(const struct xfs_bmbt_rec *r);
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
+extern void xfs_bmbt_disk_get_all(const struct xfs_bmbt_rec *r,
+		struct xfs_bmbt_irec *s);
 
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index d5741980094a..87518e1292f8 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -91,7 +91,7 @@ xchk_allocbt_xref(
 STATIC int
 xchk_allocbt_rec(
 	struct xchk_btree	*bs,
-	union xfs_btree_rec	*rec)
+	const union xfs_btree_rec *rec)
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
 	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index ea701f5ca32b..7f7ac8ca1610 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -383,7 +383,7 @@ xchk_bmap_iextent(
 STATIC int
 xchk_bmapbt_rec(
 	struct xchk_btree	*bs,
-	union xfs_btree_rec	*rec)
+	const union xfs_btree_rec *rec)
 {
 	struct xfs_bmbt_irec	irec;
 	struct xfs_bmbt_irec	iext_irec;
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 5572e475f8ed..b7d2fc01fbf9 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -26,8 +26,8 @@ void xchk_btree_xref_set_corrupt(struct xfs_scrub *sc,
 
 struct xchk_btree;
 typedef int (*xchk_btree_rec_fn)(
-	struct xchk_btree	*bs,
-	union xfs_btree_rec	*rec);
+	struct xchk_btree		*bs,
+	const union xfs_btree_rec	*rec);
 
 struct xchk_btree {
 	/* caller-provided scrub state */
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 30e568596b79..db42eb0a32f2 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -418,7 +418,7 @@ xchk_iallocbt_rec_alignment(
 STATIC int
 xchk_iallocbt_rec(
 	struct xchk_btree		*bs,
-	union xfs_btree_rec		*rec)
+	const union xfs_btree_rec	*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xchk_iallocbt		*iabt = bs->private;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index c547e5ca3207..2744eecdbaf0 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -330,7 +330,7 @@ xchk_refcountbt_xref(
 STATIC int
 xchk_refcountbt_rec(
 	struct xchk_btree	*bs,
-	union xfs_btree_rec	*rec)
+	const union xfs_btree_rec *rec)
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
 	xfs_agblock_t		*cow_blocks = bs->private;
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index fc306573f0ac..8dae0345c7df 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -88,7 +88,7 @@ xchk_rmapbt_xref(
 STATIC int
 xchk_rmapbt_rec(
 	struct xchk_btree	*bs,
-	union xfs_btree_rec	*rec)
+	const union xfs_btree_rec *rec)
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
 	struct xfs_rmap_irec	irec;

