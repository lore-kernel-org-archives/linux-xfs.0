Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54388 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbfDDQky (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:40:54 -0400
Subject: Re: [PATCH 45/36] xfs_scrub: rename confusing structure
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320200330.GI1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <34a79955-0121-5a50-dbf9-45c230fea153@sandeen.net>
Date: Thu, 4 Apr 2019 11:40:53 -0500
MIME-Version: 1.0
In-Reply-To: <20190320200330.GI1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 3:03 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename xfs_verify_extent to media_verify_state so that the name more
> accurately reflects what we're storing in the structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Hate to do this, but "*ve" made sense for "verify extent" but
really doesn't for "verify state..."  If the point is clarity, I
think s/ve/vs/ would be reasonable as well?  It's about 35 instances.

> ---
>  scrub/phase6.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 5e2b9ee3..2b4f6ff1 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -35,7 +35,7 @@
>  
>  /* Verify disk blocks with GETFSMAP */
>  
> -struct xfs_verify_extent {
> +struct media_verify_state {
>  	struct read_verify_pool	*rvp_data;
>  	struct read_verify_pool	*rvp_log;
>  	struct read_verify_pool	*rvp_realtime;
> @@ -47,7 +47,7 @@ struct xfs_verify_extent {
>  static struct read_verify_pool *
>  xfs_dev_to_pool(
>  	struct scrub_ctx		*ctx,
> -	struct xfs_verify_extent	*ve,
> +	struct media_verify_state	*ve,
>  	dev_t				dev)
>  {
>  	if (dev == ctx->fsinfo.fs_datadev)
> @@ -348,7 +348,7 @@ xfs_check_rmap_ioerr(
>  {
>  	struct fsmap			keys[2];
>  	char				descr[DESCR_BUFSZ];
> -	struct xfs_verify_extent	*ve = arg;
> +	struct media_verify_state	*ve = arg;
>  	struct bitmap			*tree;
>  	dev_t				dev;
>  	bool				moveon;
> @@ -395,7 +395,7 @@ xfs_check_rmap(
>  	struct fsmap			*map,
>  	void				*arg)
>  {
> -	struct xfs_verify_extent	*ve = arg;
> +	struct media_verify_state	*ve = arg;
>  	struct read_verify_pool		*rvp;
>  
>  	rvp = xfs_dev_to_pool(ctx, ve, map->fmr_device);
> @@ -463,7 +463,7 @@ bool
>  xfs_scan_blocks(
>  	struct scrub_ctx		*ctx)
>  {
> -	struct xfs_verify_extent	ve = { NULL };
> +	struct media_verify_state	ve = { NULL };
>  	bool				moveon;
>  
>  	moveon = bitmap_init(&ve.d_bad);
> 
