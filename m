Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34396 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbeBAVLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 16:11:49 -0500
Date: Thu, 1 Feb 2018 13:11:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 31/29] xfs_scrub: handle scrub-only kernels more helpfully
Message-ID: <20180201211144.GS4849@magnolia>
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
 <20180131173016.GD4849@magnolia>
 <313224b9-67b0-cd94-fca5-a862761b2b02@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <313224b9-67b0-cd94-fca5-a862761b2b02@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 02:33:30PM -0600, Eric Sandeen wrote:
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
> ---
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 547767b..e78ac7d 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -175,7 +175,7 @@ _("Does not appear to be an XFS filesystem!"));
>  	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
>  	    !xfs_can_scrub_parent(ctx)) {
>  		str_error(ctx, ctx->mntpoint,
> -_("Kernel metadata scrubbing facility is required."));
> +_("Kernel metadata scrubbing facility not available."));

"is not available"?

>  		return false;
>  	}
>  
> @@ -183,10 +183,10 @@ _("Kernel metadata scrubbing facility is required."));
>  	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
>  		if (ctx->mode == SCRUB_MODE_PREEN)
>  			str_error(ctx, ctx->mntpoint,
> -_("Kernel metadata optimization facility is required."));
> +_("Kernel metadata optimization facility not available.  Please use -n."));

I approve of s/is required/is not available/, but I have trouble with
the bare suggestion of running with -n.  We're telling users that the
strategy they asked for (e.g. -y) is not available, so the only
realistic option is to choose a different strategy (i.e. -n).  I don't
want them to get the impression that -n is some magic fixit for -y not
working (but maybe sysadmins are smarter than that?)

"Kernel metadata repair faciility not available.  You can request a
metadata check with -n."

>  		else
>  			str_error(ctx, ctx->mntpoint,
> -_("Kernel metadata repair facility is required."));
> +_("Kernel metadata repair facility not not available. Please use -n."));

not not available?  So it is? :)

--D

>  		return false;
>  	}
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
