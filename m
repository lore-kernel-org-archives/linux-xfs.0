Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 597447FAE
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 10:53:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4705430405F
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 08:53:01 -0700 (PDT)
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86]) by
	cuda.sgi.com with ESMTP id RabJTkuKH4qg1rnN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 08:52:59 -0700 (PDT)
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <ferseiti@linux.vnet.ibm.com>;
	Wed, 5 Aug 2015 12:52:57 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id E042E1DC007C
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 11:51:52 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
	t75FpQja54526116
	for <xfs@oss.sgi.com>; Wed, 5 Aug 2015 12:51:27 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	t75FqpVu029787 for <xfs@oss.sgi.com>; Wed, 5 Aug 2015 12:52:51 -0300
Message-ID: <55C23152.3030801@linux.vnet.ibm.com>
Date: Wed, 05 Aug 2015 12:52:50 -0300
From: Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
References: <55BB9271.6000300@gmx.net> <55BBEF4F.6070809@linux.vnet.ibm.com>
	<20150801225230.GR16638@dastard>
	<41BF7556-AAAB-4F22-B8C2-8991A0917DE2@gmx.net>
	<20150802221301.GO3902@dastard>
	<55C0D916.1010102@linux.vnet.ibm.com>
	<20150804225819.GV16638@dastard>
	<55C208D2.4060907@linux.vnet.ibm.com>
	<20150805134729.GX16638@dastard>
In-Reply-To: <20150805134729.GX16638@dastard>
Content-Type: multipart/mixed; boundary="------------060709010009080302030403"
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
Cc: xfs@oss.sgi.com, 793495@bugs.debian.org, Breno Leitao <brenohl@br.ibm.com>, Daniel Bast <daniel.bast@gmx.net>

This is a multi-part message in MIME format.
--------------060709010009080302030403
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave!

On 08/05/2015 10:47 AM, Dave Chinner wrote:

> make realclean also removes the .census file, so it appears that
> the debian package build has a dependency on it. Still, that's a
> side issue, because we still don't exactly what is causing the
> configure script to fail.
Right. The immediate reason is because config.guess and config.sub are not
being updated. Once they are updated, configure will not fail. When I copy them,
manually, from /usr/share/libtool/config/, the build does not fail.

> You seem to be talking about 2 different tarballs here.  The
> tarballs I release most definitely have a configure script in them:
>
> $ tar tfv xfsprogs-4.2.0-rc1.tar.gz |grep configure
> -rw-r--r-- dave/dave      3098 2015-08-04 11:16 xfsprogs-4.2.0-rc1/configure.ac
> -rwxr-xr-x dave/dave    469084 2015-08-04 14:25 xfsprogs-4.2.0-rc1/configure
>
> So I don't know where you are getting xfsprogs tarballs without
> configure scripts from.
My apologies, it was a confusion of my part. I was looking at the git tree.
The tarball does come with configure. But the config.{guess,sub} that come with
it are up-to-date, differently of what comes with the debian src package.
I generated a diff from them, which is attached.
Also, the version I have here is not 4.2.0-rc1, it is the one found at the git
repository I mentioned. Is that not correct?

>
> To clear up any confusion, can you please explain exactly what you
> are building (step by step for the dummies in the audience like me)
> so we all understand exactly what context the build is failing in?
>
Ok. Just clarifying that what actually fails is the debian package, exclusively.
The ones found in xfs.org (actually oss.sgi.com/xfs) build flawlessly.

Originally I used sbuild, but manually this is what I do:

# apt-get source xfsprogs
# cd xfsprogs-3.2.4/
# apt-get build-dep xfsprogs
...
# dpkg-buildpackage
I am attaching the build log because it is a bit long.

>> Actually powerpc*-*linux* covers the triplet for ppc64el, as seen in:
>>>>         host-triplet:     powerpc64le-unknown-linux-gnu
>> So ppc*-*linux* does not make difference for  ppc64el, if that is what you
>> refer to.
>
> Did you actually try it?
Yes, I changed that line 1315 in /usr/share/aclocal/libtool.m4 to look the same
as you showed, but the build failed anyway.
>
> Sure, it may not be the reason that it builds correctly on Darrick's
> machine, but the fact is that Darricks' environment successfully
> builds packages from the official xfsprogs tarballs without
> problems and yours doesn't. The above change is the only thing that
> is non-standard in Darrick's environment, so it's an obvious change
> to try even if it makes no sense to you.
I understand that.
A correction though: mine builds from the official xfsprogs source or tarballs
without problems too.
It is the Debian source package that fails, exclusively.

>
> And it still doesn't change the situation: we can't fix the problem
> until we understand what is causing it....
What is causing it is: the old files config.guess and config.sub in the source 
package. Whether shipping updated ones or not shipping the configure file would
be the quick solution to this. Again, it is an exclusive problem with the
Debian package.

I am curious about something I have just noticed (while writing this e-mail).
Running apt-get source xfsprogs gets a tarball xfsprogs_3.2.4.tar.gz
Shouldn't it be the exact same file I get from:
http://ftp.br.debian.org/debian/pool/main/x/xfsprogs/xfsprogs_3.2.4.tar.gz
Because they differ. And the latter does not fail at all.

I am sorry for any confusion I might be causing :)

Thanks and regards.
-- 

Fernando Seiti Furusato
IBM Linux Technology Center

--------------060709010009080302030403
Content-Type: text/x-log;
 name="xfs_build.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="xfs_build.log"

dpkg-buildpackage: source package xfsprogs
dpkg-buildpackage: source version 3.2.4
dpkg-buildpackage: source distribution unstable
dpkg-buildpackage: source changed by Nathan Scott <nathans@debian.org>
 dpkg-source --before-build xfsprogs-3.2.4
dpkg-buildpackage: host architecture ppc64el
 debian/rules clean
