Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395294F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513558; cv=none; b=Xu+ywFKddkGwlue4dT0cwycD6RQUnjNbuxOQB/XxJHxUo6Y4ySofCVzm/WO7Y+vbI2KmE1ctE3n9KsI7ISHgJDsuzkCZ57utk/4iuLyMMqOvIC2ql8hoBW0OpJf6J7QZpTF5CxO5ztC3XLCc2elk+yDtAKiI19ojCuCx98PqEuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513558; c=relaxed/simple;
	bh=pMW1SU7W+ybJY9uMlf4ivijjTYikuTfZABsrZlUzH9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dwJGZULfbx3Nf4fR1i6QV1OwO4wKZE/DG4dvuiPh5gqZXKoO+3Nq914rYfVHRjFqFFCfEFPylYkeVTHryHCD/e5tfNYMhZx+CYv4ZTvdyD6OPkTJCNJ83Rrqyv223NeHfuo3cgXcuXiCBmI7b0PerEXZBqTqpopPvyZpq6aKQ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wIu66YT0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wIu66YT0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gR42YleYkTmdb8294bENLtGlDB5QaFkhZPzGITR5Z90=; b=wIu66YT0UV6T3CtqZCOf3d5fA9
	6ZQBZOgC5+zXNxbyqGbeVlpkbYCVke2mBNoNpXJwLAObU8c8Rws59WCJMbmp+LaWcmDzwYffPzOC5
	C7smRW64xSHrL5Ssy/4xdGmJep0WyvOC2aCDapggubgjtSBwHvaTXQgEC+uqk+tOViJGsVx85+eVj
	uDPZnGfpM00fLQfwihdwn4zDatrAxUuyoHBmlLKItp7MrWLnBL9MOMxkU1lUDB7t7FFBXzFVG9K1O
	K+rcwQQvo6Dc5bbJEsBWguAwS3vsf0om/aq3/oek1ucmHbJSjijYL8GZvUY28rzRHSObRKUVATAO8
	SebOozEQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8C-0000000Bcco-1qeH;
	Mon, 29 Jan 2024 07:32:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/27] configure: don't check for getmntent
Date: Mon, 29 Jan 2024 08:31:55 +0100
Message-Id: <20240129073215.108519-8-hch@lst.de>
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

getmntent always exists on Linux (and always has), so don't bother
checking for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  2 --
 fsr/Makefile          |  4 ----
 include/builddefs.in  |  2 --
 libfrog/Makefile      |  4 ----
 libfrog/paths.c       |  9 +--------
 m4/package_libcdev.m4 | 27 ---------------------------
 6 files changed, 1 insertion(+), 47 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3e40931b1..58048945c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -171,7 +171,6 @@ AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
 AC_HAVE_SENDFILE
-AC_HAVE_GETMNTENT
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PWRITEV2
@@ -179,7 +178,6 @@ AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_SYNCFS
-AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
diff --git a/fsr/Makefile b/fsr/Makefile
index 86486fc9c..d57f2de24 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -11,10 +11,6 @@ LLDLIBS = $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBBLKID)
 LTDEPENDENCIES = $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
-ifeq ($(HAVE_GETMNTENT),yes)
-LCFLAGS += -DHAVE_GETMNTENT
-endif
-
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/include/builddefs.in b/include/builddefs.in
index 6e7eaface..b5bfbb1f2 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -95,7 +95,6 @@ HAVE_FADVISE = @have_fadvise@
 HAVE_MADVISE = @have_madvise@
 HAVE_MINCORE = @have_mincore@
 HAVE_SENDFILE = @have_sendfile@
-HAVE_GETMNTENT = @have_getmntent@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
@@ -104,7 +103,6 @@ HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_SYNCFS = @have_syncfs@
 HAVE_READDIR = @have_readdir@
-HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
diff --git a/libfrog/Makefile b/libfrog/Makefile
index dcfd1fb8a..cafee073f 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -54,10 +54,6 @@ workqueue.h
 
 LSRCFILES += gen_crc32table.c
 
-ifeq ($(HAVE_GETMNTENT),yes)
-LCFLAGS += -DHAVE_GETMNTENT
-endif
-
 LDIRT = gen_crc32table crc32table.h
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libfrog/paths.c b/libfrog/paths.c
index d8c42163a..320b26dbf 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -15,6 +15,7 @@
 #include "paths.h"
 #include "input.h"
 #include "projects.h"
+#include <mntent.h>
 #include <limits.h>
 
 extern char *progname;
@@ -295,10 +296,6 @@ fs_cursor_next_entry(
 	return NULL;
 }
 
-
-#if defined(HAVE_GETMNTENT)
-#include <mntent.h>
-
 /*
  * Determines whether the "logdev" or "rtdev" mount options are
  * present for the given mount point.  If so, the value for each (a
@@ -417,10 +414,6 @@ fs_table_initialise_mounts(
 	return error;
 }
 
-#else
-# error "How do I extract info about mounted filesystems on this platform?"
-#endif
-
 /*
  * Given a directory, match it up to a filesystem mount point.
  */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 174070651..5d947a024 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -70,24 +70,6 @@ sendfile(0, 0, 0, 0);
     AC_SUBST(have_sendfile)
   ])
 
-#
-# Check if we have a getmntent libc call (Linux)
-#
-AC_DEFUN([AC_HAVE_GETMNTENT],
-  [ AC_MSG_CHECKING([for getmntent ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <stdio.h>
-#include <mntent.h>
-	]], [[
-getmntent(0);
-	]])
-    ], have_getmntent=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_getmntent)
-  ])
-
 #
 # Check if we have a fallocate libc call (Linux)
 #
@@ -262,15 +244,6 @@ AC_DEFUN([AC_HAVE_FSETXATTR],
     AC_SUBST(have_fsetxattr)
   ])
 
-#
-# Check if there is mntent.h
-#
-AC_DEFUN([AC_HAVE_MNTENT],
-  [ AC_CHECK_HEADERS(mntent.h,
-    have_mntent=yes)
-    AC_SUBST(have_mntent)
-  ])
-
 #
 # Check if we have a mremap call (not on Mac OS X)
 #
-- 
2.39.2

