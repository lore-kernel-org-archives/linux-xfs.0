Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8644EB67E
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980102; cv=none; b=PoLGaHQHd0sjaeDS10sJlhIljTPg0ErxgqzMOuasAy907j2JE/5NikzbcS+BPEr7GNb6MqN6Z82sp9Mhgq1bIXczVHCnBhzkgyROzn5T7Yt9XHjcRZax9dcS7pmKrNlv5XLbNOKPst2fCSZUSj5FEGRpNpyRd5NMCaaMFWymfvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980102; c=relaxed/simple;
	bh=fGkgHkP7Jo7IwuwIYSILsfx7C6nmHRu6RPS3Dlo3Xts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nntY/wZbcVmV9ferH4XkjdxgxoqoaJYt+Q0zxvGTCJ/oacps56p1JR9YS2SdbLPIbbteSQ7QW23fTZ2DGRWhSUmBHlYrO3nCJCShQcBxk6KbGdUkbRT8GGJzM7QKIz/YdVX6Fo+wXtgDmKMrLrka14fc2mdAnKuEdnrnzs/9mIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JM2eii6Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JM2eii6Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DBLod3D87ynnd9fYoYzpagmVv6H6oL7y2R3bTzEDSGg=; b=JM2eii6QvBnWRIDtYk6eDyvPrL
	GsYP6X6/id948yu8TkBJUFkfsZE2wxKzmb77UqU07pAeVqKuo0UelPnqjH3x9dG8M3AftxcCJ6xlx
	8CV7GXl90AWvDkJHxnCwohidFmScKGw6sQ60O10JjXzt5PjNjwG0UK17TgMvjbLpsxP6uDyzowmy6
	3gRuK4x0X0/CDBh9OKTLgKg1/5aLNvAkkPFjxGst/HhNzzpbS9tNskoaoyX/mM+ycBdeDvZD3Pb/g
	EjCjLj8sPtzdngVViWcmRtWH1AVetIiFhwaq1kw+lhtO2lXWoPqXL5ynZwWP/BcrVUXF/sA+DxBHg
	XKgCVzKQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVe8-0000000F9GM-35lt;
	Thu, 15 Feb 2024 06:55:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 12/26] configure: don't check for mincor
Date: Thu, 15 Feb 2024 07:54:10 +0100
Message-Id: <20240215065424.2193735-13-hch@lst.de>
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

mincore has been supported since Linux 2.3.99pre1 and glibc 2.2.

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
index 0194af7bf..3a708c359 100644
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

