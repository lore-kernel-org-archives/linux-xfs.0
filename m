Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FF7C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F9AD6103E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbhHLXc2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237906AbhHLXc2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D5896103E;
        Thu, 12 Aug 2021 23:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811122;
        bh=IPcOg8KgJ2LM1/LFxbsktfe3n8ryzT0269BL5lkYwm4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T5Y4JMkQ2cDnBQO/wH2dApvGM5fTk6W0Yv0iKmeRRSyDTpTnIetwiiaU6xGlA6ATL
         kQIj0pOjg4lC8r3wwtA1XeTw79xxjGNEsuJCIGdvZOgV0eTXJjAbJn51tz0qQRtCdz
         PLJRZm0MOB0VBwqqYFhd6B6oNrailasMy6q0sw9rhDCSQWcji2UAckDYQaFllIh26a
         xozVqNSFPid6t399n+DXhh8GLxCYFC58qJhUFfYddd1FAwy3WQrkp0KChYt2Dx6Ern
         bPcqgl2gHtjQ/14ZWWeqAAx7ykNZag4+NFuUpVFY+a/7AxC9CsB10vIuFVzEOCMsM2
         THWcPL5YO09ow==
Subject: [PATCH 07/10] xfs: make the pointer passed to btree set_root
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:32:02 -0700
Message-ID: <162881112205.1695493.15576454755917300007.stgit@magnolia>
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

The pointer passed to each per-AG btree type's ->set_root function isn't
supposed to be modified (that function sets an external pointer to the
root block) so mark them const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 +++---
 fs/xfs/libxfs/xfs_btree.h          |    2 +-
 fs/xfs/libxfs/xfs_btree_staging.c  |    6 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   12 ++++++------
 fs/xfs/libxfs/xfs_refcount_btree.c |    6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |    6 +++---
 6 files changed, 19 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index c2d2a0be56d8..87f7f9f27449 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -31,9 +31,9 @@ xfs_allocbt_dup_cursor(
 
 STATIC void
 xfs_allocbt_set_root(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	int			inc)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4b95373c6d23..504032d91a0a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -106,7 +106,7 @@ struct xfs_btree_ops {
 
 	/* update btree root pointer */
 	void	(*set_root)(struct xfs_btree_cur *cur,
-			    union xfs_btree_ptr *nptr, int level_change);
+			    const union xfs_btree_ptr *nptr, int level_change);
 
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index aa8dc9521c39..bce6a3da9865 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -112,9 +112,9 @@ xfs_btree_fakeroot_init_ptr_from_cur(
 /* Update the btree root information for a per-AG fake root. */
 STATIC void
 xfs_btree_afakeroot_set_root(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	int			inc)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
 {
 	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a6ba08bb9bfe..903537a08c8e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -40,9 +40,9 @@ xfs_inobt_dup_cursor(
 
 STATIC void
 xfs_inobt_set_root(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*nptr,
-	int			inc)	/* level change */
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*nptr,
+	int				inc)	/* level change */
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agi		*agi = agbp->b_addr;
@@ -54,9 +54,9 @@ xfs_inobt_set_root(
 
 STATIC void
 xfs_finobt_set_root(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*nptr,
-	int			inc)	/* level change */
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*nptr,
+	int				inc)	/* level change */
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agi		*agi = agbp->b_addr;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 907869014a99..ec4b7195c371 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -31,9 +31,9 @@ xfs_refcountbt_dup_cursor(
 
 STATIC void
 xfs_refcountbt_set_root(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	int			inc)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 3c3cf4971bd7..4b62064d0baa 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -57,9 +57,9 @@ xfs_rmapbt_dup_cursor(
 
 STATIC void
 xfs_rmapbt_set_root(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	int			inc)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;

