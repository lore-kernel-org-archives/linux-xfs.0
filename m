Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31725 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdHBTiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 15:38:02 -0400
Date: Wed, 2 Aug 2017 12:37:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Fix leak of discard bio
Message-ID: <20170802193702.GQ4477@magnolia>
References: <20170802083741.4600-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802083741.4600-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org

On Wed, Aug 02, 2017 at 10:37:41AM +0200, Jan Kara wrote:
> The bio describing discard operation is allocated by
> __blkdev_issue_discard() which returns us a reference to it. That
> reference is never released and thus we leak this bio. Drop the bio
> reference once it completes in xlog_discard_endio().
> 
> CC: stable@vger.kernel.org
> Fixes: 4560e78f40cb55bd2ea8f1ef4001c5baa88531c7
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_log_cil.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> Note, this is untested. It's just something I've noticed when looking at the
> code.
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index fbe72b134bef..43aa42a3a5d3 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -539,6 +539,7 @@ xlog_discard_endio(
>  
>  	INIT_WORK(&ctx->discard_endio_work, xlog_discard_endio_work);
>  	queue_work(xfs_discard_wq, &ctx->discard_endio_work);
> +	bio_put(bio);

It would seem that we /do/ leak the bio here. :(

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  }
>  
>  static void
> -- 
> 2.12.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
