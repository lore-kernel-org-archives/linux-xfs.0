Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32126 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752965AbdHBLdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 07:33:54 -0400
Date: Wed, 2 Aug 2017 21:33:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix leak of discard bio
Message-ID: <20170802113349.GR17762@dastard>
References: <20170802083741.4600-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802083741.4600-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, stable@vger.kernel.org

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
>  }

At a quick glance, it does seem that we are leaking the bio here. It
appears to me that ext4_process_freed_data() also has the same
problem and leaks the discard_bio....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