== dpkg-buildpackage: clean
test -f debian/rules
rm -f built .census mkfs/mkfs.xfs-xfsprogs-udeb
/usr/bin/make distclean
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4'
rm -rf debian/xfsprogs debian/xfslibs-dev debian/xfsprogs-udeb
rm -f debian/*substvars debian/files* debian/*.debhelper
dh_autoreconf_clean
dh_clean
	rm -f debian/xfsprogs.substvars
	rm -f debian/xfsprogs.*.debhelper
	rm -rf debian/xfsprogs/
	rm -f debian/xfslibs-dev.substvars
	rm -f debian/xfslibs-dev.*.debhelper
	rm -rf debian/xfslibs-dev/
	rm -f debian/xfsprogs-udeb.substvars
	rm -f debian/xfsprogs-udeb.*.debhelper
	rm -rf debian/xfsprogs-udeb/
	rm -f debian/*.debhelper.log
	rm -f debian/files
	find .  \( \( \
		\( -path .\*/.git -o -path .\*/.svn -o -path .\*/.bzr -o -path .\*/.hg -o -path .\*/CVS \) -prune -o -type f -a \
	        \( -name '#*#' -o -name '.*~' -o -name '*~' -o -name DEADJOE \
		 -o -name '*.orig' -o -name '*.rej' -o -name '*.bak' \
		 -o -name '.*.orig' -o -name .*.rej -o -name '.SUMS' \
		 -o -name TAGS -o \( -path '*/.deps/*' -a -name '*.P' \) \
		\) -exec rm -f {} + \) -o \
		\( -type d -a -name autom4te.cache -prune -exec rm -rf {} + \) \)
 dpkg-source -b xfsprogs-3.2.4
dpkg-source: warning: no source format specified in debian/source/format, see dpkg-source(1)
dpkg-source: info: using source format `1.0'
dpkg-source: info: building xfsprogs in xfsprogs_3.2.4.tar.gz
dpkg-source: info: building xfsprogs in xfsprogs_3.2.4.dsc
 debian/rules build
test -f debian/rules
== dpkg-buildpackage: installer
if [ ! -f mkfs/mkfs.xfs-xfsprogs-udeb ]; then \
	export DEBUG=-DNDEBUG DISTRIBUTION=debian INSTALL_USER=root INSTALL_GROUP=root LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ; export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no" ; /usr/bin/make include/platform_defs.h; \
	for dir in include libxfs libdisk mkfs; do \
		/usr/bin/make -C $dir; \
	done; \
	mv mkfs/mkfs.xfs mkfs/mkfs.xfs-xfsprogs-udeb; \
	/usr/bin/make distclean; \
fi
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
./configure $LOCAL_CONFIGURE_OPTIONS
checking build system type... ./config.guess: unable to guess system type

This script, last modified 2012-02-10, has failed to recognize
the operating system you are using. It is advised that you
download the most up to date version of the config scripts from

  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD
and
  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD

If the version you run (./config.guess) is already up to date, please
send the following data and any information you think might be
pertinent to <config-patches@gnu.org> in order to provide the needed
information to handle your system.

config.guess timestamp = 2012-02-10

uname -m = ppc64le
uname -r = 3.16.0-4-powerpc64le
uname -s = Linux
uname -v = #1 SMP Debian 3.16.7-ckt9-3~deb8u1 (2015-04-24)

/usr/bin/uname -p = 
/bin/uname -X     = 

hostinfo               = 
/bin/universe          = 
/usr/bin/arch -k       = 
/bin/arch              = 
/usr/bin/oslevel       = 
/usr/convex/getsysinfo = 

UNAME_MACHINE = ppc64le
UNAME_RELEASE = 3.16.0-4-powerpc64le
UNAME_SYSTEM  = Linux
UNAME_VERSION = #1 SMP Debian 3.16.7-ckt9-3~deb8u1 (2015-04-24)
configure: error: cannot guess build type; you must specify one
Makefile:89: recipe for target 'include/builddefs' failed
make[1]: *** [include/builddefs] Error 1
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4'
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4/include'
Makefile:19: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4/include'
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4/libxfs'
Makefile:6: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4/libxfs'
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4/libdisk'
Makefile:6: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4/libdisk'
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4/mkfs'
Makefile:6: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4/mkfs'
mv: cannot stat ‘mkfs/mkfs.xfs’: No such file or directory
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4'
== dpkg-buildpackage: configure
test -f debian/rules
AUTOHEADER=/bin/true dh_autoreconf
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o -path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exec md5sum {} \; > debian/autoreconf.before
	autoreconf -f -i
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o -path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exec md5sum {} \; > debian/autoreconf.after
export DEBUG=-DNDEBUG DISTRIBUTION=debian INSTALL_USER=root INSTALL_GROUP=root LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ; /usr/bin/make include/platform_defs.h
make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
./configure $LOCAL_CONFIGURE_OPTIONS
checking build system type... ./config.guess: unable to guess system type

This script, last modified 2012-02-10, has failed to recognize
the operating system you are using. It is advised that you
download the most up to date version of the config scripts from

  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD
and
  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD

If the version you run (./config.guess) is already up to date, please
send the following data and any information you think might be
pertinent to <config-patches@gnu.org> in order to provide the needed
information to handle your system.

config.guess timestamp = 2012-02-10

uname -m = ppc64le
uname -r = 3.16.0-4-powerpc64le
uname -s = Linux
uname -v = #1 SMP Debian 3.16.7-ckt9-3~deb8u1 (2015-04-24)

/usr/bin/uname -p = 
/bin/uname -X     = 

hostinfo               = 
/bin/universe          = 
/usr/bin/arch -k       = 
/bin/arch              = 
/usr/bin/oslevel       = 
/usr/convex/getsysinfo = 

UNAME_MACHINE = ppc64le
UNAME_RELEASE = 3.16.0-4-powerpc64le
UNAME_SYSTEM  = Linux
UNAME_VERSION = #1 SMP Debian 3.16.7-ckt9-3~deb8u1 (2015-04-24)
configure: error: cannot guess build type; you must specify one
Makefile:89: recipe for target 'include/builddefs' failed
make[1]: *** [include/builddefs] Error 1
make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4'
debian/rules:36: recipe for target '.census' failed
make: *** [.census] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2

--------------060709010009080302030403
Content-Type: text/x-patch;
 name="config_guess_sub.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config_guess_sub.diff"

diff -purN debian/config.guess git/config.guess
--- debian/config.guess	2015-08-05 11:03:57.168020710 -0400
+++ git/config.guess	2015-08-05 11:04:09.964035700 -0400
@@ -1,14 +1,12 @@
 #! /bin/sh
 # Attempt to guess a canonical system name.
-#   Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
-#   2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010,
-#   2011, 2012 Free Software Foundation, Inc.
+#   Copyright 1992-2014 Free Software Foundation, Inc.
 
-timestamp='2012-02-10'
+timestamp='2014-03-23'
 
 # This file is free software; you can redistribute it and/or modify it
 # under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
+# the Free Software Foundation; either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful, but
@@ -22,19 +20,17 @@ timestamp='2012-02-10'
 # As a special exception to the GNU General Public License, if you
 # distribute this file as part of a program that contains a
 # configuration script generated by Autoconf, you may include it under
-# the same distribution terms that you use for the rest of that program.
-
-
-# Originally written by Per Bothner.  Please send patches (context
-# diff format) to <config-patches@gnu.org> and include a ChangeLog
-# entry.
+# the same distribution terms that you use for the rest of that
+# program.  This Exception is an additional permission under section 7
+# of the GNU General Public License, version 3 ("GPLv3").
 #
-# This script attempts to guess a canonical system name similar to
-# config.sub.  If it succeeds, it prints the system name on stdout, and
-# exits with 0.  Otherwise, it exits with 1.
+# Originally written by Per Bothner.
 #
 # You can get the latest version of this script from:
 # http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD
+#
+# Please send patches with a ChangeLog entry to config-patches@gnu.org.
+
 
 me=`echo "$0" | sed -e 's,.*/,,'`
 
@@ -54,9 +50,7 @@ version="\
 GNU config.guess ($timestamp)
 
 Originally written by Per Bothner.
-Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000,
-2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012
-Free Software Foundation, Inc.
+Copyright 1992-2014 Free Software Foundation, Inc.
 
 This is free software; see the source for copying conditions.  There is NO
 warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
@@ -138,6 +132,27 @@ UNAME_RELEASE=`(uname -r) 2>/dev/null` |
 UNAME_SYSTEM=`(uname -s) 2>/dev/null`  || UNAME_SYSTEM=unknown
 UNAME_VERSION=`(uname -v) 2>/dev/null` || UNAME_VERSION=unknown
 
+case "${UNAME_SYSTEM}" in
+Linux|GNU|GNU/*)
+	# If the system lacks a compiler, then just pick glibc.
+	# We could probably try harder.
+	LIBC=gnu
+
+	eval $set_cc_for_build
+	cat <<-EOF > $dummy.c
+	#include <features.h>
+	#if defined(__UCLIBC__)
+	LIBC=uclibc
+	#elif defined(__dietlibc__)
+	LIBC=dietlibc
+	#else
+	LIBC=gnu
+	#endif
+	EOF
+	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep '^LIBC' | sed 's, ,,g'`
+	;;
+esac
+
 # Note: order is significant - the case branches are not exclusive.
 
 case "${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}" in
