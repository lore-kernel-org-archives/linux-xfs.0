Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:49483 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbeJ0KYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 06:24:38 -0400
Date: Sat, 27 Oct 2018 12:45:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] misc: only build with lto if explicitly enabled
Message-ID: <20181027014516.GH19305@dastard>
References: <20181026232538.GK28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026232538.GK28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 04:25:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the LTO default to off from probe because it wastes build time on
> developer machines.  Anyone who really wants it for release builds or
> whatever can still turn it on.

Build time is not the problem. Making the resultant binary
completely unusable with gdb and hence undebuggable is the real
problem with LTO.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  configure.ac |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 44a4b3a8..f8f29c07 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -109,8 +109,8 @@ AC_ARG_ENABLE(threadsan,
>  AC_SUBST(enable_threadsan)
>  
>  AC_ARG_ENABLE(lto,
> -[ --enable-lto=[yes/no]      Enable link time optimization (LTO) [default=probe]],,
> -	enable_lto=probe)
> +[ --enable-lto=[yes/no]      Enable link time optimization (LTO) [default=no]],,
> +	enable_lto=no)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
