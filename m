Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44828 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbdF3TeO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Jun 2017 15:34:14 -0400
Subject: Re: [PATCH] libxfs: fix fsmap.h inclusion
References: <20170630170855.GO5874@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <be4e67aa-d23b-e05d-706e-a825062b86b8@sandeen.net>
Date: Fri, 30 Jun 2017 14:34:13 -0500
MIME-Version: 1.0
In-Reply-To: <20170630170855.GO5874@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On 6/30/17 12:08 PM, Darrick J. Wong wrote:
> If we /do/ have HAVE_GETFSMAP defined, we need to include linux/fsmap.h.
> 
> Found-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/linux.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 92f291d..6ce344c 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -222,7 +222,9 @@ struct fsxattr {
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>  #endif
>  
> -#ifndef HAVE_GETFSMAP
> +#ifdef HAVE_GETFSMAP
> +# include <linux/fsmap.h>
> +#else
>  /*
>   *	Structure for FS_IOC_GETFSMAP.
>   *
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
