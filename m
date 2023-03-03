Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849B1C64EC4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCCRLu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCCRLs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:11:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED41E5F7
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF053618A2
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188C5C433D2;
        Fri,  3 Mar 2023 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863507;
        bh=YEDcSc1cJfiDX6zloYDQzLyEcNJ9ichsgku5ugFJXr4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Org0wuEo6nwqx9M6Qq2x/LooLQRISyinVHUNf8PG4JGbtiz92PLn0Zuivc5bQEsMo
         TfJX89MctBldUBoMeIU2NWwwyMc4C7aNFduv9oeX/uzGGvmKnjPpBMJyfa5/4wtrke
         JYMe9ZwzH2Obyz6KixSNmeCrNbs/LJZZoUWcozXn4Ju3qPF3hLDX8FrUDJkBZoTqf3
         h+RY4UMtpPqrYLISibGO9gCELQCYWJmDKuDvTA3FR08u2wAkxpH4abhuA5uq5DBgJc
         z/CxNMO8gAufExNzmskXaML1mbhOhEw+B4pbwuq/xtVqvEkkONyWynsz6jokocheyo
         1Qo8ArpYGvtIg==
Subject: [PATCH 05/13] xfs: log VLOOKUP xattr setting operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:11:46 -0800
Message-ID: <167786350657.1543331.8819703939606652496.stgit@magnolia>
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

If high level code wants to do a deferred xattr set operation with the
VLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |    5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6468286d2d71..ba8ad232b306 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -910,9 +910,13 @@ xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_SET;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
+	if (args->op_flags & XFS_DA_OP_VLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVSET;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a3d95a3d8476..1fe9f7394812 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -960,6 +960,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	5	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	6	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 08cb26d6b37b..79a459e8d51a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -545,6 +545,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 		break;
 	default:
 		return false;
@@ -633,6 +634,9 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (attr->xattri_op_flags) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
+		args->op_flags |= XFS_DA_OP_VLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
@@ -773,6 +777,7 @@ xlog_recover_attri_commit_pass2(
 
 	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:

