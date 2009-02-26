Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1QCOFcP254896 for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 06:24:16 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3FC015709D
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 04:23:45 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id GD2Z0CMDpAGA8RIH for <xfs@oss.sgi.com>;
	Thu, 26 Feb 2009 04:23:45 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Thu, 26 Feb 2009 13:23:08 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<200902260126.14606.agruen@suse.de>
	<200902252003.32646.vapier@gentoo.org>
In-Reply-To: <200902252003.32646.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tmopJ3VcNEKe5RS"
Message-Id: <200902261323.09312.agruen@suse.de>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--Boundary-00=_tmopJ3VcNEKe5RS
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 26 February 2009 02:03:29 Mike Frysinger wrote:
> On Wednesday 25 February 2009 19:26:14 Andreas Gruenbacher wrote:
> > On Wednesday, 25 February 2009 0:45:25 Mike Frysinger wrote:
> > > and for attr.git:
> > > http://sources.gentoo.org/sys-apps/attr/files/attr-2.4.39-gettext.patch
> >
> > This functionality already exists (in both the acl and attr packages).
>
> was this in the last release (2.4.43) ?  either way, can you highlight the
> code you're referring to so there's no confusion on my part ;)

Hmm ... so there code that this patch adds to include/gettext.h already exists 
in include/config.h.in, but ENABLE_GETTEXT isn't being defined anywhere. So 
this part of your patch still seems to be needed, in both the attr and acl 
packages.

When I add it, I get this far:

	$ make aclocal.m4
	$ autoconf
	configure:3493: error: possibly undefined macro: AC_PROG_LIBTOOL
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.

It turns out that aclocal.m4 is created with only the macros in the m4/ 
directory, and AC_PROG_LIBTOOL is not among them; this can be checked with:

	$ aclocal --acdir=m4 --verbose

This would usually be fixed by including the macros in m4/ in addition, but 
then I run into the next problem:

	$ aclocal -I m4
	$ autoconf
	[...]
	configure: error: cannot run /bin/sh ./config.sub

As per one of the libtool info pages,

> In order to use libtool, you need to include the following files with
> your package:
>
> `config.guess'
>      Attempt to guess a canonical system name.
>
> `config.sub'
>      Canonical system name validation subroutine script.
>
> `install-sh'
>      BSD-compatible `install' replacement script.
>
> `ltmain.sh'
>      A generic script implementing basic libtool functionality.

after adding config.guess, config.sub from automake, and ltmain.sh from 
libtool (we already have our own install-sh), the package builds again.

I'm attaching a diff relative to the current repo excluding config.guess, 
config.sub, and ltmain.sh which should be on your systems from automake and 
libtool already.

This is quite insane. Is there a more reasonable way?

Thanks,
Andreas

--Boundary-00=_tmopJ3VcNEKe5RS
Content-Type: text/x-patch;
  charset="utf-8";
  name="libtool-and-gettext-fixes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libtool-and-gettext-fixes.diff"

diff --git a/.gitignore b/.gitignore
index a4d8b60..6391bdc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,3 +25,4 @@ attr-*.tar.gz
 *.o
 /po/attr.pot
 /setfattr/setfattr
+/libtool
diff --git a/Makefile b/Makefile
index 7d2faad..e42a371 100644
--- a/Makefile
+++ b/Makefile
@@ -11,6 +11,7 @@ endif
 
 CONFIGURE = configure include/builddefs include/config.h
 LSRCFILES = configure configure.in aclocal.m4 Makepkgs install-sh exports \
+	config.sub config.guess ltmain.sh \
 	README VERSION
 
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
@@ -63,7 +64,7 @@ include/config.h: include/builddefs
 	fi
 
 aclocal.m4::
-	aclocal --acdir=`pwd`/m4 --output=$@
+	aclocal -I m4
 
 install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index 6569e3b..38d623c 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -100,6 +100,7 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
         xgettext=$XGETTEXT
         AC_SUBST(xgettext)
         AC_PACKAGE_NEED_UTILITY($1, "$xgettext", xgettext, gettext)
+	AC_DEFINE([ENABLE_GETTEXT], 1, [enable gettext])
     fi
 
     if test -z "$RPM"; then

--Boundary-00=_tmopJ3VcNEKe5RS
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Boundary-00=_tmopJ3VcNEKe5RS--
