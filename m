Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB14F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513608; cv=none; b=n9haQHonGbwmfTgWoZYl0zp4k54HHBAIPewVgOiRwrY91qnRFLm1OsZO+r7y9jL9LS8AZeebotKmo8eEC73yLT4rIzgtnn21kr+oe+KgZ6lgGZ04thnBd5fFRQDVaKEcdKqpRZlZF9rfqGp4A5IFigi+fgcSwPDVKIN4PGcpnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513608; c=relaxed/simple;
	bh=tp2Ok3VcRvfKj1bI/lGbr/iCRY3XThA5iO5XOJvDYOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d6bys7/gpGg606ZzD4Ip8oFy7xkeMvjm7wwBcS8G7UmyZW5tDSH/qDoUPQdyLh/x/kWLk36JO5Be2o6DsOyMotWhivQ+an/YzykCPgTPYKiaIXq9IUVjE/jdky6EsHGIjhNpCCrCC+5pONzurCUXPzACu5zz1bCD3SgmhRwrt8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FM4kFzmc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FM4kFzmc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oauDdpBD+5g6zaodaUcu+y0ggYivRiiiulafYAhqC/c=; b=FM4kFzmc5U5FwOMd+dJlCRlJPE
	DOm+CH8uPOGAGadfoiW+EHOTJF411CC85h78zxxU5JTLbrKRYIndSCHZY/S9AAZwhLqUi4yYef2gL
	iocLVwxgpS3r/JEapGJEP8sJ6N1ga8vM3QyAPL3qa5wSPZ7fJ2sP5m0I7KMwrUIQd6xgElf5tm/ml
	kTIBbEHPAMb/WV8/0hQd62uEZdaq9E16Q/ixn8tDDXFhvdjBCJy1j08RDjdwSSkD08uvF2+LXDLU1
	y6bzqFY7A8Xryccy/5md6sCWJCMlR9XXwrhVlkD036o26K7u9IgrrUx7qqxAbWk7kN9sHAu8yGoxd
	B4rMHctg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8z-0000000BcoC-40dk;
	Mon, 29 Jan 2024 07:33:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 26/27] configure: don't check for SG_IO
Date: Mon, 29 Jan 2024 08:32:14 +0100
Message-Id: <20240129073215.108519-27-hch@lst.de>
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

SG_IO has been around longer than XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 19 -------------------
 scrub/Makefile        |  4 ----
 scrub/disk.c          | 22 ++++++++--------------
 5 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/configure.ac b/configure.ac
index 260772a6b..db967055b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -181,7 +181,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
diff --git a/include/builddefs.in b/include/builddefs.in
index e02600f09..61981fc6a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -101,7 +101,6 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 0ff05a04b..a85894a11 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -157,25 +157,6 @@ test = mallinfo2();
     AC_SUBST(have_mallinfo2)
   ])
 
-#
-# Check if we have the SG_IO ioctl
-#
-AC_DEFUN([AC_HAVE_SG_IO],
-  [ AC_MSG_CHECKING([for struct sg_io_hdr ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <scsi/sg.h>
-#include <sys/ioctl.h>
-	]], [[
-struct sg_io_hdr hdr;
-ioctl(0, SG_IO, &hdr);
-	]])
-    ], have_sg_io=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_sg_io)
-  ])
-
 #
 # Check if we have the HDIO_GETGEO ioctl
 #
diff --git a/scrub/Makefile b/scrub/Makefile
index 4eac20a13..f9dfb016f 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -94,10 +94,6 @@ CFILES += unicrash.c
 LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
 endif
 
-ifeq ($(HAVE_SG_IO),yes)
-LCFLAGS += -DHAVE_SG_IO
-endif
-
 ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
diff --git a/scrub/disk.c b/scrub/disk.c
index addb964d7..0ec29d965 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -10,9 +10,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#ifdef HAVE_SG_IO
-# include <scsi/sg.h>
-#endif
+#include <scsi/sg.h>
 #ifdef HAVE_HDIO_GETGEO
 # include <linux/hdreg.h>
 #endif
@@ -90,14 +88,13 @@ disk_heads(
  * works if we're talking to a raw SCSI device, and only if we trust the
  * firmware.
  */
-#ifdef HAVE_SG_IO
-# define SENSE_BUF_LEN		64
-# define VERIFY16_CMDLEN	16
-# define VERIFY16_CMD		0x8F
-
-# ifndef SG_FLAG_Q_AT_TAIL
-#  define SG_FLAG_Q_AT_TAIL	0x10
-# endif
+#define SENSE_BUF_LEN		64
+#define VERIFY16_CMDLEN	16
+#define VERIFY16_CMD		0x8F
+
+#ifndef SG_FLAG_Q_AT_TAIL
+# define SG_FLAG_Q_AT_TAIL	0x10
+#endif
 static int
 disk_scsi_verify(
 	struct disk		*disk,
@@ -167,9 +164,6 @@ disk_scsi_verify(
 
 	return blockcount << BBSHIFT;
 }
-#else
-# define disk_scsi_verify(...)		(ENOTTY)
-#endif /* HAVE_SG_IO */
 
 /* Test the availability of the kernel scrub ioctl. */
 static bool
-- 
2.39.2

