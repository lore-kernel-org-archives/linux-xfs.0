Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724E8A95E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178389; cv=none; b=cIc1thsa8cDi159Qv4XL2T/ik5w6DfCq61yGHea59wLIqkxZpjDHz6pqwgtJt+N5O+uXgdDaDEU3MjxPsR5qOm/ptdFF2WW4GSq+8w8JrdeH9chtFYSIfPFtM12pNFzKufLq1oFCNJu1BsBSlTTgfAoVyQvPairKEMLi1ztnpy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178389; c=relaxed/simple;
	bh=78k8vwePRnxdsKaW4qXPtMJUVQphoJ5x3mp2TUCUe0k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L54PtUIfg40oO9CiH9BjM/fGinqlJXvhhjKmtrcfZtksoCDNwG7nYz32CUiCogXRijngcXzKNTirv9YWiNzIA/qxbImnAxu3yjPUVGuSvu+KR6XmE0ju4yLaKHJtCguiw74PVVus2bETv8QAhpV7sxwMVBH0HWKy8V9a+zg5Jx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTIyvGfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTIyvGfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1CEC4CEE7;
	Thu, 23 Oct 2025 00:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178387;
	bh=78k8vwePRnxdsKaW4qXPtMJUVQphoJ5x3mp2TUCUe0k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZTIyvGfVL4+LIz/lvKHwoKxBn516QC2dgZ9DsOVhEJY+zreocJxtmevkxj7FK4C8o
	 JfwFOIFvS0BetxVTxLCH3DiPXVAFpfoBlG+E/xu2TeyzxXgAJ5KK7YEri5aYdbEr1y
	 wZoSdC78M57aXn+nJml+4dd3L4F6NKYIL2frYq8uuqsqMshe/svIagN/w3nHm4RCYa
	 XW8oBe7pOa8qNBh93Y+hy1lVJiLmGEtbWnyCRcSadyoWE7chyqxZRqYUR3i21tCh7i
	 lBgb4wtzKCspywC4qoZweqxtswwAKfribp/gVuFiJOsyigvmXRmLdrvYndPMERhTOW
	 m/2St4Aq9BJKQ==
Date: Wed, 22 Oct 2025 17:13:07 -0700
Subject: [PATCH 03/19] xfs_healer: bindgen xfs_fs.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748313.1029045.18277017204734785364.stgit@frogsfrogsfrogs>
In-Reply-To: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
References: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create Rust bindings for all the stuff in xfs_fs.h so that we can call
the health monitor and online fsck ioctls later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/bindgen_xfs_fs.h |    6 +++++
 configure.ac            |   14 +++++++++++-
 healer/Makefile         |   14 ++++++++++++
 healer/rbindgen         |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 healer/src/lib.rs       |    1 +
 include/builddefs.in    |    3 ++
 m4/package_rust.m4      |   22 ++++++++++++++++++
 7 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100644 healer/bindgen_xfs_fs.h
 create mode 100755 healer/rbindgen


diff --git a/healer/bindgen_xfs_fs.h b/healer/bindgen_xfs_fs.h
new file mode 100644
index 00000000000000..82d11182bd11f3
--- /dev/null
+++ b/healer/bindgen_xfs_fs.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
diff --git a/configure.ac b/configure.ac
index 4cb253592ce09b..8b9aad143c2cec 100644
--- a/configure.ac
+++ b/configure.ac
@@ -283,7 +283,7 @@ if test "$have_rustc" = "yes"; then
 	AC_HAVE_CARGO
 fi
 
-# If we have cargo, check that our crate dependencies are present
+# If we have cargo, check that we have the first two dependencies for bindgen
 if test "$have_cargo" = "yes"; then
 	if test "$with_system_crates" = "yes"; then
 		AC_USE_SYSTEM_CRATES
@@ -291,6 +291,18 @@ if test "$have_cargo" = "yes"; then
 		AC_MAYBE_USE_SYSTEM_CRATES
 	fi
 	AC_HAVE_CLIPPY
+	AC_HAVE_CLANG
+	AC_HAVE_RUSTFMT
+fi
+
+# If we have the first two deps for bindgen, check that we have bindgen
+if test "$have_clang:$have_rustfmt" = "yes:yes"; then
+	AC_HAVE_BINDGEN
+fi
+
+# If we have rustc, cargo, clang, rustfmt, and bindgen, check that our crate
+# dependencies are present
+if test "$have_bindgen" = "yes"; then
 	AC_HAVE_HEALER_CRATES
 fi
 
diff --git a/healer/Makefile b/healer/Makefile
index ae248bc984b178..407e49ad868f4d 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -13,12 +13,17 @@ INSTALL_HEALER = install-healer
 # Rust implementation
 ifeq ($(HAVE_HEALER_CRATES),yes)
 
+HFILES = \
+	bindgen_xfs_fs.h
+
 RUSTFILES = \
 	src/lib.rs \
 	src/main.rs \
+	src/xfs_fs.rs \
 	src/xfsprogs.rs
 
 BUILT_RUSTFILES = \
+	src/xfs_fs.rs \
 	src/xfsprogs.rs
 
 CARGO_MANIFEST=Cargo.toml
