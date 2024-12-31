Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B3429415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689114; cv=none; b=sIp54dSCspcst4yKuDqNhb8a8Iu4jQkEl1bG6wjeLEzu47CiZkjT9/TpzgUVBLx1bcD3/Gi3XFqRYjugqJvvpmLbgv3wHPAqaLrWQyxsn+O7brrD2Nf1+iSX48hiM1IyGniMbwWcJFDKBeKS4L++pIq6yuW90TJy6wNXmfYkQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689114; c=relaxed/simple;
	bh=9h82dR31wj2nQaoNFx94JXMkxyiQb3zqy62GtHQyqQg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgBxOnA8zB86eZjmaLak/HCckV3ync//k0P5x3ZAZX3zqRvaQMt/z6Idnij4M317qzftoDdsAvkGQPJam0EgJSXgTH1/aDt9QL34Q+8HrDOqqOsAC5nINoBTW3D6hHNMhxDSWiuWOJiM5CdVk+QPJT5kWWW7/Wyek5buOeG0UAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7gSd3kA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7gSd3kA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802ADC4CED2;
	Tue, 31 Dec 2024 23:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689113;
	bh=9h82dR31wj2nQaoNFx94JXMkxyiQb3zqy62GtHQyqQg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V7gSd3kAYGy9Rp0O2ywF5Q7wtqv3+mOt0GdVsIPeJpM3Ie+dGk0gylGPus0gpIzwo
	 JTSG/ZbuxJhiQTY8fW2cWIC7xXY/vHyk5KVLwDd0WbW5U7ZJhhLIV01E2fOoZ/wVLz
	 GpzEyrqUWOlVmAWZl3syGwOtZ8NxIBo6CWL/yhsJ5J3fYpKm2Z95oUx0s4FbUmB3un
	 nKd+1nxkKfRNGEsAKws7aNgrsVLRyVOa5zj5Ml3EBnjeBn/vTD27/nkOMS1dNLX7CD
	 8gg7fVfocAD/yRfshNRECuqAaEvd1TnXQ1NRPa+cbHiRmtHeNOaY4sQglPjiTL0v05
	 8ysTq6zH+Fn8Q==
Date: Tue, 31 Dec 2024 15:51:53 -0800
Subject: [PATCH 16/21] builddefs: refactor udev directory specification
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778707.2710211.17677068348003849396.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Refactor the code that finds the udev rules directory to detect the
location of the parent udev directory instead.  IOWs, we go from:

UDEV_RULE_DIR=/foo/bar/rules.d

to:

UDEV_DIR=/foo/bar
UDEV_RULE_DIR=/foo/bar/rules.d

This is needed by the next patch, which adds a helper script.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac           |    2 +-
 include/builddefs.in   |    3 ++-
 m4/package_services.m4 |   30 +++++++++++++++---------------
 3 files changed, 18 insertions(+), 17 deletions(-)


diff --git a/configure.ac b/configure.ac
index 1f7fec838e1239..cabbef51068dbc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -175,7 +175,7 @@ if test "$enable_scrub" = "yes"; then
 fi
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
-AC_CONFIG_UDEV_RULE_DIR
+AC_CONFIG_UDEV_DIR
 AC_HAVE_BLKID_TOPO
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
diff --git a/include/builddefs.in b/include/builddefs.in
index bb022c36627a72..4a25de76d5c325 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -112,7 +112,8 @@ SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
 HAVE_CROND = @have_crond@
 CROND_DIR = @crond_dir@
 HAVE_UDEV = @have_udev@
-UDEV_RULE_DIR = @udev_rule_dir@
+UDEV_DIR = @udev_dir@
+UDEV_RULE_DIR = @udev_dir@/rules.d
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 USE_RADIX_TREE_FOR_INUMS = @use_radix_tree_for_inums@
 
diff --git a/m4/package_services.m4 b/m4/package_services.m4
index a683ddb93e0e91..de0504df0c206f 100644
--- a/m4/package_services.m4
+++ b/m4/package_services.m4
@@ -77,33 +77,33 @@ AC_DEFUN([AC_CONFIG_CROND_DIR],
 ])
 
 #
-# Figure out where to put udev rule files
+# Figure out where to put udev files
 #
-AC_DEFUN([AC_CONFIG_UDEV_RULE_DIR],
+AC_DEFUN([AC_CONFIG_UDEV_DIR],
 [
 	AC_REQUIRE([PKG_PROG_PKG_CONFIG])
-	AC_ARG_WITH([udev_rule_dir],
-	  [AS_HELP_STRING([--with-udev-rule-dir@<:@=DIR@:>@],
-		[Install udev rules into DIR.])],
+	AC_ARG_WITH([udev_dir],
+	  [AS_HELP_STRING([--with-udev-dir@<:@=DIR@:>@],
+		[Install udev files underneath DIR.])],
 	  [],
-	  [with_udev_rule_dir=yes])
-	AS_IF([test "x${with_udev_rule_dir}" != "xno"],
+	  [with_udev_dir=yes])
+	AS_IF([test "x${with_udev_dir}" != "xno"],
 	  [
-		AS_IF([test "x${with_udev_rule_dir}" = "xyes"],
+		AS_IF([test "x${with_udev_dir}" = "xyes"],
 		  [
 			PKG_CHECK_MODULES([udev], [udev],
 			  [
-				with_udev_rule_dir="$($PKG_CONFIG --variable=udev_dir udev)/rules.d"
+				with_udev_dir="$($PKG_CONFIG --variable=udev_dir udev)"
 			  ], [
-				with_udev_rule_dir=""
+				with_udev_dir=""
 			  ])
 			m4_pattern_allow([^PKG_(MAJOR|MINOR|BUILD|REVISION)$])
 		  ])
-		AC_MSG_CHECKING([for udev rule dir])
-		udev_rule_dir="${with_udev_rule_dir}"
-		AS_IF([test -n "${udev_rule_dir}"],
+		AC_MSG_CHECKING([for udev dir])
+		udev_dir="${with_udev_dir}"
+		AS_IF([test -n "${udev_dir}"],
 		  [
-			AC_MSG_RESULT(${udev_rule_dir})
+			AC_MSG_RESULT(${udev_dir})
 			have_udev="yes"
 		  ],
 		  [
@@ -115,5 +115,5 @@ AC_DEFUN([AC_CONFIG_UDEV_RULE_DIR],
 		have_udev="disabled"
 	  ])
 	AC_SUBST(have_udev)
-	AC_SUBST(udev_rule_dir)
+	AC_SUBST(udev_dir)
 ])

