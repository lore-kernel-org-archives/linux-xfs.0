Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F0B77F61
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 15:36:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C7D28F8092
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 13:36:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id a1SftEQEbLr7LTpT for
	<xfs@oss.sgi.com>; Wed, 06 Nov 2013 13:36:38 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rA6LacPA014527
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Nov 2013 16:36:38 -0500
Date: Wed, 6 Nov 2013 16:36:35 -0500
From: Kyle McMartin <kyle@redhat.com>
Subject: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131106213635.GC24712@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sandeen@redhat.com
Cc: xfs@oss.sgi.com

New Linux ports are using a standard syscall list that does not include
deprecated syscalls where 64-bit clean alternatives exist. As a result,
on arm64, __NR_getdents is undefined, resulting in xfsdump failing to
build.

To avoid that, in the case where __NR_getdents is unset in unistd.h,
avoid building the fallback path entirely, since
__ASSUME_GETDENTS64_SYSCALL will be true, the SYS_getdents64 case will
be the primary (and only) path used.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/common/getdents.c
+++ b/common/getdents.c
@@ -70,6 +70,9 @@ extern int __have_no_getdents64;
 # ifndef SYS_getdents64
 #  define SYS_getdents64 __NR_getdents64
 # endif
+# ifndef __NR_getdents
+#  define __ONLY_GETDENTS64_SYSCALL     1
+# endif
 #endif
 
 
@@ -207,6 +210,13 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
 # endif
     }
 #endif
+/* Newer Linux ports are not adding deprecated syscalls, so to avoid compile
+ * failures since SYS_getdents will be undefined, we check for that and only
+ * build the fall-back case if SYS_getdents is defined. We know that
+ * __ASSUME_GETDENTS64_SYSCALL is set, since __NR_getdents64 must exist on
+ * those platforms.
+ */
+#ifndef __ONLY_GETDENTS64_SYSCALL
   {
     size_t red_nbytes;
     struct kernel_dirent *skdp, *kdp;
@@ -265,4 +275,5 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
     }
 
   return (char *) dp - buf;
+#endif
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