@@ -200,6 +215,10 @@ case "${UNAME_MACHINE}:${UNAME_SYSTEM}:$
 	# CPU_TYPE-MANUFACTURER-OPERATING_SYSTEM is used.
 	echo "${machine}-${os}${release}"
 	exit ;;
+    *:Bitrig:*:*)
+	UNAME_MACHINE_ARCH=`arch | sed 's/Bitrig.//'`
+	echo ${UNAME_MACHINE_ARCH}-unknown-bitrig${UNAME_RELEASE}
+	exit ;;
     *:OpenBSD:*:*)
 	UNAME_MACHINE_ARCH=`arch | sed 's/OpenBSD.//'`
 	echo ${UNAME_MACHINE_ARCH}-unknown-openbsd${UNAME_RELEASE}
@@ -302,7 +321,7 @@ case "${UNAME_MACHINE}:${UNAME_SYSTEM}:$
     arm:RISC*:1.[012]*:*|arm:riscix:1.[012]*:*)
 	echo arm-acorn-riscix${UNAME_RELEASE}
 	exit ;;
-    arm:riscos:*:*|arm:RISCOS:*:*)
+    arm*:riscos:*:*|arm*:RISCOS:*:*)
 	echo arm-unknown-riscos
 	exit ;;
     SR2?01:HI-UX/MPP:*:* | SR8000:HI-UX/MPP:*:*)
@@ -801,10 +820,13 @@ EOF
     i*:CYGWIN*:*)
 	echo ${UNAME_MACHINE}-pc-cygwin
 	exit ;;
+    *:MINGW64*:*)
+	echo ${UNAME_MACHINE}-pc-mingw64
+	exit ;;
     *:MINGW*:*)
 	echo ${UNAME_MACHINE}-pc-mingw32
 	exit ;;
-    i*:MSYS*:*)
+    *:MSYS*:*)
 	echo ${UNAME_MACHINE}-pc-msys
 	exit ;;
     i*:windows32*:*)
@@ -852,21 +874,21 @@ EOF
 	exit ;;
     *:GNU:*:*)
 	# the GNU system
