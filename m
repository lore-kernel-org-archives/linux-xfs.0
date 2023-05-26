Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1204BC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZBKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZBKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:10:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925999B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2789E64C14
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B739C433EF;
        Fri, 26 May 2023 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063403;
        bh=z8PchLuriAQHkZoXT0OIjj+UkuRSiqFUMdWXI9Ltg/I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iIHzdgesju0knGLlYX2X3BDu296LDyknbONZVuuglgsBnQ66AvI+li8JLQIgvA54w
         YgGWPFCBPy2mt4O3G8ToeTNMjj9i/QZy5q06ALNb1PwW8HvsmeAPCMvhKSrcBfAKZZ
         VY708wG2Mit2QZete4q36JxXNBAyyntKrDqxtLUDiQso9NrHjHRlgtMg4JCncCcf1y
         NCpFh11dQE+RKCElRA4KF83NlVv8OHG+UizpQds6HWrTd059iFQ5dav6pIA6j1V2SQ
         sPkNN72QO1NlV1YIQcZP6X9V5FGDIGr7rsWLsxIfHZF0jdYwrk8BxlKQ+OGqIGgctf
         CbschwYWWIJGw==
Date:   Thu, 25 May 2023 18:10:03 -0700
Subject: [PATCH 8/9] xfs: set btree block buffer ops in _init_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062797.3733506.2570835441273974344.stgit@frogsfrogsfrogs>
In-Reply-To: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
References: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
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
index 456f2559790b..875b1d9576ac 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -682,7 +682,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 285dc609daa8..5af19610d891 100644
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
index e7975f462428..b5874e3f39da 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -415,7 +415,6 @@ xfbtree_init_leaf_block(
 
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
-	bp->b_ops = cfg->btree_ops->buf_ops;
 	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);

