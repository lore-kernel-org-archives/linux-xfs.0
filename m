Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AAEFE7F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 20:55:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23E34AC004
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 18:55:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hZUFmaXGpWMVpBDE for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 18:55:47 -0700 (PDT)
Date: Mon, 14 Apr 2014 11:55:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: split xfs_bmap_btalloc_nullfb
Message-ID: <20140414015544.GH27694@dastard>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
	<1397289723-26243-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397289723-26243-3-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Apr 12, 2014 at 10:01:56AM +0200, Christoph Hellwig wrote:
> Split xfs_bmap_btalloc_nullfb into one function for filestream allocations
> and one for everything else that share a few helpers.  This dramatically
> simplifies the control flow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Small comment below.

> ---
>  fs/xfs/xfs_bmap.c |  200 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 117 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 3340f0e..d5d52df 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -3517,6 +3517,67 @@ xfs_bmap_adjacent(
>  #undef ISVALID
>  }
>  
> +static int
> +xfs_bmap_longest_free_extent(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		ag,
> +	xfs_extlen_t		*blen,
> +	int			*notinit)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_perag	*pag;
> +	xfs_extlen_t		longest;
> +	int			error = 0;
> +
> +	pag = xfs_perag_get(mp, ag);
> +	if (!pag->pagf_init) {
> +		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
> +		if (error)
> +			goto out;
> +
> +		if (!pag->pagf_init) {
> +			*notinit = 1;
> +			goto out;
> +		}
> +	}
> +
> +	longest = xfs_alloc_longest_free_extent(mp, pag);
> +	if (*blen < longest)
> +		*blen = longest;
> +
> +out:
> +	xfs_perag_put(pag);
> +	return error;
> +}
> +
> +static void
> +xfs_bmap_fix_args(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	xfs_extlen_t		*blen,
> +	int			notinit)

Not a big fan of the "fix_args" name here. What it's actually doing
is setting the minimum allocation length. Also, it could return the
minimum length rather than set it inside the function, and pass
blen by value rather than reference as it isn't modified in the
function...

Other than that, it's a good cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
