Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E09C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCPT3X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPT3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:29:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FECC3B0F5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 69729CE1E5A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CADC433EF;
        Thu, 16 Mar 2023 19:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994957;
        bh=x5WDhtF1UJx98WwrvTZDyBfJSxWWBTWL9jr4KIqVFHE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DKUZJmyYJpVz35LB0Ppir/xtXOLx+MOgXrrasmgy62SgdkN7G9LUD4XKP7n1RsxpL
         Patn4LQNXjNXJVonMXD+73FW3ZsCiC7Mr07QErJviZjQJteL2RcyehBfmLqqs6gw0H
         GQ81DLZXeCsiW6XbRdaORfkFeFSfenGFWxF4nuPiLe7kCxfYHQOzSfhTHESOmpodmR
         oQ5kOBmmIaV+hlkMZr/f4fZy0D3/xdwMTqH9WEAM/YM6ogKyHpefrZnFHkb3WSXc5K
         p6/Y6Kma0JSBXYVrqtMw51Z/qH5hKcRd6Dm35MME80yQn6F1DLN8BIBfFnbuvj9xP3
         DnQdgNyAsCc5g==
Date:   Thu, 16 Mar 2023 12:29:17 -0700
Subject: [PATCH 2/7] libfrog: remove all the parent pointer code from
 libhandle
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416096.16628.7558790734995602619.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
References: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
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
index fb9000419..4d3ad51b4 100644
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
index 8c822cdeb..f5ebb40e4 100644
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
index 011070823..5622ab9b0 100644
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
index b511f5b64..96de47b89 100644
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
+ * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
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
index 000000000..d174aa2a5
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
index cf7df67c8..f297a59e4 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -12,7 +12,7 @@ LT_AGE = 0
 
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
 
-CFILES = handle.c jdm.c parent.c
+CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
 
 default: ltdepend $(LTLIBRARY)

