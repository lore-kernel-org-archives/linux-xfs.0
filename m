Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D77EC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjBPVEO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjBPVEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:04:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CF5505D3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F057460C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF08C433D2;
        Thu, 16 Feb 2023 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581451;
        bh=Yk7tXYVf86isRM7zlOUZZLrhWjaowRzxvfQxZCH0EQY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iFkRDMHiWcfMXywq/vE2Gor3lMRRbRe3t5zRdz1e4h3PO8/GxLUW/UgvpvWZpnfJ4
         Wyh09EyXG9rgndt4Jg4fxMGB6tXuPZZ8COeffhjeC6XHjdT6wu18agFXs6yWkpkZkv
         ToFS0L9Wt6DAY+dWVrJNAi0PkP5N9euVCQdRBYK9VOmdxxrgI0O0R4gHtBDdggUq35
         sqNua8jVxDrNN8CxtuY4FZmzoYoD+gDZx8dVUIGuC+PbJ3jS+dyIXlTaJGh0a5RIP9
         djn8g6O1uRA7nhvxL1IjRDA/d0FOS6NcDGpC1wwkUWuMbqaAkKkbzkWqHawaXdTok8
         z3Y+dhgA//7iA==
Date:   Thu, 16 Feb 2023 13:04:10 -0800
Subject: [PATCH 04/10] libfrog: remove all the parent pointer code from
 libhandle
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880311.3477097.14103004780435007800.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move this code out of libhandle and into libfrog.  We don't want to
expose this stuff to a userspace library until customers actually demand
it.  While we're here, fix the copyright statements and licensing tags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/parent.h   |   18 ------------------
 io/parent.c        |    1 +
 libfrog/Makefile   |    2 ++
 libfrog/pptrs.c    |   22 ++++------------------
 libfrog/pptrs.h    |   27 +++++++++++++++++++++++++++
 libhandle/Makefile |    2 +-
 6 files changed, 35 insertions(+), 37 deletions(-)
 rename libhandle/parent.c => libfrog/pptrs.c (87%)
 create mode 100644 libfrog/pptrs.h


diff --git a/include/parent.h b/include/parent.h
index fb900041..4d3ad51b 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -17,22 +17,4 @@ typedef struct parent_cursor {
 	__u32	opaque[4];      /* an opaque cookie */
 } parent_cursor_t;
 
-struct path_list;
-
-typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
-		void *arg);
-typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
-		void *arg);
-
-#define WALK_PPTRS_ABORT	1
-int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
-int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
-
-#define WALK_PPATHS_ABORT	1
-int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
-int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
-
-int fd_to_path(int fd, char *path, size_t pathlen);
-int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
-
 #endif
diff --git a/io/parent.c b/io/parent.c
index 66bb0fae..ceb62a43 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "libfrog/paths.h"
 #include "parent.h"
+#include "libfrog/pptrs.h"
 #include "handle.h"
 #include "init.h"
 #include "io.h"
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 01107082..5622ab9b 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -23,6 +23,7 @@ list_sort.c \
 linux.c \
 logging.c \
 paths.c \
+pptrs.c \
 projects.c \
 ptvar.c \
 radix-tree.c \
@@ -42,6 +43,7 @@ crc32table.h \
 fsgeom.h \
 logging.h \
 paths.h \
+pptrs.h \
 projects.h \
 ptvar.h \
 radix-tree.h \
diff --git a/libhandle/parent.c b/libfrog/pptrs.c
similarity index 87%
rename from libhandle/parent.c
rename to libfrog/pptrs.c
index c10a55ac..66a34246 100644
--- a/libhandle/parent.c
+++ b/libfrog/pptrs.c
@@ -1,21 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2017 Oracle.  All Rights Reserved.
- *
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "platform_defs.h"
 #include "xfs.h"
@@ -23,7 +9,7 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "handle.h"
-#include "parent.h"
+#include "libfrog/pptrs.h"
 
 /* Allocate a buffer large enough for some parent pointer records. */
 static inline struct xfs_pptr_info *
diff --git a/libfrog/pptrs.h b/libfrog/pptrs.h
new file mode 100644
index 00000000..d174aa2a
--- /dev/null
+++ b/libfrog/pptrs.h
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_PPTRS_H_
+#define	__LIBFROG_PPTRS_H_
+
+struct path_list;
+
+typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
+		void *arg);
+typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
+		void *arg);
+
+#define WALK_PPTRS_ABORT	1
+int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
+int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
+
+#define WALK_PPATHS_ABORT	1
+int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
+int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
+
+int fd_to_path(int fd, char *path, size_t pathlen);
+int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
+
+#endif /* __LIBFROG_PPTRS_H_ */
diff --git a/libhandle/Makefile b/libhandle/Makefile
index cf7df67c..f297a59e 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -12,7 +12,7 @@ LT_AGE = 0
 
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
 
-CFILES = handle.c jdm.c parent.c
+CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
 
 default: ltdepend $(LTLIBRARY)

