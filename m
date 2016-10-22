Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29137 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754888AbcJVAwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 20:52:15 -0400
Date: Fri, 21 Oct 2016 17:52:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: fix up inode cowblocks tracking tracepoints
Message-ID: <20161022005211.GA5256@birch.djwong.org>
References: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
 <1477070533-59327-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477070533-59327-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2016 at 01:22:11PM -0400, Brian Foster wrote:
> These calls are still using the eofblocks tracepoints. The cowblocks
> equivalents are already defined, we just aren't actually calling them.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Good catch!

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_icache.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 14796b7..f295049 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1656,9 +1656,9 @@ void
>  xfs_inode_set_cowblocks_tag(
>  	xfs_inode_t	*ip)
>  {
> -	trace_xfs_inode_set_eofblocks_tag(ip);
> +	trace_xfs_inode_set_cowblocks_tag(ip);
>  	return __xfs_inode_set_eofblocks_tag(ip, xfs_queue_cowblocks,
> -			trace_xfs_perag_set_eofblocks,
> +			trace_xfs_perag_set_cowblocks,
>  			XFS_ICI_COWBLOCKS_TAG);
>  }
>  
> @@ -1666,7 +1666,7 @@ void
>  xfs_inode_clear_cowblocks_tag(
>  	xfs_inode_t	*ip)
>  {
> -	trace_xfs_inode_clear_eofblocks_tag(ip);
> +	trace_xfs_inode_clear_cowblocks_tag(ip);
>  	return __xfs_inode_clear_eofblocks_tag(ip,
> -			trace_xfs_perag_clear_eofblocks, XFS_ICI_COWBLOCKS_TAG);
> +			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
>  }
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
