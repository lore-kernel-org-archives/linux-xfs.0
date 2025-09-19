Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337B831D73B
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298443; cv=none; b=W1ceq60Mt6iqP6HbKQ5EdY44oBESAORakvkzwqDSt5l1sYkLzd1JcGXMIFEdXSpdJPFfT9r5LhSaYNtJl6Zrk8j2dKdjgm7+CAQHEbAzrQqAj9DF/5NU/MMwYrvp1iH0LUHmWZIXVi2bHQ00QpKlS4iuKCm8eWS9njHjFoZ0A2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298443; c=relaxed/simple;
	bh=1MJq8iDq/8Q5uDNst3b/5Vjx/YjlTCEyzafJcffpjZM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=A0zupwm4Y+hoVtKCy9H3s3XoujKWis8qYqMx4L3WcnqGCkz629RfFJe2Bsp2Qdw0cSrslK64hKGrKemBxLIiq2wcpQTD+ktl4w1czmHW6YM4ebcc9V/3pFj7lbVduxfk7lionKFqdpRHvv7tIwc4sOXx8H1LlnR5dcdS0erUoGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOojviMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOojviMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7FBC4CEF0;
	Fri, 19 Sep 2025 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298440;
	bh=1MJq8iDq/8Q5uDNst3b/5Vjx/YjlTCEyzafJcffpjZM=;
	h=Date:From:To:Cc:Subject:From;
	b=XOojviMsagxTyKLp+EX0MD4/uCeqWK1Ouep2UoCZnXByNxl4IAQAhpekBXZnNCQjn
	 7ig3CC7Ri86ChOKQW2IWgr2dpCR0B5MgoQZmolQaKgfVCvvW6nvjNmaT0JobjKI2s4
	 2yO6le4hSREM5jswSOUGKBzmDXhjtHTS5+GhwzOlT3ARgsFPvxt/dzIN93WaYPqBIW
	 2eyIfdWw3PVoRhaGXQaPHF4bpvGgpF46T0MNfH1RhhFscjigB4aF1tvwkqVtm9BVTH
	 DCcXinKJlfD7WPl+5S2+LI9cPBL3UNI/qvOD1N2zjuzFDME1MJLXOYpsxq/4L1B0F/
	 S8+gHurgiRlCg==
Date: Fri, 19 Sep 2025 09:14:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: "A. Wilcox" <AWilcox@wilcox-tech.com>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <20250919161400.GO8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

In commit 75faf2bc907584, someone tried to fix scrub to use the POSIX
version of strerror_r so that the build would work with musl.
Unfortunately, neither the author nor myself remembered that GNU libc
imposes its own version any time _GNU_SOURCE is defined, which
builddefs.in always does.  Regrettably, the POSIX and GNU versions have
different return types and the GNU version can return any random
pointer, so now this code is broken on glibc.

"Fix" this standards body own goal by casting the return value to
intptr_t and employing some gross heuristics to guess at the location of
the actual error string.

Fixes: 75faf2bc907584 ("xfs_scrub: Use POSIX-conformant strerror_r")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v2: go the autoconf route
---
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 m4/package_libcdev.m4 |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 scrub/Makefile        |    4 ++++
 scrub/common.c        |    8 ++++++--
 5 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index d2407cb5de5af2..df19379b02ba55 100644
--- a/configure.ac
+++ b/configure.ac
@@ -183,6 +183,7 @@ AC_CONFIG_CROND_DIR
 AC_CONFIG_UDEV_RULE_DIR
 AC_HAVE_BLKID_TOPO
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
+AC_STRERROR_R_RETURNS_STRING
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index 93b5c75155c0f4..5aa5742bb31b9e 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -241,6 +241,7 @@ CROND_DIR = @crond_dir@
 HAVE_UDEV = @have_udev@
 UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
+STRERROR_R_RETURNS_STRING = @strerror_r_returns_string@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall -Werror -Wextra -Wno-unused-parameter
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index ce1ba47264659c..c5538c30d2518a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -301,3 +301,49 @@ syscall(__NR_file_getattr, 0, 0, 0, 0, 0);
        AC_MSG_RESULT(no))
     AC_SUBST(have_file_getattr)
   ])
+
+#
+# Check if strerror_r returns an int, as opposed to a char *, because there are
+# two versions of this function, with differences that are hard to detect.
+#
+# GNU strerror_r returns a pointer to a string on success, but the returned
+# pointer might point to a static buffer and not buf, so you have to use the
+# return value.  The declaration has the __warn_unused_result__ attribute to
+# enforce this.
+#
+# XSI strerror_r always writes to buf and returns 0 on success, -1 on error.
+#
+# How do you select a particular version?  By defining macros, of course!
+# _GNU_SOURCE always gets you the GNU version, and _POSIX_C_SOURCE >= 200112L
+# gets you the XSI version but only if _GNU_SOURCE isn't defined.
+#
+# The build system #defines _GNU_SOURCE unconditionally, so when compiling
+# against glibc we get the GNU version.  However, when compiling against musl,
+# the _GNU_SOURCE definition does nothing and we get the XSI version anyway.
+# Not definining _GNU_SOURCE breaks the build in many areas, so we'll create
+# yet another #define for just this weird quirk so that we can patch around it
+# in the one place we need it.
+#
+# Note that we have to force erroring out on the int conversion warnings
+# because C doesn't consider it a hard error to cast a char pointer to an int
+# even when CFLAGS contains -std=gnu11.
+AC_DEFUN([AC_STRERROR_R_RETURNS_STRING],
+  [AC_MSG_CHECKING([if strerror_r returns char *])
+    OLD_CFLAGS="$CFLAGS"
+    CFLAGS="$CFLAGS -Wall -Werror"
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <string.h>
+  ]], [[
+char buf[1024];
+puts(strerror_r(0, buf, sizeof(buf)));
+  ]])
+    ],
+       strerror_r_returns_string=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    CFLAGS="$OLD_CFLAGS"
+    AC_SUBST(strerror_r_returns_string)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index 3636a47942e98e..6375d77a291bcb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -105,6 +105,10 @@ CFILES += unicrash.c
 LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
 endif
 
+ifeq ($(STRERROR_R_RETURNS_STRING),yes)
+LCFLAGS += -DSTRERROR_R_RETURNS_STRING
+endif
+
 # Automatically trigger a media scan once per month
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
 
diff --git a/scrub/common.c b/scrub/common.c
index 9437d0abb8698b..9a33e2a9d54ed4 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -126,8 +126,12 @@ __str_out(
 	fprintf(stream, "%s%s: %s: ", stream_start(stream),
 			_(err_levels[level].string), descr);
 	if (error) {
-		strerror_r(error, buf, DESCR_BUFSZ);
-		fprintf(stream, _("%s."), buf);
+#ifdef STRERROR_R_RETURNS_STRING
+		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
+#else
+		if (strerror_r(error, buf, DESCR_BUFSZ) == 0)
+			fprintf(stream, _("%s."), buf);
+#endif
 	} else {
 		va_start(args, format);
 		vfprintf(stream, format, args);
