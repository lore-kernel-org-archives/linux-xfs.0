Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 15:02:00 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74M1YDW011917
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 15:01:44 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k74M0vnx022982
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 17:00:57 -0500
Message-ID: <44D3C351.7060109@sgi.com>
Date: Fri, 04 Aug 2006 16:59:45 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com>
In-Reply-To: <44D38D34.1010503@thebarn.com>
Content-Type: multipart/mixed;
 boundary="------------080707030407020401070109"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Dean Roehrich <dean.roehrich@sun.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------080707030407020401070109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here's a patch that accomplishes #3. Turns out no libhandle
changes were required. Built debian and rpm packages and
verified that dmapi/libdm were not mentioned in the dependencies,
and for debian that libdm was not mentioned in the build-deps either.

I'd still like to move the current hsmapi.c out of xfsdump, but it's
just not much of a priority right now.

Bill

Russell Cattelan wrote:
> Bill Kendall wrote:
> 
> [snip]
> 
>>
>> 3) Add make_handle() routine to libhandle. xfsdump's only dependencies
>> from libdm are dm_make_handle() and dm_handle_to_fsid() (the latter
>> of which is in libhandle as handle_to_fshandle(), I think).
> 
> Hmm looking at dm_handle_to_fsid: it calls parse_handle which appears
> be quite dmapi specific and would require much of dm_handle.c?
> 
> I suppose we could move dm_handle.c into  libhandle ?
> But that seems to be going in the wrong direction in terms of
> correct code compartmentalization.
> 
> Since dmapi is only available  on Suse , Propack and somebody doing
> a custom kernel, I'm not convinced that xfs dump/restore should
> support dmapi no matter what.
> The only time a problem might arise is somebody not using the shipped 
> version
> of xfs dump/restore on a Suse or propack system, in which case they
> should either know what they are doing or get what they deserve.
> 
>>
>> 4) Noop the existing hsm routines, and allow xfsdump to dlopen a
>> specified .so to override the default (noop) behavior. DMF could
>> then ship a .so implementing those functions.
>>
>> Bill
>>

--------------080707030407020401070109
Content-Type: text/plain;
 name="no_dmapi"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no_dmapi"

Index: xfs/xfsdump/common/hsmapi.c
===================================================================
--- xfs.orig/xfsdump/common/hsmapi.c	2006-08-04 13:39:36.088684549 -0500
+++ xfs/xfsdump/common/hsmapi.c	2006-08-04 15:34:42.512343704 -0500
@@ -18,8 +18,7 @@
 
 #include <xfs/xfs.h>
 #include <attr/attributes.h>
-#include <xfs/handle.h>
-#include <xfs/dmapi.h>
+#include <xfs/jdm.h>
 
 #include "hsmapi.h"
 #include "mlog.h"
@@ -86,13 +85,12 @@
 #define	DMF_ST_NOMIGR		5	/* file should not be migrated */
 #define	DMF_ST_PARTIAL		6	/* file has backups plus parts online */
 
-/* Interesting bit combinations within the bs_dmevmask field of xfs_bstat_t:
+/* Create mask containing read, write, trunc and destroy dmapi event bits.
+ * Hardcode the values since xfsdump should not depend on dmapi being installed.
+ * Interesting bit combinations within the bs_dmevmask field of xfs_bstat_t:
  * OFL, UNM, and PAR files have exactly these bits set.
  * DUL and MIG files have all but the DM_EVENT_READ bit set */
-#define DMF_EV_BITS	( (1<<DM_EVENT_DESTROY) | \
-			  (1<<DM_EVENT_READ)    | \
-			  (1<<DM_EVENT_WRITE)   | \
-			  (1<<DM_EVENT_TRUNCATE) )
+#define DMF_EV_BITS	( (1<<16) | (1<<17) | (1<<18) | (1<<20) )
 
 /* OFL file's managed region event flags */
 #define DMF_MR_FLAGS	( 0x1 | 0x2 | 0x4 )
