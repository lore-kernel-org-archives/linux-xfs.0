Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4688BE8
	for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2024 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723910476; cv=none; b=DY34T/G3dJAgr7EYmaK4skijq4kaRxCCRRUtTB58HGJ0AecZlOcf7NfO8G82KoeztVBt5RDbuWfQfWxUVkEOo+sXH/c1WwDcGAiO0AWTSo8GxlAu++L7sqGrk0hm3CEvjZbpSLBh6uf3E7wqD4q64qqX//UD9G98ihoLUs4a91E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723910476; c=relaxed/simple;
	bh=bJoSR+o1Y54AyThbsTqRqRwIroAJ/f1WcrqKS1IXcl8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OjXjvUufjIJiQMKPwdTZUEDCMBU0vXAWNc/tBBUuxuwcDovk03oMtjFd/nDTY91ZVC8SwPG7eRkk05WQdfZDcrUtUeSb5MPg5/Cmxwar2xh6W/MxpprIurcg+maSIYky+Okz9RDs7CpsKZk/C0KHOs1c6XJEDOoFVh5+OMhl+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=EsMfCVNE; arc=none smtp.client-ip=212.27.42.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="EsMfCVNE"
Received: from home.juju.sh (unknown [IPv6:2a01:e0a:485:b220:8213:2270:4a8d:a1d5])
	(Authenticated sender: ju.o@free.fr)
	by smtp1-g21.free.fr (Postfix) with ESMTPSA id E8613B00572;
	Sat, 17 Aug 2024 18:01:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1723910471;
	bh=bJoSR+o1Y54AyThbsTqRqRwIroAJ/f1WcrqKS1IXcl8=;
	h=From:To:Cc:Subject:Date:From;
	b=EsMfCVNES1AS7B+CQNXKzG9KywQWZ2iT19ZR+y15fo8dWV7wWryrw9cIWg6SJ+VBW
	 1B7bhVTUgLtyzaFLSYU/G1iaTgEVCKskyXPqMYib5r/AHtESJqKvsnqnmVYwn7PKnV
	 /P+PSZ35VnLIVlZQJ+YHVj/HpTRTm7xkz0sAEa024XsV6YnpGw06ys5vG1dTQGGYIW
	 +qQybwC/Xi9Bcm38w9P4+ssQtgzRwE9AAHbtiq1EhstIqXWjdsGZFoq4RjPumshPAP
	 xhSpq9wttd9rORYfDtbWp4X4QNVQ4pkc37j9K4BKFUJ3Syd4BsT9kEcspyasfDAIyB
	 u7xL3dDCBrOSw==
From: Julien Olivain <ju.o@free.fr>
To: linux-xfs@vger.kernel.org
Cc: Julien Olivain <ju.o@free.fr>
Subject: [PATCH 1/1] libxfs: provide a memfd_create() wrapper if not present in libc
Date: Sat, 17 Aug 2024 18:00:52 +0200
Message-ID: <20240817160052.2810571-1-ju.o@free.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 1cb2e387 "libxfs: add xfile support" introduced
a use of the memfd_create() system call, included in version
xfsprogs v6.9.0.

This system call was introduced in kernel commit [1], first included
in kernel v3.17 (released on 2014-10-05).

The memfd_create() glibc wrapper function was added much later in
commit [2], first included in glibc version 2.27 (released on
2018-02-01).

This direct use memfd_create() introduced a requirement on
Kernel >= 3.17 and glibc >= 2.27.

There is old toolchains like [3] for example (which ships gcc 7.3.1,
glibc 2.25 and includes kernel v4.10 headers), that can still be used
to build newer kernels. Even if such toolchains can be seen as
outdated, they are still claimed as supported by recent kernel.
For example, Kernel v6.10.5 has a requirement on gcc version 5.1 and
greater. See [4].

