Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48974 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdBBXBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 18:01:33 -0500
Date: Thu, 2 Feb 2017 15:01:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: reject all unaligned direct writes to reflinked
 files
Message-ID: <20170202230126.GP9134@birch.djwong.org>
References: <1485985359-971-1-git-send-email-hch@lst.de>
 <1485985359-971-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485985359-971-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2017 at 10:42:36PM +0100, Christoph Hellwig wrote:
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
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_file.c  |  7 +++++++
>  fs/xfs/xfs_iomap.c | 12 +-----------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index bbb9eb6..06236bf 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -527,6 +527,13 @@ xfs_file_dio_aio_write(
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
> index 767208f..d17aa3b 100644
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

Can you either port the tracepoint to the new hunk or just kill it
entirely?

(If you opt for killing it, I'll just remove it from xfs_trace.h when I
import this patch.)

Otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
