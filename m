Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052764F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513579; cv=none; b=MBJwGWCkTT19Hq0keodtH+KtF1COsQZWNayFtS42DrqZktrCEua8c8RadLS+GUYcwfkygUKdUnxsvU+paUxZIDI0O61K3GmSU0a2j8NhM7g1OgJ1MFVcPofybtuROhlvem52eLb8DFa+6+dKKiqrGqQYv+K6loFHedepJ68pCBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513579; c=relaxed/simple;
	bh=0m4Xg3c3tz19ozmH/+Ivs6Ae4Cj/EG7y3bTeKdh3tKI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SO9QEiSvpO4Co1uqqO1p5mSTyiOr4HXjulArCFLPgqkiHpgI285edqsIheqz4kBvJd7PhKE3W6cId5hGxWZHf4HPcVVAbsBUU/eP7MevsLHi4LvgXP7kD+GjqHFzS6rr09QKU5ddzVX29Syaypd22JWrS8A7rLUuDOUC+5UqzC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hv9SVsUk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hv9SVsUk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jd1vqHtFK+2+Z0ni0XLWah6iV8C0H2LT7snXELFbfv4=; b=hv9SVsUkgl3oTbf4huomF2Zq/Q
	Fq8beSp4zDj03XeRJBHxeZwiZFUhrMYinOCEHtnXF2G8kGsMQADyGpPxgnXIO2tRp0DYt9qlI2YpM
	eA5xdjbcAtApgRD0UKKTtQu4ehysIIw+hpCm0/d/gGvFDyhDeWbnuk6xIx8bXMm3Ox5T37P3RmrQ8
	BWM4LULHrx4ic3BZ0ekd6sAcA0VStdL+rGWE5Trz82aE0Hx/ddHA67fZadVSEp7qHYhfRTiPMLjXR
	1meCOqro+SdD+t6daP3kdGmO8pC/1lAcEv1Vy4AAA+8X9xFCcb5wWfh0lGr8t0fOalKCftb9zpKIQ
	ekW2UKkQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8X-0000000BchY-1Ewo;
	Mon, 29 Jan 2024 07:32:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/27] configure: don't check for readdir
Date: Mon, 29 Jan 2024 08:32:03 +0100
Message-Id: <20240129073215.108519-16-hch@lst.de>
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

readdir has been part of Posix since the very beginning.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  7 +------
 io/io.h               |  7 -------
 m4/package_libcdev.m4 | 17 -----------------
 5 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7c1248583..6510a4fb3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -168,7 +168,6 @@ AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNCFS
 AC_HAVE_FLS
-AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
diff --git a/include/builddefs.in b/include/builddefs.in
index 247dd9956..4951ae9d9 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -95,7 +95,6 @@ HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNCFS = @have_syncfs@
-HAVE_READDIR = @have_readdir@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
diff --git a/io/Makefile b/io/Makefile
index 0709f8f21..837716238 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -14,7 +14,7 @@ CFILES = init.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
 	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c fiemap.c \
-	sync_file_range.c
+	sync_file_range.c readdir.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
@@ -46,11 +46,6 @@ ifeq ($(HAVE_PWRITEV2),yes)
 LCFLAGS += -DHAVE_PWRITEV2
 endif
 
-ifeq ($(HAVE_READDIR),yes)
-CFILES += readdir.c
-LCFLAGS += -DHAVE_READDIR
-endif
-
 ifeq ($(HAVE_MREMAP),yes)
 LCFLAGS += -DHAVE_MREMAP
 endif
diff --git a/io/io.h b/io/io.h
index ad025c51d..e807bb0de 100644
--- a/io/io.h
+++ b/io/io.h
@@ -129,15 +129,8 @@ extern void		copy_range_init(void);
 #endif
 
 extern void		sync_range_init(void);
-
-#ifdef HAVE_READDIR
 extern void		readdir_init(void);
-#else
-#define readdir_init()		do { } while (0)
-#endif
-
 extern void		reflink_init(void);
-
 extern void		cowextsize_init(void);
 
 #ifdef HAVE_GETFSMAP
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5a2290de1..25d869841 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -91,23 +91,6 @@ syncfs(0);
     AC_SUBST(have_syncfs)
   ])
 
-#
-# Check if we have a readdir libc call
-#
-AC_DEFUN([AC_HAVE_READDIR],
-  [ AC_MSG_CHECKING([for readdir])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <dirent.h>
-	]], [[
-readdir(0);
-	]])
-    ], have_readdir=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_readdir)
-  ])
-
 #
 # Check if we have a flc call (Mac OS X)
 #
-- 
2.39.2