When compiling xfsprogs v6.9.0 with a toolchain not providing the
memfd_create() syscall wrapper, the compilation fail with message:

    xfile.c: In function 'xfile_create_fd':
    xfile.c:56:7: warning: implicit declaration of function 'memfd_create'; did you mean 'timer_create'? [-Wimplicit-function-declaration]
      fd = memfd_create(description, MFD_CLOEXEC | MFD_NOEXEC_SEAL);
           ^~~~~~~~~~~~

    ../libxfs/.libs/libxfs.a(xfile.o): In function 'xfile_create_fd':
    /build/xfsprogs-6.9.0/libxfs/xfile.c:56: undefined reference to 'memfd_create'

In order to let xfsprogs compile in a wider range of configurations,
this commit adds a memfd_create() function check in autoconf configure
script, and adds a system call wrapper which will be used if the
function is not available. With this commit, the environment
requirement is relaxed to only kernel >= v3.17.

Note: this issue was found in xfsprogs integration in Buildroot [5]
using the command "utils/test-pkg -a -p xfsprogs", which tests many
toolchain/arch combinations.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=9183df25fe7b194563db3fec6dc3202a5855839c
[2] https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=59d2cbb1fe4b8601d5cbd359c3806973eab6c62d
[3] https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
[4] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/process/changes.rst?h=v6.10.5#n32
[5] https://buildroot.org/

Signed-off-by: Julien Olivain <ju.o@free.fr>
---
 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 libxfs/Makefile       |  4 ++++
 libxfs/xfile.c        | 16 ++++++++++++++++
 m4/package_libcdev.m4 | 18 ++++++++++++++++++
 5 files changed, 40 insertions(+)

diff --git a/configure.ac b/configure.ac
index b84234b5..8a9ddb3f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -151,6 +151,7 @@ AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_HAVE_MALLINFO2
+AC_HAVE_MEMFD_CREATE
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
 if test "$enable_scrub" = "yes"; then
diff --git a/include/builddefs.in b/include/builddefs.in
index 734bd95e..1647d2cd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -101,6 +101,7 @@ HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
+HAVE_MEMFD_CREATE = @have_memfd_create@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
 HAVE_SYSTEMD = @have_systemd@
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 2f2791ca..833c6509 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -128,6 +128,10 @@ CFILES = buf_mem.c \
 #
 #LCFLAGS +=
 
+ifeq ($(HAVE_MEMFD_CREATE),yes)
+LCFLAGS += -DHAVE_MEMFD_CREATE
+endif
+
 FCFLAGS = -I.
 
 LTLIBS = $(LIBPTHREAD) $(LIBRT)
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index b4908b49..b8379775 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -8,6 +8,9 @@
 #include "libxfs/xfile.h"
 #include <linux/memfd.h>
 #include <sys/mman.h>
+#ifndef HAVE_MEMFD_CREATE
+#include <sys/syscall.h>
+#endif
 #include <sys/types.h>
 #include <sys/wait.h>
 
@@ -36,6 +39,19 @@
 # define MFD_NOEXEC_SEAL	(0x0008U)
 #endif
 
+/*
+ * The memfd_create system call was added to kernel 3.17 (2014), but
+ * its corresponding glibc wrapper was only added in glibc 2.27
+ * (2018).  In case a libc is not providing the wrapper, we provide
+ * one here.
+ */
+#ifndef HAVE_MEMFD_CREATE
+static int memfd_create(const char *name, unsigned int flags)
+{
+	return syscall(SYS_memfd_create, name, flags);
+}
+#endif
+
 /*
  * Open a memory-backed fd to back an xfile.  We require close-on-exec here,
  * because these memfd files function as windowed RAM and hence should never
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index de64c9af..6de8b33e 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -177,6 +177,24 @@ test = mallinfo2();
     AC_SUBST(have_mallinfo2)
   ])
 
+#
+# Check if we have a memfd_create libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_MEMFD_CREATE],
+  [ AC_MSG_CHECKING([for memfd_create])
+    AC_LINK_IFELSE(
+    [	AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/mman.h>
+	]], [[
+memfd_create(0, 0);
+	]])
+    ], have_memfd_create=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_memfd_create)
+  ])
+
 AC_DEFUN([AC_PACKAGE_CHECK_LTO],
   [ AC_MSG_CHECKING([if C compiler supports LTO])
     OLD_CFLAGS="$CFLAGS"
-- 
2.46.0

