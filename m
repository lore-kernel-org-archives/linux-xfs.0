Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767E84F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513610; cv=none; b=ZmTPWDPGsELfk96eWXhp4QOwZ2mAtw4qHTW4IBP7u9YHLVnyA1CmS/In1Jw2yHUotYXhl9NW4tKoTyYAC6OpOWckVyReKaLz+de8lKa2GMJno7H0oAm0d0jl2Te9BClVihytCzaTOe2n/i2et0tkZRVuVEu++RpoZxOQ18T+uQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513610; c=relaxed/simple;
	bh=rGjyz5Pkso2pmdDDGCAbER95lA/4ipIWAj1zdvuOmog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hVOFPyvqCi/crDWCusc7F7KS4M2WsXyX6FM4lTv0yHIhuYrQ963B2JipcfsmbXO4+1pTwcFSJvPSpliQOlfp3Ea8aSm+QGOnSeWOYYaRtsPmVoxpCjJwywVixh/BrGXire+fFvFwX7v/BBRRAOHbQlw3+KJ0YEcis3Q2QuUkkLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L7jDEpZu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L7jDEpZu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zVVK8Ny+xiNjovuwamKXIm4FOIYN8/+5Yibplxr7N6s=; b=L7jDEpZu99du02pnQTMdFypEt+
	jpzL2j13rZ4eQmNnAJk9TNv2V64TtEvvdUaDfBpAMu1VlyXIO+E7NXXLF7wtHK22EWh2eb6A57KQk
	WOvhcUkCOkeG2L9ia1xCv8YqE2S+Xx0yPbBXCuSBJpVF26NppW0ph3f9Wwi/wNRkV2aoclchiiKl+
	g6LxjpnJYXB9/La/jzQA86h3RvvQfpsFVu++i+kWvoW6m1Ustgnd5pqdB4RTBJgVLh5zkLPnRV8wS
	t1NmJ/rTxrGlz+W7JV+LNazCt+qhWBqisS72ysyCC+azKwfah7jqwyJFNuRWn0Ep7PYfjhY+ut/Kb
	SRAJuUVQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM92-0000000Bcp3-367J;
	Mon, 29 Jan 2024 07:33:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 27/27] configure: don't check for HDIO_GETGEO
Date: Mon, 29 Jan 2024 08:32:15 +0100
Message-Id: <20240129073215.108519-28-hch@lst.de>
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

HDIO_GETGEO has been around longer than XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 19 -------------------
 scrub/Makefile        |  4 ----
 scrub/disk.c          |  8 +-------
 5 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index db967055b..d85a6e774 100644
--- a/configure.ac
+++ b/configure.ac
@@ -181,7 +181,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
 AC_CONFIG_UDEV_RULE_DIR
diff --git a/include/builddefs.in b/include/builddefs.in
index 61981fc6a..aa69859c0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -101,7 +101,6 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
 HAVE_CROND = @have_crond@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index a85894a11..13dcdec1b 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -157,25 +157,6 @@ test = mallinfo2();
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
index f9dfb016f..9bb485f91 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -94,10 +94,6 @@ CFILES += unicrash.c
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

