Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfF0PNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 11:13:17 -0400
Date: Thu, 27 Jun 2019 08:13:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190627151307.GM5171@magnolia>
References: <20190627143950.19558-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627143950.19558-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com

On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> Properly allocate the space for the bio_vecs instead of just one byte
> per bio_vec.
> 
> Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> Reported-by: syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Doh....

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0f849b4095d6..e230f3c18ceb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1415,7 +1415,8 @@ xlog_alloc_log(
>  	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE);
> +		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
> +				sizeof(struct bio_vec);
>  
>  		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
>  		if (!iclog)
> -- 
> 2.20.1
> 
