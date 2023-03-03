Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2419DC64EC4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjCCRL5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCCRL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:11:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5B02384A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:11:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15B82B8191F
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD9AC433EF;
        Fri,  3 Mar 2023 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863512;
        bh=YCcxwSsquDG9EOlPhKO4rGkl5BOg21++RqNBfLaRo7Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pJ92VwKVTfjNSpv6PQ0j7OTRLNRnQ29Y0D+WZN8d0bZ6wp+bmHnd+d/KfkJ15Xzgy
         t/+Xvn81dZ12I7OOnGvfIUSX0vGRrVOtrgpTjq/EwCr/rpavV1j4vaeDkHSHsnQ/zR
         E2lSDXD6r7g3CFTWH1rYkf//Jv8JfgPi9sYGZFKxg2QOUr3IXJ4daJSj76tynpYOIf
         6YADlB0qbRpBKKoNc9gdZinlAJOeIsCCPf4sZZpeHfvz5I/SDgPYJAo2Z6E6CQGwuZ
         qiLNmq8kc3dcu+draYH8IS+7Fqzyx7GQGpYPe/TxIZM+Q+Ve5qXrRFX0MGiRLBpWWH
         tV8gdBAAwkPww==
Subject: [PATCH 06/13] xfs: refactor extracting attri ops from alfi_op_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:11:52 -0800
Message-ID: <167786351226.1543331.5452828411615681184.stgit@magnolia>
In-Reply-To: <167786347827.1543331.2803518928321606576.stgit@magnolia>
References: <167786347827.1543331.2803518928321606576.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor this very long expression into a helper before we start adding
more of them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 79a459e8d51a..6dce2110a871 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -374,6 +374,12 @@ xfs_xattri_finish_update(
 	return error;
 }
 
+static inline unsigned int
+xfs_attr_log_item_op(const struct xfs_attri_log_format *attrp)
+{
+	return attrp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
+
 /* Log an attr to the intent item. */
 STATIC void
 xfs_attr_log_item(
@@ -525,8 +531,7 @@ xfs_attri_validate(
 	struct xfs_mount		*mp,
 	struct xfs_attri_log_format	*attrp)
 {
-	unsigned int			op = attrp->alfi_op_flags &
-					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	unsigned int			op = xfs_attr_log_item_op(attrp);
 
 	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
 	    attrp->alfi_nname_len != 0)
@@ -608,8 +613,7 @@ xfs_attri_item_recover(
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
-	attr->xattri_op_flags = attrp->alfi_op_flags &
-						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	attr->xattri_op_flags = xfs_attr_log_item_op(attrp);
 
 	/*
 	 * We're reconstructing the deferred work state structure from the
@@ -775,7 +779,7 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_SET:

