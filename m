Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17647C142
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980133; cv=none; b=Sf6GNz0072qA9+JP+1oCKYYPdGdlPESCMJ3DNArC4fqpGonjbvqHc5ENDwM13QIwmcTVcoxODM+FcQPCzzoYBas97rnTI0TP0T7nVFSjQ2Bw7NtZ4Bsfr06anAsqexMaqenoRRTQCFT96eD8T8Dazk0EAParhsAqy3oSQoDyNik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980133; c=relaxed/simple;
	bh=w9wgwzawgjAHqQBKZ6o0YprcW5gk6eubVffeLTWtTuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AxWgqedGlMdXxVID01vE+5ksn7FUqvyjJKe+LYYJaZdSOdzjr0nLemjc227H/V/iuArT+4zoXUbuzX8r8K044Nfe0jiF3QyhMZPOQu6RISE10FKSxH8At9qOeeasWgwdhKbmdOhBMyj1gUMOh8YFHELNuUmjUCwLGcMjL3mKWkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gQcgmQCM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gQcgmQCM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xjrQq4sK8MiYmBEuhsBKIXSoIvxV0XXEgYJzIW+6J7A=; b=gQcgmQCM8oKs8Q3epUCz1UCd7U
	vkYTlh7D2t5YrVv8R7D7CSIoVq0a1XzXpcnFyG7Yoxz+CoChMPqVEvkhe++MkkIlE4542bI7Vpg+/
	mwkxdDYX/e14gS/nLcA+lMXep1FmpvhCyZvZCDmT24T00ayLtkPn+SLrf1PwKB0GkoSgzffWTclgj
	KaF5ejFcvEMlVCTrWP2aD0FfsOAC4KUSt8SVyhQwTQmgzhYIrJtq0ixwHa8DEwZk4Tz6nsbKU6rkj
	js/NbiuoDn/sdvfHsQXIuEjwj0zxqeBYK2arjmofcujXl4kRvM4waDPGpKMnsbGdgsn271LW6FAJa
	0GoMwt3Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVed-0000000F9Q6-1S3H;
	Thu, 15 Feb 2024 06:55:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 24/26] configure: don't check for fstatat
Date: Thu, 15 Feb 2024 07:54:22 +0100
Message-Id: <20240215065424.2193735-25-hch@lst.de>
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

fstatat has been supported since Linux 2.6.16 and glibc 2.4.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 14 --------------
 scrub/Makefile        |  4 ++--
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index b0c76d619..94a4e7ee2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,7 +182,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
diff --git a/include/builddefs.in b/include/builddefs.in
index b050b6c49..000d09b68 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,7 +102,6 @@ HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 HAVE_SYSTEMD = @have_systemd@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 46abf7460..458081b90 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -177,20 +177,6 @@ test = mallinfo2();
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
index c6ca3cff7..dc6fadc91 100644
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

