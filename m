Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5D44F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513563; cv=none; b=Ti5L9skjtZU8D2FFNOKTOJ4YP4TDKETM4GkECgjXOAX1qwud+eC/6ZnEB3Oh0P2nGF+Yt65jKu9tKPCfuiwGi1j4+xWuVhE+61FnF307mdhVXaXtLEDUFX3WVtQ43M/OsobRYzER3KnS2/YhU2p8+PgqWm7dYv+ovygn/36Wshw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513563; c=relaxed/simple;
	bh=ImeHWH+1cyWhHuetTQLkO46k0Fnl+D0HlqyLLnvsKMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LuFYz97Nk3BYIW1s7XbeTSQ2e+ZfWAYKISHGBTWQ4H6r2rKh/3dumUHbXiScDpoAGpwkyR0tbgvvKk3/blHk7827MH720pXRv80BaPZZLZZNNbyw8nJhxyX6GVJBws6N0YldX5LVFM+/5+2V+OLvL27PUjTkRI/jksgiLk1WA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dxw/Jk5f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dxw/Jk5f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ptZXkRSCXbltYqgFHk/DRpqPym6T1sJZMyQF/hSwDtQ=; b=Dxw/Jk5f/cODBRMSOE60YrjmRa
	Y/yB3VS5A/j72DeIad1pZNGeQ1/TTNvWgQbGp2V3mgEOYpU8owIlMMUpayaHgylNItvxBw1KuCfqx
	1vWevVUrUTV6F6JHBnoXcnE64oNoHtFHvNtIyqAe5o6NtIpcLCFDp38AdNm/MyjjblUmgF/gFcpHl
	8J6vPmvlcbs4tMHzZLcoeljM+93dCc3jrdMz9EHI9J4R7ZNLsmB9vMV4DXSgwDxVFG4p2+HTpeSYd
	KfJixmhDa/yDlPbsAW4XsTz6MMqDOXPExnexpQWEx31iLWql0uCF5OijOnsTWqs+Vv6kGpBXoxQ/f
	fOOHulJw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8H-0000000BceJ-2v0G;
	Mon, 29 Jan 2024 07:32:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/27] configure: don't check for fadvise
Date: Mon, 29 Jan 2024 08:31:57 +0100
Message-Id: <20240129073215.108519-10-hch@lst.de>
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

fadvise has been supported since Linux 2.5.60 and glibc 2.2.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  9 +--------
 io/io.h               |  5 -----
 m4/package_libcdev.m4 | 18 ------------------
 5 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/configure.ac b/configure.ac
index a94360090..478eadc6c 100644
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

