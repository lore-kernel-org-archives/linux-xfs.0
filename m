Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A01D528
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309647; cv=none; b=I3RQm2ejYEMQvu45vBhUJVh+IPdrNyZpvLMQRFJS7Tz0U9n6+y0lZSxjJceOU2vGR0BGIzq5UALGGP8usF6vFzeKUXydLJDpdRyQeAEPpOEgACHxIF3BIx70vo8qwcicOMQMrpOQh5GzwyQmQGLYIf5Z+NcKIOQkVKxcQJ0GYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309647; c=relaxed/simple;
	bh=07qXOpVr1l6POrMhRNLQMpmHuT/7UHMo7/aWl/H3rMc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvX8TCRe47eAlX/1WrUSvg0pRJM3C4ng6r9IvOrB8TQJkAyprhlMwZfstWzSv8g2/eBEoWG4T/vR+liMbyPDUo0wuiGvdzLQZsYHgqLFYAv9CgD1ll5WzQA7lUJr3S5UiILhBUV0UlJlsFhUNJOXp+yPp7DZjW8+y471Tj2KVFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyIv6SSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyIv6SSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71241C4AF0A;
	Tue, 30 Jul 2024 03:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309646;
	bh=07qXOpVr1l6POrMhRNLQMpmHuT/7UHMo7/aWl/H3rMc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OyIv6SSmjfbJMF7cdFZZct4KNdGDiSzC8Yx70fYmCoBoEW3cAdodxpLaQASwkpuzv
	 ZlA6wnReR0UuWQZCPudeBCH5QLC1kW5VA1ot6T5QEUuwBdYZNy0PeGQxsEvmiHmTGT
	 s55NH12BrzvvTrM1ax93/kbf5dl8HmJHPKDpf6O6AUvpwonhpZw0XwIvRdcz10l4Iv
	 qF2pBuLLQqXrvZ+d6udaZql0YnQU6mbUQehUJF/cDlGo1IM8F2ScbC6Kurpzw35t5P
	 rT78kCYXpkSURhlmmWXbpJRPfEzCQFkgmEwvWa1ok+4t+RX9Row8HdRWmdZI0giiEG
	 r4Yh5f3MybfcQ==
Date: Mon, 29 Jul 2024 20:20:45 -0700
Subject: [PATCH 4/7] libxfs: hoist listxattr from xfs_repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940631.1543753.17382323806715632348.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
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

Hoist the listxattr code from xfs_repair so that we can use it in
xfs_db.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile    |    2 ++
 libxfs/listxattr.c |    2 +-
 libxfs/listxattr.h |    6 +++---
 repair/Makefile    |    2 --
 repair/pptr.c      |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)
 rename repair/listxattr.c => libxfs/listxattr.c (99%)
 rename repair/listxattr.h => libxfs/listxattr.h (81%)


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 4e8f9a135818..2f2791cae587 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -23,6 +23,7 @@ HFILES = \
 	defer_item.h \
 	libxfs_io.h \
 	libxfs_api_defs.h \
+	listxattr.h \
 	init.h \
 	libxfs_priv.h \
 	linux-err.h \
@@ -69,6 +70,7 @@ CFILES = buf_mem.c \
 	defer_item.c \
 	init.c \
 	kmem.c \
+	listxattr.c \
 	logitem.c \
 	rdwr.c \
 	topology.c \
diff --git a/repair/listxattr.c b/libxfs/listxattr.c
similarity index 99%
rename from repair/listxattr.c
rename to libxfs/listxattr.c
index 2af77b7b2195..bedaca678439 100644
--- a/repair/listxattr.c
+++ b/libxfs/listxattr.c
@@ -6,7 +6,7 @@
 #include "libxfs.h"
 #include "libxlog.h"
 #include "libfrog/bitmap.h"
-#include "repair/listxattr.h"
+#include "listxattr.h"
 
 /* Call a function for every entry in a shortform xattr structure. */
 STATIC int
diff --git a/repair/listxattr.h b/libxfs/listxattr.h
similarity index 81%
rename from repair/listxattr.h
rename to libxfs/listxattr.h
index 2d26fce0f323..cddd96af7c0c 100644
--- a/repair/listxattr.h
+++ b/libxfs/listxattr.h
@@ -3,8 +3,8 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#ifndef __REPAIR_LISTXATTR_H__
-#define __REPAIR_LISTXATTR_H__
+#ifndef __LIBXFS_LISTXATTR_H__
+#define __LIBXFS_LISTXATTR_H__
 
 typedef int (*xattr_walk_fn)(struct xfs_inode *ip, unsigned int attr_flags,
 		const unsigned char *name, unsigned int namelen,
@@ -12,4 +12,4 @@ typedef int (*xattr_walk_fn)(struct xfs_inode *ip, unsigned int attr_flags,
 
 int xattr_walk(struct xfs_inode *ip, xattr_walk_fn attr_fn, void *priv);
 
-#endif /* __REPAIR_LISTXATTR_H__ */
+#endif /* __LIBXFS_LISTXATTR_H__ */
diff --git a/repair/Makefile b/repair/Makefile
index e7445d53e918..a36a95e353a5 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -24,7 +24,6 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
-	listxattr.h \
 	pptr.h \
 	prefetch.h \
 	progress.h \
@@ -59,7 +58,6 @@ CFILES = \
 	incore_ext.c \
 	incore_ino.c \
 	init.c \
-	listxattr.c \
 	phase1.c \
 	phase2.c \
 	phase3.c \
diff --git a/repair/pptr.c b/repair/pptr.c
index 8ec6a51d2c3d..cc66e637217f 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -11,7 +11,7 @@
 #include "repair/globals.h"
 #include "repair/err_protos.h"
 #include "repair/slab.h"
-#include "repair/listxattr.h"
+#include "libxfs/listxattr.h"
 #include "repair/threads.h"
 #include "repair/incore.h"
 #include "repair/pptr.h"

