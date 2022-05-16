Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F80C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiEPDcl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbiEPDcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FCB1FCCE
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBCE660ECF
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AA2C385AA;
        Mon, 16 May 2022 03:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671950;
        bh=HaJwXRHMdiQqe5KOcX95YiAkhkURXP79cb3RfxQxG6w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uE7fZB2B7vJiFzqSA8omGPnOnvXUfNjgt9DhU0VWMWD1aCleIAMD2h4M/0vicAo/d
         TDZNmyv8Rgh1VzwvnHJHPee1VgWTNIa6Ucj7x/R6RDxLCT0iGYEbI+YNRgOLTqjJh8
         w+ACEqsL44wkkm9T9U9UuVusUWyAJ5m242886fuG9GRFWDBmth+p4xIvBpu/lkC1X5
         ba1+yhro3norKkxE2oXODdqRp+tZgv+mlY/wXZBmpfQUuxIKbaKrBeuGBtL/kupwe+
         WajqF2MM13atwG5p50J+98cR69CQTFF04THN9u+dHFpz0MmkHyJC0mlF2zXGr+v2ac
         a92hmDug8y3Ag==
Subject: [PATCH 2/6] xfs: put the xattr intent item op flags in their own
 namespace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:29 -0700
Message-ID: <165267194968.626272.5616764509389152783.stgit@magnolia>
In-Reply-To: <165267193834.626272.10112290406449975166.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The flags that are stored in the extended attr intent log item really
should have a separate namespace from the rest of the XFS_ATTR_* flags.
Give them one to make it a little more obvious that they're intent item
flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++---
 fs/xfs/libxfs/xfs_attr.h       |    2 +-
 fs/xfs/libxfs/xfs_log_format.h |    8 ++++----
 fs/xfs/xfs_attr_item.c         |   20 ++++++++++----------
 4 files changed, 18 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 381b8d46529a..0f88f6e17101 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -918,7 +918,7 @@ xfs_attr_defer_add(
 	struct xfs_attr_item	*new;
 	int			error = 0;
 
-	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
 	if (error)
 		return error;
 
@@ -937,7 +937,7 @@ xfs_attr_defer_replace(
 	struct xfs_attr_item	*new;
 	int			error = 0;
 
-	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE, &new);
+	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
 	if (error)
 		return error;
 
@@ -957,7 +957,7 @@ xfs_attr_defer_remove(
 	struct xfs_attr_item	*new;
 	int			error;
 
-	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	error  = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1af7abe29eef..c739caa11a4b 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -530,7 +530,7 @@ struct xfs_attr_item {
 	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
-	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
+	 * Attr operation being performed - XFS_ATTRI_OP_FLAGS_*
 	 */
 	unsigned int			xattri_op_flags;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 5017500bfd8b..377b230aecfd 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -906,10 +906,10 @@ struct xfs_icreate_log {
  * Flags for deferred attribute operations.
  * Upper bits are flags, lower byte is type code
  */
-#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
-#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
-#define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
-#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
+#define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 #define XFS_ATTRI_FILTER_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTRI_FILTER_SECURE		(1u << XFS_ATTR_SECURE_BIT)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 7cbb640d7856..930366055013 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -350,7 +350,7 @@ xfs_attr_log_item(
 	attrp = &attrip->attri_format;
 	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
 	attrp->alfi_op_flags = attr->xattri_op_flags &
-						XFS_ATTR_OP_FLAGS_TYPE_MASK;
+						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
 	attrp->alfi_name_len = attr->xattri_da_args->namelen;
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter &
@@ -493,12 +493,12 @@ xfs_attri_validate(
 	struct xfs_attri_log_format	*attrp)
 {
 	unsigned int			op = attrp->alfi_op_flags &
-					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
 	if (attrp->__pad != 0)
 		return false;
 
-	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
+	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
@@ -506,9 +506,9 @@ xfs_attri_validate(
 
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
-	case XFS_ATTR_OP_FLAGS_SET:
-	case XFS_ATTR_OP_FLAGS_REPLACE:
-	case XFS_ATTR_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		break;
 	default:
 		return false;
@@ -565,7 +565,7 @@ xfs_attri_item_recover(
 
 	attr->xattri_da_args = args;
 	attr->xattri_op_flags = attrp->alfi_op_flags &
-						XFS_ATTR_OP_FLAGS_TYPE_MASK;
+						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
 	args->dp = ip;
 	args->geo = mp->m_attr_geo;
@@ -577,8 +577,8 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
 
 	switch (attr->xattri_op_flags) {
-	case XFS_ATTR_OP_FLAGS_SET:
-	case XFS_ATTR_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->value = attrip->attri_value;
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -587,7 +587,7 @@ xfs_attri_item_recover(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
-	case XFS_ATTR_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
 			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);

