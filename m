Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFC8C127
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980136; cv=none; b=OqdokYEen8UjbU3SXDVm9PSp3IoCCEx8aEGjhio5X74UC7qf6eHQoFWf3cJPKStn1McCW7q4rKuCyHBN+Hj0liITlyhtYB80QNNbrwJ65GwrN1w0LygJJr/tzDL2R2oYoI2HyTb0P1Cr/RVzXgbCQplgwdzp9XJYPz9nC3NgMJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980136; c=relaxed/simple;
	bh=qp+OdIkseCjh8bkpneVC+xqVvG4uG9zRzV4bRMmd3G0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIb0eNN0KDtKNHg4itQrl6zIKHcOgN4PoKvZTJwaeiZOCtq+1gHNlt1MDSaftCnDjnEcS1z3z3ODnXRE8YKh3RwWnRPZBUmDnkfdEJrFK21bfDYN+R8fChlfaOC4Xkz31YXl8pKe6k8GIwHBOp6dzHGMPV7FvdyNX/sfGHtZus4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WdnWziML; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WdnWziML"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PLZj6JdDm1V3JX20FG01CDx5MM5Ih+xDCVlTVLKXmY0=; b=WdnWziML9gseHZpgR/pkDIsEE1
	bFYdFgpAOE3FnUOItqE8M86BdioCUxTYkpIiNV/r54oQcytZ+DChmEUXjS3VMnQK7RR350s8mJgNl
	Up2tMxvofek9pYXuxpCIVViCT/0n/TLzxy1kh9OR6zL8v+fPZ1d3jdbgqZTMnMiuEp5div9kforfs
	7OvudXAC9rG8Ezo9lhKYUZRk/AbtzyUU0WarJbIaryu5SQz643+vWeBAx6AzIRwQwsFUyTQqlcYm+
	Odr4qMX+aVvDNMKhZfFeftbeiUl52c5hteplhV/4UCPyBtjbp+TN+K9+Za9Ftda7nVFMmYIjlui//
	yjXzeg3A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeg-0000000F9RR-0E9D;
	Thu, 15 Feb 2024 06:55:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 25/26] configure: don't check for SG_IO
Date: Thu, 15 Feb 2024 07:54:23 +0100
Message-Id: <20240215065424.2193735-26-hch@lst.de>
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

SG_IO has been around longer than XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 19 -------------------
 scrub/Makefile        |  4 ----
 scrub/disk.c          | 22 ++++++++--------------
 5 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/configure.ac b/configure.ac
index 94a4e7ee2..ae95a3dab 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,7 +182,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
diff --git a/include/builddefs.in b/include/builddefs.in
index 000d09b68..daee022e2 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,7 +102,6 @@ HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 458081b90..8a86bab5a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -177,25 +177,6 @@ test = mallinfo2();
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
index dc6fadc91..2f123ef00 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -98,10 +98,6 @@ CFILES += unicrash.c
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

