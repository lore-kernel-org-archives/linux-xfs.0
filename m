Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343014F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513571; cv=none; b=LwrLAxDOTJ5xxIf6VXzXgLl77Ewv6kVijRcUR6/4C+V2G/9mOC5BdeG/wGSMys6Hd1Fy//pE+au6HYpiopnvZybPSEHp7w3WGzyf5dzhzXw7cPkmFnnwfWd5ikOajvvma7UqxzkHV65ZRG7Iys7yVxm5gSkexorLY3/mKRHyMvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513571; c=relaxed/simple;
	bh=9pLLbPlVxGAh6esQWMhZWqgueWLFs/fN90hNwH1Q57U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qaO0GJbGSHMJCtceq0gYCSJxRdgjAn1Fnq+aViFWX7ZYFiW/QomzyLfnfM4CTFDaXDD0yBQoMGt/wiVr3A36vl5MwZaAxqptAsEKt4D3aSr8g7Mgi4G4KRvPJFj2dH/0j5b7iB5kslIdSBTQArU2NcAfUDfzPb71DV8zZFqtMu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JQgHSYzx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JQgHSYzx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=l6fwmdc9RjoA4EM6qGtOgPkkl4/xG3TUhiWRi9dU2sM=; b=JQgHSYzxkdJ7aY+NSMyMgKVfG5
	qZRDmzKCGWRSEdpo6J4nwBXDIvbiS38XzLhblr9DbIL57v6YUiQrBpm1UG9Osa5faH/KfItPVEN79
	jAMnsBbJDKhhWJmKMsc7I6fShR6QO/NCMIDnGmRtxdzPiJFwAenHRuc2In6n+eUAwB8sKtbUp2DYk
	kyrJjuE8RePKXps05uQ9hM226HF6phhaH+HNVNnTjZOOnzbc7EefFALFFVdcsHUOKgfz022TepOX5
	Td+H7jJAi1/HtgoQsHZHU0LJAmkUIsH6A4yCqI/VUCdeG3WmThBLwzshfBpGC2aVn8Nr9b9f/RRjB
	aWOYHSIQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8P-0000000Bcg0-1ub4;
	Mon, 29 Jan 2024 07:32:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/27] configure: don't check for mincor
Date: Mon, 29 Jan 2024 08:32:00 +0100
Message-Id: <20240129073215.108519-13-hch@lst.de>
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

mincore has been supported since Linux 2.3.99pre1 and glibc 2.2.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  9 +--------
 io/io.h               |  5 -----
 m4/package_libcdev.m4 | 18 ------------------
 5 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4d5609129..3b5ebf375 100644
--- a/configure.ac
+++ b/configure.ac
@@ -162,7 +162,6 @@ AC_PACKAGE_NEED_PTHREADMUTEXINIT
 AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
-AC_HAVE_MINCORE
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PWRITEV2
diff --git a/include/builddefs.in b/include/builddefs.in
index f8558a79f..353a03d18 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -90,7 +90,6 @@ ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-HAVE_MINCORE = @have_mincore@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
diff --git a/io/Makefile b/io/Makefile
index f01f32d16..f480272ae 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,19 +13,12 @@ CFILES = init.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c fadvise.c sendfile.c madvise.c
+	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
-ifeq ($(HAVE_MINCORE),yes)
-CFILES += mincore.c
-LCFLAGS += -DHAVE_MINCORE
-else
-LSRCFILES += mincore.c
-endif
-
 ifeq ($(HAVE_FIEMAP),yes)
 CFILES += fiemap.c
 LCFLAGS += -DHAVE_FIEMAP
diff --git a/io/io.h b/io/io.h
index d90dc91cb..9c056efb5 100644
--- a/io/io.h
+++ b/io/io.h
@@ -119,12 +119,7 @@ extern void		utimes_init(void);
 extern void		fadvise_init(void);
 extern void		sendfile_init(void);
 extern void		madvise_init(void);
-
-#ifdef HAVE_MINCORE
 extern void		mincore_init(void);
-#else
-#define mincore_init()	do { } while (0)
-#endif
 
 #ifdef HAVE_FIEMAP
 extern void		fiemap_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 9586ef03d..87c294b24 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,21 +1,3 @@
-#
-# Check if we have a working mincore system call
-#
-AC_DEFUN([AC_HAVE_MINCORE],
-  [ AC_MSG_CHECKING([for mincore ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <sys/mman.h>
-	]], [[
-mincore(0, 0, 0);
-	]])
-    ],	have_mincore=yes
-	AC_MSG_RESULT(yes),
-	AC_MSG_RESULT(no))
-    AC_SUBST(have_mincore)
-  ])
-
 #
 # Check if we have a fallocate libc call (Linux)
 #
-- 
2.39.2

