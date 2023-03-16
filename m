Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7647FC76195
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCPTZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCPTZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC43BCFE4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6916E620F5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C086CC433EF;
        Thu, 16 Mar 2023 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994723;
        bh=slOeWOAzxpY9UpJUVikq81tGA9CNoOoyGHH3Q/4ACEE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AecnA2ZmWT6NBFNrDT4+wQiVG0GeWLY7Iio/35Q9yy/m8/atfvHtDTCrID1xozhGR
         Iy3/nLhP15o7MJA6UTJXM5TJLz6PrHjWLAKdKpPfdXT4qvhKDLegXSJjzI+UcTc5DW
         MSM5EJ12+dzxBThwx1CuMFScy6CiqIkGqjgcgwIA0ltOEs3i6pU/h+S9XcjknQqf7e
         f5OgMmO+M2jx3FLer5/i6FGTq3/6GuJ/QTF7ATdCe9w7/XwZ+41zvfEN2mNPYecP9t
         HEfXvMWvz90h2A/HcTDAT2Ri+hjtGQTz0wrwB28RH1ovxPRwltGSFd8yNZPOivlg3U
         uW2XRhRH8hngA==
Date:   Thu, 16 Mar 2023 12:25:23 -0700
Subject: [PATCH 15/17] xfs: log VLOOKUP xattr nvreplace operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414566.15363.10668981176184534459.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If high level code wants to do a deferred xattr nvreplace operation with
the VLOOKUP flag set, we need to push this through the log.  To avoid
breaking bisection in parent pointer code, we'll temporarily create a
new NVREPLACEXXX flag that connects to the VLOOKUP flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |   11 +++++++----
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |   23 +++++++++++++++++++++--
 3 files changed, 29 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 313593b36e65..35d94608c621 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -426,7 +426,8 @@ xfs_attr_complete_op(
 		return XFS_DAS_DONE;
 
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-	if (xfs_attr_intent_op(attr) != XFS_ATTRI_OP_FLAGS_NVREPLACE)
+	if (xfs_attr_intent_op(attr) != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    xfs_attr_intent_op(attr) != XFS_ATTRI_OP_FLAGS_NVREPLACEXXX)
 		return replace_state;
 
 	/*
@@ -939,11 +940,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
-	int			op_flag;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_REPLACE;
 	int			error = 0;
 
-	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
-		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+	if (args->op_flags & XFS_DA_OP_VLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREPLACEXXX;
+	else if (args->new_namelen > 0)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREPLACE;
 
 	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8b16ae27c2fd..a1581dc6f131 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -961,6 +961,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	5	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_NVSET	6	/* Set attr with w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACEXXX	7	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index b730f8e7a785..9eebc9db2280 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -403,7 +403,10 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 
-	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
+		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
+		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
+	} else if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
 		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
 	} else {
@@ -564,6 +567,7 @@ xfs_attri_validate(
 		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
 			return false;
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		if (attrp->alfi_oldname_len == 0 ||
 		    attrp->alfi_oldname_len > XATTR_NAME_MAX)
@@ -650,6 +654,7 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVSET:
 		args->op_flags |= XFS_DA_OP_VLOOKUP;
 		fallthrough;
@@ -745,7 +750,10 @@ xfs_attri_item_relog(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
+		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
+		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
+	} else if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
 		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
 	} else {
@@ -825,6 +833,16 @@ xlog_recover_attri_commit_pass2(
 		}
 		name_len = attri_formatp->alfi_name_len;
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
+		/* Log item, attr name, new attr name, optional attr value */
+		if (item->ri_total < 3 || item->ri_total > 4) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_oldname_len;
+		newname_len = attri_formatp->alfi_newname_len;
+		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		/* Log item, attr name, new attr name, attr value */
 		if (item->ri_total != 4) {
@@ -929,6 +947,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 		/*
 		 * Name-value replace operations require the caller to specify
 		 * the old and new name explicitly.  Values are optional.