-	echo `echo ${UNAME_MACHINE}|sed -e 's,[-/].*$,,'`-unknown-gnu`echo ${UNAME_RELEASE}|sed -e 's,/.*$,,'`
+	echo `echo ${UNAME_MACHINE}|sed -e 's,[-/].*$,,'`-unknown-${LIBC}`echo ${UNAME_RELEASE}|sed -e 's,/.*$,,'`
 	exit ;;
     *:GNU/*:*:*)
 	# other systems with GNU libc and userland
-	echo ${UNAME_MACHINE}-unknown-`echo ${UNAME_SYSTEM} | sed 's,^[^/]*/,,' | tr '[A-Z]' '[a-z]'``echo ${UNAME_RELEASE}|sed -e 's/[-(].*//'`-gnu
+	echo ${UNAME_MACHINE}-unknown-`echo ${UNAME_SYSTEM} | sed 's,^[^/]*/,,' | tr '[A-Z]' '[a-z]'``echo ${UNAME_RELEASE}|sed -e 's/[-(].*//'`-${LIBC}
 	exit ;;
     i*86:Minix:*:*)
 	echo ${UNAME_MACHINE}-pc-minix
 	exit ;;
     aarch64:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     aarch64_be:Linux:*:*)
 	UNAME_MACHINE=aarch64_be
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     alpha:Linux:*:*)
 	case `sed -n '/^cpu model/s/^.*: \(.*\)/\1/p' < /proc/cpuinfo` in
@@ -879,59 +901,54 @@ EOF
 	  EV68*) UNAME_MACHINE=alphaev68 ;;
 	esac
 	objdump --private-headers /bin/sh | grep -q ld.so.1
-	if test "$?" = 0 ; then LIBC="libc1" ; else LIBC="" ; fi
-	echo ${UNAME_MACHINE}-unknown-linux-gnu${LIBC}
+	if test "$?" = 0 ; then LIBC="gnulibc1" ; fi
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
+	exit ;;
+    arc:Linux:*:* | arceb:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     arm*:Linux:*:*)
 	eval $set_cc_for_build
 	if echo __ARM_EABI__ | $CC_FOR_BUILD -E - 2>/dev/null \
 	    | grep -q __ARM_EABI__
 	then
-	    echo ${UNAME_MACHINE}-unknown-linux-gnu
+	    echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	else
 	    if echo __ARM_PCS_VFP | $CC_FOR_BUILD -E - 2>/dev/null \
 		| grep -q __ARM_PCS_VFP
 	    then
-		echo ${UNAME_MACHINE}-unknown-linux-gnueabi
+		echo ${UNAME_MACHINE}-unknown-linux-${LIBC}eabi
 	    else
-		echo ${UNAME_MACHINE}-unknown-linux-gnueabihf
+		echo ${UNAME_MACHINE}-unknown-linux-${LIBC}eabihf
 	    fi
 	fi
 	exit ;;
     avr32*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     cris:Linux:*:*)
-	echo ${UNAME_MACHINE}-axis-linux-gnu
+	echo ${UNAME_MACHINE}-axis-linux-${LIBC}
 	exit ;;
     crisv32:Linux:*:*)
-	echo ${UNAME_MACHINE}-axis-linux-gnu
+	echo ${UNAME_MACHINE}-axis-linux-${LIBC}
 	exit ;;
     frv:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     hexagon:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     i*86:Linux:*:*)
-	LIBC=gnu
-	eval $set_cc_for_build
-	sed 's/^	//' << EOF >$dummy.c
-	#ifdef __dietlibc__
-	LIBC=dietlibc
-	#endif
-EOF
-	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep '^LIBC'`
-	echo "${UNAME_MACHINE}-pc-linux-${LIBC}"
+	echo ${UNAME_MACHINE}-pc-linux-${LIBC}
 	exit ;;
     ia64:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     m32r*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     m68*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     mips:Linux:*:* | mips64:Linux:*:*)
 	eval $set_cc_for_build
@@ -950,54 +967,63 @@ EOF
 	#endif
 EOF
 	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep '^CPU'`
-	test x"${CPU}" != x && { echo "${CPU}-unknown-linux-gnu"; exit; }
+	test x"${CPU}" != x && { echo "${CPU}-unknown-linux-${LIBC}"; exit; }
 	;;
-    or32:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+    openrisc*:Linux:*:*)
+	echo or1k-unknown-linux-${LIBC}
+	exit ;;
+    or32:Linux:*:* | or1k*:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     padre:Linux:*:*)
-	echo sparc-unknown-linux-gnu
+	echo sparc-unknown-linux-${LIBC}
 	exit ;;
     parisc64:Linux:*:* | hppa64:Linux:*:*)
-	echo hppa64-unknown-linux-gnu
+	echo hppa64-unknown-linux-${LIBC}
 	exit ;;
     parisc:Linux:*:* | hppa:Linux:*:*)
 	# Look for CPU level
 	case `grep '^cpu[^a-z]*:' /proc/cpuinfo 2>/dev/null | cut -d' ' -f2` in
-	  PA7*) echo hppa1.1-unknown-linux-gnu ;;
-	  PA8*) echo hppa2.0-unknown-linux-gnu ;;
-	  *)    echo hppa-unknown-linux-gnu ;;
+	  PA7*) echo hppa1.1-unknown-linux-${LIBC} ;;
+	  PA8*) echo hppa2.0-unknown-linux-${LIBC} ;;
+	  *)    echo hppa-unknown-linux-${LIBC} ;;
 	esac
 	exit ;;
     ppc64:Linux:*:*)
-	echo powerpc64-unknown-linux-gnu
+	echo powerpc64-unknown-linux-${LIBC}
 	exit ;;
     ppc:Linux:*:*)
-	echo powerpc-unknown-linux-gnu
+	echo powerpc-unknown-linux-${LIBC}
+	exit ;;
+    ppc64le:Linux:*:*)
+	echo powerpc64le-unknown-linux-${LIBC}
+	exit ;;
+    ppcle:Linux:*:*)
+	echo powerpcle-unknown-linux-${LIBC}
 	exit ;;
     s390:Linux:*:* | s390x:Linux:*:*)
-	echo ${UNAME_MACHINE}-ibm-linux
+	echo ${UNAME_MACHINE}-ibm-linux-${LIBC}
 	exit ;;
     sh64*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     sh*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     sparc:Linux:*:* | sparc64:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     tile*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     vax:Linux:*:*)
