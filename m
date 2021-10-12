Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5959C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5F760ED4
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhJLXem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhJLXel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6DA60E53;
        Tue, 12 Oct 2021 23:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081559;
        bh=4F6K/QG6wH1qhqYOUuEKtyGHLGPZG8SV64N8qHlbXWI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uG0MrFBDa+CFdsTIq12y/sAm1Mgr2CvOQ6JDPUld2koLZzu2aJ0WR5JY9XFBoky8m
         e0+NBgFADCXer7su+AApDxQaijpyLK0l+7YTs31s+SeBTkKZY/0YlLMnvX/cg82Rif
         HguaivSCZ17IOiVghg0Xk5HUJKwUFuFwoXJFrcYc3DylJL/u6ilDWqZy50XMhppbU8
         5gci9mVzA94GllI5fqcDY8WjXJ6Md5RnC6bWKQDpyjBvpn8Ov3ZzXua4tde1fOExXa
         /V+a0swCtiNLjbHrCyZ/LX+D7jzZpqYHGs+afQRCfDX5KKihGN1Z2ZtlVJwU7eBoIp
         MuKGinsB5quug==
Subject: [PATCH 01/15] xfs: remove xfs_btree_cur.bc_blocklog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:32:39 -0700
Message-ID: <163408155929.4151249.7734053676233395860.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This field isn't used by anyone, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    1 -
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 -
 fs/xfs/libxfs/xfs_btree.h          |    1 -
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 --
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 -
 6 files changed, 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6746fd735550..152ed2a202f4 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -482,7 +482,6 @@ xfs_allocbt_init_common(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 72444b8b38a6..a43dea8d6a65 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -558,7 +558,6 @@ xfs_bmbt_init_cursor(
 	cur->bc_mp = mp;
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_btnum = XFS_BTNUM_BMAP;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 513ade4a89f8..49ecc496238f 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -229,7 +229,6 @@ struct xfs_btree_cur
 #define	XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
 #define	XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
 	uint8_t		bc_nlevels;	/* number of levels in the tree */
-	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 27190840c5d8..10736b89b679 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -444,8 +444,6 @@ xfs_inobt_init_common(
 		cur->bc_ops = &xfs_finobt_ops;
 	}
 
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1ef9b99962ab..3ea589f15b14 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -326,7 +326,6 @@ xfs_refcountbt_init_common(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = XFS_BTNUM_REFC;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b7dbbfb3aeed..d65bf3c6f25e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -457,7 +457,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur->bc_btnum = XFS_BTNUM_RMAP;
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
 

