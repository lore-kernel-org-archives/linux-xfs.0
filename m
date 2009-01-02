Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n023lrSD022002 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 21:47:54 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 702F01BF8A21
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 19:47:49 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 3QdOpB8Ts97JgPZK for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 19:47:49 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id CFB4DAC6273
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 21:47:49 -0600 (CST)
Message-ID: <495D8E64.5070206@sandeen.net>
Date: Thu, 01 Jan 2009 21:47:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests Makepkgs framework, builds rpms
References: <495D42CE.6060806@sandeen.net>
In-Reply-To: <495D42CE.6060806@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

With the install target in place, this lets us do Makepkgs:

== dist, log is Logs/dist
Wrote: /root/src/xfstests-dev.work/build/xfstests-1.0.0.src.tar.gz
Wrote: /root/src/xfstests-dev.work/build/tar/xfstests-1.0.0.tar.gz
Wrote: /root/src/xfstests-dev.work/build/rpm/xfstests-1.0.0-1.src.rpm
Wrote: /root/src/xfstests-dev.work/build/rpm/xfstests-1.0.0-1.x86_64.rpm

It's all largely cut & pasted from the xfsprogs framework.
I'll let the debian elves do the things they do for debian 
packaging if they're interested...

xfstests could use more work to make it package-friendly but this
is a good start at least.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfstests-dev.work/Makepkgs
===================================================================
--- /dev/null
+++ xfstests-dev.work/Makepkgs
@@ -0,0 +1,88 @@
+#! /bin/sh
+#
+#	Make whichever packages have been requested.
+#	Defaults to RPMs.
+#
+LOGDIR=Logs
+
+type=rpm
+verbose=false
+
+MAKE=${MAKE:-make}
+test ! -z "$MAKE" && make=$MAKE
+
+for opt in $*
+do
+	case "$opt" in
+	clean)
+		;; # ignored, kept for backward compatibility
+	rpm)
+		type=rpm ;;
+	debian)
+		type=debian ;;
+	verbose)
+		verbose=true ;;
+	*)
+		echo "Usage: Makepkgs [verbose] [debian|rpm]"; exit 1 ;;
+	esac
+done
+
+# start with a clean manifest
+test -f files.rpm && rm -f files.rpm
+test -f filesdevel.rpm && rm -f filesdevel.rpm
+test -f fileslib.rpm && rm -f fileslib.rpm
+
+test ! -d $LOGDIR && mkdir $LOGDIR
+rm -rf $LOGDIR/* > /dev/null 2>&1
+
+# build Debian packages, cleans itself before starting
+SUDO=${SUDO:-sudo}
+test ! -z "$SUDO" && sudo=$SUDO
+if [ $type = debian ] ; then
+	LOGDEB=`pwd`
+	LOGDEB=../`basename $LOGDEB`.log
+	echo "== Debian build, log is $LOGDEB"; echo
+	if $verbose ; then
+		dpkg-buildpackage -r$SUDO | tee $LOGDEB
+	else
+		dpkg-buildpackage -r$SUDO > $LOGDEB || exit 1
+	fi
+	exit 0
+fi
+
+# build RPM packages - manual clean before starting
+echo "== clean, log is $LOGDIR/clean"
+if $verbose ; then
+	$MAKE clean 2>&1 | tee $LOGDIR/clean
+else
+	$MAKE clean > $LOGDIR/clean 2>&1  || exit 1
+fi
+
+echo
+echo "== configure, log is $LOGDIR/configure"
+rm -f .census	# force configure to run here
+if $verbose ; then
+	$MAKE configure 2>&1 | tee $LOGDIR/configure
+else
+	$MAKE configure > $LOGDIR/configure 2>&1 || exit 1
+fi
+
+echo
+echo "== default, log is $LOGDIR/default"
+if $verbose ; then
+	$MAKE default 2>&1 | tee $LOGDIR/default
+else
+	$MAKE default > $LOGDIR/default 2>&1 || exit 1
+fi
+
+echo
+echo "== dist, log is $LOGDIR/dist"
+[ ! -f .census ] && touch .census
+if $verbose ; then
+	$MAKE -C build dist 2>&1 | tee $LOGDIR/dist
+else
+	$MAKE -C build dist > $LOGDIR/dist 2>&1 || exit 1
+	grep '^Wrote:' $LOGDIR/dist | sed -e 's/\.\.\/\.\.\///'
+fi
+
+exit 0
Index: xfstests-dev.work/build/rpm/macros.template
===================================================================
--- /dev/null
+++ xfstests-dev.work/build/rpm/macros.template
@@ -0,0 +1,30 @@
+#
+# rpmrc.template
+#
+# Template to fudge rpm directory structure inside IRIX-like build
+# environment
+
+# Force 386 build on all platforms
+%_target i386-pc-linux
+%_target_cpu i386
+%_target_os linux
+
+# topdir == $(WORKAREA)
+%_topdir %topdir%
+
+# Following directories are specific to the topdir
+# This is where build is done. In our case it's the same as $WORKAREA
+%_builddir %topdir%
+
+# This is where foo.1.99.tar.gz is living in the real world.
+# Be careful not to run full rpm build as it will override the sources
+%_sourcedir %topdir%/build
+
+# This is where binary RPM and source RPM would end up
+%_rpmdir    %topdir%/build/rpm
+%_srcrpmdir %topdir%/build/rpm
+%_specdir   %topdir%/build/rpm
+
+# Leave RPM files in the same directory - we're not building for
+# multiple architectures
+%_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm
Index: xfstests-dev.work/build/rpm/xfstests.spec.in
===================================================================
--- /dev/null
+++ xfstests-dev.work/build/rpm/xfstests.spec.in
@@ -0,0 +1,49 @@
+Summary: XFS regression test suite
+Name: @pkg_name@
+Version: @pkg_version@
+Release: @pkg_release@
+Distribution: @pkg_distribution@
+Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
+BuildRoot: @build_root@
+BuildRequires:  autoconf, xfsprogs-devel, e2fsprogs-devel
+BuildREquires:  libacl-devel, libattr-devel, libaio-devel
+Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
+Requires:       bc, indent, quota
+Source: @pkg_name@-@pkg_version@.src.tar.gz
+License: GPL2+
+Vendor: Silicon Graphics, Inc.
+URL: http://oss.sgi.com/projects/xfs/
+Group: System Environment/Base
+
+%description
+The XFS regression test suite.  Also includes some support for
+acl, attr, dmapi, udf, and nfs testing.  Contains around 200 specific tests
+for userspace & kernelspace.
+
+%prep
+if [ -f .census ] ; then
+   if [ ! -d ${RPM_PACKAGE_NAME}-${RPM_PACKAGE_VERSION} ] ; then
+      ln -s . ${RPM_PACKAGE_NAME}-${RPM_PACKAGE_VERSION}
+   fi
+else
+%setup
+INSTALL_USER=root
+INSTALL_GROUP=root
+export INSTALL_USER INSTALL_GROUP
+@make@ configure
+fi
+
+%build
+@make@
+
+%install
+DIST_ROOT="$RPM_BUILD_ROOT"
+DIST_INSTALL=`pwd`/install.manifest
+export DIST_ROOT DIST_INSTALL
+@make@ install DIST_MANIFEST="$DIST_INSTALL"
+@make@ -C build/rpm rpmfiles DIST_MANIFEST="$DIST_INSTALL"
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%files -f build/rpm/rpmfiles

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
