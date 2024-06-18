Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A925672;
	Tue, 18 Jun 2024 00:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671700; cv=none; b=tjJIKy0UpUNjoMqjBJEsQ0CLleHlC5WjORjxYnETdYdxbaytGk2ZYUwRDDZIhN9zH9dUSd3RPVwSbCS1ZxAwdi5W0U0dTdrHspN5R/hzeR1M4cLxWViQCL4BZKCdDur6+pDrejLbQ7drAgYV4t3jiDRpfMNZ7SJ1Xqg1TGHqpWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671700; c=relaxed/simple;
	bh=BK91fSJNvcM9g4Xe+fJR2S9hey9dLz9CISk8CoCCdr8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJVwRBfCRXt+d2E6FrTZ1L9j7vYTelt6EIxS9RzWYOziJyoiqzB3lQTJ0TtkcPMOrSbwwk0nrxUWCNSiC7DCHibtYpIMQ0UKcDYzAb8fMfl3KREqCuZaU/P0cgy8rpApThlVH/afedKIyNUe7HC+6t2HXcAGrNb5guUh2rAfCNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvT6we5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvT6we5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD11C2BD10;
	Tue, 18 Jun 2024 00:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671699;
	bh=BK91fSJNvcM9g4Xe+fJR2S9hey9dLz9CISk8CoCCdr8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JvT6we5MLLYpVoXzEkh2VgN91dsgnkNyPWXzwo1+VQCGS0M0MiihgIL1ykfZk6uHO
	 nxQa1gla9+rrbofFh+jpf5Kp9Rsuxeg3nZmQK94rD0qWK+UUv1tmTKZHgqOO/FS9KJ
	 d/8x7kgsanqJx2lQGmd43/4ZyE5GNLFZTiWa1c8T1Wb/pIzp6AVehleG+rzP7h1Rnv
	 bMNHcETqc8/npgOXHiFELH4J9DcfdqWt9AqmJjvRlciubG1b1LMTrxhzNXmx0mRrEU
	 Hdt7V7CtMlnUJV8LiWxnC42O93dhDFQznU1MEYNxpfpCN1uxmjsaGy1GNrc/ENhBmj
	 fgyicnfT7aQWQ==
Date: Mon, 17 Jun 2024 17:48:19 -0700
Subject: [PATCH 06/10] misc: flip HAVE_XFS_IOC_EXCHANGE_RANGE logic
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145390.793463.9133351291514672371.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We only need to include src/fiexchange.h if the system's xfslibs package
either doesn't define it or is so old that we want a newer definition.
Invert the logic so that we only use src/fiexchange if we need the
override.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    2 +-
 include/builddefs.in  |    2 +-
 ltp/Makefile          |    4 ++--
 m4/package_xfslibs.m4 |   13 +++++++------
 src/Makefile          |    4 ++--
 src/global.h          |    2 +-
 src/vfs/Makefile      |    4 ++--
 7 files changed, 16 insertions(+), 15 deletions(-)


diff --git a/configure.ac b/configure.ac
index 4e567d3c96..c81411e735 100644
--- a/configure.ac
+++ b/configure.ac
@@ -70,7 +70,7 @@ AC_HAVE_SEEK_DATA
 AC_HAVE_BMV_OF_SHARED
 AC_HAVE_NFTW
 AC_HAVE_RLIMIT_NOFILE
-AC_HAVE_XFS_IOC_EXCHANGE_RANGE
+AC_NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 AC_HAVE_FICLONE
 
 AC_CHECK_FUNCS([renameat2])
diff --git a/include/builddefs.in b/include/builddefs.in
index ce95fe7d4b..7274cde8d0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -72,7 +72,7 @@ HAVE_SEEK_DATA = @have_seek_data@
 HAVE_NFTW = @have_nftw@
 HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
 HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
-HAVE_XFS_IOC_EXCHANGE_RANGE = @have_xfs_ioc_exchange_range@
+NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE = @need_internal_xfs_ioc_exchange_range@
 HAVE_FICLONE = @have_ficlone@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
diff --git a/ltp/Makefile b/ltp/Makefile
index c0b2824076..0611c5efe9 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -36,8 +36,8 @@ ifeq ($(HAVE_COPY_FILE_RANGE),yes)
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
 endif
 
-ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
-LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
+ifeq ($(NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE),yes)
+LCFLAGS += -DNEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 endif
 
 default: depend $(TARGETS)
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 2f1dbc6951..3cc88a27d2 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -92,16 +92,17 @@ AC_DEFUN([AC_HAVE_BMV_OF_SHARED],
     AC_SUBST(have_bmv_of_shared)
   ])
 
-# Check if we have XFS_IOC_EXCHANGE_RANGE
-AC_DEFUN([AC_HAVE_XFS_IOC_EXCHANGE_RANGE],
-  [ AC_MSG_CHECKING([for XFS_IOC_EXCHANGE_RANGE])
+# Check if we need to override the system XFS_IOC_EXCHANGE_RANGE
+AC_DEFUN([AC_NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE],
+  [ AC_MSG_CHECKING([for new enough XFS_IOC_EXCHANGE_RANGE])
     AC_LINK_IFELSE([AC_LANG_PROGRAM([[
 #define _GNU_SOURCE
 #include <xfs/xfs.h>
     ]], [[
          struct xfs_exch_range obj;
          ioctl(-1, XFS_IOC_EXCHANGE_RANGE, &obj);
-    ]])],[have_xfs_ioc_exchange_range=yes
-       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
-    AC_SUBST(have_xfs_ioc_exchange_range)
+    ]])],[AC_MSG_RESULT(yes)],
+         [need_internal_xfs_ioc_exchange_range=yes
+          AC_MSG_RESULT(no)])
+    AC_SUBST(need_internal_xfs_ioc_exchange_range)
   ])
diff --git a/src/Makefile b/src/Makefile
index ab98a06f49..9979613711 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -99,8 +99,8 @@ ifeq ($(HAVE_FICLONE),yes)
      TARGETS += t_reflink_read_race
 endif
 
-ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
-LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
+ifeq ($(NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE),yes)
+LCFLAGS += -DNEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 endif
 
 CFILES = $(TARGETS:=.c)
diff --git a/src/global.h b/src/global.h
index 4f92308d6c..157c898065 100644
--- a/src/global.h
+++ b/src/global.h
@@ -171,7 +171,7 @@
 #include <sys/mman.h>
 #endif
 
-#ifndef HAVE_XFS_IOC_EXCHANGE_RANGE
+#ifdef NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 # include "fiexchange.h"
 #endif
 
diff --git a/src/vfs/Makefile b/src/vfs/Makefile
index 868540f578..a9c37e92ea 100644
--- a/src/vfs/Makefile
+++ b/src/vfs/Makefile
@@ -19,8 +19,8 @@ ifeq ($(HAVE_URING), true)
 LLDLIBS += -luring
 endif
 
-ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
-LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
+ifeq ($(NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE),yes)
+LCFLAGS += -DNEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 endif
 
 default: depend $(TARGETS)

