Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA7DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbiEPDcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiEPDcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9101C1FCC1
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 344D960EBE
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983A9C385AA;
        Mon, 16 May 2022 03:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671929;
        bh=H8zxR5o5TKCkoOOg45UVdKqu+zQR50zSJVlQ4o+bTL8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WO0P3PklTj8Gh3RdnPdUoik0Gn2gVLmG/FhT6T5uDPTMnrd67K/8m5QU5xoZZZXq0
         ogU4MY+dFBsaj6BpFE14n2fvZWpzEHqkzYERw2bBFZ7B+Agpcqv/Fj24d6tr2rPjoF
         ESyn+9cFiUEGekYVc7+W9rMMSTifLgDEhdXwhjLXKSIBY6kdmS7lCQQjf3ShOke2nA
         2IwYJhwr1aAAUvCj4Hgub27L40RoJWCZB3QlrMULCnqEQikEz/p+vSsv0BQGX4Vf0G
         9cGT26WprpxMNkqjg4uM2kA3MmB3HHbZbS36nLYFb/DeKzdZLXdSKepuXQeRfdDfPY
         +8G03ss0D4wcQ==
Subject: [PATCH 3/4] xfs: reject unknown xattri log item operation flags
 during recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:09 -0700
Message-ID: <165267192904.625255.1227477138553372618.stgit@magnolia>
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

Make sure we screen the op flags field of recovered xattr intent log
items to reject flag bits that we don't know about.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 687cf517841a..459b6c93b40b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -349,7 +349,8 @@ xfs_attr_log_item(
 	 */
 	attrp = &attrip->attri_format;
 	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
-	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_op_flags = attr->xattri_op_flags &
+						XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
 	attrp->alfi_name_len = attr->xattri_da_args->namelen;
 	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
@@ -496,6 +497,9 @@ xfs_attri_validate(
 	if (attrp->__pad != 0)
 		return false;
 
+	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
+		return false;
+
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
@@ -556,7 +560,8 @@ xfs_attri_item_recover(
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
-	attr->xattri_op_flags = attrp->alfi_op_flags;
+	attr->xattri_op_flags = attrp->alfi_op_flags &
+						XFS_ATTR_OP_FLAGS_TYPE_MASK;
 
 	args->dp = ip;
 	args->geo = mp->m_attr_geo;
@@ -567,7 +572,7 @@ xfs_attri_item_recover(
 	args->attr_filter = attrp->alfi_attr_flags;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
 
-	switch (attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK) {
+	switch (attr->xattri_op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 	case XFS_ATTR_OP_FLAGS_REPLACE:
 		args->value = attrip->attri_value;

