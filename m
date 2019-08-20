Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC038C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99D8B22D6D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbfHTUWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:22:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730804AbfHTUWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:22:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKIv8R172542;
        Tue, 20 Aug 2019 20:21:58 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hpgxmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKIK3D165108;
        Tue, 20 Aug 2019 20:21:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ugj7p4hgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKLvZE028835;
        Tue, 20 Aug 2019 20:21:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:21:57 -0700
Subject: [PATCH 4/4] xfs_restore: support fallocate when reserving space for
 a file
From:   "Darrick J. Wong" <djwong@maple.djwong.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:21:56 -0700
Message-ID: <156633251670.1207741.14528791952409305250.stgit@magnolia>
In-Reply-To: <156633248668.1207741.376678690204909405.stgit@magnolia>
References: <156633248668.1207741.376678690204909405.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update the file creation helper to try fallocate when restoring a
filesystem before it tries RESVSP.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    2 ++
 include/builddefs.in  |    1 +
 m4/Makefile           |    1 +
 m4/package_libcdev.m4 |   15 +++++++++++++++
 restore/Makefile      |    4 ++++
 restore/dirattr.c     |   11 +++++++++++
 6 files changed, 34 insertions(+)
 create mode 100644 m4/package_libcdev.m4


diff --git a/configure.ac b/configure.ac
index a77054c..73dedd7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -84,6 +84,8 @@ AC_PACKAGE_NEED_ATTRIBUTES_H
 AC_PACKAGE_NEED_ATTRIBUTES_MACROS
 AC_PACKAGE_NEED_ATTRGET_LIBATTR
 
+AC_HAVE_FALLOCATE
+
 AC_MANUAL_FORMAT
 
 AC_CONFIG_FILES([include/builddefs])
diff --git a/include/builddefs.in b/include/builddefs.in
index 269c928..1c7e12f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -69,6 +69,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
+HAVE_FALLOCATE = @have_fallocate@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index 9a35056..ae452f7 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -16,6 +16,7 @@ LSRCFILES = \
 	manual_format.m4 \
 	package_attrdev.m4 \
 	package_globals.m4 \
+	package_libcdev.m4 \
 	package_ncurses.m4 \
 	package_pthread.m4 \
 	package_utilies.m4 \
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
new file mode 100644
index 0000000..050f82c
--- /dev/null
+++ b/m4/package_libcdev.m4
@@ -0,0 +1,15 @@
+#
+# Check if we have a fallocate libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_FALLOCATE],
+  [ AC_MSG_CHECKING([for fallocate])
+    AC_TRY_LINK([
+#include <fcntl.h>
+#include <linux/falloc.h>
+    ], [
+         fallocate(0, 0, 0, 0);
+    ], have_fallocate=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fallocate)
+  ])
diff --git a/restore/Makefile b/restore/Makefile
index 20c870a..ac3f8c8 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -102,6 +102,10 @@ LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DRESTORE
 
+ifeq ($(HAVE_FALLOCATE),yes)
+LCFLAGS += -DHAVE_FALLOCATE
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 267bef0..15a16d1 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -75,6 +75,17 @@ create_filled_file(
 	if (fd < 0)
 		return fd;
 
+#ifdef HAVE_FALLOCATE
+	ret = fallocate(fd, 0, 0, size);
+	if (ret && (errno != EOPNOTSUPP && errno != ENOTTY))
+		mlog(MLOG_VERBOSE | MLOG_NOTE,
+_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
+				size, pathname, "fallocate",
+				strerror(errno), errno);
+	if (ret == 0)
+		goto done;
+#endif
+
 	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
 	if (ret && (errno != EOPNOTSUPP && errno != ENOTTY))
 		mlog(MLOG_VERBOSE | MLOG_NOTE,