@@ -103,7 +101,7 @@
 
 typedef	struct	{
 	int		dumpversion;
-	dm_fsid_t	fsid;
+	jdm_fshandle_t  *fshanp;
 } dmf_fs_ctxt_t;
 
 typedef	struct	{
@@ -183,30 +181,11 @@
 	int		dumpversion)
 {
 	dmf_fs_ctxt_t	*dmf_fs_ctxtp;
-	void		*fshanp;
-	size_t		fshlen = 0;
-	dm_fsid_t	fsid;
-	int		error;
 
 	if (dumpversion != HSM_API_VERSION_1) {
 		return NULL;		/* we can't handle this version */
 	}
 
-	/* Get the filesystem's DMAPI fsid for later use in building file
-	   handles in HsmInitFileContext.  We use path_to_handle() because
-	   dm_path_to_handle() doesn't work if the filesystem isn't mounted
-	   with -o dmi.
-	*/
-
-	if (path_to_fshandle((char *)mountpoint, &fshanp, &fshlen)) {
-		return NULL;
-	}
-	error = dm_handle_to_fsid(fshanp, fshlen, &fsid);
-	free_handle(fshanp, fshlen);
-	if (error) {
-		return NULL;
-	}
-
 	/* Malloc space for a filesystem context, and initialize any fields
 	   needed later by other routines.
 	*/
@@ -215,7 +194,15 @@
 		return NULL;
 	}
 	dmf_fs_ctxtp->dumpversion = dumpversion;
-	dmf_fs_ctxtp->fsid = fsid;
+
+	/* Get the filesystem's handle for later use in building file
+	   handles in HsmInitFileContext.
+	*/
+	dmf_fs_ctxtp->fshanp = jdm_getfshandle((char *)mountpoint);
+	if (dmf_fs_ctxtp->fshanp == NULL) {
+		free(dmf_fs_ctxtp);
+		return NULL;
+	}
 
 	return (hsm_fs_ctxt_t *)dmf_fs_ctxtp;
 }
@@ -411,10 +398,6 @@
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
 	XFSattrvalue0_t	*dmfattrp;
-	void		*hanp;
-	size_t		hlen = 0;
-	dm_ino_t	ino;
-	dm_igen_t	igen;
 	int		state;
 	int		error;
 	attr_multiop_t	attr_op;
@@ -437,13 +420,6 @@
 	   for the DMF attribute.  (It could be in a disk block separate from
 	   the inode.)
 	*/
-
-	ino = (dm_ino_t)statp->bs_ino;
-	igen = (dm_igen_t)statp->bs_gen;
-	if (dm_make_handle(&dmf_f_ctxtp->fsys.fsid, &ino, &igen, &hanp, &hlen) != 0) {
-		return 0;	/* can't make a proper handle */
-	}
-
 	attr_op.am_opcode    = ATTR_OP_GET;
 	attr_op.am_error     = 0;
 	attr_op.am_attrname  = DMF_ATTR_NAME;
@@ -451,8 +427,11 @@
 	attr_op.am_length    = sizeof(dmf_f_ctxtp->attrval);
 	attr_op.am_flags     = ATTR_ROOT;
 
-	error = attr_multi_by_handle(hanp, hlen, &attr_op, 1, 0);
-	free_handle(hanp, hlen);
+	error = jdm_attr_multi(dmf_f_ctxtp->fsys.fshanp,
+			       (xfs_bstat_t *)statp,
+			       (char *)&attr_op,
+			       1,
+			       0);
 	if (error || attr_op.am_error)
 		return 0; /* no DMF attribute */
 
Index: xfs/xfsdump/aclocal.m4
===================================================================
--- xfs.orig/xfsdump/aclocal.m4	2006-08-04 15:36:45.207573713 -0500
+++ xfs/xfsdump/aclocal.m4	2006-08-04 15:39:03.904854078 -0500
@@ -157,33 +157,6 @@
 	exit 1 ])
   ])
 
