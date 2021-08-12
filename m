Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2218CC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF4A660C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbhHLXce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237919AbhHLXcd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D718260C3E;
        Thu, 12 Aug 2021 23:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811127;
        bh=81Ify3rWIcvIWZAP/ieLhl7IFBrg4TszGWixJqs3EQ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SQzGpmJpyVViYCUuKlNOoVvGag0PpORRTMGkXAIcBnIBPBI0qfOPLOProaIT/99qi
         CadaifcEwJZbWjjjiWamNXkewLrOt8DUarScnv7ni/Kivqz2UddLt0NK6HIZHCpoip
         I9LcRx9zo8XnImlcS2BlXn11sOMTQxHE0VxdVpT83Y4FkFG65fLDvXQJxPyLIbRLSo
         /J+9Z5Bwqm/rRUxY8CdtMbumOoWOHrzZSyAm9AEZEjFNw25HMiCZyFvN9g9ZymsdPL
         VnDd/tQtH3HRGruaJN+52UHeR/nl+JeDoOOyRk1rD5a280TmcXzxcQu/C/P4z6PDqd
         ptQj3gH4lNrhQ==
Subject: [PATCH 08/10] xfs: make the start pointer passed to btree alloc_block
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:32:07 -0700
Message-ID: <162881112756.1695493.5877305257052136774.stgit@magnolia>
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

The @start pointer passed to each per-AG btree type's ->alloc_block
function isn't supposed to be modified, since it's a hint about the
location of the btree block being split that is to be fed to the
allocator, so mark the parameter const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    8 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |    8 ++++----
 fs/xfs/libxfs/xfs_btree.h          |    2 +-
 fs/xfs/libxfs/xfs_btree_staging.c  |    8 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   26 +++++++++++++-------------
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 ++++----
 fs/xfs/libxfs/xfs_rmap_btree.c     |    8 ++++----
 7 files changed, 34 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 87f7f9f27449..0b9303caf41a 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -50,10 +50,10 @@ xfs_allocbt_set_root(
 
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 961f0193b058..3bb7c03ea4d1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -193,10 +193,10 @@ xfs_bmbt_update_cursor(
 
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 504032d91a0a..8a36012a2e89 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -110,7 +110,7 @@ struct xfs_btree_ops {
 
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
-			       union xfs_btree_ptr *start_bno,
+			       const union xfs_btree_ptr *start_bno,
 			       union xfs_btree_ptr *new_bno,
 			       int *stat);
 	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index bce6a3da9865..ac9e80152b5c 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 903537a08c8e..cb602ba8b5d1 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -88,11 +88,11 @@ xfs_inobt_mod_blockcount(
 
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
@@ -127,20 +127,20 @@ __xfs_inobt_alloc_block(
 
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index ec4b7195c371..3c97c24f033b 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -51,10 +51,10 @@ xfs_refcountbt_set_root(
 
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 4b62064d0baa..aa86f35d05fc 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -76,10 +76,10 @@ xfs_rmapbt_set_root(
 
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

