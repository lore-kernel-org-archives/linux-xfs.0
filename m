Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DC2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiEPDcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbiEPDcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528481FCC1
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 763E5B80E16
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A72C385AA;
        Mon, 16 May 2022 03:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671935;
        bh=m1AhM4TuoVTHsGUBd9W/j+19m2kp13L0BHWojQSBkc8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=igUjCGQ/Bf/GhFvjUi8BMGAugn2LqHVbcWajMkrUDkQEsfK/AdWqL/g7SLUNy1XuY
         LF654yN1IUDitv3m96T9ZpDfqDunwdaANI93dtJTDIPeO0gXcmRI4MAxPQ8QWM9InB
         j9CVNpYdRDl5HeclVYxVM7T/3XXVSNJ8vnRhOE8C1dY/pG6K0P9oDhxGXPAUknyipC
         QYXmejo7q1W+M/fTELpTpFqePD2XVYxo+zG7BOomG0fkOZf5bBOwp41F1Mhnm2Otqb
         giyXMkHakgK3tfoqqbnQ2y8et0fZYJ3jJpQgOzJVLoxAQU6m8p+Y0Lrt1lcNZMhwpx
         rOnZl13Dys5kw==
Subject: [PATCH 4/4] xfs: reject unknown xattri log item filter flags during
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:14 -0700
Message-ID: <165267193475.625255.2721960601959913094.stgit@magnolia>
In-Reply-To: <165267191199.625255.12173648515376165187.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we screen the "attr flags" field of recovered xattr intent log
items to reject flag bits that we don't know about.  This is really the
attr *filter* flags, so rename the field and create properly namespaced
flags to fill it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    9 ++++++++-
 fs/xfs/xfs_attr_item.c         |   10 +++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f7edd1ecf6d9..5017500bfd8b 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -911,6 +911,13 @@ struct xfs_icreate_log {
 #define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
+#define XFS_ATTRI_FILTER_ROOT		(1u << XFS_ATTR_ROOT_BIT)
+#define XFS_ATTRI_FILTER_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTRI_FILTER_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
+#define XFS_ATTRI_FILTER_MASK		(XFS_ATTRI_FILTER_ROOT | \
+					 XFS_ATTRI_FILTER_SECURE | \
+					 XFS_ATTRI_FILTER_INCOMPLETE)
+
 /*
  * This is the structure used to lay out an attr log item in the
  * log.
@@ -924,7 +931,7 @@ struct xfs_attri_log_format {
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
 	uint32_t	alfi_name_len;	/* attr name length */
 	uint32_t	alfi_value_len;	/* attr value length */
-	uint32_t	alfi_attr_flags;/* attr flags */
+	uint32_t	alfi_attr_filter;/* attr filter flags */
 };
 
 struct xfs_attrd_log_format {
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 459b6c93b40b..7cbb640d7856 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -353,7 +353,8 @@ xfs_attr_log_item(
 						XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
 	attrp->alfi_name_len = attr->xattri_da_args->namelen;
-	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
+	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter &
+						XFS_ATTRI_FILTER_MASK;
 
 	memcpy(attrip->attri_name, attr->xattri_da_args->name,
 	       attr->xattri_da_args->namelen);
@@ -500,6 +501,9 @@ xfs_attri_validate(
 	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
 		return false;
 
+	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
+		return false;
+
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
@@ -569,7 +573,7 @@ xfs_attri_item_recover(
 	args->name = attrip->attri_name;
 	args->namelen = attrp->alfi_name_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
-	args->attr_filter = attrp->alfi_attr_flags;
+	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
 
 	switch (attr->xattri_op_flags) {
@@ -658,7 +662,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
-	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	memcpy(new_attrip->attri_name, old_attrip->attri_name,
 		new_attrip->attri_name_len);

