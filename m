Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753313AbeGCQHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 12:07:00 -0400
Date: Tue, 3 Jul 2018 09:06:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] iomap: add inline data support to
 iomap_readpage_actor
Message-ID: <20180703160641.GX5711@magnolia>
References: <20180702145458.22330-1-hch@lst.de>
 <20180702145458.22330-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702145458.22330-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Jul 02, 2018 at 08:54:58AM -0600, Christoph Hellwig wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
> 
> Just copy the inline data into the page using the existing helper.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 98a1fdd5c091..13cdcf33e6c0 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -155,6 +155,12 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	bool is_contig = false;
>  	sector_t sector;
>  
> +	if (iomap->type == IOMAP_INLINE) {
> +		WARN_ON_ONCE(poff);
> +		iomap_read_inline_data(inode, page, iomap);
> +		return PAGE_SIZE;
> +	}
> +
>  	/* we don't support blocksize < PAGE_SIZE quite yet. */
>  	WARN_ON_ONCE(pos != page_offset(page));
>  	WARN_ON_ONCE(plen != PAGE_SIZE);
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
