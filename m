Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34895 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdHRPSc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 11:18:32 -0400
Date: Fri, 18 Aug 2017 08:18:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: add missing translation
Message-ID: <20170818151826.GH4796@magnolia>
References: <20170818103924.24452-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170818103924.24452-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 18, 2017 at 12:39:24PM +0200, Jan Tulak wrote:
> Add a missing underscore where it was omitted probably by a mistake.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 091ca530..ec9ed633 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1281,7 +1281,7 @@ check_opt(
>  
>  	if (sp->index != index) {
>  		fprintf(stderr,
> -	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
> +	_("Developer screwed up option parsing (%d/%d)! Please report!\n"),
>  			sp->index, index);
>  		reqval(opts->name, (char **)opts->subopts, index);
>  	}
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
