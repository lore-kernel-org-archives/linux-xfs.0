Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A73C127
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980138; cv=none; b=lpeqcf1AHuxhvHTgBi3vHapGMPiqtimN4mEOUvRgWo6Vb+7mQcXRSWyrakyslmjz23mZfAvULSLwU1yGfv92Igs4Ph3dEbPHrDt/dfGoel0OQGqmGxDrAsEqFCW7FzHdQPp8HZ+hEO/48hVSJNNteeuz3lBAPyrmuQOgl6HEfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980138; c=relaxed/simple;
	bh=+bhbX/xAILrWFxhFsoYhBCQkTJ6Q8nxO2MbmuPtK9/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EC25V0U0qrMo1My+9MlXdVJsfEJkdvLuptLAGg14TeNadN+QnY+beVap8JlXpuv6whj5NC27cnHtI8j7BW0FJqhcjwiplGWlBhv9TXLym79a1EuYMmAunC6saoGHHDnnRZF+yD9ULKXGu1guGz2iMzGQwGA6DAuXuf+ueDGh0J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wr2+JqvE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wr2+JqvE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7V3pcSCa2uIsanZW98jlmbSfgMmkyqcnD8QrZNEKTrI=; b=Wr2+JqvE/LtrNNVf/gb1dVSmJK
	HtjfF3lyhcb6C+laks8DDIRB0hbZICVA1Ahv1/Ac+iwb66tDr22PUq8dZF7rqB47U1kqsreOi6ZxJ
	wLIsBDuwSzfJKNNpoJA5Sd49aJ3PsJk+nRdtGiLAzWY99be7AyyRjUoGEGBxwB8QciiMk5JFx+aKD
	CFesU+dMouYuXzj74d0oBgcGeODHNXs4mIIwrZdo5dF9E/1sDaGsMvVy6/TiXp1OJ9qfdTM+at9OX
	z27hkYZ+Q9a4OqVyjrHUoSYOOfI6zrMiZbxD7LMeRGXeaOriwJ6OD+ghRdOlkJwcL6ZAyvy0j58bW
	67RPhpbw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVei-0000000F9SX-2Eq3;
	Thu, 15 Feb 2024 06:55:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 26/26] configure: don't check for HDIO_GETGEO
Date: Thu, 15 Feb 2024 07:54:24 +0100
Message-Id: <20240215065424.2193735-27-hch@lst.de>
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

HDIO_GETGEO has been around longer than XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 19 -------------------
 scrub/Makefile        |  4 ----
 scrub/disk.c          |  8 +-------
 5 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index ae95a3dab..e0713e9bc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,7 +182,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
 AC_CONFIG_UDEV_RULE_DIR
diff --git a/include/builddefs.in b/include/builddefs.in
index daee022e2..1cb07f379 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,7 +102,6 @@ HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
 HAVE_CROND = @have_crond@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 8a86bab5a..de64c9af7 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -177,25 +177,6 @@ test = mallinfo2();
     AC_SUBST(have_mallinfo2)
   ])
 
-#
-# Check if we have the HDIO_GETGEO ioctl
-#
-AC_DEFUN([AC_HAVE_HDIO_GETGEO],
-  [ AC_MSG_CHECKING([for struct hd_geometry ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <linux/hdreg.h>
-#include <sys/ioctl.h>
-	]], [[
-struct hd_geometry hdr;
-ioctl(0, HDIO_GETGEO, &hdr);
-	]])
-    ], have_hdio_getgeo=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_hdio_getgeo)
-  ])
-
 AC_DEFUN([AC_PACKAGE_CHECK_LTO],
   [ AC_MSG_CHECKING([if C compiler supports LTO])
     OLD_CFLAGS="$CFLAGS"
diff --git a/scrub/Makefile b/scrub/Makefile
index 2f123ef00..c11c2b5fe 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -98,10 +98,6 @@ CFILES += unicrash.c
 LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
 endif
 
-ifeq ($(HAVE_HDIO_GETGEO),yes)
-LCFLAGS += -DHAVE_HDIO_GETGEO
-endif
-
 LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
diff --git a/scrub/disk.c b/scrub/disk.c
index 0ec29d965..2cf84d918 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -11,9 +11,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include <scsi/sg.h>
-#ifdef HAVE_HDIO_GETGEO
-# include <linux/hdreg.h>
-#endif
+#include <linux/hdreg.h>
 #include "platform_defs.h"
 #include "libfrog/util.h"
 #include "libfrog/paths.h"
@@ -184,9 +182,7 @@ struct disk *
 disk_open(
 	const char		*pathname)
 {
-#ifdef HAVE_HDIO_GETGEO
 	struct hd_geometry	bdgeo;
-#endif
 	struct disk		*disk;
 	bool			suspicious_disk = false;
 	int			error;
@@ -218,7 +214,6 @@ disk_open(
 		error = ioctl(disk->d_fd, BLKBSZGET, &disk->d_blksize);
 		if (error)
 			disk->d_blksize = 0;
-#ifdef HAVE_HDIO_GETGEO
 		error = ioctl(disk->d_fd, HDIO_GETGEO, &bdgeo);
 		if (!error) {
 			/*
@@ -234,7 +229,6 @@ disk_open(
 				suspicious_disk = true;
 			disk->d_start = bdgeo.start << BBSHIFT;
 		} else
-#endif
 			disk->d_start = 0;
 	} else {
 		disk->d_size = disk->d_sb.st_size;
-- 
2.39.2

