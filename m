Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEA8C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239695AbjDFTTZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240211AbjDFTTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:19:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9F159EA
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98FB160FA1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21B6C433D2;
        Thu,  6 Apr 2023 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808763;
        bh=Z+fdO/DqehWQoPg1FAtCSiAKfM20q4a4xrpb2mNoS8Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d3VBZSPsQ7KPy5QO7GfBxvbFgZVe2DyjLRwtWU5A/+ItiUVdLTCtxoBBBXrkRLuxY
         KtGWOb0VUaA3vJN2AkcRf1MV+eYQq0vP+v8jTRC/wmMAZehlSDDiPjDkAlfe1DERpa
         KrLml4V44qBnF1pOp4N/D/4RctVhTNNak17dwZ2YQKsb7CQDYwtif3+hNqVdP73ELE
         oAQqACKh9jHcec4FVVTcWi6VwcHCkaJjtvt+bCCXbuqNeKwjC02nyvw58Us0wUZojD
         kAGU5HL9Hmi44yYwFsIKN58yETR+fz//2mOdubLqH289oqF22Rz8YKLQOS934FQHQt
         ibe7qBX2G/GOg==
Date:   Thu, 06 Apr 2023 12:19:22 -0700
Subject: [PATCH 11/12] xfs: log NVLOOKUP xattr setting operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823960.613065.1632972654900176629.stgit@frogsfrogsfrogs>
In-Reply-To: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
References: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
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
index 1f4dc6e01e68..287990a9b29d 100644
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
index ecf0ac32d752..7a4226e20dae 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -958,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index dd73d30f9e8d..f8def28090f8 100644
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
@@ -604,6 +605,9 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
+		args->op_flags |= XFS_DA_OP_NVLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->total = xfs_attr_calc_size(args, &local);
@@ -740,6 +744,7 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		/* Log item, attr name, optional attr value */
 		if (item->ri_total != 3 && item->ri_total != 2) {
@@ -824,6 +829,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -832,7 +838,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 *
-		 * Name-value remove operations must have a name, do not
+		 * Name-value set/remove operations must have a name, do not
 		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || name_len == 0) {

