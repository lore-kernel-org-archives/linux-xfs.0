Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45471DE4C3;
	Thu, 16 Jan 2025 23:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070271; cv=none; b=FQTMNQfbXxtrIT9Jq9zDBgiElS8qga7ZzbTL0+F2LudRhpqEY4+ASiM88/ZXqGYyuMf9DcUzjEFsMDM4vitHJf5NvVPGle6rPhak7ZNRq0yDFT5ngrW6ndQpgnIZKCshSWHC3w+K8US6ZAobrjWJsN6DOmZIdcw/Fo4U0nhTzpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070271; c=relaxed/simple;
	bh=O4Cyfmf1PiUsgG1Ck2sttsvWEKF9xt3iM267UnUXtB8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRN09Sdn4+FZABx+LuxHM4fp7docvrfXMFylYB9iRpePmdL83hVC5DV73h9d/sjmv37QLx52Ycgx+F/zMDaSVJMDu82uX8OS5SW3xGbWtGMZNNz4g79bSWx0LchTi21mrqs+kI+Jh2zdsdKn581qXhKfYCDr7URrGOlPrea6zLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6CgiXhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6CgiXhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B57AC4CED6;
	Thu, 16 Jan 2025 23:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070270;
	bh=O4Cyfmf1PiUsgG1Ck2sttsvWEKF9xt3iM267UnUXtB8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y6CgiXhUC40qT/J05W0ktfZrZMEUZqJXARG9O8WUAshT1It9dIKMNtvxaAWqRvpDM
	 0extf7HdSaC5xavgFDMTTH9e/UNoNyJDQNzZSKodW9bBBSOR4rboUPPz8Ku8wFSAOe
	 X+j7OBxAvCg0rGH68WsNNBxOzAhdb+HOZhx32cPCGDQK1+Ayz2CCj1EHSm9eY3lJQ/
	 BCvdliPalNhRxlu1Bgj+mbim9oF0cdePcUg4wYzkfCGikkjaQBuFKyfYxPqy3eaIcf
	 plH7i9da0/saFid9dIB779IyJOsGKh/NIBY/CcNgoQ3AWrcp2wRB4S6BojHtighzfn
	 5n39DLDoiHnkg==
Date: Thu, 16 Jan 2025 15:31:09 -0800
Subject: [PATCH 23/23] build: initialize stack variables to zero by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974423.1927324.17566007446431552196.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Newer versions of gcc and clang can include the ability to zero stack
variables by default.  Let's enable it so that we (a) reduce the risk of
writing stack contents to disk somewhere and (b) try to reduce
unpredictable program behavior based on random stack contents.  The
kernel added this 6 years ago, so I think it's mature enough for
fstests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac          |    1 +
 include/builddefs.in  |    3 ++-
 m4/package_libcdev.m4 |   14 ++++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)


diff --git a/configure.ac b/configure.ac
index c81411e735a90d..f3c8c643f0eb9e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -72,6 +72,7 @@ AC_HAVE_NFTW
 AC_HAVE_RLIMIT_NOFILE
 AC_NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 AC_HAVE_FICLONE
+AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 
 AC_CHECK_FUNCS([renameat2])
 AC_CHECK_FUNCS([reallocarray])
diff --git a/include/builddefs.in b/include/builddefs.in
index 7274cde8d0814c..5b5864278682a4 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -76,6 +76,7 @@ NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE = @need_internal_xfs_ioc_exchange_range@
 HAVE_FICLONE = @have_ficlone@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
+SANITIZER_CFLAGS += @autovar_init_cflags@
 
 ifeq ($(PKG_PLATFORM),linux)
 PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
@@ -90,7 +91,7 @@ GCFLAGS = $(OPTIMIZER) $(DEBUG) $(CPPFLAGS) \
 	-I$(TOPDIR)/include -DVERSION=\"$(PKG_VERSION)\"
 
 # Global, Platform, Local CFLAGS
-CFLAGS += $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
+CFLAGS += $(GCFLAGS) $(PCFLAGS) $(LCFLAGS) $(SANITIZER_CFLAGS)
 
 include $(TOPDIR)/include/buildmacros
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index a0d50f4d9b68e4..ed8fe6e32ae00a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -72,3 +72,17 @@ AC_DEFUN([AC_HAVE_FICLONE],
        AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
     AC_SUBST(have_ficlone)
   ])
+
+# Check if we have -ftrivial-auto-var-init=zero
+AC_DEFUN([AC_HAVE_TRIVIAL_AUTO_VAR_INIT],
+  [ AC_MSG_CHECKING([if C compiler supports zeroing automatic vars])
+    OLD_CFLAGS="$CFLAGS"
+    TEST_CFLAGS="-ftrivial-auto-var-init=zero"
+    CFLAGS="$CFLAGS $TEST_CFLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [autovar_init_cflags=$TEST_CFLAGS],
+        [AC_MSG_RESULT([no])])
+    CFLAGS="${OLD_CFLAGS}"
+    AC_SUBST(autovar_init_cflags)
+  ])