-	echo ${UNAME_MACHINE}-dec-linux-gnu
+	echo ${UNAME_MACHINE}-dec-linux-${LIBC}
 	exit ;;
     x86_64:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     xtensa*:Linux:*:*)
-	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	echo ${UNAME_MACHINE}-unknown-linux-${LIBC}
 	exit ;;
     i*86:DYNIX/ptx:4*:*)
 	# ptx 4.0 does uname -s correctly, with DYNIX/ptx in there.
@@ -1201,6 +1227,9 @@ EOF
     BePC:Haiku:*:*)	# Haiku running on Intel PC compatible.
 	echo i586-pc-haiku
 	exit ;;
+    x86_64:Haiku:*:*)
+	echo x86_64-unknown-haiku
+	exit ;;
     SX-4:SUPER-UX:*:*)
 	echo sx4-nec-superux${UNAME_RELEASE}
 	exit ;;
@@ -1227,19 +1256,31 @@ EOF
 	exit ;;
     *:Darwin:*:*)
 	UNAME_PROCESSOR=`uname -p` || UNAME_PROCESSOR=unknown
-	case $UNAME_PROCESSOR in
-	    i386)
-		eval $set_cc_for_build
-		if [ "$CC_FOR_BUILD" != 'no_compiler_found' ]; then
-		  if (echo '#ifdef __LP64__'; echo IS_64BIT_ARCH; echo '#endif') | \
-		      (CCOPTS= $CC_FOR_BUILD -E - 2>/dev/null) | \
-		      grep IS_64BIT_ARCH >/dev/null
-		  then
-		      UNAME_PROCESSOR="x86_64"
-		  fi
-		fi ;;
-	    unknown) UNAME_PROCESSOR=powerpc ;;
-	esac
+	eval $set_cc_for_build
+	if test "$UNAME_PROCESSOR" = unknown ; then
+	    UNAME_PROCESSOR=powerpc
+	fi
+	if test `echo "$UNAME_RELEASE" | sed -e 's/\..*//'` -le 10 ; then
+	    if [ "$CC_FOR_BUILD" != 'no_compiler_found' ]; then
+		if (echo '#ifdef __LP64__'; echo IS_64BIT_ARCH; echo '#endif') | \
+		    (CCOPTS= $CC_FOR_BUILD -E - 2>/dev/null) | \
+		    grep IS_64BIT_ARCH >/dev/null
+		then
+		    case $UNAME_PROCESSOR in
+			i386) UNAME_PROCESSOR=x86_64 ;;
+			powerpc) UNAME_PROCESSOR=powerpc64 ;;
+		    esac
+		fi
+	    fi
+	elif test "$UNAME_PROCESSOR" = i386 ; then
+	    # Avoid executing cc on OS X 10.9, as it ships with a stub
+	    # that puts up a graphical alert prompting to install
+	    # developer tools.  Any system running Mac OS X 10.7 or
+	    # later (Darwin 11 and later) is required to have a 64-bit
+	    # processor. This is not true of the ARM version of Darwin
+	    # that Apple uses in portable devices.
+	    UNAME_PROCESSOR=x86_64
+	fi
 	echo ${UNAME_PROCESSOR}-apple-darwin${UNAME_RELEASE}
 	exit ;;
     *:procnto*:*:* | *:QNX:[0123456789]*:*)
@@ -1256,7 +1297,7 @@ EOF
     NEO-?:NONSTOP_KERNEL:*:*)
 	echo neo-tandem-nsk${UNAME_RELEASE}
 	exit ;;
-    NSE-?:NONSTOP_KERNEL:*:*)
+    NSE-*:NONSTOP_KERNEL:*:*)
 	echo nse-tandem-nsk${UNAME_RELEASE}
 	exit ;;
     NSR-?:NONSTOP_KERNEL:*:*)
@@ -1330,157 +1371,6 @@ EOF
 	exit ;;
 esac
 
