Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58345 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfAaSLL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:11:11 -0500
Date: Thu, 31 Jan 2019 13:11:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/11] xfs: don't try to map blocks beyond i_size in
 writeback
Message-ID: <20190131181108.GF36239@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131075524.4769-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:55:17AM +0100, Christoph Hellwig wrote:
> We already shortcut xfs_map_blocks for COW mappings, but there is just
> as little reason to start writeback beyond i_size in the data fork.
> 
> Note that this has to be just an optimization as hole punches can unmaps
> block just like truncate, and we need to handle that case further down
> in the low-level code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8bfb62d8776f..9c2a1947d5dd 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -348,6 +348,20 @@ xfs_map_blocks(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	/*
> +	 * If the offset is beyond the inode size, we know that we raced with
> +	 * truncate.  No point in doing calling any lower level code, just
> +	 * return a hole so that the writeback code skips writeback for the
> +	 * rest of the file.
> +	 */
> +	if (offset > i_size_read(inode)) {
> +		wpc->imap.br_startoff = offset_fsb;
> +		wpc->imap.br_blockcount = end_fsb - offset_fsb;
> +		wpc->imap.br_startblock = HOLESTARTBLOCK;
> +		wpc->imap.br_state = XFS_EXT_NORM;
> +		return 0;
> +	}
> +

The code looks fine, but I don't see any more value in this code than
the similar code down in xfs_iomap_write_allocate(). The comment implies
this skips writeback for the rest of the file, but AFACT the higher
level page->index code in xfs_do_writepage() already does that. All
these checks do is skip the remaining blocks in the current page. When
you consider that we're most likely sending an I/O in the latter case
either way, I'm curious why we'd bother to keep this around at all.

Brian

>  	/*
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
> @@ -388,26 +402,6 @@ xfs_map_blocks(
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
