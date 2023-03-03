Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DA8C7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjCCRMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjCCRMd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B168236693
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B6D6618A0
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5452C433EF;
        Fri,  3 Mar 2023 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863546;
        bh=UvB1l4931GZoRTy8aEBLiQN7zI1tDvQwcDUphBYu9Bg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DgKAud5oGUnsJ/k1x1+JOv9vwiEO1pG6xi0wPhTr0O65a6aGlKiaPQNophCafflFW
         ieRMNKTLQTdai0d63UbXGkgG19vQqA7Eb92RQpXWqgixf4meM9pRNGSlfu9jxtWjOV
         cbXi7YpXtz9HoM4jwxbJd+xziZzKn6EbWwJp7gRVNauAJIGOBziCw1PWXqNnv9O++a
         bSdNQ5d4VX47Wm7tE7RF7jNmb/7dvyuxTDrIQQRN8OuvV9ROC4Rpq7Bc4G792yMBSC
         R23xQ/QlipP+LwA9snjUW5siNJls0qgYFlR8tlfgwl6mJDsjOYqd5LrqpllhdPhPSS
         0UNvJ0fzblx5A==
Subject: [PATCH 12/13] xfs: turn NVREPLACEXXX into NVREPLACE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:12:26 -0800
Message-ID: <167786354618.1543331.1557214035782220495.stgit@magnolia>
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

NVREPLACEXXX is NVREPLACE with VLOOKUP enabled.  Nobody uses NVREPLACE
now, so get rid of NVREPLACE and make NVREPLACEXXX take its place.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    7 -------
 fs/xfs/libxfs/xfs_log_format.h |    1 -
 fs/xfs/xfs_attr_item.c         |   15 +++------------
 3 files changed, 3 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d807692b259c..c6621aba161d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -431,11 +431,6 @@ xfs_attr_complete_op(
 							args->namelen);
 			args->value = args->new_value;
 			args->valuelen = args->new_valuelen;
-		} else if (args->new_namelen > 0) {
-			args->name = args->new_name;
-			args->namelen = args->new_namelen;
-			args->hashval = xfs_da_hashname(args->name,
-							args->namelen);
 		}
 		return replace_state;
 	}
@@ -944,8 +939,6 @@ xfs_attr_defer_replace(
 	int			error = 0;
 
 	if (args->op_flags & XFS_DA_OP_VLOOKUP)
-		op_flag = XFS_ATTRI_OP_FLAGS_NVREPLACEXXX;
-	else if (args->new_namelen > 0)
 		op_flag = XFS_ATTRI_OP_FLAGS_NVREPLACE;
 
 	error = xfs_attr_intent_init(args, op_flag, &new);
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ed406738847d..ec85af39ed91 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -961,7 +961,6 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	5	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_NVSET	6	/* Set attr with w/ vlookup */
-#define XFS_ATTRI_OP_FLAGS_NVREPLACEXXX	7	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 57cc426b1e22..70d56bab4e21 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -428,13 +428,10 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 
-	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
+	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
 		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
 		attrp->alfi_newvalue_len = attr->xattri_nameval->newvalue.i_len;
-	} else if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
-		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
-		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
 	} else {
 		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
 	}
@@ -598,7 +595,6 @@ xfs_attri_validate(
 		if (attrp->alfi_newvalue_len != 0)
 			return false;
 		break;
-	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		if (attrp->alfi_oldname_len == 0 ||
 		    attrp->alfi_oldname_len > XATTR_NAME_MAX)
@@ -685,7 +681,7 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (attr->xattri_op_flags) {
-	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->new_value = nv->newvalue.i_addr;
 		args->new_valuelen = nv->newvalue.i_len;
 		fallthrough;
@@ -694,7 +690,6 @@ xfs_attri_item_recover(
 		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -788,13 +783,10 @@ xfs_attri_item_relog(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
+	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
 		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
 		new_attrp->alfi_newvalue_len = old_attrp->alfi_newvalue_len;
-	} else if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
-		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
-		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
 	} else {
 		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
 	}
@@ -864,7 +856,6 @@ xlog_recover_attri_commit_pass2(
 		name_len = attri_formatp->alfi_name_len;
 		value_len = attri_formatp->alfi_value_len;
 		break;
-	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		if (item->ri_total < 3 || item->ri_total > 5) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,

