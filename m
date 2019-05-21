Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44158 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfEUTYm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:24:42 -0400
Subject: Re: [PATCH 11/12] mkfs: validate start and end of aligned logs
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839427473.68606.3900005341580158051.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <03cd588a-f4b0-0c79-4862-31ae0e5cd3dd@sandeen.net>
Date: Tue, 21 May 2019 14:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <155839427473.68606.3900005341580158051.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Validate that the start and end of the log stay within a single AG if
> we adjust either end to align to stripe units.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/xfs_mkfs.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5b66074d..8f84536e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3044,15 +3044,28 @@ align_internal_log(
>  	struct xfs_mount	*mp,
>  	int			sunit)
>  {
> +	uint64_t		logend;
> +
>  	/* round up log start if necessary */
>  	if ((cfg->logstart % sunit) != 0)
>  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
>  
> +	/* if our log start rounds into the next AG we're done */

/* If our log start overlaps the next AG's metadata, fail */

> +	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> +			fprintf(stderr,
> +_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
> +  "within an allocation group.\n"),
> +			(long long) cfg->logstart);

Hm, should it suggest what should be modified to try again ...?

> +		usage();
> +	}
> +
>  	/* round up/down the log size now */
>  	align_log_size(cfg, sunit);
>  
>  	/* check the aligned log still fits in an AG. */
> -	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
> +	logend = cfg->logstart + cfg->logblocks - 1;
> +	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
> +	    !xfs_verify_fsbno(mp, logend)) {

this xfs_verify_fsbno is probably redundant but can't hurt?

-Eric

>  		fprintf(stderr,
>  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
>    "Must fit within an allocation group.\n"),
> 
