Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932686AbeFUUVw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 16:21:52 -0400
Subject: Re: [PATCH] xfs_io: clarify -c from documentation
References: <20180621201404.GI4838@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <44478702-cca5-2356-ab4c-3bfa1e70103e@redhat.com>
Date: Thu, 21 Jun 2018 15:21:51 -0500
MIME-Version: 1.0
In-Reply-To: <20180621201404.GI4838@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 6/21/18 3:14 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The -c parameter displays the cow fork information for a file if the
> kernel was built with CONFIG_XFS_DEBUG=y.  Since xfs_bmap doesn't
> support it and it doesn't work generally, remove it from the manpages.
> However, xfstests relies on the -c command to be documented in the help
> screen so leave it there with a warning about its use.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm not sure xfstests actually cares (xfs/293?) but anyway, this
works for me, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/bmap.c         |    1 +
>  man/man8/xfs_io.8 |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/io/bmap.c b/io/bmap.c
> index 2e4ff7b2..345f276e 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -43,6 +43,7 @@ bmap_help(void)
>  " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
>  " -a -- prints the attribute fork map instead of the data fork.\n"
>  " -c -- prints the copy-on-write fork map instead of the data fork.\n"
> +"       This works only if the kernel was compiled in debug mode.\n"
>  " -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
>  " -e -- print delayed allocation extents.\n"
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 2bd77ee8..eb2b862e 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -315,7 +315,7 @@ See the
>  .B pwrite
>  command.
>  .TP
> -.BI "bmap [ \-acdelpv ] [ \-n " nx " ]"
> +.BI "bmap [ \-adelpv ] [ \-n " nx " ]"
>  Prints the block mapping for the current open file. Refer to the
>  .BR xfs_bmap (8)
>  manual page for complete documentation.
> 

