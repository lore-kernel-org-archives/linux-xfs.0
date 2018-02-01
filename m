Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbeBAVtK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Feb 2018 16:49:10 -0500
Date: Thu, 1 Feb 2018 15:49:03 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 31/29 v2] xfs_scrub: handle scrub-only kernels more
 helpfully
Message-ID: <20180201214903.GA9528@redhat.com>
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
 <20180131173016.GD4849@magnolia>
 <313224b9-67b0-cd94-fca5-a862761b2b02@sandeen.net>
 <8b77b774-5f60-2236-ab23-b591417e79a9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b77b774-5f60-2236-ab23-b591417e79a9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 03:46:20PM -0600, Eric Sandeen wrote:
> 
> 
> If xfs_scrub is run today against a 4.15 kernel, it fails with
> 
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Error: /home: Kernel metadata optimization facility is required.
> Info: /home: Scrub aborted after phase 1.
> /home: 2 errors found.
> 
> Be a bit kinder to the user and suggest a path forward.  By the
> time we fail for missing preen or repair functionality, we do
> know that scrub is available, so suggest it.
> 
> Further, rather than stating what is required, state what was not
> found ... we're failing, so state what was missing, vs. what is
> required - seems a bit more definitive.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

looks good.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> V2: change verbiage to make it more better and not not not confusing.
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 547767b..9128429 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -175,7 +175,7 @@ _("Does not appear to be an XFS filesystem!"));
>  	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
>  	    !xfs_can_scrub_parent(ctx)) {
>  		str_error(ctx, ctx->mntpoint,
> -_("Kernel metadata scrubbing facility is required."));
> +_("Kernel metadata scrubbing facility is not available."));
>  		return false;
>  	}
>  
> @@ -183,10 +183,10 @@ _("Kernel metadata scrubbing facility is required."));
>  	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
>  		if (ctx->mode == SCRUB_MODE_PREEN)
>  			str_error(ctx, ctx->mntpoint,
> -_("Kernel metadata optimization facility is required."));
> +_("Kernel metadata optimization facility is not available.  Use -n to scrub."));
>  		else
>  			str_error(ctx, ctx->mntpoint,
> -_("Kernel metadata repair facility is required."));
> +_("Kernel metadata repair facility is not available.  Use -n to scrub."));
>  		return false;
>  	}
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
