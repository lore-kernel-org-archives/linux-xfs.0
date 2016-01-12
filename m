Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5C097F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:30:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6368BAC001
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:30:12 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0A5N4AMNHcLCpuAg for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 13:30:08 -0800 (PST)
Date: Wed, 13 Jan 2016 08:30:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] Add configure check for members of dirent for use in
	io/readdir.c
Message-ID: <20160112213006.GN10456@dastard>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200022.GG568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112200022.GG568@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 09:00:22PM +0100, Felix Janda wrote:
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  configure.ac         |  7 +++++++
>  include/builddefs.in |  4 ++++
>  io/Makefile          | 10 ++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/configure.ac b/configure.ac
> index feee50a..3d6443a 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -135,5 +135,12 @@ AC_CHECK_SIZEOF([char *])
>  AC_TYPE_UMODE_T
>  AC_MANUAL_FORMAT
>  
> +AC_CHECK_MEMBERS([struct dirent.d_reclen],[],[],[[#include <dirent.h>]])
> +AC_SUBST(ac_cv_member_struct_dirent_d_reclen)
> +AC_CHECK_MEMBERS([struct dirent.d_off],[],[],[[#include <dirent.h>]])
> +AC_SUBST(ac_cv_member_struct_dirent_d_off)
> +AC_CHECK_MEMBERS([struct dirent.d_type],[],[],[[#include <dirent.h>]])
> +AC_SUBST(ac_cv_member_struct_dirent_d_type)
> +
>  AC_CONFIG_FILES([include/builddefs])
>  AC_OUTPUT
> diff --git a/include/builddefs.in b/include/builddefs.in
> index b5ce336..67d963c 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -109,6 +109,10 @@ HAVE_FLS = @have_fls@
>  HAVE_FSETXATTR = @have_fsetxattr@
>  HAVE_MREMAP = @have_mremap@
>  
> +HAVE_STRUCT_DIRENT_D_RECLEN = @ac_cv_member_struct_dirent_d_reclen@
> +HAVE_STRUCT_DIRENT_D_OFF = @ac_cv_member_struct_dirent_d_off@
> +HAVE_STRUCT_DIRENT_D_TYPE = @ac_cv_member_struct_dirent_d_type@
> +
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
>  
> diff --git a/io/Makefile b/io/Makefile
> index 0b53f41..9574168 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -94,6 +94,16 @@ ifeq ($(HAVE_MREMAP),yes)
>  LCFLAGS += -DHAVE_MREMAP
>  endif
>  
> +ifeq ($(HAVE_STRUCT_DIRENT_D_RECLEN),yes)
> +LCFLAGS += -D_DIRENT_HAVE_D_RECLEN
> +endif

The C library should be defining these if those fields are
supported, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
