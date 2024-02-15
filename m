Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42B0D272
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980113; cv=none; b=u7Cux1epUyo45p8sNyu+93FhFMaj94BJ4UFo4/ivTxve2PIaOmiO/dyRseHnE3LmaxYvM5jO4eyO0Rj6Ij/CQoYc3W386ip67MEw5rkU7/fSJkYfZ5yS5NWvNyhTYcphi/UzWewru9IOZkxJsBpl3d+Tc7WlP4+cX5WnIUkujnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980113; c=relaxed/simple;
	bh=JqH9W2NEiaWMzQLxLp5CObTkslXfMOPvgjhrm5WM3b4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YzKluugGDfnh9axJALvI0CWv9Yxw6u1MOKz2eUPyWF1M0cIlZ5/rNqc8rXMB0Y7YwKCPzoGa3jlq13sp8q45mCm0hv1We2Kvt7FSxpEX9Jl7ngA70eSrfl6xpuxBeH6Fhs0EYM4kUa1gW8+VdHHK6KreX5WgQnSCOfbHjAGaJ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q5rTvpwl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q5rTvpwl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hX+4X1GXSTFLYM9jpsAhSk7dZfO2cQxRt30y4AI7Kvs=; b=q5rTvpwlnnxycb3MT4yL75lV+v
	avbl7C5zooVwTNk5FYCIxl5w6T0kJ0hBmZFR5FCP/3WN6rbStqQa9QPk7jnogA1G3bgn8w3me1V1D
	YBT1STiI0otZ8L2DjAG40YCwZsqk9RhynazVsGPG1004EAUK9cqP91pZOzkA99g0HNHhmCWtaSrcY
	JAcwXha6AdfsILIQqtatj0OEOfy0J2Ma7b1G0XFs1uHAHzgT8sEs4aJabiKE2xA2jqe33PH4DIesX
	oh8raWZTUMmp0GNz+zKB56eJeDtOC2QdoQjMkV23G3rwRnubdqZfp8YcW2CIdZvFKbC7442jfw3Jp
	TXqT8mQA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeJ-0000000F9Je-0p9O;
	Thu, 15 Feb 2024 06:55:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 16/26] configure: don't check for fls
Date: Thu, 15 Feb 2024 07:54:14 +0100
Message-Id: <20240215065424.2193735-17-hch@lst.de>
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

fls should never be provided by system headers.  It seems like on MacOS
it did, but as we're not supporting MacOS anymore there is no need to
check for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/bitops.h      |  2 --
 include/builddefs.in  |  4 ----
 m4/package_libcdev.m4 | 12 ------------
 4 files changed, 19 deletions(-)

diff --git a/configure.ac b/configure.ac
index 68d50e2d2..79fb475f7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,7 +167,6 @@ AC_HAVE_PWRITEV2
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNCFS
-AC_HAVE_FLS
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
diff --git a/include/bitops.h b/include/bitops.h
index fe6173039..1f1adcecc 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -6,7 +6,6 @@
  * fls: find last bit set.
  */
 
-#ifndef HAVE_FLS
 static inline int fls(int x)
 {
 	int r = 32;
@@ -34,7 +33,6 @@ static inline int fls(int x)
 	}
 	return r;
 }
-#endif /* HAVE_FLS */
 
 static inline int fls64(__u64 x)
 {
diff --git a/include/builddefs.in b/include/builddefs.in
index 4951ae9d9..47ac7173c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -95,7 +95,6 @@ HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNCFS = @have_syncfs@
-HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
@@ -127,9 +126,6 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 # _LGPL_SOURCE is for liburcu to work correctly with GPL/LGPL programs
 PCFLAGS = -D_LGPL_SOURCE -D_GNU_SOURCE $(GCCFLAGS)
 DEPENDFLAGS = -D__linux__
-ifeq ($(HAVE_FLS),yes)
-LCFLAGS+= -DHAVE_FLS
-endif
 ifeq ($(HAVE_MNTENT),yes)
 PCFLAGS+= -DHAVE_MNTENT
 endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 25d869841..17319bb23 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -91,18 +91,6 @@ syncfs(0);
     AC_SUBST(have_syncfs)
   ])
 
-#
-# Check if we have a flc call (Mac OS X)
-#
-AC_DEFUN([AC_HAVE_FLS],
-  [ AC_CHECK_DECL([fls],
-       have_fls=yes,
-       [],
-       [#include <string.h>]
-       )
-    AC_SUBST(have_fls)
-  ])
-
 #
 # Check if we have a fsetxattr call
 #
-- 
2.39.2

