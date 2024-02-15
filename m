Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F140D527
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980130; cv=none; b=hfucCbj5XE5PVchxTV5dOfDbMK1SmsK9pUZH/g3HWFPvVDl3vOxwuDlOdmr66gEree5l8OzuARydWcQsau6+qtdPjs34tVi3kL1WCtn68Uhdb7TaHn9fLGW/ql8Lqhe2R1OoOBXffdcEGlRzgeJIJ8+rJzNZNO6Hhn5XZkiYpaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980130; c=relaxed/simple;
	bh=Mu2WR1RQLUwgjcaXWwqcIOAC4QjiphNU1uZAb2uPZdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WGwbSa8N3ewdL8zIC0fhZNDWfMdJpbSUQuC5y1IEx+4R3t1PTGDJHK4ij9WC262cBjlBr1Rz9Qs9DDc7OmX6Pkg41p2BT0Bf6xMVAlTP8aM3hexH2rwyQ1uRvyFzbkBsKQqRK/5D00XFc7ac0V8/tK9zom6qRQrDypvSP2Tl07g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EK1x4CnW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EK1x4CnW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ylkOlByeheq0dvQXAPzfebMRw2v6lQrKtT+1EN59cY0=; b=EK1x4CnWUicEpslnuc5W6Ffjr1
	fjkA3pnVkCQTelHA6AQA6YmeCg6S8QEBGXXiI7lBHX8xSACVXnkhzkQiczvTjgx15wZDOxWexezST
	uvs3VFpVE6mgSCU7EG3aPPmiVXA8RnY4ALgUB7EnntRt+/bYdHLukJ9FQXy4Lo169t4RNp/tcc2mI
	HNyW+Vsp6KpnYZxwZSr1KPti3OjPIXEqntOTaKxBgCy+vM9ABzDRb02DpFECdagIfj4zf5fpHiOqO
	aT+L0eyv74UeC0c7xK1XdgcS/yXrgzxHDekkQvPe42c2bz8j5O+FsqeWLDXOFuH+Rj9NRGlBbMq3Y
	Jl5vO84A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVea-0000000F9P4-2VkW;
	Thu, 15 Feb 2024 06:55:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 23/26] configure: don't check for openat
Date: Thu, 15 Feb 2024 07:54:21 +0100
Message-Id: <20240215065424.2193735-24-hch@lst.de>
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

openat has been supported since Linux 2.6.16 and glibc 2.4.

Note that xfs_db already uses it without the ifdef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 14 --------------
 scrub/Makefile        |  4 ++--
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index a967322cf..b0c76d619 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,7 +182,6 @@ if test "$enable_scrub" = "yes"; then
                 AC_MSG_ERROR([libicu not found.])
         fi
 fi
-AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
diff --git a/include/builddefs.in b/include/builddefs.in
index c359cde45..b050b6c49 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,7 +102,6 @@ HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
-HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 320809a62..46abf7460 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -177,20 +177,6 @@ test = mallinfo2();
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
index f3e22a9d6..c6ca3cff7 100644
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

