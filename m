Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCD8C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbjDFTRF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFTRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:17:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BB7C1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2818560C99
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8628AC433D2;
        Thu,  6 Apr 2023 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808622;
        bh=q6KyTSWLaxU8dptWjMqpsSVBWfIfG7yur1piAMNiAtc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jTOO8QA2hSsa0JAk6QD6gi/RN5R/5odFP2WnJHAM/gTVmJtSnTSfk94Nupx+2CkNj
         O1OLobtwPE0vBEoJkpK19ZL/1qob3Rif5oCyA1+EtX2i7OIL/Fl0sW97dZaydPPhwT
         9+HLso10Q9qY4ay1+plcMrCtkqQr8qUDVgq6AnYOUBa0VpHPTpEnlvHBg8/JGAuZr3
         sESQzSZrzoBbRsHTuN6nXc+g0PgjFch0h4Cp3WvzaZ2zuxJSCmkYN3iBVta8b77Amy
         zE65zQgD95AwQA7rPdMyg6B9ZDGQdlYPSbKPZYOOBSrNCmD0k31hVlN50Oem4sLiTX
         bf3VJt5Akp9Vw==
Date:   Thu, 06 Apr 2023 12:17:02 -0700
Subject: [PATCH 02/12] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823833.613065.377220236636487349.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c |    9 +++++----
 fs/xfs/xfs_xattr.c       |    5 +++++
 2 files changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..1518b786cdaa 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -967,6 +967,7 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			is_remove = args->op_flags & XFS_DA_OP_REMOVE;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
@@ -991,7 +992,7 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -1025,7 +1026,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (!is_remove || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -1039,7 +1040,7 @@ xfs_attr_set(
 	switch (error) {
 	case -EEXIST:
 		/* if no value, we are performing a remove operation */
-		if (!args->value) {
+		if (is_remove) {
 			error = xfs_attr_defer_remove(args);
 			break;
 		}
@@ -1051,7 +1052,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (is_remove)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 7b9a0ed1b11f..61779d92295f 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -103,6 +103,11 @@ xfs_attr_change(
 		use_logging = true;
 	}
 
+	if (args->value)
+		args->op_flags &= ~XFS_DA_OP_REMOVE;
+	else
+		args->op_flags |= XFS_DA_OP_REMOVE;
+
 	error = xfs_attr_set(args);
 
 	if (use_logging)

