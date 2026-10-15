Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910973BB122
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075876; cv=none; b=Ra8J6wwvAaLSmxmiKUrvQEfWmLDIWoU/ZcQTarQquL5OoKdtrkpipSQPLdqB4j2K6D4ihxl3UuEPdlbAlYpO0102DncyYDyYLOT5nE4xcak6YU0DcMS1ehYmKIJAC2qKFsLu7fJpTzW58bvaAzROZKEyyJHNgSoBi9a/FfuCRhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075876; c=relaxed/simple;
	bh=2HL+bjRZCpUniNlqGecPVnJkhY0AvHrXXqrvbHYtfuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0YeUBb92AkW8WUVD44fmG/3D/1lJ3Nzjxhe3Iabxw3usJsLRfi+w4Nln83bMlGyREJ2zd7a+LLDFpTC/cgUIHGNlZ+x0kSHXH/LZSQza50cdUnTSgdCYv7Pcimj6PexaPLKvqF6PGqkcHzro/9QUAvNIWnh6J6vdeZqR9fueJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ii1Nb2aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ii1Nb2aw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D77831F000C4;
	Thu, 15 Oct 2026 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075874;
	bh=spygr3LX98bnGBt5J4v2G6ZX/WJMM4sCBuxvxe6+xDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ii1Nb2aw8O8QH/fy/rvvojgxyS4jjeYzKmq0nutMvM2fXO8bsfSH+ZwANbWhvKmyM
	 HN1gqCsOlJvN6hgacpYSOCTesX0tWTPNWlUXBVrdzHhleyoOpBlmZFz8JqYaNYGkZd
	 Ydvk8vGBi8F7CpWuCRxwPn+ecENaIywSG7e2aQtKaBT7oHcB6TGkDvBXuoi3tbaLAT
	 lE4jng5GIw+lSoAzu56380/RMh00NTXr3kcEJXnSHtbLnmfRNWgcxjXSNiV4bu3rQW
	 +ymfjIL6S0OKK1DSq7i1ayqW8ooKXYFTmnp3tIGI0PEAOEO/vsn7+EbsPlJekRo+7r
	 DW0VkAZp32Jxg==
Date: Thu, 15 Oct 2026 07:51:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfsprogs: even more debug whining
Message-ID: <20261015145114.GS2705364@frogsfrogsfrogs>
References: <20261015144610.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015144610.GP2705364@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Yeah these should be consolidated

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac            |    2 ++
 include/builddefs.in    |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_sanitizer.m4 |   14 ++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/configure.ac b/configure.ac
index a4e491895e020d..3628f53dbb4a96 100644
--- a/configure.ac
+++ b/configure.ac
@@ -38,6 +38,8 @@ fi
 AC_PROG_CXX
 # no C++ build tools yet
 
+AC_HAVE_X86_CFLAGS
+
 AC_ARG_ENABLE(shared,
 [  --enable-shared=[yes/no]  Enable use of shared libraries [default=yes]],,
 	enable_shared=yes)
diff --git a/include/builddefs.in b/include/builddefs.in
index 41076ddf389f82..81678113815330 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -94,6 +94,54 @@ WARNINGS += -Wno-dangling-pointer		# gcc 12.2 bug
 WARNINGS += -Wno-error=type-limits		# rtgroups patchset
 WARNINGS += -Wno-error=array-bounds		# rtgroups patchset
 
+# OpenSSF recommendations March 2025
+# https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html
+#WARNINGS += -O2				# already set elsewhere
+#WARNINGS += -Wall
+WARNINGS += -Wformat
+WARNINGS += -Wformat=2
+WARNINGS += -Wno-format-nonliteral		# xfs_db and friends fail this everywhere
+#WARNINGS += -Wconversion
+WARNINGS += -Wimplicit-fallthrough
+WARNINGS += -Werror=format-security
+WARNINGS += -U_FORTIFY_SOURCE
+WARNINGS += -D_FORTIFY_SOURCE=2			# debian defaults to 2
+WARNINGS += -D_GLIBCXX_ASSERTIONS
+#WARNINGS += -fstrict-flex-arrays=3		# not in gcc 12?
+WARNINGS += -fstack-clash-protection
+WARNINGS += -fstack-protector-strong
+WARNINGS += -Wl,-z,nodlopen
+WARNINGS += -Wl,-z,noexecstack
+WARNINGS += -Wl,-z,relro
+WARNINGS += -Wl,-z,now
+WARNINGS += -Wl,--as-needed
+WARNINGS += -Wl,--no-copy-dt-needed-entries
+
+# OpenSSF gcc recommendations
+WARNINGS += -Wtrampolines
+
+# OpenSSF per-arch recommendations + extra assertions
+WARNINGS += @arch_cflags@ -D_LIBCXX_ENABLE_ASSERTIONS
+
+# OpenSSF for production code
+WARNINGS += -fno-delete-null-pointer-checks
+WARNINGS += -fno-strict-overflow
+#WARNINGS += -fno-strict-aliasing		# elsewhere
+#WARNINGS += -ftrivial-auto-var-init=zero	# elsewhere
+
+# OpenSSF for obsolete C constructs
+WARNINGS += -Werror=implicit
+WARNINGS += -Werror=incompatible-pointer-types
+WARNINGS += -Werror=int-conversion
+
+# OpenSSF for multithreaded code
+WARNINGS += -fexceptions
+
+# chainguard.dev recommendations
+WARNINGS += -fno-omit-frame-pointer
+WARNINGS += -mno-omit-leaf-frame-pointer
+#WARNINGS += -fhardened				# not on gcc 12
+
 # Comment out for release builds
 CFLAGS += $(WARNINGS)
 BUILD_CFLAGS += $(WARNINGS)
diff --git a/m4/package_sanitizer.m4 b/m4/package_sanitizer.m4
index 6488f7ebce2f50..c20e5156907ab2 100644
--- a/m4/package_sanitizer.m4
+++ b/m4/package_sanitizer.m4
@@ -71,3 +71,17 @@ AC_DEFUN([AC_HAVE_TRIVIAL_AUTO_VAR_INIT],
     CFLAGS="${OLD_CFLAGS}"
     AC_SUBST(autovar_init_cflags)
   ])
+
+# Add arch-specific gcc flags if they exist
+AC_DEFUN([AC_HAVE_X86_CFLAGS],
+  [ AC_MSG_CHECKING([if C compiler supports various x86 CFLAGS])
+    OLD_CFLAGS="$CFLAGS"
+    TEST_CFLAGS="-fcf-protection=full -mshstk"
+    CFLAGS="$CFLAGS $TEST_CFLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [arch_cflags="$TEST_CFLAGS $arch_cflags"],
+        [AC_MSG_RESULT([no])])
+    CFLAGS="${OLD_CFLAGS}"
+    AC_SUBST(arch_cflags)
+  ])
