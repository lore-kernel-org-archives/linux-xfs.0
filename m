Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48978 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdJaVhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 17:37:07 -0400
Date: Tue, 31 Oct 2017 14:37:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/18] xfs: treat idx as a cursor in xfs_bmap_del_extent_*
Message-ID: <20171031213703.GP4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:19PM +0200, Christoph Hellwig wrote:
> Stop poking before and after the index and just increment or decrement
> it while doing our operations on it to prepare for a new extent list
> implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 10878c495869..5ba0c0368629 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4749,12 +4749,12 @@ xfs_bmap_del_extent_delay(
>  						       del->br_blockcount);
>  
>  		got->br_startblock = nullstartblock((int)got_indlen);
> -		xfs_iext_update_extent(ip, state, *idx, got);
>  
>  		new.br_startoff = del_endoff;
>  		new.br_state = got->br_state;
>  		new.br_startblock = nullstartblock((int)new_indlen);
>  
> +		xfs_iext_update_extent(ip, state, *idx, got);
>  		++*idx;
>  		xfs_iext_insert(ip, *idx, 1, &new, state);
>  
> @@ -4831,13 +4831,13 @@ xfs_bmap_del_extent_cow(
>  		 * Deleting the middle of the extent.
>  		 */
>  		got->br_blockcount = del->br_startoff - got->br_startoff;
> -		xfs_iext_update_extent(ip, state, *idx, got);
>  
>  		new.br_startoff = del_endoff;
>  		new.br_blockcount = got_endoff - del_endoff;
>  		new.br_state = got->br_state;
>  		new.br_startblock = del->br_startblock + del->br_blockcount;
>  
> +		xfs_iext_update_extent(ip, state, *idx, got);
>  		++*idx;
>  		xfs_iext_insert(ip, *idx, 1, &new, state);
>  		break;
> @@ -5053,8 +5053,8 @@ xfs_bmap_del_extent_real(
>  			flags |= xfs_ilog_fext(whichfork);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> -		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
>  		++*idx;
> +		xfs_iext_insert(ip, *idx, 1, &new, state);
>  		break;
>  	}
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
