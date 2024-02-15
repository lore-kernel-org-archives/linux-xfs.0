Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348F9475
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980123; cv=none; b=e0uX/qaNPcJ/b8Nq8iDQpW5K8ns8alz1em8XfKmBopiD3eOQ0dbxJo7P0+A6qT+5eoKMK0ZhncDZbMSU8EDFwhpqq1jUtO9aPNFOev978i4YlDNAEHfpBe9HYUTHLROYt1xTHAZ2Hdp6gjZsQypbVPUjX5yFlEzpofC7uHJSgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980123; c=relaxed/simple;
	bh=E9lrp9CmdaSKLGMmLKiKA0+Z5/xrkYjKMrvwJ7D2Kbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jijM6dafgIwzpv8x8mcphB144i8aXsIzd/lpYfdIe96jK4VJmNU69luL6dO5TQEauGPMyccnL9kloBmmHoV1qm29TiAn7k92HCbLZ0XN8GHicpWzwuZqKtEgUUEUtWT90MXvgI6MYb/cBE//BRgtbFMk2NsNFD2f/LPwVImdHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zXHyE8vf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zXHyE8vf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ivc/Q6wtYRTykF+MW0Bai6xP+FJehWHLRtV6t4Enh7c=; b=zXHyE8vf1sdLDCduQXv3njiHSF
	I0p4zMvQFYKgwF6qQmpKUGVHTOii5WmjM88jblV4IRs8uPKlDjXe0ADopCBbaEt4zwWMwITRhTWXW
	7OvTm6toJnwUM02wf+3+rL3+N2gR56Y1eBsgVh6P5qkrnR7ChQgNha8kxkMd+wYPG//iKEjVS3ZtT
	n9QIZVhGrXLQgQEV225l8VEM++SAfcskTYvcBHUk91KAQtyYrK9F0/RQEKNYTZwU8uEWV5x8SfZbj
	heq5HqqqAAZz7LjDJa0ZSpP2Atzp1rK7dbogk9/PQSp8ehssZgkQdV19cDhROuZvqU2NNpFeqBc5y
	apZhzrCw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeT-0000000F9MM-0tZD;
	Thu, 15 Feb 2024 06:55:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 20/26] configure: don't check for mremap
Date: Thu, 15 Feb 2024 07:54:18 +0100
Message-Id: <20240215065424.2193735-21-hch@lst.de>
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

mremap has been around since before the dawn of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  4 ----
 io/mmap.c             |  8 --------
 m4/package_libcdev.m4 | 13 -------------
 5 files changed, 27 deletions(-)

diff --git a/configure.ac b/configure.ac
index 66feba8f7..296eb3c1f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -165,7 +165,6 @@ AC_PACKAGE_NEED_RCU_INIT
 AC_HAVE_PWRITEV2
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_FSETXATTR
-AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
diff --git a/include/builddefs.in b/include/builddefs.in
index 0e0f26144..4b55f97cd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -93,7 +93,6 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_FSETXATTR = @have_fsetxattr@
-HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
diff --git a/io/Makefile b/io/Makefile
index a81a75fc8..35b3ebd52 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -33,10 +33,6 @@ ifeq ($(HAVE_PWRITEV2),yes)
 LCFLAGS += -DHAVE_PWRITEV2
 endif
 
-ifeq ($(HAVE_MREMAP),yes)
-LCFLAGS += -DHAVE_MREMAP
-endif
-
 ifeq ($(HAVE_MAP_SYNC),yes)
 LCFLAGS += -DHAVE_MAP_SYNC
 endif
diff --git a/io/mmap.c b/io/mmap.c
index 425957d4b..c3bb211a8 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -16,9 +16,7 @@ static cmdinfo_t mread_cmd;
 static cmdinfo_t msync_cmd;
 static cmdinfo_t munmap_cmd;
 static cmdinfo_t mwrite_cmd;
-#ifdef HAVE_MREMAP
 static cmdinfo_t mremap_cmd;
-#endif /* HAVE_MREMAP */
 
 mmap_region_t	*maptable;
 int		mapcount;
@@ -636,7 +634,6 @@ mwrite_f(
 	return 0;
 }
 
-#ifdef HAVE_MREMAP
 static void
 mremap_help(void)
 {
@@ -712,7 +709,6 @@ mremap_f(
 	mapping->length = new_length;
 	return 0;
 }
-#endif /* HAVE_MREMAP */
 
 void
 mmap_init(void)
@@ -769,7 +765,6 @@ mmap_init(void)
 		_("writes data into a region in the current memory mapping");
 	mwrite_cmd.help = mwrite_help;
 
-#ifdef HAVE_MREMAP
 	mremap_cmd.name = "mremap";
 	mremap_cmd.altname = "mrm";
 	mremap_cmd.cfunc = mremap_f;
@@ -780,14 +775,11 @@ mmap_init(void)
 	mremap_cmd.oneline =
 		_("alters the size of the current memory mapping");
 	mremap_cmd.help = mremap_help;
-#endif /* HAVE_MREMAP */
 
 	add_command(&mmap_cmd);
 	add_command(&mread_cmd);
 	add_command(&msync_cmd);
 	add_command(&munmap_cmd);
 	add_command(&mwrite_cmd);
-#ifdef HAVE_MREMAP
 	add_command(&mremap_cmd);
-#endif /* HAVE_MREMAP */
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7d7679fa0..dd04be5f0 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -48,19 +48,6 @@ AC_DEFUN([AC_HAVE_FSETXATTR],
     AC_SUBST(have_fsetxattr)
   ])
 
-#
-# Check if we have a mremap call (not on Mac OS X)
-#
-AC_DEFUN([AC_HAVE_MREMAP],
-  [ AC_CHECK_DECL([mremap],
-       have_mremap=yes,
-       [],
-       [#define _GNU_SOURCE
-        #include <sys/mman.h>]
-       )
-    AC_SUBST(have_mremap)
-  ])
-
 #
 # Check if we need to override the system struct fsxattr with
 # the internal definition.  This /only/ happens if the system
-- 
2.39.2

