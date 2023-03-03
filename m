Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA944C7EE2D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCCRMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjCCRMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9153130EB9
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0764DB8191E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3158C433D2;
        Fri,  3 Mar 2023 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863529;
        bh=hdXbtNyhTki/Q/3JZtvqohwmVFXl8UFL0szbD+fA0WQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rri0zgtwXsUldC6gK8eH2daPJWc8swvoykUdGRCVZvAhGVCxTKKnikKzZWgjW2aR0
         4GRZhsWWfghsAQGGN3lUcMm5z12KFMWKXvKBJmdmyZRErd4ymUxVIAJeymnus2EsRV
         7MbVrNrfupbRtPxP5TKKNwPFqxKKmSjDIax/InBIVBoACv5w+5okro8RvduLkwichh
         S9ZWMfdXt+dhblzzsFG2pmGf4XWlC5yuO/tIbuWUHZPCred373K2qnaC2+oo4QgnvM
         E7S4pcRgrkcgy3OWs+LXEuzbKo3a8PKFaBNaZ5WyfVhQHwZ+HquQjgrppO/dmb2t+Z
         R4GFFWe8WCYYA==
Subject: [PATCH 09/13] xfs: log VLOOKUP xattr nvreplace operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:12:09 -0800
Message-ID: <167786352923.1543331.16240053109176341528.stgit@magnolia>
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

If high level code wants to do a deferred xattr nvreplace operation with
the VLOOKUP flag set, we need to push this through the log.  To avoid
breaking the parent pointer code, we'll temporarily create a new
NVREPLACEXXX flag that connects to the VLOOKUP flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |   15 +++++++++++----
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |   13 +++++++++++--
 3 files changed, 23 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ba8ad232b306..b9178c4efdeb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -424,7 +424,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-		if (args->new_namelen > 0) {
+		if (args->op_flags & XFS_DA_OP_VLOOKUP) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		} else if (args->new_namelen > 0) {
 			args->name = args->new_name;
 			args->namelen = args->new_namelen;
 			args->hashval = xfs_da_hashname(args->name,
@@ -933,11 +938,13 @@ xfs_attr_defer_replace(
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
index 83e83aa05f94..0dd49c5f235a 100644
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
@@ -649,6 +653,7 @@ xfs_attri_item_recover(
 
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_NVSET:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 		args->op_flags |= XFS_DA_OP_VLOOKUP;
 		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
@@ -747,7 +752,10 @@ xfs_attri_item_relog(
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
@@ -815,6 +823,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		name_len = attri_formatp->alfi_name_len;
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		if (item->ri_total != 3 && item->ri_total != 4) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,

