Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:28322 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753042AbcK2Vo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 16:44:58 -0500
Date: Wed, 30 Nov 2016 08:44:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix building xfsprogs on 32-bit platforms
Message-ID: <20161129214456.GE31101@dastard>
References: <1480372955-41315-1-git-send-email-ebiggers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480372955-41315-1-git-send-email-ebiggers@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers@google.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2016 at 02:42:35PM -0800, Eric Biggers wrote:
> Since commit 7fda99a0c297 ("xfs.h: require transparent LFS for all
> users"), building xfsprogs fails on a 32-bit platform because it does
> not define _FILE_OFFSET_BITS=64 itself.  Fix it by adding this to CFLAGS
> in builddefs.in.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/builddefs.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index aeb2905..5219071 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -25,7 +25,7 @@ OPTIMIZER = @opt_build@
>  MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
> -CFLAGS = @CFLAGS@
> +CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64

So, umm, why aren't these lines in configure.ac setting this already
on your system?

AC_SYS_LARGEFILE
AC_NEED_LFS

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
