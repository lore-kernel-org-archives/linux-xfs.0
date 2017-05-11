Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25993 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756737AbdEKPSQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 11:18:16 -0400
Date: Thu, 11 May 2017 08:17:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: avoid harmless gcc-7 warnings
Message-ID: <20170511151757.GA4519@birch.djwong.org>
References: <20170511150450.2573345-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511150450.2573345-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org

On Thu, May 11, 2017 at 05:04:33PM +0200, Arnd Bergmann wrote:
> gcc-7 flags the use of integer math inside of a condition
> as a potential bug:
> 
> fs/xfs/xfs_bmap_util.c: In function 'xfs_swap_extents_check_format':
> fs/xfs/xfs_bmap_util.c:1619:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> fs/xfs/xfs_bmap_util.c:1629:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> 
> There is already a helper function for testing the di_forkoff
> field for zero, so let's use that instead to shut up the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2b954308a1d6..da4867567647 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
>  	 * extent format...
>  	 */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> -		if (XFS_IFORK_BOFF(ip) &&
> +		if (XFS_IFORK_Q(ip) &&
>  		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
>  			return -EINVAL;
>  		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
> @@ -1623,7 +1623,7 @@ xfs_swap_extents_check_format(
>  
>  	/* Reciprocal target->temp btree format checks */
>  	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> -		if (XFS_IFORK_BOFF(tip) &&
> +		if (XFS_IFORK_Q(tip) &&
>  		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
>  			return -EINVAL;
>  		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
> -- 
> 2.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
