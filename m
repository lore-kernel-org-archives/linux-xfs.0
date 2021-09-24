Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94593C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B8B610CB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbhIXB23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243740AbhIXB22 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FCF7604E9;
        Fri, 24 Sep 2021 01:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446816;
        bh=tUXQYzReRyQkafmeQeQrfivW9TpMGhUnbxCr3k9zlNo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=efmGLYCaxRC7BZBSxgxQcAJCFB6rgvYSoD4n6Y0KfTRTDAszn1R7+ap4EJSC00hRH
         Hb+JH3FstRzrHopPC6Bvv09ujqZxM1xg25MlL8x25WCUKtHoP2t778gF78QoYZWtDm
         r6OfZHhCAx4mv+Gd1QuDWc61BRcbnFmS28GPZUbEqxuvqA1hxp6pIveTXEwYtY8BvP
         HZxk1AKLPZPUY0MuNu/haf1o2nggcwpS3+0vc/i5UQtOPXDffyZscgUnrn/ONogdno
         3vDw2O08LhVc1cVlOImKoi5xOfusw26rPtHcfqMGluOncnzMQFkaIW3E3PJJKxUrpN
         VaTZpgLQV0uhA==
Subject: [PATCH 08/15] xfs: check that bc_nlevels never overflows
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:26:55 -0700
Message-ID: <163244681592.2701302.2389326771667274348.stgit@magnolia>
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

Warn if we ever bump nlevels higher than the allowed maximum cursor
height.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c         |    2 ++
 fs/xfs/libxfs/xfs_btree_staging.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b0cce0932f02..bc4e49f0456a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2933,6 +2933,7 @@ xfs_btree_new_iroot(
 	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
+	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 	cur->bc_ptrs[level + 1] = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
@@ -3096,6 +3097,7 @@ xfs_btree_new_root(
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
 	cur->bc_ptrs[cur->bc_nlevels] = nptr;
 	cur->bc_nlevels++;
+	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 	*stat = 1;
 	return 0;
 error0:
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 89c8a1498df1..cc56efc2b90a 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -703,6 +703,7 @@ xfs_btree_bload_compute_geometry(
 			 * block-based btree level.
 			 */
 			cur->bc_nlevels++;
+			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 			xfs_btree_bload_level_geometry(cur, bbl, level,
 					nr_this_level, &avg_per_block,
 					&level_blocks, &dontcare64);
@@ -718,6 +719,7 @@ xfs_btree_bload_compute_geometry(
 
 			/* Otherwise, we need another level of btree. */
 			cur->bc_nlevels++;
+			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 		}
 
 		nr_blocks += level_blocks;

