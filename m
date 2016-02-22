Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DC387F55
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 04:28:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69B52AC00D
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:28:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Uiau2w2o7TjFuCKu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:16:53 -0800 (PST)
Date: Mon, 22 Feb 2016 18:16:48 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: xfstests configure error with xfsprogs v4.5-rc1
Message-ID: <20160222101648.GX11419@eguan.usersys.redhat.com>
References: <20160222030304.GV11419@eguan.usersys.redhat.com>
	<20160222032450.GF14668@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iAL9S67WQOXgEPD9"
Content-Disposition: inline
In-Reply-To: <20160222032450.GF14668@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com


--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 22, 2016 at 02:24:50PM +1100, Dave Chinner wrote:
> On Mon, Feb 22, 2016 at 11:03:04AM +0800, Eryu Guan wrote:
> > Hi,
> > 
> > After upgrading to xfsprogs v4.5-rc1 version, xfstests failed to built
> > because of configure error:
> > 
> >     checking xfs/xfs.h usability... no
> >     checking xfs/xfs.h presence... yes
> >     configure: WARNING: xfs/xfs.h: present but cannot be compiled
> >     configure: WARNING: xfs/xfs.h:     check for missing prerequisite headers?
> >     configure: WARNING: xfs/xfs.h: see the Autoconf documentation
> >     configure: WARNING: xfs/xfs.h:     section "Present But Cannot Be Compiled"
> >     configure: WARNING: xfs/xfs.h: proceeding with the compiler's result
> >     checking for xfs/xfs.h... no
> >     
> >     FATAL ERROR: cannot find a valid <xfs/xfs.h> header file.
> >     Run "make install-qa" from the xfsprogs source.
> > 
> > and config.log showed:
> > 
> >     configure:4543: checking xfs/xfs.h usability
> >     configure:4543: ccache gcc -c -g -O2  conftest.c >&5
> >     In file included from /usr/include/xfs/xfs.h:37:0,
> >     		 from conftest.c:73:
> >     /usr/include/xfs/linux.h:145:1: error: unknown type name 'off64_t'
> >      typedef off64_t  xfs_off_t;
> >      ^
> >     configure:4543: $? = 1
> 
> That would seem like a system library problem in that it doesn't
> define off64_t through stdio.h. What distro are you compiling on?
> Also,  if you set _GNU_SOURCE, does it then compile? e.g. see
> m4/package_libcdev.m4 for how to test whether code compiles under
> certain defines.
> 
> If it does compile with _GNU_SOURCE being set, then all that needs
> to be is to update the autoconf rule.

Yes, it compiles with _GNU_SOURCE being set. And it turns out that not
only the check for xfs.h needs _GNU_SOURCE, many other checks need it
too, like libxfs.h, xfs_log_format.h, xlog_assign_lsn, xqm.h and xfsctl.

Attached file is updates I made to autoconf rules, as I'm not familiar
with autotools, I'm not sure if it's a proper fix, but it does work for
me, with both old and new version of xfsprogs.

Thanks,
Eryu

--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="off64_t.patch"

diff --git a/configure.ac b/configure.ac
index d038f95..fa48d2f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -34,7 +34,9 @@ AC_HEADER_STDC
 			cifs/ioctl.h		\
     ])
 
-AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[#include <xfs/libxfs.h>])
+AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[
+#define _GNU_SOURCE
+#include <xfs/libxfs.h>])
 
 AC_PACKAGE_NEED_UUIDCOMPARE
 
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 78a3dc4..aeb3d7c 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -1,5 +1,5 @@
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XFS_H],
-  [ AC_CHECK_HEADERS([xfs/xfs.h])
+  [ AC_CHECK_HEADERS([xfs/xfs.h],,,[#define _GNU_SOURCE])
     if test "$ac_cv_header_xfs_xfs_h" != "yes"; then
         echo
         echo 'FATAL ERROR: cannot find a valid <xfs/xfs.h> header file.'
@@ -9,19 +9,21 @@ AC_DEFUN([AC_PACKAGE_NEED_XFS_XFS_H],
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_LIBXFS_H],
-  [ AC_CHECK_HEADERS([xfs/libxfs.h], [ have_libxfs=true ], [ have_libxfs=false ])
+  [ AC_CHECK_HEADERS([xfs/libxfs.h], [ have_libxfs=true ],
+    [ have_libxfs=false ], [#define _GNU_SOURCE])
     AC_SUBST(have_libxfs)
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
   [ AC_CHECK_DECL(xlog_assign_lsn,
-      [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
-      [[#include <xfs/libxfs.h>]])
+      [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ], [[
+#define _GNU_SOURCE
+#include <xfs/libxfs.h>]])
     AC_SUBST(have_xlog_assign_lsn)
   ])
 
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
-  [ AC_CHECK_HEADERS([xfs/xqm.h])
+  [ AC_CHECK_HEADERS([xfs/xqm.h],,,[#define _GNU_SOURCE])
     if test "$ac_cv_header_xfs_xqm_h" != "yes"; then
         echo
         echo 'FATAL ERROR: cannot find a valid <xfs/xqm.h> header file.'
@@ -99,7 +101,10 @@ AC_DEFUN([AC_PACKAGE_NEED_IRIX_LIBHANDLE],
 
 AC_DEFUN([AC_PACKAGE_NEED_XFSCTL_MACRO],
   [ AC_MSG_CHECKING([xfsctl from xfs/xfs.h])
-    AC_TRY_LINK([#include <xfs/xfs.h>], [ int x = xfsctl(0, 0, 0, 0); ],
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <xfs/xfs.h> ],
+      [ int x = xfsctl(0, 0, 0, 0); ],
       [ echo ok ],
       [ echo
         echo 'FATAL ERROR: cannot find required macros in the XFS headers.'

--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--iAL9S67WQOXgEPD9--
