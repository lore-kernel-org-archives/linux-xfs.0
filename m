Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387846AbfBKPWz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Feb 2019 10:22:55 -0500
Date: Mon, 11 Feb 2019 10:22:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] xfs: remove the truncate short cut in
 xfs_map_blocks
Message-ID: <20190211152252.GH2804@bfoster>
References: <20190211125427.16577-1-hch@lst.de>
 <20190211125427.16577-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211125427.16577-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 11, 2019 at 01:54:26PM +0100, Christoph Hellwig wrote:
> Now that we properly handle the race with truncate in the delalloc
> allocator there is no need to short cut this exceptional case earlier
> on.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 403df647c0e4..6a8937a833ad 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -426,26 +426,6 @@ xfs_map_blocks(
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
