Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388691AbfBOXhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 18:37:51 -0500
Date: Fri, 15 Feb 2019 15:37:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/10] xfs: remove the truncate short cut in
 xfs_map_blocks
Message-ID: <20190215233742.GS32253@magnolia>
References: <20190215144725.8894-1-hch@lst.de>
 <20190215144725.8894-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215144725.8894-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Feb 15, 2019 at 03:47:24PM +0100, Christoph Hellwig wrote:
> Now that we properly handle the race with truncate in the delalloc
> allocator there is no need to short cut this exceptional case earlier
> on.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok modulo my comments in patch 10/10,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 42017ecf78ed..a6abb7125203 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -420,26 +420,6 @@ xfs_map_blocks(
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
>  		wpc->fork = XFS_COW_FORK;
> -
> -		/*
> -		 * Truncate can race with writeback since writeback doesn't
> -		 * take the iolock and truncate decreases the file size before
> -		 * it starts truncating the pages between new_size and old_size.
> -		 * Therefore, we can end up in the situation where writeback
> -		 * gets a CoW fork mapping but the truncate makes the mapping
> -		 * invalid and we end up in here trying to get a new mapping.
> -		 * bail out here so that we simply never get a valid mapping
> -		 * and so we drop the write altogether.  The page truncation
> -		 * will kill the contents anyway.
> -		 */
> -		if (offset > i_size_read(inode)) {
> -			wpc->imap.br_blockcount = end_fsb - offset_fsb;
> -			wpc->imap.br_startoff = offset_fsb;
> -			wpc->imap.br_startblock = HOLESTARTBLOCK;
> -			wpc->imap.br_state = XFS_EXT_NORM;
> -			return 0;
> -		}
> -
>  		goto allocate_blocks;
>  	}
>  
> -- 
> 2.20.1
> 
