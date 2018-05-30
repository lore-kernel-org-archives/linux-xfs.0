Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeE3Fvi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 01:51:38 -0400
Date: Tue, 29 May 2018 22:51:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/34] iomap: use __bio_add_page in iomap_dio_zero
Message-ID: <20180530055132.GA30110@magnolia>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523144357.18985-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 04:43:35PM +0200, Christoph Hellwig wrote:
> We don't need any merging logic, and this also replaces a BUG_ON with a
> WARN_ON_ONCE inside __bio_add_page for the impossible overflow condition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index f52209a2c270..8e28f25f086f 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -949,8 +949,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
>  	bio->bi_end_io = iomap_dio_bio_end_io;
>  
>  	get_page(page);
> -	if (bio_add_page(bio, page, len, 0) != len)
> -		BUG();
> +	__bio_add_page(bio, page, len, 0);
>  	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
>  
>  	atomic_inc(&dio->ref);
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
