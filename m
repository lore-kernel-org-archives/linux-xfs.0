Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMZqoZ175873 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:35:53 -0600
Received: from out2.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECB8516DC8A0
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:35:50 -0800 (PST)
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26]) by cuda.sgi.com with ESMTP id hRu0xrkT43ecilW6
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:35:50 -0800 (PST)
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 805B820DAB
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 17:35:50 -0500 (EST)
Date: Tue, 22 Nov 2011 13:34:25 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 4/9] [PATCH 4/9] xfs: dont serialise direct IO reads on
	page cache
Message-ID: <20111122213425.GA29127@kroah.com>
References: <20111119181336.964593075@bombadil.infradead.org>
	<20111119181544.111984285@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111119181544.111984285@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>, stable@vger.kernel.org, xfs@oss.sgi.com

On Sat, Nov 19, 2011 at 01:13:40PM -0500, Christoph Hellwig wrote:
> There is no need to grab the i_mutex of the IO lock in exclusive
> mode if we don't need to invalidate the page cache. Taking these
> locks on every direct IO effective serialises them as taking the IO
> lock in exclusive mode has to wait for all shared holders to drop
> the lock. That only happens when IO is complete, so effective it
> prevents dispatch of concurrent direct IO reads to the same inode.
> 
> Fix this by taking the IO lock shared to check the page cache state,
> and only then drop it and take the IO lock exclusively if there is
> work to be done. Hence for the normal direct IO case, no exclusive
> locking will occur.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Tested-by: Joern Engel <joern@logfs.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Alex Elder <aelder@sgi.com>

What is the git commit id that matches this patch in Linus's tree?

thanks,

greg k-h

> ---
>  fs/xfs/linux-2.6/xfs_file.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index 7f782af2..93cc02d 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -309,7 +309,19 @@ xfs_file_aio_read(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if (unlikely(ioflags & IO_ISDIRECT)) {
> +	/*
> +	 * Locking is a bit tricky here. If we take an exclusive lock
> +	 * for direct IO, we effectively serialise all new concurrent
> +	 * read IO to this file and block it behind IO that is currently in
> +	 * progress because IO in progress holds the IO lock shared. We only
> +	 * need to hold the lock exclusive to blow away the page cache, so
> +	 * only take lock exclusively if the page cache needs invalidation.
> +	 * This allows the normal direct IO case of no page cache pages to
> +	 * proceeed concurrently without serialisation.
> +	 */
> +	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
> +	if ((ioflags & IO_ISDIRECT) && inode->i_mapping->nrpages) {
> +		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
>  		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
>  
>  		if (inode->i_mapping->nrpages) {
> @@ -322,8 +334,7 @@ xfs_file_aio_read(
>  			}
>  		}
>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
> -	} else
> -		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
> +	}
>  
>  	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
>  
> -- 
> 1.7.7
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
