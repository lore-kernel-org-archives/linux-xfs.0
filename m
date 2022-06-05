Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD3AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 16:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351242AbiFEQhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 12:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346126AbiFEQhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 12:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9012CB841
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 09:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A89E261135
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 16:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B40FC385A5;
        Sun,  5 Jun 2022 16:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654447022;
        bh=M4QF0ECuCoLk5OC2vTRADfNycwUV2mmsTKfLK3rlOns=;
        h=Date:From:To:Cc:Subject:From;
        b=TWXv2qB5jM14S9dnDEG2dnZiW/d3j04Ft8RFw53/Jr6GlKD+WEdV/R2kilydU0sNO
         +9WPwN1ZOoI4martBx9XWG0fL9l/SUvFf81K36yPXpmtlDjSvtEA+aMOXHWr+zyl4A
         a9NI8hrKEivgtGPGcP4IXWrBh27NhJKxwpjEwzU4Dm3PoRmBv8O+J/Q9Qr5uCzZt+3
         YU/k1If5HoJ15UWZ31h/D3uJnekaL2LfjQhNE0xCYjyT5HhjxwbQyEpi1C1cispR4A
         695T+xPmnk9SvO8KqWy2hhroUNO4jXU6ijqPe8O3A5F9sEKq2PPVyjkM9pN/gFHcDa
         RewE4Fih0scCw==
Date:   Sun, 5 Jun 2022 09:37:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: fix TOCTOU race involving the new logged xattrs
 control knob
Message-ID: <YpzbrQdA9voYKRCE@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I found a race involving the larp control knob, aka the debugging knob
that lets developers enable logging of extended attribute updates:

Thread 1			Thread 2

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
 fs/xfs/libxfs/xfs_attr.h      |   12 +-----------
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 +-
 fs/xfs/libxfs/xfs_da_btree.h  |    4 +++-
 fs/xfs/xfs_attr_item.c        |   15 +++++++++------
 fs/xfs/xfs_xattr.c            |   17 ++++++++++++++++-
 5 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e329da3e7afa..b4a2fc77017e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
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
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 15a990409463..37e7c33f6283 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1530,7 +1530,7 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_REPLACE) {
-		if (!xfs_has_larp(mp))
+		if (!(args->op_flags & XFS_DA_OP_LOGGED))
 			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index d33b7686a0b3..033c35e71c85 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
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
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4a28c2d77070..135d44133477 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -413,18 +413,20 @@ xfs_attr_create_intent(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_attri_log_item	*attrip;
 	struct xfs_attr_intent		*attr;
+	struct xfs_da_args		*args;
 
 	ASSERT(count == 1);
 
-	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
-		return NULL;
-
 	/*
 	 * Each attr item only performs one attribute operation at a time, so
 	 * this is a list of one
 	 */
 	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
 			xattri_list);
+	args = attr->xattri_da_args;
+
+	if (!(args->op_flags & XFS_DA_OP_LOGGED))
+		return NULL;
 
 	/*
 	 * Create a buffer to store the attribute name and value.  This buffer
@@ -432,8 +434,6 @@ xfs_attr_create_intent(
 	 * and the lower level xattr log items.
 	 */
 	if (!attr->xattri_nameval) {
-		struct xfs_da_args	*args = attr->xattri_da_args;
-
 		/*
 		 * Transfer our reference to the name/value buffer to the
 		 * deferred work state structure.
@@ -617,7 +617,10 @@ xfs_attri_item_recover(
 	args->namelen = nv->name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
-	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
+	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
+			 XFS_DA_OP_LOGGED;
+
+	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 35e13e125ec6..149a8f537b06 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -68,6 +68,18 @@ xfs_attr_rele_log_assist(
 	xlog_drop_incompat_feat(mp->m_log);
 }
 
+#ifdef DEBUG
+static inline bool
+xfs_attr_want_log_assist(
+	struct xfs_mount	*mp)
+{
+	/* Logged xattrs require a V5 super for log_incompat */
+	return xfs_has_crc(mp) && xfs_globals.larp;
+}
+#else
+# define xfs_attr_want_log_assist(mp)	false
+#endif
+
 /*
  * Set or remove an xattr, having grabbed the appropriate logging resources
  * prior to calling libxfs.
@@ -80,11 +92,14 @@ xfs_attr_change(
 	bool			use_logging = false;
 	int			error;
 
-	if (xfs_has_larp(mp)) {
+	ASSERT(!(args->op_flags & XFS_DA_OP_LOGGED));
+
+	if (xfs_attr_want_log_assist(mp)) {
 		error = xfs_attr_grab_log_assist(mp);
 		if (error)
 			return error;
 
+		args->op_flags |= XFS_DA_OP_LOGGED;
 		use_logging = true;
 	}
 
