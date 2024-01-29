Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7934F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513582; cv=none; b=GisEisvc3G/yLSHo8Qzxeml3oHYN3JkdoMLqXnVn0UFDnIejSx8JM04/UmN7p8j8L12wHPVEr/oQQilXm2S9ByLvj9Ed0ByUEevKI7zrYF3xGxGS0U6JAKsy/g8sAquhyQwrR2pUvtXe8F62+oODCllzaEV76O4KsdXZo1R4NOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513582; c=relaxed/simple;
	bh=7VHgjO+7HKrVjK2tRtth3Ide9ME3MFi1zEVSLgp+yBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=amACn/mkz7mGMFHH1BZZC1SF7a3IeU3rOswEShgtMbDtuJw3jK0jxq6k5WzX/5dnA98HtureR43sQoKGGx14GmYvUIhbeoETpXS1lmYclI4s/3PclnUA8Qr6tP8ZAfavdjstchBB2MEG/6xsJJIGyAnXl5pqLLnPSItDCJaEVDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R56OMdZk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R56OMdZk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GRjiRsgC6U3nnLSDHJTPyEd8vySwR6Lu54mGu8OdOkc=; b=R56OMdZkTqkRW9B30Tnn+ZIo5Q
	CbwOCNVsKBvmKBXIWd/1SL3zZZVQ3wwor68cdLD4nm0QrXCUGmkhncqZr8ZGSQE3nZq6HkBc236pr
	dlBqSqHf0nIxIZj1l+MIEzPbP2iIDxQpAlsoQxQrykDk+8raR/SQ2rHeIDkOelmQ2Vzgfb6UW+ksu
	n/+rihXSD4vG2eVz8ITiW2b+M/HrkUQhfQMqQXPQUlAi3kEtuKLIztqbYH61asfkuFNbRjSl2yl/U
	vV9L2poPl7TzSPYJQXhWPtIHr1Qml/V0X/zEHAn5+chOu9AOZYDRtQbqtNulDu+Wk7MafQy8YbpoN
	Fv/sTbNg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8Z-0000000Bchn-3lI5;
	Mon, 29 Jan 2024 07:33:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/27] configure: don't check for fls
Date: Mon, 29 Jan 2024 08:32:04 +0100
Message-Id: <20240129073215.108519-17-hch@lst.de>
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

fls should never be provided by system headers.  It seems like on MacOS
it did, but as we're not supporting MacOS anymore there is no need to
check for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/bitops.h      |  2 --
 include/builddefs.in  |  4 ----
 m4/package_libcdev.m4 | 12 ------------
 4 files changed, 19 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6510a4fb3..abedaacf2 100644
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

