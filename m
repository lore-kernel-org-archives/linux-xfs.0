Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FE6C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCPTYj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCPTYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B5472032
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38864B82290
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C09C433EF;
        Thu, 16 Mar 2023 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994645;
        bh=M5xBE6gYpbl+tBX+vxNTlVSKJUGdONslsEpwCaod+Nw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=S5pj1/DJJqhiCNQKbwcH/o3LPasJY1IgvCEzhVvc9DCD1aSTm5RMZN1n6Hmu3f3wA
         qgwyjsk9+lby3GC1TiuJkMNWe552va7KNdEIUU71QY+2bguCmJtukdGia79Me/TEi2
         d8/5tNcnd3dcbFlWQPLx+UszGI6yNuwfldYPYQKAXjDPTui14GhW2LWhb0JCTcF7Fs
         I53g3vCzMR0oBCv49dO6PL+1F65uRURMblrmwr0BB0D7gGuXkNEUQeC+SmsrxYyXvY
         dYpTvXPAlk1PLTBfAyTb8JZjjeCRFyu0tO5onvCHMTVdCE7J+CrOZD0pgcTXWPn2vR
         35/JupV+swdFw==
Date:   Thu, 16 Mar 2023 12:24:05 -0700
Subject: [PATCH 10/17] xfs: log VLOOKUP xattr removal operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414496.15363.4226611011899994676.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr remove operation with
the VLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1a047099e9c7..3425b94ca4ab 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -959,9 +959,13 @@ xfs_attr_defer_remove(
 {
 
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_REMOVE;
 	int			error;
 
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
+	if (args->op_flags & XFS_DA_OP_VLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREMOVE;
+
+	error  = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 727b5a858028..a3d95a3d8476 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -959,6 +959,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	5	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 66b4c167588d..a72368acda3d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -549,6 +549,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		break;
 	default:
 		return false;
@@ -647,6 +648,9 @@ xfs_attri_item_recover(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		args->op_flags |= XFS_DA_OP_VLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
 			goto out;
@@ -771,6 +775,14 @@ xlog_recover_attri_commit_pass2(
 
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		/* Log item, attr name, optional attr value */
+		if (item->ri_total != 3 && item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/* Log item, attr name, attr value */
@@ -874,12 +886,16 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/*
 		 * Regular xattr set/remove/replace operations require a name
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
+		 *
+		 * Name-value remove operations must have a name, do not
+		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,

