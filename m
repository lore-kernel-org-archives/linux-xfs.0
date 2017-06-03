Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40932 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdFCEuq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 00:50:46 -0400
Date: Fri, 2 Jun 2017 21:50:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: avoid -Wint-in-bool-context warning in
 xfs_bmap_util.c
Message-ID: <20170603045041.GF5636@birch.djwong.org>
References: <20170603042107.17469-1-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170603042107.17469-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Fri, Jun 02, 2017 at 09:21:07PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> XFS triggers gcc 7's -Wint-in-bool-context warning (on by default with
> -Wall), which warns about arithmetic in a boolean context that has no
> effect on the result:
> 
>     In file included from fs/xfs/xfs_inode.h:22:0,
>                      from fs/xfs/xfs_bmap_util.c:29:
>     fs/xfs/xfs_bmap_util.c: In function ‘xfs_swap_extents_check_format’:
>     fs/xfs/libxfs/xfs_inode_fork.h:90:30: warning: ‘<<’ in boolean context, did you mean ‘<’ ? [-Wint-in-bool-context]
>      #define XFS_IFORK_BOFF(ip)  ((int)((ip)->i_d.di_forkoff << 3))
>                                  ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     fs/xfs/xfs_bmap_util.c:1620:7: note: in expansion of macro ‘XFS_IFORK_BOFF’
>        if (XFS_IFORK_BOFF(ip) &&
>            ^~~~~~~~~~~~~~
>     fs/xfs/libxfs/xfs_inode_fork.h:90:30: warning: ‘<<’ in boolean context, did you mean ‘<’ ? [-Wint-in-bool-context]
>      #define XFS_IFORK_BOFF(ip)  ((int)((ip)->i_d.di_forkoff << 3))
>                                  ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     fs/xfs/xfs_bmap_util.c:1630:7: note: in expansion of macro ‘XFS_IFORK_BOFF’
>        if (XFS_IFORK_BOFF(tip) &&
>            ^~~~~~~~~~~~~~
> 
> This is more or less a false positive, because the useless arithmetic is
> just the left shift in XFS_IFORK_BOFF().  Use XFS_IFORK_Q() instead to
> make the warnings go away, while having the same behavior and being more
> consistent with other places in XFS which also use XFS_IFORK_Q().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Arnd Bergmann already sent the exact same patch[1] for 4.13, but, er,
thanks for spotting this! :)

--D

[1] https://marc.info/?l=linux-xfs&m=149498134833721&w=2

> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 7ac80a1facf2..05a6fdf5976d 100644
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
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
