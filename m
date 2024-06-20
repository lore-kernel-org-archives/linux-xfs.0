Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A164F143737
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924367; cv=none; b=HmPO98wlATntzR/6+SREQE/4KaznOBV7Oa4E56nJnOi/GtGQgiJJtvTL36o0Zn+u+ey1db5rBGTdXzsOxXr2+/07ED1DmIlzsGO8Hetlj7TmxxJiM8TMw//1mD1Bl/kM05xYUtf0WtcMAfWNf9WsvXiHbZEKAHLTUOIhHsBK+lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924367; c=relaxed/simple;
	bh=IrGqgBJQAh+0QAqtfo4dWXx2H6pm9hXvjbI9LVPQhGs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCZmNkFtV8Edk5AJFsGfndWqzmqacKWFuw19AryvtePUyXgoaioX6A+fuN9nqldyVlXfE7y4Af7BRDNEQL6hXoRLl3yuKO93yxDZu/2fVtOhXErhAplxYsiBG70gvAWCk5bu/W5RRwVwrC160eEhs+4PEXMbLhj4A5p3ypc+8oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWpqrN6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWpqrN6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B15C2BD10;
	Thu, 20 Jun 2024 22:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924367;
	bh=IrGqgBJQAh+0QAqtfo4dWXx2H6pm9hXvjbI9LVPQhGs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bWpqrN6I03/710PH7CpXnA0XW6zmJ7cRoqnuRjjV3G64mbPK2FGQTnkvTbB6Nnd44
	 jQyW/1DU7r9J/FnXbrO/jJX3lIVl2puxnop3qwnjZYdNu1H2HRFoyCBfEhgqJq36zU
	 MilZC0sJUIu7PBk3R0sdjMAFWOs8+PA/GVRYFIwthqfLUEewsNsmNam+GuLlaBMjZQ
	 hyNToW9Be1CUUmuWV/LbZq7TiW2XB1a8tqDCSS9s97jq3mMei/5/ZqUViH3REEpDRy
	 3aiQHpGAXENIPmHTgPGsvB9oX9PVF2SqQP70T6MGV9C5aRMxi5UDYFFbuSt3yyWTAi
	 yhuxzxbIbNU8A==
Date: Thu, 20 Jun 2024 15:59:26 -0700
Subject: [PATCH 04/24] xfs: hoist inode flag conversion functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417963.3183075.6780097546790838079.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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
index c50447548d655..dd692619bed58 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_iext_tree.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
+				   xfs_inode_util.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
 				   xfs_parent.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f889123126d22..09e3302a4b72f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -39,6 +39,7 @@
 #include "xfs_health.h"
 #include "xfs_bmap_item.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_inode_util.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
new file mode 100644
index 0000000000000..ed5e1a9b4b8c6
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
index 0000000000000..6ad1898a0f73f
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
index a00072adcb679..e98b636731417 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -523,55 +523,6 @@ xfs_lock_two_inodes(
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
index 0e642afa77a7c..b20768962e8d6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -8,6 +8,7 @@
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_inode_util.h"
 
 /*
  * Kernel only inode definitions
@@ -549,7 +550,6 @@ void		xfs_assert_ilocked(struct xfs_inode *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-uint		xfs_ip2xflags(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f0117188f3021..4e933db75b12b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -469,66 +469,6 @@ xfs_fileattr_get(
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

