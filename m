Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71986C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55033610FB
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhINCmp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINCmo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA55610D1;
        Tue, 14 Sep 2021 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587287;
        bh=joraU5cxcw8coys0KRcVKDs7IpKpW2AMauNb/BOMqJE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EEPd2RjZH5m7mBzi/ZNGzlLyh+Z5qnHPVlUyTqBIhV3KkMZvzJAEJj0tt4uZccYRm
         eF7HyOc5pl4nnFh9fncfbNUiT2ZUBUohGvy7nFP/evSkynC5lFOupwz16I3Iv145iv
         jCXa1EQmR+NSumIYEvDwqGYsSYIixM8HW64FPFoLgOmC5iQfe9E+eDX4EVhYNBPiyS
         27NOBuBVHm5Ip+BGivskUUFCc1wPjVKJO/gWWgPZLgVyKhXwJ9jnCg4z3ymakFZudf
         503kMPTY2Al/LrGEfL0qwcF9VAw2W9rYLq5P5SvPvh2W9WyW3ZmlwdlQ1M1IJu5e/l
         e14nXEVA/CWqg==
Subject: [PATCH 16/43] xfs: make the start pointer passed to btree alloc_block
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:27 -0700
Message-ID: <163158728744.1604118.7373675138987652673.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: deb06b9ab6dfa167c280a68d5acb2f12e007073f

The @start pointer passed to each per-AG btree type's ->alloc_block
function isn't supposed to be modified, since it's a hint about the
location of the btree block being split that is to be fed to the
allocator, so mark the parameter const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    8 ++++----
 libxfs/xfs_bmap_btree.c     |    8 ++++----
 libxfs/xfs_btree.h          |    2 +-
 libxfs/xfs_btree_staging.c  |    8 ++++----
 libxfs/xfs_ialloc_btree.c   |   26 +++++++++++++-------------
 libxfs/xfs_refcount_btree.c |    8 ++++----
 libxfs/xfs_rmap_btree.c     |    8 ++++----
 7 files changed, 34 insertions(+), 34 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index c10f20d6..33b43c7c 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -48,10 +48,10 @@ xfs_allocbt_set_root(
 
 STATIC int
 xfs_allocbt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
 {
 	int			error;
 	xfs_agblock_t		bno;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 9e2e9926..0552157a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -191,10 +191,10 @@ xfs_bmbt_update_cursor(
 
 STATIC int
 xfs_bmbt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
 	int			error;		/* error return value */
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 504032d9..8a36012a 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -110,7 +110,7 @@ struct xfs_btree_ops {
 
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
-			       union xfs_btree_ptr *start_bno,
+			       const union xfs_btree_ptr *start_bno,
 			       union xfs_btree_ptr *new_bno,
 			       int *stat);
 	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index d808f0fc..146d2475 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -59,10 +59,10 @@ xfs_btree_fakeroot_dup_cursor(
  */
 STATIC int
 xfs_btree_fakeroot_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start_bno,
-	union xfs_btree_ptr	*new_bno,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start_bno,
+	union xfs_btree_ptr		*new_bno,
+	int				*stat)
 {
 	ASSERT(0);
 	return -EFSCORRUPTED;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index f644882b..5053c4a5 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -87,11 +87,11 @@ xfs_inobt_mod_blockcount(
 
 STATIC int
 __xfs_inobt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat,
-	enum xfs_ag_resv_type	resv)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat,
+	enum xfs_ag_resv_type		resv)
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
 	int			error;		/* error return value */
@@ -126,20 +126,20 @@ __xfs_inobt_alloc_block(
 
 STATIC int
 xfs_inobt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
 {
 	return __xfs_inobt_alloc_block(cur, start, new, stat, XFS_AG_RESV_NONE);
 }
 
 STATIC int
 xfs_finobt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
 {
 	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_alloc_block(cur, start, new, stat);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 291098a9..7a5a1a8d 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -50,10 +50,10 @@ xfs_refcountbt_set_root(
 
 STATIC int
 xfs_refcountbt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 755246c6..7a441f64 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -74,10 +74,10 @@ xfs_rmapbt_set_root(
 
 STATIC int
 xfs_rmapbt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
-	int			*stat)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;

