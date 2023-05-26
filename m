Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31442C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZCJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjEZCJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:09:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C85194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE677614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA6CC433EF;
        Fri, 26 May 2023 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066963;
        bh=1ni5/5D2wZ1SWGiliLlIJeGbrExchd/K3rrat5w59ho=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=T7fnOtR1LQGXg1xs+kvR+8BEOtNiEKxYFgKTc7dz3F9sfrEhfEt14m0rxNSbH0IRW
         nlGP7Ah+bS19CTWvrTtjbJK4bDpyYQ/VRqakl0PHwu1Tp7dPcj7cHPXDdLwc0LQ8NE
         Z5ZaxzmLdB7r0heekXGKvxkvKM/5ta5oQbZWEqET9nmVHSdkhm9ndYlnB7dtGHQKN2
         F78vYgSZmoxDFy8zWHWlIi70fSCjLhNHCKk9EZMs2wk3V7k6sEnCINv6ht3CeTZrY6
         Y4saAdnwAc/iiTXK5I7zRLDxNCw2GncJkqGW0rjXAkots/jfkOJGchKOZesLMbSlhK
         oAlGylZMWtaPQ==
Date:   Thu, 25 May 2023 19:09:22 -0700
Subject: [PATCH 10/12] xfs: log NVLOOKUP xattr removal operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072325.3743652.15451477619386202912.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr remove operation with
the NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |   18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b7484251a21a..0f74d9397a6f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -942,9 +942,13 @@ xfs_attr_defer_remove(
 {
 
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_REMOVE;
 	int			error;
 
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREMOVE;
+
+	error  = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index c7d02bb04f41..0eb8362e91d8 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1036,6 +1036,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5f5f2f9e8dd7..1934adb0e2ab 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -522,6 +522,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		break;
 	default:
 		return false;
@@ -612,6 +613,9 @@ xfs_attri_item_recover(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		args->op_flags |= XFS_DA_OP_NVLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
 			goto out;
@@ -737,6 +741,16 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		/* Log item, attr name, optional attr value */
+		if (item->ri_total != 3 && item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/* Log item, attr name, attr value */
@@ -811,12 +825,16 @@ xlog_recover_attri_commit_pass2(
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
 		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,

