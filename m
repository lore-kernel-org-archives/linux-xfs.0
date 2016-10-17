Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49611 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934164AbcJQQ13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 12:27:29 -0400
Date: Mon, 17 Oct 2016 09:27:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/9] xfs: handle "raw" delayed extents
 xfs_reflink_trim_around_shared
Message-ID: <20161017162724.GC1120@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Sat, Oct 15, 2016 at 10:52:28AM +0200, Christoph Hellwig wrote:
> Delalloc extents in the extent list contain the number of reserved
> indirect blocks in their startblock value and don't use the magic
> DELAYSTARTBLOCK constant.  Ensure that xfs_reflink_trim_around_shared
> handles them properly by checking for isnullstartblock().
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
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
