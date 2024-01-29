Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00E84F1EC
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513568; cv=none; b=NtE2W8dWZ8E9vP6F/okrYSi10Aei1bfZ5yAHcCH+N9JFKlrPzRFVWdbuDGIBBe1L8860lez+gkOvDLAJc13zM9TO2uOcrr3Q9/6xATaZv+GcUJ7OaJtMggPvlOo+dzca/XzDc+95WKPVZo0UqmDdvBX5yiVMAnam9EagSeO+iVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513568; c=relaxed/simple;
	bh=l1I5VFApjVllKOnmkKpv5wZM8Q7OPfcm7xmsXf/MSMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n3ssTxRFo4zLGtFcAcuOqGauBVH2dfp7XKqfmOCjlc8+ViardLC6txz8LNF+4Xx7WiSelWauFLxirBjZM2/PTmC58jLJYzog23Ov6F84deoLUva3+X/yRoata5nOYr3TFAE3X6vMgMKSuVuTBjZeAGGtE4m2+kfxIQQCDSsIZHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q9MDiCY2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q9MDiCY2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=V5jSzWNweQi19zrLwwPM+9zbrExpTgIY7S2DPlFZav4=; b=Q9MDiCY2jPgbv1c7QgrOrmQwsB
	2bO9gGfcdc++ZvdNMrVEUhrJX/BxPyrJAGXwN9QDHygAAHw+YC9F4KMVdsgipUCaDoCfSVDNuDFLY
	BP/1IB6kWDauYf5qy57yyNQ4h4ldFNoCXpaEJcEssQeu1YkHFBQsvQ31Wzz4IJxZmI5n9Lr0OX9rb
	zrMok5nHFZS04SI/2+rye2ytOJM39WCXueH/lLt4kYIMmdQAwoKAdd4rWeE6ZXkdZdR8ptAUfmY78
	ktUODq7bTx8xxedKGGtqTtQ6QCXHQ0tMup2cIu3qZEthdtGoAAjDhhcz30RxmedI1Jh8gvWCE7YNA
	OfDitaQw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8M-0000000Bcfk-3bKI;
	Mon, 29 Jan 2024 07:32:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/27] configure: don't check for madvise
Date: Mon, 29 Jan 2024 08:31:59 +0100
Message-Id: <20240129073215.108519-12-hch@lst.de>
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

madvise has been supported since before the dawn of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  9 +--------
 io/io.h               |  5 -----
 m4/package_libcdev.m4 | 18 ------------------
 5 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/configure.ac b/configure.ac
index cc9d9c268..4d5609129 100644
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

