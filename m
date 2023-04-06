Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F19C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDFT3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjDFT3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FC75272
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D6F264B8B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB49EC433EF;
        Thu,  6 Apr 2023 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809354;
        bh=iII8BctkB63guvAg8f4E7x/aOCOPewjgG+5xQPtbyQM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dxoftWUNintbwpiccnyx3+LAiWf3289tKiAxeIl4Ex6Sf0Yp6GDE9St8HZY/ObWB3
         qBrb6EhQQN1B4LCECC3plhztnpLwoheHsPARzf0s5j0anzX1ayTeClNP0YHi3ToZb/
         O0e7fA4ZzX3kG1Q0MHNWQ/0sDvLIpG2OGucP0bTC8X28XUrp4LQw4YfTfmuiAG03q2
         HwV2VUyIpEGPi8XLdjhpwhFTtlBknDsrWsmMAEKFazxYQefWILtAscZYTzN6e+JyH1
         m+tiOASpNgyyVF/f22d/aP06aR1SOqauOHWz/bzHbn2xaZhW7Hs7j0MexTVTiEw8Wn
         eIFwoA1kFseQg==
Date:   Thu, 06 Apr 2023 12:29:14 -0700
Subject: [PATCH 01/10] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827129.616519.16285674158489951513.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
References: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quite a few patches from now, we're going to change the parent pointer
xattr format to encode as much of the dirent name in the xattr name as
fits, and spill the rest of it to the xattr value.  To make this work
correctly, we'll be adding the ability to look up xattrs based on name
/and/ value.

Internally, the xattr data structure supports attributes with a zero
length value, which is how we're going to store parent pointers for
short dirent names.  The parent pointer repair code uses xfs_attr_set to
add missing and remove dangling parent pointers, so that interface must
be capable of setting an xattr with args->value == NULL.

The userspace API doesn't support this, so xfs_attr_set currently treats
a NULL args->value as a request to remove an attr.  However, that's a
quirk of the existing callers and the interface.  Make the callers of
xfs_attr_set to declare explicitly that they want to remove an xattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c      |    4 +++-
 libxfs/xfs_attr.c |    9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 0d8d70a84..d493a1329 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -184,7 +184,9 @@ attr_remove_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { };
+	struct xfs_da_args	args = {
+		.op_flags	= XFS_DA_OP_REMOVE,
+	};
 	int			c;
 
 	if (cur_typ == NULL) {
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2103a06b9..177962dec 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -965,6 +965,7 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			is_remove = args->op_flags & XFS_DA_OP_REMOVE;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
@@ -989,7 +990,7 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -1023,7 +1024,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (!is_remove || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -1037,7 +1038,7 @@ xfs_attr_set(
 	switch (error) {
 	case -EEXIST:
 		/* if no value, we are performing a remove operation */
-		if (!args->value) {
+		if (is_remove) {
 			error = xfs_attr_defer_remove(args);
 			break;
 		}
@@ -1049,7 +1050,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (is_remove)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */

