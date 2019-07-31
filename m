Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59178 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbfGaXZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 19:25:07 -0400
Date: Wed, 31 Jul 2019 16:24:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/9] iomap: Remove length and start fields from
 iomap_fiemap
Message-ID: <20190731232447.GX1561054@magnolia>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-7-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731141245.7230-7-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 04:12:42PM +0200, Carlos Maiolino wrote:
> fiemap_extent_info now embeds start and length parameters, users of
> iomap_fiemap() doesn't need to pass it individually anymore.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/gfs2/inode.c       | 4 +---
>  fs/iomap.c            | 4 +++-
>  fs/xfs/xfs_iops.c     | 8 ++------
>  include/linux/iomap.h | 2 +-
>  4 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 5e84d5963506..df31bd8ecf6f 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2006,8 +2006,6 @@ static int gfs2_getattr(const struct path *path, struct kstat *stat,
>  
>  static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
>  {
> -	u64 start = fieinfo->fi_start;
> -	u64 len = fieinfo->fi_len;
>  	struct gfs2_inode *ip = GFS2_I(inode);
>  	struct gfs2_holder gh;
>  	int ret;
> @@ -2018,7 +2016,7 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
>  	if (ret)
>  		goto out;
>  
> -	ret = iomap_fiemap(inode, fieinfo, start, len, &gfs2_iomap_ops);
> +	ret = iomap_fiemap(inode, fieinfo, &gfs2_iomap_ops);
>  
>  	gfs2_glock_dq_uninit(&gh);
>  
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 97cb9d486a7d..b1e88722e10b 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1184,9 +1184,11 @@ iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  }
>  
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
> -		loff_t start, loff_t len, const struct iomap_ops *ops)
> +		 const struct iomap_ops *ops)
>  {
>  	struct fiemap_ctx ctx;
> +	loff_t start = fi->fi_start;
> +	loff_t len = fi->fi_len;
>  	loff_t ret;
>  
>  	memset(&ctx, 0, sizeof(ctx));
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1f4354fa989b..b485190b7ecd 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1112,18 +1112,14 @@ xfs_vn_fiemap(
>  	struct inode		  *inode,
>  	struct fiemap_extent_info *fieinfo)
>  {
> -	u64	start = fieinfo->fi_start;
> -	u64	length = fieinfo->fi_len;
>  	int	error;
>  
>  	xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
>  	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
>  		fieinfo->fi_flags &= ~FIEMAP_FLAG_XATTR;
> -		error = iomap_fiemap(inode, fieinfo, start, length,
> -				&xfs_xattr_iomap_ops);
> +		error = iomap_fiemap(inode, fieinfo, &xfs_xattr_iomap_ops);
>  	} else {
> -		error = iomap_fiemap(inode, fieinfo, start, length,
> -				&xfs_iomap_ops);
> +		error = iomap_fiemap(inode, fieinfo, &xfs_iomap_ops);
>  	}
>  	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
>  
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0fefb5455bda..bc4c421ee822 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -145,7 +145,7 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
>  vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf,
>  			const struct iomap_ops *ops);
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> -		loff_t start, loff_t len, const struct iomap_ops *ops);
> +		const struct iomap_ops *ops);
>  loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
>  		const struct iomap_ops *ops);
>  loff_t iomap_seek_data(struct inode *inode, loff_t offset,
> -- 
> 2.20.1
> 
