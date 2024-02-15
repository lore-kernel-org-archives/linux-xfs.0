Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B775B67E
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980097; cv=none; b=tNr9Xn09c3CGvj35WxyTYRq99zKTAB1fPntR3M2J/Oun52Q80kY/LaqLKUBak3BKRfY/jnvrzhHM6IkigprgxlrRS2ux30UqMmBMe0QTNq6XklbVd9NPvorshewRKOBPiVIKMJZ7uMFtQD+EnndDYrMrNlHXtSLNAYlOy54PUwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980097; c=relaxed/simple;
	bh=sKldD9Q9ynQ+8WeunW5w+/aTaGJOMf1+QNuBMaXKjKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L4d134XDOE/1Z8TjZGGrSMeFOCzXMj8By2Xe/sSWZQxRL6JqGCTgHXKW7H6hTHC+SGkt71H2HojRrzn7jb1XIxL1MdoUjxpk8zx/gN/ehf7iw6vE2S0LCawWoeA2T7imcS6/at25AZ5+TFYKVh6xTXP9nChrzbCkjhqBicHaDuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0nLq0rjd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0nLq0rjd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Hm1l4RVGOqoA81uepfn7H9NRkDepdu0Gk9QaRYWGU/M=; b=0nLq0rjdtcZJw8mDqAz1RDNpuV
	YQF+jtveaRgTkyvGTtVvuomFrnqDB1MxqZoR3I7JO3gSxNl1xmbWVjoZuihRnK8elm/gtTWawTr32
	5dGUKSn8djQTUyrPTm2o926YBWGu7Yhtoq7wh97FW8i6rcmvJcoRzMcLHRIog1F1vh8KiWTFzJI3v
	FNRd0HkFFUSiGq86kEeVv0wUw81UVfTZgTDDPx33b3iaaXF3n0jSt0MjcZdifNmk2mglpTf5Cr0th
	uN0iL3qNVsrS5/CwYEHleHCpXejcU9YHroP2i4tj33l64L3/eke9MxKApAFAvqBTDi75dOPhmqZS7
	NJv+UR0w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVe3-0000000F9FX-27Xh;
	Thu, 15 Feb 2024 06:54:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 10/26] configure: don't check for sendfile
Date: Thu, 15 Feb 2024 07:54:08 +0100
Message-Id: <20240215065424.2193735-11-hch@lst.de>
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

sendfile has been supported since Linux 2.2 and glibc 2.1.

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
index 0b94dab18..871dc5cf1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -164,7 +164,6 @@ AC_PACKAGE_NEED_RCU_INIT
 
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
-AC_HAVE_SENDFILE
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PWRITEV2
diff --git a/include/builddefs.in b/include/builddefs.in
index 42dc23174..9c7ef93e8 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -92,7 +92,6 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
 HAVE_MADVISE = @have_madvise@
 HAVE_MINCORE = @have_mincore@
-HAVE_SENDFILE = @have_sendfile@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
diff --git a/io/Makefile b/io/Makefile
index a8ea64010..9309f1a4f 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,7 +13,7 @@ CFILES = init.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c fadvise.c
+	truncate.c utimes.c fadvise.c sendfile.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
@@ -33,13 +33,6 @@ else
 LSRCFILES += mincore.c
 endif
 
-ifeq ($(HAVE_SENDFILE),yes)
-CFILES += sendfile.c
-LCFLAGS += -DHAVE_SENDFILE
-else
-LSRCFILES += sendfile.c
-endif
-
 ifeq ($(HAVE_FIEMAP),yes)
 CFILES += fiemap.c
 LCFLAGS += -DHAVE_FIEMAP
diff --git a/io/io.h b/io/io.h
index ad90cf3cb..9f176685e 100644
--- a/io/io.h
+++ b/io/io.h
@@ -117,12 +117,7 @@ extern void		sync_init(void);
 extern void		truncate_init(void);
 extern void		utimes_init(void);
 extern void		fadvise_init(void);
-
-#ifdef HAVE_SENDFILE
 extern void		sendfile_init(void);
-#else
-#define sendfile_init()	do { } while (0)
-#endif
 
 #ifdef HAVE_MADVISE
 extern void		madvise_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 53d19a1b6..ef20ae41a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -34,24 +34,6 @@ mincore(0, 0, 0);
     AC_SUBST(have_mincore)
   ])
 
-#
-# Check if we have a working sendfile system call
-#
-AC_DEFUN([AC_HAVE_SENDFILE],
-  [ AC_MSG_CHECKING([for sendfile ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <sys/sendfile.h>
-	]], [[
-sendfile(0, 0, 0, 0);
-	]])
-    ],	have_sendfile=yes
-	AC_MSG_RESULT(yes),
-	AC_MSG_RESULT(no))
-    AC_SUBST(have_sendfile)
-  ])
-
 #
 # Check if we have a fallocate libc call (Linux)
 #
-- 
2.39.2

