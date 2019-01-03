Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34090 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfACR6G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 12:58:06 -0500
Date: Thu, 3 Jan 2019 09:57:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs_metadump: Zap unused space in inode btrees
Message-ID: <20190103175757.GF20475@magnolia>
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <20181105213145.7560-5-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105213145.7560-5-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 10:31:44PM +0100, Stefan Ring wrote:
> Signed-off-by: Stefan Ring <stefanrin@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/metadump.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index d4c751c0..59765263 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2173,6 +2173,19 @@ process_btinode(
>  	}
>  
>  	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
> +
> +	if (zero_stale_data) {
> +		char	*top;
> +
> +		/* Unused btree key space */
> +		top = (char*)XFS_BMDR_KEY_ADDR(dib, nrecs + 1);
> +		memset(top, 0, (char*)pp - top);
> +
> +		/* Unused btree ptr space */
> +		top = (char*)&pp[nrecs];
> +		memset(top, 0, (char*)dib + XFS_DFORK_SIZE(dip, mp, whichfork) - top);
> +	}
> +
>  	for (i = 0; i < nrecs; i++) {
>  		xfs_agnumber_t	ag;
>  		xfs_agblock_t	bno;
> -- 
> 2.14.5
> 
