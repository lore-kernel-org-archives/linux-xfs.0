Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526ADC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300DA61152
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhIRBbG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234492AbhIRBbF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06F5F6112E;
        Sat, 18 Sep 2021 01:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928583;
        bh=LyGKZh25qDkbXOV4fTNukRG2/PAIjNqQ5GVg2Fv0EQQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=faaz58oSiXizO7S+nLMVQwxWDz4qZZ5MA5pNRZP0t8FNrc6WLiU1kF0NtlKD3TEr7
         +RHWnQQyK2MeXGZjSjKrUDWvF8Sn0/4ury+ilgw+ByFFiH+qaWLG56liGCEcssel0A
         Zz2FybErG4j9sg92djCi5dhGrTKPt6E8lYOzT/8ej5AN+GCzqHD3om9bMOIQtWHuwU
         z9YW7qkVHafmdfB6gnYNfrT4n6nl+pBF8rZQwaWgeTxNGy9MbE0fzXUf1u2TUYFw7n
         GLHTwxCXFTinh0Tract90nqG4f9iGdS6BmKL0FYZ+Y3GvMdDO7hLeJ6OzpLnHJ98dm
         E0Rv6+zM9/SLA==
Subject: [PATCH 06/14] xfs: check that bc_nlevels never overflows
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:42 -0700
Message-ID: <163192858276.416199.6204001049315596078.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
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
index ac9e80152b5c..26143297bb7b 100644
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

