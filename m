Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23170 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbdJaVfk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 17:35:40 -0400
Date: Tue, 31 Oct 2017 14:35:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/18] xfs: treat idx as a cursor in
 xfs_bmap_add_extent_hole_delay
Message-ID: <20171031213536.GM4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:16PM +0200, Christoph Hellwig wrote:
> Stop poking before and after the index and just increment or decrement
> it while doing our operations on it to prepare for a new extent list
> implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 83f5a503dce1..6358b30b70f9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2583,7 +2583,6 @@ xfs_bmap_add_extent_hole_delay(
>  		 * on the left and on the right.
>  		 * Merge all three into a single extent record.
>  		 */
> -		--*idx;
>  		temp = left.br_blockcount + new->br_blockcount +
>  			right.br_blockcount;
>  
> @@ -2594,9 +2593,10 @@ xfs_bmap_add_extent_hole_delay(
>  					 oldlen);
>  		left.br_startblock = nullstartblock(newlen);
>  		left.br_blockcount = temp;
> -		xfs_iext_update_extent(ip, state, *idx, &left);
>  
> -		xfs_iext_remove(ip, *idx + 1, 1, state);
> +		xfs_iext_remove(ip, *idx, 1, state);
> +		--*idx;
> +		xfs_iext_update_extent(ip, state, *idx, &left);
>  		break;
>  
>  	case BMAP_LEFT_CONTIG:
> @@ -2605,7 +2605,6 @@ xfs_bmap_add_extent_hole_delay(
>  		 * on the left.
>  		 * Merge the new allocation with the left neighbor.
>  		 */
> -		--*idx;
>  		temp = left.br_blockcount + new->br_blockcount;
>  
>  		oldlen = startblockval(left.br_startblock) +
> @@ -2614,6 +2613,8 @@ xfs_bmap_add_extent_hole_delay(
>  					 oldlen);
>  		left.br_blockcount = temp;
>  		left.br_startblock = nullstartblock(newlen);
> +
> +		--*idx;
>  		xfs_iext_update_extent(ip, state, *idx, &left);
>  		break;
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
