Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752343AbeBUMrz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Feb 2018 07:47:55 -0500
Date: Wed, 21 Feb 2018 06:47:51 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_scrub: don't ask user to run xfs_repair for only
 warnings
Message-ID: <20180221124751.GA2637@redhat.com>
References: <20180221033654.GI27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180221033654.GI27629@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 20, 2018 at 07:36:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't advise the user to run xfs_repair on a filesystem that triggers
> warnings but no errors; there's no corruption for it to fix.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  scrub/xfs_scrub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index ab26e63..53a105a 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -514,7 +514,7 @@ report_outcome(
>  		fprintf(stderr, _("%s: errors found: %llu; warnings found: %llu\n"),
>  				ctx->mntpoint, total_errors,
>  				ctx->warnings_found);
> -	if (ctx->need_repair)
> +	if (ctx->need_repair && total_errors > 0)
>  		fprintf(stderr, _("%s: Unmount and run xfs_repair.\n"),
>  				ctx->mntpoint);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
