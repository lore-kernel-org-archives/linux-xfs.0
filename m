Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856D9C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZCHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZCHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:07:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97BDA3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F81464C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDB9C433D2;
        Fri, 26 May 2023 02:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066838;
        bh=hf8Dw/u5EVzhLaZ694+JTkwkU2UkXFeFhes9D3+1nkQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QscrwolSN7K05+JNObWDHQyi5q25P6EEWfXp37pVZ0QGlLGcARsd0qGLkiTpyUBe8
         dOLxuewQc0QhUYDLdKbAXSf9P4j0QCQYah3zwluz/4TBJZgkUjpnoTN5eKdOP9idsU
         NPYEwT6aEXQxQAkp63ucvAFfmJhGwzJQXfAy+ttuDn/rODOuReryOQBkBZuuyyHbLs
         Zk5AS51O7VmEbUAgkZkVOK53c2xuKg7RWzPUWfAvjKwLtX/6oBLteas75B8IsxVS/P
         5hAOpsZ3aVGmvJKvWTmYLBaTlTBwpHgruMyRreP1n2+LYA76esYkdehbcnvs3F720m
         TQiPyUSI7eXAw==
Date:   Thu, 25 May 2023 19:07:18 -0700
Subject: [PATCH 02/12] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072210.3743652.6278949108151855588.stgit@frogsfrogsfrogs>
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
index d38a4c42a912..343fa2bf0227 100644
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
index 71f6263505d3..5704fada042e 100644
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

