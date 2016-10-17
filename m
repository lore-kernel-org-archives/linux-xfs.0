Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754595AbcJQPfw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:35:52 -0400
Date: Mon, 17 Oct 2016 11:35:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] xfs: add xfs_trim_extent
Message-ID: <20161017153550.GC12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:27AM +0200, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> This helpers allows to trim an extent to a subset of it's original range
> while making sure the block numbers in it remain valid,
> 
> In the future xfs_trim_extent and xfs_bmapi_trim_map should probably be
> merged in some form.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [hch: split from a previous patch from Darrick, moved around and added
>  support for "raw" delayed extents"]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 33 +++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_bmap.h |  2 ++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c27344c..016dacc 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3999,6 +3999,39 @@ xfs_bmap_alloc(
>  	return xfs_bmap_btalloc(ap);
>  }
>  
> +/* Trim extent to fit a logical block range. */
> +void
> +xfs_trim_extent(
> +	struct xfs_bmbt_irec	*irec,
> +	xfs_fileoff_t		bno,
> +	xfs_filblks_t		len)
> +{
> +	xfs_fileoff_t		distance;
> +	xfs_fileoff_t		end = bno + len;
> +
> +	if (irec->br_startoff + irec->br_blockcount <= bno ||
> +	    irec->br_startoff >= end) {
> +		irec->br_blockcount = 0;
> +		return;
> +	}
> +
> +	if (irec->br_startoff < bno) {
> +		distance = bno - irec->br_startoff;
> +		if (isnullstartblock(irec->br_startblock))
> +			irec->br_startblock = DELAYSTARTBLOCK;
> +		if (irec->br_startblock != DELAYSTARTBLOCK &&
> +		    irec->br_startblock != HOLESTARTBLOCK)
> +			irec->br_startblock += distance;
> +		irec->br_startoff += distance;
> +		irec->br_blockcount -= distance;
> +	}
> +
> +	if (end < irec->br_startoff + irec->br_blockcount) {
> +		distance = irec->br_startoff + irec->br_blockcount - end;
> +		irec->br_blockcount -= distance;
> +	}
> +}
> +
>  /*
>   * Trim the returned map to the required bounds
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index f97db71..eb86af0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -190,6 +190,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
>  #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
>  #endif
>  
> +void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
> +		xfs_filblks_t len);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
>  void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
