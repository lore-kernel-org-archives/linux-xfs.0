Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF5198A0D
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063621; cv=none; b=O232uo1R4d4il/13/7ZSS84SMnH4y4ZbBLdAJ8Or/7ZRtVhAhlyvYezcCbBLOKNmXThv7H9uWJxS3n6FgEG7VDJoZYs0YTG1CUMfOqWulgaWDv6TYFcbE7A2T4ghMC+a32k1h1w1FtyaQKPmsLdimVjDLe+7KfDmZ5oh3cUGCpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063621; c=relaxed/simple;
	bh=WQD3ZXK/TDCd9m+hmZEwoLoSaDB2ApXMz34y5eLV3nU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRFdq2/XztU8PDwNbZjFOMGrKllGOaTpOpjBsRZ9tzCjcG5Tofrg7f2qoauOrCMNo38lXO49ECyrN9nnPck26nmazOdbO6SbSxNt85bPOspV8gloBBf6rMTqGx9vQOwF393Q5FjZItz66HYRWc0ifQpg3dTUNxITV9R/Oz3LcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYDu6tf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYDu6tf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E429C4CED6;
	Thu, 16 Jan 2025 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063621;
	bh=WQD3ZXK/TDCd9m+hmZEwoLoSaDB2ApXMz34y5eLV3nU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KYDu6tf/LFvjISHaxpF2RE09kguqr1+0+nSCYCrbhCLS9bKr1Y5IJ69clOtVHNSKB
	 HciMa+wjFw1S2Rx5rykjzP1qqjITl/PHalxAr26RPOXjimN3S7IUShTDHTE7zpMzOF
	 TswRFxAp7l5+1jEcYJGEH885CiliOk/Zvz8xnRJX4il+3zFLFoR5cGgLzhhD0i7MTX
	 WuKv0SK9n3NesDkeNYy4IptR2dLMnesrOAWuTx9vtjuxEfQEPMTFP5M2Ckrz7APc+z
	 i7/8gagWICpghetE+Hf64wwQIQMPV8jUlHUvvdd03oCIjts5G272ZxBd058NhUmA0W
	 7HHn8Ou2eotBw==
Date: Thu, 16 Jan 2025 13:40:20 -0800
Subject: [PATCH 7/8] build: initialize stack variables to zero by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173706332310.1823674.14707219486092901346.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
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
Reluctantly-Reviewed-by: Christoph Hellwig <hch@lst.de>
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

