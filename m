Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E15C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+OPUOYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF9CC433C7;
	Sun, 31 Dec 2023 23:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064969;
	bh=xGkk0ERYZgv/0y8TDi5zE1vmAAoQ0VVENKLv5bY0FnE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a+OPUOYlveMlyJWE0w0rpIZd1REXchtfWLX+iGxmI21pMzVS6sJvNh7TW3N5583Hx
	 2H+JrElf+Ioj/C3z2vjFAxCwcBmhoQogHOyM29K/dOmmNr2WxBVZ20eX7Ar++N8I7Q
	 XMWtIJYqCg6WmAJG83wtbS9xfo6ezYuSCgdS/MC3V4l7zt0ew8bv4ULVNoAKErFnys
	 rtQn9U2+Aa6GlRT5mABcQkXTDVm3MMKlKTGW/IZOiOAOhEEjUjSO5oTnrmjN25a+YP
	 i//8Yh+VYogifw0Zo9zoW2VfqpuvI7SUgSDpsUXejnqejocRKTS3mv7I56IFqQlIEd
	 Y+cd/AR7NuWXw==
Date: Sun, 31 Dec 2023 15:22:49 -0800
Subject: [PATCH 02/28] xfs: hoist inode flag conversion functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009205.1808635.13130025267603355658.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index 425112b0693..0d60b9f9f51 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -73,6 +73,7 @@ struct iomap;
 #include "xfs_attr_sf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_buf.h"
+#include "xfs_inode_util.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 42db70f8144..d75269cb414 100644
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
index 42dce62ecf9..bb6c2d5616c 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -51,6 +51,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_inode_util.h \
 	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
@@ -102,6 +103,7 @@ CFILES = cache.c \
 	xfs_iext_tree.c \
 	xfs_inode_buf.c \
 	xfs_inode_fork.c \
+	xfs_inode_util.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
 	xfs_parent.c \
diff --git a/libxfs/util.c b/libxfs/util.c
index 5106a6433da..dedf6c2a7b7 100644
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
index 15553659612..ed50bb90e6a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -33,6 +33,7 @@
 #include "xfs_health.h"
 #include "defer_item.h"
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

