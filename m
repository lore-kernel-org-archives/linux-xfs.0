Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B65C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AC38610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhIOXM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232894AbhIOXM1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BE8E600D4;
        Wed, 15 Sep 2021 23:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747468;
        bh=5bhK7AQGoHsIFX7Qw5FbjkTaV9mZTpdQvudTV5vDCDw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mHSqbeNaKZLCu2l1ugnzTv1JTaBvD4tI0NynFBlSaVfLJlvmtlTqQYU1MAGoAiV8M
         V4FGhjr8rmcsQe7K8dEVl36FABvJ99rk/ZystxtwXqfUgiGGu5/52EZjVWoZ+UkMIH
         Am2HqIbJcvbSwhDMKOn+vwhQYmQn+bic10qUJ4/4DAoI2q0r3g5ohYLljpkDXCAzb0
         Y5Dd4n8gIloE33pha09lZXIux02nqT7xap/E+12GQ63yu8k0zd1D5DtpLQovO3179p
         apbIojSGRRvBxfeu5dnO/XNN746GPrJdIFQKXgrGTKi6RuWqu7C2XIk8kxvLRan+gq
         6WAYz9/sMAXZg==
Subject: [PATCH 50/61] xfs: Make attr name schemes consistent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:07 -0700
Message-ID: <163174746784.350433.11265996869720933535.stgit@magnolia>
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

Source kernel commit: 816c8e39b7ea0875640312c9ed3be0d5a68d7183

This patch renames the following functions to make the nameing scheme more consistent:
xfs_attr_shortform_remove -> xfs_attr_sf_removename
xfs_attr_node_remove_name -> xfs_attr_node_removename
xfs_attr_set_fmt -> xfs_attr_sf_addname

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      |   18 +++++++++---------
 libxfs/xfs_attr_leaf.c |    2 +-
 libxfs/xfs_attr_leaf.h |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cbac7612..8f6f1754 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -63,8 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
-STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
-				     struct xfs_da_state *state);
+STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
+				    struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -298,7 +298,7 @@ xfs_attr_set_args(
 }
 
 STATIC int
-xfs_attr_set_fmt(
+xfs_attr_sf_addname(
 	struct xfs_delattr_context	*dac,
 	struct xfs_buf			**leaf_bp)
 {
@@ -367,7 +367,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac, leaf_bp);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -840,7 +840,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
 			return retval;
-		retval = xfs_attr_shortform_remove(args);
+		retval = xfs_attr_sf_removename(args);
 		if (retval)
 			return retval;
 		/*
@@ -1223,7 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	error = xfs_attr_node_remove_name(args, state);
+	error = xfs_attr_node_removename(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
@@ -1339,7 +1339,7 @@ int xfs_attr_node_removename_setup(
 }
 
 STATIC int
-xfs_attr_node_remove_name(
+xfs_attr_node_removename(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
@@ -1390,7 +1390,7 @@ xfs_attr_remove_iter(
 		 * thus state transitions. Call the right helper and return.
 		 */
 		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-			return xfs_attr_shortform_remove(args);
+			return xfs_attr_sf_removename(args);
 
 		if (xfs_attr_is_leaf(dp))
 			return xfs_attr_leaf_removename(args);
@@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
 				goto out;
 		}
 
-		retval = xfs_attr_node_remove_name(args, state);
+		retval = xfs_attr_node_removename(args, state);
 
 		/*
 		 * Check to see if the tree needs to be collapsed. If so, roll
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1df9d63f..cfb6bf17 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -771,7 +771,7 @@ xfs_attr_fork_remove(
  * Remove an attribute from the shortform attribute list structure.
  */
 int
-xfs_attr_shortform_remove(
+xfs_attr_sf_removename(
 	struct xfs_da_args		*args)
 {
 	struct xfs_attr_shortform	*sf;
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 9b1c59f4..efa757f1 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -51,7 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
-int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_attr_sf_removename(struct xfs_da_args *args);
 int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     struct xfs_attr_sf_entry **sfep,
 			     unsigned int *basep);

