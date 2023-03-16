Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC8AC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjCPTYp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjCPTYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:24:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1555DCB074
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF615B8231F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E40C433D2;
        Thu, 16 Mar 2023 19:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994661;
        bh=F1c5e8kjO+YF7R3jF8Pw7hzSmq0aNvy1mC83XbhCTLA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UZNTEeAGBHXbkYMPb4ISRTRr/lSn5jtu/yw3hVc6jdwL8OTSdHrQ3IeP4xEGlNz1E
         aV80K/+FXezIZMPFZ0mEzDnHR2hi9gVrqx2yOpARBiMSZ68v5nrsdfbJTSWeRTVcoM
         S/lGiyCl8sdI96oMjd2MP/K4SxPWNd56r+Clni/bvaHM1Z5xKfDfGpb7b2XPm/OM4M
         Ztg+MIwTKg4CDYLNcDxKOz274SIBzgA8TO55aLHZflsRVybtGOKbwfTZObaErE17AJ
         oB/iyMkS65j1DHB6PXTJi2ZA2eeVbPXDewMdaUbaKt5E3XabffVp3TZ93X1z7B1Fir
         TU/2n3ol66siA==
Date:   Thu, 16 Mar 2023 12:24:21 -0700
Subject: [PATCH 11/17] xfs: log VLOOKUP xattr setting operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414510.15363.16708486637227385829.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr set operation with the
VLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    6 +++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |    8 +++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3425b94ca4ab..313593b36e65 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -916,9 +916,13 @@ xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_SET;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
+	if (args->op_flags & XFS_DA_OP_VLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVSET;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a3d95a3d8476..1fe9f7394812 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -960,6 +960,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	5	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	6	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a72368acda3d..4472250f461c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -550,6 +550,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 		break;
 	default:
 		return false;
@@ -639,6 +640,9 @@ xfs_attri_item_recover(
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
+		args->op_flags |= XFS_DA_OP_VLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
@@ -775,6 +779,7 @@ xlog_recover_attri_commit_pass2(
 
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		/* Log item, attr name, optional attr value */
 		if (item->ri_total != 3 && item->ri_total != 2) {
@@ -886,6 +891,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -894,7 +900,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 *
-		 * Name-value remove operations must have a name, do not
+		 * Name-value set/remove operations must have a name, do not
 		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {

