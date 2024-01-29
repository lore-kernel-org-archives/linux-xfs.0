Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40934F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513587; cv=none; b=ouYEkcfHGfXvw9vFg4YpsXgQjnhN7+lxBxDmNRpJHCtxQhCnsidcd8H4zyljItRo8FLxmeD0GTwBw5/7Y/fEUBOn8SxHF33mB5WIYqB86CsSSHdMPShls9P1y0NXy2Oz7AMrMTdvpM2/Q0viP/NuXIn7YffnwcvN/w3A6brPeUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513587; c=relaxed/simple;
	bh=cSPIo88sJYZ0PNw4O4JeQhDHxF7kaiYM3I/ngneMDU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EZ4cvJhwbHZBvJdh60FZTzU/pOVDGVgK0SXKqTr7qYF6XbhAi9n5yreCdgXJXBjUAUqWihJt2vt9OKtdou2YMy4STa65/ck42ERr2MeJ0hO+pH4RH/flRZEiMTXF0Ix1lTc/IT1u7rG3brkh0f8TcNRg0BqIco9ueMNVXBOtj9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e3zR3WnH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e3zR3WnH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gKQkL/N5lqp93b25OSARzpcx+SzhYWD0bz6vN1LGFPc=; b=e3zR3WnHNxEyCK6zWGgf/7NsZd
	wleNR/IQf4/3VFnY3MJXRx9yW+E1p4NBp2nbmUVomSHiD3bBLN+5tY0qRUre/nzF4QzyX5f4zXLlE
	D/cUCi4DvJAKts/H6U8vA3vBJqIPKSdLKJ6ZRenrDB+c1HQFNuhZgCJF8apbcWglggZlr/NUdGX6Q
	gNVJClXxi8rKKfZxPiBuyUsrTUGly+7oopwN68umKz+afFElVgfCrl7U3xWdY20hyOIgfW1H27B+q
	E572DjP4NDxwfnXmeFG7nohJr2V2kTt4xb1/Y8hGFhkC6CpUXimG3UOBEppvNw/Twg/4f096n0OSj
	kn1+6qcw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8f-0000000BcjV-0oy1;
	Mon, 29 Jan 2024 07:33:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 18/27] configure: don't check for syncfs
Date: Mon, 29 Jan 2024 08:32:06 +0100
Message-Id: <20240129073215.108519-19-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

syncfs has been supported since Linux 2.6.39.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  4 ----
 io/sync.c             |  4 ----
 m4/package_libcdev.m4 | 18 ------------------
 scrub/Makefile        |  4 ----
 scrub/common.h        |  8 --------
 7 files changed, 40 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8c903ea2d..3a131982f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -165,7 +165,6 @@ AC_PACKAGE_NEED_RCU_INIT
 AC_HAVE_PWRITEV2
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
-AC_HAVE_SYNCFS
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
diff --git a/include/builddefs.in b/include/builddefs.in
index 64468f486..cb63751fd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -93,7 +93,6 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
-HAVE_SYNCFS = @have_syncfs@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
diff --git a/io/Makefile b/io/Makefile
index eb6ad0574..acef8957d 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -25,10 +25,6 @@ CFILES += copy_file_range.c
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
 endif
 
-ifeq ($(HAVE_SYNCFS),yes)
-LCFLAGS += -DHAVE_SYNCFS
-endif
-
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
diff --git a/io/sync.c b/io/sync.c
index 89f787ecd..f3b900d86 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -21,7 +21,6 @@ sync_f(
 	return 0;
 }
 
-#ifdef HAVE_SYNCFS
 static cmdinfo_t syncfs_cmd;
 
 static int
@@ -35,7 +34,6 @@ syncfs_f(
 	}
 	return 0;
 }
-#endif
 
 void
 sync_init(void)
@@ -49,7 +47,6 @@ sync_init(void)
 
 	add_command(&sync_cmd);
 
-#ifdef HAVE_SYNCFS
 	syncfs_cmd.name = "syncfs";
 	syncfs_cmd.cfunc = syncfs_f;
 	syncfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
@@ -57,5 +54,4 @@ sync_init(void)
 		_("calls syncfs(2) to flush all in-core filesystem state to disk");
 
 	add_command(&syncfs_cmd);
-#endif
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 758b9378c..37d11e338 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -54,24 +54,6 @@ syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
     AC_SUBST(have_copy_file_range)
   ])
 
-#
-# Check if we have a syncfs libc call (Linux)
-#
-AC_DEFUN([AC_HAVE_SYNCFS],
-  [ AC_MSG_CHECKING([for syncfs])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <unistd.h>
-	]], [[
-syncfs(0);
-	]])
-    ], have_syncfs=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_syncfs)
-  ])
-
 #
 # Check if we have a fsetxattr call
 #
diff --git a/scrub/Makefile b/scrub/Makefile
index 4368897f2..f3e22a9d6 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -89,10 +89,6 @@ ifeq ($(HAVE_MALLINFO2),yes)
 LCFLAGS += -DHAVE_MALLINFO2
 endif
 
-ifeq ($(HAVE_SYNCFS),yes)
-LCFLAGS += -DHAVE_SYNCFS
-endif
-
 ifeq ($(HAVE_LIBATTR),yes)
 LCFLAGS += -DHAVE_LIBATTR
 endif
diff --git a/scrub/common.h b/scrub/common.h
index 865c1caa4..764639c06 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -74,14 +74,6 @@ double auto_units(unsigned long long number, char **units, int *precision);
 unsigned int scrub_nproc(struct scrub_ctx *ctx);
 unsigned int scrub_nproc_workqueue(struct scrub_ctx *ctx);
 
-#ifndef HAVE_SYNCFS
-static inline int syncfs(int fd)
-{
-	sync();
-	return 0;
-}
-#endif
-
 void background_sleep(void);
 char *string_escape(const char *in);
 
-- 
2.39.2

