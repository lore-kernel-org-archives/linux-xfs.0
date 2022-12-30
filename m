Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88A7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbiLaCDi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiLaCDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:03:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA0C10B64
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:03:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4915161C5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A005AC433EF;
        Sat, 31 Dec 2022 02:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452215;
        bh=n5KvCVS41tqf7u7/7Ro0SZ/U5evfri9SF9hnka4f6fM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WaORTVUoO3uhuPk01ww8C/eUOWCOqp342+Dbx9We8Pu0MzP+TIXeLYsaDbJhGqOyj
         gbzORHVOUiaUTXr4xL+i9MOvLmwnijD+5UMonnEMfMj6njx9rv8VdzqPTtUyQKyyJ/
         2wV+/kOnC9XZ+mUaIjbSTZso13CLVtNk+vMS4jw03CNpE+rzCHvRWhb9Eof2NOtcc+
         TN8wNWZGEg63NrN0iagUJnfnRtdkEU2yy7leJEoqim8I46nNtqsY6AqxvD/8MTDTav
         e9RA6tNXRZE++mVYkf9p0THR3vQ1uDDVEbTjIg8HayxfVvhjDJB/ma7v5VkDFFamzL
         H06Z+aVhh3zqA==
Subject: [PATCH 02/26] xfs: hoist inode flag conversion functions to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875351.723621.2754453083089475155.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hoist the inode flag conversion functions into libxfs so that we can
keep them in sync.  Do this by creating a new xfs_inode_util.c file in
libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h        |    1 
 include/xfs_inode.h     |    1 
 libxfs/Makefile         |    2 +
 libxfs/util.c           |   60 -----------------------
 libxfs/xfs_bmap.c       |    1 
 libxfs/xfs_inode_util.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |   14 +++++
 7 files changed, 143 insertions(+), 60 deletions(-)
 create mode 100644 libxfs/xfs_inode_util.c
 create mode 100644 libxfs/xfs_inode_util.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 14f6d629c9f..a4f6e1c2b28 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -68,6 +68,7 @@ struct iomap;
 #include "xfs_attr_sf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_buf.h"
+#include "xfs_inode_util.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 3bc5aa2c7cb..ef62ac50912 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -10,6 +10,7 @@
 /* These match kernel side includes */
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_inode_util.h"
 
 struct xfs_trans;
 struct xfs_mount;
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 0e43941948d..0d9c4adf82b 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -48,6 +48,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_inode_util.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
@@ -96,6 +97,7 @@ CFILES = cache.c \
 	xfs_iext_tree.c \
 	xfs_inode_buf.c \
 	xfs_inode_fork.c \
+	xfs_inode_util.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
 	xfs_refcount.c \
diff --git a/libxfs/util.c b/libxfs/util.c
index 3d5ef68d8e7..6b888e9f996 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -150,66 +150,6 @@ current_time(struct inode *inode)
 	return tv;
 }
 
