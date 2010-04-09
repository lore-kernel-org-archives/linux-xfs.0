Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o393kDAP068634 for <xfs@oss.sgi.com>; Thu, 8 Apr 2010 22:46:19 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6536153C6D9
	for <xfs@oss.sgi.com>; Thu,  8 Apr 2010 20:48:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id M5yZCV2xDK86rirg for
	<xfs@oss.sgi.com>; Thu, 08 Apr 2010 20:48:05 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o393m4he023306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Apr 2010 23:48:05 -0400
From: Wenming Zhang <wezhang@redhat.com>
Subject: [PATCH] xfstests: fix compile issue with gdbm and --enable-lib64
	warnnings
Date: Fri,  9 Apr 2010 11:48:02 +0800
Message-Id: <1270784882-8130-1-git-send-email-wezhang@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Wenming Zhang <wezhang@redhat.com>

fix couldn't be compiled with gdbm lib issue
and clear warnings while configure with  --enable-lib64 

Signed-off-by: Wenming Zhang <wezhang@redhat.com>
---
 configure.in |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 45b7fd1..92e2711 100644
--- a/configure.in
+++ b/configure.in
@@ -10,6 +10,7 @@ AC_HEADER_STDC
 			errno.h			\
 			malloc.h		\
 			uuid.h			\
+			gdbm.h			\
 			uuid/uuid.h		\
 			sys/uuid.h		\
 			sys/file.h		\
@@ -44,6 +45,12 @@ in
 		;;
 	*)
 		AC_MULTILIB($enable_lib64)
+		AC_ARG_ENABLE([lib64], [AS_HELP_STRING([--enable-lib64],
+                			[enable lib64 support (default is no)])],
+				[enable_lib64=$withval],
+				[enable_lib64=no]
+		)
+
 		AC_PACKAGE_NEED_XFS_XFS_H
 		AC_PACKAGE_WANT_LIBXFS_H
 		AC_PACKAGE_WANT_XLOG_ASSIGN_LSN
-- 
1.6.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
