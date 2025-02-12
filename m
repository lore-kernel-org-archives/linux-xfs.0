Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B40271839;
	Wed, 12 Feb 2025 03:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331572; cv=none; b=oDPorjiMEMj6zD3+l/LVCGaL+6dBjSEagaXYB9tFXrqPZx35hyCCV7B2OfC+NWRkj9BE2857BqdWvP50FYjYPL8jPK1hX+gl5zSrlfgxoY1DpqNm97/rhE7V+7MCuDgchUALscnb5sS+qIMVddFDjdNacHaUQyWD8mGgYWyQL68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331572; c=relaxed/simple;
	bh=0QfkWSthC2YqQjjP8ObmMtswwxsCBRWGZfXVp/KrKcg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tFOED2TuQUgungECal4pysW6tbjqfz3jFjVTYxYUublIJHXUnBE0zQ/msU1CjK9P1mA19lfEW7x6m55siilH/xisyN2v9yUsuZKTJd1PwofHFq+UjKHkj02BETDVzy2aUQ0GSjXXbS8oI1vuLOi+7JvUxFqX9FLGwiHeQueIqNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pe7SqEmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pe7SqEmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE631C4CEDF;
	Wed, 12 Feb 2025 03:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331572;
	bh=0QfkWSthC2YqQjjP8ObmMtswwxsCBRWGZfXVp/KrKcg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pe7SqEmyWK3D7FEIpBb2Y9cz4XDsbhy5jKOlgiMTJBsK71WrwHTUq94u+BdrKn0js
	 ZrOoUXRV5u2/cXNIyW/P00PQRjoLpoaXQaIsGG/6GVzNUMGZ/EqtNN3nWO8+fHbxzt
	 K+IPpxdWjQLwt+tH6BEr0tEZoG8J0PMSc7tOuF2lSyBGRghf/iJm5LrrFecPCDoRbS
	 nj2HIHJA1z3WpHGWXTRIMuHHW3LJV9wkJrg1lPzFrkD21lA5U1CC97vd72IAB2gxXK
	 Y2/X9WVEEoIE8Cf8pz2PD0d5gXsdG6JrbIuxSy4gjo7J1XtYSaYiXw0ZqfrKqg451o
	 mGrgm8PItt8qg==
Date: Tue, 11 Feb 2025 19:39:32 -0800
Subject: [PATCH 34/34] build: initialize stack variables to zero by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094874.1758477.14830829870142897241.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

