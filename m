Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6981E7F55
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 01:42:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14C44AC001
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 23:42:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dHpYNp7fC7YH7qTI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 23:42:38 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9B6gbHg004977
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 06:42:38 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9B6gaD4016845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 06:42:37 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9B6gaZo016047 for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 06:42:36 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH RESEND] xfstests: Incorrect check for gdbm/ndbm.h
Date: Fri, 11 Oct 2013 10:42:31 +0400
Message-Id: <1381473751-31534-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1381312905-22322-1-git-send-email-stanislav.kholmanskikh@oracle.com>
References: <1381312905-22322-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: vasily.isaenko@oracle.com

Current version of AC_PACKAGE_WANT_NDBM has following bugs:
* a typo (',') next to 'gdbm/ndbm.h', so C compiler fails
  with a syntax error when trying to compile
  "#include <gdbm/ndbm.h,>"

* autoconf never defines HAVE_GDBM_NDBM_H_ because it
  converts both header names (gdbm/ndbm.h, gdbm-ndbm.h)
  to GDBM_NDBM_H

Because of these bugs 'dbtest' can't be compiled on systems where
'gdbm-ndbm.h' header is absent but 'gdbm/ndbm.h' is present.

Fixed this.

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 m4/package_gdbmdev.m4 |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/m4/package_gdbmdev.m4 b/m4/package_gdbmdev.m4
index c07f75d..a57e3a2 100644
--- a/m4/package_gdbmdev.m4
+++ b/m4/package_gdbmdev.m4
@@ -19,7 +19,18 @@ AC_DEFUN([AC_PACKAGE_WANT_NDBM],
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_GDBM],
-  [ AC_CHECK_HEADERS([gdbm/ndbm.h, gdbm-ndbm.h], [ have_db=true ], [ have_db=false ])
+  [ AC_CHECK_HEADER(gdbm-ndbm.h, [ gdbm_ndbm=true; have_db=true ], [ gdbm_ndbm=false; have_db=false ])
+
+    if test $gdbm_ndbm = true; then
+        AC_DEFINE(HAVE_GDBM_NDBM_H, [1], [Define to 1 if you have the <gdbm-ndbm.h> header file.])
+    else
+	AS_UNSET([ac_cv_header_gdbm_ndbm_h])
+        AC_CHECK_HEADER(gdbm/ndbm.h, [ gdbm_ndbm_=true; have_db=true ], [ gdbm_ndbm_=false; have_db=false ])
+        if test $gdbm_ndbm_ = true; then
+            AC_DEFINE(HAVE_GDBM_NDBM_H_, [1], [Define to 1 if you have the <gdbm/ndbm.h> header file.])
+        fi
+    fi
+
     found=false
     libgdbm=""
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
