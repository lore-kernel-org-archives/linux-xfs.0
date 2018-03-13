Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35346 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbeCMUu6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:50:58 -0400
Date: Tue, 13 Mar 2018 13:50:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/8] xfs: mark xfs_reflink_clear_inode_flag static
Message-ID: <20180313205053.GI4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:36:00PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  fs/xfs/xfs_reflink.h | 2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cdbd342a5249..85d3379a81df 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1552,7 +1552,7 @@ xfs_reflink_inode_has_shared_extents(
>  }
>  
>  /* Clear the inode reflink flag if there are no shared extents. */
> -int
> +static int

Online inode repair/optimization will call this function (see
xfs_repair_inode in scrub/inode_repair.c in the online repair series),
so I'd prefer not to add static only to have to pull it out later.

(Granted, nobody's commented on any of online repair afaict...)

--D

>  xfs_reflink_clear_inode_flag(
>  	struct xfs_inode	*ip,
>  	struct xfs_trans	**tpp)
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 701487bab468..7d6d34a30200 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -49,8 +49,6 @@ extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
>  		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
>  extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
>  		struct xfs_inode *ip, bool *has_shared);
> -extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
> -		struct xfs_trans **tpp);
>  extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len);
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
