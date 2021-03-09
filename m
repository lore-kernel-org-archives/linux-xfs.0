Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B16C43331
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A541A6528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCIEkK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhCIEjl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C4265275;
        Tue,  9 Mar 2021 04:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264780;
        bh=yDrpyfZ2wBB8HmqUgn5geBKJq0Lozcbb2KGNEe4NJzQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tYEMu1kPZUzlRPMMwe6qkD7fFj5vcNaDsV7ka4obLo3utoo60D/9IF0a1A4aX1VM7
         uzR0hC+cYa2QJOqtrvhxvM6VMM3IOqm7dRubzxx1eiPd6HqRygWEUYLbGhWCVp6LQv
         5TnW6486e3DBgE/WcnRCCHDblARMRaJ4j7BjgFqw6a8ZgPT8GTVB5rgjvT4/lwGOu7
         JcFqYH0WrSWmwJ34pMk4eAsC2nRblfK8/mbckkN3o9dRb97cn0mH38WErDQeF25TpP
         tz/jLYsjy3onpKPtWkEBshj6R+oLnpe8W1JMGwSatz/1pm3Y6C9yPUr2bCCHUVMSi0
         u0UFUYWBuU2yA==
Subject: [PATCH 2/2] fstests: remove libattr dependencies
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:40 -0800
Message-ID: <161526478017.1212985.2364574454492357224.stgit@magnolia>
In-Reply-To: <161526476928.1212985.15718497220408703599.stgit@magnolia>
References: <161526476928.1212985.15718497220408703599.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we don't have any libattr dependencies anymore, get rid of all
the build system hooks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README                     |    4 ++-
 build/rpm/xfstests.spec.in |    2 +-
 configure.ac               |    4 ---
 include/builddefs.in       |    2 --
 ltp/Makefile               |    5 ----
 ltp/fsstress.c             |    6 -----
 m4/Makefile                |    1 -
 m4/package_attrdev.m4      |   54 --------------------------------------------
 8 files changed, 3 insertions(+), 75 deletions(-)
 delete mode 100644 m4/package_attrdev.m4


diff --git a/README b/README
index 7a2638af..f15363f6 100644
--- a/README
+++ b/README
@@ -6,14 +6,14 @@ _______________________
 - install prerequisite packages
   For example, for Ubuntu:
 	sudo apt-get install xfslibs-dev uuid-dev libtool-bin \
-	e2fsprogs automake gcc libuuid1 quota attr libattr1-dev make \
+	e2fsprogs automake gcc libuuid1 quota attr make \
 	libacl1-dev libaio-dev xfsprogs libgdbm-dev gawk fio dbench \
 	uuid-runtime python sqlite3 liburing-dev
   For Fedora, RHEL, or CentOS:
 	yum install acl attr automake bc dbench dump e2fsprogs fio \
 	gawk gcc indent libtool lvm2 make psmisc quota sed \
 	xfsdump xfsprogs \
-	libacl-devel libattr-devel libaio-devel libuuid-devel \
+	libacl-devel libaio-devel libuuid-devel \
 	xfsprogs-devel btrfs-progs-devel python sqlite liburing-devel
 	(Older distributions may require xfsprogs-qa-devel as well.)
 	(Note that for RHEL and CentOS, you may need the EPEL repo.)
diff --git a/build/rpm/xfstests.spec.in b/build/rpm/xfstests.spec.in
index 338e8839..0a8c896b 100644
--- a/build/rpm/xfstests.spec.in
+++ b/build/rpm/xfstests.spec.in
@@ -6,7 +6,7 @@ Distribution: @pkg_distribution@
 Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@
 BuildRequires:  autoconf, xfsprogs-devel, e2fsprogs-devel
-BuildREquires:  libacl-devel, libattr-devel, libaio-devel
+BuildREquires:  libacl-devel, libaio-devel
 Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
 Requires:       bc, indent, quota
 Source: @pkg_name@-@pkg_version@.src.tar.gz
diff --git a/configure.ac b/configure.ac
index 8922c47e..e5771285 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,11 +49,7 @@ AC_PACKAGE_WANT_XLOG_ASSIGN_LSN
 AC_PACKAGE_NEED_XFS_XQM_H
 AC_PACKAGE_NEED_XFSCTL_MACRO
 AC_PACKAGE_NEED_XFS_HANDLE_H
-
 AC_PACKAGE_NEED_ATTRLIST_LIBHANDLE
-AC_PACKAGE_NEED_ATTRIBUTES_H
-AC_PACKAGE_WANT_ATTRLIST_LIBATTR
-AC_PACKAGE_NEED_ATTRSET_LIBATTR
 
 AC_PACKAGE_NEED_SYS_ACL_H
 AC_PACKAGE_NEED_ACL_LIBACL_H
diff --git a/include/builddefs.in b/include/builddefs.in
index fded3230..6893d598 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -20,7 +20,6 @@ HAVE_LIBXFS = @have_libxfs@
 HAVE_XLOG_ASSIGN_LSN = @have_xlog_assign_lsn@
 LIBXFS = @libxfs@
 LIBACL = @libacl@
