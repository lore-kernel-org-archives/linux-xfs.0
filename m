Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45302 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:26:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOOIP123090
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:26:56 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qtwkut8wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:26:56 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NQui8030826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:26:56 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NQu4N007449
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:26:56 GMT
Subject: [PATCH 01/23] configure: use sys/xattr.h for fsetxattr detection
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:26:55 -0800
Message-ID: <155148281495.16677.12629575032379173191.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The only user of fsetxattr and HAVE_FSETXATTR is fsr, which includes
sys/xattr.h (from libc).  However, the m4 macro to detect fsetxattr
support requires attr/xattr.h (from libattr).  libattr dropped xattr.h
last year, so update the check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 m4/package_libcdev.m4 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7ee4acdd..2c0c72ce 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -223,14 +223,14 @@ AC_DEFUN([AC_HAVE_FLS],
   ])
 
 #
-# Check if we have a fsetxattr call (Mac OS X)
+# Check if we have a fsetxattr call
 #
 AC_DEFUN([AC_HAVE_FSETXATTR],
   [ AC_CHECK_DECL([fsetxattr],
        have_fsetxattr=yes,
        [],
        [#include <sys/types.h>
-        #include <attr/xattr.h>]
+        #include <sys/xattr.h>]
        )
     AC_SUBST(have_fsetxattr)
   ])
