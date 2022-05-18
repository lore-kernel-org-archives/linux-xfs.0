Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA16C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbiERSy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbiERSyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ABE218FD4
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380C46183D
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ACCC385A9;
        Wed, 18 May 2022 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900093;
        bh=I0PQxYC8YOSfddxnlxjN6U8/5028Nbtd+WBnZAiROXY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G3dyI9P9eQx3iO2fV78CNQ9O88cMQzGFPvN605xugDKhUQkzZqVVwr22JTPz0e+vK
         TmTuwjfCb+sLg57/CKmDbkT7Orfc3fc+M1h/NT6dAixr3d0kCzGsWjKmG72s+hklNw
         kV1xe2eGGLO/3naaH2yMu7UpxP6PuSb7hvxfac6Ce1oFgX/hRUGkOCHQd1+FE0QEus
         4rZplKNjowrmCjK7nKAhd/xR9fBALxCF0RacEWxTCf1Ocoy98KqxxAguKhZtcqV5QF
         c5XVX5OXGRd5aU4O1rw7MLUXpaxMPodp373TGKzX+WhWjlBPUBzW6+kl41IInYO2ZB
         qL+oXpSFVPaOg==
Subject: [PATCH 3/4] xfs: reject unknown xattri log item operation flags
 during recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:54:53 -0700
Message-ID: <165290009308.1646028.18416941628526291634.stgit@magnolia>
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

Make sure we screen the op flags field of recovered xattr intent log
items to reject flag bits that we don't know about.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_attr_item.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 687cf517841a..ae227a56bbed 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -349,6 +349,7 @@ xfs_attr_log_item(
 	 */
 	attrp = &attrip->attri_format;
 	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
+	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
 	attrp->alfi_name_len = attr->xattri_da_args->namelen;
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

