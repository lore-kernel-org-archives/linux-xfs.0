Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51252 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfFXQBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 12:01:18 -0400
Date: Mon, 24 Jun 2019 09:00:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/12] xfs: simplify xfs_ioend_can_merge
Message-ID: <20190624160056.GN5387@magnolia>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624055253.31183-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 07:52:49AM +0200, Christoph Hellwig wrote:
> Compare the block layer status directly instead of converting it to
> an errno first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 017b87b7765f..acbd73976067 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -226,13 +226,9 @@ xfs_end_ioend(
>  static bool
>  xfs_ioend_can_merge(
>  	struct xfs_ioend	*ioend,
> -	int			ioend_error,
>  	struct xfs_ioend	*next)
>  {
> -	int			next_error;
> -
> -	next_error = blk_status_to_errno(next->io_bio->bi_status);
> -	if (ioend_error != next_error)
> +	if (ioend->io_bio->bi_status != next->io_bio->bi_status)
>  		return false;
>  	if ((ioend->io_fork == XFS_COW_FORK) ^ (next->io_fork == XFS_COW_FORK))
>  		return false;
> @@ -251,17 +247,11 @@ xfs_ioend_try_merge(
>  	struct list_head	*more_ioends)
>  {
>  	struct xfs_ioend	*next_ioend;
> -	int			ioend_error;
> -
> -	if (list_empty(more_ioends))
> -		return;
> -
> -	ioend_error = blk_status_to_errno(ioend->io_bio->bi_status);
>  
>  	while (!list_empty(more_ioends)) {
>  		next_ioend = list_first_entry(more_ioends, struct xfs_ioend,
>  				io_list);
> -		if (!xfs_ioend_can_merge(ioend, ioend_error, next_ioend))
> +		if (!xfs_ioend_can_merge(ioend, next_ioend))
>  			break;
>  		list_move_tail(&next_ioend->io_list, &ioend->io_list);
>  		ioend->io_size += next_ioend->io_size;
> -- 
> 2.20.1
> 
