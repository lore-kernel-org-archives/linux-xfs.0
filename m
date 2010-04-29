Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TKnYhR100202 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 15:49:35 -0500
Subject: Re: [PATCH 10/11] xfs: clean up end index calculation in
	xfs_page_state_convert
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123016.305118675@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123016.305118675@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 15:50:53 -0500
Message-ID: <1272574253.3221.145.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2010-04-28 at 08:29 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-iomap-cleanup-11)
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Whoops, I think I responded twice to patch 9.

The whole series of 11 looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:52.857024355 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:54.989003542 +0200
> @@ -1064,7 +1064,7 @@ xfs_page_state_convert(
>  	unsigned long           p_offset = 0;
>  	unsigned int		type;
>  	__uint64_t              end_offset;
> -	pgoff_t                 end_index, last_index, tlast;
> +	pgoff_t                 end_index, last_index;
>  	ssize_t			size, len;
>  	int			flags, err, imap_valid = 0, uptodate = 1;
>  	int			page_dirty, count = 0;
> @@ -1259,15 +1259,22 @@ xfs_page_state_convert(
>  		xfs_start_page_writeback(page, 1, count);
>  
>  	if (ioend && imap_valid) {
> -		struct xfs_mount	*m = XFS_I(inode)->i_mount;
> -		xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap.br_startoff);
> -		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(m, imap.br_blockcount);
> -
> -		offset = (iomap_offset + iomap_bsize - 1) >>
> -					PAGE_CACHE_SHIFT;
> -		tlast = min_t(pgoff_t, offset, last_index);
> +		xfs_off_t		end_index;
> +
> +		end_index = imap.br_startoff + imap.br_blockcount;
> +
> +		/* to bytes */
> +		end_index <<= inode->i_blkbits;
> +
> +		/* to pages */
> +		end_index = (end_index - 1) >> PAGE_CACHE_SHIFT;
> +
> +		/* check against file size */
> +		if (end_index > last_index)
> +			end_index = last_index;
> +
>  		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
> -					wbc, startio, all_bh, tlast);
> +					wbc, startio, all_bh, end_index);
>  	}
>  
>  	if (iohead)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
