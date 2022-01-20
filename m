Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB411C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbiATAYZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345222AbiATAYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B3DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:24:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B88D26150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD0DC004E1;
        Thu, 20 Jan 2022 00:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638264;
        bh=eThtSgh6puhCDl2tK7Spv6x0YBKzRogBFmeU4mq/iwo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BCgA7aFIHSmuLkDg/ddnA6rsqs4rJX0aqCRuWHGkAHruYeu2fjrg7ZZRLrwHcEpkR
         HuX2mr2qLwjpuwWbHDUxQDPwPKLgz0g7fJ9WhiexyRlOb20S4X++PLOHqoSDlQ4YJQ
         bAudZ/n+BJ/gjtEZc8Ope3lZaB6+HetxLy2CAw8KQGOSehCVqk+UhLzmutik2zJkel
         7+jK6TeAi5O5sLXv4QTUx9G+KsjiUPtz+e+1B+QNDAdbrSZ7PCZcQ3rISjno/YZJEz
         QEwSQbNGowlVKzgx5N/s2tQ+xlOFWDoU76Vx+WWf1By3XfLKHZXLHcGt8xi4kspYP3
         3+RSTj7SXPrJw==
Subject: [PATCH 13/48] xfs: remove xfs_btree_cur.bc_blocklog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:23 -0800
Message-ID: <164263826380.865554.7368372957111538202.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: cc411740472d958b718b9c6a7791ba00d88f7cef

This field isn't used by anyone, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    1 -
 libxfs/xfs_bmap_btree.c     |    1 -
 libxfs/xfs_btree.h          |    1 -
 libxfs/xfs_ialloc_btree.c   |    2 --
 libxfs/xfs_refcount_btree.c |    1 -
 libxfs/xfs_rmap_btree.c     |    1 -
 6 files changed, 7 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 03ebefc3..46d0f229 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -480,7 +480,6 @@ xfs_allocbt_init_common(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index aea9b5a8..565e8af7 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -556,7 +556,6 @@ xfs_bmbt_init_cursor(
 	cur->bc_mp = mp;
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_btnum = XFS_BTNUM_BMAP;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 513ade4a..49ecc496 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -229,7 +229,6 @@ struct xfs_btree_cur
 #define	XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
 #define	XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
 	uint8_t		bc_nlevels;	/* number of levels in the tree */
-	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 1a5289ce..f1e03cfd 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -443,8 +443,6 @@ xfs_inobt_init_common(
 		cur->bc_ops = &xfs_finobt_ops;
 	}
 
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 62ef048c..f7f99cbd 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -325,7 +325,6 @@ xfs_refcountbt_init_common(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = XFS_BTNUM_REFC;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ca72324b..bba29eea 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -455,7 +455,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur->bc_btnum = XFS_BTNUM_RMAP;
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
 

