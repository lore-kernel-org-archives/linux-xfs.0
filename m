Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6A4C388F9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 20:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61FE4218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 20:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373345AbgJ0UxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 16:53:01 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48311 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S373343AbgJ0UxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 16:53:01 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E6B3658C43F
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 07:52:58 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXVxi-004zyD-Az
        for linux-xfs@vger.kernel.org; Wed, 28 Oct 2020 07:52:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kXVxi-00Bqlz-38
        for linux-xfs@vger.kernel.org; Wed, 28 Oct 2020 07:52:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/5] build: add support for libinih for mkfs
Date:   Wed, 28 Oct 2020 07:52:54 +1100
Message-Id: <20201027205258.2824424-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027205258.2824424-1-david@fromorbit.com>
References: <20201027205258.2824424-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=NHsjDDs8AAAA:20
        a=QwDmcnV3u2fYWEkn6UMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Need to make sure the library is present so we can build mkfs with
config file support.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac         |  3 +++
 doc/INSTALL          |  5 +++++
 include/builddefs.in |  1 +
 m4/package_inih.m4   | 20 ++++++++++++++++++++
 4 files changed, 29 insertions(+)
 create mode 100644 m4/package_inih.m4

diff --git a/configure.ac b/configure.ac
index 345d90be8b8c..c419f16c39c2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -145,6 +145,9 @@ AC_PACKAGE_UTILITIES(xfsprogs)
 AC_MULTILIB($enable_lib64)
 AC_RT($enable_librt)
 
+AC_PACKAGE_NEED_INI_H
+AC_PACKAGE_NEED_LIBINIH
+
 AC_PACKAGE_NEED_UUID_H
 AC_PACKAGE_NEED_UUIDCOMPARE
 
diff --git a/doc/INSTALL b/doc/INSTALL
index d4395eefa834..2b04f9cfe108 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -28,6 +28,11 @@ Linux Instructions
    (on an RPM based system) or the uuid-dev package (on a Debian system)
    as some of the commands make use of the UUID library provided by these.
 
+   If your distro does not provide a libinih package, you can download and build
+   it from source from the upstream repository found at:
+
+	https://github.com/benhoyt/inih
+
    To build the package and install it manually, use the following steps:
 
 	# make
diff --git a/include/builddefs.in b/include/builddefs.in
index 30b2727a8db4..e8f447f92baf 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -27,6 +27,7 @@ LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
 LIBBLKID = @libblkid@
 LIBDEVMAPPER = @libdevmapper@
+LIBINIH = @libinih@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBFROG = $(TOPDIR)/libfrog/libfrog.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
diff --git a/m4/package_inih.m4 b/m4/package_inih.m4
new file mode 100644
index 000000000000..a2775592e09d
--- /dev/null
+++ b/m4/package_inih.m4
@@ -0,0 +1,20 @@
+AC_DEFUN([AC_PACKAGE_NEED_INI_H],
+  [ AC_CHECK_HEADERS([ini.h])
+    if test $ac_cv_header_ini_h = no; then
+	echo
+	echo 'FATAL ERROR: could not find a valid ini.h header.'
+	echo 'Install the libinih development package.'
+	exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_LIBINIH],
+  [ AC_CHECK_LIB(inih, ini_parse,, [
+	echo
+	echo 'FATAL ERROR: could not find a valid inih library.'
+	echo 'Install the libinih library package.'
+	exit 1
+    ])
+    libinih=-linih
+    AC_SUBST(libinih)
+  ])
-- 
2.28.0

