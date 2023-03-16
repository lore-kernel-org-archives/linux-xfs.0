Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DCBC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjCPTZO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCPTZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:25:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF9361A8E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FAA4B82290
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B6DC433D2;
        Thu, 16 Mar 2023 19:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994708;
        bh=psNJNocFjxXvWACpmKxDP4xqdallEbCnLoCK7FQ8mgs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uUNwh53wV+y5knqWuTqOQcrKUetSrm3G6rbwhbwwocaKkUnf+AUProJ4qC9UkyraC
         GqSQxRkJ+5az9btJrWGiUMDM9d2Oefzu24SMHvLOytClphvsLbDf0eEV/NrD1L/xeX
         NfZha3peI33B209h42bnG7UGUxmfseTuW3/32JmBl4ewNqJNk/+/IJgCyv6YqxSy95
         TJ92T9q+aXE3bCiHEzEwZI4CACqCaAThjkpF/RcV99vwXvxrNlziMR/VXtiHw17yvR
         vqiUe5N+rJ8YAVwYN+LBnytDiy+f+8Xn6Skt2Ix01Jj/YBaRVP2X1N2wvtkcazqXJX
         1vAnBgi0PXmuQ==
Date:   Thu, 16 Mar 2023 12:25:07 -0700
Subject: [PATCH 14/17] xfs: rename nname to newname
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414552.15363.3487395942887673254.stgit@frogsfrogsfrogs>
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

Burn a couple of extra source code bytes to make it clear what this does.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    2 +-
 fs/xfs/xfs_attr_item.c         |   40 ++++++++++++++++++++--------------------
 fs/xfs/xfs_attr_item.h         |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)


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
index fba6a472805d..b730f8e7a785 100644
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
 	args->value = nv->value.i_addr;
 	args->valuelen = nv->value.i_len;
@@ -858,7 +858,7 @@ xlog_recover_attri_commit_pass2(
 	}
 	i++;
 
-	/* Validate the attr nname */
+	/* Validate the new attr name */
 	if (newname_len > 0) {
 		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(newname_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
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
 

