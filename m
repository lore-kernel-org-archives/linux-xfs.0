Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7I566Ja091723 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 00:06:07 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EBA8CD596B
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 22:15:51 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id eRfDFoXCQLBlmcRa for
	<xfs@oss.sgi.com>; Tue, 17 Aug 2010 22:15:51 -0700 (PDT)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam & Virus Firewall) with ESMTP id
	E92FB27F4F6
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 15:06:32 +1000 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id Al2Xgm1LxeCAashA for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 15:06:32 +1000 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.102.10])
	by postoffice.aconex.com (Postfix) with ESMTP id D61E5A503C8
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 15:06:32 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id D3B4ABC019F
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 15:06:32 +1000 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id W5+rHFXhioMQ for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 15:06:28 +1000 (EST)
Received: from mail-au.aconex.com (mail-au.aconex.com [192.168.102.12])
	by gatekeeper.aconex.com (Postfix) with ESMTP id D19F5BC019E
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 15:06:28 +1000 (EST)
Received: from mail-au.aconex.com (mail-au.aconex.com [192.168.102.12])
	by mail-au.aconex.com (Postfix) with ESMTP id CBFF164B86F4
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 15:06:28 +1000 (EST)
Date: Wed, 18 Aug 2010 15:06:28 +1000 (EST)
From: nathans@aconex.com
Message-ID: <86828409.114311282107988740.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <472498892.114291282107960876.JavaMail.root@mail-au.aconex.com>
Subject: Review: xfsprogs with libblkid enabled for Debian
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_8094_1097065593.1282107988739"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

------=_Part_8094_1097065593.1282107988739
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi guys,

Attached patch adds support for libblkid in Debian builds.
There's a couple of other trivial things fixed up while the
package was building - man page typos reported by lintian,
fix source tarball generation (and deb build) when libblkid
is enabled (*must* descend into libdisk to pick up sources)
... but its all pretty straight forward.

I've checked that mkfs.xfs is linked as expected too. :)

cheers.

-- 
Nathan

------=_Part_8094_1097065593.1282107988739
Content-Type: text/x-patch; name=patchlet
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=patchlet

diff --git a/Makefile b/Makefile
index 9d98bb0..c40fb2c 100644
--- a/Makefile
+++ b/Makefile
@@ -39,14 +39,10 @@ LDIRDIRT = $(SRCDIR)
 LDIRT += $(SRCTAR)
 endif
 
-LIB_SUBDIRS = libxfs libxlog libxcmd libhandle $(LDISK)
+LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc po debian
 
-ifneq ($(ENABLE_BLKID), yes)
-LIB_SUBDIRS += libdisk
-endif
-
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/platform_defs.h
diff --git a/VERSION b/VERSION
index 40f0361..58a77e2 100644
--- a/VERSION
+++ b/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=2
+PKG_REVISION=3
 PKG_BUILD=1
diff --git a/debian/changelog b/debian/changelog
index c1f3257..502c8e8 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,10 @@
+xfsprogs (3.1.3) unstable; urgency=low
+
+  * New upstream release
+  * Enforce building with libblkid (closes: #593320)
+
+ -- Nathan Scott <nathans@debian.org>  Wed, 18 Aug 2010 13:34:59 +1000
+
 xfsprogs (3.1.2) unstable; urgency=low
 
   * New upstream release
diff --git a/debian/control b/debian/control
index 5130bab..0f437b2 100644
--- a/debian/control
+++ b/debian/control
@@ -3,15 +3,15 @@ Section: admin
 Priority: optional
 Maintainer: Nathan Scott <nathans@debian.org>
 Uploaders: Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev
-Standards-Version: 3.8.1
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev, libblkid-dev
+Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/
 
 Package: xfsprogs
 Depends: ${shlibs:Depends}, ${misc:Depends}
 Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
-Conflicts: xfsdump (<< 3.0.0)
+Breaks: xfsdump (<< 3.0.0)
 Architecture: any
 Description: Utilities for managing the XFS filesystem
  A set of commands to use the XFS filesystem, including mkfs.xfs.
@@ -29,8 +29,8 @@ Description: Utilities for managing the XFS filesystem
 Package: xfslibs-dev
 Section: libdevel
 Priority: extra
-Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0)
-Conflicts: xfsprogs (<< 3.0.0)
+Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
+Breaks: xfsprogs (<< 3.0.0)
 Architecture: any
 Description: XFS filesystem-specific static libraries and headers
  xfslibs-dev contains the libraries and header files needed to
diff --git a/debian/rules b/debian/rules
index 8c15dcb..a26195d 100755
--- a/debian/rules
+++ b/debian/rules
@@ -20,7 +20,7 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS=--enable-readline=yes ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ;
 diopts  = $(options) \
 	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no" ;
 checkdir = test -f debian/rules
diff --git a/doc/CHANGES b/doc/CHANGES
index 9a3b998..c433a50 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,12 @@
+xfsprogs-3.1.3 (18 August 2010)
+	- Fix depend targets.
+	- Allow xfs_io resvsp command for foreign filesystems.
+	- Fix configure --prefix.
+	- Make xfs_db check for valid inode data pointer before dereferencing.
+	- Unbreak make update-po, permissions problem.
+	- Fix linking of libxfs. Fix librt detection (needs pthread).
+	- Add a platform_discard_blocks stub for GNU/kFreebsd.
+
 xfsprogs-3.1.2 (6 May 2010)
 	- Fix missing thread synchronization in xfs_repair duplicate
 	  extent tracking.
diff --git a/libdisk/Makefile b/libdisk/Makefile
index f56f3b4..b058a9f 100644
--- a/libdisk/Makefile
+++ b/libdisk/Makefile
@@ -20,7 +20,11 @@ else
 LSRCFILES = $(LINUX_DRIVERS)
 endif
 
+ifneq ($(ENABLE_BLKID), yes)
 default: ltdepend $(LTLIBRARY)
+else
+default:
+endif
 
 include $(BUILDRULES)
 
diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 0aadc4a..a7d2b68 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -38,7 +38,7 @@ can be destroyed.
 Shows restore progress on stdout.
 .SH DIAGNOSTICS
 .B xfs_mdrestore
-returns an exit code of 0 if all the metadata is succesfully restored or
+returns an exit code of 0 if all the metadata is successfully restored or
 1 if an error occurs.
 .SH SEE ALSO
 .BR xfs_metadump (8),
@@ -47,4 +47,4 @@ returns an exit code of 0 if all the metadata is succesfully restored or
 .BR xfs (5)
 .SH BUGS
 Email bug reports to
-.BR xfs@oss.sgi.com .
\ No newline at end of file
+.BR xfs@oss.sgi.com .
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index f0ff1ae..9672713 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -98,11 +98,11 @@ copied.
 Disables obfuscation of file names and extended attributes.
 .TP
 .B \-w
-Prints warnings of inconsistant metadata encountered to stderr. Bad metadata
+Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
 .SH DIAGNOSTICS
 .B xfs_metadump
-returns an exit code of 0 if all readable metadata is succesfully copied or
+returns an exit code of 0 if all readable metadata is successfully copied or
 1 if a write error occurs or a read error occurs and the
 .B \-e
 option used.

------=_Part_8094_1097065593.1282107988739
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_8094_1097065593.1282107988739--
