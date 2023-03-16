Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744D5C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCPTYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCPTYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:24:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A180B2121
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E8CB82290
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA9EC433D2;
        Thu, 16 Mar 2023 19:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994677;
        bh=7fwfqIT5nAuSkhsEPshgb7zgKA2/tEdHQFxBsrfYQ7Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=o1YIjJ3mD2Vo1ZpxDiTV5hq+90qkfcMPGGvC0Jl3oLlQHMV/OPHZIbtg3NBCTvY9b
         1NtxkZIW6Cl8RMZDiG03KpyF+2Oww8PQkFigfX5yKAQWGP5ycP54R42En3hFTMD3Rt
         /79buWM9wq0FAcByKndfrJYYpWitm5XTALbnnTZsMEBHLOVnLhwxv/88/hhDWAJbIU
         HtXnRhyfdJt5KYFjkJgXGhkrXx4g0PVmZxsi6UYKG97tDL6JBMoB9TFS7YGyZ4PflX
         YfZpEms2c+5FgfYLZbweOu3HRyUENJ/tpluQO7dI6FIT7Rv5EFo93wSpWlEHY1+MJu
         UAov5SsuSVP6g==
Date:   Thu, 16 Mar 2023 12:24:36 -0700
Subject: [PATCH 12/17] xfs: overlay alfi_nname_len atop alfi_name_len for
 NVREPLACE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414525.15363.10856383808135579343.stgit@frogsfrogsfrogs>
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

In preparation for being able to log the old attr value in a NVREPLACE
operation, encode the old and new name lengths in the alfi_name_len
field.  We haven't shipped a kernel with XFS_ATTRI_OP_FLAGS_NVREPLACE,
so we can still tweak the ondisk log item format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |   14 +++++-
 fs/xfs/xfs_attr_item.c         |   99 ++++++++++++++++++++++------------------
 2 files changed, 67 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 1fe9f7394812..32035786135b 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -979,11 +979,21 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	alfi_nname_len;	/* attr new name length */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
-	uint32_t	alfi_name_len;	/* attr name length */
+	union {
+		uint32_t	alfi_name_len;	/* attr name length */
+		struct {
+			/*
+			 * For NVREPLACE, these are the lengths of the old and
+			 * new attr name.
+			 */
+			uint16_t	alfi_oldname_len;
+			uint16_t	alfi_newname_len;
+		};
+	};
 	uint32_t	alfi_value_len;	/* attr value length */
 	uint32_t	alfi_attr_filter;/* attr filter flags */
 };
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4472250f461c..bb21d4e6dcf2 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -402,8 +402,14 @@ xfs_attr_log_item(
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
-	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
-	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
+
+	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
+		attrp->alfi_newname_len = attr->xattri_nameval->nname.i_len;
+	} else {
+		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	}
+
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -533,10 +539,6 @@ xfs_attri_validate(
 {
 	unsigned int			op = xfs_attr_log_item_op(attrp);
 
-	if (op != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
-	    attrp->alfi_nname_len != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -545,29 +547,37 @@ xfs_attri_validate(
 
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (attrp->alfi_value_len != 0)
+			return false;
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-	case XFS_ATTRI_OP_FLAGS_REMOVE:
-	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVSET:
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (attrp->alfi_oldname_len == 0 ||
+		    attrp->alfi_oldname_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_newname_len == 0 ||
+		    attrp->alfi_newname_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
 		break;
 	default:
 		return false;
 	}
 
-	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
-		return false;
-
-	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
-	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
-	    (attrp->alfi_name_len == 0))
-		return false;
-
-	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
-	    attrp->alfi_value_len != 0)
-		return false;
-
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -735,8 +745,12 @@ xfs_attri_item_relog(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
-	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
+	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
+		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
+	} else {
+		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	}
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -759,7 +773,8 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	const void			*attr_nname = NULL;
+	const void			*attr_newname = NULL;
+	unsigned int			name_len = 0, newname_len = 0;
 	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -787,6 +802,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -796,6 +812,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
@@ -804,6 +821,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		/* Log item, attr name, new attr name, attr value */
@@ -812,6 +830,8 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_oldname_len;
+		newname_len = attri_formatp->alfi_newname_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -821,15 +841,14 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[i].i_len !=
-			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
+	if (item->ri_buf[i].i_len != xlog_calc_iovec_len(name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+	if (!xfs_attr_namecheck(mp, attr_name, name_len,
 				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
@@ -837,19 +856,17 @@ xlog_recover_attri_commit_pass2(
 	}
 	i++;
 
-	/* Validate the attr name. */
-	if (attri_formatp->alfi_nname_len) {
-		if (item->ri_buf[i].i_len !=
-		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+	/* Validate the attr nname */
+	if (newname_len > 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(newname_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(mp, attr_nname,
-				attri_formatp->alfi_nname_len,
+		attr_newname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(mp, attr_newname, newname_len,
 				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
@@ -903,12 +920,7 @@ xlog_recover_attri_commit_pass2(
 		 * Name-value set/remove operations must have a name, do not
 		 * take a newname, and can take a value.
 		 */
-		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
-		if (attr_nname != NULL || attri_formatp->alfi_nname_len != 0) {
+		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -919,12 +931,12 @@ xlog_recover_attri_commit_pass2(
 		 * Name-value replace operations require the caller to specify
 		 * the old and new name explicitly.  Values are optional.
 		 */
-		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
-		if (attr_nname == NULL || attri_formatp->alfi_nname_len == 0) {
+		if (attr_newname == NULL || newname_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -937,9 +949,8 @@ xlog_recover_attri_commit_pass2(
 	 * name/value buffer to the recovered incore log item and drop our
 	 * reference.
 	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_nname,
-			attri_formatp->alfi_nname_len, attr_value,
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_newname,
+			newname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);

