Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD13CC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZCJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D067CE7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AC661834
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5106C433D2;
        Fri, 26 May 2023 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066978;
        bh=iS7yXAh2Z4nTPS/DTLAuFLF7LWFA6RCn1ILamdX8sIY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ryuHC9y2frdg9rfkICgDSs+gXdBZzsUkGwHZ6na5ZgoeFyAaq5CBkwdnWfdkNXKdH
         RvFbBBe5VnVNt7XUGqYMxSXKTQn1Ai60uuhJbFQ/A9iOS4EfDEb6L6G0ki6tL1oLlR
         QaoeS81QsygixDOm0H/ICrAAICxzx0HHftRKpJhT/1tRIHzb4a5t1jh9fKov9jEDYp
         H3SCyz11TEaaBSt0xCE0OoiXo3YGMnojR9WfiNZL6LQzQABSifcDzYxLK7KTuEMOyR
         qyMtSJU0H2c9aCUzbDBEb4Nf4oDXYpGGUoYp8pOEH7slszm5N4YNcxYaXXQ5PWXDax
         ZrMroCwNXkjMQ==
Date:   Thu, 25 May 2023 19:09:38 -0700
Subject: [PATCH 11/12] xfs: log NVLOOKUP xattr setting operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072339.3743652.500465903079237674.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
References: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If high level code wants to do a deferred xattr set operation with the
NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |    8 +++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0f74d9397a6f..497fb4aa5a5e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -903,9 +903,13 @@ xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_SET;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVSET;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0eb8362e91d8..7b848b1d8aa4 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1037,6 +1037,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 1934adb0e2ab..a0ef1ed14652 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -523,6 +523,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 		break;
 	default:
 		return false;
@@ -605,6 +606,9 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
+		args->op_flags |= XFS_DA_OP_NVLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->total = xfs_attr_calc_size(args, &local);
@@ -741,6 +745,7 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		/* Log item, attr name, optional attr value */
 		if (item->ri_total != 3 && item->ri_total != 2) {
@@ -825,6 +830,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -833,7 +839,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 *
-		 * Name-value remove operations must have a name, do not
+		 * Name-value set/remove operations must have a name, do not
 		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || name_len == 0) {

