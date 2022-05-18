Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BDDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbiERS4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241746AbiERS4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1365A19C77A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B32D2B821A2
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72980C36AE2;
        Wed, 18 May 2022 18:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900178;
        bh=XFeOWycLBWrQICF7reLr+ufEHRQBvsSaErgMKwkpWZ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XXd1CbSlR6OdKDIiXcEArWrkAVYT2kafBxlqAUA2sof8/pHfrL2/yXC3o5g8VApH/
         JvvmN0dhUVmbCa/aDf/QWRNgV/wVfcEmHVFxAnrPTJ/I8uUTexjXT+lIRBJuM8++Dz
         +yc838zIx+1AD5eMAltUFdhDO63tJXmiF8BHAjzHcY5FfdldoBiNU/djp6L7w0qGfK
         ZaWVAM5aQxCyt88hStOMoSyJxb99zShOHBpIoxQ1k7oJcUVI6makmk5MHnm96n5P15
         fya583zhgJpItwGJU0fQh9Cm5WoMOvZUKaBsTWY8ahNDv4XUYr49kHTS8PFl/nQaj+
         9OskbW7lSJ0sw==
Subject: [PATCH 6/7] xfs: clean up state variable usage in
 xfs_attr_node_remove_attr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:56:18 -0700
Message-ID: <165290017800.1647637.17976841524804650684.stgit@magnolia>
In-Reply-To: <165290014409.1647637.4876706578208264219.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The state variable is now a local variable pointing to a heap
allocation, so we don't need to zero-initialize it, nor do we need the
conditional to decide if we should free it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 162fbac78524..b1300bd10318 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1516,7 +1516,7 @@ xfs_attr_node_remove_attr(
 	struct xfs_attr_item		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state		*state = xfs_da_state_alloc(args);
 	int				retval = 0;
 	int				error = 0;
 
@@ -1526,8 +1526,6 @@ xfs_attr_node_remove_attr(
 	 * attribute entry after any split ops.
 	 */
 	args->attr_filter |= XFS_ATTR_INCOMPLETE;
-	state = xfs_da_state_alloc(args);
-	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error)
 		goto out;
@@ -1545,8 +1543,7 @@ xfs_attr_node_remove_attr(
 	retval = error = 0;
 
 out:
-	if (state)
-		xfs_da_state_free(state);
+	xfs_da_state_free(state);
 	if (error)
 		return error;
 	return retval;

