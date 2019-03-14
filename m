Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49658 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbfCNVEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:06 -0400
Subject: [PATCH 03/36] configure.ac: fix alignment of features
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:01 -0700
Message-ID: <155259744173.31886.6475707140088498779.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the alignment of the feature options in the --help screen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)


diff --git a/configure.ac b/configure.ac
index ccc6e292..5a4e55ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -28,82 +28,82 @@ if test "${BUILD_CFLAGS+set}" != "set"; then
 fi
 
 AC_ARG_ENABLE(shared,
-[ --enable-shared=[yes/no] Enable use of shared libraries [default=yes]],,
+[  --enable-shared=[yes/no]  Enable use of shared libraries [default=yes]],,
 	enable_shared=yes)
 AC_SUBST(enable_shared)
 
 AC_ARG_ENABLE(gettext,
-[ --enable-gettext=[yes/no] Enable alternate language support [default=yes]],,
+[  --enable-gettext=[yes/no] Enable alternate language support [default=yes]],,
 	enable_gettext=yes)
 AC_SUBST(enable_gettext)
 
 AC_ARG_ENABLE(blkid,
-[ --enable-blkid=[yes/no] Enable use of block device id library [default=yes]],,
+[  --enable-blkid=[yes/no]   Enable use of block device id library [default=yes]],,
 	enable_blkid=yes)
 AC_SUBST(enable_blkid)
 
 AC_ARG_ENABLE(readline,
-[ --enable-readline=[yes/no] Enable readline command editing [default=no]],
+[  --enable-readline=[yes/no] Enable readline command editing [default=no]],
 	test $enable_readline = yes && libreadline="-lreadline",
 	enable_readline=no)
 AC_SUBST(libreadline)
 AC_SUBST(enable_readline)
 
 AC_ARG_ENABLE(editline,
-[ --enable-editline=[yes/no] Enable editline command editing [default=no]],
+[  --enable-editline=[yes/no] Enable editline command editing [default=no]],
 	test $enable_editline = yes && libeditline="-ledit",
 	enable_editline=no)
 AC_SUBST(libeditline)
 AC_SUBST(enable_editline)
 
 AC_ARG_ENABLE(termcap,
-[ --enable-termcap=[yes/no] Enable terminal capabilities library [default=no]],
+[  --enable-termcap=[yes/no] Enable terminal capabilities library [default=no]],
 	test $enable_termcap = yes && libtermcap="-ltermcap",)
 AC_SUBST(libtermcap)
 
 
 AC_ARG_ENABLE(lib64,
-[ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
+[  --enable-lib64=[yes/no]   Enable lib64 support [default=yes]],,
 	enable_lib64=yes)
 AC_SUBST(enable_lib64)
 
 AC_ARG_ENABLE(librt,
-[ --enable-librt=[yes/no] Enable librt support [default=yes]],,
+[  --enable-librt=[yes/no]   Enable librt support [default=yes]],,
 	enable_librt=yes)
 AC_SUBST(enable_librt)
 
 # Enable UBSAN; set enable_ubsan=probe below to enable autoprobe.
 AC_ARG_ENABLE(ubsan,
-[ --enable-ubsan=[yes/no] Enable Undefined Behavior Sanitizer (UBSAN) [default=no]],,
+[  --enable-ubsan=[yes/no]   Enable Undefined Behavior Sanitizer (UBSAN) [default=no]],,
 	enable_ubsan=no)
 AC_SUBST(enable_ubsan)
 
 # Enable ADDRSAN; set enable_addrsan=probe below to enable autoprobe.
 AC_ARG_ENABLE(addrsan,
-[ --enable-addrsan=[yes/no] Enable Address Sanitizer (ADDRSAN) [default=no]],,
+[  --enable-addrsan=[yes/no] Enable Address Sanitizer (ADDRSAN) [default=no]],,
 	enable_addrsan=no)
 AC_SUBST(enable_addrsan)
 
 # Enable THREADSAN; set enable_threadsan=probe to enable autoprobe.
 AC_ARG_ENABLE(threadsan,
-[ --enable-threadsan=[yes/no] Enable Thread Sanitizer (THREADSAN) [default=no]],,
+[  --enable-threadsan=[yes/no] Enable Thread Sanitizer (THREADSAN) [default=no]],,
 	enable_threadsan=no)
 AC_SUBST(enable_threadsan)
 
 AC_ARG_ENABLE(lto,
-[ --enable-lto=[yes/no]      Enable link time optimization (LTO) [default=no]],,
+[  --enable-lto=[yes/no]     Enable link time optimization (LTO) [default=no]],,
 	enable_lto=no)
 AC_SUBST(enable_lto)
 
 # Enable xfs_scrub build
 AC_ARG_ENABLE(scrub,
-[ --enable-scrub=[yes/no]    Enable build of xfs_scrub utility [default=yes]],,
+[  --enable-scrub=[yes/no]   Enable build of xfs_scrub utility [default=yes]],,
 	enable_scrub=yes)
 AC_SUBST(enable_scrub)
 
 # Enable libicu for xfs_scrubbing of malicious unicode sequences in names
 AC_ARG_ENABLE(libicu,
-[ --enable-libicu=[yes/no]   Enable Unicode name scanning in xfs_scrub (libicu) [default=probe]],,
+[  --enable-libicu=[yes/no]  Enable Unicode name scanning in xfs_scrub (libicu) [default=probe]],,
 	enable_libicu=probe)
 
 #
