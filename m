Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FFBC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38864600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhIOXIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhIOXIy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A89E610A4;
        Wed, 15 Sep 2021 23:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747255;
        bh=SM5noYSrY3lUsOysbND8gaTzoX+E/ImsV2Q2UPPrzZ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AKNpt7+3n/MLBuCmR6csGUrvhopHAv+nXf0vTspqhlxBjVKLQPjHAon6gcJFfHDC1
         9ODVnRKqPOMgmsYvHQoVn7wi0i1w8e7b3o+0Mhco39XoF19dckiezS88lNVgxWLMa1
         ZEu1Y7+dAYlpYXiW/XSb62dd9PD/3HAt6qkkNTYrA8jSdFqoJe/6bulaX6jNU2ZY/f
         1VLwBZauk4nzB22snD/xUlPc+ZXLUV+AHyXVVVt9CMZSmsNTYqqLn4R1DyIUCnqOkJ
         I8k+hZGNiFHDmYtLCpNKNTW7TLjimMxUu5gR8KmYrJHQ4Q9OhaSq7U+rKVF3AGJk6o
         7k/cNlyilRIHg==
Subject: [PATCH 11/61] xfs: Refactor xfs_attr_set_shortform
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:34 -0700
Message-ID: <163174725477.350433.17329349440640687673.stgit@magnolia>
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

Source kernel commit: 6286514b63e12d7bedc67e46aa1aeff9ed8378ce

This patch is actually the combination of patches from the previous
version (v18).  Initially patch 3 hoisted xfs_attr_set_shortform, and
the next added the helper xfs_attr_set_fmt. xfs_attr_set_fmt is similar
the old xfs_attr_set_shortform. It returns 0 when the attr has been set
and no further action is needed. It returns -EAGAIN when shortform has
been transformed to leaf, and the calling function should proceed the
set the attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5da3ec39..b181777d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -236,16 +236,11 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
 STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
 {
+	struct xfs_buf          *leaf_bp = NULL;
 	struct xfs_inode	*dp = args->dp;
 	int			error, error2 = 0;
 
@@ -258,29 +253,29 @@ xfs_attr_set_shortform(
 		args->trans = NULL;
 		return error ? error : error2;
 	}
+
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
 	if (error)
 		return error;
 
 	/*
 	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
 	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
+	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, leaf_bp);
 	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
 	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
+		xfs_trans_brelse(args->trans, leaf_bp);
 		return error;
 	}
 
-	return 0;
+	return -EAGAIN;
 }
 
 /*
@@ -291,8 +286,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -301,15 +295,8 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-
-		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
-		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
 	}
 
@@ -344,8 +331,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*

