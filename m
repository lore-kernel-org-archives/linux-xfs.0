Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC130C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240445AbiATAXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiATAXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6F5C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC95561514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18143C004E1;
        Thu, 20 Jan 2022 00:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638220;
        bh=X/vEeiKdGLizcL6jAwlWsAFcrcSZpQpEOvIUbsI09Us=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zwq6FqxKhAfN2LlcDeMhX+bSoxZHrGmI9VCgU7AmW/DXVa9PMEKVSz25W22a1l9Gb
         sWQMUvCrVzPTrDyNX8ywwTj7HvcUhosZQLbWOg4tJ19t1DKf+3iWZ15EceOUVj+O5A
         seGa4txvN3d9U0bJMg2eQkswYMkjS+nsoBvUKoKJ1hJhWDFMPGU4VqxMemVPVaf0CT
         sa0bM1RI/8ezJOs1wV+jnuzvJ3NxQr/eVhrsAHzyBZjQYeYGMhVDBJyAheO8kEbnwl
         e+m+msYEBmIP8lJLWXouSFIOx8zZ3nPBQPZIZBF06/O5YZAZYLmJFf7JzkC0g6QNiy
         K0BzzjSclIACw==
Subject: [PATCH 05/48] xfs: check that bc_nlevels never overflows
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:39 -0800
Message-ID: <164263821980.865554.4911263848271071817.stgit@magnolia>
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

Source kernel commit: 4c175af2ccd3e0d618b2af941e656fabc453c4af

Warn if we ever bump nlevels higher than the allowed maximum cursor
height.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c         |    2 ++
 libxfs/xfs_btree_staging.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 7097abde..426ab7f8 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2934,6 +2934,7 @@ xfs_btree_new_iroot(
 	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
+	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 	cur->bc_ptrs[level + 1] = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
@@ -3097,6 +3098,7 @@ xfs_btree_new_root(
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
 	cur->bc_ptrs[cur->bc_nlevels] = nptr;
 	cur->bc_nlevels++;
+	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 	*stat = 1;
 	return 0;
 error0:
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index daf99797..aa3d49cf 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
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

