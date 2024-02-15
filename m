Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A5A9475
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980115; cv=none; b=Q9TDr8S6QhSIzQO8YwD9ZZb4/OCaOi75rWYTYWMZh/3lN8KTut9q663KGCCpHXdyUmfCY8zhSQyJQoEF3rMyRhQTVObUhbKfQVq5nMlKaskzAJqYbFujBuh1RMTA0JrBFvnMPYDFPce6118jUR7omTNR599EsMEYOBDwfmSbSLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980115; c=relaxed/simple;
	bh=o1yvxrt/MoQrU3eJFSgisqlX+oNFd/AG9qWhXlAGeRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qBrH7TaYdI2DuEsFOu8pr7bJ/y3kJUthGnJFyXrJZz8UDOjhASpQEjixcN4x1z7uWVRnaOA56WRVv/semi3EzR6lZKbMSvIjWq6098mwtSFD4P2xB9mgSwwA0hUlJe86aPjnjOuM9AftwP4VDaAvGQgZlet5xYVfIjOQMDIQPtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pvuGKLPP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pvuGKLPP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QSoGrm3ZJT1BmegYuVMilghQHm1SWFSq5/YQdQDMLbE=; b=pvuGKLPPF0a5Y5/sAuq/vunOsn
	VOkzg18qHQ4RwPXZgfLGUDbtoMcMKERvMgyk+OqP9qvKv4qoeL65HjZwpVZubud/Kll8kUjSekav7
	ba4CWOhI+BCpAq6aYgowlnbrutFfJAYUcPbhvmdvRnDjniLmYfAaI3U6ABfiKBzNBe3leCG2Y+ISA
	OyTT6Srzwczh+89XRO+xlAxx/jzxvR/jMc64sOryFR+mknQkinc4tDfaEeyxQZFHgwE5CddiEGBE1
	JYysOKykA6F22YZ3iBdx/gCe/ALU/FB+SWpRaHjyjujt72Mdw6fqJ+7hKvHXhGQLILVtMU+V38AWB
	GhIEN9hQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeL-0000000F9KH-3E4M;
	Thu, 15 Feb 2024 06:55:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 17/26] configure: don't check for fallocate
Date: Thu, 15 Feb 2024 07:54:15 +0100
Message-Id: <20240215065424.2193735-18-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fallocate has been supported since Linux 2.6.23 and glibc 2.10.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  4 ----
 include/linux.h       |  2 --
 io/Makefile           |  4 ----
 io/prealloc.c         |  8 --------
 m4/package_libcdev.m4 | 19 -------------------
 6 files changed, 38 deletions(-)

diff --git a/configure.ac b/configure.ac
index 79fb475f7..b915733bf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -162,7 +162,6 @@ AC_PACKAGE_NEED_PTHREADMUTEXINIT
 AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
-AC_HAVE_FALLOCATE
 AC_HAVE_PWRITEV2
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
diff --git a/include/builddefs.in b/include/builddefs.in
index 47ac7173c..64468f486 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -90,7 +90,6 @@ ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-HAVE_FALLOCATE = @have_fallocate@
 HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
@@ -144,9 +143,6 @@ endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
-ifeq ($(HAVE_FALLOCATE),yes)
-PCFLAGS += -DHAVE_FALLOCATE
-endif
 
 LIBICU_LIBS = @libicu_LIBS@
 LIBICU_CFLAGS = @libicu_CFLAGS@
diff --git a/include/linux.h b/include/linux.h
index eddc4ad9c..95a0deee2 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -27,9 +27,7 @@
 #include <asm/types.h>
 #include <mntent.h>
 #include <fcntl.h>
-#if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
-#endif
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # define fsxattr sys_fsxattr
 #endif
diff --git a/io/Makefile b/io/Makefile
index 837716238..eb6ad0574 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -33,10 +33,6 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
-ifeq ($(HAVE_FALLOCATE),yes)
-LCFLAGS += -DHAVE_FALLOCATE
-endif
-
 # Also implies PWRITEV
 ifeq ($(HAVE_PREADV),yes)
 LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
diff --git a/io/prealloc.c b/io/prealloc.c
index 5805897a4..8e968c9f2 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -4,9 +4,7 @@
  * All Rights Reserved.
  */
 
-#if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
-#endif
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -37,14 +35,12 @@ static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
 static cmdinfo_t unresvsp_cmd;
 static cmdinfo_t zero_cmd;
-#if defined(HAVE_FALLOCATE)
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
 static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 static cmdinfo_t funshare_cmd;
-#endif
 
 static int
 offset_length(
@@ -182,7 +178,6 @@ zero_f(
 }
 
 
-#if defined (HAVE_FALLOCATE)
 static void
 falloc_help(void)
 {
@@ -381,7 +376,6 @@ funshare_f(
 	}
 	return 0;
 }
-#endif	/* HAVE_FALLOCATE */
 
 void
 prealloc_init(void)
@@ -435,7 +429,6 @@ prealloc_init(void)
 	add_command(&unresvsp_cmd);
 	add_command(&zero_cmd);
 
-#if defined (HAVE_FALLOCATE)
 	falloc_cmd.name = "falloc";
 	falloc_cmd.cfunc = fallocate_f;
 	falloc_cmd.argmin = 2;
@@ -496,5 +489,4 @@ prealloc_init(void)
 	funshare_cmd.oneline =
 	_("unshares shared blocks within the range");
 	add_command(&funshare_cmd);
-#endif	/* HAVE_FALLOCATE */
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 17319bb23..758b9378c 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,22 +1,3 @@
-#
-# Check if we have a fallocate libc call (Linux)
-#
-AC_DEFUN([AC_HAVE_FALLOCATE],
-  [ AC_MSG_CHECKING([for fallocate])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <fcntl.h>
-#include <linux/falloc.h>
-	]], [[
-fallocate(0, 0, 0, 0);
-	]])
-    ], have_fallocate=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_fallocate)
-  ])
-
 #
 # Check if we have a preadv libc call (Linux)
 #
-- 
2.39.2

