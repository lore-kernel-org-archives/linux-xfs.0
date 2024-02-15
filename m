Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8833BA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980095; cv=none; b=FdNkJg6CnRnRGE9CCa4JE9Nkxazuj9n7Y64Z6At2/6emSwZG6fQjFuQ79s8CZXHQeX0rekR4BCIYdjQNaPvxByRzWTuJZxKCwMmCmTjGXH3e6c0AO/hxLPP/VBF88ePggc1Kw57U4OXi81Wjx0AxkDp+9bwIkhqHpx3yrDg1hio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980095; c=relaxed/simple;
	bh=E9deHyIxgr6Y2n6K9ijqTSHCZzTBQX8dvJkhuaq9p4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ul8blqgQnfGpi8mE9hcnL5OMOwTyLmMmHt3Uo9UMqjbP7kH9xwpWYVLalKse+M8ZrWD80AoQAKwpJmn/YDyqpOGcYSX3z8mWtFPI9L25alOT22NBxX++Wi8o6aavIXOvKIXWmxOmGfRcdmTbNkFvwgvceGu8ntsyn7KS+710/Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ss47BXYO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ss47BXYO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nXqFFF01s3G1/9AeeJtEbPNCD8slzkTk6jZjA/kzOBs=; b=ss47BXYOVNRKp4EU9H+MolitiY
	ul7s84HbTbtJKjHVWbjpcsbhmwhxitfo4NIsb873PM0t8owzZqEJFSf9oInoN4aIkVn+cref2pmXn
	5yDeZMgHCCbKZ5IQa/LykyY20bm1wtdESJ5tPIZvV0cxw8ZiR2yDkrqIR2IWEGinba0PJrDAgij7a
	nzc3LpLdnlLVkkyJA6FitHucYmMoyy+kPtYigBQEFYuXv6LUnva7JKoK+wji5otYfdk0DSiQSBnS9
	ALVBSDgpfmlXgwXjwJievH5dNJnO/ogehp+y/UBQYawfp/pa/k2A8y1DHIHGros6OhWy3Ae1akrk6
	Cx/SmeFw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVe1-0000000F9Ev-0BJn;
	Thu, 15 Feb 2024 06:54:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 09/26] configure: don't check for fadvise
Date: Thu, 15 Feb 2024 07:54:07 +0100
Message-Id: <20240215065424.2193735-10-hch@lst.de>
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

fadvise has been supported since Linux 2.5.60 and glibc 2.2.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  9 +--------
 io/io.h               |  5 -----
 m4/package_libcdev.m4 | 18 ------------------
 5 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/configure.ac b/configure.ac
index 012508b8e..0b94dab18 100644
--- a/configure.ac
+++ b/configure.ac
@@ -162,7 +162,6 @@ AC_PACKAGE_NEED_PTHREADMUTEXINIT
 AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
-AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
 AC_HAVE_SENDFILE
diff --git a/include/builddefs.in b/include/builddefs.in
index a00283da1..42dc23174 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -90,7 +90,6 @@ ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-HAVE_FADVISE = @have_fadvise@
 HAVE_MADVISE = @have_madvise@
 HAVE_MINCORE = @have_mincore@
 HAVE_SENDFILE = @have_sendfile@
diff --git a/io/Makefile b/io/Makefile
index 53fef09e8..a8ea64010 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,19 +13,12 @@ CFILES = init.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c
+	truncate.c utimes.c fadvise.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
-ifeq ($(HAVE_FADVISE),yes)
-CFILES += fadvise.c
-LCFLAGS += -DHAVE_FADVISE
-else
-LSRCFILES += fadvise.c
-endif
-
 ifeq ($(HAVE_MADVISE),yes)
 CFILES += madvise.c
 LCFLAGS += -DHAVE_MADVISE
diff --git a/io/io.h b/io/io.h
index fe474faf4..ad90cf3cb 100644
--- a/io/io.h
+++ b/io/io.h
@@ -116,12 +116,7 @@ extern void		swapext_init(void);
 extern void		sync_init(void);
 extern void		truncate_init(void);
 extern void		utimes_init(void);
-
-#ifdef HAVE_FADVISE
 extern void		fadvise_init(void);
-#else
-#define fadvise_init()	do { } while (0)
-#endif
 
 #ifdef HAVE_SENDFILE
 extern void		sendfile_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5d947a024..53d19a1b6 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,21 +1,3 @@
-# 
-# Check if we have a working fadvise system call
-#
-AC_DEFUN([AC_HAVE_FADVISE],
-  [ AC_MSG_CHECKING([for fadvise ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <fcntl.h>
-	]], [[
-posix_fadvise(0, 1, 0, POSIX_FADV_NORMAL);
-	]])
-    ],	have_fadvise=yes
-	AC_MSG_RESULT(yes),
-	AC_MSG_RESULT(no))
-    AC_SUBST(have_fadvise)
-  ])
-
 #
 # Check if we have a working madvise system call
 #
-- 
2.39.2

