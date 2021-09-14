Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90648C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78541610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhINCmj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINCmi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C9E6610FB;
        Tue, 14 Sep 2021 02:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587282;
        bh=653Y42PGC3qIZsMbFcFSRvsJ8b02uOLCx9qxZCfAkho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G2K7KyhcXk/IDlp1eXSeJNBEKvf9TVZOZuTRakCiDKY3i6HTHWlduZUM+LRxSWbx4
         HRe6wq/Non25PdlC36mhADdB+9SJduOHs4DUnAJ8//0eJOUmyoEPyGtauKJA0+SiV1
         MSe+bapO1w+GnT/O/PvyFWu/QRdSVgWiOeu9jB7/eHKpELI1zatBs8ahVyFisK/yWe
         op3fnf1ob3S2tI4JBmFEUmtnhYCoU8QkMMo3GzZLcBWNeRwK+dmNUJN04jmh7KGNtP
         HmPFpN3PMPYFPzS6R5U4vuwju921v1yvbla3LbHtL6J3ScB45FZ0ValhyFHLPOAPQi
         o19av8fITdOmg==
Subject: [PATCH 15/43] xfs: make the pointer passed to btree set_root
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:22 -0700
Message-ID: <163158728198.1604118.6785493093865692097.stgit@magnolia>
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

Source kernel commit: b5a6e5fe0e6840bc90e51cf522d6c5a880cde567

The pointer passed to each per-AG btree type's ->set_root function isn't
supposed to be modified (that function sets an external pointer to the
root block) so mark them const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    6 +++---
 libxfs/xfs_btree.h          |    2 +-
 libxfs/xfs_btree_staging.c  |    6 +++---
 libxfs/xfs_ialloc_btree.c   |   12 ++++++------
 libxfs/xfs_refcount_btree.c |    6 +++---
 libxfs/xfs_rmap_btree.c     |    6 +++---
 6 files changed, 19 insertions(+), 19 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 79130125..c10f20d6 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -29,9 +29,9 @@ xfs_allocbt_dup_cursor(
 
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4b95373c..504032d9 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -106,7 +106,7 @@ struct xfs_btree_ops {
 
 	/* update btree root pointer */
 	void	(*set_root)(struct xfs_btree_cur *cur,
-			    union xfs_btree_ptr *nptr, int level_change);
+			    const union xfs_btree_ptr *nptr, int level_change);
 
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index ace2eb7c..d808f0fc 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
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
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 14b54f13..f644882b 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -39,9 +39,9 @@ xfs_inobt_dup_cursor(
 
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
@@ -53,9 +53,9 @@ xfs_inobt_set_root(
 
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
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index b088c4a0..291098a9 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -30,9 +30,9 @@ xfs_refcountbt_dup_cursor(
 
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
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 6d28a469..755246c6 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -55,9 +55,9 @@ xfs_rmapbt_dup_cursor(
 
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

