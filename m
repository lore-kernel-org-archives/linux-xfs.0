Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfCNVEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:02 -0400
Subject: [PATCH 02/36] configure: use sys/xattr.h for fsetxattr detection
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:03:55 -0700
Message-ID: <155259743543.31886.18053722203157328922.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

The only user of fsetxattr and HAVE_FSETXATTR is fsr, which includes
sys/xattr.h (from libc).  However, the m4 macro to detect fsetxattr
support requires attr/xattr.h (from libattr).  libattr dropped xattr.h
last year, so update the check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