-#echo '(No uname command or uname output not recognized.)' 1>&2
-#echo "${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}" 1>&2
-
-eval $set_cc_for_build
-cat >$dummy.c <<EOF
-#ifdef _SEQUENT_
-# include <sys/types.h>
-# include <sys/utsname.h>
-#endif
-main ()
-{
-#if defined (sony)
-#if defined (MIPSEB)
-  /* BFD wants "bsd" instead of "newsos".  Perhaps BFD should be changed,
-     I don't know....  */
-  printf ("mips-sony-bsd\n"); exit (0);
-#else
-#include <sys/param.h>
-  printf ("m68k-sony-newsos%s\n",
-#ifdef NEWSOS4
-	"4"
-#else
-	""
-#endif
-	); exit (0);
-#endif
-#endif
-
-#if defined (__arm) && defined (__acorn) && defined (__unix)
-  printf ("arm-acorn-riscix\n"); exit (0);
-#endif
-
-#if defined (hp300) && !defined (hpux)
-  printf ("m68k-hp-bsd\n"); exit (0);
-#endif
-
-#if defined (NeXT)
-#if !defined (__ARCHITECTURE__)
-#define __ARCHITECTURE__ "m68k"
-#endif
-  int version;
-  version=`(hostinfo | sed -n 's/.*NeXT Mach \([0-9]*\).*/\1/p') 2>/dev/null`;
-  if (version < 4)
-    printf ("%s-next-nextstep%d\n", __ARCHITECTURE__, version);
-  else
-    printf ("%s-next-openstep%d\n", __ARCHITECTURE__, version);
-  exit (0);
-#endif
-
-#if defined (MULTIMAX) || defined (n16)
-#if defined (UMAXV)
-  printf ("ns32k-encore-sysv\n"); exit (0);
-#else
-#if defined (CMU)
-  printf ("ns32k-encore-mach\n"); exit (0);
-#else
-  printf ("ns32k-encore-bsd\n"); exit (0);
-#endif
-#endif
-#endif
-
-#if defined (__386BSD__)
-  printf ("i386-pc-bsd\n"); exit (0);
-#endif
-
-#if defined (sequent)
-#if defined (i386)
-  printf ("i386-sequent-dynix\n"); exit (0);
-#endif
-#if defined (ns32000)
-  printf ("ns32k-sequent-dynix\n"); exit (0);
-#endif
-#endif
-
-#if defined (_SEQUENT_)
-    struct utsname un;
-
-    uname(&un);
-
-    if (strncmp(un.version, "V2", 2) == 0) {
-	printf ("i386-sequent-ptx2\n"); exit (0);
-    }
-    if (strncmp(un.version, "V1", 2) == 0) { /* XXX is V1 correct? */
-	printf ("i386-sequent-ptx1\n"); exit (0);
-    }
-    printf ("i386-sequent-ptx\n"); exit (0);
-
-#endif
-
-#if defined (vax)
-# if !defined (ultrix)
-#  include <sys/param.h>
-#  if defined (BSD)
-#   if BSD == 43
-      printf ("vax-dec-bsd4.3\n"); exit (0);
-#   else
-#    if BSD == 199006
-      printf ("vax-dec-bsd4.3reno\n"); exit (0);
-#    else
-      printf ("vax-dec-bsd\n"); exit (0);
-#    endif
-#   endif
-#  else
-    printf ("vax-dec-bsd\n"); exit (0);
-#  endif
-# else
-    printf ("vax-dec-ultrix\n"); exit (0);
-# endif
-#endif
-
-#if defined (alliant) && defined (i860)
-  printf ("i860-alliant-bsd\n"); exit (0);
-#endif
-
-  exit (1);
-}
-EOF
-
-$CC_FOR_BUILD -o $dummy $dummy.c 2>/dev/null && SYSTEM_NAME=`$dummy` &&
-	{ echo "$SYSTEM_NAME"; exit; }
-
-# Apollos put the system type in the environment.
-
-test -d /usr/apollo && { echo ${ISP}-apollo-${SYSTYPE}; exit; }
-
-# Convex versions that predate uname can use getsysinfo(1)
-
-if [ -x /usr/convex/getsysinfo ]
-then
-    case `getsysinfo -f cpu_type` in
-    c1*)
-	echo c1-convex-bsd
-	exit ;;
-    c2*)
-	if getsysinfo -f scalar_acc
-	then echo c32-convex-bsd
-	else echo c2-convex-bsd
-	fi
-	exit ;;
-    c34*)
-	echo c34-convex-bsd
-	exit ;;
-    c38*)
-	echo c38-convex-bsd
-	exit ;;
-    c4*)
-	echo c4-convex-bsd
-	exit ;;
-    esac
-fi
-
 cat >&2 <<EOF
 $0: unable to guess system type
 
diff -purN debian/config.sub git/config.sub
--- debian/config.sub	2015-08-05 11:05:29.408006538 -0400
+++ git/config.sub	2015-08-05 11:05:22.076007641 -0400
@@ -1,24 +1,18 @@
 #! /bin/sh
 # Configuration validation subroutine script.
-#   Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
-#   2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010,
-#   2011, 2012 Free Software Foundation, Inc.
-
-timestamp='2012-04-18'
-
-# This file is (in principle) common to ALL GNU software.
-# The presence of a machine in this file suggests that SOME GNU software
-# can handle that machine.  It does not imply ALL GNU software can.
-#
-# This file is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
+#   Copyright 1992-2014 Free Software Foundation, Inc.
+
+timestamp='2014-09-11'
+
+# This file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 3 of the License, or
 # (at your option) any later version.
 #
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program; if not, see <http://www.gnu.org/licenses/>.
@@ -26,11 +20,12 @@ timestamp='2012-04-18'
 # As a special exception to the GNU General Public License, if you
 # distribute this file as part of a program that contains a
 # configuration script generated by Autoconf, you may include it under
-# the same distribution terms that you use for the rest of that program.
+# the same distribution terms that you use for the rest of that
+# program.  This Exception is an additional permission under section 7
+# of the GNU General Public License, version 3 ("GPLv3").
 
 
-# Please send patches to <config-patches@gnu.org>.  Submit a context
-# diff and a properly formatted GNU ChangeLog entry.
+# Please send patches with a ChangeLog entry to config-patches@gnu.org.
 #
 # Configuration subroutine to validate and canonicalize a configuration type.
 # Supply the specified configuration type as an argument.
@@ -73,9 +68,7 @@ Report bugs and patches to <config-patch
 version="\
 GNU config.sub ($timestamp)
 
-Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000,
-2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012
-Free Software Foundation, Inc.
+Copyright 1992-2014 Free Software Foundation, Inc.
 
 This is free software; see the source for copying conditions.  There is NO
 warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
@@ -123,7 +116,7 @@ esac
 maybe_os=`echo $1 | sed 's/^\(.*\)-\([^-]*-[^-]*\)$/\2/'`
 case $maybe_os in
   nto-qnx* | linux-gnu* | linux-android* | linux-dietlibc | linux-newlib* | \
-  linux-uclibc* | uclinux-uclibc* | uclinux-gnu* | kfreebsd*-gnu* | \
+  linux-musl* | linux-uclibc* | uclinux-uclibc* | uclinux-gnu* | kfreebsd*-gnu* | \
   knetbsd*-gnu* | netbsd*-gnu* | \
   kopensolaris*-gnu* | \
   storm-chaos* | os2-emx* | rtmk-nova*)
@@ -156,7 +149,7 @@ case $os in
 	-convergent* | -ncr* | -news | -32* | -3600* | -3100* | -hitachi* |\
 	-c[123]* | -convex* | -sun | -crds | -omron* | -dg | -ultra | -tti* | \
 	-harris | -dolphin | -highlevel | -gould | -cbm | -ns | -masscomp | \
