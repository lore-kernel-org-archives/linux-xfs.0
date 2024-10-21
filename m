Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4F31E25F3
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 21:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729547967; cv=none; b=YklVJmeBNOzy4e3DlUGcsE6i2KGkQZIkaGpSGxTSi+FPjfLq56p9q0Q8WzRZvRRyJNFZWSI+lJsOZ1kkZ6B30ZMsAwP/nlWWXj7HiKbshTMOybkD87yqQdyScTpM2aVmm/y4ESnRtsbD7/+c1Ywsz0g7zJXFr/6IqE8s+0z4If4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729547967; c=relaxed/simple;
	bh=O4sbKkydiEx+d2vw5ow4wTV+Jb4CRQxlaMzX7rb4Ur8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cTB7ufkzzzto1xkme0R8DzGmBj4bCjC/cgxEXK7kWVNNTf985lzndHD4Hz0edrpOMJalT8C5I4x553U3Kwfb2XsXUugFKJwnvdgVPKMvKicnv4UT1CoaZ7CzMgsllM6kNaGINLKMtJ9FPShrsvwU2RMsqfq0G3jjpAeSFyxe3sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+VlYv0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+VlYv0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9AEC4CEE6;
	Mon, 21 Oct 2024 21:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729547967;
	bh=O4sbKkydiEx+d2vw5ow4wTV+Jb4CRQxlaMzX7rb4Ur8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b+VlYv0Msa4BlLWCOLQ86amKDdWbkTGeic7gq0MrmziYRZEMtT9auReNkYijZVCCh
	 otj+uNKGFrEXCtvo63ywH1JY75lgAwPQwkrg4fNV/E1sgqRm4n3S/z8zvALLiVw3VF
	 aFJ6ezubGCBCMl8fdOzSPvAaW286Jll47hDv6w0hnqfTdfq0LEpVYgYDm7+cbxLLoG
	 uUgnRp3lCSV39rYytefa86eO/hRiMvi42CIUMUBOf2npJdXCka4Mve+sXkHfbvzE9o
	 IBU4BZfoB0Qc+ztY51pMAX9sHEI67blwvvJb9NCV12V+pl6YTGvq7xgx7Hrp2SvlaH
	 qEzghrtO9bD1w==
Date: Mon, 21 Oct 2024 14:59:27 -0700
Subject: [PATCH 02/37] libxfs: compile with a C++ compiler
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783502.34558.4926204658396667428.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Apparently C++ compilers don't like the implicit void* casts that go on
in the system headers.  Compile a dummy program with the C++ compiler to
make sure this works.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Sam James <sam@gentoo.org>
Reviewed-by: Sam James <sam@gentoo.org>
---
 configure.ac               |    6 ++++++
 include/builddefs.in       |    8 ++++++++
 libxfs/Makefile            |   31 ++++++++++++++++++++++++++++++-
 libxfs/ioctl_c_dummy.c     |   11 +++++++++++
 libxfs/ioctl_cxx_dummy.cpp |   13 +++++++++++++
 m4/package_utilies.m4      |    5 +++++
 6 files changed, 73 insertions(+), 1 deletion(-)
 create mode 100644 libxfs/ioctl_c_dummy.c
 create mode 100644 libxfs/ioctl_cxx_dummy.cpp


diff --git a/configure.ac b/configure.ac
index b75f7d9e7563b2..dc587f39b80533 100644
--- a/configure.ac
+++ b/configure.ac
@@ -9,6 +9,9 @@ AC_PREFIX_DEFAULT(/usr)
 if test "${CFLAGS+set}" != "set"; then
 	CFLAGS="-g -O2 -std=gnu11"
 fi
+if test "${CXXFLAGS+set}" != "set"; then
+	CXXFLAGS="-g -O2 -std=gnu++11"
+fi
 
 AC_PROG_INSTALL
 LT_INIT
@@ -31,6 +34,9 @@ if test "${BUILD_CFLAGS+set}" != "set"; then
   fi
 fi
 
+AC_PROG_CXX
+# no C++ build tools yet
+
 AC_ARG_ENABLE(shared,
 [  --enable-shared=[yes/no]  Enable use of shared libraries [default=yes]],,
 	enable_shared=yes)
