Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfHMO2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 10:28:36 -0400
Date: Tue, 13 Aug 2019 07:28:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfsprogs: Fix --disable-static option build
Message-ID: <20190813142801.GP7138@magnolia>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813051421.21137-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 03:14:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Internal xfsprogs libraries are linked statically to binaries as
> they are not shipped libraries. Using --disable-static prevents the
> internal static libraries from being built and this breaks dead code
> elimination and results in linker failures from link dependencies
> introduced by dead code.
> 
> We can't remove the --disable-static option that causes this as it
> is part of the libtool/autoconf generated infrastructure. We can,
> however, reliably detect whether static library building has been
> disabled after the libtool infrastructure has been configured.
> Therefore, add a check to determine the static build status and
> abort the configure script with an error if we have been configured
> not to build static libraries.

Uh... is this missing from the patch?  I don't see anything that aborts
configure.  Though I sense this might be your v2 solution that works
around --disable-static via the ld command line and leaves configure
alone...? :)

--D

> This build command now succeeds:
> 
> $ make realclean; make configure; ./configure --disable-static ; make
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libfrog/Makefile | 2 ++
>  libxcmd/Makefile | 2 ++
>  libxfs/Makefile  | 2 ++
>  libxlog/Makefile | 2 ++
>  4 files changed, 8 insertions(+)
> 
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index f5a0539b3f03..4d79983eb910 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libfrog.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  CFILES = \
>  avl64.c \
> diff --git a/libxcmd/Makefile b/libxcmd/Makefile
> index 914bec024c46..f9bc1c5c483a 100644
> --- a/libxcmd/Makefile
> +++ b/libxcmd/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libxcmd.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  CFILES = command.c input.c help.c quit.c
>  
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 8c681e0b9083..d1688dc3853a 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libxfs.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  # headers to install in include/xfs
>  PKGHFILES = xfs_fs.h \
> diff --git a/libxlog/Makefile b/libxlog/Makefile
> index bdea6abacea4..b0f5ef154133 100644
> --- a/libxlog/Makefile
> +++ b/libxlog/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libxlog.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  CFILES = xfs_log_recover.c util.c
>  
> -- 
> 2.23.0.rc1
> 
