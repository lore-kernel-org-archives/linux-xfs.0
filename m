Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184669475
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980105; cv=none; b=apDlR+trTOfc1GgCuTlZOoCg0Oqjg/QvUqf4iQ09h202FjH7J6MZppzrzrgeqCidMVVVCTmVsa6ePxSRoIlY118cRFMy2hvWUUZRgtihOsIDIliX/L5oK6o25td7GsLD+0QJ2C47p1N9HUFoFeMCAfZ3zjuhqOQUujt7JRW0v44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980105; c=relaxed/simple;
	bh=9eSn6/dD7x4ZhB0ckTLCi1QSvmgQisdVxNTM/PkVY2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b9PH/Voe3rfQ9jy8aapaO7ZCusSzKu4svh4++EiMp9e1uO+TnaYGWOTprUJLlTDJyvki2SklWp3V0/ARAkgAjH60kvvft6Oi1lilIeV4Bbn60ZPqbuf0Tgr4BNAcvjoSjmpr8q9Gqb5WflvERcmoLWjSG/1GywpxAbKMZV3kfd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Tt9e13SG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tt9e13SG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5UvhIIxwYfQSVKfvQgCijycEw4A4VowYb+M2Qfu9GtU=; b=Tt9e13SGX7Hdo8E8EBVMszuCmU
	bCjpg3x0IUZr56bT5KAC/OYgoNejrlW3PkOjJzoYsIFm+a8cbgbgSQKI9kJ9CzM+SNUC6Oyqlzv1R
	lb4pMYqXc1KVnnobyHDA1C+vUKWVp6ZwnP19OcWyywcojYECzKzQmNgPC/36ay+siRg/yX6/oZg47
	AWu+2jtqUpKuVqycQLNAShCkCTLfGjMhykjWppTHDleJPkRQSzoifAwfsMow8pB+lnU738oq+HmkG
	b96GYwf4BeCQJ6Md0o6v/R2JEUILoUdxhkyzCdeu8zy0u7+OdKA2kd27trtmSkUbzHzYTyu9BWKYi
	MKPuBg5A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeB-0000000F9Gw-16Ez;
	Thu, 15 Feb 2024 06:55:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 13/26] configure: don't check for fiemap
Date: Thu, 15 Feb 2024 07:54:11 +0100
Message-Id: <20240215065424.2193735-14-hch@lst.de>
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

fiemap has been supported since Linux 2.6.28.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  9 +--------
 io/io.h               |  5 -----
 m4/package_libcdev.m4 | 21 ---------------------
 5 files changed, 1 insertion(+), 36 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3a708c359..2650b7111 100644
--- a/configure.ac
+++ b/configure.ac
@@ -163,7 +163,6 @@ AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
 AC_HAVE_FALLOCATE
-AC_HAVE_FIEMAP
 AC_HAVE_PWRITEV2
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
diff --git a/include/builddefs.in b/include/builddefs.in
index 353a03d18..a5408014d 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -91,7 +91,6 @@ ENABLE_SCRUB	= @enable_scrub@
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
 HAVE_FALLOCATE = @have_fallocate@
-HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
diff --git a/io/Makefile b/io/Makefile
index f480272ae..2271389f5 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,19 +13,12 @@ CFILES = init.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c
+	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c fiemap.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
-ifeq ($(HAVE_FIEMAP),yes)
-CFILES += fiemap.c
-LCFLAGS += -DHAVE_FIEMAP
-else
-LSRCFILES += fiemap.c
-endif
-
 ifeq ($(HAVE_COPY_FILE_RANGE),yes)
 CFILES += copy_file_range.c
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
diff --git a/io/io.h b/io/io.h
index 9c056efb5..982d37c38 100644
--- a/io/io.h
+++ b/io/io.h
@@ -120,12 +120,7 @@ extern void		fadvise_init(void);
 extern void		sendfile_init(void);
 extern void		madvise_init(void);
 extern void		mincore_init(void);
-
-#ifdef HAVE_FIEMAP
 extern void		fiemap_init(void);
-#else
-#define fiemap_init()	do { } while (0)
-#endif
 
 #ifdef HAVE_COPY_FILE_RANGE
 extern void		copy_range_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 87c294b24..93daf3640 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -17,27 +17,6 @@ fallocate(0, 0, 0, 0);
     AC_SUBST(have_fallocate)
   ])
 
-#
-# Check if we have the fiemap ioctl (Linux)
-#
-AC_DEFUN([AC_HAVE_FIEMAP],
-  [ AC_MSG_CHECKING([for fiemap])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <linux/fs.h>
-#include <linux/fiemap.h>
-#include <sys/ioctl.h>
-	]], [[
-struct fiemap *fiemap;
-ioctl(0, FS_IOC_FIEMAP, (unsigned long)fiemap);
-	]])
-    ], have_fiemap=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_fiemap)
-  ])
-
 #
 # Check if we have a preadv libc call (Linux)
 #
-- 
2.39.2

