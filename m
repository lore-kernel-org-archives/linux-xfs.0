Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC90DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiL3XqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbiL3XqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:46:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78C81DF30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:46:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70443B81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5FFC433EF;
        Fri, 30 Dec 2022 23:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443960;
        bh=uXpLTXTiUXVFcA+7dzHlme9I3pedaIIbqPuON3hPIIk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YvpRjhc67Hu6Bq22ItmJNfEHXGDmxFi5cKW/80eh1O9icLlw3s5UnvbeDMvu6zGUq
         HuYsr+H2jGy52kX+06J7+Ex5KYuMbusT+R+esDkvlHDhDlCO7bBtvXLW4iHLGbN97P
         7qufbZwQodR075ZUoGO2Ta+Om2bCiQlrBi8Bab/2vL3GuFNB/Jqhcxpx5VYpTlABfH
         BlkdAOBfy/CqdZGGAfi7eKyaF0+bvdWvnIjkS89DaZqvFLqVy35mHq1ExFyitWAfxp
         g9r7rHLBeOfShAmTu7k9M84N8S4mLCMLhRPHpoeaZy7IuVpptg/UKVBJeXiG2S5jIw
         oNk23yS+4/+CQ==
Subject: [PATCH 8/9] xfs: set btree block buffer ops in _init_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:34 -0800
Message-ID: <167243841484.696890.2949357059622229756.stgit@magnolia>
In-Reply-To: <167243841359.696890.6518296492918665756.stgit@magnolia>
References: <167243841359.696890.6518296492918665756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Set the btree block buffer ops in xfs_btree_init_buf since we already
have access to that information through the btree ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c  |    1 -
 fs/xfs/libxfs/xfs_btree.c |    1 +
 fs/xfs/scrub/xfbtree.c    |    1 -
 3 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ee94c935702d..9b99669be43d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -693,7 +693,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 54afec1f9121..737342918e11 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1278,6 +1278,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index d42d1bc8e36b..ac7b9f679b56 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -415,7 +415,6 @@ xfbtree_init_leaf_block(
 
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
-	bp->b_ops = cfg->btree_ops->buf_ops;
 	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);

