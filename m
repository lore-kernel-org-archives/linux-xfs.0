Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5034F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513574; cv=none; b=DazOY7dquGZxEyYZg6LtjQKbGFOtbj6lWrcNEq3P2zsqaMDFwWHlk06dNqIlOVHQgyQXfUCRcD/snC5CTuPrOGlABvzL35AOZALv5BXVthwMQ6DB8+ogbD8etyLeGbs2/9f0wXq3UCiLSBcs/tVcDg9S9ZYAFj9MxpqRNzHTNzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513574; c=relaxed/simple;
	bh=H0MuuNmIliFQiL9Bze7B3Wy6EYBwARKEnZf/kJwP2sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ApaJiAfstN/OQAZTl9diCfG7FZTajpDB6nCp1gtji/KILc9ymUga23zpQR6T1qdVBqryVXsuRDE2AjB58+nCMBEzkYsoM4D5ancy0d+9U9DkYeX/PU9SyA3LLN9JTj0DCJHbi41TmOe0tpMnYw2u/q8zXNpqu8qhO5lvZe6kRN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=niYqOpCE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="niYqOpCE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5e41KYKI1G0YKtLwRQU+kf4790z+Mv0jovnOCvG0Gr4=; b=niYqOpCEd+r1qxlLW+70niRzvV
	KDviI2uKNiJa7hrzAdu83SeYkmf3/tZFoMYFIgmyrUqGAXOKLS2jVCPHChdKcqTmhPcroqGvI1m+P
	3uAapSiS7+cgiFBY+O0M94OflTJI0uCAaZGg3Bg9lJPA98VKFLw1sBWGHm0RCQHpA43tBHzV9GKEv
	pXu3/J+bhUS+Ubw8u+9cYANZ/+P5/sROJK50SG12XFLPdizH1nfHx5uwP+UIbn1jDlQ+2RLllCzj1
	f1tYRcU7K90dB4NPlco7yyU0+dhjUUShnPMQjzU+N9rE3WBe1Pho8/LyKoacSYN61ebJpeGJo8sAm
	ifdSE0KQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8S-0000000BcgM-0h7A;
	Mon, 29 Jan 2024 07:32:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/27] configure: don't check for fiemap
Date: Mon, 29 Jan 2024 08:32:01 +0100
Message-Id: <20240129073215.108519-14-hch@lst.de>
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

fiemap has been supported since Linux 2.6.28.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  9 +--------
 io/io.h               |  5 -----
 m4/package_libcdev.m4 | 21 ---------------------
 5 files changed, 1 insertion(+), 36 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3b5ebf375..40999b598 100644
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

