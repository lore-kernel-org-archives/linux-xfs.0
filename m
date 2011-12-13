Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD05mwt129137 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:05:48 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B209D156F336
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:05:46 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BOwf1DH9vsOSpVKy for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 16:05:46 -0800 (PST)
Date: Tue, 13 Dec 2011 11:05:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/12] xfsprogs: allow linking against libtcmalloc
Message-ID: <20111213000543.GX14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.685796560@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174741.685796560@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 02, 2011 at 12:46:23PM -0500, Christoph Hellwig wrote:
> Allow linking against the libtcmalloc library from Google's performance
> tools, which at least for repair reduces the memory usage dramatically.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/configure.in
> ===================================================================
> --- xfsprogs-dev.orig/configure.in	2011-11-14 13:54:28.000000000 +0000
> +++ xfsprogs-dev/configure.in	2011-11-20 19:21:26.000000000 +0000
> @@ -31,6 +31,26 @@ AC_ARG_ENABLE(editline,
>  AC_SUBST(libeditline)
>  AC_SUBST(enable_editline)
>  
> +AC_ARG_ENABLE(tcmalloc,
> +[ --enable-tcmalloc=[yes/no] Enable tcmalloc [default=no]],,
> +	enable_tcmalloc=check)
> +
> +if test x$enable_tcmalloc != xno; then

Firstly, I don't think this branch of detection code belongs here in
configure.in - m4/package_globals.m4 is where malloc libraries and
compiler flags are set. Indeed, I doubt electric fence is compatible
with tcmalloc, so those options need to be made exclusive....

> +    saved_CPPFLAGS="$CPPFLAGS"
> +    CPPFLAGS="$CPPFLAGS -fno-builtin-malloc"

This needs a comment explaining why this is necessary. Something
like:

"gcc assumes that malloc is implemented by glibc and makes
assumptions and optimisations that break glibc-external
optimisations and malloc-hook debugging. Hence we have to tell it
not to make those optimisations when using tcmalloc."

I also don't see how this "-fno-builtin-malloc" is being passed to
the build environment. There needs to be another variable exported
to add this to the CFLAGS of the build....

> +    AC_CHECK_LIB([tcmalloc_minimal], [malloc], [libtcmalloc="-ltcmalloc_minimal"],
> +        [AC_CHECK_LIB([tcmalloc], [malloc], [libtcmalloc="-ltcmalloc"], [
> +         if test x$enable_tcmalloc = xyes; then
> +            AC_MSG_ERROR([libtcmalloc_minimal or libtcmalloc library not found], 1)
> +         fi]
> +        )]
> +    )

I can't say this is my favourite way of encoding all the options.
I'd prefer something more verbose and explicit that keeps all the
malloc library options in one set of logic. That is, I'm pretty sure
electric fence won't work with tcmalloc, so those options are
multually exclusive. So perhaps putting this in
m4/package_globals.m4:

	tcmalloc=false
	saved_CPPFLAGS="$CPPFLAGS"
	if test $enable_tcmalloc != no ; then
		CPPFLAGS="$CPPFLAGS -fno-builtin-malloc"
		AC_CHECK_LIB(tcmalloc_minimal, malloc, tcmalloc=minimum, tcmalloc=false)
		AC_CHECK_LIB(tcmalloc, malloc, tcmalloc=full,)
	fi

	if test $tcmalloc = minimum ; then
		malloc_lib="-ltcmalloc_minimum"
		malloc_cflags="-fno-builtin-malloc"
	fi
	if test $tcmalloc = full ; then
		malloc_lib="-ltcmalloc"
		malloc_cflags="-fno-builtin-malloc"
	fi
	if test $tcmalloc = false ; then
		CPPFLAGS="$saved_CPPFLAGS"
		malloc_cflags=""

		# electric fence malloc debugging might be enabled
		MALLOCLIB=${MALLOCLIB:-''}	# /usr/lib/libefence.a
		malloc_lib="$MALLOCLIB"
	fi

	AC_SUBST(malloc_lib)
	AC_SUBST(malloc_cflags)

And then adding this to include/builddefs.in:

-CFLAGS = @CFLAGS@
+CFLAGS = @CFLAGS@ @malloc_cflags@

would appear to be a better way to do this....

> +    if test x$libtcmalloc = x; then
> +        CPPFLAGS="$saved_CPPFLAGS"
> +    fi
> +fi
> +AC_SUBST(libtcmalloc)
> +

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
