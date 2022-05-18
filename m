Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E147C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbiERSzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbiERSzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53AB230204
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D619B821AB
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B076C385A5;
        Wed, 18 May 2022 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900099;
        bh=YBdYbjJu4RhlxWLVRipRGZb4Ty5HW4b1CFLJ0kcOliA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rhcrwqJvSsk36/6j8JYCAHuopbHUP1HDyyn1tyPMAJhdrFOxhE/JuTx9EHPGlfDTd
         M2GJEebMKKSePuT0Yhwqh5OufQXMnm6qOxZYKKi6+NKasc85HLjF76/8BguWr/wleY
         BzEvMmlqKvr+Uxqh6YYCczcybCmnPFcEIqsdU/71HH83Iy2rJE/Un8Zz43to7zDXbC
         sc2ls4ZkB9OWG1VAaS4lYaieEMOSgVc1bGWaqKJYXoKo8ROj6eCP+HPKEMQrFIvclM
         K6m1ZDSonKHKxDgpUcdlZAR0pthGD2EIGNjno7AVx23XwoPt1KJ1OZyAzwFNbrXzf3
         QJY7vglTQoylg==
Subject: [PATCH 4/4] xfs: reject unknown xattri log item filter flags during
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:54:58 -0700
Message-ID: <165290009876.1646028.9980499225084838287.stgit@magnolia>
In-Reply-To: <165290007585.1646028.11376304341026166988.stgit@magnolia>
References: <165290007585.1646028.11376304341026166988.stgit@magnolia>
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
attr *filter* field from xfs_da_args, so rename the field and create
a mask to make checking for invalid bits easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |   10 +++++++++-
 fs/xfs/xfs_attr_item.c         |   10 +++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f7edd1ecf6d9..a9d08f3d4682 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -911,6 +911,14 @@ struct xfs_icreate_log {
 #define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
+/*
+ * alfi_attr_filter captures the state of xfs_da_args.attr_filter, so it should
+ * never have any other bits set.
+ */
+#define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
+					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_INCOMPLETE)
+
 /*
  * This is the structure used to lay out an attr log item in the
  * log.
@@ -924,7 +932,7 @@ struct xfs_attri_log_format {
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
 	uint32_t	alfi_name_len;	/* attr name length */
 	uint32_t	alfi_value_len;	/* attr value length */
-	uint32_t	alfi_attr_flags;/* attr flags */
+	uint32_t	alfi_attr_filter;/* attr filter flags */
 };
 
 struct xfs_attrd_log_format {
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ae227a56bbed..fd0a74f3ef45 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -353,7 +353,8 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
 	attrp->alfi_name_len = attr->xattri_da_args->namelen;
-	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
+	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
+	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 
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

