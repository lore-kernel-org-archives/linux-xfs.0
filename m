Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20077 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdJTLXv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:23:51 -0400
Date: Fri, 20 Oct 2017 07:23:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs_io: add new error injection knobs to inject
 command
Message-ID: <20171020112349.GC13669@bfoster.bfoster>
References: <150837629129.31583.8002405051612025341.stgit@magnolia>
 <150837630628.31583.12537115048470504642.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150837630628.31583.12537115048470504642.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Oct 18, 2017 at 06:25:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Bring xfs_io's inject command up to date with the newest knobs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
