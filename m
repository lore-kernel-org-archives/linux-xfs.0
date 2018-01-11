Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40110 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932684AbeAKTtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 14:49:23 -0500
Date: Thu, 11 Jan 2018 11:49:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] libxfs: use a memory zone for log items
Message-ID: <20180111194916.GE5602@magnolia>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-6-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515699458-6925-6-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 01:37:35PM -0600, Eric Sandeen wrote:
> In addition to more closely matching the kernel, this will
> help us catch any leaks from these allocations.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  libxfs/trans.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 035cc22..f79fae9 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -65,13 +65,7 @@ libxfs_trans_add_item(
>  	ASSERT(lip->li_mountp == tp->t_mountp);
>  	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
>  
> -	lidp = calloc(sizeof(struct xfs_log_item_desc), 1);
> -	if (!lidp) {
> -		fprintf(stderr, _("%s: lidp calloc failed (%d bytes): %s\n"),
> -			progname, (int)sizeof(struct xfs_log_item_desc),
> -			strerror(errno));
> -		exit(1);
> -	}
> +	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
>  
>  	lidp->lid_item = lip;
>  	lidp->lid_flags = 0;
> @@ -80,6 +74,14 @@ libxfs_trans_add_item(
>  	lip->li_desc = lidp;
>  }
>  
> +static void
> +libxfs_trans_free_item_desc(
> +        struct xfs_log_item_desc *lidp)
> +{
> +	list_del_init(&lidp->lid_trans);
> +	kmem_zone_free(xfs_log_item_desc_zone, lidp);
> +}
> +
>  /*
>   * Unlink and free the given descriptor.
>   */
> @@ -87,8 +89,7 @@ void
>  libxfs_trans_del_item(
>  	struct xfs_log_item	*lip)
>  {
> -	list_del_init(&lip->li_desc->lid_trans);
> -	free(lip->li_desc);
> +	libxfs_trans_free_item_desc(lip->li_desc);
>  	lip->li_desc = NULL;
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
