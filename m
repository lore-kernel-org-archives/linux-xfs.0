Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C423C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbiATASy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45964 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiATASx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB61B81C34
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1DDC004E1;
        Thu, 20 Jan 2022 00:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637931;
        bh=653Y42PGC3qIZsMbFcFSRvsJ8b02uOLCx9qxZCfAkho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VQ//0epfNuLAVKIP8y0URk82m5ySCqpAIxZRQ75xAo2EAKlLCm59YqB3CjFBBaKwa
         iK+/lJTkVCTKiSJIzdb2lEQVW9KNjA2e963b8hXy3L5Qkfi69AVEOEcIGk/XCtHE4y
         7uGQOpwSolM2LhMP2xR2kfgIBQP+tGVr6nWQ/NzT77lLwbK60R+x0vXjUg46sPBt0v
         mJvIybDXTJEZtCHWvwVfunQuS0coDOkU3sUqkk6KzeQUwsoWQLrHSO8fcUeYg8pAzr
         XHP4bBaWMjgkbjT3qdH4gKAMbFh7WDkV2xw7OsMSvLq8dJDiPQ9Jz0jNpMjWLXuDM+
         HHtHspWt/S+Aw==
Subject: [PATCH 16/45] xfs: make the pointer passed to btree set_root
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:50 -0800
Message-ID: <164263793088.860211.10462673504159783783.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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

