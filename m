Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3FB19644B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802334; cv=none; b=uyvE4Q+6io9OO8+2zgZ97MqHUcoBKv+QlhddVwO5BhtZ/hM0KKiL3RQUScFrAfRaAj3jcKpNW3d6ZXp9qgRedAMK9J1zuRq0URzpM/W876uobv9Mt6s0l5+TdHRLNB2lKW2P9vzQkOdZaGDI2HJSxg2Z/YlJrTI9TwF+KeGkYHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802334; c=relaxed/simple;
	bh=hsvMcPkJp1CDUAJvdI+82TgbsDsagQ6djNBxzTP19tg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DH1LzbgKhb4Pn7B128TRTANCqC2EMr8LfbARE3bWrQt9D4D0Wt8Ji5Pg1XZBQdprnmwRvBQQiacej57VsVXtwgPUS5DvZ0e4Xqi41yweZXMhUcvqk29RxfrcvtVgWtHI66dvl5m8YNeHZZWmg/X2n8IzoEaImQuwF6YfOPwH8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvIkVnJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvIkVnJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193A7C4AF16;
	Tue, 27 Aug 2024 23:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724802334;
	bh=hsvMcPkJp1CDUAJvdI+82TgbsDsagQ6djNBxzTP19tg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=BvIkVnJQzcEKCnq9LDkn8hX/Lkk6ZB3FrZj26Q9IWBVAjlEFdCIJxg4C9V4svuKD2
	 kWiwLOohzmtD57lPNufzUTh4lUGigWvUAF7cJtYaforgRgvMou+cr9VYxKgzPnBXlb
	 hB8oes4LxvZUzxiCcXUJltq/6RsfcPGoPfj7KRYK8Y8Sco95tcj/qVvUCSbYSx/Ggd
	 Pla1IGwwBw7CjJ3fL1rVWQq//AFVwBby3lUYTJ3tT5oDBzwoHM2Ks9HJdJcXWSxwVf
	 FmMfNYevermoD5cXsBTH5KaimQ+eWSRLcya5BVl6lQ5C/Oq7deyV0r0v0EgfaJaQrZ
	 wOqT3tcADOdJA==
Date: Tue, 27 Aug 2024 16:45:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: sam@gentoo.org, kernel@mattwhitlock.name, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: [RFC PATCH] libxfs: compile with a C++ compiler
Message-ID: <20240827234533.GE1977952@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Apparently C++ compilers don't like the implicit void* casts that go on
in the system headers.  Compile a dummy program with the C++ compiler to
make sure this works, so Darrick has /some/ chance of figuring these
things out before the users do.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac         |    1 +
 include/builddefs.in |    7 +++++++
 libxfs/Makefile      |    8 +++++++-
 libxfs/dummy.cpp     |   15 +++++++++++++++
 4 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 libxfs/dummy.cpp

diff --git a/configure.ac b/configure.ac
index 0ffe2e5dfc53..04544f85395b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -9,6 +9,7 @@ AC_PROG_INSTALL
 LT_INIT
 
 AC_PROG_CC
+AC_PROG_CXX
 AC_ARG_VAR(BUILD_CC, [C compiler for build tools])
 if test "${BUILD_CC+set}" != "set"; then
   if test $cross_compiling = no; then
diff --git a/include/builddefs.in b/include/builddefs.in
index 44f95234d21b..0f312b8b88fe 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -14,6 +14,7 @@ MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
+CXXFLAGS = @CXXFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
 BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
 
 # make sure we don't pick up whacky LDFLAGS from the make environment and
@@ -234,9 +235,15 @@ ifeq ($(ENABLE_GETTEXT),yes)
 GCFLAGS += -DENABLE_GETTEXT
 endif
 
+# Override these if C++ needs other options
+SANITIZER_CXXFLAGS = $(SANITIZER_CFLAGS)
+GCXXFLAGS = $(GCFLAGS)
+PCXXFLAGS = $(PCFLAGS)
+
 BUILD_CFLAGS += $(GCFLAGS) $(PCFLAGS)
 # First, Sanitizer, Global, Platform, Local CFLAGS
 CFLAGS += $(FCFLAGS) $(SANITIZER_CFLAGS) $(OPTIMIZER) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
+CXXFLAGS += $(FCXXFLAGS) $(SANITIZER_CXXFLAGS) $(OPTIMIZER) $(GCXXFLAGS) $(PCXXFLAGS) $(LCXXFLAGS)
 
 include $(TOPDIR)/include/buildmacros
 
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 1185a5e6cb26..bb851ab74204 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -125,6 +125,8 @@ CFILES = buf_mem.c \
 	xfs_trans_space.c \
 	xfs_types.c
 
+LDIRT += dummy.o
+
 #
 # Tracing flags:
 # -DMEM_DEBUG		all zone memory use
@@ -144,7 +146,11 @@ LTLIBS = $(LIBPTHREAD) $(LIBRT)
 # don't try linking xfs_repair with a debug libxfs.
 DEBUG = -DNDEBUG
 
-default: ltdepend $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY) dummy.o
+
+dummy.o: dummy.cpp
+	@echo "    [CXX]    $@"
+	$(Q)$(CC) $(CXXFLAGS) -c $<
 
 # set up include/xfs header directory
 include $(BUILDRULES)
diff --git a/libxfs/dummy.cpp b/libxfs/dummy.cpp
new file mode 100644
index 000000000000..a872c00ad84b
--- /dev/null
+++ b/libxfs/dummy.cpp
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "include/xfs.h"
+#include "include/handle.h"
+#include "include/jdm.h"
+
+/* Dummy program to test C++ compilation of user-exported xfs headers */
+
+int main(int argc, char *argv[])
+{
+	return 0;
+}
