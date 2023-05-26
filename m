Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860C6C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjEZCTd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEZCTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:19:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5237F187
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:19:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFBBA614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BB6C43443;
        Fri, 26 May 2023 02:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067571;
        bh=Jjpvek0G5ErPa/acMyLJCrWIyd5Telcq1FfI2l1PAMg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Zda4WFa12I3jZceqVxNMHBzihq1IW19ifwb9arLRPPY5dKp/gUAtJaEsl4b+uD1wc
         3UM4tYzXYakqlhpFe63DeO8L5qzhc1MwGRgaM5R+OUZxCHTBdsQjuifx0S9xBxmys6
         LRt2yLkC7Olz2OU1zx0q2i/68+4UZeGE1pYVvKXHixFGgQilU3mzsdfmTP3oph88Z4
         TZTe9DFhqKvlh0bgPUyOaJ3BIAcvXBY8WwCn0PMtovW6kvDYoEV13BpAz5ctuS+Gdz
         32dshDJzogL35BqClajA6IbkF8opWtiPXKeyO8soNQ7otDMKOdbbf+TitHbVDuk/IS
         9BgAQA3ygPLxQ==
Date:   Thu, 25 May 2023 19:19:30 -0700
Subject: [PATCH 01/10] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077448.3749126.4421797460119228908.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
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
index 2b6cdb5f5c3..123bdff1b62 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -185,7 +185,9 @@ attr_remove_f(
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
index c8382190e22..b131a8f2662 100644
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

