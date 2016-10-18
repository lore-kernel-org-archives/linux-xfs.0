Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754431AbcJRM6E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 08:58:04 -0400
Date: Tue, 18 Oct 2016 14:58:00 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: don't take the IOLOCK exclusive for direct I/O page
 invalidation
Message-ID: <20161018125800.j532h3aponjxyqe3@eorzea.usersys.redhat.com>
References: <1476706392-2264-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476706392-2264-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org

On Mon, Oct 17, 2016 at 02:13:12PM +0200, Christoph Hellwig wrote:
> XFS historically took the iolock exclusive when invalidating pages
> before direct I/O operations to protect against writeback starvations.
> 
> But this writeback starvation issues has been fixed a long time ago
> in the core writeback code, and all other file systems manage to do
> without the exclusive lock.  Convert XFS over to avoid the exclusive
> lock in this case, and also move to range invalidations like done
> by the other file systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 98 +++++++++++++++++--------------------------------------
>  1 file changed, 30 insertions(+), 68 deletions(-)
> 
>  
>  	/*
>  	 * If we are doing unaligned IO, wait for all other IO to drain,
> -	 * otherwise demote the lock if we had to flush cached pages
> +	 * otherwise demote the lock if we had to take the exclusive lock
> +	 * for other reaosons in xfs_file_aio_write_checks.
		     ^ reasons

>  	 */
>  	if (unaligned_io)
>  		inode_dio_wait(inode);
> -- 
> 2.1.4

Despite typo above, it looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
