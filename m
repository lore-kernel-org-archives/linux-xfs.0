Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA1B67E
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980100; cv=none; b=PnE36dTLsHSwtWJ2K4nmwo9u/+j7Z28WqOqH00eve9CfR0/LB7/V1L/5IS2P3hFyR/UHf/+e5SXnxkJFbYS09b/wGOJwhTHlctiQ7k94o2xVDFZC0w7E8v+gQNcZgALhMh0AhgERQhHUJsoRu59+9SdBWqyoCFtSiI45//tWTfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980100; c=relaxed/simple;
	bh=O0kp+2EcisiCJU59kiaYITX+npniTDI4+zJ8pViQGTY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sJUKqdB2odD4pv3zyupH9H1XGzqtqozTl6VbEzvcoNq1snPwLJAiSfTnSFayhC1/hFO/Ej6suGvO3KrNO7bgfOqfvZ2Z6vDSlXh7EhEBz19D2q/YdW9lrgcSEXNsr6187ZP1IL17GobyUOfRO64NKgFuNhZrFg8mbPCFPyL/tvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WS/Y3+Gc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WS/Y3+Gc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HFdu/Im8FvMhvfOg3WZYM3mj01Ga1cVEhyh/AWxVVgI=; b=WS/Y3+GcOEOYr7D73KLDXu6BNY
	1ydaR9EtMY3WXbqUeU3U9XQ8ookzgarzkkxYFyLC8OapRMOu8CgmhgE1nILyfCdnzlJZ14fwrxEts
	5RhxksXyijbN5MphRxebBJmPKhSk0+A8XHDePTMH0TLMrOevcOiHV82UBhsKfq8ZxXQdCXpAYg+Oq
	Q/RwY3N2/AFwzzEOKaLjqeIURf1j/Zx+kqzJu4BoTJzUqDSEfEbRsdYqWDEgvHtESMPc0l0nKhgKA
	w5CpNhtRms5tM5ZVmmHrpXW/hEf1/W+LxrtCS9DdzV6Kqh7+vtu58OMddAZh05UcFEI+kRJdsTV7S
	rMVloyvg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVe5-0000000F9Fq-4AxM;
	Thu, 15 Feb 2024 06:54:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 11/26] configure: don't check for madvise
Date: Thu, 15 Feb 2024 07:54:09 +0100
Message-Id: <20240215065424.2193735-12-hch@lst.de>
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

madvise has been supported since before the dawn of it.

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
index 871dc5cf1..0194af7bf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -162,7 +162,6 @@ AC_PACKAGE_NEED_PTHREADMUTEXINIT
 AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
-AC_HAVE_MADVISE
 AC_HAVE_MINCORE
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
diff --git a/include/builddefs.in b/include/builddefs.in
index 9c7ef93e8..f8558a79f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -90,7 +90,6 @@ ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-HAVE_MADVISE = @have_madvise@
 HAVE_MINCORE = @have_mincore@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
diff --git a/io/Makefile b/io/Makefile
index 9309f1a4f..f01f32d16 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,19 +13,12 @@ CFILES = init.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c fadvise.c sendfile.c
+	truncate.c utimes.c fadvise.c sendfile.c madvise.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
-ifeq ($(HAVE_MADVISE),yes)
-CFILES += madvise.c
-LCFLAGS += -DHAVE_MADVISE
-else
-LSRCFILES += madvise.c
-endif
-
 ifeq ($(HAVE_MINCORE),yes)
 CFILES += mincore.c
 LCFLAGS += -DHAVE_MINCORE
diff --git a/io/io.h b/io/io.h
index 9f176685e..d90dc91cb 100644
--- a/io/io.h
+++ b/io/io.h
@@ -118,12 +118,7 @@ extern void		truncate_init(void);
 extern void		utimes_init(void);
 extern void		fadvise_init(void);
 extern void		sendfile_init(void);
-
-#ifdef HAVE_MADVISE
 extern void		madvise_init(void);
-#else
-#define madvise_init()	do { } while (0)
-#endif
 
 #ifdef HAVE_MINCORE
 extern void		mincore_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index ef20ae41a..9586ef03d 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,21 +1,3 @@
-#
-# Check if we have a working madvise system call
-#
-AC_DEFUN([AC_HAVE_MADVISE],
-  [ AC_MSG_CHECKING([for madvise ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <sys/mman.h>
-	]], [[
-posix_madvise(0, 0, MADV_NORMAL);
-	]])
-    ],	have_madvise=yes
-	AC_MSG_RESULT(yes),
-	AC_MSG_RESULT(no))
-    AC_SUBST(have_madvise)
-  ])
-
 #
 # Check if we have a working mincore system call
 #
-- 
2.39.2

