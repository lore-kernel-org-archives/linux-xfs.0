Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E62877F37
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 16:35:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 835F5AC003
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 14:35:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9Aqr9nZo3erhH2eJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Sep 2014 14:35:15 -0700 (PDT)
Date: Thu, 4 Sep 2014 17:35:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsrestore: use utimensat() to provide atime/mtime with
	ns resolution
Message-ID: <20140904213511.GA902@bfoster.bfoster>
References: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
	<5408C1B4.1010001@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5408C1B4.1010001@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Sep 04, 2014 at 02:47:00PM -0500, Eric Sandeen wrote:
> On 9/4/14, 11:38 AM, Brian Foster wrote:
> >xfsdump encodes and stores the full atime and mtime for each file with
> >nanosecond resolution. xfsrestore uses utime() to set the times of each
> >file that is restored. The latter supports resolution of 1 second, thus
> >sub-second timestamp data is lost on restore.
> >
> >Add the associated configure checks for and use utimensat() when
> >available to restore timestamps with nanosecond resolution. Create a new
> >helper to facilitate conditional support for utimensat().
> >
> >Signed-off-by: Brian Foster <bfoster@redhat.com>
> >---
> >
> >I'm not totally sure on the configure bits here... it's mostly copied
> >from xfsprogs and tweaked appropriately. It seems to work, at least. ;)
> >
> >Brian
> >
> >  configure.ac          |  2 ++
> >  include/builddefs.in  |  1 +
> >  m4/Makefile           |  1 +
> >  m4/package_libcdev.m4 | 16 ++++++++++++++++
> >  restore/Makefile      |  4 ++++
> >  restore/content.c     | 38 ++++++++++++++++++++++++++++++--------
> >  6 files changed, 54 insertions(+), 8 deletions(-)
> >  create mode 100644 m4/package_libcdev.m4
> >
> >diff --git a/configure.ac b/configure.ac
> >index 59f9564..28e604e 100644
> >--- a/configure.ac
> >+++ b/configure.ac
> >@@ -82,6 +82,8 @@ AC_PACKAGE_NEED_ATTRIBUTES_H
> >  AC_PACKAGE_NEED_ATTRIBUTES_MACROS
> >  AC_PACKAGE_NEED_ATTRGET_LIBATTR
> >
> >+AC_HAVE_UTIMENSAT
> >+
> >  AC_MANUAL_FORMAT
> >
> >  AC_CONFIG_FILES([include/builddefs])
> >diff --git a/include/builddefs.in b/include/builddefs.in
> >index 269c928..bdf0ede 100644
> >--- a/include/builddefs.in
> >+++ b/include/builddefs.in
> >@@ -69,6 +69,7 @@ ENABLE_SHARED	= @enable_shared@
> >  ENABLE_GETTEXT	= @enable_gettext@
> >
> >  HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
> >+HAVE_UTIMENSAT = @have_utimensat@
> >
> >  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
> >  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> >diff --git a/m4/Makefile b/m4/Makefile
> >index 9a35056..ae452f7 100644
> >--- a/m4/Makefile
> >+++ b/m4/Makefile
> >@@ -16,6 +16,7 @@ LSRCFILES = \
> >  	manual_format.m4 \
> >  	package_attrdev.m4 \
> >  	package_globals.m4 \
> >+	package_libcdev.m4 \
> >  	package_ncurses.m4 \
> >  	package_pthread.m4 \
> >  	package_utilies.m4 \
> >diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> >new file mode 100644
> >index 0000000..6fcbdba
> >--- /dev/null
> >+++ b/m4/package_libcdev.m4
> >@@ -0,0 +1,16 @@
> >+#
> >+# Check if we have a utimensat libc call
> >+#
> >+AC_DEFUN([AC_HAVE_UTIMENSAT],
> >+  [ AC_MSG_CHECKING([for utimensat])
> >+    AC_TRY_COMPILE([
> 
> (as discussed on IRC...)
> 
> I think you need AC_TRY_LINK here; changing utimensat() to utimensatFOO() still
> passes.  ;)
> 

Yeah... I tested that by breaking the function signature. I'm guessing
this does a 'gcc -c,' which lets me compile pretty much any kind of call
if no function declaration is found in a header. AC_TRY_LINK() does what
we want. Thanks for catching that.

Brian

> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
