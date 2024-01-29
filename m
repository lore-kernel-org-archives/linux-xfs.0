Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC744F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513605; cv=none; b=ZXUqPBx31d47EfL8X+NJQGLnbVq8S9m2blM2+d85zk43qB8aY6mLXG3y3JY9e6aRWiuV9CuUKa01F8orw13qWmyA7r771rIi8X1n8Gcq8LViXtdnfq0Sdb7bw6IiKAWmNl5YoO3MLnbzhw5uEVPyghGzSsNULKwd/Bzi4xLo7Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513605; c=relaxed/simple;
	bh=vxGCb6WNJu6iZhrFoh/DKoQaXyN6sugQXaIeQm6jUNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mlJpcncSAFRX0RZROaqzB0AQ+9tUyu+3jc66nZNRGgagsHWCTUEF+WUHcqVlt3GRsDajo8yX6Kh4iTdW9ZreWKhla9H5m7YMnItJ47wwNrhC6xBHAE5+cC/U8z5PFlrp+f17ZIZcMa/XYAY1S1bXfNVZKjYVEEQCSwlPO6rQKv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K5Klsqfz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K5Klsqfz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lHTuaxEZQFJ+dDfIjVSMFXmJlyC6/PlgWRaE8mWz2YM=; b=K5KlsqfzFx1nGq0tdfdodIuUSy
	VttrAwJ8T9VD85JjN3D2W/nN3juTElpHTG1ZhtSTS0dbLv+39ZgLfeRcgrkG2i9wTSvdyUDbRTKO4
	Nr/b7Dm5bLy8E2uhPTa8RHt0I1DrM7YwNod+qI6HU01S6CivHUD+HmW0XODSjsIxDSQ9Tk3/teNO5
	2scjqYPux9ZGnay0ByjE4QPaoQY6dEVyUJUN25EgEQgs6nHY8oS/osjr1gKqg3Z2dbvcCgdeI92UK
	2zQBNzR1oCiPM/oIwVDLe+AV091/9yBd8j9h+RPXHw+rCeCPYC13gAon7G0GRZpj1CaKxdRJJnE08
	hFRRMGZQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8x-0000000Bcnl-1Zgg;
	Mon, 29 Jan 2024 07:33:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 25/27] configure: don't check for fstatat
Date: Mon, 29 Jan 2024 08:32:13 +0100
Message-Id: <20240129073215.108519-26-hch@lst.de>
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

fstatat has been supported since Linux 2.6.16 and glibc 2.4.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 14 --------------
 scrub/Makefile        |  4 ++--
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index 47531fce5..260772a6b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -181,7 +181,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
diff --git a/include/builddefs.in b/include/builddefs.in
index c768d0411..e02600f09 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -101,7 +101,6 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 HAVE_SYSTEMD = @have_systemd@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index f857bcd94..0ff05a04b 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -157,20 +157,6 @@ test = mallinfo2();
     AC_SUBST(have_mallinfo2)
   ])
 
-#
-# Check if we have a fstatat call
-#
-AC_DEFUN([AC_HAVE_FSTATAT],
-  [ AC_CHECK_DECL([fstatat],
-       have_fstatat=yes,
-       [],
-       [#define _GNU_SOURCE
-       #include <sys/types.h>
-       #include <sys/stat.h>
-       #include <unistd.h>])
-    AC_SUBST(have_fstatat)
-  ])
-
 #
 # Check if we have the SG_IO ioctl
 #
diff --git a/scrub/Makefile b/scrub/Makefile
index 1d613b946..4eac20a13 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -6,11 +6,11 @@ TOPDIR = ..
 builddefs=$(TOPDIR)/include/builddefs
 include $(builddefs)
 
-SCRUB_PREREQS=$(HAVE_FSTATAT)$(HAVE_GETFSMAP)
+SCRUB_PREREQS=$(HAVE_GETFSMAP)
 
 scrub_svcname=xfs_scrub@.service
 
-ifeq ($(SCRUB_PREREQS),yesyes)
+ifeq ($(SCRUB_PREREQS),yes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
-- 
2.39.2

