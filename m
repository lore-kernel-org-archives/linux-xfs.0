Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46670 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750728AbeCHUU6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 15:20:58 -0500
Subject: Re: [PATCH v2 04/16] xfs_scrub: don't ask user to run xfs_repair for
 only warnings
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993160036.22223.2742740914776483127.stgit@magnolia>
 <20180308193628.GC18989@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0612d2cd-ddf4-72d5-7c82-013f1d60b7d7@sandeen.net>
Date: Thu, 8 Mar 2018 14:20:57 -0600
MIME-Version: 1.0
In-Reply-To: <20180308193628.GC18989@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On 3/8/18 1:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't advise the user to run xfs_repair on a filesystem that triggers
> warnings but no errors; there's no corruption for it to fix.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix confusing variable name, add more comments

thanks, that helps my poor brain.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/phase1.c    |    2 +-
>  scrub/xfs_scrub.c |    7 ++++++-
>  scrub/xfs_scrub.h |    2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index b856a7f..002c642 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -237,6 +237,6 @@ _("Unable to find realtime device path."));
>  	 * purely setup errors).
>  	 */
>  	log_info(ctx, _("Invoking online scrub."), ctx);
> -	ctx->need_repair = true;
> +	ctx->scrub_setup_succeeded = true;
>  	return true;
>  }
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 7ab0c3e..7ee02b6 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -522,7 +522,12 @@ report_outcome(
>  				total_errors, ctx->warnings_found);
>  	}
>  
> -	if (ctx->need_repair)
> +	/*
> +	 * Don't advise the user to run repair unless we were successful in
> +	 * setting up the scrub and we actually saw corruptions.  Warnings
> +	 * are not corruptions.
> +	 */
> +	if (ctx->scrub_setup_succeeded && total_errors > 0)
>  		fprintf(stderr, _("%s: Unmount and run xfs_repair.\n"),
>  				ctx->mntpoint);
>  }
> diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
> index b455747..aa130a7 100644
> --- a/scrub/xfs_scrub.h
> +++ b/scrub/xfs_scrub.h
> @@ -96,7 +96,7 @@ struct scrub_ctx {
>  	unsigned long long	naming_warnings;
>  	unsigned long long	repairs;
>  	unsigned long long	preens;
> -	bool			need_repair;
> +	bool			scrub_setup_succeeded;
>  	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
>  };
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
