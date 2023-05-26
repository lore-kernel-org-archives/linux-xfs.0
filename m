Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5572C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjEZCJK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjEZCJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:09:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D0CE7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A80961834
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E396C433EF;
        Fri, 26 May 2023 02:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066947;
        bh=XISg/hWmeG1p6+PYnwggpCimrKFCzd+qydbUjmk1cP4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=K1WKaX+/NsbSDrVLo35dnN+jka7gfAIIPMgsh//hyCWFs2XWZEMfECRpBxTV9IdWk
         4o+oaCzASQNlqwi1ZkskZ7R17hc1SQ7sUA8lOLTEz6A6HO8qSmXPGSJOZnXYyjkelU
         P+3IMsDGLMBcGhM2XUIzxMplMBoePzXieXP2VYqVubciBVu7W9d3gDfyZoFRXzRoaP
         rOk4tTRSab1DG/8qofjxtHjikbpa7fC9fSfKd120apOWRlCVEIxQ/03UOk/jCRPbf9
         MRDF1+pfMezjMtG3rI2VuDlWXdpWx38g0u2jKu7kPeA31YfMs90EyFfe4IZipnjUEk
         hKhbIQlmf3Phg==
Date:   Thu, 25 May 2023 19:09:07 -0700
Subject: [PATCH 09/12] xfs: use local variables for name and value length in
 _attri_commit_pass2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072311.3743652.9548361018791386779.stgit@frogsfrogsfrogs>
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

We're about to start using tagged unions in the xattr log format, so
create a bunch of local variables in the recovery function so we only
have to decode the log item fields once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2da3e3f53987..5f5f2f9e8dd7 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -712,9 +712,11 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_item       *attrip;
 	struct xfs_attri_log_format     *attri_formatp;
 	struct xfs_attri_log_nameval	*nv;
-	const void			*attr_value = NULL;
 	const void			*attr_name;
+	const void			*attr_value = NULL;
 	size_t				len;
+	unsigned int			name_len = 0;
+	unsigned int			value_len = 0;
 	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -743,6 +745,8 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
@@ -751,6 +755,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -760,15 +765,14 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[i].i_len !=
-			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
+	if (item->ri_buf[i].i_len != xlog_calc_iovec_len(name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(attr_name, name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
@@ -776,8 +780,8 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr value, if present */
-	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+	if (value_len != 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
@@ -801,7 +805,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Regular remove operations operate only on names. */
-		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+		if (attr_value != NULL || value_len != 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -814,7 +818,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 */
-		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -827,9 +831,8 @@ xlog_recover_attri_commit_pass2(
 	 * name/value buffer to the recovered incore log item and drop our
 	 * reference.
 	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
-			attri_formatp->alfi_value_len);
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
+			attr_value, value_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);

