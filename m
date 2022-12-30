Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CEDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiLaBF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:05:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A7F64E5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E445061D33
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEC6C433D2;
        Sat, 31 Dec 2022 01:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448755;
        bh=Mg/5ahLDD7yE2ihNwf7IYfDSC+XL9Ed3+mItZ0Qvdws=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MhDiswVF2LdVB50bSASnCUuKbUt2cZJGnZlS/EpF0l/Am3EPwfOfN/s+x37C/v+YU
         Id/jINbNRqW7aPIDScFychzGlCx01SJO+pC00Zxw4Vpmtw6vGyd3507AGJU0ilIxTJ
         hFY7sbHa0eLv0ntdqmEhsz5uMTAihZ3ry/bo18MZB9+NjCIxqn07jtFoIPE6eCf5oy
         uuK6lDfp7ZFUIxFO6W9rsDdyVzmBaCj4GuYl8Eg1OxkP9i3MT88lG1RosMimTptwak
         U5Zjfj4eO14ICH/v86MZDDAg7AbY+RYGLFrzqW/j+WeHXUN0sX0O5Ra98ExVGOlt8J
         SuCL6DDidtpUg==
Subject: [PATCH 03/20] xfs: hoist inode flag conversion functions to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:18 -0800
Message-ID: <167243863874.707335.4877917404492106021.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
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
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_bmap.c       |    1 
 fs/xfs/libxfs/xfs_inode_util.c |  124 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   14 +++++
 fs/xfs/xfs_inode.c             |   49 ----------------
 fs/xfs/xfs_inode.h             |    2 -
 fs/xfs/xfs_ioctl.c             |   60 -------------------
 7 files changed, 141 insertions(+), 110 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 33b1ea3e6e6b..dac4165b02c0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -39,6 +39,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_iext_tree.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
+				   xfs_inode_util.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5224e3fcce83..a372618ce393 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -38,6 +38,7 @@
 #include "xfs_iomap.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_inode_util.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
new file mode 100644
index 000000000000..ed5e1a9b4b8c
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
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
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
new file mode 100644
index 000000000000..6ad1898a0f73
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_inode_util.h
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4a3ca9a3ea6..cd1d742a8a81 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -544,55 +544,6 @@ xfs_lock_two_inodes(
 	}
 }
 
-uint
-xfs_ip2xflags(
-	struct xfs_inode	*ip)
-{
-	uint			flags = 0;
-
-	if (ip->i_diflags & XFS_DIFLAG_ANY) {
-		if (ip->i_diflags & XFS_DIFLAG_REALTIME)
-			flags |= FS_XFLAG_REALTIME;
-		if (ip->i_diflags & XFS_DIFLAG_PREALLOC)
-			flags |= FS_XFLAG_PREALLOC;
-		if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
-			flags |= FS_XFLAG_IMMUTABLE;
-		if (ip->i_diflags & XFS_DIFLAG_APPEND)
-			flags |= FS_XFLAG_APPEND;
-		if (ip->i_diflags & XFS_DIFLAG_SYNC)
-			flags |= FS_XFLAG_SYNC;
-		if (ip->i_diflags & XFS_DIFLAG_NOATIME)
-			flags |= FS_XFLAG_NOATIME;
-		if (ip->i_diflags & XFS_DIFLAG_NODUMP)
-			flags |= FS_XFLAG_NODUMP;
-		if (ip->i_diflags & XFS_DIFLAG_RTINHERIT)
-			flags |= FS_XFLAG_RTINHERIT;
-		if (ip->i_diflags & XFS_DIFLAG_PROJINHERIT)
-			flags |= FS_XFLAG_PROJINHERIT;
-		if (ip->i_diflags & XFS_DIFLAG_NOSYMLINKS)
-			flags |= FS_XFLAG_NOSYMLINKS;
-		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
-			flags |= FS_XFLAG_EXTSIZE;
-		if (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT)
-			flags |= FS_XFLAG_EXTSZINHERIT;
-		if (ip->i_diflags & XFS_DIFLAG_NODEFRAG)
-			flags |= FS_XFLAG_NODEFRAG;
-		if (ip->i_diflags & XFS_DIFLAG_FILESTREAM)
-			flags |= FS_XFLAG_FILESTREAM;
-	}
-
-	if (ip->i_diflags2 & XFS_DIFLAG2_ANY) {
-		if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-			flags |= FS_XFLAG_DAX;
-		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
-			flags |= FS_XFLAG_COWEXTSIZE;
-	}
-
-	if (xfs_inode_has_attr_fork(ip))
-		flags |= FS_XFLAG_HASATTR;
-	return flags;
-}
-
 /*
  * Lookups up an inode from "name". If ci_name is not NULL, then a CI match
  * is allowed, otherwise it has to be an exact match. If a CI match is found,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index adcdc369396a..2f6072d78444 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -8,6 +8,7 @@
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_inode_util.h"
 
 /*
  * Kernel only inode definitions
@@ -518,7 +519,6 @@ bool		xfs_isilocked(struct xfs_inode *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-uint		xfs_ip2xflags(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index df6601eda7ec..615fd1e4a611 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1055,66 +1055,6 @@ xfs_fileattr_get(
 	return 0;
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
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,

