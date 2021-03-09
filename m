Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C72C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4541165295
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhCIEkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCIEjz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 703DE6523B;
        Tue,  9 Mar 2021 04:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264795;
        bh=UTmsGf6pzsOIXWEj+lo05taEArKorY+/PGT1/xEVF1U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cu9zpNOFi5HnT8SzpzEV1iapFS8XlM2Z6MGJHSs9pqorEAtraAQjo53qWVfg/O7EB
         XJL9CEDxQztA+FsbScUQkJpd0jyD65O1i/pAw2njsi4eU6kw88E4Am1QQ78DSylA3j
         8Md8lfwQOGuR/y7/kGH0Iunrt90g2hvKtFsa5vg+ngfDqdzOXTnJ+AtOA6eFz4/6iG
         iufSlvrij1xq5zkL/mIOlq7YWFDLdDw58rWrqHJxcXuE/nd3lUXIZrCHQG4py7jIcw
         nfXKOxjFpCoXXSkOJTLV5hOKWUueKw3Dk+br0G6Xk7EaYTxclxE9aRKu7giS4Im447
         S6BZgRuSa0JTQ==
Subject: [PATCH 2/2] fstests: remove DMAPI support from build system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:55 -0800
Message-ID: <161526479532.1213071.1569165278701497636.stgit@magnolia>
In-Reply-To: <161526478158.1213071.11274238322406050241.stgit@magnolia>
References: <161526478158.1213071.11274238322406050241.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since we've axed all the DMAPI tests, get rid of the build system
support too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Makefile                   |    2 +-
 build/rpm/xfstests.spec.in |    2 +-
 common/rc                  |    1 -
 configure.ac               |    1 -
 include/builddefs.in       |    1 -
 m4/Makefile                |    1 -
 m4/package_dmapidev.m4     |   27 ---------------------------
 tools/auto-qa              |    4 ++--
 8 files changed, 4 insertions(+), 35 deletions(-)
 delete mode 100644 m4/package_dmapidev.m4


diff --git a/Makefile b/Makefile
index 48927bcd..86a2d399 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,7 @@ TOOL_SUBDIRS = ltp src m4 common
 export TESTS_DIR = tests
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
 
-default: include/builddefs $(DMAPI_MAKEFILE)
+default: include/builddefs
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) $@
 else
diff --git a/build/rpm/xfstests.spec.in b/build/rpm/xfstests.spec.in
index 0a8c896b..e0f7c5f9 100644
--- a/build/rpm/xfstests.spec.in
+++ b/build/rpm/xfstests.spec.in
@@ -17,7 +17,7 @@ Group: System Environment/Base
 
 %description
 The XFS regression test suite.  Also includes some support for
-acl, attr, dmapi, udf, and nfs testing.  Contains around 200 specific tests
+acl, attr, udf, and nfs testing.  Contains around 200 specific tests
 for userspace & kernelspace.
 
 %prep
diff --git a/common/rc b/common/rc
index 6983bf6a..c0a791cb 100644
--- a/common/rc
+++ b/common/rc
@@ -277,7 +277,6 @@ _mount_ops_filter()
     local params="$*"
     local last_index=$(( $# - 1 ))
 
-    #get mount point to handle dmapi mtpt option correctly
     [ $last_index -gt 0 ] && shift $last_index
     local fs_escaped=$1
 
diff --git a/configure.ac b/configure.ac
index e5771285..27d57d63 100644
--- a/configure.ac
+++ b/configure.ac
@@ -58,7 +58,6 @@ AC_PACKAGE_NEED_ACLINIT_LIBACL
 AC_PACKAGE_WANT_GDBM
 AC_PACKAGE_WANT_AIO
 AC_PACKAGE_WANT_URING
-AC_PACKAGE_WANT_DMAPI
 AC_PACKAGE_WANT_LINUX_FIEMAP_H
 AC_PACKAGE_WANT_FALLOCATE
 AC_PACKAGE_WANT_OPEN_BY_HANDLE_AT
diff --git a/include/builddefs.in b/include/builddefs.in
index 6893d598..471e651c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -63,7 +63,6 @@ HAVE_AIO = @have_aio@
 HAVE_URING = @have_uring@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_OPEN_BY_HANDLE_AT = @have_open_by_handle_at@
-HAVE_DMAPI = @have_dmapi@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
diff --git a/m4/Makefile b/m4/Makefile
index 5d9c5896..f3f195c5 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -10,7 +10,6 @@ LSRCFILES = \
 	package_acldev.m4 \
 	package_aiodev.m4 \
 	package_gdbmdev.m4 \
-	package_dmapidev.m4 \
 	package_globals.m4 \
 	package_libcdev.m4 \
 	package_liburing.m4 \
diff --git a/m4/package_dmapidev.m4 b/m4/package_dmapidev.m4
deleted file mode 100644
index 6a7257ee..00000000
--- a/m4/package_dmapidev.m4
+++ /dev/null
@@ -1,27 +0,0 @@
-AC_DEFUN([AC_PACKAGE_NEED_XFS_DMAPI_H],
-  [ AC_CHECK_HEADERS([xfs/dmapi.h])
-    if test "$ac_cv_header_xfs_dmapi_h" != yes; then
-        echo
-        echo 'FATAL ERROR: could not find a valid DMAPI library header.'
-        echo 'Install the data migration API (dmapi) development package.'
-        echo 'Alternatively, run "make install-dev" from the dmapi source.'
-        exit 1
-    fi
-  ])
-
-AC_DEFUN([AC_PACKAGE_WANT_DMAPI],
-  [ AC_CHECK_LIB(dm, dm_make_handle, [ have_dmapi=true ], [
-	have_dmapi=false
-        echo
-        echo 'WARNING: could not find a valid DMAPI base library.'
-	echo 'If you want DMAPI support please install the data migration'
-	echo 'API (dmapi) library package. Alternatively, run "make install"'
-	echo 'from the dmapi source.'
-	echo
-    ])
-    libdm="-ldm"
-    test -f ${libexecdir}${libdirsuffix}/libdm.la && \
-	libdm="${libexecdir}${libdirsuffix}/libdm.la"
-    AC_SUBST(libdm)
-    AC_SUBST(have_dmapi)
-  ])
diff --git a/tools/auto-qa b/tools/auto-qa
index 1d0cc07c..1beb2835 100755
--- a/tools/auto-qa
+++ b/tools/auto-qa
@@ -308,7 +308,7 @@ do
 
 	*cleantools)
 	    # we need to configure or else we might fail to clean
-	    for pkg in attr acl xfsprogs dmapi xfsdump xfstests
+	    for pkg in attr acl xfsprogs xfsdump xfstests
 	    do
 		[ -d $WORKAREA/$pkg ] || continue
 		cd $WORKAREA/$pkg
@@ -321,7 +321,7 @@ do
 
 	*buildtools)
 	    _log "	*** build and install tools"
-	    for pkg in attr acl xfsprogs dmapi xfsdump xfstests 
+	    for pkg in attr acl xfsprogs xfsdump xfstests 
 	    do
 		[ -d $WORKAREA/$pkg ] || continue
 		cd $WORKAREA/$pkg

