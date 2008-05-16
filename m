Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 22:29:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G5Sfi6019124
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 22:28:44 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA23121; Fri, 16 May 2008 15:29:18 +1000
Message-ID: <482D1BAE.9070109@sgi.com>
Date: Fri, 16 May 2008 15:29:18 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] re-enable test 010
References: <20080515171619.GA10094@lst.de>
In-Reply-To: <20080515171619.GA10094@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> The dbtest program required for testcase 010 hasn't been build for ages
> due to various crufty autofoo magic.  The patch below just builds it
> unconditionally for Linux as all distros should have the ndbm compat
> bits for libgdbm in the same place.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'd rather we fixed the autofoo magic rather than just chop it out,
Gdbm isn't always packaged the same way.

Currently on Suse (gdbm-devel) it doesnt build, with your patch we get
build errors. On Rhel (unknown package) it builds fine as is but would
break with your patch.

I've been trying to figure out the autotools foo required to fix this,
we'll need to add your include/lib layout into the mix too.

Anyone know autotools?

Don

..
gcc -g -O2 -DDEBUG -I../include -DVERSION=\"1.0.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c -o dbtest.o dbtest.c
dbtest.c:20:23: error: gdbm-ndbm.h: No such file or directory

donaldd@molten ~/isms/xfs-cmds/xfstests
$ rpm -ql gdbm-devel
/usr/include/dbm.h
/usr/include/gdbm.h
/usr/include/ndbm.h
/usr/lib64/libgdbm.a
/usr/lib64/libgdbm.la
/usr/lib64/libgdbm.so
/usr/lib64/libgdbm_compat.a
/usr/lib64/libgdbm_compat.la
/usr/lib64/libgdbm_compat.so
/usr/lib64/libndbm.a
/usr/lib64/libndbm.so
/usr/share/info/gdbm.info.gz
/usr/share/man/man3/gdbm.3.gz

> Index: xfstests/src/Makefile
> ===================================================================
> RCS file: /cvs/xfs-cmds/xfstests/src/Makefile,v
> retrieving revision 1.43
> diff -u -p -r1.43 Makefile
> --- xfstests/src/Makefile	3 Oct 2007 16:23:57 -0000	1.43
> +++ xfstests/src/Makefile	15 May 2008 17:13:50 -0000
> @@ -15,7 +15,7 @@ TARGETS = dirstress fill fill2 getpagesi
>  LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
>  	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
>  	fs_perms testx looptest locktest unwritten_mmap \
> -	bulkstat_unlink_test bulkstat_unlink_test_modified
> +	bulkstat_unlink_test bulkstat_unlink_test_modified dbtest t_immutable
>  
>  IRIX_TARGETS = open_unlink
>  
> @@ -27,14 +27,6 @@ ifeq ($(PKG_PLATFORM),irix)
>  TARGETS += $(IRIX_TARGETS)
>  endif
>  
> -ifeq ($(HAVE_DB), true)
> -TARGETS += dbtest
> -endif
> -
> -ifeq ($(PKG_PLATFORM),linux)
> -TARGETS += t_immutable
> -endif
> -
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS)
>  
> @@ -50,7 +42,7 @@ truncfile: truncfile.o $(LIBTEST)
>  	$(LINKTEST) $(LIBTEST) $(LDLIBS)
>  
>  dbtest:	dbtest.o $(LIBTEST)
> -	$(LINKTEST) $(LIBTEST) $(LIBGDBM) $(LDLIBS)
> +	$(LINKTEST) $(LIBTEST) -lgdbm_compat $(LDLIBS)
>  
>  nametest: nametest.o $(LIBTEST)
>  	$(LINKTEST) $(LIBTEST) $(LDLIBS)
> Index: xfstests/src/dbtest.c
> ===================================================================
> RCS file: /cvs/xfs-cmds/xfstests/src/dbtest.c,v
> retrieving revision 1.6
> diff -u -p -r1.6 dbtest.c
> --- xfstests/src/dbtest.c	9 Nov 2005 02:50:19 -0000	1.6
> +++ xfstests/src/dbtest.c	15 May 2008 17:13:51 -0000
> @@ -17,20 +17,7 @@
>   */
>   
>  #include "global.h"
> -
> -#ifdef HAVE_GDBM_NDBM_H
> -#include <gdbm/ndbm.h>
> -#else
> -#ifdef HAVE_GDBM_H
> -#include <gdbm.h>
> -#else
> -#ifdef HAVE_NDBM_H
> -#include <ndbm.h>
> -#else
> -bozo!
> -#endif
> -#endif
> -#endif
> +#include <gdbm-ndbm.h>
>  
>  
>  /* #define WorkDir	"/xfs" */
> 
