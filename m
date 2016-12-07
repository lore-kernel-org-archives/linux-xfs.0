Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932632AbcLGS74 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 13:59:56 -0500
Date: Wed, 7 Dec 2016 13:59:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: reject all unaligned direct writes to reflinked
 files
Message-ID: <20161207185953.GB23106@bfoster.bfoster>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
 <1480971924-4864-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480971924-4864-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Mon, Dec 05, 2016 at 10:05:22PM +0100, Christoph Hellwig wrote:
> We currently fall back from direct to buffered writes if we detect a
> remaining shared extent in the iomap_begin callback.  But by the time
> iomap_begin is called for the potentially unaligned end block we might
> have already written most of the data to disk, which we'd now write
> again using buffered I/O.  To avoid this reject all writes to reflinked
> files before starting I/O so that we are guaranteed to only write the
> data once.
> 
> The alternative would be to unshare the unaligned start and/or end block
> before doing the I/O. I think that's doable, and will actually be
> required to support reflinks on DAX file system.  But it will take a
> little more time and I'd rather get rid of the double write ASAP.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c  |  7 +++++++
>  fs/xfs/xfs_iomap.c | 12 +-----------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f5effa6..873cd42 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -532,6 +532,13 @@ xfs_file_dio_aio_write(
>  	if ((iocb->ki_pos & mp->m_blockmask) ||
>  	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
>  		unaligned_io = 1;
> +
> +		/*
> +		 * We can't properly handle unaligned direct I/O to reflink
> +		 * files yet, as we can't unshare a partial block.
> +		 */
> +		if (xfs_is_reflink_inode(ip))
> +			return -EREMCHG;
>  		iolock = XFS_IOLOCK_EXCL;
>  	} else {
>  		iolock = XFS_IOLOCK_SHARED;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0d14742..78105db 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1026,17 +1026,7 @@ xfs_file_iomap_begin(
>  		if (error)
>  			goto out_unlock;
>  
> -		/*
> -		 * We're here because we're trying to do a directio write to a
> -		 * region that isn't aligned to a filesystem block.  If the
> -		 * extent is shared, fall back to buffered mode to handle the
> -		 * RMW.
> -		 */
> -		if (!(flags & IOMAP_REPORT) && shared) {
> -			trace_xfs_reflink_bounce_dio_write(ip, &imap);
> -			error = -EREMCHG;
> -			goto out_unlock;
> -		}
> +		ASSERT((flags & IOMAP_REPORT) || !shared);
>  	}
>  
>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
