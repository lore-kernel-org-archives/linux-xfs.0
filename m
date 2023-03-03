Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E7CC7EE2D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjCCRMH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjCCRMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF0323C71
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DEA615DA
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA4EC433D2;
        Fri,  3 Mar 2023 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863524;
        bh=VcHsW0sRAlywqvexAzokuDHAOHWQOHcj7RPWVMi+sD4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qSYtYzGbH8wy0ifKoWHmpmOeUmxfVqZ9y9qkZ7FZeFU6tqIFPQ7M02gWVloAfiDIu
         slcWjd0iTeU+7ewXlKZvCC/LYT+1h6111KnmC4OHmpFY6yu0hDNeWlTU5eiB4T+mcs
         qisbqXi0C+JvxtsTArSFAXqT9DretkvWTpWduApXIHyb6Dd+QKBYGU3OBaL3Lu2yQc
         BXb65kPNFNR9JmM9b7JsP4hf3iTEnT1pUFOnfhEkp69y1JQKO+XzC2Z0L7Wz0E5vCk
         stYnNOGNUZh1B2YqzoOXqrNeXJMeqnQkV4kUN7OLj7rNP6qX9qm+FcjZoJ9ZYiUe4t
         G2c0LzVgj5fuw==
Subject: [PATCH 08/13] xfs: rename nname to newname
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:12:03 -0800
Message-ID: <167786352351.1543331.16080812326506289061.stgit@magnolia>
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

Burn a couple of extra bytes to make it clear what this does.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    2 +-
 fs/xfs/xfs_attr_item.c         |   48 ++++++++++++++++++++--------------------
 fs/xfs/xfs_attr_item.h         |    2 +-
 3 files changed, 26 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 32035786135b..8b16ae27c2fd 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,7 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_ATTR_NEWNAME	31
 #define XLOG_REG_TYPE_MAX		31
 
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6042ba34f705..83e83aa05f94 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,8 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
-	const void			*nname,
-	unsigned int			nname_len,
+	const void			*newname,
+	unsigned int			newname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -87,25 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + nname_len + value_len);
+					name_len + newname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
-	if (nname_len) {
-		nv->nname.i_addr = nv->name.i_addr + name_len;
-		nv->nname.i_len = nname_len;
-		memcpy(nv->nname.i_addr, nname, nname_len);
+	if (newname_len) {
+		nv->newname.i_addr = nv->name.i_addr + name_len;
+		nv->newname.i_len = newname_len;
+		memcpy(nv->newname.i_addr, newname, newname_len);
 	} else {
-		nv->nname.i_addr = NULL;
-		nv->nname.i_len = 0;
+		nv->newname.i_addr = NULL;
+		nv->newname.i_len = 0;
 	}
-	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+	nv->newname.i_type = XLOG_REG_TYPE_ATTR_NEWNAME;
 
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
+		nv->value.i_addr = nv->name.i_addr + newname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -159,9 +159,9 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (nv->nname.i_len) {
+	if (nv->newname.i_len) {
 		*nvecs += 1;
-		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+		*nbytes += xlog_calc_iovec_len(nv->newname.i_len);
 	}
 
 	if (nv->value.i_len) {
@@ -197,7 +197,7 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
-	if (nv->nname.i_len > 0)
+	if (nv->newname.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
 	if (nv->value.i_len > 0)
@@ -208,8 +208,8 @@ xfs_attri_item_format(
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
 
-	if (nv->nname.i_len > 0)
-		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+	if (nv->newname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->newname);
 
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
@@ -405,7 +405,7 @@ xfs_attr_log_item(
 
 	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
 		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
-		attrp->alfi_newname_len = attr->xattri_nameval->nname.i_len;
+		attrp->alfi_newname_len = attr->xattri_nameval->newname.i_len;
 	} else {
 		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
 	}
@@ -638,8 +638,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
-	args->new_name = nv->nname.i_addr;
-	args->new_namelen = nv->nname.i_len;
+	args->new_name = nv->newname.i_addr;
+	args->new_namelen = nv->newname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -775,7 +775,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	const void			*attr_nname = NULL;
+	const void			*attr_newname = NULL;
 	unsigned int			name_len = 0, newname_len = 0;
 	int				op, i = 0;
 
@@ -848,7 +848,7 @@ xlog_recover_attri_commit_pass2(
 
 	i++;
 	if (newname_len > 0) {
-		/* Validate the attr nname */
+		/* Validate the attr newname */
 		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(newname_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
@@ -856,8 +856,8 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 
-		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(mp, attr_nname, newname_len,
+		attr_newname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(mp, attr_newname, newname_len,
 				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
@@ -884,7 +884,7 @@ xlog_recover_attri_commit_pass2(
 	 * name/value buffer to the recovered incore log item and drop our
 	 * reference.
 	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_nname,
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_newname,
 			newname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 24d4968dd6cc..e374712ba06b 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,7 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
-	struct xfs_log_iovec	nname;
+	struct xfs_log_iovec	newname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 