-	-apple | -axis | -knuth | -cray | -microblaze)
+	-apple | -axis | -knuth | -cray | -microblaze*)
 		os=
 		basic_machine=$1
 		;;
@@ -259,10 +252,12 @@ case $basic_machine in
 	| alpha | alphaev[4-8] | alphaev56 | alphaev6[78] | alphapca5[67] \
 	| alpha64 | alpha64ev[4-8] | alpha64ev56 | alpha64ev6[78] | alpha64pca5[67] \
 	| am33_2.0 \
-	| arc | arm | arm[bl]e | arme[lb] | armv[2345] | armv[345][lb] | avr | avr32 \
-        | be32 | be64 \
+	| arc | arceb \
+	| arm | arm[bl]e | arme[lb] | armv[2-8] | armv[3-8][lb] | armv7[arm] \
+	| avr | avr32 \
+	| be32 | be64 \
 	| bfin \
-	| c4x | clipper \
+	| c4x | c8051 | clipper \
 	| d10v | d30v | dlx | dsp16xx \
 	| epiphany \
 	| fido | fr30 | frv \
@@ -270,10 +265,11 @@ case $basic_machine in
 	| hexagon \
 	| i370 | i860 | i960 | ia64 \
 	| ip2k | iq2000 \
+	| k1om \
 	| le32 | le64 \
 	| lm32 \
 	| m32c | m32r | m32rle | m68000 | m68k | m88k \
-	| maxq | mb | microblaze | mcore | mep | metag \
+	| maxq | mb | microblaze | microblazeel | mcore | mep | metag \
 	| mips | mipsbe | mipseb | mipsel | mipsle \
 	| mips16 \
 	| mips64 | mips64el \
@@ -287,23 +283,26 @@ case $basic_machine in
 	| mips64vr5900 | mips64vr5900el \
 	| mipsisa32 | mipsisa32el \
 	| mipsisa32r2 | mipsisa32r2el \
+	| mipsisa32r6 | mipsisa32r6el \
 	| mipsisa64 | mipsisa64el \
 	| mipsisa64r2 | mipsisa64r2el \
+	| mipsisa64r6 | mipsisa64r6el \
 	| mipsisa64sb1 | mipsisa64sb1el \
 	| mipsisa64sr71k | mipsisa64sr71kel \
+	| mipsr5900 | mipsr5900el \
 	| mipstx39 | mipstx39el \
 	| mn10200 | mn10300 \
 	| moxie \
 	| mt \
 	| msp430 \
 	| nds32 | nds32le | nds32be \
-	| nios | nios2 \
+	| nios | nios2 | nios2eb | nios2el \
 	| ns16k | ns32k \
-	| open8 \
-	| or32 \
+	| open8 | or1k | or1knd | or32 \
 	| pdp10 | pdp11 | pj | pjl \
 	| powerpc | powerpc64 | powerpc64le | powerpcle \
 	| pyramid \
+	| riscv32 | riscv64 \
 	| rl78 | rx \
 	| score \
 	| sh | sh[1234] | sh[24]a | sh[24]aeb | sh[23]e | sh[34]eb | sheb | shbe | shle | sh[1234]le | sh3ele \
@@ -328,7 +327,7 @@ case $basic_machine in
 	c6x)
 		basic_machine=tic6x-unknown
 		;;
-	m6811 | m68hc11 | m6812 | m68hc12 | m68hcs12x | picochip)
+	m6811 | m68hc11 | m6812 | m68hc12 | m68hcs12x | nvptx | picochip)
 		basic_machine=$basic_machine-unknown
 		os=-none
 		;;
@@ -370,13 +369,13 @@ case $basic_machine in
 	| aarch64-* | aarch64_be-* \
 	| alpha-* | alphaev[4-8]-* | alphaev56-* | alphaev6[78]-* \
 	| alpha64-* | alpha64ev[4-8]-* | alpha64ev56-* | alpha64ev6[78]-* \
-	| alphapca5[67]-* | alpha64pca5[67]-* | arc-* \
+	| alphapca5[67]-* | alpha64pca5[67]-* | arc-* | arceb-* \
 	| arm-*  | armbe-* | armle-* | armeb-* | armv*-* \
 	| avr-* | avr32-* \
 	| be32-* | be64-* \
 	| bfin-* | bs2000-* \
 	| c[123]* | c30-* | [cjt]90-* | c4x-* \
-	| clipper-* | craynv-* | cydra-* \
+	| c8051-* | clipper-* | craynv-* | cydra-* \
 	| d10v-* | d30v-* | dlx-* \
 	| elxsi-* \
 	| f30[01]-* | f700-* | fido-* | fr30-* | frv-* | fx80-* \
@@ -385,11 +384,13 @@ case $basic_machine in
 	| hexagon-* \
 	| i*86-* | i860-* | i960-* | ia64-* \
 	| ip2k-* | iq2000-* \
+	| k1om-* \
 	| le32-* | le64-* \
 	| lm32-* \
 	| m32c-* | m32r-* | m32rle-* \
 	| m68000-* | m680[012346]0-* | m68360-* | m683?2-* | m68k-* \
-	| m88110-* | m88k-* | maxq-* | mcore-* | metag-* | microblaze-* \
+	| m88110-* | m88k-* | maxq-* | mcore-* | metag-* \
+	| microblaze-* | microblazeel-* \
 	| mips-* | mipsbe-* | mipseb-* | mipsel-* | mipsle-* \
 	| mips16-* \
 	| mips64-* | mips64el-* \
@@ -403,18 +404,22 @@ case $basic_machine in
 	| mips64vr5900-* | mips64vr5900el-* \
 	| mipsisa32-* | mipsisa32el-* \
 	| mipsisa32r2-* | mipsisa32r2el-* \
+	| mipsisa32r6-* | mipsisa32r6el-* \
 	| mipsisa64-* | mipsisa64el-* \
 	| mipsisa64r2-* | mipsisa64r2el-* \
