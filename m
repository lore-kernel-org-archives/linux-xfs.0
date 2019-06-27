Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0Ruc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 13:50:32 -0400
Date: Thu, 27 Jun 2019 10:50:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/13] xfs: remove the unused xfs_count_page_state
 declaration
Message-ID: <20190627175011.GO5171@magnolia>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627104836.25446-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 27, 2019 at 12:48:25PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index f62b03186c62..45a1ea240cbb 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -28,7 +28,6 @@ extern const struct address_space_operations xfs_dax_aops;
>  
>  int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
>  
> -extern void xfs_count_page_state(struct page *, int *, int *);
>  extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
>  extern struct dax_device *xfs_find_daxdev_for_inode(struct inode *);
>  
> -- 
> 2.20.1
> 
