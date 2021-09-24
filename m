Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D394C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAF861211
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbhIXB1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243744AbhIXB1u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:27:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3FB761100;
        Fri, 24 Sep 2021 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446777;
        bh=NDUF87LyJZAchJBvOKbqdXmQXsDFkuH+S4Ye/wXnYoE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nHKZ/TfEZmpSOLLpyeW+bOFicKdn7qEBRHZEACeSTBklqVbVchMPss7ytHZMnXttJ
         pPpSJ2Hlsg7KIuj8PRqzwweKA+qhmYn+/h5HrC0p8KD6nANo5uDnb9KmVDbCSQsfLg
         xDzW+9/UTJoCA+/eDNgFiFoNb4HnGiYxbq0qmml0GGoRKqzJq0QAjznAMwn51TcnuP
         SzlrNAKt5u/tLuTxb245Teh6NBNSR48mqc9h6qZJhOFc5/xWQU4CdxS9lA6aLS0pIn
         HCQh1ak34CmnAOd+jEq+X7sLsJHcvX81sC+2l6Ew0Pidl5/HsWmlAFpOtkvDIdSsSu
         BsgluZuL2Sw2A==
Subject: [PATCH 01/15] xfs: fix maxlevels comparisons in the btree staging
 code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:26:17 -0700
Message-ID: <163244677758.2701302.11176093546368019785.stgit@magnolia>
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

The btree geometry computation function has an off-by-one error in that
it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
This can result in repairs failing unnecessarily on very fragmented
filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
the per-btree type computations will make this a much more likely
occurrence.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index ac9e80152b5c..89c8a1498df1 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -724,7 +724,7 @@ xfs_btree_bload_compute_geometry(
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;

