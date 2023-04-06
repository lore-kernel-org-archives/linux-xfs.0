Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD9AC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbjDFTSI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240423AbjDFTSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:18:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FCE1BEE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A296F60F3E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1528DC433EF;
        Thu,  6 Apr 2023 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808685;
        bh=m9mNOFnNGWKM8FrcWIt8Rms0QFVSsgHawLw9cL8fGHs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jB3iqvM8s3FRP/lz/gtQd4NJHK63jTUclrpngX09ZohdFHfbYT9IkapJl8d01yPRX
         hvy8AtKTx+7fKL/DtI77S20of5x81a7jygL0E/nv3UqC4RxjKaG8ltN4bE/h+5zC6/
         hdXAWIBwelIQLEqiJRBuC4y9hmPARN/fDQU8l6lSDMsLzRMoDvcZKSEoV0ZZJ9UlTG
         SWoyJSPLi7wY6R3tb8ROkeM1bG1JO4uPlWF4TF1ISSLbYcDiOMdCwGFG/fauHOVza8
         S2uF5LHiiY41QIrg2I1S0S2089hmamtzNbnp+x6W6QljfEHaTvac/Kecq9+rFJwa+r
         Fs6n7TxKPx2kA==
Date:   Thu, 06 Apr 2023 12:18:04 -0700
Subject: [PATCH 06/12] xfs: use helpers to extract xattr op from opflags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823889.613065.12567417828619394071.stgit@frogsfrogsfrogs>
In-Reply-To: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
References: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
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
index 81be9b3e4004..f0aa372ecba1 100644
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
index 61ed139af8b1..23fee7c0938f 100644
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
@@ -596,7 +600,7 @@ xfs_attri_item_recover(
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
-	switch (attr->xattri_op_flags) {
+	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->value = nv->value.i_addr;
@@ -730,7 +734,7 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	/* Check the number of log iovecs makes sense for the op code. */
-	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

