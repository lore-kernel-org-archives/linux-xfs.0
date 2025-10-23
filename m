Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C6115E97
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178200; cv=none; b=WV72XM2UegmeqU6MRXzgJoJ+xgRWBvujLtGM27+ivNGfzhtXNysNtSYLu2/+Y0AI/T14aFgJJ6owY+rbbvifHFUyp+/B1SZKI9UO5joqhwGpFLp0yTVCQ3jRHx4zYNywTmpErFIa3MSegvetT0N4+5wjGtrq86Z0J/bSOq9edtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178200; c=relaxed/simple;
	bh=CrSRm/pAF9KWw9+FBqqd0+HWmfEHOqlYICwF1AXPmSQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMd7Jz8AagIV/7kDliFpVs1dteK2pBkM4iTC48u0z6WRB480qWet55Lct79ApNx6gZtkuhoxNbHxY0Dg9X4VBT3bIHZG5dN5Vh+vQENhbzgV+r64QY2CoK3Y8P+YF6gGHUuRJQ9zBv8sOkFaFjbwsLNyFnXKRZGFwxU6bNDX77M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6Nivd1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6Nivd1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00866C4CEE7;
	Thu, 23 Oct 2025 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178200;
	bh=CrSRm/pAF9KWw9+FBqqd0+HWmfEHOqlYICwF1AXPmSQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l6Nivd1hTrbu0LX67JunQmQCNYxG3J6Ug63RSlh5bn875qxEqPyGfK66PZ8L6Cc45
	 pY2YshNzsqdCv/pkmNsZp9wGebTLG5zbqp9oxmtQq2iQCelXmCRUdGDaO42oXR25MP
	 veYwp76+DHL7Z8skImcqsVQE0golUl7smC88ZaivB0TQiVkp+UQNjsooo4PYp64Ode
	 +7IcPwCbmboy+bQRdGCj8eBFD00MiZCeW2Ihr0KiR9zJoAOU71TmlIIFNSU5zq9FmG
	 L7ErhG4L9CUjG5WVo4v1Wrgx9Gvi0u+z0XGU9uUrpl2Nqdqnsfh15SrwL8p4pDaXuN
	 3PPHlG3gF1XWw==
Date: Wed, 22 Oct 2025 17:09:59 -0700
Subject: [PATCH 17/26] builddefs: refactor udev directory specification
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747786.1028044.514581940826196282.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
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
index 369cdd1696380a..4e7b917c38ae7c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -184,7 +184,7 @@ if test "$enable_scrub" = "yes"; then
 fi
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
-AC_CONFIG_UDEV_RULE_DIR
+AC_CONFIG_UDEV_DIR
 AC_HAVE_BLKID_TOPO
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 AC_STRERROR_R_RETURNS_STRING
diff --git a/include/builddefs.in b/include/builddefs.in
index cb43029dc1f4c1..ddcc784361f0b9 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -116,7 +116,8 @@ SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
 HAVE_CROND = @have_crond@
 CROND_DIR = @crond_dir@
 HAVE_UDEV = @have_udev@
-UDEV_RULE_DIR = @udev_rule_dir@
+UDEV_DIR = @udev_dir@
+UDEV_RULE_DIR = @udev_dir@/rules.d
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 STRERROR_R_RETURNS_STRING = @strerror_r_returns_string@
 
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

