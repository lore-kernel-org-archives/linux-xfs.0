Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9321C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241733AbiERS4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241738AbiERS4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BCE4BFE3
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 450B3B821AD
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018D9C385A5;
        Wed, 18 May 2022 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900156;
        bh=nTQ3DzcG6RhoI793DhGS11csieR+D588Lu5KyYB4ECA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KyoC0sSV/pXCBGJohtWkenlK3JZNbNhBJ9gVlZl3PlqsEiY9xeiUHPnYgXucTf72C
         Pc75NeHuiTFTIfeknbNXC3nbBNwePpG47SlOV7rQrHIY/gFisu1WtO3fJKhXLoQz5l
         adV3meABFtlZnba7ZsEoV0nRjJC+vVZikp6cBE+DxPm+uhdhN/+UlVjGyTA40tvYfe
         1Xv5prRCeTmzZE6BCL4qYEY64inwyjKT2VoIsvfHmboA6ocj8+slTn9pC7FGy5UQ9n
         i2dMV2j48uYlz3xaVDxKTRxQMt3bgDK0E9zNOcnfxABUYXFUAObaHhOcX4ilVRarcK
         vMENGxrQfgTDg==
Subject: [PATCH 2/7] xfs: put the xattr intent item op flags in their own
 namespace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:55 -0700
Message-ID: <165290015553.1647637.9536028316314201783.stgit@magnolia>
In-Reply-To: <165290014409.1647637.4876706578208264219.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
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
index 3838109ef288..56e56df9f9f0 100644
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
index 17746dcc2268..ccb4f45f474a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -538,7 +538,7 @@ struct xfs_attr_item {
 	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
-	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
+	 * Attr operation being performed - XFS_ATTRI_OP_FLAGS_*
 	 */
 	unsigned int			xattri_op_flags;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a9d08f3d4682..b351b9dc6561 100644
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
 
 /*
  * alfi_attr_filter captures the state of xfs_da_args.attr_filter, so it should
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9ef2c2455921..27b6bdc8a3aa 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -406,7 +406,7 @@ xfs_attr_log_item(
 	 */
 	attrp = &attrip->attri_format;
 	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
-	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK));
+	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->anvl_value_len;
 	attrp->alfi_name_len = attr->xattri_nameval->anvl_name_len;
@@ -539,12 +539,12 @@ xfs_attri_validate(
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
@@ -552,9 +552,9 @@ xfs_attri_validate(
 
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
@@ -613,7 +613,7 @@ xfs_attri_item_recover(
 
 	attr->xattri_da_args = args;
 	attr->xattri_op_flags = attrp->alfi_op_flags &
-						XFS_ATTR_OP_FLAGS_TYPE_MASK;
+						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
 	/*
 	 * We're reconstructing the deferred work state structure from the
@@ -632,8 +632,8 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
 
 	switch (attr->xattri_op_flags) {
-	case XFS_ATTR_OP_FLAGS_SET:
-	case XFS_ATTR_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->value = xfs_attri_log_valbuf(attrip);
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -642,7 +642,7 @@ xfs_attri_item_recover(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
-	case XFS_ATTR_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
 			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);