@@ -130,10 +135,19 @@ $(CARGO_CONFIG):
 	touch $@
 endif
 
+ifeq ($(HAVE_RUSTFMT),yes)
+rustfmt: $(RUSTFILES)
+	rustfmt $^
+endif
+
 docs:
 	@echo "    [CARGO]  doc $@"
 	$(Q)cargo doc --no-deps
 
+src/xfs_fs.rs: bindgen_xfs_fs.h ../libxfs/xfs_fs.h rbindgen
+	@echo "    [RBIND]  $@"
+	$(Q)./rbindgen $< $@ '*xfs_fs.h*'
+
 # cargo install only knows how to build a binary and install it to $root/bin,
 # so we install it to ./rust/bin/ and let the install-rust target move it to
 # $prefix/usr/libexec/xfsprogs like we want.
diff --git a/healer/rbindgen b/healer/rbindgen
new file mode 100755
index 00000000000000..8f31678e845606
--- /dev/null
+++ b/healer/rbindgen
@@ -0,0 +1,57 @@
+#!/bin/bash
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+
+# Wrap bindgen so that it gives us what we want
+
+input="$1"
+shift
+output="$1"
+shift
+
+if [ -z "$1" ] || [ -z "${input}" ] || [ -z "${output}" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 src dest"
+	exit 1
+fi
+
+bindgen_args=("${input}" -o "${output}")
+
+# Try to generate inline functions
+bindgen_args+=(--generate-inline-functions)
+
+# Implement Debug on all generated structures so we can debug C FFI issues
+bindgen_args+=(--impl-debug)
+
+# Implement PartialEq when possible so that we can compare file handles
+bindgen_args+=(--with-derive-partialeq)
+
+# Implement Default when possible so that we can zero-init things
+bindgen_args+=(--with-derive-default)
+
+# Don't complain about unsafe code and improperly cased typenames being wrong
+# in this file, we want the C versions as-is
+bindgen_args+=(--raw-line '#![allow(non_camel_case_types)]')
+bindgen_args+=(--raw-line '#![allow(non_snake_case)]')
+bindgen_args+=(--raw-line '#![allow(non_upper_case_globals)]')
+
+# aarch64 libc defines va_args as an opaque u64 array which causes rustc to
+# complain about passing arrays by reference.  We don't call out to va_args
+# functions from Rust, so this is irrelevant.
+bindgen_args+=(--raw-line '#![allow(improper_ctypes)]')
+
+# Don't complain about unsafe code missing safety docs because we implicitly
+# trust the C programmers
+bindgen_args+=(--raw-line '#![allow(clippy::missing_safety_doc)]')
+
+# Older versions of bindgen (e.g. 0.60) required us to request promotion of
+# size_t to usize.  This seems to be the default as of 0.69, so force it here.
+if bindgen --help | grep -q -w -- '--size_t-is-usize'; then
+	bindgen_args+=(--size_t-is-usize)
+fi
+
+# Include xfsprogs C headers; if bindgen can't find stddef.h then you need to
+# install clang
+clang_args=(-I ../include/ -I ../libxfs/ -I ../)
+
+exec bindgen "${bindgen_args[@]}" -- "${clang_args[@]}"
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index 34ab19e07de82f..9455ed840b3ab0 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -5,3 +5,4 @@
  */
 
 pub mod xfsprogs;
+pub mod xfs_fs;
diff --git a/include/builddefs.in b/include/builddefs.in
index 3ac4147de8c815..20bd2d85b755e0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,6 +25,9 @@ HAVE_HEALER_CRATES = @have_healer_crates@
 CARGOFLAGS = @CARGOFLAGS@
 USE_SYSTEM_CRATES = @use_system_crates@
 HAVE_CLIPPY = @have_clippy@
+HAVE_CLANG = @have_clang@
+HAVE_RUSTFMT = @have_rustfmt@
+HAVE_BINDGEN = @have_bindgen@
 
 # make sure we don't pick up whacky LDFLAGS from the make environment and
 # only use what we calculate from the configured options above.
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
index a596ec0740f51e..0c25d7fba02243 100644
--- a/m4/package_rust.m4
+++ b/m4/package_rust.m4
@@ -132,3 +132,25 @@ $gettext_dep
 ],
     [yes], [no])
 ])
+
+# Check if clang is installed so that bindgen can find system headers.
+AC_DEFUN([AC_HAVE_CLANG],
+[
+  AC_CHECK_PROG([have_clang], [clang], [yes], [no])
+  AC_SUBST(have_clang)
+])
+
+# Check if rustfmt is installed; bindgen needs this to produce readable source
+# code.
+AC_DEFUN([AC_HAVE_RUSTFMT],
+[
+  AC_CHECK_PROG([have_rustfmt], [rustfmt], [yes], [no])
+  AC_SUBST(have_rustfmt)
+])
+
+# Check if bindgen (aka the C FFI generator) is installed
+AC_DEFUN([AC_HAVE_BINDGEN],
+[
+  AC_CHECK_PROG([have_bindgen], [bindgen], [yes], [no])
+  AC_SUBST(have_bindgen)
+])

