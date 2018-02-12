Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48820 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753543AbeBLUuW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Feb 2018 15:50:22 -0500
Subject: Re: [PATCH 3/7] xfs_scrub: classify lack of ioctl support as a
 runtime error
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787295310.3743.17476652120290779062.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ad623242-d3e6-8878-0d66-bb064d8a9e1d@sandeen.net>
Date: Mon, 12 Feb 2018 14:50:21 -0600
MIME-Version: 1.0
In-Reply-To: <151787295310.3743.17476652120290779062.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 2/5/18 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the kernel doesn't have the SCRUB_METADATA ioctl that's a runtime
> error, not a fs error.  Account it as such.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yup that's better I think.  I wonder if eventually str_$FOO should
get renamed to make it crystal clear to the caller whether they are
registering a filesystem error or something else, but this fixes this
problem up for now.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/phase1.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index af93d0f..82c8022 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -174,14 +174,14 @@ _("Does not appear to be an XFS filesystem!"));
>  	    !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
>  	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
>  	    !xfs_can_scrub_parent(ctx)) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Kernel metadata scrubbing facility is not available."));
>  		return false;
>  	}
>  
>  	/* Do we need kernel-assisted metadata repair? */
>  	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Kernel metadata repair facility is not available.  Use -n to scrub."));
>  		return false;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
