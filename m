Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E64F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513592; cv=none; b=FdZEC4WKUcc1P6GGEwAHmT+5kBBj7hA+6akXfURRIFdy1SqoYHqQKyp7oWAMVC6B7lj+6RvnX9e1gUX7jlP9sP4m1eRf2K2ck4aPXDqjtwPWiDEC4uI5whlb6IsnkFN3MlMpvzhWZ4tuAbL7l9Lbv3eU1kgZYGFMwOBflbROmiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513592; c=relaxed/simple;
	bh=9kouTLmqoV6EB/RL/NaZT5gG+G/wySrtx4jDSSlLy10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HhnAp+oMnCzJRjUscAa5917Mjwxzfl/taf5YgZY6/bORlhcedHwXLOVP966WCwnayOaLrGiLyTodjncKdp5XW7dZ8wIH9Yl4nFwLM12vJ9fWyI7+t7nfsfddMxuHqkD0rnMinpQ/2z+/qoMk7JPYRSISxw4h7Ox57F8/pjV3dec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HfTQKNak; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HfTQKNak"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fXU9HtqqoHHQACjChsp17l79yf8UiZ5prKDKTTAUSic=; b=HfTQKNakDerOYBJBapx1VPXbj1
	rRpfLMW/H1EwP+fUAkS/YamWH75827R0+qH6hTTbefxpKiM/5DcmrA4Pda6lZD6HWRBHamqM3A+j+
	JyAFPeZDndY3hv1KcLPPWWk9royAxg/rfojXdaMX0us2XHa/NH3Me8XVjO6GV63RP7cmkESQ1wcnV
	P3YYf1Vun03QZgFwqC/ZuKSeUFCBpYlqcMjNYftkQCmVAyKF7vsyQm5vpl/5XOLLuFZlCkiJOBHQz
	IEPzxzSmZnMEouKfOI+RVOYxdkgL7pAmPQ96qOTtlD7+JR04GeUihb4h5Pg16MmRHHnRAUvgy6ZUF
	ch+2zc8Q==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8k-0000000Bckv-1uX4;
	Mon, 29 Jan 2024 07:33:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 20/27] configure: don't check for mremap
Date: Mon, 29 Jan 2024 08:32:08 +0100
Message-Id: <20240129073215.108519-21-hch@lst.de>
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

mremap has been around since before the dawn of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  4 ----
 io/mmap.c             |  8 --------
 m4/package_libcdev.m4 | 13 -------------
 5 files changed, 27 deletions(-)

diff --git a/configure.ac b/configure.ac
index a332b7694..dd000f11c 100644
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

