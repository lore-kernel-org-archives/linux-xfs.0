Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1633C485;
	Tue,  6 Aug 2024 18:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968422; cv=none; b=N4N1MwTVYUyqjm3lk0OeKZs5LZpDYiQgZE+sJgu6P3wj3X7vHiKJdsWz1KjMU8xptN/nmTTshSvB9qbNImYsWMmOZ8E/NSW5P/TSWK+MCWkyaOKnn+N/nPuVxnz7NX2Qk9n3zb4FPC97TXobWrIezs3HSXPBGAob+cdy3x7gazI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968422; c=relaxed/simple;
	bh=mE+EIDBUYsfgcYfsD1baFR1mHMySHYjIAjXzSx1LeM0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=At1CsVr4LnW3GOxMq09TRgsUfLz7NusPKggIgdGvoAxFUQvJeHC41GGkuWn08t11MKKiA8eaSWA88+4zA3ttnUxxPHe9vLd3ukcoaijnEu3XD7i0OMHvZpEXtbGRMKnCJLAdNN80bn/F1hNbSKO5agPEEDEmz8MJH9EYmHsQjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOp7vQZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOp7vQZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C29C32786;
	Tue,  6 Aug 2024 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968422;
	bh=mE+EIDBUYsfgcYfsD1baFR1mHMySHYjIAjXzSx1LeM0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZOp7vQZiRl0jN1xZNiijHSgCqVfQdzmhFV2El1O2bXVVKOFmXY3+YpIqg5EB65NyJ
	 tTPD0D/Sa+HlxlAA+CPaeoCepqVczP7GfbjPKJDjc3BPNrxPWu3umlROdD81WPsHVq
	 163QecoMb+TsCSAtFLVL9aCPhwS2D1VASjHi+zWqU4SHjaHqwRoZpEHvWPTij85Hbp
	 UBhtN+VEcvFUf4H6/iH3S55l9ACXzpQbq3bnljfatnJFPDR5WRmR6elbeMYYYmkYSU
	 If4Dwoo/FDNBNvqTKAFo1f1o6yicopSg7JtFvqdvEE7RQq5vcUQsaeI5URiDk5+Dci
	 oCb7cjaaMV2lA==
Date: Tue, 06 Aug 2024 11:20:21 -0700
Subject: [PATCH 4/7] libxfs: hoist listxattr from xfs_repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825249.3193059.10081892807300202489.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dave Chinner <dchinner@redhat.com>
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
index 4e8f9a135..2f2791cae 100644
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
index 2af77b7b2..bedaca678 100644
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
index 2d26fce0f..cddd96af7 100644
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
index e7445d53e..a36a95e35 100644
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
index 8ec6a51d2..cc66e6372 100644
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

