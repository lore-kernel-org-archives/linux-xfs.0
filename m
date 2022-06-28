Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE7BC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiF1Uss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiF1Usr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:48:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536BD2CE03
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08180B81E04
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9C0C341C8;
        Tue, 28 Jun 2022 20:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449323;
        bh=S1DN/Nh98tVM49PO5BY28WSyoNxcE+vgXSqt7QCVOgk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n+qDvvHJy/EPdqWt1GaGxhB1+AxKn6EuYlX+/2wanBOBdKa5hwsn3oaDAd/yfx7kl
         JPFJvCPO0IH0vLLJcNMDmYZ5/CeTdnakXp8/UHjt0ZMmN3TRRAd/P+kQoUTba6VebJ
         KGBMEOKyRDRUqgXshwnmC3ryHCQ2pFFL9bbJKMWGBumQ6qfyC5+UaDHYVnVskxs1wR
         ArSBzmTSCtqLvyAfH7Hc+12HTYjirYwkkLNARXh48eiaKu1m2M82CL1QbvHO0dwyBM
         GPip051auOIh3dfXYBzPJhTKJzq8r4GccVzbm80dHojyX/ahk1byWj3bJLJnzTfec3
         gRtWKCjLqPvVg==
Subject: [PATCH 3/8] xfs: fix TOCTOU race involving the new logged xattrs
 control knob
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:48:43 -0700
Message-ID: <165644932309.1089724.2522590493157297421.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: fe5b1eb7fdcb2e5b6dd70da2f17acd8026d93b6a

I found a race involving the larp control knob, aka the debugging knob
that lets developers enable logging of extended attribute updates:

Thread 1                        Thread 2

echo 0 > /sys/fs/xfs/debug/larp
setxattr(REPLACE)
xfs_has_larp (returns false)
xfs_attr_set

echo 1 > /sys/fs/xfs/debug/larp

xfs_attr_defer_replace
xfs_attr_init_replace_state
xfs_has_larp (returns true)
xfs_attr_init_remove_state

<oops, wrong DAS state!>

This isn't a particularly severe problem right now because xattr logging
is only enabled when CONFIG_XFS_DEBUG=y, and developers *should* know
what they're doing.

However, the eventual intent is that callers should be able to ask for
the assistance of the log in persisting xattr updates.  This capability
might not be required for /all/ callers, which means that dynamic
control must work correctly.  Once an xattr update has decided whether
or not to use logged xattrs, it needs to stay in that mode until the end
of the operation regardless of what subsequent parallel operations might
do.

Therefore, it is an error to continue sampling xfs_globals.larp once
xfs_attr_change has made a decision about larp, and it was not correct
for me to have told Allison that ->create_intent functions can sample
the global log incompat feature bitfield to decide to elide a log item.

Instead, create a new op flag for the xfs_da_args structure, and convert
all other callers of xfs_has_larp and xfs_sb_version_haslogxattrs within
the attr update state machine to look for the operations flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      |    6 ++++--
 libxfs/xfs_attr.h      |   12 +-----------
 libxfs/xfs_attr_leaf.c |    2 +-
 libxfs/xfs_da_btree.h  |    4 +++-
 4 files changed, 9 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index dfd284c6..d2e28a27 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -995,9 +995,11 @@ xfs_attr_set(
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.
+	 * removal to fail as well.  Preserve the logged flag, since we need
+	 * to pass that through to the logging code.
 	 */
-	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->op_flags = XFS_DA_OP_OKNOENT |
+					(args->op_flags & XFS_DA_OP_LOGGED);
 
 	if (args->value) {
 		XFS_STATS_INC(mp, xs_attr_set);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index e329da3e..b4a2fc77 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -28,16 +28,6 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
-static inline bool xfs_has_larp(struct xfs_mount *mp)
-{
-#ifdef DEBUG
-	/* Logged xattrs require a V5 super for log_incompat */
-	return xfs_has_crc(mp) && xfs_globals.larp;
-#else
-	return false;
-#endif
-}
-
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -624,7 +614,7 @@ static inline enum xfs_delattr_state
 xfs_attr_init_replace_state(struct xfs_da_args *args)
 {
 	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
-	if (xfs_has_larp(args->dp->i_mount))
+	if (args->op_flags & XFS_DA_OP_LOGGED)
 		return xfs_attr_init_remove_state(args);
 	return xfs_attr_init_add_state(args);
 }
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 75b8f08e..5fea3702 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1527,7 +1527,7 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_REPLACE) {
-		if (!xfs_has_larp(mp))
+		if (!(args->op_flags & XFS_DA_OP_LOGGED))
 			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index d33b7686..ffa3df5b 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -92,6 +92,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
 #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
 #define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -101,7 +102,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
-	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }
+	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
+	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.

