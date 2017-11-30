Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17154 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdK3WYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 17:24:07 -0500
Date: Thu, 30 Nov 2017 14:23:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: add buf_lru_ref tag to inject table
Message-ID: <20171130222357.GN21412@magnolia>
References: <79e391ff-fbb5-baf9-bb36-776d956ccecf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79e391ff-fbb5-baf9-bb36-776d956ccecf@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 30, 2017 at 04:12:32PM -0600, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

/me wonders if we could make so that the compiler complains about
missing table entries here, but that's orthogonal to this patch so:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> it might be nice to also allow specification by number, but
> for now just fix this up to match the currently-defined tags.
> 
> diff --git a/io/inject.c b/io/inject.c
> index 9d0cf62..2f15854 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -62,6 +62,7 @@ error_tag(char *name)
>  		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
>  		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
>  		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
> +		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
>  		{ XFS_ERRTAG_MAX,			NULL }
>  	};
>  	int	count;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
