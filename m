Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26696 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdGRSPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 14:15:42 -0400
Date: Tue, 18 Jul 2017 11:15:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170718181535.GJ4224@magnolia>
References: <20170718172545.18065-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718172545.18065-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: n.borisov.lkml@gmail.com, linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 07:25:45PM +0200, Christoph Hellwig wrote:
> Just like in the allocator we must avoid touching multiple AGs out of
> order when freeing blocks, as freeing still locks the AGF and can cause
> the same AB-BA deadlocks as in the allocation path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>

Looks ok, though I wonder what the bug report looked like. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0a9880777c9c..935adde72a8b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5435,6 +5435,7 @@ __xfs_bunmapi(
>  	xfs_fsblock_t		sum;
>  	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
>  	xfs_fileoff_t		max_len;
> +	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
>  
>  	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
>  
> @@ -5534,6 +5535,17 @@ __xfs_bunmapi(
>  		 */
>  		del = got;
>  		wasdel = isnullstartblock(del.br_startblock);
> +
> +		/*
> +		 * Make sure we don't touch multiple AGF headers out of order
> +		 * in a single transaction, as that could cause AB-BA deadlocks.
> +		 */
> +		if (!wasdel) {
> +			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
> +			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
> +				break;
> +			prev_agno = agno;
> +		}
>  		if (got.br_startoff < start) {
>  			del.br_startoff = start;
>  			del.br_blockcount -= start - got.br_startoff;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
