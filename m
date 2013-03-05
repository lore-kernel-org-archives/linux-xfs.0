Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6F7F8064
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 17:48:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B04708F8074
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 15:48:50 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id Ecqqer5gwAKh9yMB (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 15:48:46 -0800 (PST)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: strange behavior of a larger xfs directory
Date: Wed, 06 Mar 2013 00:48:25 +0100
Message-ID: <1517139.CltWl8VXzZ@xrated>
In-Reply-To: <20130305222941.GP26081@dastard>
References: <4300208.uZ6HVTycB6@xrated> <8026381.3dEJ1E4pzL@xrated>
	<20130305222941.GP26081@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2973599.LGyd7z4d3N"
Content-Transfer-Encoding: 7Bit
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
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--nextPart2973599.LGyd7z4d3N
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Mittwoch, 6. M=E4rz 2013, 09:29:41 schrieb Dave Chinner:
> On Tue, Mar 05, 2013 at 09:32:02PM +0100, Hans-Peter Jansen wrote:
> > Am Dienstag, 5. M=E4rz 2013, 10:05:27 schrieb Dave Chinner:
> > > On Mon, Mar 04, 2013 at 05:40:13PM +0100, Hans-Peter Jansen wrote=
:
> > > Second solution: Run 3.8.1, make sure you mount with inode32, and=

> > > then run the xfs_reno tool mentioned on this page:
> > >=20
> > > http://xfs.org/index.php/Unfinished_work
> > >=20
> > > to find all the inodes with inode numbers larger than 32
> > > bits and move them to locations with smaller inode numbers.
> >=20
> > Okay, I would like to take that route.
> >=20
> > I've updated the xfsprogs, xfsdump and xfstests packages in my open=
SUSE
> > build service repo home:frispete:tools to current versions today, a=
nd
> > plan to submit them to Factory. openSUSE is always lagging in this =
area.
> >=20
> > I've tried to include a build of the xfs_reno tool in xfsprogs, sin=
ce, as
> > you mentioned, others might have a similar need soon. Unfortunately=
 I
> > failed so far, because it is using some attr_multi and attr_list
> > interfaces, that aren't part of the xfsprogs visible API anymore. O=
nly
> > the handle(3) man page refers to them.
> >=20
> > Attached is my current state: I've relocated the patch to xfsprogs =
3.1.9,
> > because it already carries all the necessary headers (apart from
> > attr_multi
> > and attr_list). The attr interfaces seem to be collected in libhand=
le now,
> > hence I've added it to the build.
>=20
> attr_list and attr_multi are supplied by libattr, you should not
> need the *by_handle variants at all - they are special sauce used by
> xfsdump, not xfs_reno....

Ahh, I see. These interfaces cannot be exercised much, given that googl=
e=20
didn't relate them to libattr prominently..

> .....
>=20
> > +TOPDIR =3D ..
> > +include $(TOPDIR)/include/builddefs
> > +
> > +LTCOMMAND =3D xfs_reno
> > +CFILES =3D xfs_reno.c
> > +LLDLIBS =3D $(LIBATTR)
>=20
> The patch assumes that libattr has been found by autoconf and set up
> in $(LIBATTR), but xfsprogs does not currently use libattr and hence
> that variable isn't set up. Therefore this line is a no-op:
>=20
> +LLDLIBS =3D $(LIBATTR)
>=20
> Change it to:
>=20
> LLDLIBS =3D -lattr
>=20
> And the xfs_reno should then link.
>=20
> BTW, if you want extra points and add the autoconf magic to the
> patch, copy it from the xfsdump tree. The places you need to copy
> from are:
>=20
> $ git grep -l LIBATTR |grep -v Makefile
> configure.ac
> include/builddefs.in
> m4/package_attrdev.m4
> $

Done that up to this point ;-) Nice and easy.=20
Committed, attached, and public build is on the way.

Dave, you made my day, ahem, night. Thank you very much.

To a casual consumer of this thread: go, grab the xfs_reno.patch in the=
=20
preceding mail, and the attached patch, apply both to a current version=
 of=20
