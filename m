Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32101 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbeAEBUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:20:00 -0500
Date: Fri, 5 Jan 2018 12:17:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/21] xfs: xfs_scrub_bmap should use for_each_xfs_iext
Message-ID: <20180105011747.GQ30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398978874.18741.7497018527609073813.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398978874.18741.7497018527609073813.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_scrub_bmap to use for_each_xfs_iext now that it exists.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/bmap.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 42fec0b..0261e11 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -235,7 +235,6 @@ xfs_scrub_bmap(
>  	struct xfs_ifork		*ifp;
>  	xfs_fileoff_t			endoff;
>  	struct xfs_iext_cursor		icur;
> -	bool				found;
>  	int				error = 0;
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> @@ -314,9 +313,7 @@ xfs_scrub_bmap(
>  	/* Scrub extent records. */
>  	info.lastoff = 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &irec);
> -	     found != 0;
> -	     found = xfs_iext_next_extent(ifp, &icur, &irec)) {
> +	for_each_xfs_iext(ifp, &icur, &irec) {
>  		if (xfs_scrub_should_terminate(sc, &error))
>  			break;
>  		if (isnullstartblock(irec.br_startblock))

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