-LIBATTR = @libattr@
 LIBGDBM = @libgdbm@
 LIBUUID = @libuuid@
 LIBHANDLE = @libhdl@
@@ -65,7 +64,6 @@ HAVE_URING = @have_uring@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_OPEN_BY_HANDLE_AT = @have_open_by_handle_at@
 HAVE_DMAPI = @have_dmapi@
-HAVE_ATTR_LIST = @have_attr_list@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
diff --git a/ltp/Makefile b/ltp/Makefile
index 198d930f..85f63414 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -13,11 +13,6 @@ LDIRT = $(TARGETS)
 LCFLAGS = -DXFS
 LCFLAGS += -I$(TOPDIR)/src #Used for including $(TOPDIR)/src/global.h
 
-ifeq ($(HAVE_ATTR_LIST), true)
-LCFLAGS += -DHAVE_ATTR_LIST
-LLDLIBS += $(LIBATTR)
-endif
-
 ifeq ($(HAVE_AIO), true)
 TARGETS += aio-stress
 LCFLAGS += -DAIO
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 10c27a7d..e7cd0eae 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -14,15 +14,9 @@
 #ifdef HAVE_BTRFSUTIL_H
 #include <btrfsutil.h>
 #endif
-#ifdef HAVE_ATTR_ATTRIBUTES_H
-#include <attr/attributes.h>
-#endif
 #ifdef HAVE_LINUX_FIEMAP_H
 #include <linux/fiemap.h>
 #endif
-#ifndef HAVE_ATTR_LIST
-#define attr_list(path, buf, size, flags, cursor) (errno = -ENOSYS, -1)
-#endif
 #ifdef HAVE_SYS_PRCTL_H
 #include <sys/prctl.h>
 #endif
diff --git a/m4/Makefile b/m4/Makefile
index 0352534d..5d9c5896 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -10,7 +10,6 @@ LSRCFILES = \
 	package_acldev.m4 \
 	package_aiodev.m4 \
 	package_gdbmdev.m4 \
-	package_attrdev.m4 \
 	package_dmapidev.m4 \
 	package_globals.m4 \
 	package_libcdev.m4 \
diff --git a/m4/package_attrdev.m4 b/m4/package_attrdev.m4
deleted file mode 100644
index d994cfc2..00000000
--- a/m4/package_attrdev.m4
+++ /dev/null
@@ -1,54 +0,0 @@
-AC_DEFUN([AC_PACKAGE_NEED_ATTR_ERROR_H],
-  [ AC_CHECK_HEADERS([attr/error_context.h])
-    if test "$ac_cv_header_attr_error_context_h" != "yes"; then
-        echo
-        echo 'FATAL ERROR: attr/error_context.h does not exist.'
-        echo 'Install the extended attributes (attr) development package.'
-        echo 'Alternatively, run "make install-dev" from the attr source.'
-        exit 1
-    fi
-  ])
-
-AC_DEFUN([AC_PACKAGE_NEED_ATTRIBUTES_H],
-  [ have_attributes_h=false
-    AC_CHECK_HEADERS([attr/attributes.h sys/attributes.h], [have_attributes_h=true], )
-    if test "$have_attributes_h" = "false"; then
-        echo
-        echo 'FATAL ERROR: attributes.h does not exist.'
-        echo 'Install the extended attributes (attr) development package.'
-        echo 'Alternatively, run "make install-dev" from the attr source.'
-        exit 1
-    fi
-  ])
-
-AC_DEFUN([AC_PACKAGE_WANT_ATTRLIST_LIBATTR],
-  [ AC_CHECK_LIB(attr, attr_list, [have_attr_list=true], [have_attr_list=false])
-    AC_SUBST(have_attr_list)
-  ])
-
-AC_DEFUN([AC_PACKAGE_NEED_ATTRSET_LIBATTR],
-  [ AC_CHECK_LIB(attr, attr_set,, [
-        echo
-        echo 'FATAL ERROR: could not find a valid Extended Attributes library.'
-        echo 'Install the extended attributes (attr) development package.'
-        echo 'Alternatively, run "make install-lib" from the attr source.'
-        exit 1
-    ])
-    libattr="-lattr"
-    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
-	libattr="${libexecdir}${libdirsuffix}/libattr.la"
-    AC_SUBST(libattr)
-  ])
-
-AC_DEFUN([AC_PACKAGE_NEED_ATTRIBUTES_MACROS],
-  [ AC_MSG_CHECKING([macros in attr/attributes.h])
-    AC_TRY_LINK([
-#include <sys/types.h>
-#include <attr/attributes.h>],
-    [ int x = ATTR_SECURE; ], [ echo ok ], [
-        echo
-	echo 'FATAL ERROR: could not find a current attributes header.'
-        echo 'Upgrade the extended attributes (attr) development package.'
-        echo 'Alternatively, run "make install-dev" from the attr source.'
-	exit 1 ])
-  ])

