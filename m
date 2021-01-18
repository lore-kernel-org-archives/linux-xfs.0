Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C321BC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8157E22CB1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388352AbhARWOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388360AbhARWN6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B1C322D58;
        Mon, 18 Jan 2021 22:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007998;
        bh=vV+qbCKplHVwclTP+4xHv2YY+xG34Eg8aBs3vL/i4XY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tovBjpbEjhAZIORQ/XytGmSqS06GfWa4dbee0CFda7tRSBkRFJ3epJGtrFh2Xj4ID
         XlIRaRsVaveHfX/ZhzWDWyE9hBWdiK8IFbQ3j9oZnVQMPo/Z/tKn+K4FK0oeuLolPb
         v0O0AXNKeEEAzzkMOaTSgZdQgEXoZSlG9r/aC4cBczp6BhoVqJudJQF2ahf0IfQAIM
         553frQqV2KnEFfnRUpNCMjQ2TzcR7+SbyCAY4rZn7/WDu6wI8e+byyoUP516EboR0T
         YRUb6pYZMW7rURWRCLNPnwadXc/Xs2NjEg7XYi+XMdwYZIwVSGVyOzP6tijrwcp83e
         gh1Mw6zPQfJGA==
Subject: [PATCH 03/10] xfs: hide xfs_icache_free_cowblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:17 -0800
Message-ID: <161100799781.90204.6400744147219775342.stgit@magnolia>
In-Reply-To: <161100798100.90204.7839064495063223590.stgit@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the one remaining caller of xfs_icache_free_cowblocks to use our
new combined blockgc scan function instead, since we will soon be
combining the two scans.  This introduces a slight behavior change,
since a readonly remount now clears out post-EOF preallocations and not
just CoW staging extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_icache.h |    1 -
 fs/xfs/xfs_super.c  |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e80adadcf81a..097dd979e182 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1567,7 +1567,7 @@ xfs_inode_free_cowblocks(
 	return ret;
 }
 
-int
+static int
 xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index b31155c9087c..a48c70008e5c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -68,7 +68,6 @@ void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 813be879a5e5..d17fbdb2a656 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1743,7 +1743,7 @@ xfs_remount_ro(
 	xfs_stop_block_reaping(mp);
 
 	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
+	error = xfs_blockgc_free_space(mp, NULL);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;

