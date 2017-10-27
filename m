Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37118 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdJ0AJs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 20:09:48 -0400
Subject: Re: [PATCH 03/10] xfs_io: add new error injection knobs to inject
 command
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905611328.28563.9043969796286227381.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f4cab9d0-74f4-948b-1d44-9202960205d8@sandeen.net>
Date: Thu, 26 Oct 2017 19:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <150905611328.28563.9043969796286227381.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 10/26/17 5:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Bring xfs_io's inject command up to date with the newest knobs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, but should we get this into shared libxfs files eventually?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/inject.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/io/inject.c b/io/inject.c
> index 25c7021..964ebfe 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -86,7 +86,13 @@ error_tag(char *name)
>  		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
>  #define XFS_ERRTAG_AG_RESV_CRITICAL			27
>  		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
> -#define XFS_ERRTAG_MAX                                  28
> +#define XFS_ERRTAG_DROP_WRITES				28
> +		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
> +#define XFS_ERRTAG_LOG_BAD_CRC				29
> +		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
> +#define XFS_ERRTAG_LOG_ITEM_PIN				30
> +		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
> +#define XFS_ERRTAG_MAX                                  31
>  		{ XFS_ERRTAG_MAX,			NULL }
>  	};
>  	int	count;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