-STATIC uint16_t
-xfs_flags2diflags(
-	struct xfs_inode	*ip,
-	unsigned int		xflags)
-{
-	/* can't set PREALLOC this way, just preserve it */
-	uint16_t		di_flags =
-		(ip->i_diflags & XFS_DIFLAG_PREALLOC);
-
-	if (xflags & FS_XFLAG_IMMUTABLE)
-		di_flags |= XFS_DIFLAG_IMMUTABLE;
-	if (xflags & FS_XFLAG_APPEND)
-		di_flags |= XFS_DIFLAG_APPEND;
-	if (xflags & FS_XFLAG_SYNC)
-		di_flags |= XFS_DIFLAG_SYNC;
-	if (xflags & FS_XFLAG_NOATIME)
-		di_flags |= XFS_DIFLAG_NOATIME;
-	if (xflags & FS_XFLAG_NODUMP)
-		di_flags |= XFS_DIFLAG_NODUMP;
-	if (xflags & FS_XFLAG_NODEFRAG)
-		di_flags |= XFS_DIFLAG_NODEFRAG;
-	if (xflags & FS_XFLAG_FILESTREAM)
-		di_flags |= XFS_DIFLAG_FILESTREAM;
-	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-		if (xflags & FS_XFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (xflags & FS_XFLAG_NOSYMLINKS)
-			di_flags |= XFS_DIFLAG_NOSYMLINKS;
-		if (xflags & FS_XFLAG_EXTSZINHERIT)
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-		if (xflags & FS_XFLAG_PROJINHERIT)
-			di_flags |= XFS_DIFLAG_PROJINHERIT;
-	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
-		if (xflags & FS_XFLAG_REALTIME)
-			di_flags |= XFS_DIFLAG_REALTIME;
-		if (xflags & FS_XFLAG_EXTSIZE)
-			di_flags |= XFS_DIFLAG_EXTSIZE;
-	}
-
-	return di_flags;
-}
-
-STATIC uint64_t
-xfs_flags2diflags2(
-	struct xfs_inode	*ip,
-	unsigned int		xflags)
-{
-	uint64_t		di_flags2 =
-		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
-				   XFS_DIFLAG2_BIGTIME |
-				   XFS_DIFLAG2_NREXT64));
-
-	if (xflags & FS_XFLAG_DAX)
-		di_flags2 |= XFS_DIFLAG2_DAX;
-	if (xflags & FS_XFLAG_COWEXTSIZE)
-		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-
-	return di_flags2;
-}
-
 /* Propagate di_flags from a parent inode to a child inode. */
 static void
 xfs_inode_propagate_flags(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c4a81537ccf..afa432727db 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,6 +31,7 @@
 #include "xfs_refcount.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_inode_util.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
new file mode 100644
index 00000000000..868a77cafa6
--- /dev/null
+++ b/libxfs/xfs_inode_util.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_inode_util.h"
+
+uint16_t
+xfs_flags2diflags(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	/* can't set PREALLOC this way, just preserve it */
+	uint16_t		di_flags =
+		(ip->i_diflags & XFS_DIFLAG_PREALLOC);
+
+	if (xflags & FS_XFLAG_IMMUTABLE)
+		di_flags |= XFS_DIFLAG_IMMUTABLE;
+	if (xflags & FS_XFLAG_APPEND)
+		di_flags |= XFS_DIFLAG_APPEND;
+	if (xflags & FS_XFLAG_SYNC)
+		di_flags |= XFS_DIFLAG_SYNC;
+	if (xflags & FS_XFLAG_NOATIME)
+		di_flags |= XFS_DIFLAG_NOATIME;
+	if (xflags & FS_XFLAG_NODUMP)
+		di_flags |= XFS_DIFLAG_NODUMP;
+	if (xflags & FS_XFLAG_NODEFRAG)
+		di_flags |= XFS_DIFLAG_NODEFRAG;
+	if (xflags & FS_XFLAG_FILESTREAM)
+		di_flags |= XFS_DIFLAG_FILESTREAM;
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		if (xflags & FS_XFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (xflags & FS_XFLAG_NOSYMLINKS)
+			di_flags |= XFS_DIFLAG_NOSYMLINKS;
+		if (xflags & FS_XFLAG_EXTSZINHERIT)
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+		if (xflags & FS_XFLAG_PROJINHERIT)
+			di_flags |= XFS_DIFLAG_PROJINHERIT;
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
+		if (xflags & FS_XFLAG_REALTIME)
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (xflags & FS_XFLAG_EXTSIZE)
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+	}
+
+	return di_flags;
+}
+
+uint64_t
+xfs_flags2diflags2(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	uint64_t		di_flags2 =
+		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
+				   XFS_DIFLAG2_BIGTIME |
+				   XFS_DIFLAG2_NREXT64));
+
+	if (xflags & FS_XFLAG_DAX)
+		di_flags2 |= XFS_DIFLAG2_DAX;
+	if (xflags & FS_XFLAG_COWEXTSIZE)
+		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+
+	return di_flags2;
+}
+
+uint32_t
+xfs_ip2xflags(
+	struct xfs_inode	*ip)
+{
+	uint32_t		flags = 0;
+
+	if (ip->i_diflags & XFS_DIFLAG_ANY) {
+		if (ip->i_diflags & XFS_DIFLAG_REALTIME)
+			flags |= FS_XFLAG_REALTIME;
+		if (ip->i_diflags & XFS_DIFLAG_PREALLOC)
+			flags |= FS_XFLAG_PREALLOC;
+		if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
+			flags |= FS_XFLAG_IMMUTABLE;
+		if (ip->i_diflags & XFS_DIFLAG_APPEND)
+			flags |= FS_XFLAG_APPEND;
+		if (ip->i_diflags & XFS_DIFLAG_SYNC)
+			flags |= FS_XFLAG_SYNC;
+		if (ip->i_diflags & XFS_DIFLAG_NOATIME)
+			flags |= FS_XFLAG_NOATIME;
+		if (ip->i_diflags & XFS_DIFLAG_NODUMP)
+			flags |= FS_XFLAG_NODUMP;
+		if (ip->i_diflags & XFS_DIFLAG_RTINHERIT)
+			flags |= FS_XFLAG_RTINHERIT;
+		if (ip->i_diflags & XFS_DIFLAG_PROJINHERIT)
+			flags |= FS_XFLAG_PROJINHERIT;
+		if (ip->i_diflags & XFS_DIFLAG_NOSYMLINKS)
+			flags |= FS_XFLAG_NOSYMLINKS;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			flags |= FS_XFLAG_EXTSIZE;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT)
+			flags |= FS_XFLAG_EXTSZINHERIT;
+		if (ip->i_diflags & XFS_DIFLAG_NODEFRAG)
+			flags |= FS_XFLAG_NODEFRAG;
+		if (ip->i_diflags & XFS_DIFLAG_FILESTREAM)
+			flags |= FS_XFLAG_FILESTREAM;
+	}
+
+	if (ip->i_diflags2 & XFS_DIFLAG2_ANY) {
+		if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
+			flags |= FS_XFLAG_DAX;
+		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+			flags |= FS_XFLAG_COWEXTSIZE;
+	}
+
+	if (xfs_inode_has_attr_fork(ip))
+		flags |= FS_XFLAG_HASATTR;
+	return flags;
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
new file mode 100644
index 00000000000..6ad1898a0f7
--- /dev/null
+++ b/libxfs/xfs_inode_util.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_INODE_UTIL_H__
+#define	__XFS_INODE_UTIL_H__
+
+uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
+uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
+uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
+uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
+
+#endif /* __XFS_INODE_UTIL_H__ */