+	| mipsisa64r6-* | mipsisa64r6el-* \
 	| mipsisa64sb1-* | mipsisa64sb1el-* \
 	| mipsisa64sr71k-* | mipsisa64sr71kel-* \
+	| mipsr5900-* | mipsr5900el-* \
 	| mipstx39-* | mipstx39el-* \
 	| mmix-* \
 	| mt-* \
 	| msp430-* \
 	| nds32-* | nds32le-* | nds32be-* \
-	| nios-* | nios2-* \
+	| nios-* | nios2-* | nios2eb-* | nios2el-* \
 	| none-* | np1-* | ns16k-* | ns32k-* \
 	| open8-* \
+	| or1k*-* \
 	| orion-* \
 	| pdp10-* | pdp11-* | pj-* | pjl-* | pn-* | power-* \
 	| powerpc-* | powerpc64-* | powerpc64le-* | powerpcle-* \
@@ -788,11 +793,15 @@ case $basic_machine in
 		basic_machine=ns32k-utek
 		os=-sysv
 		;;
-	microblaze)
+	microblaze*)
 		basic_machine=microblaze-xilinx
 		;;
+	mingw64)
+		basic_machine=x86_64-pc
+		os=-mingw64
+		;;
 	mingw32)
-		basic_machine=i386-pc
+		basic_machine=i686-pc
 		os=-mingw32
 		;;
 	mingw32ce)
@@ -820,6 +829,10 @@ case $basic_machine in
 		basic_machine=powerpc-unknown
 		os=-morphos
 		;;
+	moxiebox)
+		basic_machine=moxie-unknown
+		os=-moxiebox
+		;;
 	msdos)
 		basic_machine=i386-pc
 		os=-msdos
@@ -828,7 +841,7 @@ case $basic_machine in
 		basic_machine=`echo $basic_machine | sed -e 's/ms1-/mt-/'`
 		;;
 	msys)
-		basic_machine=i386-pc
+		basic_machine=i686-pc
 		os=-msys
 		;;
 	mvs)
@@ -1019,7 +1032,11 @@ case $basic_machine in
 		basic_machine=i586-unknown
 		os=-pw32
 		;;
-	rdos)
+	rdos | rdos64)
+		basic_machine=x86_64-pc
+		os=-rdos
+		;;
+	rdos32)
 		basic_machine=i386-pc
 		os=-rdos
 		;;
@@ -1346,29 +1363,29 @@ case $os in
 	-gnu* | -bsd* | -mach* | -minix* | -genix* | -ultrix* | -irix* \
 	      | -*vms* | -sco* | -esix* | -isc* | -aix* | -cnk* | -sunos | -sunos[34]*\
 	      | -hpux* | -unos* | -osf* | -luna* | -dgux* | -auroraux* | -solaris* \
-	      | -sym* | -kopensolaris* \
+	      | -sym* | -kopensolaris* | -plan9* \
 	      | -amigaos* | -amigados* | -msdos* | -newsos* | -unicos* | -aof* \
 	      | -aos* | -aros* \
 	      | -nindy* | -vxsim* | -vxworks* | -ebmon* | -hms* | -mvs* \
 	      | -clix* | -riscos* | -uniplus* | -iris* | -rtu* | -xenix* \
 	      | -hiux* | -386bsd* | -knetbsd* | -mirbsd* | -netbsd* \
-	      | -openbsd* | -solidbsd* \
+	      | -bitrig* | -openbsd* | -solidbsd* \
 	      | -ekkobsd* | -kfreebsd* | -freebsd* | -riscix* | -lynxos* \
 	      | -bosx* | -nextstep* | -cxux* | -aout* | -elf* | -oabi* \
 	      | -ptx* | -coff* | -ecoff* | -winnt* | -domain* | -vsta* \
 	      | -udi* | -eabi* | -lites* | -ieee* | -go32* | -aux* \
 	      | -chorusos* | -chorusrdb* | -cegcc* \
 	      | -cygwin* | -msys* | -pe* | -psos* | -moss* | -proelf* | -rtems* \
-	      | -mingw32* | -linux-gnu* | -linux-android* \
-	      | -linux-newlib* | -linux-uclibc* \
-	      | -uxpv* | -beos* | -mpeix* | -udk* \
+	      | -mingw32* | -mingw64* | -linux-gnu* | -linux-android* \
+	      | -linux-newlib* | -linux-musl* | -linux-uclibc* \
+	      | -uxpv* | -beos* | -mpeix* | -udk* | -moxiebox* \
 	      | -interix* | -uwin* | -mks* | -rhapsody* | -darwin* | -opened* \
 	      | -openstep* | -oskit* | -conix* | -pw32* | -nonstopux* \
 	      | -storm-chaos* | -tops10* | -tenex* | -tops20* | -its* \
 	      | -os2* | -vos* | -palmos* | -uclinux* | -nucleus* \
 	      | -morphos* | -superux* | -rtmk* | -rtmk-nova* | -windiss* \
 	      | -powermax* | -dnix* | -nx6 | -nx7 | -sei* | -dragonfly* \
-	      | -skyos* | -haiku* | -rdos* | -toppers* | -drops* | -es*)
+	      | -skyos* | -haiku* | -rdos* | -toppers* | -drops* | -es* | -tirtos*)
 	# Remember, each alternative MUST END IN *, to match a version number.
 		;;
 	-qnx*)
@@ -1492,9 +1509,6 @@ case $os in
 	-aros*)
 		os=-aros
 		;;
-	-kaos*)
-		os=-kaos
-		;;
 	-zvmoe)
 		os=-zvmoe
 		;;
@@ -1543,6 +1557,9 @@ case $basic_machine in
 	c4x-* | tic4x-*)
 		os=-coff
 		;;
+	c8051-*)
+		os=-elf
+		;;
 	hexagon-*)
 		os=-elf
 		;;

--------------060709010009080302030403
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060709010009080302030403--
