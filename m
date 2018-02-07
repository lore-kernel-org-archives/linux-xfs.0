Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51650 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBGXXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 18:23:51 -0500
Date: Wed, 7 Feb 2018 15:23:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use memset to initialize xfs_scrub_agfl_info
Message-ID: <20180207232345.GB5433@magnolia>
References: <c6ed0221-31ef-0241-f0d0-418aaf6431c2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6ed0221-31ef-0241-f0d0-418aaf6431c2@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Feb 07, 2018 at 04:23:38PM -0600, Eric Sandeen wrote:
> Apparently different gcc versions have competing and
> incompatible notions of how to initialize at declaration,
> so just give up and fall back to the time-tested memset().
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index fd97552..05c66e0 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -767,7 +767,7 @@ struct xfs_scrub_agfl_info {
>  xfs_scrub_agfl(
>  	struct xfs_scrub_context	*sc)
>  {
> -	struct xfs_scrub_agfl_info	sai = { 0 };
> +	struct xfs_scrub_agfl_info	sai;
>  	struct xfs_agf			*agf;
>  	xfs_agnumber_t			agno;
>  	unsigned int			agflcount;
> @@ -795,6 +795,7 @@ struct xfs_scrub_agfl_info {
>  		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
>  		goto out;
>  	}
> +	memset(&sai, 0, sizeof(sai));
>  	sai.sz_entries = agflcount;
>  	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount, KM_NOFS);
>  	if (!sai.entries) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
