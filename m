Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbeBBUWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 15:22:54 -0500
Date: Fri, 2 Feb 2018 12:22:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs_mdrestore: Add -i option to built-in help
Message-ID: <20180202202249.GB4849@magnolia>
References: <1517598674-52297-1-git-send-email-marco.antonio.780@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517598674-52297-1-git-send-email-marco.antonio.780@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco A Benatto <marco.antonio.780@gmail.com>
Cc: linux-xfs@vger.kernel.org, mbenatto@redhat.com

On Fri, Feb 02, 2018 at 05:11:13PM -0200, Marco A Benatto wrote:
> Currently we are missing -i option from usage().
> This patch adds it to this biult-in help.

"built-in"

> Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  mdrestore/xfs_mdrestore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index c49c13a..0bb4ac8 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -194,7 +194,7 @@ perform_restore(
>  static void
>  usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [-V] [-g] source target\n", progname);
> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
>  	exit(1);
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
