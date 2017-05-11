Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751969AbdEKNdG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 09:33:06 -0400
Subject: Re: [PATCH] xfs: avoid harmless gcc-7 warnings
References: <20170511124932.226016-1-arnd@arndb.de>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <7aa9d167-8870-748e-3986-29ea1a60e5b8@redhat.com>
Date: Thu, 11 May 2017 08:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <20170511124932.226016-1-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Calvin Owens <calvinowens@fb.com>, linux-kernel@vger.kernel.org

On 5/11/17 7:49 AM, Arnd Bergmann wrote:
> gcc-7 flags the use of integer math inside of a condition
> as a potential bug:
> 
> fs/xfs/xfs_bmap_util.c: In function 'xfs_swap_extents_check_format':
> fs/xfs/xfs_bmap_util.c:1619:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> fs/xfs/xfs_bmap_util.c:1629:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> 
> This one is clearly fine, and we can add a comparison to zero
> to shut up the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd -

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2b954308a1d6..cbd3ffe42f39 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
>  	 * extent format...
>  	 */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> -		if (XFS_IFORK_BOFF(ip) &&
> +		if ((XFS_IFORK_BOFF(ip) != 0) &&
>  		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
>  			return -EINVAL;
>  		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
> @@ -1623,7 +1623,7 @@ xfs_swap_extents_check_format(
>  
>  	/* Reciprocal target->temp btree format checks */
>  	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> -		if (XFS_IFORK_BOFF(tip) &&
> +		if ((XFS_IFORK_BOFF(tip) != 0) &&
>  		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
>  			return -EINVAL;
>  		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
> 

