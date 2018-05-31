Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755688AbeEaRPg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 13:15:36 -0400
Date: Thu, 31 May 2018 12:15:35 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 2/4] xfs: xfs_rtbuf_get should check the bmapi_read
 results
Message-ID: <20180531171535.GB25547@redhat.com>
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
 <152778443693.6891.16527148773204429254.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152778443693.6891.16527148773204429254.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 09:33:57AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs_rtbuf_get function should check the block mapping it gets back
> from bmapi_read.  If there are no mappings or the mapping isn't a real
> extent, we should return -EFSCORRUPTED rather than trying to read a
> garbage value.  We also require realtime bitmap blocks to be real,
> written allocations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
looks fine...
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 106be2d0bb88..7712f282d172 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -90,6 +90,9 @@ xfs_rtbuf_get(
>  	if (error)
>  		return error;
>  
> +	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
> +		return -EFSCORRUPTED;
> +
>  	ASSERT(map.br_startblock != NULLFSBLOCK);
>  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
