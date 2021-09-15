Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55887C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C59610D1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhIOXJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXJn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28480600D4;
        Wed, 15 Sep 2021 23:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747304;
        bh=sZOSu8rreDJBcjpJU7tw58/7VcXBhYFoBKLNeECTo8A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bq5rjo3a3uoeJ4V5kr9V6R8iJaoA2Gc9Jhst6YP4UDNeUabcuCDu4cBej2U/ue2wl
         dzpZjPN8BXknglXBCOrSAx34N23pPcpkizpVnqFguyk2DQoxKAiYrHNu4Fas41fTTr
         uduY7tRiX/NrJgbpzLAB+G8G4im+sbObD2dUpIsSeTHMkAZgXBqIQwAjpOoQWSFjnq
         1iGNKBrq7hwHgkSeq8yxvuxfOsWX99n3wIz2OhJFJXMh3OEJGfPhR6HPYmj9P1RPPH
         VDNHAQ6RjchRHXJYZdTeSbxhKTYRmfNJiYNSepiuN6agQTxgyZfGE1iPhNM7zCRqTe
         Wa99bRJkOf5eg==
Subject: [PATCH 20/61] xfs: Clean up xfs_attr_node_addname_clear_incomplete
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:23 -0700
Message-ID: <163174730391.350433.15101407424452926045.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 4fd084dbbd05402bb6e24782b8e9f9ea3e8ab3d6

We can use the helper function xfs_attr_node_remove_name to reduce
duplicate code in this function

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 347f854e..edc19de6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -63,6 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
+STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
+				     struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -1207,7 +1209,6 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
-	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1222,13 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[state->path.active-1];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	error = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	error = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.

