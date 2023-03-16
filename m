Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D29C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjCPTZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCPTZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:25:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DB7DFB5B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9494B82290
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE1C4339B;
        Thu, 16 Mar 2023 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994739;
        bh=DPenfYGpwwlHERZfhMh0NcoPu2UIOS/krzc1tb/YiHY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lxbB4+U6BztcH6aFSsbQXy77iWoJRpWl47Krf5GPPAELiHPI1TaDZtuaRV/26xlSv
         BACRNhR8HGRQYQDf8opWDaKc8v5WYVK9iqVETW0P4C8FI6ve4Vum1yrYl4oQZGPFiO
         QZ3iiCn8rApHpKns/BvIC1JZzUnxWSRuLqjfnyFXdVE2eOLyeH1FBHHJK3GyvcouDs
         X1gRjp8brywLje9mQ6RQ/DCUiA0JknFEISnpmHQS6WmEd9ayCFeEJ78KGo7yDpHcjc
         5AZiOrUUN/cXGMdIuQm6Sz9E5sATdz2GD+3RpX3rwrwzd+056T4xMK4T0veVNzlj9s
         V6NYH/Ut5OsdQ==
Date:   Thu, 16 Mar 2023 12:25:38 -0700
Subject: [PATCH 16/17] xfs: log new xattr values for NVREPLACEXXX operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414580.15363.12225322547350421185.stgit@frogsfrogsfrogs>
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

For NVREPLACEXXX operations, make it possible to log the old and new
attr values, since this variant does VLOOKUP operations and we actually
need both old and new values to be represented.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |    2 +
 fs/xfs/libxfs/xfs_log_format.h |   14 +++++-
 fs/xfs/xfs_attr_item.c         |   88 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_item.h         |    3 +
 5 files changed, 93 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 35d94608c621..8022e1e1887f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -432,13 +432,15 @@ xfs_attr_complete_op(
 
 	/*
 	 * NVREPLACE operations require the caller to set the old and new names
-	 * explicitly.
+	 * and values explicitly.
 	 */
 	ASSERT(args->new_namelen > 0);
 
 	args->name = args->new_name;
 	args->namelen = args->new_namelen;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = args->new_value;
+	args->valuelen = args->new_valuelen;
 	return replace_state;
 }
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 6132787ad1f4..3f3313ace903 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -60,7 +60,9 @@ typedef struct xfs_da_args {
 	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*new_value;	/* new xattr value (may contain NULLs) */
 	int		valuelen;	/* length of value */
+	int		new_valuelen;	/* length of new value */
 	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a1581dc6f131..711654fca49a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -115,11 +115,11 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_BUD_FORMAT	26
 #define XLOG_REG_TYPE_ATTRI_FORMAT	27
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_NAME		29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
 #define XLOG_REG_TYPE_ATTR_NEWNAME	31
-#define XLOG_REG_TYPE_MAX		31
-
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	32
+#define XLOG_REG_TYPE_MAX		32
 
 /*
  * Flags to log operation header
@@ -980,7 +980,13 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+
+	/*
+	 * For NVREPLACEXXX, this is the length of the new xattr value.
+	 * alfi_value_len contains the length of the old xattr value.
+	 */
+	uint32_t	alfi_newvalue_len;
+
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9eebc9db2280..5497862e4072 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -78,7 +78,9 @@ xfs_attri_log_nameval_alloc(
 	const void			*newname,
 	unsigned int			newname_len,
 	const void			*value,
-	unsigned int			value_len)
+	unsigned int			value_len,
+	const void			*newvalue,
+	unsigned int			newvalue_len)
 {
 	struct xfs_attri_log_nameval	*nv;
 
@@ -87,7 +89,8 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + newname_len + value_len);
+					name_len + newname_len + value_len +
+					newvalue_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
@@ -114,6 +117,17 @@ xfs_attri_log_nameval_alloc(
 	}
 	nv->value.i_type = XLOG_REG_TYPE_ATTR_VALUE;
 
+	if (newvalue_len) {
+		nv->newvalue.i_addr = nv->name.i_addr + newname_len +
+							name_len + value_len;
+		nv->newvalue.i_len = newvalue_len;
+		memcpy(nv->newvalue.i_addr, newvalue, newvalue_len);
+	} else {
+		nv->newvalue.i_addr = NULL;
+		nv->newvalue.i_len = 0;
+	}
+	nv->newvalue.i_type = XLOG_REG_TYPE_ATTR_NEWVALUE;
+
 	refcount_set(&nv->refcount, 1);
 	return nv;
 }
@@ -168,6 +182,11 @@ xfs_attri_item_size(
 		*nvecs += 1;
 		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
 	}