-AC_DEFUN([AC_PACKAGE_NEED_XFS_DMAPI_H],
-  [ AC_CHECK_HEADERS([xfs/dmapi.h])
-    if test "$ac_cv_header_xfs_dmapi_h" != yes; then
-        echo
-        echo 'FATAL ERROR: could not find a valid DMAPI library header.'
-        echo 'Install the data migration API (dmapi) development package.'
-        echo 'Alternatively, run "make install-dev" from the dmapi source.'
-        exit 1
-    fi
-  ])
-
-AC_DEFUN([AC_PACKAGE_NEED_MAKEHANDLE_LIBDM],
-  [ AC_CHECK_LIB(dm, dm_make_handle,, [
-        echo
-        echo 'FATAL ERROR: could not find a valid DMAPI base library.'
-        echo 'Install the data migration API (dmapi) library package.'
-        echo 'Alternatively, run "make install" from the dmapi source.'
-        exit 1
-    ])
-    libdm="-ldm"
-    test -f `pwd`/../dmapi/libdm/libdm.la && \
-        libdm="`pwd`/../dmapi/libdm/libdm.la"
-    test -f ${libexecdir}${libdirsuffix}/libdm.la && \
-	libdm="${libexecdir}${libdirsuffix}/libdm.la"
-    AC_SUBST(libdm)
-  ])
-
 #
 # Generic macro, sets up all of the global packaging variables.
 # The following environment variables may be set to override defaults:
Index: xfs/xfsdump/dump/Makefile
===================================================================
--- xfs.orig/xfsdump/dump/Makefile	2006-08-04 15:43:59.901686947 -0500
+++ xfs/xfsdump/dump/Makefile	2006-08-04 15:44:09.206843880 -0500
@@ -85,7 +85,7 @@
 HFILES = $(LOCALINCL) $(COMMINCL) $(INVINCL)
 LINKS  = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
-LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBDM) $(LIBRMT)
+LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DDUMP -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DSIZEEST -DPIPEINVFIX
Index: xfs/xfsdump/include/builddefs.in
===================================================================
--- xfs.orig/xfsdump/include/builddefs.in	2006-08-04 15:41:12.564871559 -0500
+++ xfs/xfsdump/include/builddefs.in	2006-08-04 15:41:54.018029788 -0500
@@ -13,7 +13,6 @@
 LOADERFLAGS = @LDFLAGS@
 
 LIBRMT = $(TOPDIR)/librmt/librmt.la
-LIBDM = @libdm@
 LIBXFS = @libxfs@
 LIBATTR = @libattr@
 LIBUUID = @libuuid@
Index: xfs/xfsdump/debian/control
===================================================================
--- xfs.orig/xfsdump/debian/control	2006-08-04 15:44:59.345076705 -0500
+++ xfs/xfsdump/debian/control	2006-08-04 15:45:06.637983169 -0500
@@ -2,7 +2,7 @@
 Section: admin
 Priority: optional
 Maintainer: Nathan Scott <nathans@debian.org>
-Build-Depends: xfslibs-dev (>= 2.6.4), uuid-dev, libdm0-dev, libattr1-dev (>= 2.4.14), libncurses-dev, autoconf, debhelper (>= 5), gettext, libtool
+Build-Depends: xfslibs-dev (>= 2.6.4), uuid-dev, libattr1-dev (>= 2.4.14), libncurses-dev, autoconf, debhelper (>= 5), gettext, libtool
 Standards-Version: 3.5.9
 
 Package: xfsdump
