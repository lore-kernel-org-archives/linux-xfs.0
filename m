Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EEFD272
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980110; cv=none; b=ZHcqKtHViGh2K7UWzRNnCAHVLsfWFrJPKfLORc3MxNQ9lhHQd0Kf4qYaMotAzbaqr2WMyuIwHYoAfUg/T68u+oGS7fLvE347sI2ajxyUQWu4gt+OlOhnUyEntHxsJ7QJ4i2NWmLp0tgQGKNYh1iOChYeBjnsTy2K4+MkrInbsJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980110; c=relaxed/simple;
	bh=LcPLKO+dkz4zFoxsni8oCLpi1Mp+I06FhHkOAgF+eSg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G3yo8LnBOr08IzGpoqFzuOue7fhZIlM0tAUtYOGrQ/os/M8kpMwh8UJtMoaJDQfVTa4aimPZ0wEGHYOXCo3BVOqsqdee4o5LjYC/BEEXexYafPKvSvhnRkDu8YxMaf7GK9AzQHiFzNNXsVWnEXpXmIQYG82fzihkAotASMivKr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NHrllmZG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NHrllmZG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dl7oZfZx5k0BVGBrb8IKiJGRTlknH3Q3O/GgExd3qCc=; b=NHrllmZGWn81bdfHkON9C5fw0g
	3fWShkS0ukD6Rk2RDoLnoOJXKeRgjdSl4/KZyLRwGHDMUDblJktc7Xu8BRId+7qaFCsCcvSFswJcK
	jXoWFBJPa13DTfHaI5/IxFkgNGlAh96YpFlzC97RJu+GwCso3Wa6zc9ZXun/NB5f5FJ0qdu3MheH/
	cbkn5pay00CsdjvTHLYfbaDpA0Lbqz6v+m03AecQQCQ4TKE4kjimI7W/VVkfPT9271/KfOO3wVxAC
	onpeIJoCgaZffaWZH74YAaIiV5jybD2YqG1cdKXHdL4XDSk0eODQz2fyYRbWNftLlJfv/LCrZ9xtV
	nCw0N2Qg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeG-0000000F9IT-1lTg;
	Thu, 15 Feb 2024 06:55:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 15/26] configure: don't check for readdir
Date: Thu, 15 Feb 2024 07:54:13 +0100
Message-Id: <20240215065424.2193735-16-hch@lst.de>
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

readdir has been part of Posix since the very beginning.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  7 +------
 io/io.h               |  7 -------
 m4/package_libcdev.m4 | 17 -----------------
 5 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5f1478f68..68d50e2d2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -168,7 +168,6 @@ AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNCFS
 AC_HAVE_FLS
-AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
diff --git a/include/builddefs.in b/include/builddefs.in
index 247dd9956..4951ae9d9 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -95,7 +95,6 @@ HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNCFS = @have_syncfs@
-HAVE_READDIR = @have_readdir@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
diff --git a/io/Makefile b/io/Makefile
index 0709f8f21..837716238 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -14,7 +14,7 @@ CFILES = init.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
 	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c fiemap.c \
-	sync_file_range.c
+	sync_file_range.c readdir.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
@@ -46,11 +46,6 @@ ifeq ($(HAVE_PWRITEV2),yes)
 LCFLAGS += -DHAVE_PWRITEV2
 endif
 
-ifeq ($(HAVE_READDIR),yes)
-CFILES += readdir.c
-LCFLAGS += -DHAVE_READDIR
-endif
-
 ifeq ($(HAVE_MREMAP),yes)
 LCFLAGS += -DHAVE_MREMAP
 endif
diff --git a/io/io.h b/io/io.h
index ad025c51d..e807bb0de 100644
--- a/io/io.h
+++ b/io/io.h
@@ -129,15 +129,8 @@ extern void		copy_range_init(void);
 #endif
 
 extern void		sync_range_init(void);
-
-#ifdef HAVE_READDIR
 extern void		readdir_init(void);
-#else
-#define readdir_init()		do { } while (0)
-#endif
-
 extern void		reflink_init(void);
-
 extern void		cowextsize_init(void);
 
 #ifdef HAVE_GETFSMAP
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5a2290de1..25d869841 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -91,23 +91,6 @@ syncfs(0);
     AC_SUBST(have_syncfs)
   ])
 
-#
-# Check if we have a readdir libc call
-#
-AC_DEFUN([AC_HAVE_READDIR],
-  [ AC_MSG_CHECKING([for readdir])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <dirent.h>
-	]], [[
-readdir(0);
-	]])
-    ], have_readdir=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_readdir)
-  ])
-
 #
 # Check if we have a flc call (Mac OS X)
 #
-- 
2.39.2

