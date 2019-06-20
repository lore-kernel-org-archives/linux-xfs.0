Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFTTqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 15:46:33 -0400
Subject: Re: [PATCH 09/12] mkfs: validate start and end of aligned logs
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104942708.1172531.3848135690205396934.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6b093274-3ad4-f4b6-4ee5-465ff9ea97cf@sandeen.net>
Date: Thu, 20 Jun 2019 14:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <156104942708.1172531.3848135690205396934.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:50 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Validate that the start and end of the log stay within a single AG if
> we adjust either end to align to stripe units.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ddb25ecc..468b8fde 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3033,15 +3033,28 @@ align_internal_log(
>  	struct xfs_mount	*mp,
>  	int			sunit)
>  {
> +	uint64_t		logend;
> +
>  	/* round up log start if necessary */
>  	if ((cfg->logstart % sunit) != 0)
>  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
>  
> +	/* If our log start overlaps the next AG's metadata, fail. */
> +	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> +			fprintf(stderr,
> +_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
> +  "within an allocation group.\n"),
> +			(long long) cfg->logstart);
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
>  		fprintf(stderr,
>  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
>    "Must fit within an allocation group.\n"),
> 
