Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1503C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9862E600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOXJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhIOXJK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677E8610A4;
        Wed, 15 Sep 2021 23:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747271;
        bh=QDWCRnCp9vaOHDjCaTJsItOQOScOTnu/Z4GEHtGxq/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K7r3sQGf625ftAGKUjDHyNmgaePKIwAq+mGMW6W/0XOMiNV+sTan2soS2jTQqxufZ
         wFsz/9gYaIDHq0gs2LCWCViEK+W5mBdozL1xDdVrn3daH3bqaZweyQLbEjNU9hIIsB
         K5kcGI3hNiPaMBVOTImMajsHoeguJ7MrRDLdBLZ3MVneVI54rvswA7KUut2HTAmGKx
         NOjyXu3oLNpYHbbkejx2znIySpPKo36KH345Tp/NeXODSUSqD9QHGd2eVPxwPO2PqN
         bgzpvfY7icPmG1HK+ocZ+suKAaZ2s/M81X0fYlRFzXy2skdCtMS3VlfSEhbCeFNUaD
         LzfHBwo0i/nWQ==
Subject: [PATCH 14/61] xfs: Hoist xfs_attr_node_addname
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:51 -0700
Message-ID: <163174727115.350433.15129593227303742709.stgit@magnolia>
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

Source kernel commit: 5d954cc09f6baed80458ea02ec092031608ea3fe

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |  159 +++++++++++++++++++++++++----------------------------
 1 file changed, 75 insertions(+), 84 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 32a51d56..16e919d2 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
@@ -290,8 +291,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -342,7 +343,75 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
 
+	/*
+	 * Commit the leaf addition or btree split and start the next
+	 * trans in the chain.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, dp);
+	if (error)
+		goto out;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_set(args);
+		if (error)
+			return error;
+	}
+
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		goto out;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
+
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
+	}
+
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
 	return error;
 }
 
@@ -968,7 +1037,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -976,8 +1045,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1023,88 +1092,10 @@ xfs_attr_node_addname(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 
-	/*
-	 * Kill the state structure, we're done with it and need to
-	 * allow the buffers to come back later.
-	 */
-	xfs_da_state_free(state);
-	state = NULL;
-
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	error = xfs_attr_node_addname_clear_incomplete(args);
-	if (error)
-		goto out;
-	retval = 0;
 out:
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 

