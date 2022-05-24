Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13887C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiEXFgx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiEXFgw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574D665D0A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DB56B8175F
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97D7C385AA;
        Tue, 24 May 2022 05:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370608;
        bh=DwBg9n4Wbc/HFjBkrdtGTQAlyMYfjqtS7MVeTIll+2c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u+R7wb3lHZj+Ex0rOAolmw9dhPXssycnlDVU2A1Tgny+smwOQ91ip5uC+fQp31GZB
         xfBwdDEsTE+D5tEMFRopb5luV7rf+3kP2z9bXcg2aUPd/a04+6HqdRWkL0rmK5LVd+
         wYB9A7mL4OH4t7UeyORdUgD5012mLOemMEnL0ix1h3ctAS+MH17YHajX2G4MKsKyBO
         9RPaCz53SINK9d0GqHhppLSnkoOZ+S4smF/43gYpvp3MjFTfMrgyoEz6ZS3kU8M62R
         BG0q1d+5YI5xtuzYLXR39o5r3agkGBivYtXMdNQmoTtAsoydsHOik/ukbAwsSt8oKd
         oi1Zzg6P+3TZQ==
Subject: [PATCH 5/5] xfs: move xfs_attr_use_log_assist usage out of libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:48 -0700
Message-ID: <165337060828.994444.7975135646390262956.stgit@magnolia>
In-Reply-To: <165337058023.994444.12794741176651030531.stgit@magnolia>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The LARP patchset added an awkward coupling point between libxfs and
what would be libxlog, if the XFS log were actually its own library.
Move the code that sets up logged xattr updates out of libxfs and into
xfs_xattr.c so that libxfs no longer has to know about xlog_* functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   12 +-----------
 fs/xfs/xfs_acl.c         |    3 ++-
 fs/xfs/xfs_ioctl.c       |    3 ++-
 fs/xfs/xfs_iops.c        |    3 ++-
 fs/xfs/xfs_xattr.c       |   34 +++++++++++++++++++++++++++++++---
 fs/xfs/xfs_xattr.h       |    3 +--
 6 files changed, 39 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 24fa213715c1..836ab1b8ed7b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -982,7 +982,6 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
-	bool			use_logging = xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -1027,12 +1026,6 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
-	if (use_logging) {
-		error = xfs_attr_grab_log_assist(mp);
-		if (error)
-			return error;
-	}
-
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
@@ -1040,7 +1033,7 @@ xfs_attr_set(
 	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		goto drop_incompat;
+		return error;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -1100,9 +1093,6 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-drop_incompat:
-	if (use_logging)
-		xfs_attr_rele_log_assist(mp);
 	return error;
 
 out_trans_cancel:
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3df9c1782ead..b744c62052b6 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -17,6 +17,7 @@
 #include "xfs_error.h"
 #include "xfs_acl.h"
 #include "xfs_trans.h"
+#include "xfs_xattr.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -202,7 +203,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		xfs_acl_to_disk(args.value, acl);
 	}
 
-	error = xfs_attr_set(&args);
+	error = xfs_attr_change(&args);
 	kmem_free(args.value);
 
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e5cb7936206..5a364a7d58fd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_xattr.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -524,7 +525,7 @@ xfs_attrmulti_attr_set(
 		args.valuelen = len;
 	}
 
-	error = xfs_attr_set(&args);
+	error = xfs_attr_change(&args);
 	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	kfree(args.value);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e912b7fee714..29f5b8b8aca6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -24,6 +24,7 @@
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
+#include "xfs_xattr.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
@@ -61,7 +62,7 @@ xfs_initxattrs(
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
 		};
-		error = xfs_attr_set(&args);
+		error = xfs_attr_change(&args);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index fc6acf7021a7..35e13e125ec6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-int
+static inline int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
@@ -61,13 +61,41 @@ xfs_attr_grab_log_assist(
 	return error;
 }
 
-void
+static inline void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
 	xlog_drop_incompat_feat(mp->m_log);
 }
 
+/*
+ * Set or remove an xattr, having grabbed the appropriate logging resources
+ * prior to calling libxfs.
+ */
+int
+xfs_attr_change(
+	struct xfs_da_args	*args)
+{
+	struct xfs_mount	*mp = args->dp->i_mount;
+	bool			use_logging = false;
+	int			error;
+
+	if (xfs_has_larp(mp)) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			return error;
+
+		use_logging = true;
+	}
+
+	error = xfs_attr_set(args);
+
+	if (use_logging)
+		xfs_attr_rele_log_assist(mp);
+	return error;
+}
+
+
 static int
 xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, void *value, size_t size)
@@ -105,7 +133,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	};
 	int			error;
 
-	error = xfs_attr_set(&args);
+	error = xfs_attr_change(&args);
 	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	return error;
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index d34ef1835541..2b09133b1b9b 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -6,8 +6,7 @@
 #ifndef __XFS_XATTR_H__
 #define __XFS_XATTR_H__
 
-int xfs_attr_grab_log_assist(struct xfs_mount *mp);
-void xfs_attr_rele_log_assist(struct xfs_mount *mp);
+int xfs_attr_change(struct xfs_da_args *args);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 

