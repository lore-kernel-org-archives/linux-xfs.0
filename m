Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18731 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdK3XNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 18:13:39 -0500
Date: Thu, 30 Nov 2017 15:13:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V3] xfs_io: add buf_lru_ref tag to inject table
Message-ID: <20171130231332.GO21412@magnolia>
References: <79e391ff-fbb5-baf9-bb36-776d956ccecf@redhat.com>
 <2ad83585-651a-ee47-d400-5dc91089a69e@sandeen.net>
 <4fee68a1-3e32-cc6e-e84b-fe38ce492744@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fee68a1-3e32-cc6e-e84b-fe38ce492744@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 30, 2017 at 05:04:36PM -0600, Eric Sandeen wrote:
> And catch it at build time if we get out of sync again.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

/me wondered if we should just turn it into this, given that the error
tags are sequentially increasing:

static char *eflags[] = {
	[XFS_ERRTAG_NOERROR] = "noerror",
	[XFS_ERRTAG_IFLUSH_1] = "iflush1",
};

BUILD_BUG_ON(sizeof(eflags) == sizeof(char *) * XFS_ERRTAG_MAX);

and so on, but that can be another patch.

--D

> ---
> 
> V2: add BUILD_BUG_ON
> V3: dynamically size the array
> 
> (I tested w/ dynamically sized but lost it in the V2 patch)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index 9f0f11b..a40ca0c 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -64,6 +64,10 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #define __packed __attribute__((packed))
>  #endif
>  
> +#ifndef BUILD_BUG_ON
> +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> +#endif
> +
>  #include <xfs/xfs_types.h>
>  #include <xfs/xfs_fs.h>
>  
> diff --git a/io/inject.c b/io/inject.c
> index 9d0cf62..fc3cf25 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -30,7 +30,7 @@ error_tag(char *name)
>  	static struct {
>  		int	tag;
>  		char	*name;
> -	} *e, eflags[XFS_ERRTAG_MAX + 1] = {
> +	} *e, eflags[] = {
>  		{ XFS_ERRTAG_NOERROR,			"noerror" },
>  		{ XFS_ERRTAG_IFLUSH_1,			"iflush1" },
>  		{ XFS_ERRTAG_IFLUSH_2,			"iflush2" },
> @@ -62,10 +62,14 @@ error_tag(char *name)
>  		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
>  		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
>  		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
> +		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
>  		{ XFS_ERRTAG_MAX,			NULL }
>  	};
>  	int	count;
>  
> +	/* If this fails make sure every tag is defined in the array above */
> +	BUILD_BUG_ON(sizeof(eflags) != (XFS_ERRTAG_MAX + 1) * sizeof(*e));
> +
>  	/* Search for a name */
>  	if (name) {
>  		for (e = eflags; e->name; e++)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
