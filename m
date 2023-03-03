Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801BAC64EC4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCCRLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCCRLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:11:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5181E5F7
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B73B8191F
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EC5C433EF;
        Fri,  3 Mar 2023 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863501;
        bh=n0+2D2TJFJm5z0gr0gdoJVNRMdiZoXMhillFRrYe4cY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tEcCI+kyBXu6y/j+NJJ8ZDEGlWFaGLf17YGXolm1Q0XgGc5329J7KJo17y8TAxjwj
         4hmHk+m/lr3ORsOgSxPhAHNVp6TnQs/K5/dokwgDQSqcb0TEDfrQN0wx0BU8KIwrZb
         Gk0MZr08KkyIui1+SPHwh9GL2/9WQx9X448lqn7ICG5T6WUkrfv0bKUyI+LvskHrir
         qJMtBUiat0G+S0CxvLYlYYfxFKkVVF7ndO4TcTl51lSik/JBUBZqqGcBSdU+9cT7tX
         rF+RN0f+VNuhJsC3g2HaFbE2dvzdeSPDpjLbMk2s8t6dBz/oeaBJWLU7aWWGAA/tcQ
         Zc6QDkKND8JDQ==
Subject: [PATCH 04/13] xfs: log VLOOKUP xattr removal operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:11:40 -0800
Message-ID: <167786350094.1543331.12664403111045148085.stgit@magnolia>
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

If high level code wants to do a deferred xattr remove operation with
the VLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |    7 +++++++
 3 files changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 86672061c99e..6468286d2d71 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -953,9 +953,13 @@ xfs_attr_defer_remove(
 {
 
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_REMOVE;
 	int			error;
 
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
+	if (args->op_flags & XFS_DA_OP_VLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREMOVE;
+
+	error  = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 727b5a858028..a3d95a3d8476 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -959,6 +959,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	5	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 792c01a49749..08cb26d6b37b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -544,6 +544,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		break;
 	default:
 		return false;
@@ -643,6 +644,11 @@ xfs_attri_item_recover(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		args->op_flags |= XFS_DA_OP_VLOOKUP;
+		args->value = nv->value.i_addr;
+		args->valuelen = nv->value.i_len;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
 			goto out;
@@ -769,6 +775,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		if (item->ri_total != 3 && item->ri_total != 2) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);