Index: xfs/xfsdump/m4/package_dmapidev.m4
===================================================================
--- xfs.orig/xfsdump/m4/package_dmapidev.m4	2006-08-04 15:46:39.293496665 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,26 +0,0 @@
-AC_DEFUN([AC_PACKAGE_NEED_XFS_DMAPI_H],
-  [ AC_CHECK_HEADERS([xfs/dmapi.h])
-    if test "$ac_cv_header_xfs_dmapi_h" != yes; then
-        echo
-        echo 'FATAL ERROR: could not find a valid DMAPI library header.'
-        echo 'Install the data migration API (dmapi) development package.'
-        echo 'Alternatively, run "make install-dev" from the dmapi source.'
-        exit 1
-    fi
-  ])
-
-AC_DEFUN([AC_PACKAGE_NEED_MAKEHANDLE_LIBDM],
-  [ AC_CHECK_LIB(dm, dm_make_handle,, [
-        echo
-        echo 'FATAL ERROR: could not find a valid DMAPI base library.'
-        echo 'Install the data migration API (dmapi) library package.'
-        echo 'Alternatively, run "make install" from the dmapi source.'
-        exit 1
-    ])
-    libdm="-ldm"
-    test -f `pwd`/../dmapi/libdm/libdm.la && \
-        libdm="`pwd`/../dmapi/libdm/libdm.la"
-    test -f ${libexecdir}${libdirsuffix}/libdm.la && \
-	libdm="${libexecdir}${libdirsuffix}/libdm.la"
-    AC_SUBST(libdm)
-  ])
Index: xfs/xfsdump/debian/shlibs.local
===================================================================
--- xfs.orig/xfsdump/debian/shlibs.local	2006-08-04 15:47:45.321698050 -0500
+++ xfs/xfsdump/debian/shlibs.local	2006-08-04 15:47:50.806379180 -0500
@@ -1,3 +1,2 @@
-libdm		0	libdm0   (>= 2.1.0)
 libattr		1	libattr1 (>= 2.0.0)
 libhandle	1	xfsprogs (>= 2.6.30)
Index: xfs/xfsdump/restore/Makefile
===================================================================
--- xfs.orig/xfsdump/restore/Makefile	2006-08-04 15:48:11.880996211 -0500
+++ xfs/xfsdump/restore/Makefile	2006-08-04 15:48:21.402178453 -0500
@@ -95,7 +95,7 @@
 HFILES = $(LOCALINCL) $(COMMINCL) $(INVINCL)
 LINKS  = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
-LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBDM) $(LIBRMT)
+LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
Index: xfs/xfsdump/build/rpm/xfsdump.spec.in
===================================================================
--- xfs.orig/xfsdump/build/rpm/xfsdump.spec.in	2006-08-04 16:02:28.743149991 -0500
+++ xfs/xfsdump/build/rpm/xfsdump.spec.in	2006-08-04 16:02:36.688132300 -0500
@@ -5,7 +5,7 @@
 Distribution: @pkg_distribution@
 Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@ 
-Requires: xfsprogs >= 2.6.30, dmapi >= 2.0.0, attr >= 2.0.0
+Requires: xfsprogs >= 2.6.30, attr >= 2.0.0
 Source: @pkg_name@-@pkg_version@.src.tar.gz
 License: GPL
 Vendor: Silicon Graphics, Inc.
Index: xfs/xfsdump/configure.in
===================================================================
--- xfs.orig/xfsdump/configure.in	2006-08-04 15:49:23.473884494 -0500
+++ xfs/xfsdump/configure.in	2006-08-04 15:49:37.967683519 -0500
@@ -31,9 +31,6 @@
 AC_PACKAGE_NEED_XFS_HANDLE_H
 AC_PACKAGE_NEED_OPEN_BY_FSHANDLE
 
-AC_PACKAGE_NEED_XFS_DMAPI_H
-AC_PACKAGE_NEED_MAKEHANDLE_LIBDM
-
 AC_PACKAGE_NEED_ATTRIBUTES_H
 AC_PACKAGE_NEED_ATTRIBUTES_MACROS
 AC_PACKAGE_NEED_ATTRGET_LIBATTR
Index: xfs/xfsdump/m4/Makefile
===================================================================
--- xfs.orig/xfsdump/m4/Makefile	2006-08-04 16:03:15.648948927 -0500
+++ xfs/xfsdump/m4/Makefile	2006-08-04 16:03:21.013612090 -0500
@@ -8,7 +8,6 @@
 LSRCFILES = \
 	manual_format.m4 \
 	package_attrdev.m4 \
-	package_dmapidev.m4 \
 	package_globals.m4 \
 	package_ncurses.m4 \
 	package_utilies.m4 \

--------------080707030407020401070109--