xfsprogs, build, and read man xfs_reno. Seriously.

> And for even more bonus points, you could write a basic xfstest that
> creates a bunch of 64 bit inodes and then runs xfs_reno on it and
> checks that they get moved to 32 bit inodes. At that point, we could
> probably pull the xfs_reno patch into xfsprogs and ship it....

Hmm, any idea on how xfs can be tricked into generating 64 bit inodes w=
ithout=20
the need to create an excessive big test fs, or is this an accepted pra=
ctice?

Note to myself: xfs_reno could use some mount option check. Forgot to r=
emount=20
one partition with inode32 and, consequently, moved the offending inode=
s to=20
another 64 bit value..

Cheers,
Pete
--nextPart2973599.LGyd7z4d3N
Content-Disposition: attachment; filename="xfs_reno_fix.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="xfs_reno_fix.diff"

Index: b/configure.ac
===================================================================
--- a/configure.ac
+++ b/configure.ac
@@ -101,6 +101,10 @@ AC_PACKAGE_NEED_UUIDCOMPARE
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_NEED_ATTRIBUTES_H
+AC_PACKAGE_NEED_ATTRIBUTES_MACROS
+AC_PACKAGE_NEED_ATTRGET_LIBATTR
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
Index: b/include/builddefs.in
===================================================================
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -34,6 +34,7 @@ LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
+LIBATTR = @libattr@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
 LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
Index: b/m4/package_attrdev.m4
===================================================================
--- /dev/null
+++ b/m4/package_attrdev.m4
@@ -0,0 +1,79 @@
+AC_DEFUN([AC_PACKAGE_NEED_ATTR_XATTR_H],
+  [ AC_CHECK_HEADERS([attr/xattr.h])
+    if test "$ac_cv_header_attr_xattr_h" != "yes"; then
+        echo
+        echo 'FATAL ERROR: attr/xattr.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTR_ERROR_H],
+  [ AC_CHECK_HEADERS([attr/error_context.h])
+    if test "$ac_cv_header_attr_error_context_h" != "yes"; then
+        echo
+        echo 'FATAL ERROR: attr/error_context.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTRIBUTES_H],
+  [ have_attributes_h=false
+    AC_CHECK_HEADERS([attr/attributes.h sys/attributes.h], [have_attributes_h=true], )
+    if test "$have_attributes_h" = "false"; then
+        echo
+        echo 'FATAL ERROR: attributes.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_WANT_ATTRLIST_LIBATTR],
+  [ AC_CHECK_LIB(attr, attr_list, [have_attr_list=true], [have_attr_list=false])
+    AC_SUBST(have_attr_list)
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_GETXATTR_LIBATTR],
+  [ AC_CHECK_LIB(attr, getxattr,, [
+        echo
+        echo 'FATAL ERROR: could not find a valid Extended Attributes library.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-lib" from the attr source.'
+        exit 1
+    ])
+    libattr="-lattr"
+    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
+	libattr="${libexecdir}${libdirsuffix}/libattr.la"
+    AC_SUBST(libattr)
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTRGET_LIBATTR],
+  [ AC_CHECK_LIB(attr, attr_get,, [
+        echo
+        echo 'FATAL ERROR: could not find a valid Extended Attributes library.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-lib" from the attr source.'
+        exit 1
+    ])
+    libattr="-lattr"
+    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
+	libattr="${libexecdir}${libdirsuffix}/libattr.la"
+    AC_SUBST(libattr)
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTRIBUTES_MACROS],
+  [ AC_MSG_CHECKING([macros in attr/attributes.h])
+    AC_TRY_LINK([
+#include <sys/types.h>
+#include <attr/attributes.h>],
+    [ int x = ATTR_SECURE; ], [ echo ok ], [
+        echo
+	echo 'FATAL ERROR: could not find a current attributes header.'
+        echo 'Upgrade the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+	exit 1 ])
+  ])

--nextPart2973599.LGyd7z4d3N
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--nextPart2973599.LGyd7z4d3N--