+
+	if (nv->newvalue.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->newvalue.i_len);
+	}
 }
 
 /*
@@ -203,6 +222,9 @@ xfs_attri_item_format(
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
+	if (nv->newvalue.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
@@ -213,6 +235,9 @@ xfs_attri_item_format(
 
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
+
+	if (nv->newvalue.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->newvalue);
 }
 
 /*
@@ -406,6 +431,7 @@ xfs_attr_log_item(
 	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
 		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
 		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
+		attrp->alfi_newvalue_len = attr->xattri_nameval->newvalue.i_len;
 	} else if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
 		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
@@ -455,7 +481,8 @@ xfs_attr_create_intent(
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
 				args->namelen, args->new_name,
-				args->new_namelen, args->value, args->valuelen);
+				args->new_namelen, args->value, args->valuelen,
+				args->new_value, args->new_valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -556,6 +583,8 @@ xfs_attri_validate(
 		if (attrp->alfi_name_len == 0 ||
 		    attrp->alfi_name_len > XATTR_NAME_MAX)
 			return false;
+		if (attrp->alfi_newvalue_len != 0)
+			return false;
 		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -566,6 +595,8 @@ xfs_attri_validate(
 			return false;
 		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
 			return false;
+		if (attrp->alfi_newvalue_len != 0)
+			return false;
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
@@ -577,6 +608,8 @@ xfs_attri_validate(
 			return false;
 		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
 			return false;
+		if (attrp->alfi_newvalue_len > XATTR_SIZE_MAX)
+			return false;
 		break;
 	default:
 		return false;
@@ -647,6 +680,8 @@ xfs_attri_item_recover(
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->value = nv->value.i_addr;
 	args->valuelen = nv->value.i_len;
+	args->new_value = nv->newvalue.i_addr;
+	args->new_valuelen = nv->newvalue.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -753,6 +788,7 @@ xfs_attri_item_relog(
 	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
 		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
 		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
+		new_attrp->alfi_newvalue_len = old_attrp->alfi_newvalue_len;
 	} else if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
 		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
@@ -779,11 +815,12 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_format     *attri_formatp;
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
+	const void			*attr_newvalue = NULL;
 	const void			*attr_name;
 	size_t				len;
 	const void			*attr_newname = NULL;
 	unsigned int			name_len = 0, newname_len = 0;
-	unsigned int			value_len;
+	unsigned int			value_len = 0, newvalue_len = 0;
 	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -801,7 +838,6 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	value_len = attri_formatp->alfi_value_len;
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_NVSET:
@@ -813,6 +849,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -823,6 +860,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
@@ -834,14 +872,19 @@ xlog_recover_attri_commit_pass2(
 		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
-		/* Log item, attr name, new attr name, optional attr value */
-		if (item->ri_total < 3 || item->ri_total > 4) {
+		/*
+		 * Log item, attr name, new attr name, optional attr value,
+		 * optional new attr value
+		 */
+		if (item->ri_total < 3 || item->ri_total > 5) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 		name_len = attri_formatp->alfi_oldname_len;
 		newname_len = attri_formatp->alfi_newname_len;
+		value_len = attri_formatp->alfi_value_len;
+		newvalue_len = attri_formatp->alfi_newvalue_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		/* Log item, attr name, new attr name, attr value */
@@ -852,6 +895,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		name_len = attri_formatp->alfi_oldname_len;
 		newname_len = attri_formatp->alfi_newname_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -896,9 +940,8 @@ xlog_recover_attri_commit_pass2(
 		i++;
 	}
 
-
 	/* Validate the attr value, if present */
-	if (value_len != 0) {
+	if (value_len > 0) {
 		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					attri_formatp, len);
@@ -909,6 +952,18 @@ xlog_recover_attri_commit_pass2(
 		i++;
 	}
 
+	/* Validate the new attr value, if present */
+	if (newvalue_len > 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(newvalue_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_newvalue = item->ri_buf[i].i_addr;
+		i++;
+	}
+
 	/*
 	 * Make sure we got the correct number of buffers for the operation
 	 * that we just loaded.
@@ -947,10 +1002,18 @@ xlog_recover_attri_commit_pass2(
 		}
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		/* Old name-value replace operations do not have new values. */
+		if (attr_newvalue != NULL || newvalue_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 		/*
-		 * Name-value replace operations require the caller to specify
-		 * the old and new name explicitly.  Values are optional.
+		 * New name-value replace operations require the caller to
+		 * specify the old and new names and values explicitly.
+		 * Values are optional.
 		 */
 		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -971,7 +1034,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_newname,
-			newname_len, attr_value, value_len);
+			newname_len, attr_value, value_len, attr_newvalue,
+			newvalue_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index e374712ba06b..098f7f3aae78 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,8 +13,9 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
-	struct xfs_log_iovec	newname;
+	struct xfs_log_iovec	newname;	/* NVREPLACEXXX only */
 	struct xfs_log_iovec	value;
+	struct xfs_log_iovec	newvalue;	/* NVREPLACEXXX only */
 	refcount_t		refcount;
 
 	/* name and value follow the end of this struct */

