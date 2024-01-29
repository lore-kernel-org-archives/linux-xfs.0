Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC9B4F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513602; cv=none; b=HGBSc6uiiRRnSs/OdPeo1tSWa/dZ3eDgG6pM9hUiEpu60PMV7vw6nOiFHvnZZkPJS7SyZB1/7ykZJOrO9hdUOgkNqKu4Sc7ZnmfhrVh/TlTvgxGvWCa0P67MyiiNa5vrq7W6SW9xYY87UpdAxussqRAlJ697QWsK8n/68BVvFC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513602; c=relaxed/simple;
	bh=6fpLLCiTmjs6UhwyCwvQdGtWkOx+5gIlRRztyi8J/7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FVbgCTq1iBwcnje2gWBs53+xdaVMpQUFX6wQ95vZ+k9oS0EZVCClNSRfv1dE340AK1Uz/hLWuNNtDp4nj7Lj73jtUt6MiG8shSMsvIJOYttmXgs/v38mC3OE6ARbt7JU47BRYVDRcReWe5iD4M1OgITRtl3yoqZ8/ZoAQ+t9f1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IkdNVGeT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IkdNVGeT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gmlEaZP3KwJyaA3jATfw/Jo7r9iml2fTZx6wo6dP8g8=; b=IkdNVGeTVGDohTLEnKrKQxbv6G
	813ucFK+AqHqbyaT6x4lha7UnvT7jkjqlLf8+8cwwfPHdTZ1dFqEiTHylWIouoxetU3BalQWvtjsP
	sYPMipw1uuPW1HgsLAP1UePHf7pgOUIPq5MR7DB6f44aSF7lAuaoH7RqB/BmsRPNs78SfPexBsjxw
	AMIUa1qtWDJcDmDu0Xlyeft+kAr/lKxzp7J2IOY8cZ2W4YRB6211Z7e+HW3kprJOoCHhpTvu18Lrr
	CO0giTPndL48HtXKccZaGFeO7iTCiiFviEujxdisFD2BUNIBRZQaDefWGrtJrFyN3TMqOZbRzDtNQ
	RYoDqoJA==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8u-0000000BcnS-3IJ9;
	Mon, 29 Jan 2024 07:33:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 24/27] configure: don't check for openat
Date: Mon, 29 Jan 2024 08:32:12 +0100
Message-Id: <20240129073215.108519-25-hch@lst.de>
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

openat has been supported since Linux 2.6.16 and glibc 2.4.

Note that xfs_db already uses it without the ifdef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 14 --------------
 scrub/Makefile        |  4 ++--
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0fa900d95..47531fce5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -181,7 +181,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
diff --git a/include/builddefs.in b/include/builddefs.in
index 0df78f933..c768d0411 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -101,7 +101,6 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index f29bdd76f..f857bcd94 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -157,20 +157,6 @@ test = mallinfo2();
     AC_SUBST(have_mallinfo2)
   ])
 
-#
-# Check if we have a openat call
-#
-AC_DEFUN([AC_HAVE_OPENAT],
-  [ AC_CHECK_DECL([openat],
-       have_openat=yes,
-       [],
-       [#include <sys/types.h>
-        #include <sys/stat.h>
-        #include <fcntl.h>]
-       )
-    AC_SUBST(have_openat)
-  ])
-
 #
 # Check if we have a fstatat call
 #
diff --git a/scrub/Makefile b/scrub/Makefile
index 846774619..1d613b946 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -6,11 +6,11 @@ TOPDIR = ..
 builddefs=$(TOPDIR)/include/builddefs
 include $(builddefs)
 
-SCRUB_PREREQS=$(HAVE_OPENAT)$(HAVE_FSTATAT)$(HAVE_GETFSMAP)
+SCRUB_PREREQS=$(HAVE_FSTATAT)$(HAVE_GETFSMAP)
 
 scrub_svcname=xfs_scrub@.service
 
-ifeq ($(SCRUB_PREREQS),yesyesyes)
+ifeq ($(SCRUB_PREREQS),yesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
-- 
2.39.2

