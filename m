Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755533AbcJQPgG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:36:06 -0400
Date: Mon, 17 Oct 2016 11:36:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/9] xfs: don't bother looking at the refcount tree for
 reads
Message-ID: <20161017153603.GE12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-5-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:29AM +0200, Christoph Hellwig wrote:
> There is no need to trim an extent into a shared or non-shared one, or
> report any flags for plain old reads.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---

I think the tag above was meant for the subsequent patch, but anyways..
:P

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d907eb9..1dabf2e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -996,11 +996,14 @@ xfs_file_iomap_begin(
>  		return error;
>  	}
>  
> -	/* Trim the mapping to the nearest shared extent boundary. */
> -	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
> -	if (error) {
> -		xfs_iunlock(ip, lockmode);
> -		return error;
> +	if (flags & (IOMAP_WRITE | IOMAP_ZERO | IOMAP_REPORT)) {
> +		/* Trim the mapping to the nearest shared extent boundary. */
> +		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
> +				&trimmed);
> +		if (error) {
> +			xfs_iunlock(ip, lockmode);
> +			return error;
> +		}
>  	}
>  
>  	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
