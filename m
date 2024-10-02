Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BBD804
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831350; cv=none; b=RqjSFoSZsVqmtsuncSZFr6ayB0dKBXd09SyVPQgpeSoncurccUrVXgRVx3GARNTRXq++RngWwUIN12FLiB0UdOHsx5GvVCZUBK3Pon2CAjgWxFLur6K3hRAs2KKKPAQyfoQ8GhJLMBhO4oo9OIT0LrRnYuX4R6BTB0dJuzraDI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831350; c=relaxed/simple;
	bh=RLG/m0BxOgU4OZzVo9wDfMzaqvSoto4TKqNWcJeQsxQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o98Y2o35b5nvxWI23FjZrLMP8U4Q2z+j3fdXSd4PTPUU+IhbtjkgjGpLC7NGyRgF4J1eNwXS/MHatDCmQS45uPo8gNfF8o+sMXrjXOUAsNKaBTRGCwSzHq+61zNJNwFR/CQ/WJ+1e/re2sZDZDyBZw6CmilkbZHwEIC5kwzwdb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKlWuzL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKlWuzL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6121BC4CEC6;
	Wed,  2 Oct 2024 01:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831349;
	bh=RLG/m0BxOgU4OZzVo9wDfMzaqvSoto4TKqNWcJeQsxQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AKlWuzL9E5NAO+zPSpl/O2yQEaRQ7zN8ZoN0P02Y60jzHYX5ZSXquPUuR2RswVVh3
	 XIBOHBFmY3k8w/cTO6blqlR8lRdRUaqNyJT3IQJFX1m00clmo5flS5pV5M9B/GXm12
	 mKwuRS59g7985g048jdoxrrXE/sQ2T5z4/uOYo+hNeER12k+oHpzTUsBLqwa9plfST
	 T/MWPvqpcC4Cn9YqaLVQaBLIVvpbyTKdN4tdTBBnTKlZRDYEmXMcO0CQfqTYe8CLul
	 3NTlMFYketxU0xWPv5knX9kQsAxJbUkXlXiaizohh+tzQF+3tx1aXBOGQFcaqK/RES
	 t9BmGHZk5Tu4Q==
Date: Tue, 01 Oct 2024 18:09:08 -0700
Subject: [PATCH 05/64] xfs: hoist inode flag conversion functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783101856.4036371.1608295756911361432.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: b7c477be396948ce88ea591b91070fa68ac12437

Hoist the inode flag conversion functions into libxfs so that we can
keep them in sync.  Do this by creating a new xfs_inode_util.c file in
libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 31d081191..17cf619f0 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -74,6 +74,7 @@ struct iomap;
 #include "xfs_attr_sf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_buf.h"
+#include "xfs_inode_util.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index ec4eada81..17d3da6ae 100644
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
index 833c65092..cc3312b57 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -52,6 +52,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_inode_util.h \
 	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
@@ -105,6 +106,7 @@ CFILES = buf_mem.c \
 	xfs_iext_tree.c \
 	xfs_inode_buf.c \
 	xfs_inode_fork.c \
+	xfs_inode_util.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
 	xfs_parent.c \
diff --git a/libxfs/util.c b/libxfs/util.c
index 373749457..4e96ba5ce 100644
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
index befbe0b07..5f4446104 100644
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
index 000000000..868a77caf
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
index 000000000..6ad1898a0
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

