Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17249 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753211AbcJZBGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 21:06:24 -0400
Date: Wed, 26 Oct 2016 12:06:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/39] xfs_io: get and set the CoW extent size hint
Message-ID: <20161026010620.GG23194@dastard>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743672316.11035.10557430267483073641.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743672316.11035.10557430267483073641.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:05:23PM -0700, Darrick J. Wong wrote:
> Enable administrators to get or set the CoW extent size hint.
> Report the hint when we run stat.  This also requires some
> autoconf magic to detect whether or not fsx_cowextsize exists.
....
> +++ b/include/builddefs.in
> @@ -109,6 +109,7 @@ HAVE_MNTENT = @have_mntent@
>  HAVE_FLS = @have_fls@
>  HAVE_FSETXATTR = @have_fsetxattr@
>  HAVE_MREMAP = @have_mremap@
> +HAVE_FSXATTR_COWEXTSIZE = @have_fsxattr_cowextsize@
>  ENABLE_INTERNAL_FSXATTR = @enable_internal_fsxattr@

We really need a comment here that states that
ENABLE_INTERNAL_FSXATTR=yes implies HAVE_FSXATTR_COWEXTSIZE=yes
because of the autoconf magic we do....

> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 7a847e9..45954c2 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -265,3 +265,29 @@ AC_DEFUN([AC_HAVE_MREMAP],
>         )
>      AC_SUBST(have_mremap)
>    ])
> +
> +#
> +# Check if we have a struct fsxattr with a fsx_cowextsize field.
> +# If linux/fs.h has a struct with that field, then we're ok.
> +# If we can't find fsxattr in linux/fs.h at all, the internal
> +# definitions provide it, and we're ok.
> +#
> +# The only way we won't have this is if the kernel headers don't
> +# have the field.
> +#
> +AC_DEFUN([AC_HAVE_FSXATTR_COWEXTSIZE],
> +  [ AM_CONDITIONAL([INTERNAL_FSXATTR], [test "x$enable_internal_fsxattr" = xyes])
> +    AM_COND_IF([INTERNAL_FSXATTR],
> +    [have_fsxattr_cowextsize=yes],

Ok, so here we set the value. I think this needs a better/more
generic comment because we're going to have to repeat this
pattern in future. i.e. explain the basic construct, then as a
separate statement say "apply it to detection of the fsx_cowextsize
field".

> +    [ AC_CHECK_TYPE(struct fsxattr,
> +	  [AC_CHECK_MEMBER(struct fsxattr.fsx_cowextsize,
> +		  have_fsxattr_cowextsize=yes,
> +		  have_fsxattr_cowextsize=no,
> +		  [#include <linux/fs.h>]
> +          )],
> +	  have_fsxattr_cowextsize=yes,
> +	  [#include <linux/fs.h>]
> +      )
> +    ])
> +    AC_SUBST(have_fsxattr_cowextsize)
> +  ])

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
