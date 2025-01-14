Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250FD146590
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 21:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890888; cv=none; b=Ph+hAvdDUKHV//yYoNHZVswb3J8s/fNIViaP8f4Ljkol4T3MqssCmmuQxdIWIKgJWDLvWfqJWr97MbqZ+epn/92eMHL9yyPId/CqZ0JJ4CnENcPQ8Qy/e626FIpyrkUt4cdDO8JuoZF35p/l3N4zjTUSXf4dWTMbZhGRo0u91ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890888; c=relaxed/simple;
	bh=vgzVjP0HKubT4A9f+9QvYz0mcrngRluDZKdQZ9TwvH4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utBuMV4+qv5Bl6aRPlMfBVPPPdWWv60z8Ij+zlv+4GkGoCYcFJ82KL4Cy0Iu24h3aV9BOEaVhPSyrmKozsuGLzYpe+hzZQ+xvVt4IJXDY1zSm/aR9qc1wV9U7UJkqHDgdXKAPP7u76yNxn1DhqFXgrOVkOFs8JhN1gRayeNuV9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwwcLCg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwwcLCg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90337C4CEDD;
	Tue, 14 Jan 2025 21:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736890885;
	bh=vgzVjP0HKubT4A9f+9QvYz0mcrngRluDZKdQZ9TwvH4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kwwcLCg65uU8L3H+0TEpZdrlomZRd0NKIccNo7X7IhKS8DmKDkrpYN5kyO3Vt2uaE
	 tdaCp5jmsctkiWQ1E2gRdK/rfj2ZQN9Ze2S8DK4s4nyAhoImS8l72o9P4MP9exDt4N
	 E8FJVSfZs6fq0dU49FOQrQKSlz15kR9xWb5wADO9s/iZZcmbTRGgfZDHcgGbNizFx2
	 3TyYVImilrm+QaUuS1GQ5u8VgTwb+UQ9T7BdpcD2GijLZgZkH5bXS8tDNy4hFoT5BE
	 BV67zRMnEE0cR44zoVkVB0HsUkMD0b454bZLk5Sb20vqxFmd9XxgpAharOtOgFJ4dS
	 3iKGoEoK91QWQ==
Date: Tue, 14 Jan 2025 13:41:25 -0800
Subject: [PATCH 4/5] build: initialize stack variables to zero by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173689081941.3476119.6143322419702468919.stgit@frogsfrogsfrogs>
In-Reply-To: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
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
xfsprogs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac            |    1 +
 include/builddefs.in    |    2 +-
 m4/package_sanitizer.m4 |   14 ++++++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)


diff --git a/configure.ac b/configure.ac
index 224d1d3930bf2f..90ef7925a925d0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -177,6 +177,7 @@ AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
 AC_CONFIG_UDEV_RULE_DIR
 AC_HAVE_BLKID_TOPO
+AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index ac43b6412c8cbb..82840ec7fd3adb 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -146,7 +146,7 @@ ifeq ($(HAVE_LIBURCU_ATOMIC64),yes)
 PCFLAGS += -DHAVE_LIBURCU_ATOMIC64
 endif
 
-SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
+SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@ @autovar_init_cflags@
 SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
 # Use special ar/ranlib wrappers if we have lto
diff --git a/m4/package_sanitizer.m4 b/m4/package_sanitizer.m4
index 41b729906a27ba..6488f7ebce2f50 100644
--- a/m4/package_sanitizer.m4
+++ b/m4/package_sanitizer.m4
@@ -57,3 +57,17 @@ AC_DEFUN([AC_PACKAGE_CHECK_THREADSAN],
     AC_SUBST(threadsan_cflags)
     AC_SUBST(threadsan_ldflags)
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

