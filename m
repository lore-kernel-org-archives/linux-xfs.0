Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F99C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFF0206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHZB4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 21:56:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49597 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbgHZB4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 21:56:39 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 50AB8824BB6
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 11:56:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-0000zX-IX
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-00Gg2D-1c
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] build: add support for libinih for mkfs
Date:   Wed, 26 Aug 2020 11:56:32 +1000
Message-Id: <20200826015634.3974785-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826015634.3974785-1-david@fromorbit.com>
References: <20200826015634.3974785-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=ELq9USmBTRWUPsVfHjoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Need to make sure the library is present so we can build mkfs with
config file support.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 configure.ac         |  3 +++
 include/builddefs.in |  1 +
 m4/package_inih.m4   | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+)
 create mode 100644 m4/package_inih.m4

diff --git a/configure.ac b/configure.ac
index fe1584e7704b..c0c7badccbdf 100644
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

