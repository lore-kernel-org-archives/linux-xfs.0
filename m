Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbdJaRxl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:53:41 -0400
Date: Tue, 31 Oct 2017 13:53:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/18] xfs: treat idx as a cursor in
 xfs_bmap_add_extent_hole_real
Message-ID: <20171031175339.GG7093@bfoster.bfoster>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:17PM +0200, Christoph Hellwig wrote:
> Stop poking before and after the index and just increment or decrement
> it while doing our operations on it to prepare for a new extent list
> implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6358b30b70f9..7bd27c08981f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2741,11 +2741,11 @@ xfs_bmap_add_extent_hole_real(
>  		 * left and on the right.
>  		 * Merge all three into a single extent record.
>  		 */
> -		--*idx;
>  		left.br_blockcount += new->br_blockcount + right.br_blockcount;
> -		xfs_iext_update_extent(ip, state, *idx, &left);
>  
> -		xfs_iext_remove(ip, *idx + 1, 1, state);
> +		xfs_iext_remove(ip, *idx, 1, state);
> +		--*idx;
> +		xfs_iext_update_extent(ip, state, *idx, &left);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> @@ -2777,10 +2777,10 @@ xfs_bmap_add_extent_hole_real(
>  		 * on the left.
>  		 * Merge the new allocation with the left neighbor.
>  		 */
> -		--*idx;
>  		old = left;
> -
>  		left.br_blockcount += new->br_blockcount;
> +
> +		--*idx;
>  		xfs_iext_update_extent(ip, state, *idx, &left);
>  
>  		if (cur == NULL) {
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
