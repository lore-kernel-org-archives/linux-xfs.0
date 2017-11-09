Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61527 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751914AbdKICJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:09:06 -0500
Date: Thu, 9 Nov 2017 13:08:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: check the uniqueness of the AGFL entries
Message-ID: <20171109020829.GK4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001660786.26786.14027251894350460924.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001660786.26786.14027251894350460924.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 05:03:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we don't list a block twice in the agfl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
>  /* Scrub the AGFL. */
>  int
>  xfs_scrub_agfl(
>  	struct xfs_scrub_context	*sc)
>  {
> +	struct xfs_scrub_agfl_info	sai = { 0 };
> +	struct xfs_agf			*agf;
> +	size_t				sz;
>  	xfs_agnumber_t			agno;
> +	unsigned int			agflcount;
> +	unsigned int			i;
>  	int				error;
>  
>  	agno = sc->sa.agno = sc->sm->sm_agno;
> @@ -508,8 +532,33 @@ xfs_scrub_agfl(
>  	if (!sc->sa.agf_bp)
>  		return -EFSCORRUPTED;
>  
> +	/* Allocate buffer to ensure uniqueness of AGFL entries. */
> +	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> +	agflcount = be32_to_cpu(agf->agf_flcount);
> +	sz = sizeof(xfs_agblock_t) * agflcount;
> +	if (sz > sc->mp->m_sb.sb_sectsize) {

No need for sz?

	if (agflcount > XFS_AGFL_SIZE(mp)

> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> +		goto out;
> +	}
> +	sai.entries = kmem_zalloc(sz, KM_NOFS);

KM_NOSLEEP, check for failure?

Otherwise looks ok.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
