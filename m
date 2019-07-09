Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55708 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 11:45:54 -0400
Date: Tue, 9 Jul 2019 08:45:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: chain bios the right way around in xfs_rw_bdev
Message-ID: <20190709154546.GS1404256@magnolia>
References: <20190709152352.27465-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152352.27465-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Tue, Jul 09, 2019 at 08:23:52AM -0700, Christoph Hellwig wrote:
> We need to chain the earlier bios to the later ones, so that
> submit_bio_wait waits on the bio that all the completions are
> dispatched to.
> 
> Fixes: 6ad5b3255b9e ("xfs: use bios directly to read and write the log recovery buffers")
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me; anyone else want to add a tested-by?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bio_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 757c1d9293eb..e2148f2d5d6b 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -43,7 +43,7 @@ xfs_rw_bdev(
>  			bio_copy_dev(bio, prev);
>  			bio->bi_iter.bi_sector = bio_end_sector(prev);
>  			bio->bi_opf = prev->bi_opf;
> -			bio_chain(bio, prev);
> +			bio_chain(prev, bio);
>  
>  			submit_bio(prev);
>  		}
> -- 
> 2.20.1
> 
