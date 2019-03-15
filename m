Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37620 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729576AbfCORgf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Mar 2019 13:36:35 -0400
Subject: Re: [PATCH 13/36] xfs_scrub: use datadev parallelization estimates
 for thread count
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259750953.31886.7244219282258067422.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f5165fad-9128-c469-4142-8c8012c8fa70@sandeen.net>
Date: Fri, 15 Mar 2019 12:36:34 -0500
MIME-Version: 1.0
In-Reply-To: <155259750953.31886.7244219282258067422.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During phases 2-5, xfs_scrub should estimate the level of
> parallelization possible on the data device to determine the number of
> threads spawned to scrub filesystem metadata, not just blindly using the
> number of CPUs.  This avoids flooding non-rotational storage with random
> reads, which totally destroys performance and makes scrub runtimes
> higher.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

seems like when I first looked at this I had a concern but now I don't
remember, and today it seems fine? :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/phase1.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 2113014b..6b472147 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -109,13 +109,6 @@ _("Must be root to run scrub."));
>  		return false;
>  	}
>  
> -	ctx->nr_io_threads = nproc;
> -	if (verbose) {
> -		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
> -				ctx->mntpoint, scrub_nproc(ctx));
> -		fflush(stdout);
> -	}
> -
>  	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
>  		str_info(ctx, ctx->mntpoint,
>  _("Does not appear to be an XFS filesystem!"));
> @@ -193,6 +186,13 @@ _("Unable to find realtime device path."));
>  		return false;
>  	}
>  
> +	ctx->nr_io_threads = disk_heads(ctx->datadev);
> +	if (verbose) {
> +		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
> +				ctx->mntpoint, scrub_nproc(ctx));
> +		fflush(stdout);
> +	}
> +
>  	if (ctx->fsinfo.fs_log) {
>  		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
>  		if (error) {
> 
