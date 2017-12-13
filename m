Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752956AbdLMAp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:28 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 4/9] build: update AC_PACKAGE_WANT_GDBM() and src/dbtest.c to build
Date: Tue, 12 Dec 2017 16:45:14 -0800
Message-Id: <20171213004519.29340-5-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Modern gdbm-devel packages bundle together gdbm.h and ndbm.h.
The old m4 macro had detection support for some old gdbm libraries
but not for new ones.

We fix compilation of src/dbtest.c by making the autoconf helper
check for this new arrangement:

If both gdbm.h and gdbm.h are found define set both gdbm_ndbm_=true,
and have_db=true, and define HAVE_GDBM_H. The src/dbtest.c already
had a HAVE_GDBM_H but there was never a respective autoconf settter for
it. We can just re-use this and fix it for new arrangement.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 m4/package_gdbmdev.m4 | 8 ++++++++
 src/dbtest.c          | 1 +
 2 files changed, 9 insertions(+)

diff --git a/m4/package_gdbmdev.m4 b/m4/package_gdbmdev.m4
index 734a192baf4d..e96343168478 100644
--- a/m4/package_gdbmdev.m4
+++ b/m4/package_gdbmdev.m4
@@ -28,6 +28,14 @@ AC_DEFUN([AC_PACKAGE_WANT_GDBM],
         AC_CHECK_HEADER(gdbm/ndbm.h, [ gdbm_ndbm_=true; have_db=true ], [ gdbm_ndbm_=false; have_db=false ])
         if test $gdbm_ndbm_ = true; then
             AC_DEFINE(HAVE_GDBM_NDBM_H_, [1], [Define to 1 if you have the <gdbm/ndbm.h> header file.])
+        else
+            AC_CHECK_HEADER(gdbm.h, [ gdbm_ndbm_=true; have_db=true ], [ gdbm_ndbm_=false; have_db=false ])
+            AC_CHECK_HEADER(ndbm.h, [ ndbm_=true ], [ ndbm_=false ])
+                if test $gdbm_ndbm_ = true; then
+                    if test $ndbm_ = true; then
+                        AC_DEFINE(HAVE_GDBM_H, [1], [Define to 1 if you have both <gdbm.h> and <ndbm.h> header files.])
+                    fi
+                fi
         fi
     fi
 
diff --git a/src/dbtest.c b/src/dbtest.c
index ec8db0b93a4e..f45db4ac2b19 100644
--- a/src/dbtest.c
+++ b/src/dbtest.c
@@ -24,6 +24,7 @@
 #include <gdbm-ndbm.h>
 #elif HAVE_GDBM_H
 #include <gdbm.h>
+#include <ndbm.h>
 #elif HAVE_NDBM_H
 #include <ndbm.h>
 #else
-- 
2.15.0

