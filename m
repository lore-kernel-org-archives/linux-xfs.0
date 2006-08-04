Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 07:25:44 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74EPHDW030500
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 07:25:29 -0700
Message-ID: <44D35885.8070507@sgi.com>
Date: Fri, 04 Aug 2006 09:24:05 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com>
In-Reply-To: <44D10F9B.8090904@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

I'm concerned about distributions inadvertently turning off dmapi
support in their xfsdump builds. An explicit ./configure switch
to disable dmapi support would be better, IMHO. But either way
it would be a build-time decision rather than a run-time decision.

xfsdump only uses one DMAPI call (dm_make_handle), so this could
easily be done with dlopen/dlsym, and this would eliminate the
dmapi requirement for those not using -a. dmapi would still be
a build requirement for xfsdump.

Ideally, hsmapi.c wouldn't even exist in xfsdump -- the current
implementation belongs in DMF. There should be a plugin mechanism
added to xfsdump to allow the loading libraries that implement
the API in hsmapi.c (though that interface needs some work first).

Bill

Russell Cattelan wrote:
> Since very few people run xfs with dmapi enabled it seem kind of silly
> to force the install of the dmapi utils/libraries just for xfs 
> dump/restore.
> 
> This patch stubs out the Hsm functions and adjusts the autoconf
> to not fail in the case of missing dmapi headers/libs.
> 
> If somebody does trie to do a dump with the -a option a ERROR message
> is issued, the dump does continue? this might not be the desired behavior.
> 
> 
> ------------------------------------------------------------------------
> 
> Index: xfs-cmds/xfsdump/aclocal.m4
> ===================================================================
> --- xfs-cmds.orig/xfsdump/aclocal.m4	2006-08-02 14:51:34.000000000 -0500
> +++ xfs-cmds/xfsdump/aclocal.m4	2006-08-02 14:58:11.250605250 -0500
> @@ -161,27 +161,31 @@ AC_DEFUN([AC_PACKAGE_NEED_XFS_DMAPI_H],
>    [ AC_CHECK_HEADERS([xfs/dmapi.h])
>      if test "$ac_cv_header_xfs_dmapi_h" != yes; then
>          echo
> -        echo 'FATAL ERROR: could not find a valid DMAPI library header.'
> -        echo 'Install the data migration API (dmapi) development package.'
> +        echo 'WARNING: could not find a valid DMAPI library header.'
> +        echo 'xfsdump / xfsrestore will not support dmapi file systems.'
>          echo 'Alternatively, run "make install-dev" from the dmapi source.'
> -        exit 1
>      fi
>    ])
>  
>  AC_DEFUN([AC_PACKAGE_NEED_MAKEHANDLE_LIBDM],
> -  [ AC_CHECK_LIB(dm, dm_make_handle,, [
> +  [ AC_CHECK_LIB(dm, dm_make_handle,
> +	[have_dmapi=true
> + 	libdm="-ldm"
> +	    test -f `pwd`/../dmapi/libdm/libdm.la && \
> +	        libdm="`pwd`/../dmapi/libdm/libdm.la"
> +	    test -f ${libexecdir}${libdirsuffix}/libdm.la && \
> +		libdm="${libexecdir}${libdirsuffix}/libdm.la"
> +	],
> +	[
>          echo
> -        echo 'FATAL ERROR: could not find a valid DMAPI base library.'
> -        echo 'Install the data migration API (dmapi) library package.'
> +        echo 'WARNING: could not find a valid DMAPI base library.'
> +        echo 'xfsdump / xfsrestore will not support dmapi file systems.'
>          echo 'Alternatively, run "make install" from the dmapi source.'
> -        exit 1
> +	have_dmapi=false
> +	libdm = ""
>      ])
> -    libdm="-ldm"
> -    test -f `pwd`/../dmapi/libdm/libdm.la && \
> -        libdm="`pwd`/../dmapi/libdm/libdm.la"
> -    test -f ${libexecdir}${libdirsuffix}/libdm.la && \
> -	libdm="${libexecdir}${libdirsuffix}/libdm.la"
>      AC_SUBST(libdm)
> +    AC_SUBST(have_dmapi)
>    ])
>  
>  # 
> Index: xfs-cmds/xfsdump/common/hsmapi_noop.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs-cmds/xfsdump/common/hsmapi_noop.c	2006-08-02 15:38:39.046333000 -0500
> @@ -0,0 +1,147 @@
> +/*
> + * Copyright (c) 2000-2004 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include <xfs/xfs.h>
> +#include <attr/attributes.h>
> +#include <xfs/handle.h>
> +
> +#include "hsmapi.h"
> +#include "mlog.h"
> +#include "exit.h"
> +
> +typedef	struct	{
> +} dmf_fs_ctxt_t;
> +
> +extern hsm_fs_ctxt_t *
> +HsmInitFsysContext(
> +const	char		*mountpoint,
> +	int		dumpversion)
> +{
> +	mlog( MLOG_NORMAL | MLOG_ERROR, _(
> +		      "-%c Dumping of DMF dualstate file not supported in this version\n"));
> +	return NULL;
> +}
> +
> +extern void
> +HsmDeleteFsysContext(
> +	hsm_fs_ctxt_t	*contextp)
> +{
> +}
> +
> +extern int
> +HsmEstimateFileSpace(
> +	hsm_fs_ctxt_t	*contextp,
> +const	xfs_bstat_t	*statp,
> +	off64_t		*bytes)
> +{
> +	return 0;
> +}
> +
> +extern int
> +HsmEstimateFileOffset(
> +	hsm_fs_ctxt_t	*contextp,
> +const	xfs_bstat_t	*statp,
> +	off64_t		bytecount,
> +	off64_t		*byteoffset)
> +{
> +	return 0;
> +}
> +
> +extern hsm_f_ctxt_t *
> +HsmAllocateFileContext(
> +	hsm_fs_ctxt_t	*contextp)
> +{
> +	return NULL;
> +}
> +
> +extern void
> +HsmDeleteFileContext(
> +	hsm_f_ctxt_t	*contextp)
> +{
> +}
> +
> +extern int
> +HsmInitFileContext(
> +	hsm_f_ctxt_t	*contextp,
> +const	xfs_bstat_t	*statp)
> +{
> +	return 0;
> +}
> +
> +extern int
> +HsmModifyInode(
> +	hsm_f_ctxt_t	*contextp,
> +	xfs_bstat_t	*statp)
> +{
> +	return 0;
> +}
> +
> +extern int
> +HsmModifyExtentMap(
> +	hsm_f_ctxt_t	*contextp,
> +	struct getbmapx	*bmap)
> +{
> +	return 0;
> +}
> +
> +extern int
> +HsmFilterExistingAttribute(
> +	hsm_f_ctxt_t	*hsm_f_ctxtp,
> +const	char		*namep,		/* attribute name */
> +	u_int32_t	valuesz,	/* value size */
> +	int		flag,
> +	int		*skip_entry)
> +{
> +	return 0;
> +}
> +
> +extern int
> +HsmAddNewAttribute(
> +	hsm_f_ctxt_t	*hsm_f_ctxtp,
> +	int		cursor,
> +	int		flag,
> +	char		**namepp,	/* pointer to new attribute name */
> +	char		**valuepp,	/* pointer to its value */
> +	u_int32_t	*valueszp)	/* pointer to the value size */
> +{
> +	return 0;
> +}
> +
> +extern void
> +HsmBeginRestoreFile(
> +	bstat_t		*bstatp,
> +	int		fd,
> +	int		*hsm_flagp)
> +{
> +}
> +
> +extern void
> +HsmRestoreAttribute(
> +	int		flag,		/* ext attr flags */
> +	char		*namep,		/* pointer to new attribute name */
> +	int		*hsm_flagp)
> +{
> +}
> +
> +extern void
> +HsmEndRestoreFile(
> +	char		*path,
> +	int		fd,
> +	int		*hsm_flagp)
> +{
> +}
> Index: xfs-cmds/xfsdump/dump/Makefile
> ===================================================================
> --- xfs-cmds.orig/xfsdump/dump/Makefile	2006-08-02 14:51:34.000000000 -0500
> +++ xfs-cmds/xfsdump/dump/Makefile	2006-08-02 14:52:15.076345750 -0500
> @@ -57,7 +57,6 @@ COMMON = \
>  	fs.c \
>  	getdents.c \
>  	global.c \
> -	hsmapi.c \
>  	lock.c \
>  	main.c \
>  	mlog.c \
> @@ -69,6 +68,12 @@ COMMON = \
>  	util.c \
>  	sproc.c
>  
> +ifeq ($(HAVE_DMAPI), true)
> +  COMMON += hsmapi.c
> +else
> +  COMMON += hsmapi_noop.c
> +endif
> +
>  LOCALS = \
>  	content.c \
>  	inomap.c \
> Index: xfs-cmds/xfsdump/include/builddefs.in
> ===================================================================
> --- xfs-cmds.orig/xfsdump/include/builddefs.in	2006-08-02 14:51:34.000000000 -0500
> +++ xfs-cmds/xfsdump/include/builddefs.in	2006-08-02 14:52:15.080346000 -0500
> @@ -66,6 +66,8 @@ ENABLE_GETTEXT	= @enable_gettext@
>  
>  HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
>  
> +HAVE_DMAPI = @have_dmapi@
> +
>  LCFLAGS += -DXFS_BIG_FILES=1 -DXFS_BIG_FILESYSTEMS=1
>  
>  ifeq ($(PKG_PLATFORM),linux)
> Index: xfs-cmds/xfsdump/restore/Makefile
> ===================================================================
> --- xfs-cmds.orig/xfsdump/restore/Makefile	2006-08-02 14:51:34.000000000 -0500
> +++ xfs-cmds/xfsdump/restore/Makefile	2006-08-02 14:52:15.080346000 -0500
> @@ -55,7 +55,6 @@ COMMON = \
>  	fs.c \
>          getdents.c \
>  	global.c \
> -	hsmapi.c \
>  	lock.c \
>  	main.c \
>  	mlog.c \
> @@ -67,6 +66,12 @@ COMMON = \
>  	stream.c \
>  	util.c
>  
> +ifeq ($(HAVE_DMAPI), true)
> +  COMMON += hsmapi.c
> +else
> +  COMMON += hsmapi_noop.c
> +endif
> +
>  LOCALS = \
>  	bag.c \
>  	content.c \
