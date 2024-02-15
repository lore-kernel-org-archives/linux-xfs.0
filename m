Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D230DBA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980090; cv=none; b=jcSp0AXTDwjS+NCR2izKn4YPfPIPgD4zjgUSlTio4o81TpA58lvCPSKiv7gOZXYPPy4tMTTi/UB+K9ggdQEA2dQiv17VCV9s06PctFBZTPe8mDL3btVzzyFMmN/X2G5vtIoN5pjhOnUPodNSTOzsF+Q7Ndf8c0WqT8/ASzcqLYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980090; c=relaxed/simple;
	bh=Sxw5Qs0I1S0ajWosT54Vpc6niCAwoU3PbRBkGaHUvg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IZxrd9F5U7RCDgGYXMTSqNvwMTX7YIIOpKZoVdhszSw3DjwNTLaieG3QQ6CSxdLXti8qMNeuc+4DuctFIFHXr5DEUNYjbjbYHVZYG1TPQUaISlmGgFD/KhzuxzFpAH9JobHb/hTeDIIIMojA2Rm0g9wk7dN7VCsTd3bLZmE77zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hRvmTeOw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hRvmTeOw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ViUtR3KFQn3stVj0bcJxE5viMl0fLFQf1g+BZcjgqC0=; b=hRvmTeOwpmdyQnZbgupG99MJB3
	YUp9OJ+O7usF4VIgBK5rvpFKUApIZZAOd1Lm6OrNmgTzXKuGWO2y50siQieDomFR35aYQFi30op3m
	NfzNkQsPa9KYziqJ/AoLu3LJHt2RDRZXs2F2GlaeceYNDn24jF1UNDnr712QnAb/G4xJkGqsuRrHW
	uCw7iIocM7jQSpW3XkCv4bM1ctQlYF44s6jPKjCqYjmqa9zjr/DzJMyblE2x9vVi4HhMiU+JuZa0f
	K0bry718a0tZ9jOGvB4tpDdfCWJ11ed3uJjblqbvlCTjEFOJ8NVaKkp0+2c7pU/unqrwdztkJ6eOS
	EMt8eA0Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdw-0000000F9Di-01ry;
	Thu, 15 Feb 2024 06:54:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 07/26] configure: don't check for getmntent
Date: Thu, 15 Feb 2024 07:54:05 +0100
Message-Id: <20240215065424.2193735-8-hch@lst.de>
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

getmntent always exists on Linux (and always has), so don't bother
checking for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  2 --
 fsr/Makefile          |  4 ----
 include/builddefs.in  |  2 --
 libfrog/Makefile      |  4 ----
 libfrog/paths.c       |  9 +--------
 m4/package_libcdev.m4 | 27 ---------------------------
 6 files changed, 1 insertion(+), 47 deletions(-)

diff --git a/configure.ac b/configure.ac
index 127bd90ef..228e89a50 100644
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