diff --git a/include/builddefs.in b/include/builddefs.in
index c8c7de7fd2fd38..1cbace071108dd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -14,6 +14,7 @@ MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
+CXXFLAGS = @CXXFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
 BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
 
 # make sure we don't pick up whacky LDFLAGS from the make environment and
@@ -63,6 +64,7 @@ XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
+CXX		= @cxx@
 AWK		= @awk@
 SED		= @sed@
 TAR		= @tar@
@@ -161,9 +163,15 @@ ifeq ($(ENABLE_GETTEXT),yes)
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
index 72e287b8b7957a..aca28440adac08 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -125,6 +125,18 @@ CFILES = buf_mem.c \
 	xfs_trans_space.c \
 	xfs_types.c
 
+EXTRA_CFILES=\
+	ioctl_c_dummy.c
+
+EXTRA_CXXFILES=\
+	ioctl_cxx_dummy.cpp
+
+EXTRA_OBJECTS=\
+	$(patsubst %.c,%.o,$(EXTRA_CFILES)) \
+	$(patsubst %.cpp,%.o,$(EXTRA_CXXFILES))
+
+LDIRT += $(EXTRA_OBJECTS)
+
 #
 # Tracing flags:
 # -DMEM_DEBUG		all zone memory use
@@ -148,7 +160,23 @@ LTLIBS = $(LIBPTHREAD) $(LIBRT)
 # don't try linking xfs_repair with a debug libxfs.
 DEBUG = -DNDEBUG
 
-default: ltdepend $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY) $(EXTRA_OBJECTS)
+
+%dummy.o: %dummy.cpp
+	@echo "    [CXXD]   $@"
+	$(Q)$(CXX) $(CXXFLAGS) -c $<
+
+%dummy.o: %dummy.c
+	@echo "    [CCD]    $@"
+	$(Q)$(CC) $(CFLAGS) -c $<
+
+MAKECXXDEP := $(MAKEDEPEND) $(CXXFLAGS)
+
+.PHONY: .extradep
+
+.extradep: $(EXTRA_CFILES) $(EXTRA_CXXFILES) $(HFILES)
+	$(Q)$(MAKEDEP) $(EXTRA_CFILES) > .extradep
+	$(Q)$(MAKECXXDEP) $(EXTRA_CXXFILES) >> .extradep
 
 # set up include/xfs header directory
 include $(BUILDRULES)
@@ -172,4 +200,5 @@ install-dev: install
 # running the install-headers target.
 ifndef NODEP
 -include .ltdep
+-include .extradep
 endif
diff --git a/libxfs/ioctl_c_dummy.c b/libxfs/ioctl_c_dummy.c
new file mode 100644
index 00000000000000..e417332c3cf9f6
--- /dev/null
+++ b/libxfs/ioctl_c_dummy.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+
+/* Dummy program to test C compilation of user-exported xfs headers */
+
+#include "include/xfs.h"
+#include "include/handle.h"
+#include "include/jdm.h"
diff --git a/libxfs/ioctl_cxx_dummy.cpp b/libxfs/ioctl_cxx_dummy.cpp
new file mode 100644
index 00000000000000..b95babff0b0aee
--- /dev/null
+++ b/libxfs/ioctl_cxx_dummy.cpp
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+
+/* Dummy program to test C++ compilation of user-exported xfs headers */
+
+extern "C" {
+#include "include/xfs.h"
+#include "include/handle.h"
+#include "include/jdm.h"
+};
diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index 49f4dfbbd2d168..56ee0b266130bf 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -42,6 +42,11 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     AC_SUBST(cc)
     AC_PACKAGE_NEED_UTILITY($1, "$cc", cc, [C compiler])
 
+    AC_PROG_CXX
+    cxx="$CXX"
+    AC_SUBST(cxx)
+    AC_PACKAGE_NEED_UTILITY($1, "$cxx", cxx, [C++ compiler])
+
     if test -z "$MAKE"; then
         AC_PATH_PROG(MAKE, gmake,, $PATH)
     fi

