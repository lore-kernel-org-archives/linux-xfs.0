Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6066CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C8F600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhIOXJG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXJF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED623610A4;
        Wed, 15 Sep 2021 23:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747266;
        bh=iafA21hIfq/mIJ1MPQjPlhcF6KIzbX7NBnBqFHUhtyI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U6d3sNfIGgJVD9PU9YaI+hKnp8/dgNBYWRqdX48+U9IuVGJT/IUIM4AU1HYO4erlZ
         D09jYQPabdbCnII9FhXaSqqE3P8SzsFcrJGWW6P4U5deg0b5XOGSylEMqA03PsE54l
         eNu2CoXuCzbR7CRqNvz7tdZZ7uhc27OjttW/BZzERUY4UyyZ8WqL/vqBxuZW4lXUR1
         iojlpdJ99pAtS9khsNWeTgWaYa64t44AX7FwUXHZ751k/UdEGVsjqC5Ov1BAzsNu6T
         B0baQejyPF+ZIlbAjYH1d+XkH8FejQf6wDEeAjSUOjnY3G52kx/T67Rgjm6hFZpGq0
         njppRFaZM7mjg==
Subject: [PATCH 13/61] xfs: Add helper xfs_attr_node_addname_find_attr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:45 -0700
Message-ID: <163174726568.350433.16535608870459259637.stgit@magnolia>
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

Source kernel commit: 6ca5a4a1f52952790a40099b79b5631d91163ba4

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |  101 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 40 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 158149af..32a51d56 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -287,6 +290,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -332,7 +336,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -896,6 +907,50 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
+STATIC int
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
+{
+	int			retval;
+
+	/*
+	 * Search to see if name already exists, and get back a pointer
+	 * to where it should go.
+	 */
+	retval = xfs_attr_node_hasname(args, state);
+	if (retval != -ENOATTR && retval != -EEXIST)
+		goto error;
+
+	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
+		goto error;
+	if (retval == -EEXIST) {
+		if (args->attr_flags & XATTR_CREATE)
+			goto error;
+
+		trace_xfs_attr_node_replace(args);
+
+		/* save the attribute state for later removal*/
+		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
+		xfs_attr_save_rmt_blk(args);
+
+		/*
+		 * clear the remote attr state now that it is saved so that the
+		 * values reflect the state of the attribute we are about to
+		 * add, not the attribute we just found and will remove later.
+		 */
+		args->rmtblkno = 0;
+		args->rmtblkcnt = 0;
+		args->rmtvaluelen = 0;
+	}
+
+	return 0;
+error:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
 /*
  * Add a name to a Btree-format attribute list.
  *
@@ -908,52 +963,18 @@ xfs_attr_node_hasname(
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
 	int			retval, error;
 
 	trace_xfs_attr_node_addname(args);
 
-	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
 	dp = args->dp;
-restart:
-	/*
-	 * Search to see if name already exists, and get back a pointer
-	 * to where it should go.
-	 */
-	error = 0;
-	retval = xfs_attr_node_hasname(args, &state);
-	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
-
-	blk = &state->path.blk[ state->path.active-1 ];
+	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
-	if (retval == -EEXIST) {
-		if (args->attr_flags & XATTR_CREATE)
-			goto out;
-
-		trace_xfs_attr_node_replace(args);
-
-		/* save the attribute state for later removal*/
-		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
-		xfs_attr_save_rmt_blk(args);
-
-		/*
-		 * clear the remote attr state now that it is saved so that the
-		 * values reflect the state of the attribute we are about to
-		 * add, not the attribute we just found and will remove later.
-		 */
-		args->rmtblkno = 0;
-		args->rmtblkcnt = 0;
-		args->rmtvaluelen = 0;
-	}
 
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
@@ -980,7 +1001,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*

