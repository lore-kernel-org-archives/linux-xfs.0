Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C484F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513590; cv=none; b=RdfL+4239y3QqhqjzUgXS/jCT4yhGTRTiq8Gy+aG8c9OD7V3EMmors9TurBVhuZIbLVu+POTp2OluatGem8r8M9qr/s0SSbD9j+B5ovHNxNIV67v93pWuNZp9EO79kJ4OChpsxVb/NsTcWyZH96taHE/h0kodW+3Cns0D+6AZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513590; c=relaxed/simple;
	bh=izO0PNw38s3b99EtwpHLVqRc7y43d9lLOuIvpOgXRHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ljnn5bWHQLps17X3SgvOvzCVyT+DamaB1Gu5VeXv4UU6Cg444fcl5IsiaR3AkjLGeJjjN6oN9Hq/nhTjrrslbLHY5KT1R8T4EGs9/EXQhL5syXdSRFwQXzXX0vQUoS8H7PJPNxCe8QcgYN2SMGcRsBuiRASmf6OZ0gUCzUDwcGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NC8XJuu6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NC8XJuu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H8+zZIkWkClIMRzHBfNNGRfWnfk14cBZ2jAAmSf5byc=; b=NC8XJuu6Qtq7FFryDecZjy487L
	RQOhJDM9Sk4Gl24XkkqdsQyrDU/Z20ZTvbru90uJ1tJdz1Oe5enze25wWcD4VeRJvMQPzu2XMerXM
	0hbnnBtRGdqXvw9E7SOnGPcUuNgTQcgHddUwDTXWmxB+JoMzyDmvsaGnxPd1ZsL2TAFzvnKDF81Hh
	dGVqd3qw3JzUJLNcDZDJwhCiYW3z/gM6XsL5c3+nFAj3Ntf7tTWX04bjfdD8eLjUAVnJXw34dI/dN
	K7uf2lz5ekiAqfnYj6BBzuEeofrmEv1Im900FxHO5n/mghjjayX47XIiCC01E0a6ozNDozs8fQhJw
	e90A+3CA==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8h-0000000Bcke-3pxO;
	Mon, 29 Jan 2024 07:33:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 19/27] configure: don't check for preadv and pwritev
Date: Mon, 29 Jan 2024 08:32:07 +0100
Message-Id: <20240129073215.108519-20-hch@lst.de>
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

preadv and pwritev have been supported since Linux 2.6.30.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  5 -----
 io/pread.c            |  8 --------
 io/pwrite.c           |  8 --------
 m4/package_libcdev.m4 | 19 -------------------
 6 files changed, 42 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3a131982f..a332b7694 100644
--- a/configure.ac
+++ b/configure.ac
@@ -163,7 +163,6 @@ AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
 AC_HAVE_PWRITEV2
-AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
diff --git a/include/builddefs.in b/include/builddefs.in
index cb63751fd..0e0f26144 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -90,7 +90,6 @@ ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_FSETXATTR = @have_fsetxattr@
diff --git a/io/Makefile b/io/Makefile
index acef8957d..a81a75fc8 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -29,11 +29,6 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
-# Also implies PWRITEV
-ifeq ($(HAVE_PREADV),yes)
-LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
-endif
-
 ifeq ($(HAVE_PWRITEV2),yes)
 LCFLAGS += -DHAVE_PWRITEV2
 endif
diff --git a/io/pread.c b/io/pread.c
index 0f1d8b97b..75b4390a8 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -37,9 +37,7 @@ pread_help(void)
 " -R   -- read at random offsets in the range of bytes\n"
 " -Z N -- zeed the random number generator (used when reading randomly)\n"
 "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
-#ifdef HAVE_PREADV
 " -V N -- use vectored IO with N iovecs of blocksize each (preadv)\n"
-#endif
 "\n"
 " When in \"random\" mode, the number of read operations will equal the\n"
 " number required to do a complete forward/backward scan of the range.\n"
@@ -160,7 +158,6 @@ dump_buffer(
 	}
 }
 
-#ifdef HAVE_PREADV
 static ssize_t
 do_preadv(
 	int		fd,
@@ -192,9 +189,6 @@ do_preadv(
 
 	return bytes;
 }
-#else
-#define do_preadv(fd, offset, count) (0)
-#endif
 
 static ssize_t
 do_pread(
@@ -414,7 +408,6 @@ pread_f(
 		case 'v':
 			vflag = 1;
 			break;
-#ifdef HAVE_PREADV
 		case 'V':
 			vectors = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
@@ -424,7 +417,6 @@ pread_f(
 				return 0;
 			}
 			break;
-#endif
 		case 'Z':
 			zeed = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
diff --git a/io/pwrite.c b/io/pwrite.c
index 467bfa9f8..56171a696 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -40,9 +40,7 @@ pwrite_help(void)
 " -R   -- write at random offsets in the specified range of bytes\n"
 " -Z N -- zeed the random number generator (used when writing randomly)\n"
 "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
-#ifdef HAVE_PWRITEV
 " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
-#endif
 #ifdef HAVE_PWRITEV2
 " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
 " -D   -- Perform the pwritev2() with RWF_DSYNC\n"
@@ -50,7 +48,6 @@ pwrite_help(void)
 "\n"));
 }
 
-#ifdef HAVE_PWRITEV
 static ssize_t
 do_pwritev(
 	int		fd,
@@ -90,9 +87,6 @@ do_pwritev(
 
 	return bytes;
 }
-#else
-#define do_pwritev(fd, offset, count, pwritev2_flags) (0)
-#endif
 
 static ssize_t
 do_pwrite(
@@ -353,7 +347,6 @@ pwrite_f(
 		case 'u':
 			uflag = 1;
 			break;
-#ifdef HAVE_PWRITEV
 		case 'V':
 			vectors = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
@@ -363,7 +356,6 @@ pwrite_f(
 				return 0;
 			}
 			break;
-#endif
 		case 'w':
 			wflag = 1;
 			break;
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 37d11e338..7d7679fa0 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,22 +1,3 @@
-#
-# Check if we have a preadv libc call (Linux)
-#
-AC_DEFUN([AC_HAVE_PREADV],
-  [ AC_MSG_CHECKING([for preadv])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _BSD_SOURCE
-#define _DEFAULT_SOURCE
-#include <sys/uio.h>
-	]], [[
-preadv(0, 0, 0, 0);
-	]])
-    ], have_preadv=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_preadv)
-  ])
-
 #
 # Check if we have a pwritev2 libc call (Linux)
 #
-- 
2.39.2

