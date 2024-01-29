Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D24F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513600; cv=none; b=raJV2SKrIRorVk4e45hcNpDMuDd7sjGiSmRqJZ95btnnnBl6UyOkbiaiscpHV9GKtG9SkFJfc/dittfpk1wf7UFWlbdUn7bAxFlu9qgsN2PdbwHVmKSRwCeSQXTfzyDYhQ5aZ09Kg/oBxZ03uhhF9YBBcEaJrqguVowxOfjmX0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513600; c=relaxed/simple;
	bh=WrIAQ81+uy5kmLm84OBXtUqfDrLmrfmZFYv+HxbjvCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gyMCdbOgQ8vPr1mB98DUbrKkHxfp+8Rj+Bv+KYMZ49H5WDyMbt4FlRDxJ70CWhMpkv8bs2+Aevpr0HbMoKevDpFc2p4UFb0hL2KE+e+sP+p8WZEbwpGvRBiQ9e90k/r4Wj+hp0rjku7uedMroqYGtUcPLLt9T1o8TrgY+vvi3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vy4TCKsO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vy4TCKsO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ITqqNiHf36uvjfgXAhuWTrJjDckFKkYySNCvLOBobOY=; b=vy4TCKsO0ptk0EAieUiI4I85eV
	j6Ksypi/f0R3tMHLI0XIMmV7vW9HIHbXU/r9KkNB8dMlRNmItD8JWAMsSXzF4e4FxDwhK8D8LQfjt
	mTXCwLiEsrSonYO9b3c8R9WB/EXK1ZGMzHF792gRhyqnetMW6tx7kWC7TCHkIRDFgtBU2f5cKQ16W
	N32ioLiCu+tUvTg8NXEoSndX4/FwYvMGHi9HVFtY7wtUgNZ9KAQulhatzvxbwRBbgg2jKxirvgiDT
	4K/BxrWec+slyeVAO0/yH4p0CDoq6jziHsSqepKV7jKrwXEibNYIHeNpUfbocQEqJgzphOcFxiqLj
	0yocZJEA==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8s-0000000Bcmu-12hS;
	Mon, 29 Jan 2024 07:33:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 23/27] configure: don't check for mallinfo
Date: Mon, 29 Jan 2024 08:32:11 +0100
Message-Id: <20240129073215.108519-24-hch@lst.de>
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

mallinfo has been supported since the beginning in glibc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 m4/package_libcdev.m4 | 20 --------------------
 scrub/Makefile        |  4 ----
 scrub/xfs_scrub.c     |  6 ------
 5 files changed, 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index 32efad760..0fa900d95 100644
--- a/configure.ac
+++ b/configure.ac
@@ -170,7 +170,6 @@ AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
 AC_HAVE_GETFSMAP
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
-AC_HAVE_MALLINFO
 AC_HAVE_MALLINFO2
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
diff --git a/include/builddefs.in b/include/builddefs.in
index c359cde45..0df78f933 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -98,7 +98,6 @@ NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
-HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 320809a62..f29bdd76f 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -137,26 +137,6 @@ int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
     AC_SUBST(have_map_sync)
   ])
 
-#
-# Check if we have a mallinfo libc call
-#
-AC_DEFUN([AC_HAVE_MALLINFO],
-  [ AC_MSG_CHECKING([for mallinfo ])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <malloc.h>
-	]], [[
-struct mallinfo test;
-
-test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
-test = mallinfo();
-	]])
-    ], have_mallinfo=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_mallinfo)
-  ])
-
 #
 # Check if we have a mallinfo2 libc call
 #
diff --git a/scrub/Makefile b/scrub/Makefile
index f3e22a9d6..846774619 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -81,10 +81,6 @@ LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBICU_LIBS) $(LIBRT) $(LIBURCU) \
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
-ifeq ($(HAVE_MALLINFO),yes)
-LCFLAGS += -DHAVE_MALLINFO
-endif
-
 ifeq ($(HAVE_MALLINFO2),yes)
 LCFLAGS += -DHAVE_MALLINFO2
 endif
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d64..736af2711 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -296,7 +296,6 @@ report_mem_usage(
 	const char			*phase,
 	const struct phase_rusage	*pi)
 {
-#if defined(HAVE_MALLINFO2) || defined(HAVE_MALLINFO)
 # ifdef HAVE_MALLINFO2
 	struct mallinfo2		mall_now = mallinfo2();
 # else
@@ -306,11 +305,6 @@ report_mem_usage(
 		phase,
 		kbytes(mall_now.arena), kbytes(mall_now.hblkhd),
 		kbytes(mall_now.uordblks), kbytes(mall_now.fordblks));
-#else
-	fprintf(stdout, _("%sMemory used: %lluk, "),
-		phase,
-		kbytes(((char *) sbrk(0)) - ((char *) pi->brk_start)));
-#endif
 }
 
 /* Report usage stats. */
-- 
2.39.2

