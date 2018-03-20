Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32912 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbeCTVea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 17:34:30 -0400
Date: Tue, 20 Mar 2018 14:34:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_scrub: fix cross compile with libunistring
Message-ID: <20180320213421.GJ1757@magnolia>
References: <45d9ba0f01cceb75f72d157a9e4d9aaeb753a9c4.1521548516.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45d9ba0f01cceb75f72d157a9e4d9aaeb753a9c4.1521548516.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 20, 2018 at 02:21:56PM +0200, Baruch Siach wrote:
> Commit 4bbed4ecc2a (xfs_scrub: warn about normalized Unicode name collisions)
> added -lunistring to the list of the xfs_scrub dependencies. When cross
> compiling make fails to find the library on the target sysroot:
> 
> make[3]: *** No rule to make target `-lunistring', needed by `xfs_scrub'.  Stop.
> 
> Remove -lunistring from make dependencies of xfs_scrub to fix that.
> 
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  scrub/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 949f6fd8ba94..979603f524ff 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -69,7 +69,7 @@ vfs.c \
>  xfs_scrub.c
>  
>  LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING) $(LIBRT)
> -LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBUNISTRING) $(LIBRT)
> +LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBRT)

I think we can drop the $LIBRT here too... but it's sort of moot since I
was about to send a big series of xfs_scrub rewrites, one of which fixed
this problem indirectly (by ripping out libunistring and replacing it
with libicu).

Thanks for catching this and the musl bugs, though. :)

--D

>  LLDFLAGS = -static-libtool-libs
>  
>  ifeq ($(HAVE_MALLINFO),yes)
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
