Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6C6C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjEZCIX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjEZCIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1A6E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 790B5614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E2C433D2;
        Fri, 26 May 2023 02:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066900;
        bh=VHLE/2Cxa4TUPG1bmMuLaK34ulP9lwNmeXOZ0qYYtvE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=at1HCX0au7saFLxePaURyihqpOg6sfflXU0HQC0U4uAKkPWxvJ6q9isNswNHZE3P/
         5mpFefC1TErDeg/xHlnluDMxj9wdZJuPsFbzOswaDbRZzIFbze/dlOE1mauu3Sjm48
         8vu9l17zJbkuyAP1dHDwlUorSlW/wEpdOEK8UeXu4qZLuu/Spn+G0f5MVfvESo7oDW
         92vr7zqpKccGN2XzJ6r5ZxvHF6S1xrVIIDRaIOcPxKh6Pd/MPmuC9cwa+OO8vPaJYa
         5IOSuBU8Q3FtecLrj3CGWjln1ya0DQy/QSYTG0L5exCZ+kvJl8QXUOw5XN5aixLH2v
         5NJQKt9owRvfw==
Date:   Thu, 25 May 2023 19:08:20 -0700
Subject: [PATCH 06/12] xfs: use helpers to extract xattr op from opflags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072268.3743652.1496975291425927008.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
References: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |    5 +++++
 fs/xfs/xfs_attr_item.c   |   16 ++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e4f55008552b..4bacafa59a4a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -529,6 +529,11 @@ struct xfs_attr_intent {
 	struct xfs_bmbt_irec		xattri_map;
 };
 
+static inline unsigned int
+xfs_attr_intent_op(const struct xfs_attr_intent *attr)
+{
+	return attr->xattri_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
 
 /*========================================================================
  * Function prototypes for the kernel.
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 35d67bf38186..f6a54efcd102 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -351,6 +351,12 @@ xfs_xattri_finish_update(
 	return error;
 }
 
+static inline unsigned int
+xfs_attr_log_item_op(const struct xfs_attri_log_format *attrp)
+{
+	return attrp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
+
 /* Log an attr to the intent item. */
 STATIC void
 xfs_attr_log_item(
@@ -500,8 +506,7 @@ xfs_attri_validate(
 	struct xfs_mount		*mp,
 	struct xfs_attri_log_format	*attrp)
 {
-	unsigned int			op = attrp->alfi_op_flags &
-					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	unsigned int			op = xfs_attr_log_item_op(attrp);
 
 	if (attrp->__pad != 0)
 		return false;
@@ -573,8 +578,7 @@ xfs_attri_item_recover(
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
-	attr->xattri_op_flags = attrp->alfi_op_flags &
-						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	attr->xattri_op_flags = xfs_attr_log_item_op(attrp);
 
 	/*
 	 * We're reconstructing the deferred work state structure from the
@@ -597,7 +601,7 @@ xfs_attri_item_recover(
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
-	switch (attr->xattri_op_flags) {
+	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->value = nv->value.i_addr;
@@ -731,7 +735,7 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	/* Check the number of log iovecs makes sense for the op code. */
-	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

