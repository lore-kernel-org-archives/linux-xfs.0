Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC66C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E380064EBD
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhCRWd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232036AbhCRWdv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A76264E0C;
        Thu, 18 Mar 2021 22:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106831;
        bh=KYC53cB2GhrlvnsYA+VBID7LbHjXcFMro8Ksem4B3cc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c/y395eeTpABS0Eh1o6YxDwMgWqebejlWmAPMyft96yCsQckdO9sxULSmJQBpEW9G
         6NsxZJWrfJykK+RKTZUDS3AqEa8pBo0H0UF9vb3bId4Z4n1+NaHTCFJFjJ3D4jd/Nt
         MPVmBnml4D6zp/aFOItFJ8zzB3BlfPnCJQwXY90rojK784EyULODpwuy/icaN9lOtx
         QfxgGMbVNqHmhk2sQQlCFqyfSsXf5CWuowKgPteE7Y3MdFpomZYi0as0S+RW2pHT6g
         v2U9f19Ez3xGxvFciceEl67WRCYqeKKP1fBO0YXkXX1csPLfqS/auwkNeWig6W8evR
         gFv3SJf1Eq6mg==
Subject: [PATCH 2/3] xfs: reduce indirect calls in xfs_inode_walk{,_ag}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:50 -0700
Message-ID: <161610683077.1887634.10625830989355684967.stgit@magnolia>
In-Reply-To: <161610681966.1887634.12780057277967410395.stgit@magnolia>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since the previous patch requires the forward static declaration of
xfs_blockgc_scan_inode, we can eliminate an indirect call from the body
of xfs_inode_walk_ag for a (probably minor) decrease in overhead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6924125a3c53..9198c7a7c3ca 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -858,8 +858,20 @@ xfs_inode_walk_ag(
 			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], args);
-			xfs_irele(batch[i]);
+			switch (tag) {
+			case XFS_ICI_BLOCKGC_TAG:
+				error = xfs_blockgc_scan_inode(batch[i], args);
+				xfs_irele(batch[i]);
+				break;
+			case XFS_ICI_NO_TAG:
+				error = execute(batch[i], args);
+				xfs_irele(batch[i]);
+				break;
+			default:
+				ASSERT(0);
+				error = -EFSCORRUPTED;
+				break;
+			}
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;

