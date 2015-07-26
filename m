Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 045B87F9D
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:28:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA8FD304048
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:28:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3Cvi5FRYez7UcLFt (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:28:25 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:28:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfsprogs: blkid is now mandatory
Message-ID: <20150726162824.GA16659@infradead.org>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436346893-11831-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, sandeen@redhat.com, xfs@oss.sgi.com

On Wed, Jul 08, 2015 at 11:14:53AM +0200, Jan Tulak wrote:
> Because blkid is here for a long time, I hereby propose a patch for
> removing support for NOT having blkid. The current support through
> set of #ifdef is prone to errors like
> making a patch just in one of the branches, and according to a
> recent talk between Christoph and Eric, it is not necessary to keep
> it supported.
> 
> Remove code for checking ENABLE_BLKID, and the code when
> ENABLE_BLKID is not defined.  The only use of libdisk was in the
> removed code, so remove libdisk too.  It makes blkid required for
> compilation.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  Makefile             |   6 +-
>  configure.ac         |   6 +-
>  debian/rules         |   2 +-
>  include/Makefile     |   2 +-
>  include/builddefs.in |   2 -
>  include/fstyp.h      |  43 -----
>  libdisk/Makefile     |  37 -----
>  libdisk/dm.c         | 112 -------------
>  libdisk/drivers.c    |  82 ----------
>  libdisk/drivers.h    |  45 ------
>  libdisk/evms.c       |  68 --------
>  libdisk/evms.h       |  32 ----
>  libdisk/fstype.c     | 442 ---------------------------------------------------
>  libdisk/fstype.h     | 334 --------------------------------------
>  libdisk/lvm.c        | 117 --------------
>  libdisk/md.c         | 119 --------------
>  libdisk/md.h         |  67 --------
>  libdisk/pttype.c     | 118 --------------
>  libdisk/pttype.h     |  50 ------
>  libdisk/xvm.c        |  93 -----------
>  libdisk/xvm.h        |  53 ------
>  m4/package_blkid.m4  |  20 ++-
>  mkfs/Makefile        |  22 +--
>  mkfs/fstyp.c         |  59 -------
>  mkfs/xfs_mkfs.c      | 100 +-----------
>  po/de.po             |  51 ------
>  po/pl.po             |  49 ------
>  27 files changed, 16 insertions(+), 2115 deletions(-)
>  delete mode 100644 include/fstyp.h
>  delete mode 100644 libdisk/Makefile
>  delete mode 100644 libdisk/dm.c
>  delete mode 100644 libdisk/drivers.c
>  delete mode 100644 libdisk/drivers.h
>  delete mode 100644 libdisk/evms.c
>  delete mode 100644 libdisk/evms.h
>  delete mode 100644 libdisk/fstype.c
>  delete mode 100644 libdisk/fstype.h
>  delete mode 100644 libdisk/lvm.c
>  delete mode 100644 libdisk/md.c
>  delete mode 100644 libdisk/md.h
>  delete mode 100644 libdisk/pttype.c
>  delete mode 100644 libdisk/pttype.h
>  delete mode 100644 libdisk/xvm.c
>  delete mode 100644 libdisk/xvm.h
>  delete mode 100644 mkfs/fstyp.c
> 
> diff --git a/Makefile b/Makefile
> index 6d6803b..798f02a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -43,7 +43,7 @@ endif
>  # header install rules to populate include/xfs correctly
>  HDR_SUBDIRS = include libxfs
>  
> -DLIB_SUBDIRS = libxlog libxcmd libhandle libdisk
> +DLIB_SUBDIRS = libxlog libxcmd libhandle
>  LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
>  TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
>  		mdrestore repair rtcp m4 man doc po debian
> @@ -71,10 +71,6 @@ quota: libxcmd
>  repair: libxlog
>  
>  
> -ifneq ($(ENABLE_BLKID), yes)
> -mkfs: libdisk
> -endif
> -
>  ifeq ($(HAVE_BUILDDEFS), yes)
>  include $(BUILDRULES)
>  else
> diff --git a/configure.ac b/configure.ac
> index fe991cc..fac3ea7 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -37,10 +37,6 @@ AC_ARG_ENABLE(termcap,
>  	test $enable_termcap = yes && libtermcap="-ltermcap",)
>  AC_SUBST(libtermcap)
>  
> -# AC_HAVE_BLKID_TOPO below wil find the library & check for topo support
> -AC_ARG_ENABLE(blkid,
> -[ --enable-blkid=[yes/no] Enable block device id library [default=yes]],,
> -	enable_blkid=yes)
>  
>  AC_ARG_ENABLE(lib64,
>  [ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
> @@ -111,7 +107,7 @@ AC_HAVE_FALLOCATE
>  AC_HAVE_FIEMAP
>  AC_HAVE_PREADV
>  AC_HAVE_SYNC_FILE_RANGE
> -AC_HAVE_BLKID_TOPO($enable_blkid)
> +AC_HAVE_BLKID_TOPO
>  AC_HAVE_READDIR
>  
>  AC_CHECK_SIZEOF([long])
> diff --git a/debian/rules b/debian/rules
> index 27b043f..10d04f8 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -47,7 +47,7 @@ dibuild:
>  		for dir in include libxfs; do \
>  			$(MAKE) -C $$dir NODEP=1 install-headers; \
>  		done; \
> -		for dir in include libxfs libdisk mkfs; do \
> +		for dir in include libxfs mkfs; do \
>  			$(MAKE) -C $$dir; \
>  		done; \
>  		mv mkfs/mkfs.xfs mkfs/mkfs.xfs-$(bootpkg); \
> diff --git a/include/Makefile b/include/Makefile
> index 91b33b0..63a7748 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -46,7 +46,7 @@ HFILES = handle.h \
>  	xqm.h
>  
>  PHFILES = darwin.h freebsd.h irix.h linux.h gnukfreebsd.h
> -DKHFILES = volume.h fstyp.h dvh.h
> +DKHFILES = volume.h dvh.h

These two aren't useful without libdisk, so they should be
removed from the repository an the Makefile as well.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
