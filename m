Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDF2C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCPTZD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCPTYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1198F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 452A9620C9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2201C433EF;
        Thu, 16 Mar 2023 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994692;
        bh=4da1JGoaTumCtGUYtZvYb8OzV9FyfHbk5q6nVBwUc1E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=A8UfZbdIe5luWclLUAT10dCLG0NxskF3wbGPJ7sPKiWxbbwXsCrXtJ72kJYbMwP8N
         CoyV89X8dO/LO5ezjlWoMo5DeOZEEuEy6ntCQy4CbqppThBMEunjYacaOQsrUMNr8P
         B8yVsExZLRQEEK2sTN56D7GKbxG2MaxzNas6Su1e4zHcEQgZXaScjExgG/nZaDwBqA
         GH1FdR4Q7HDf8ojyVGVueodookxhAgjJQ4lknHxjjXkFHXYBbhyyS0ZhZ2v9v6J9xY
         TwEaqEwkmKwR5HuXfC2/VEH5Uko2EdTQUjfxDB1MEsKSrdoo5HIghLe7ChMCLsYXfE
         A94n29ZB5gUFg==
Date:   Thu, 16 Mar 2023 12:24:52 -0700
Subject: [PATCH 13/17] xfs: refactor value length in
 xlog_recover_attri_commit_pass2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414538.15363.14444730518973628460.stgit@frogsfrogsfrogs>
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

Use a shorter convenience variable for the attr value length in this
function, since we've just done that for attr name lengths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index bb21d4e6dcf2..fba6a472805d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -775,6 +775,7 @@ xlog_recover_attri_commit_pass2(
 	size_t				len;
 	const void			*attr_newname = NULL;
 	unsigned int			name_len = 0, newname_len = 0;
+	unsigned int			value_len;
 	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -792,6 +793,7 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	value_len = attri_formatp->alfi_value_len;
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_NVSET:
@@ -878,8 +880,8 @@ xlog_recover_attri_commit_pass2(
 
 
 	/* Validate the attr value, if present */
-	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+	if (value_len != 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -902,7 +904,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Regular remove operations operate only on names. */
-		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+		if (attr_value != NULL || value_len != 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -950,8 +952,7 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_newname,
-			newname_len, attr_value,
-			attri_formatp->alfi_value_len);
+			newname_len, attr_value, value_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);

