Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n24HRvk5098003 for <xfs@oss.sgi.com>; Wed, 4 Mar 2009 11:27:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD2A416F9BD
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 09:27:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1m1HFBis1nx2ekZK for
	<xfs@oss.sgi.com>; Wed, 04 Mar 2009 09:27:30 -0800 (PST)
Date: Wed, 4 Mar 2009 12:27:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090304172727.GA21463@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200902261323.09312.agruen@suse.de>
	<200902261017.30017.vapier@gentoo.org>
	<200902271835.30912.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902271835.30912.agruen@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 27, 2009 at 06:35:30PM +0100, Andreas Gruenbacher wrote:
> Okay, I've done that now in the configure Makefile target. This is an 
> improvement we definitely want, independent of whether or not we end up 
> shipping generated files.

I've tried to port the patch you checked into xfsprogs (see below for
the diff), but it fails to build for me.  Any idea what might have
gone wrong?

diff --git a/Makefile b/Makefile
index 133e496..4b61e41 100644
--- a/Makefile
+++ b/Makefile
@@ -12,8 +12,9 @@ endif
 CONFIGURE = configure include/builddefs include/platform_defs.h
 LSRCFILES = configure configure.in Makepkgs aclocal.m4 install-sh README VERSION
 
-LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	Logs/* built .census install.* install-dev.* *.gz
+LDIRT = config.log config.status config.cache config.guess config.sub \
+	confdefs.h ltmain.sh libtool built .census \
+	Logs/* conftest* install.* install-dev.* *.dep *.gz
 
 LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
@@ -21,7 +22,7 @@ TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
-default: include/builddefs include/platform_defs.h
+default: configure include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(MAKE) -C . $@
 else
@@ -46,6 +47,8 @@ clean:	# if configure hasn't run, nothing to clean
 endif
 
 configure include/builddefs:
+	libtoolize -c -f
+	aclocal -I m4
 	autoconf
 	./configure \
 		--prefix=/ \
@@ -68,9 +71,6 @@ include/platform_defs.h: include/builddefs
 		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
 	fi
 
-aclocal.m4::
-	aclocal --acdir=`pwd`/m4 --output=$@
-
 install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
diff --git a/configure.in b/configure.in
index 4e4e50c..531d7d0 100644
--- a/configure.in
+++ b/configure.in
@@ -1,6 +1,9 @@
 AC_INIT(include/libxfs.h)
+AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER(include/platform_defs.h)
 
+AC_PROG_LIBTOOL
+
 AC_ARG_ENABLE(shared,
 [ --enable-shared=[yes/no] Enable use of shared libraries [default=yes]],,
 	enable_shared=yes)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
