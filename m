Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C0CC7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjCCRM3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCCRM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF792DE55
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BAEDB8191F
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F9BC433D2;
        Fri,  3 Mar 2023 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863535;
        bh=lsNdcMBG80ShdVkJ+qHiu1JG8vhkxpYd5Ooadbw1mkc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pcNoZ9BDBlTTjIlNKRPgfGKrJIAjYKpZd7ivuhAJZI6L1iOTq9JNkq74ACYa7Mwy5
         NBIim9EH84eTnNIjgO3H/jAbknHxut++2pBNPftH1T/ABBmWcUG/U+Z1lqcYazdlxk
         nJE6n7yzfTJwWIT0YP1W8VSuVNNFMzrnkl180pQ/0s7cUP9+rfJ2qIy+rjLNK5jQFn
         gXJJOGBI9X1OSfkqBunBpBKTytQMU77xGDTKLo9k9Co0fQYhN8XIZ3Eqi5sfYUi7KU
         T5BuR8uWIOget3VzoHwQxkaQhmXAHu7PeC/2QZ/OAmjgg0opCpNWmN6G6rs+Z/OFbC
         1LewCFz7GAMqw==
Subject: [PATCH 10/13] xfs: log old xattr values for NVREPLACEXXX operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:12:14 -0800
Message-ID: <167786353490.1543331.6210511448533901672.stgit@magnolia>
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

For NVREPLACEXXX operations, make it possible to log the old and new
attr values, since this variant does VLOOKUP operations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    2 +
 fs/xfs/libxfs/xfs_da_btree.h   |    2 +
 fs/xfs/libxfs/xfs_log_format.h |   14 +++++---
 fs/xfs/xfs_attr_item.c         |   74 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_item.h         |    3 +-
 5 files changed, 80 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b9178c4efdeb..d807692b259c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -429,6 +429,8 @@ xfs_attr_complete_op(
 			args->namelen = args->new_namelen;
 			args->hashval = xfs_da_hashname(args->name,
 							args->namelen);
+			args->value = args->new_value;
+			args->valuelen = args->new_valuelen;
 		} else if (args->new_namelen > 0) {
 			args->name = args->new_name;
 			args->namelen = args->new_namelen;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0ef32f629e1b..cbea5233159c 100644
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
index a1581dc6f131..ed406738847d 100644
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
+	 * For NVREPLACE, this is the length of the new xattr value.
+	 * alfi_value_len contains the length of the old xattr value.
+	 */
+	uint32_t	alfi_newvalue_len;
+
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 0dd49c5f235a..57cc426b1e22 100644
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
@@ -652,8 +685,11 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (attr->xattri_op_flags) {
-	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
+		args->new_value = nv->newvalue.i_addr;
+		args->new_valuelen = nv->newvalue.i_len;
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 		args->op_flags |= XFS_DA_OP_VLOOKUP;
 		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
@@ -755,6 +791,7 @@ xfs_attri_item_relog(
 	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACEXXX) {
 		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
 		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
+		new_attrp->alfi_newvalue_len = old_attrp->alfi_newvalue_len;
 	} else if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
 		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
@@ -781,10 +818,12 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_format     *attri_formatp;
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
+	const void			*attr_newvalue = NULL;
 	const void			*attr_name;
 	size_t				len;
 	const void			*attr_newname = NULL;
 	unsigned int			name_len = 0, newname_len = 0;
+	unsigned int			value_len = 0, newvalue_len = 0;
 	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -814,6 +853,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (item->ri_total != 2) {
@@ -822,16 +862,19 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACEXXX:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
-		if (item->ri_total != 3 && item->ri_total != 4) {
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
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -876,16 +919,27 @@ xlog_recover_attri_commit_pass2(
 		i++;
 	}
 
-
 	/* Validate the attr value, if present */
-	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+	if (value_len > 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
 		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/* Validate the old attr value, if present */
+	if (newvalue_len > 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(newvalue_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_newvalue = item->ri_buf[i].i_addr;
 	}
 
 	/*
@@ -894,8 +948,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_newname,
-			newname_len, attr_value,
-			attri_formatp->alfi_value_len);
+			newname_len, attr_value, attri_formatp->alfi_value_len,
+			attr_newvalue, newvalue_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index e374712ba06b..d15fe4b1ce28 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,8 +13,9 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
-	struct xfs_log_iovec	newname;
+	struct xfs_log_iovec	newname;	/* NVREPLACE only */
 	struct xfs_log_iovec	value;
+	struct xfs_log_iovec	newvalue;	/* NVREPLACE only */
 	refcount_t		refcount;
 
 	/* name and value follow the end of this struct */

