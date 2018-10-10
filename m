Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbeJKEqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 00:46:02 -0400
Date: Wed, 10 Oct 2018 14:21:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: remove retpoline support
Message-ID: <20181010212148.GV28243@magnolia>
References: <06935570-ac17-776d-0a9c-cd9158a01922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06935570-ac17-776d-0a9c-cd9158a01922@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>

On Wed, Oct 10, 2018 at 02:58:40PM -0500, Eric Sandeen wrote:
> When it came up that xfsprogs was using retpolines by default,
> the gcc folks inside Red Hat expressed ... alarm.  I'm not sure
> of all the details, but I think the concern was that userspace
> support for this is not really quite baked.
> 
> Unless/until there is a demonstrated side-channel which would
> warrant retpolines here, let's just remove it for now.
> 
> Cc: Florian Weimer <fweimer@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Fine with me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Getting this on the list so we can have a discussion with people who
> understand the issues better than I do ...
> 
> diff --git a/configure.ac b/configure.ac
> index 5fdf78e..41f1209 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -227,7 +227,6 @@ if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
>  	AC_MSG_ERROR([LTO not supported by compiler.])
>  fi
>  
> -AC_PACKAGE_CHECK_RETPOLINE
>  AC_CHECK_SIZEOF([long])
>  AC_CHECK_SIZEOF([char *])
>  AC_TYPE_UMODE_T
> diff --git a/include/builddefs.in b/include/builddefs.in
> index f7d39a4..fe529c6 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -166,13 +166,6 @@ LIBICU_CFLAGS = @libicu_CFLAGS@
>  SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
>  SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
>  
> -# Enable retpolines if available
> -HAVE_RETPOLINE = @have_retpoline@
> -ifeq ($(HAVE_RETPOLINE),yes)
> -OPTIMIZER += @retpoline_cflags@
> -LOADERFLAGS += @retpoline_ldflags@
> -endif
> -
>  # Use special ar/ranlib wrappers if we have lto
>  HAVE_LTO = @have_lto@
>  ifeq ($(HAVE_LTO),yes)
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 0a6b514..52ddac2 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -446,25 +446,3 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
>      AC_SUBST(lto_cflags)
>      AC_SUBST(lto_ldflags)
>    ])
> -
> -AC_DEFUN([AC_PACKAGE_CHECK_RETPOLINE],
> -  [ AC_MSG_CHECKING([if C compiler supports retpoline])
> -    OLD_CFLAGS="$CFLAGS"
> -    OLD_LDFLAGS="$LDFLAGS"
> -    RETPOLINE_FLAGS="-mindirect-branch=thunk"
> -    CFLAGS="$CFLAGS $RETPOLINE_FLAGS"
> -    LDFLAGS="$LDFLAGS $RETPOLINE_FLAGS"
> -    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
> -        [AC_MSG_RESULT([yes])]
> -        [retpoline_cflags=$RETPOLINE_FLAGS]
> -        [retpoline_ldflags=$RETPOLINE_FLAGS],
> -        [AC_MSG_RESULT([no])])
> -    if test -n "$retpoline_cflags"; then
> -        have_retpoline=yes
> -    fi
> -    CFLAGS="${OLD_CFLAGS}"
> -    LDFLAGS="${OLD_LDFLAGS}"
> -    AC_SUBST(have_retpoline)
> -    AC_SUBST(retpoline_cflags)
> -    AC_SUBST(retpoline_ldflags)
> -  ])
> 
