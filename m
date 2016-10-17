Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754595AbcJQPf5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:35:57 -0400
Date: Mon, 17 Oct 2016 11:35:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs: handle "raw" delayed extents
 xfs_reflink_trim_around_shared
Message-ID: <20161017153555.GD12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-4-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:28AM +0200, Christoph Hellwig wrote:
> Delalloc extents in the extent list contain the number of reserved
> indirect blocks in their startblock value and don't use the magic
> DELAYSTARTBLOCK constant.  Ensure that xfs_reflink_trim_around_shared
> handles them properly by checking for isnullstartblock().
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 5965e94..46c824c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -182,7 +182,8 @@ xfs_reflink_trim_around_shared(
>  	if (!xfs_is_reflink_inode(ip) ||
>  	    ISUNWRITTEN(irec) ||
>  	    irec->br_startblock == HOLESTARTBLOCK ||
> -	    irec->br_startblock == DELAYSTARTBLOCK) {
> +	    irec->br_startblock == DELAYSTARTBLOCK ||
> +	    isnullstartblock(irec->br_startblock)) {
>  		*shared = false;
>  		return 0;
>  	}
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
